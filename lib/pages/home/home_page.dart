import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/app_theme/app_theme_bloc.dart';
import '../../controller/pdf_reader_controller.dart';
import '../../models/pdf_document_item.dart';
import '../../theme/app_palette.dart';
import '../pdf_viewer/pdf_viewer_page.dart';
import '../settings/settings_page.dart';
import 'widgets/empty_state_card.dart';
import 'widgets/home_header_section.dart';
import 'widgets/recent_documents_section.dart';
import 'widgets/selected_document_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PdfReaderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfReaderController();
    _controller.addListener(_handleControllerChanges);
    _controller.loadRecentDocuments();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanges);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openDocument(PdfDocumentItem document) async {
    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PdfViewerPage(document: document),
      ),
    );
  }

  Future<void> _pickAndOpenPdf() async {
    final PdfDocumentItem? document = await _controller.pickPdf();
    if (document == null || !mounted) {
      return;
    }

    await _openDocument(document);
  }

  Future<void> _reopenRecentDocument(PdfDocumentItem document) async {
    await _controller.selectDocument(document);
    if (!mounted) {
      return;
    }

    await _openDocument(document);
  }

  Future<void> _openSettings() async {
    if (!mounted) {
      return;
    }

    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SettingsPage()));
  }

  void _handleControllerChanges() {
    final String? errorMessage = _controller.errorMessage;

    if (errorMessage == null || !mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(errorMessage)));

    _controller.clearError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final PdfDocumentItem? selected = _controller.selectedDocument;
            final List<PdfDocumentItem> recentDocuments =
                _controller.recentDocuments;
            final AppThemeState themeState = context
                .watch<AppThemeBloc>()
                .state;
            final AppPalette palette = themeState.settings.palette;

            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: HomeHeaderSection(
                      isPicking: _controller.isPicking,
                      palette: palette,
                      onOpenPressed: _pickAndOpenPdf,
                      onSettingsPressed: _openSettings,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SelectedDocumentCard(
                      document: selected,
                      onReadPressed: selected == null
                          ? null
                          : () => _openDocument(selected),
                    ),
                  ),
                ),
                if (recentDocuments.isEmpty && !_controller.isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 32,
                      ),
                      child: EmptyStateCard(),
                    ),
                  )
                else
                  RecentDocumentsSection(
                    documents: recentDocuments,
                    isLoading: _controller.isLoading,
                    onDocumentTap: _reopenRecentDocument,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
