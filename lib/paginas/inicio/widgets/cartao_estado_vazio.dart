import 'package:flutter/material.dart';

import '../../../localizacao/textos_aplicativo.dart';

class CartaoEstadoVazio extends StatelessWidget {
  const CartaoEstadoVazio({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme temaTexto = Theme.of(context).textTheme;
    final ColorScheme esquemaCores = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: esquemaCores.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: esquemaCores.outlineVariant),
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.menu_book_rounded, size: 48, color: esquemaCores.primary),
          const SizedBox(height: 12),
          Text(
            context.textos.nenhumPdfAberto,
            style: temaTexto.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.textos.descricaoNenhumPdfAberto,
            style: temaTexto.bodyMedium?.copyWith(height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
