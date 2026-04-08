import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../blocos/biblioteca_pdf/bloc_biblioteca_pdf.dart';
import '../../blocos/tema_aplicativo/bloc_tema_aplicativo.dart';
import '../../localizacao/textos_aplicativo.dart';
import '../../modelos/documento_pdf.dart';
import '../detalhes_arquivo/pagina_detalhes_arquivo.dart';

class PaginaVisualizadorPdf extends StatefulWidget {
  const PaginaVisualizadorPdf({super.key, required this.documento});

  final DocumentoPdf documento;

  @override
  State<PaginaVisualizadorPdf> createState() => _PaginaVisualizadorPdfState();
}

class _PaginaVisualizadorPdfState extends State<PaginaVisualizadorPdf> {
  final PdfViewerController _controladorPdf = PdfViewerController();
  final TextEditingController _controladorPagina = TextEditingController();
  final FocusNode _noFocoTeclado = FocusNode();

  late PdfScrollDirection _direcaoRolagem;
  int _paginaAtual = 1;
  int _totalPaginas = 0;
  bool _mostrarControles = true;

  bool get _estaEmModoApresentacaoHorizontal =>
      _direcaoRolagem == PdfScrollDirection.horizontal;

  @override
  void initState() {
    super.initState();
    _direcaoRolagem = context
        .read<BlocTemaAplicativo>()
        .state
        .configuracoes
        .direcaoRolagemPadrao;
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controladorPdf.dispose();
    _controladorPagina.dispose();
    _noFocoTeclado.dispose();
    super.dispose();
  }

  void _alternarModoFoco() {
    setState(() {
      _mostrarControles = !_mostrarControles;
    });

    SystemChrome.setEnabledSystemUIMode(
      _mostrarControles
          ? SystemUiMode.edgeToEdge
          : SystemUiMode.immersiveSticky,
    );

    if (!_mostrarControles) {
      FocusScope.of(context).unfocus();
    } else {
      _noFocoTeclado.requestFocus();
    }
  }

  void _atualizarIndicadoresPagina(int paginaAtual, int totalPaginas) {
    setState(() {
      _paginaAtual = paginaAtual;
      _totalPaginas = totalPaginas;
      _controladorPagina.text = paginaAtual.toString();
    });
  }

  void _alterarDirecaoRolagem(PdfScrollDirection direcao) {
    if (_direcaoRolagem == direcao) {
      return;
    }

    final int paginaAtual = _paginaAtual;
    setState(() {
      _direcaoRolagem = direcao;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controladorPdf.jumpToPage(paginaAtual);
      _controladorPdf.zoomLevel = 1;
      if (mounted) {
        _noFocoTeclado.requestFocus();
      }
    });
  }

  void _irParaPaginaAnterior() {
    if (_paginaAtual <= 1) {
      return;
    }

    _controladorPdf.previousPage();
  }

  void _irParaProximaPagina() {
    if (_totalPaginas == 0 || _paginaAtual >= _totalPaginas) {
      return;
    }

    _controladorPdf.nextPage();
  }

  bool _pularParaPagina() {
    final int? paginaDestino = int.tryParse(_controladorPagina.text);

    if (paginaDestino == null ||
        paginaDestino < 1 ||
        paginaDestino > _totalPaginas) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _totalPaginas > 0
                  ? context.textos.paginaInvalida(_totalPaginas)
                  : context.textos.documentoCarregando,
            ),
          ),
        );
      return false;
    }

    _controladorPdf.jumpToPage(paginaDestino);
    FocusScope.of(context).unfocus();
    _noFocoTeclado.requestFocus();
    return true;
  }

  Future<void> _abrirDetalhes(DocumentoPdf documentoAtual) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaginaDetalhesArquivo(documento: documentoAtual),
      ),
    );
  }

  Future<void> _mostrarModalIrParaPagina() async {
    _controladorPagina.text = _paginaAtual.toString();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) {
        void enviarPagina() {
          final bool conseguiuPular = _pularParaPagina();
          if (conseguiuPular) {
            Navigator.of(context).pop();
          }
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.textos.irParaPagina,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controladorPagina,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.textos.irParaPagina,
                  hintText: _totalPaginas > 0
                      ? context.textos.paginaFaixa(_totalPaginas)
                      : '...',
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => enviarPagina(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: enviarPagina,
                  child: Text(context.textos.ir),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  KeyEventResult _aoReceberTecla(FocusNode node, KeyEvent evento) {
    if (evento is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final LogicalKeyboardKey tecla = evento.logicalKey;

    if (tecla == LogicalKeyboardKey.arrowRight ||
        tecla == LogicalKeyboardKey.arrowDown ||
        tecla == LogicalKeyboardKey.pageDown ||
        tecla == LogicalKeyboardKey.space) {
      _irParaProximaPagina();
      return KeyEventResult.handled;
    }

    if (tecla == LogicalKeyboardKey.arrowLeft ||
        tecla == LogicalKeyboardKey.arrowUp ||
        tecla == LogicalKeyboardKey.pageUp ||
        tecla == LogicalKeyboardKey.backspace) {
      _irParaPaginaAnterior();
      return KeyEventResult.handled;
    }

    if (tecla == LogicalKeyboardKey.home && _totalPaginas > 0) {
      _controladorPdf.jumpToPage(1);
      return KeyEventResult.handled;
    }

    if (tecla == LogicalKeyboardKey.end && _totalPaginas > 0) {
      _controladorPdf.jumpToPage(_totalPaginas);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Widget _botaoLateralNavegacao({
    required bool voltar,
    required VoidCallback? aoPressionar,
  }) {
    return Material(
      color: Colors.black.withValues(alpha: 0.28),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: aoPressionar,
        iconSize: 28,
        color: Colors.white,
        icon: Icon(
          voltar ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
        ),
      ),
    );
  }

  Widget _construirBarraSuperiorApresentacao(DocumentoPdf documentoAtual) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Row(
          children: <Widget>[
            Material(
              color: Colors.black.withValues(alpha: 0.34),
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.white,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      documentoAtual.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _totalPaginas == 0
                          ? context.textos.telaVisualizadorCarregando
                          : context.textos.paginaDe(
                              _paginaAtual,
                              _totalPaginas,
                            ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Material(
              color: Colors.black.withValues(alpha: 0.34),
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () {
                  context.read<BlocBibliotecaPdf>().add(
                    DocumentoFavoritoAlternado(documentoAtual),
                  );
                },
                color: Colors.white,
                icon: Icon(
                  documentoAtual.estaFavorito
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.black.withValues(alpha: 0.34),
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => _abrirDetalhes(documentoAtual),
                color: Colors.white,
                icon: const Icon(Icons.info_outline_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirBarraInferiorApresentacao() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.34),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: _paginaAtual > 1 ? _irParaPaginaAnterior : null,
                  color: Colors.white,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                const SizedBox(width: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 108),
                  child: Text(
                    _totalPaginas == 0
                        ? context.textos.telaVisualizadorCarregando
                        : context.textos.paginaDe(_paginaAtual, _totalPaginas),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: _totalPaginas > 0
                      ? _mostrarModalIrParaPagina
                      : null,
                  color: Colors.white,
                  icon: const Icon(Icons.pin_invoke_rounded),
                ),
                IconButton(
                  onPressed: () => _alterarDirecaoRolagem(
                    _estaEmModoApresentacaoHorizontal
                        ? PdfScrollDirection.vertical
                        : PdfScrollDirection.horizontal,
                  ),
                  color: Colors.white,
                  icon: Icon(
                    _estaEmModoApresentacaoHorizontal
                        ? Icons.swap_vert_rounded
                        : Icons.swap_horiz_rounded,
                  ),
                ),
                IconButton(
                  onPressed: _paginaAtual < _totalPaginas
                      ? _irParaProximaPagina
                      : null,
                  color: Colors.white,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirVisualizadorPdf(DocumentoPdf documentoAtual) {
    return SfPdfViewer.file(
      File(documentoAtual.caminho),
      key: ValueKey<String>(
        '${documentoAtual.caminho}_${_direcaoRolagem.name}',
      ),
      controller: _controladorPdf,
      scrollDirection: _estaEmModoApresentacaoHorizontal
          ? PdfScrollDirection.horizontal
          : _direcaoRolagem,
      pageLayoutMode: _estaEmModoApresentacaoHorizontal
          ? PdfPageLayoutMode.single
          : PdfPageLayoutMode.continuous,
      pageSpacing: _estaEmModoApresentacaoHorizontal ? 0 : 4,
      canShowPaginationDialog: !_estaEmModoApresentacaoHorizontal,
      canShowScrollHead: !_estaEmModoApresentacaoHorizontal,
      canShowScrollStatus: !_estaEmModoApresentacaoHorizontal,
      enableDoubleTapZooming: true,
      onTap: (_) => _alternarModoFoco(),
      onDocumentLoaded: (PdfDocumentLoadedDetails detalhes) {
        _atualizarIndicadoresPagina(
          _paginaAtual.clamp(1, detalhes.document.pages.count),
          detalhes.document.pages.count,
        );
        if (_paginaAtual > 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _controladorPdf.jumpToPage(_paginaAtual);
          });
        }
      },
      onPageChanged: (PdfPageChangedDetails detalhes) {
        _atualizarIndicadoresPagina(detalhes.newPageNumber, _totalPaginas);
      },
    );
  }

  Widget _construirModoApresentacao(DocumentoPdf documentoAtual) {
    return ColoredBox(
      color: Colors.black,
      child: Focus(
        autofocus: true,
        focusNode: _noFocoTeclado,
        onKeyEvent: _aoReceberTecla,
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: _construirVisualizadorPdf(documentoAtual)),
            if (_mostrarControles)
              Positioned(
                left: 12,
                top: 0,
                bottom: 0,
                child: SafeArea(
                  child: Center(
                    child: _botaoLateralNavegacao(
                      voltar: true,
                      aoPressionar: _paginaAtual > 1
                          ? _irParaPaginaAnterior
                          : null,
                    ),
                  ),
                ),
              ),
            if (_mostrarControles)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: SafeArea(
                  child: Center(
                    child: _botaoLateralNavegacao(
                      voltar: false,
                      aoPressionar: _paginaAtual < _totalPaginas
                          ? _irParaProximaPagina
                          : null,
                    ),
                  ),
                ),
              ),
            if (_mostrarControles)
              _construirBarraSuperiorApresentacao(documentoAtual),
            if (_mostrarControles) _construirBarraInferiorApresentacao(),
          ],
        ),
      ),
    );
  }

  Widget _construirModoContinuo(
    DocumentoPdf documentoAtual,
    ColorScheme esquemaCores,
  ) {
    final bool estaEmPaisagem =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bool temaEscuro = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: <Widget>[
        if (_mostrarControles)
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              estaEmPaisagem ? 8 : 12,
              16,
              estaEmPaisagem ? 8 : 12,
            ),
            color: esquemaCores.surfaceContainerHighest,
            child: estaEmPaisagem
                ? Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: _irParaPaginaAnterior,
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controladorPagina,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: context.textos.irParaPagina,
                            hintText: _totalPaginas > 0
                                ? context.textos.paginaFaixa(_totalPaginas)
                                : '...',
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _pularParaPagina(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _pularParaPagina,
                        icon: const Icon(Icons.arrow_forward_rounded),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<PdfScrollDirection>(
                        onSelected: _alterarDirecaoRolagem,
                        itemBuilder: (context) =>
                            <PopupMenuEntry<PdfScrollDirection>>[
                              PopupMenuItem<PdfScrollDirection>(
                                value: PdfScrollDirection.vertical,
                                child: Text(context.textos.vertical),
                              ),
                              PopupMenuItem<PdfScrollDirection>(
                                value: PdfScrollDirection.horizontal,
                                child: Text(context.textos.horizontal),
                              ),
                            ],
                        icon: const Icon(Icons.swap_vert_rounded),
                      ),
                      IconButton(
                        onPressed: _irParaProximaPagina,
                        icon: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _controladorPagina,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: context.textos.irParaPagina,
                                hintText: _totalPaginas > 0
                                    ? context.textos.paginaFaixa(_totalPaginas)
                                    : '...',
                                isDense: true,
                                border: const OutlineInputBorder(),
                              ),
                              onSubmitted: (_) => _pularParaPagina(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _pularParaPagina,
                            child: Text(context.textos.ir),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SegmentedButton<PdfScrollDirection>(
                              segments: <ButtonSegment<PdfScrollDirection>>[
                                ButtonSegment<PdfScrollDirection>(
                                  value: PdfScrollDirection.vertical,
                                  label: Text(context.textos.vertical),
                                  icon: const Icon(Icons.swap_vert_rounded),
                                ),
                                ButtonSegment<PdfScrollDirection>(
                                  value: PdfScrollDirection.horizontal,
                                  label: Text(context.textos.horizontal),
                                  icon: const Icon(Icons.swap_horiz_rounded),
                                ),
                              ],
                              selected: <PdfScrollDirection>{_direcaoRolagem},
                              onSelectionChanged:
                                  (Set<PdfScrollDirection> selecao) {
                                    _alterarDirecaoRolagem(selecao.first);
                                  },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: _irParaPaginaAnterior,
                              icon: const Icon(Icons.chevron_left_rounded),
                              label: Text(context.textos.anterior),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.tonalIcon(
                              onPressed: _irParaProximaPagina,
                              icon: const Icon(Icons.chevron_right_rounded),
                              label: Text(context.textos.proxima),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.textos.textoLeitorCompacto(
                            vertical: true,
                            temaEscuro: temaEscuro,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
          ),
        Expanded(child: _construirVisualizadorPdf(documentoAtual)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme esquemaCores = Theme.of(context).colorScheme;
    final DocumentoPdf documentoAtual = context.select(
      (BlocBibliotecaPdf bloc) => bloc.state.documentos.firstWhere(
        (DocumentoPdf item) => item.caminho == widget.documento.caminho,
        orElse: () => widget.documento,
      ),
    );

    return Scaffold(
      backgroundColor: _estaEmModoApresentacaoHorizontal
          ? Colors.black
          : esquemaCores.surface,
      appBar: _estaEmModoApresentacaoHorizontal || !_mostrarControles
          ? null
          : AppBar(
              titleSpacing: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    documentoAtual.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _totalPaginas == 0
                        ? context.textos.telaVisualizadorCarregando
                        : context.textos.paginaDe(_paginaAtual, _totalPaginas),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
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
                IconButton(
                  onPressed: () => _abrirDetalhes(documentoAtual),
                  icon: const Icon(Icons.info_outline_rounded),
                ),
              ],
            ),
      body: _estaEmModoApresentacaoHorizontal
          ? _construirModoApresentacao(documentoAtual)
          : _construirModoContinuo(documentoAtual, esquemaCores),
    );
  }
}
