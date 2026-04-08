part of 'app_theme_bloc.dart';

sealed class AppThemeEvent {
  const AppThemeEvent();
}

class AppThemeStarted extends AppThemeEvent {
  const AppThemeStarted();
}

class AppThemeModeChanged extends AppThemeEvent {
  const AppThemeModeChanged(this.themeMode);

  final ThemeMode themeMode;
}

class AppThemePaletteChanged extends AppThemeEvent {
  const AppThemePaletteChanged(this.palette);

  final AppPalette palette;
}
