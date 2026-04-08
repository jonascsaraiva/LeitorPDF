import 'package:flutter/material.dart';

import '../../../modelos/documento_pdf.dart';

class CartaoDocumentoSelecionado extends StatelessWidget {
  const CartaoDocumentoSelecionado({
    super.key,
    required this.documento,
    required this.aoPressionarLer,
    required this.aoPressionarDetalhes,
  });

  final DocumentoPdf? documento;
  final VoidCallback? aoPressionarLer;
  final VoidCallback? aoPressionarDetalhes;

  @override
  Widget build(BuildContext context) {
    final TextTheme temaTexto = Theme.of(context).textTheme;
    final ColorScheme esquemaCores = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: esquemaCores.surface,
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
            style: temaTexto.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            documento?.nome ?? 'Nenhum PDF selecionado ainda.',
            style: temaTexto.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            documento?.caminho ??
                'Quando voce escolher um arquivo, ele aparecera aqui para reabrir rapidamente.',
            style: temaTexto.bodyMedium?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: FilledButton.icon(
                  onPressed: aoPressionarLer,
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: const Text('Ler PDF'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: aoPressionarDetalhes,
                  icon: const Icon(Icons.info_outline_rounded),
                  label: const Text('Detalhes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
