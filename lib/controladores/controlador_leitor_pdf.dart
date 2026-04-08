import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as caminhos;
import 'package:shared_preferences/shared_preferences.dart';

import '../modelos/documento_pdf.dart';

class ControladorLeitorPdf extends ChangeNotifier {
  static const String _chaveDocumentosRecentes = 'documentos_pdf_recentes';

  final List<DocumentoPdf> _documentosRecentes = <DocumentoPdf>[];

  bool _estaSelecionando = false;
  bool _estaCarregando = false;
  String? _mensagemErro;
  DocumentoPdf? _documentoSelecionado;

  bool get estaSelecionando => _estaSelecionando;
  bool get estaCarregando => _estaCarregando;
  String? get mensagemErro => _mensagemErro;
  DocumentoPdf? get documentoSelecionado => _documentoSelecionado;
  List<DocumentoPdf> get documentosRecentes =>
      List<DocumentoPdf>.unmodifiable(_documentosRecentes);

  Future<void> carregarDocumentosRecentes() async {
    _estaCarregando = true;
    notifyListeners();

    try {
      final SharedPreferences preferencias =
          await SharedPreferences.getInstance();
      final List<String> itensCodificados =
          preferencias.getStringList(_chaveDocumentosRecentes) ?? <String>[];

      _documentosRecentes
        ..clear()
        ..addAll(
          itensCodificados
              .map(
                (String item) => DocumentoPdf.fromMap(
                  jsonDecode(item) as Map<String, dynamic>,
                ),
              )
              .where((DocumentoPdf item) => item.caminho.isNotEmpty),
        );

      if (_documentosRecentes.isNotEmpty) {
        _documentoSelecionado ??= _documentosRecentes.first;
      }
    } catch (_) {
      _mensagemErro = 'Nao foi possivel carregar a lista de PDFs recentes.';
    } finally {
      _estaCarregando = false;
      notifyListeners();
    }
  }

  Future<DocumentoPdf?> selecionarPdf() async {
    _estaSelecionando = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final FilePickerResult? resultado = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const <String>['pdf'],
      );

      if (resultado == null || resultado.files.isEmpty) {
        return null;
      }

      final PlatformFile arquivo = resultado.files.single;
      final String? caminhoArquivo = arquivo.path;

      if (caminhoArquivo == null || caminhoArquivo.isEmpty) {
        _mensagemErro =
            'Nao foi possivel localizar o arquivo selecionado no dispositivo.';
        notifyListeners();
        return null;
      }

      final DocumentoPdf documento = DocumentoPdf(
        nome: arquivo.name.isNotEmpty
            ? arquivo.name
            : caminhos.basename(caminhoArquivo),
        caminho: caminhoArquivo,
      );

      _documentoSelecionado = documento;
      await _adicionarAosRecentes(documento);
      return documento;
    } catch (_) {
      _mensagemErro =
          'Ocorreu um erro ao abrir o seletor de arquivos. Tente novamente.';
      return null;
    } finally {
      _estaSelecionando = false;
      notifyListeners();
    }
  }

  Future<void> selecionarDocumento(DocumentoPdf documento) async {
    _documentoSelecionado = documento;
    await _adicionarAosRecentes(documento);
    notifyListeners();
  }

  void limparErro() {
    if (_mensagemErro == null) {
      return;
    }

    _mensagemErro = null;
    notifyListeners();
  }

  Future<void> _adicionarAosRecentes(DocumentoPdf documento) async {
    _documentosRecentes.removeWhere(
      (DocumentoPdf item) => item.caminho == documento.caminho,
    );
    _documentosRecentes.insert(0, documento);

    if (_documentosRecentes.length > 8) {
      _documentosRecentes.removeRange(8, _documentosRecentes.length);
    }

    final SharedPreferences preferencias = await SharedPreferences.getInstance();
    await preferencias.setStringList(
      _chaveDocumentosRecentes,
      _documentosRecentes
          .map((DocumentoPdf item) => jsonEncode(item.toMap()))
          .toList(),
    );
  }
}
