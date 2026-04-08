import 'package:flutter/material.dart';

import '../../../models/pdf_document_item.dart';

class SelectedDocumentCard extends StatelessWidget {
  const SelectedDocumentCard({
    super.key,
    required this.document,
    required this.onReadPressed,
  });

  final PdfDocumentItem? document;
  final VoidCallback? onReadPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Arquivo selecionado',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            document?.name ?? 'Nenhum PDF selecionado ainda.',
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            document?.path ??
                'Quando voce escolher um arquivo, ele aparecera aqui para reabrir rapidamente.',
            style: textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onReadPressed,
            icon: const Icon(Icons.picture_as_pdf_rounded),
            label: const Text('Ler PDF'),
          ),
        ],
      ),
    );
  }
}
