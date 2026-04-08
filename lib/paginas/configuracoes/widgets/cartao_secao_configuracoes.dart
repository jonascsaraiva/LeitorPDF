import 'package:flutter/material.dart';

class CartaoSecaoConfiguracoes extends StatelessWidget {
  const CartaoSecaoConfiguracoes({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.filho,
  });

  final String titulo;
  final String subtitulo;
  final Widget filho;

  @override
  Widget build(BuildContext context) {
    final ColorScheme esquemaCores = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: esquemaCores.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: esquemaCores.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titulo,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            subtitulo,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 18),
          filho,
        ],
      ),
    );
  }
}
