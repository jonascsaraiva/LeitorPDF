import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocos/biblioteca_pdf/bloc_biblioteca_pdf.dart';
import '../../blocos/tema_aplicativo/bloc_tema_aplicativo.dart';
import '../../localizacao/textos_aplicativo.dart';
import '../../modelos/documento_pdf.dart';
import '../../temas/paleta_aplicativo.dart';
import '../detalhes_arquivo/pagina_detalhes_arquivo.dart';
import '../visualizador_pdf/pagina_visualizador_pdf.dart';
import 'widgets/cartao_estado_vazio.dart';
import 'widgets/item_documento_recente.dart';
import 'widgets/secao_cabecalho_inicio.dart';

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

  Future<void> _abrirDocumento(
    BuildContext context,
    DocumentoPdf documento,
  ) async {
    context.read<BlocBibliotecaPdf>().add(DocumentoAcessado(documento));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaginaVisualizadorPdf(documento: documento),
      ),
    );
  }

  Future<void> _abrirDetalhes(
    BuildContext context,
    DocumentoPdf documento,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaginaDetalhesArquivo(documento: documento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EstadoTemaAplicativo estadoTema = context
        .watch<BlocTemaAplicativo>()
        .state;
    final PaletaAplicativo paleta = estadoTema.configuracoes.paleta;

    return BlocConsumer<BlocBibliotecaPdf, EstadoBibliotecaPdf>(
      listenWhen: (anterior, atual) =>
          anterior.documentoAbertoAgora?.caminho !=
              atual.documentoAbertoAgora?.caminho &&
          atual.documentoAbertoAgora != null,
      listener: (context, estado) async {
        if (estado.mensagemErro != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  context.textos.traduzirMensagemErroBiblioteca(
                    estado.mensagemErro!,
                  ),
                ),
              ),
            );
        }
        if (estado.documentoAbertoAgora != null) {
          await _abrirDocumento(context, estado.documentoAbertoAgora!);
        }
      },
      builder: (context, estado) {
        final List<DocumentoPdf> recentes = estado.documentosRecentes
            .take(5)
            .toList();

        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: SecaoCabecalhoInicio(
                      estaSelecionando: estado.estaImportando,
                      paleta: paleta,
                      aoPressionarAbrir: () {
                        context.read<BlocBibliotecaPdf>().add(
                          const ImportacaoPdfSolicitada(),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              Icons.file_open_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  context.textos.importarArquivo,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.textos.descricaoImportarArquivo,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: estado.estaImportando
                                ? null
                                : () {
                                    context.read<BlocBibliotecaPdf>().add(
                                      const ImportacaoPdfSolicitada(),
                                    );
                                  },
                            child: Text(context.textos.abrir),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: estado.documentos.isEmpty && !estado.estaCarregando
                        ? const CartaoEstadoVazio()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                context.textos.recentes,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 12),
                              if (recentes.isEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    context.textos.descricaoRecentesVazio,
                                  ),
                                )
                              else
                                Column(
                                  children: recentes.map((
                                    DocumentoPdf documento,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: ItemDocumentoRecente(
                                        documento: documento,
                                        aoTocar: () =>
                                            _abrirDocumento(context, documento),
                                        aoPressionarDetalhes: () =>
                                            _abrirDetalhes(context, documento),
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
