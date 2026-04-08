import 'package:flutter/material.dart';

import '../../../localizacao/textos_aplicativo.dart';

class SeletorModoTema extends StatelessWidget {
  const SeletorModoTema({
    super.key,
    required this.modoSelecionado,
    required this.aoAlterarModo,
  });

  final ThemeMode modoSelecionado;
  final ValueChanged<ThemeMode> aoAlterarModo;

  @override
  Widget build(BuildContext context) {
    final textos = context.textos;
    return SegmentedButton<ThemeMode>(
      segments: <ButtonSegment<ThemeMode>>[
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          label: Text(textos.claro),
          icon: const Icon(Icons.light_mode_rounded),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          label: Text(textos.escuro),
          icon: const Icon(Icons.dark_mode_rounded),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          label: Text(textos.sistema),
          icon: const Icon(Icons.settings_suggest_rounded),
        ),
      ],
      selected: <ThemeMode>{modoSelecionado},
      onSelectionChanged: (Set<ThemeMode> selection) {
        aoAlterarModo(selection.first);
      },
    );
  }
}
