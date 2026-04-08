import 'package:flutter/material.dart';

import '../../../models/pdf_document_item.dart';
import 'recent_document_tile.dart';

class RecentDocumentsSection extends StatelessWidget {
  const RecentDocumentsSection({
    super.key,
    required this.documents,
    required this.isLoading,
    required this.onDocumentTap,
  });

  final List<PdfDocumentItem> documents;
  final bool isLoading;
  final ValueChanged<PdfDocumentItem> onDocumentTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      sliver: SliverMainAxisGroup(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Recentes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
          ),
          SliverList.separated(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final PdfDocumentItem document = documents[index];
              return RecentDocumentTile(
                document: document,
                onTap: () => onDocumentTap(document),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
        ],
      ),
    );
  }
}
