import 'package:flutter/material.dart';

import 'paleta_aplicativo.dart';

class FabricaTemaAplicativo {
  static ThemeData criarTema({
    required PaletaAplicativo paleta,
    required Brightness brilho,
  }) {
    final ColorScheme esquemaCores = ColorScheme.fromSeed(
      seedColor: paleta.corSemente,
      brightness: brilho,
    );

    final bool temaEscuro = brilho == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brilho,
      colorScheme: esquemaCores,
      scaffoldBackgroundColor:
          temaEscuro ? paleta.fundoEscuro : paleta.fundoClaro,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: esquemaCores.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: esquemaCores.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: esquemaCores.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: esquemaCores.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: esquemaCores.primary, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: esquemaCores.inverseSurface,
        contentTextStyle: TextStyle(color: esquemaCores.onInverseSurface),
      ),
    );
  }
}
