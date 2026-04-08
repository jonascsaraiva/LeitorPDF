import 'package:flutter/material.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onModeChanged;

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
      selected: <ThemeMode>{selectedMode},
      onSelectionChanged: (Set<ThemeMode> selection) {
        onModeChanged(selection.first);
      },
    );
  }
}
