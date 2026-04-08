import 'dart:convert';

import 'package:flutter/material.dart';

import '../temas/paleta_aplicativo.dart';

class ConfiguracoesTemaAplicativo {
  const ConfiguracoesTemaAplicativo({
    this.paleta = PaletaAplicativo.laranjaSolar,
    this.modoTema = ThemeMode.system,
  });

  final PaletaAplicativo paleta;
  final ThemeMode modoTema;

  ConfiguracoesTemaAplicativo copyWith({
    PaletaAplicativo? paleta,
    ThemeMode? modoTema,
  }) {
    return ConfiguracoesTemaAplicativo(
      paleta: paleta ?? this.paleta,
      modoTema: modoTema ?? this.modoTema,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paleta': paleta.name,
      'modoTema': modoTema.name,
    };
  }

  factory ConfiguracoesTemaAplicativo.fromMap(Map<String, dynamic> map) {
    return ConfiguracoesTemaAplicativo(
      paleta: PaletaAplicativo.values.firstWhere(
        (PaletaAplicativo item) => item.name == map['paleta'],
        orElse: () => PaletaAplicativo.laranjaSolar,
      ),
      modoTema: ThemeMode.values.firstWhere(
        (ThemeMode item) => item.name == map['modoTema'],
        orElse: () => ThemeMode.system,
      ),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ConfiguracoesTemaAplicativo.fromJson(String source) {
    return ConfiguracoesTemaAplicativo.fromMap(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}
