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

    return Expanded(
      child: Center(
        child: InkWell(
          onTap: aoTocar,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: paleta.gradiente,
              border: Border.all(
                color: estaSelecionada
                    ? esquemaCores.onSurface
                    : esquemaCores.outlineVariant,
                width: estaSelecionada ? 3 : 1.5,
              ),
              boxShadow: estaSelecionada
                  ? <BoxShadow>[
                      BoxShadow(
                        color: esquemaCores.primary.withValues(alpha: 0.22),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
