part of 'app_theme_bloc.dart';

class AppThemeState {
  const AppThemeState({
    this.settings = const AppThemeSettings(),
    this.isReady = false,
  });

  final AppThemeSettings settings;
  final bool isReady;

  AppThemeState copyWith({AppThemeSettings? settings, bool? isReady}) {
    return AppThemeState(
      settings: settings ?? this.settings,
      isReady: isReady ?? this.isReady,
    );
  }
}
