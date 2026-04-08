import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocos/tema_aplicativo/bloc_tema_aplicativo.dart';
import 'paginas/inicio/pagina_inicial.dart';
import 'temas/fabrica_tema_aplicativo.dart';

class AplicativoLeitorPdf extends StatelessWidget {
  const AplicativoLeitorPdf({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocTemaAplicativo, EstadoTemaAplicativo>(
      builder: (context, estado) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Leitor PDF',
          themeMode: estado.configuracoes.modoTema,
          theme: FabricaTemaAplicativo.criarTema(
            paleta: estado.configuracoes.paleta,
            brilho: Brightness.light,
          ),
          darkTheme: FabricaTemaAplicativo.criarTema(
            paleta: estado.configuracoes.paleta,
            brilho: Brightness.dark,
          ),
          home: const PaginaInicial(),
        );
      },
    );
  }
}
