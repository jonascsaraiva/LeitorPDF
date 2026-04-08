import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../blocos/biblioteca_pdf/bloc_biblioteca_pdf.dart';
import '../../blocos/tema_aplicativo/bloc_tema_aplicativo.dart';
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

  late PdfScrollDirection _direcaoRolagem;
  int _paginaAtual = 1;
  int _totalPaginas = 0;

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
    _controladorPdf.dispose();
    _controladorPagina.dispose();
    super.dispose();
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

    setState(() {
      _direcaoRolagem = direcao;
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

  void _pularParaPagina() {
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
                  ? 'Digite uma pagina entre 1 e $_totalPaginas.'
                  : 'O documento ainda esta sendo carregado.',
            ),
          ),
        );
      return;
    }

    _controladorPdf.jumpToPage(paginaDestino);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool temaEscuro = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme esquemaCores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.documento.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _totalPaginas == 0
                  ? 'Carregando documento...'
                  : 'Pagina $_paginaAtual de $_totalPaginas',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.read<BlocBibliotecaPdf>().add(
                    DocumentoFavoritoAlternado(widget.documento),
                  );
            },
            icon: Icon(
              widget.documento.estaFavorito
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PaginaDetalhesArquivo(documento: widget.documento),
                ),
              );
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: esquemaCores.surfaceContainerHighest,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _controladorPagina,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Ir para pagina',
                          hintText: _totalPaginas > 0
                              ? '1 - $_totalPaginas'
                              : '...',
                          isDense: true,
                          border: const OutlineInputBorder(),
                        ),
                        onSubmitted: (valor) => _pularParaPagina(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _pularParaPagina,
                      child: const Text('Ir'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SegmentedButton<PdfScrollDirection>(
                        segments: const <ButtonSegment<PdfScrollDirection>>[
                          ButtonSegment<PdfScrollDirection>(
                            value: PdfScrollDirection.vertical,
                            label: Text('Vertical'),
                            icon: Icon(Icons.swap_vert_rounded),
                          ),
                          ButtonSegment<PdfScrollDirection>(
                            value: PdfScrollDirection.horizontal,
                            label: Text('Horizontal'),
                            icon: Icon(Icons.swap_horiz_rounded),
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
                        label: const Text('Anterior'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: _irParaProximaPagina,
                        icon: const Icon(Icons.chevron_right_rounded),
                        label: const Text('Proxima'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Zoom por gesto ativo. Role no sentido ${_direcaoRolagem == PdfScrollDirection.vertical ? 'vertical' : 'horizontal'}. Tema atual: ${temaEscuro ? 'escuro' : 'claro'}.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SfPdfViewer.file(
              File(widget.documento.caminho),
              controller: _controladorPdf,
              scrollDirection: _direcaoRolagem,
              canShowPaginationDialog: true,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              enableDoubleTapZooming: true,
              onDocumentLoaded: (PdfDocumentLoadedDetails detalhes) {
                _atualizarIndicadoresPagina(1, detalhes.document.pages.count);
              },
              onPageChanged: (PdfPageChangedDetails detalhes) {
                _atualizarIndicadoresPagina(
                  detalhes.newPageNumber,
                  _totalPaginas,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
