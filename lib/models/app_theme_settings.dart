import 'dart:convert';

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class AppThemeSettings {
  const AppThemeSettings({
    this.palette = AppPalette.laranjaSolar,
    this.themeMode = ThemeMode.system,
  });

  final AppPalette palette;
  final ThemeMode themeMode;

  AppThemeSettings copyWith({AppPalette? palette, ThemeMode? themeMode}) {
    return AppThemeSettings(
      palette: palette ?? this.palette,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'palette': palette.name,
      'themeMode': themeMode.name,
    };
  }

  factory AppThemeSettings.fromMap(Map<String, dynamic> map) {
    return AppThemeSettings(
      palette: AppPalette.values.firstWhere(
        (AppPalette item) => item.name == map['palette'],
        orElse: () => AppPalette.laranjaSolar,
      ),
      themeMode: ThemeMode.values.firstWhere(
        (ThemeMode item) => item.name == map['themeMode'],
        orElse: () => ThemeMode.system,
      ),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AppThemeSettings.fromJson(String source) {
    return AppThemeSettings.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
