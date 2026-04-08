import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocos/biblioteca_pdf/bloc_biblioteca_pdf.dart';
import '../../blocos/tema_aplicativo/bloc_tema_aplicativo.dart';
import '../../modelos/documento_pdf.dart';
import '../../temas/paleta_aplicativo.dart';
import '../detalhes_arquivo/pagina_detalhes_arquivo.dart';
import '../visualizador_pdf/pagina_visualizador_pdf.dart';
import 'widgets/cartao_documento_selecionado.dart';
import 'widgets/cartao_estado_vazio.dart';
import 'widgets/item_documento_recente.dart';
import 'widgets/secao_cabecalho_inicio.dart';

class PaginaInicial extends StatelessWidget {
  const PaginaInicial({super.key});

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

  Widget _secaoLista({
    required BuildContext context,
    required String titulo,
    required List<DocumentoPdf> documentos,
    required IconData iconeVazio,
    required String mensagemVazia,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          titulo,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 12),
        if (documentos.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: <Widget>[
                Icon(iconeVazio),
                const SizedBox(width: 12),
                Expanded(child: Text(mensagemVazia)),
              ],
            ),
          )
        else
          Column(
            children: documentos.map((DocumentoPdf documento) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ItemDocumentoRecente(
                  documento: documento,
                  aoTocar: () => _abrirDocumento(context, documento),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final EstadoTemaAplicativo estadoTema =
        context.watch<BlocTemaAplicativo>().state;
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
            ..showSnackBar(SnackBar(content: Text(estado.mensagemErro!)));
        }
        if (estado.documentoAbertoAgora != null) {
          await _abrirDocumento(context, estado.documentoAbertoAgora!);
        }
      },
      builder: (context, estado) {
        final DocumentoPdf? ultimoDocumento = estado.documentosRecentes.isNotEmpty
            ? estado.documentosRecentes.first
            : null;

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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CartaoDocumentoSelecionado(
                      documento: ultimoDocumento,
                      aoPressionarLer: ultimoDocumento == null
                          ? null
                          : () => _abrirDocumento(context, ultimoDocumento),
                      aoPressionarDetalhes: ultimoDocumento == null
                          ? null
                          : () => _abrirDetalhes(context, ultimoDocumento),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: estado.documentos.isEmpty && !estado.estaCarregando
                        ? const CartaoEstadoVazio()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _secaoLista(
                                context: context,
                                titulo: 'Favoritos',
                                documentos: estado.favoritos.take(5).toList(),
                                iconeVazio: Icons.star_outline_rounded,
                                mensagemVazia:
                                    'Voce ainda nao marcou nenhum PDF como favorito.',
                              ),
                              const SizedBox(height: 20),
                              _secaoLista(
                                context: context,
                                titulo: 'Recentes',
                                documentos: estado.documentosRecentes.take(5).toList(),
                                iconeVazio: Icons.history_rounded,
                                mensagemVazia:
                                    'Os PDFs que voce abrir ou importar vao aparecer aqui.',
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
