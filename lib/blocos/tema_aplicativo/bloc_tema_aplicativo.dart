import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../modelos/configuracoes_tema_aplicativo.dart';
import '../../temas/paleta_aplicativo.dart';

part 'evento_tema_aplicativo.dart';
part 'estado_tema_aplicativo.dart';

class BlocTemaAplicativo
    extends Bloc<EventoTemaAplicativo, EstadoTemaAplicativo> {
  BlocTemaAplicativo() : super(const EstadoTemaAplicativo()) {
    on<TemaAplicativoIniciado>(_aoIniciar);
    on<ModoTemaAlterado>(_aoAlterarModoTema);
    on<PaletaTemaAlterada>(_aoAlterarPaletaTema);
    on<DirecaoRolagemPadraoAlterada>(_aoAlterarDirecaoRolagemPadrao);
    on<IdiomaAplicativoAlterado>(_aoAlterarIdiomaAplicativo);
  }

  static const String _chavePreferencias = 'configuracoes_tema_aplicativo';

  Future<void> _aoIniciar(
    TemaAplicativoIniciado evento,
    Emitter<EstadoTemaAplicativo> emitir,
  ) async {
    final SharedPreferences preferencias = await SharedPreferences.getInstance();
    final String? salvo = preferencias.getString(_chavePreferencias);

    if (salvo == null || salvo.isEmpty) {
      emitir(state.copyWith(estaPronto: true));
      return;
    }

    emitir(
      state.copyWith(
        configuracoes: ConfiguracoesTemaAplicativo.fromJson(salvo),
        estaPronto: true,
      ),
    );
  }

  Future<void> _aoAlterarModoTema(
    ModoTemaAlterado evento,
    Emitter<EstadoTemaAplicativo> emitir,
  ) async {
    final ConfiguracoesTemaAplicativo configuracoes =
        state.configuracoes.copyWith(
      modoTema: evento.modoTema,
    );

    emitir(
      state.copyWith(
        configuracoes: configuracoes,
        estaPronto: true,
      ),
    );
    await _persistir(configuracoes);
  }

  Future<void> _aoAlterarPaletaTema(
    PaletaTemaAlterada evento,
    Emitter<EstadoTemaAplicativo> emitir,
  ) async {
    final ConfiguracoesTemaAplicativo configuracoes =
        state.configuracoes.copyWith(
      paleta: evento.paleta,
    );

    emitir(
      state.copyWith(
        configuracoes: configuracoes,
        estaPronto: true,
      ),
    );
    await _persistir(configuracoes);
  }

  Future<void> _aoAlterarDirecaoRolagemPadrao(
    DirecaoRolagemPadraoAlterada evento,
    Emitter<EstadoTemaAplicativo> emitir,
  ) async {
    final ConfiguracoesTemaAplicativo configuracoes =
        state.configuracoes.copyWith(
      direcaoRolagemPadrao: evento.direcaoRolagem,
    );

    emitir(
      state.copyWith(
        configuracoes: configuracoes,
        estaPronto: true,
      ),
    );
    await _persistir(configuracoes);
  }

  Future<void> _aoAlterarIdiomaAplicativo(
    IdiomaAplicativoAlterado evento,
    Emitter<EstadoTemaAplicativo> emitir,
  ) async {
    final ConfiguracoesTemaAplicativo configuracoes =
        state.configuracoes.copyWith(
      idioma: evento.idioma,
    );

    emitir(
      state.copyWith(
        configuracoes: configuracoes,
        estaPronto: true,
      ),
    );
    await _persistir(configuracoes);
  }

  Future<void> _persistir(ConfiguracoesTemaAplicativo configuracoes) async {
    final SharedPreferences preferencias = await SharedPreferences.getInstance();
    await preferencias.setString(_chavePreferencias, configuracoes.toJson());
  }
}
