import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocos/biblioteca_pdf/bloc_biblioteca_pdf.dart';
import '../../localizacao/textos_aplicativo.dart';
import '../../modelos/documento_pdf.dart';

class PaginaDetalhesArquivo extends StatelessWidget {
  const PaginaDetalhesArquivo({
    super.key,
    required this.documento,
  });

  final DocumentoPdf documento;

  Widget _itemInformacao(BuildContext context, String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titulo,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final File arquivo = File(documento.caminho);
    final DocumentoPdf documentoAtual = context.select(
      (BlocBibliotecaPdf bloc) => bloc.state.documentos.firstWhere(
        (DocumentoPdf item) => item.caminho == documento.caminho,
        orElse: () => documento,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.textos.detalhesArquivo),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.read<BlocBibliotecaPdf>().add(
                    DocumentoFavoritoAlternado(documentoAtual),
                  );
            },
            icon: Icon(
              documentoAtual.estaFavorito
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _itemInformacao(context, context.textos.nome, documentoAtual.nome),
          const SizedBox(height: 12),
          _itemInformacao(context, context.textos.caminho, documentoAtual.caminho),
          const SizedBox(height: 12),
          _itemInformacao(
            context,
            context.textos.tamanho,
            context.textos.formatarTamanho(documentoAtual.tamanhoBytes),
          ),
          const SizedBox(height: 12),
          _itemInformacao(
            context,
            context.textos.dataImportacao,
            documentoAtual.dataImportacao.toLocal().toString(),
          ),
          const SizedBox(height: 12),
          _itemInformacao(
            context,
            context.textos.ultimoAcesso,
            documentoAtual.ultimoAcesso.toLocal().toString(),
          ),
          const SizedBox(height: 12),
          _itemInformacao(
            context,
            context.textos.arquivoExiste,
            arquivo.existsSync() ? context.textos.sim : context.textos.nao,
          ),
        ],
      ),
    );
  }
}
