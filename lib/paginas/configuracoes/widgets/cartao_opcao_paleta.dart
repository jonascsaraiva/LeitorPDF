import 'package:flutter/material.dart';

import '../../../temas/paleta_aplicativo.dart';

class CartaoOpcaoPaleta extends StatelessWidget {
  const CartaoOpcaoPaleta({
    super.key,
    required this.paleta,
    required this.estaSelecionada,
    required this.aoTocar,
  });

  final PaletaAplicativo paleta;
  final bool estaSelecionada;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final ColorScheme esquemaCores = Theme.of(context).colorScheme;

    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: esquemaCores.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: estaSelecionada
                ? esquemaCores.primary
                : esquemaCores.outlineVariant,
            width: estaSelecionada ? 2 : 1,
          ),
          boxShadow: estaSelecionada
              ? <BoxShadow>[
                  BoxShadow(
                    color: esquemaCores.primary.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 74,
              decoration: BoxDecoration(
                gradient: paleta.gradiente,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              paleta.rotulo,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              estaSelecionada ? 'Selecionada' : 'Toque para aplicar',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
