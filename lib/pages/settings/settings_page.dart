import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/app_theme/app_theme_bloc.dart';
import '../../theme/app_palette.dart';
import 'widgets/palette_option_card.dart';
import 'widgets/settings_section_card.dart';
import 'widgets/theme_mode_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
      builder: (context, state) {
        final AppPalette selectedPalette = state.settings.palette;

        return Scaffold(
          appBar: AppBar(title: const Text('Configuracoes')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: selectedPalette.gradient,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Personalize o aplicativo',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Escolha o modo de aparencia e a paleta que melhor combina com o seu leitor.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SettingsSectionCard(
                title: 'Modo do app',
                subtitle:
                    'Voce pode usar claro, escuro ou deixar o aplicativo seguir o sistema.',
                child: ThemeModeSelector(
                  selectedMode: state.settings.themeMode,
                  onModeChanged: (ThemeMode mode) {
                    context.read<AppThemeBloc>().add(AppThemeModeChanged(mode));
                  },
                ),
              ),
              const SizedBox(height: 16),
              SettingsSectionCard(
                title: 'Paleta de cores',
                subtitle:
                    'As paletas mudam o visual geral do aplicativo e o destaque da interface.',
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: AppPalette.values.map((AppPalette palette) {
                    return PaletteOptionCard(
                      palette: palette,
                      isSelected: palette == selectedPalette,
                      onTap: () {
                        context.read<AppThemeBloc>().add(
                          AppThemePaletteChanged(palette),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
