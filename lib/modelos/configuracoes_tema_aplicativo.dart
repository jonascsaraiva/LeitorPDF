import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../temas/paleta_aplicativo.dart';

enum IdiomaAplicativo {
  portugues('Portugues'),
  ingles('Ingles'),
  espanhol('Espanhol');

  const IdiomaAplicativo(this.rotulo);

  final String rotulo;

  Locale get locale {
    switch (this) {
      case IdiomaAplicativo.ingles:
        return const Locale('en');
      case IdiomaAplicativo.espanhol:
        return const Locale('es');
      case IdiomaAplicativo.portugues:
        return const Locale('pt');
    }
  }
}

class ConfiguracoesTemaAplicativo {
  const ConfiguracoesTemaAplicativo({
    this.paleta = PaletaAplicativo.laranjaSolar,
    this.modoTema = ThemeMode.system,
    this.direcaoRolagemPadrao = PdfScrollDirection.vertical,
    this.idioma = IdiomaAplicativo.portugues,
  });

  final PaletaAplicativo paleta;
  final ThemeMode modoTema;
  final PdfScrollDirection direcaoRolagemPadrao;
  final IdiomaAplicativo idioma;

  ConfiguracoesTemaAplicativo copyWith({
    PaletaAplicativo? paleta,
    ThemeMode? modoTema,
    PdfScrollDirection? direcaoRolagemPadrao,
    IdiomaAplicativo? idioma,
  }) {
    return ConfiguracoesTemaAplicativo(
      paleta: paleta ?? this.paleta,
      modoTema: modoTema ?? this.modoTema,
      direcaoRolagemPadrao: direcaoRolagemPadrao ?? this.direcaoRolagemPadrao,
      idioma: idioma ?? this.idioma,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paleta': paleta.name,
      'modoTema': modoTema.name,
      'direcaoRolagemPadrao': direcaoRolagemPadrao.name,
      'idioma': idioma.name,
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
      direcaoRolagemPadrao: PdfScrollDirection.values.firstWhere(
        (PdfScrollDirection item) => item.name == map['direcaoRolagemPadrao'],
        orElse: () => PdfScrollDirection.vertical,
      ),
      idioma: IdiomaAplicativo.values.firstWhere(
        (IdiomaAplicativo item) => item.name == map['idioma'],
        orElse: () => IdiomaAplicativo.portugues,
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
