import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/app_theme_settings.dart';
import '../../theme/app_palette.dart';

part 'app_theme_event.dart';
part 'app_theme_state.dart';

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc() : super(const AppThemeState()) {
    on<AppThemeStarted>(_onStarted);
    on<AppThemeModeChanged>(_onThemeModeChanged);
    on<AppThemePaletteChanged>(_onPaletteChanged);
  }

  static const String _preferencesKey = 'app_theme_settings';

  Future<void> _onStarted(
    AppThemeStarted event,
    Emitter<AppThemeState> emit,
  ) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? stored = preferences.getString(_preferencesKey);

    if (stored == null || stored.isEmpty) {
      emit(state.copyWith(isReady: true));
      return;
    }

    emit(
      state.copyWith(
        settings: AppThemeSettings.fromJson(stored),
        isReady: true,
      ),
    );
  }

  Future<void> _onThemeModeChanged(
    AppThemeModeChanged event,
    Emitter<AppThemeState> emit,
  ) async {
    final AppThemeSettings settings = state.settings.copyWith(
      themeMode: event.themeMode,
    );

    emit(state.copyWith(settings: settings, isReady: true));
    await _persist(settings);
  }

  Future<void> _onPaletteChanged(
    AppThemePaletteChanged event,
    Emitter<AppThemeState> emit,
  ) async {
    final AppThemeSettings settings = state.settings.copyWith(
      palette: event.palette,
    );

    emit(state.copyWith(settings: settings, isReady: true));
    await _persist(settings);
  }

  Future<void> _persist(AppThemeSettings settings) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferencesKey, settings.toJson());
  }
}
