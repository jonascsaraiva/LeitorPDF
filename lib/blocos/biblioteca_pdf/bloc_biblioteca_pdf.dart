import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as caminhos;
import 'package:shared_preferences/shared_preferences.dart';

import '../../modelos/documento_pdf.dart';

part 'evento_biblioteca_pdf.dart';
part 'estado_biblioteca_pdf.dart';

class BlocBibliotecaPdf extends Bloc<EventoBibliotecaPdf, EstadoBibliotecaPdf> {
  BlocBibliotecaPdf() : super(const EstadoBibliotecaPdf()) {
    on<BibliotecaPdfIniciada>(_aoIniciar);
    on<ImportacaoPdfSolicitada>(_aoSolicitarImportacao);
    on<DocumentoFavoritoAlternado>(_aoAlternarFavorito);
    on<DocumentoAcessado>(_aoRegistrarAcesso);
  }

  static const String _chaveDocumentos = 'biblioteca_documentos_pdf';

  Future<void> _aoIniciar(
    BibliotecaPdfIniciada evento,
    Emitter<EstadoBibliotecaPdf> emitir,
  ) async {
    emitir(state.copyWith(estaCarregando: true, limparMensagemErro: true));
    try {
      final SharedPreferences preferencias = await SharedPreferences.getInstance();
      final List<String> itens = preferencias.getStringList(_chaveDocumentos) ?? <String>[];
      final List<DocumentoPdf> documentos = itens
          .map((String item) => DocumentoPdf.fromMap(jsonDecode(item) as Map<String, dynamic>))
          .where((DocumentoPdf documento) => documento.caminho.isNotEmpty)
          .toList();
      documentos.sort(
        (DocumentoPdf a, DocumentoPdf b) => b.ultimoAcesso.compareTo(a.ultimoAcesso),
      );
      emitir(
        state.copyWith(
          estaCarregando: false,
          documentos: documentos,
          limparMensagemErro: true,
        ),
      );
    } catch (_) {
      emitir(
        state.copyWith(
          estaCarregando: false,
          mensagemErro: 'Nao foi possivel carregar a biblioteca de PDFs.',
        ),
      );
    }
  }

  Future<void> _aoSolicitarImportacao(
    ImportacaoPdfSolicitada evento,
    Emitter<EstadoBibliotecaPdf> emitir,
  ) async {
    emitir(state.copyWith(estaImportando: true, limparMensagemErro: true));
    try {
      final FilePickerResult? resultado = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const <String>['pdf'],
      );

      if (resultado == null || resultado.files.isEmpty) {
        emitir(state.copyWith(estaImportando: false));
        return;
      }

      final PlatformFile arquivo = resultado.files.single;
      final String? caminhoArquivo = arquivo.path;
      if (caminhoArquivo == null || caminhoArquivo.isEmpty) {
        emitir(
          state.copyWith(
            estaImportando: false,
            mensagemErro: 'Nao foi possivel localizar o arquivo selecionado.',
          ),
        );
        return;
      }

      final File arquivoFisico = File(caminhoArquivo);
      final FileStat estatisticas = await arquivoFisico.stat();
      final DateTime agora = DateTime.now();

      final DocumentoPdf documento = DocumentoPdf(
        nome: arquivo.name.isNotEmpty ? arquivo.name : caminhos.basename(caminhoArquivo),
        caminho: caminhoArquivo,
        tamanhoBytes: estatisticas.size,
        dataImportacaoIso: agora.toIso8601String(),
        ultimoAcessoIso: agora.toIso8601String(),
      );

      final List<DocumentoPdf> documentosAtualizados = <DocumentoPdf>[
        documento,
        ...state.documentos.where((DocumentoPdf item) => item.caminho != documento.caminho),
      ];

      await _persistir(documentosAtualizados);
      emitir(
        state.copyWith(
          estaImportando: false,
          documentos: documentosAtualizados,
          documentoAbertoAgora: documento,
          limparMensagemErro: true,
        ),
      );
    } catch (_) {
      emitir(
        state.copyWith(
          estaImportando: false,
          mensagemErro: 'Ocorreu um erro ao importar o PDF.',
        ),
      );
    }
  }

  Future<void> _aoAlternarFavorito(
    DocumentoFavoritoAlternado evento,
    Emitter<EstadoBibliotecaPdf> emitir,
  ) async {
    final List<DocumentoPdf> documentosAtualizados = state.documentos.map((DocumentoPdf documento) {
      if (documento.caminho != evento.documento.caminho) {
        return documento;
      }
      return documento.copyWith(estaFavorito: !documento.estaFavorito);
    }).toList();

    await _persistir(documentosAtualizados);
    emitir(state.copyWith(documentos: documentosAtualizados, limparMensagemErro: true));
  }

  Future<void> _aoRegistrarAcesso(
    DocumentoAcessado evento,
    Emitter<EstadoBibliotecaPdf> emitir,
  ) async {
    final DateTime agora = DateTime.now();
    final List<DocumentoPdf> documentosAtualizados = state.documentos.map((DocumentoPdf documento) {
      if (documento.caminho != evento.documento.caminho) {
        return documento;
      }
      return documento.copyWith(ultimoAcessoIso: agora.toIso8601String());
    }).toList()
      ..sort((DocumentoPdf a, DocumentoPdf b) => b.ultimoAcesso.compareTo(a.ultimoAcesso));

    await _persistir(documentosAtualizados);
    emitir(
      state.copyWith(
        documentos: documentosAtualizados,
        documentoAbertoAgora: documentosAtualizados.firstWhere(
          (DocumentoPdf documento) => documento.caminho == evento.documento.caminho,
          orElse: () => evento.documento.copyWith(ultimoAcessoIso: agora.toIso8601String()),
        ),
        limparMensagemErro: true,
      ),
    );
  }

  Future<void> _persistir(List<DocumentoPdf> documentos) async {
    final SharedPreferences preferencias = await SharedPreferences.getInstance();
    await preferencias.setStringList(
      _chaveDocumentos,
      documentos.map((DocumentoPdf documento) => jsonEncode(documento.toMap())).toList(),
    );
  }
}
