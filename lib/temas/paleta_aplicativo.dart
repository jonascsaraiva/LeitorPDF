import 'package:flutter/material.dart';

enum PaletaAplicativo {
  laranjaSolar(
    rotulo: 'Laranja Solar',
    corSemente: Color(0xFFEA580C),
    fundoClaro: Color(0xFFF6F0E8),
    fundoEscuro: Color(0xFF111827),
    coresGradiente: <Color>[Color(0xFF7C2D12), Color(0xFFEA580C)],
  ),
  azulVivo(
    rotulo: 'Azul Vivo',
    corSemente: Color(0xFF2563EB),
    fundoClaro: Color(0xFFF1F6FF),
    fundoEscuro: Color(0xFF0F172A),
    coresGradiente: <Color>[Color(0xFF1D4ED8), Color(0xFF38BDF8)],
  ),
  douradoCalmo(
    rotulo: 'Dourado Calmo',
    corSemente: Color(0xFFD4A017),
    fundoClaro: Color(0xFFFBF7E8),
    fundoEscuro: Color(0xFF1F1A0D),
    coresGradiente: <Color>[Color(0xFFB45309), Color(0xFFFACC15)],
  ),
  rubiNoturno(
    rotulo: 'Rubi Noturno',
    corSemente: Color(0xFFDC2626),
    fundoClaro: Color(0xFFFFF1F2),
    fundoEscuro: Color(0xFF1F0F13),
    coresGradiente: <Color>[Color(0xFF991B1B), Color(0xFFF43F5E)],
  ),
  verdeFloresta(
    rotulo: 'Verde Floresta',
    corSemente: Color(0xFF15803D),
    fundoClaro: Color(0xFFF1F8F1),
    fundoEscuro: Color(0xFF0F1A14),
    coresGradiente: <Color>[Color(0xFF166534), Color(0xFF4ADE80)],
  );

  const PaletaAplicativo({
    required this.rotulo,
    required this.corSemente,
    required this.fundoClaro,
    required this.fundoEscuro,
    required this.coresGradiente,
  });

  final String rotulo;
  final Color corSemente;
  final Color fundoClaro;
  final Color fundoEscuro;
  final List<Color> coresGradiente;

  LinearGradient get gradiente {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: coresGradiente,
    );
  }
}
