import 'package:flutter/material.dart';

enum AppPalette {
  laranjaSolar(
    label: 'Laranja Solar',
    seedColor: Color(0xFFEA580C),
    lightBackground: Color(0xFFF6F0E8),
    darkBackground: Color(0xFF111827),
    gradientColors: <Color>[Color(0xFF7C2D12), Color(0xFFEA580C)],
  ),
  azulVivo(
    label: 'Azul Vivo',
    seedColor: Color(0xFF2563EB),
    lightBackground: Color(0xFFF1F6FF),
    darkBackground: Color(0xFF0F172A),
    gradientColors: <Color>[Color(0xFF1D4ED8), Color(0xFF38BDF8)],
  ),
  douradoCalmo(
    label: 'Dourado Calmo',
    seedColor: Color(0xFFD4A017),
    lightBackground: Color(0xFFFBF7E8),
    darkBackground: Color(0xFF1F1A0D),
    gradientColors: <Color>[Color(0xFFB45309), Color(0xFFFACC15)],
  ),
  rubiNoturno(
    label: 'Rubi Noturno',
    seedColor: Color(0xFFDC2626),
    lightBackground: Color(0xFFFFF1F2),
    darkBackground: Color(0xFF1F0F13),
    gradientColors: <Color>[Color(0xFF991B1B), Color(0xFFF43F5E)],
  ),
  verdeFloresta(
    label: 'Verde Floresta',
    seedColor: Color(0xFF15803D),
    lightBackground: Color(0xFFF1F8F1),
    darkBackground: Color(0xFF0F1A14),
    gradientColors: <Color>[Color(0xFF166534), Color(0xFF4ADE80)],
  );

  const AppPalette({
    required this.label,
    required this.seedColor,
    required this.lightBackground,
    required this.darkBackground,
    required this.gradientColors,
  });

  final String label;
  final Color seedColor;
  final Color lightBackground;
  final Color darkBackground;
  final List<Color> gradientColors;

  LinearGradient get gradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: gradientColors,
    );
  }
}
