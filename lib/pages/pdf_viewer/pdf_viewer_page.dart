import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../models/pdf_document_item.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key, required this.document});

  final PdfDocumentItem document;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final TextEditingController _pageController = TextEditingController();

  PdfScrollDirection _scrollDirection = PdfScrollDirection.vertical;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updatePageIndicators(int currentPage, int totalPages) {
    setState(() {
      _currentPage = currentPage;
      _totalPages = totalPages;
      _pageController.text = currentPage.toString();
    });
  }

  void _changeScrollDirection(PdfScrollDirection direction) {
    if (_scrollDirection == direction) {
      return;
    }

    setState(() {
      _scrollDirection = direction;
    });
  }

  void _goToPreviousPage() {
    if (_currentPage <= 1) {
      return;
    }

    _pdfViewerController.previousPage();
  }

  void _goToNextPage() {
    if (_totalPages == 0 || _currentPage >= _totalPages) {
      return;
    }

    _pdfViewerController.nextPage();
  }

  void _jumpToPage() {
    final int? targetPage = int.tryParse(_pageController.text);

    if (targetPage == null || targetPage < 1 || targetPage > _totalPages) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _totalPages > 0
                  ? 'Digite uma pagina entre 1 e $_totalPages.'
                  : 'O documento ainda esta sendo carregado.',
            ),
          ),
        );
      return;
    }

    _pdfViewerController.jumpToPage(targetPage);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.document.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _totalPages == 0
                  ? 'Carregando documento...'
                  : 'Pagina $_currentPage de $_totalPages',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: colorScheme.surfaceContainerHighest,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _pageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Ir para pagina',
                          hintText: _totalPages > 0
                              ? '1 - $_totalPages'
                              : '...',
                          isDense: true,
                          border: const OutlineInputBorder(),
                        ),
                        onSubmitted: (value) => _jumpToPage(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _jumpToPage,
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
                        selected: <PdfScrollDirection>{_scrollDirection},
                        onSelectionChanged:
                            (Set<PdfScrollDirection> selection) {
                              _changeScrollDirection(selection.first);
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
                        onPressed: _goToPreviousPage,
                        icon: const Icon(Icons.chevron_left_rounded),
                        label: const Text('Anterior'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: _goToNextPage,
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
                    'Zoom por gesto ativo. Role no sentido ${_scrollDirection == PdfScrollDirection.vertical ? 'vertical' : 'horizontal'}. Tema atual: ${isDarkMode ? 'escuro' : 'claro'}.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SfPdfViewer.file(
              File(widget.document.path),
              controller: _pdfViewerController,
              scrollDirection: _scrollDirection,
              canShowPaginationDialog: true,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              enableDoubleTapZooming: true,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                _updatePageIndicators(1, details.document.pages.count);
              },
              onPageChanged: (PdfPageChangedDetails details) {
                _updatePageIndicators(details.newPageNumber, _totalPages);
              },
            ),
          ),
        ],
      ),
    );
  }
}
