part of 'bloc_tema_aplicativo.dart';

class EstadoTemaAplicativo {
  const EstadoTemaAplicativo({
    this.configuracoes = const ConfiguracoesTemaAplicativo(),
    this.estaPronto = false,
  });

  final ConfiguracoesTemaAplicativo configuracoes;
  final bool estaPronto;

  EstadoTemaAplicativo copyWith({
    ConfiguracoesTemaAplicativo? configuracoes,
    bool? estaPronto,
  }) {
    return EstadoTemaAplicativo(
      configuracoes: configuracoes ?? this.configuracoes,
      estaPronto: estaPronto ?? this.estaPronto,
    );
  }
}
