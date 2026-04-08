import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocos/biblioteca_pdf/bloc_biblioteca_pdf.dart';
import '../../localizacao/textos_aplicativo.dart';
import '../../modelos/documento_pdf.dart';
import '../detalhes_arquivo/pagina_detalhes_arquivo.dart';
import '../visualizador_pdf/pagina_visualizador_pdf.dart';

class PaginaBiblioteca extends StatelessWidget {
  const PaginaBiblioteca({super.key});

  Future<void> _abrirDocumento(BuildContext context, DocumentoPdf documento) async {
    context.read<BlocBibliotecaPdf>().add(DocumentoAcessado(documento));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaginaVisualizadorPdf(documento: documento),
      ),
    );
  }

  Future<void> _abrirDetalhes(BuildContext context, DocumentoPdf documento) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaginaDetalhesArquivo(documento: documento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocBibliotecaPdf, EstadoBibliotecaPdf>(
      builder: (context, estado) {
        final List<DocumentoPdf> documentos = estado.documentos;

        return Scaffold(
          appBar: AppBar(
            title: Text(context.textos.historico),
            actions: <Widget>[
              IconButton(
                onPressed: estado.estaImportando
                    ? null
                    : () {
                        context.read<BlocBibliotecaPdf>().add(
                              const ImportacaoPdfSolicitada(),
                            );
                      },
                icon: const Icon(Icons.file_upload_rounded),
                tooltip: context.textos.importarPdf,
              ),
            ],
          ),
          body: documentos.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      context.textos.bibliotecaVazia,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: documentos.length,
                  separatorBuilder: (contexto, indice) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final DocumentoPdf documento = documentos[index];
                    return ListTile(
                      tileColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      leading: const CircleAvatar(
                        child: Icon(Icons.picture_as_pdf_rounded),
                      ),
                      title: Text(
                        documento.nome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        documento.caminho,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              context.read<BlocBibliotecaPdf>().add(
                                    DocumentoFavoritoAlternado(documento),
                                  );
                            },
                            icon: Icon(
                              documento.estaFavorito
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _abrirDetalhes(context, documento),
                            icon: const Icon(Icons.info_outline_rounded),
                            tooltip: context.textos.verDetalhes,
                          ),
                        ],
                      ),
                      onTap: () => _abrirDocumento(context, documento),
                    );
                  },
                ),
        );
      },
    );
  }
}
