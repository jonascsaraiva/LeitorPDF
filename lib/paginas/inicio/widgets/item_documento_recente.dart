import 'package:flutter/material.dart';

import '../../../modelos/documento_pdf.dart';

class ItemDocumentoRecente extends StatelessWidget {
  const ItemDocumentoRecente({
    super.key,
    required this.documento,
    required this.aoTocar,
  });

  final DocumentoPdf documento;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final ColorScheme esquemaCores = Theme.of(context).colorScheme;

    return Material(
      color: esquemaCores.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: esquemaCores.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: esquemaCores.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      documento.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      documento.caminho,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
