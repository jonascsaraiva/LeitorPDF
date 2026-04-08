import 'package:flutter/material.dart';

import '../../../modelos/documento_pdf.dart';
import 'item_documento_recente.dart';

class SecaoDocumentosRecentes extends StatelessWidget {
  const SecaoDocumentosRecentes({
    super.key,
    required this.documentos,
    required this.estaCarregando,
    required this.aoTocarDocumento,
  });

  final List<DocumentoPdf> documentos;
  final bool estaCarregando;
  final ValueChanged<DocumentoPdf> aoTocarDocumento;

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
                  if (estaCarregando)
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
            itemCount: documentos.length,
            itemBuilder: (context, index) {
              final DocumentoPdf documento = documentos[index];
              return ItemDocumentoRecente(
                documento: documento,
                aoTocar: () => aoTocarDocumento(documento),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
        ],
      ),
    );
  }
}
