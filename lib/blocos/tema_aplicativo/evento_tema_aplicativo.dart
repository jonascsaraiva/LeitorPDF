part of 'bloc_tema_aplicativo.dart';

sealed class EventoTemaAplicativo {
  const EventoTemaAplicativo();
}

class TemaAplicativoIniciado extends EventoTemaAplicativo {
  const TemaAplicativoIniciado();
}

class ModoTemaAlterado extends EventoTemaAplicativo {
  const ModoTemaAlterado(this.modoTema);

  final ThemeMode modoTema;
}

class PaletaTemaAlterada extends EventoTemaAplicativo {
  const PaletaTemaAlterada(this.paleta);

  final PaletaAplicativo paleta;
}

class DirecaoRolagemPadraoAlterada extends EventoTemaAplicativo {
  const DirecaoRolagemPadraoAlterada(this.direcaoRolagem);

  final PdfScrollDirection direcaoRolagem;
}

class IdiomaAplicativoAlterado extends EventoTemaAplicativo {
  const IdiomaAplicativoAlterado(this.idioma);

  final IdiomaAplicativo idioma;
}
