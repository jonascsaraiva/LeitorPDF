import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocos/tema_aplicativo/bloc_tema_aplicativo.dart';
import '../../controladores/controlador_leitor_pdf.dart';
import '../../modelos/documento_pdf.dart';
import '../../temas/paleta_aplicativo.dart';
import '../configuracoes/pagina_configuracoes.dart';
import '../visualizador_pdf/pagina_visualizador_pdf.dart';
import 'widgets/cartao_documento_selecionado.dart';
import 'widgets/cartao_estado_vazio.dart';
import 'widgets/secao_cabecalho_inicio.dart';
import 'widgets/secao_documentos_recentes.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  late final ControladorLeitorPdf _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = ControladorLeitorPdf();
    _controlador.addListener(_escutarMudancas);
    _controlador.carregarDocumentosRecentes();
  }

  @override
  void dispose() {
    _controlador.removeListener(_escutarMudancas);
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _abrirDocumento(DocumentoPdf documento) async {
    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaginaVisualizadorPdf(documento: documento),
      ),
    );
  }

  Future<void> _selecionarEAbrirPdf() async {
    final DocumentoPdf? documento = await _controlador.selecionarPdf();
    if (documento == null || !mounted) {
      return;
    }

    await _abrirDocumento(documento);
  }

  Future<void> _reabrirDocumentoRecente(DocumentoPdf documento) async {
    await _controlador.selecionarDocumento(documento);
    if (!mounted) {
      return;
    }

    await _abrirDocumento(documento);
  }

  Future<void> _abrirConfiguracoes() async {
    if (!mounted) {
      return;
    }

    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const PaginaConfiguracoes()));
  }

  void _escutarMudancas() {
    final String? mensagemErro = _controlador.mensagemErro;

    if (mensagemErro == null || !mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagemErro)));

    _controlador.limparErro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controlador,
          builder: (context, child) {
            final DocumentoPdf? documentoSelecionado =
                _controlador.documentoSelecionado;
            final List<DocumentoPdf> documentosRecentes =
                _controlador.documentosRecentes;
            final EstadoTemaAplicativo estadoTema =
                context.watch<BlocTemaAplicativo>().state;
            final PaletaAplicativo paleta = estadoTema.configuracoes.paleta;

            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: SecaoCabecalhoInicio(
                      estaSelecionando: _controlador.estaSelecionando,
                      paleta: paleta,
                      aoPressionarAbrir: _selecionarEAbrirPdf,
                      aoPressionarConfiguracoes: _abrirConfiguracoes,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CartaoDocumentoSelecionado(
                      documento: documentoSelecionado,
                      aoPressionarLer: documentoSelecionado == null
                          ? null
                          : () => _abrirDocumento(documentoSelecionado),
                    ),
                  ),
                ),
                if (documentosRecentes.isEmpty && !_controlador.estaCarregando)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 32,
                      ),
                      child: CartaoEstadoVazio(),
                    ),
                  )
                else
                  SecaoDocumentosRecentes(
                    documentos: documentosRecentes,
                    estaCarregando: _controlador.estaCarregando,
                    aoTocarDocumento: _reabrirDocumentoRecente,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
