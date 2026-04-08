import 'package:flutter/material.dart';

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
    return SegmentedButton<ThemeMode>(
      segments: const <ButtonSegment<ThemeMode>>[
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          label: Text('Claro'),
          icon: Icon(Icons.light_mode_rounded),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          label: Text('Escuro'),
          icon: Icon(Icons.dark_mode_rounded),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          label: Text('Sistema'),
          icon: Icon(Icons.settings_suggest_rounded),
        ),
      ],
      selected: <ThemeMode>{modoSelecionado},
      onSelectionChanged: (Set<ThemeMode> selection) {
        aoAlterarModo(selection.first);
      },
    );
  }
}
