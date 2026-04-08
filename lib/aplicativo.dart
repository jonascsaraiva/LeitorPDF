import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocos/biblioteca_pdf/bloc_biblioteca_pdf.dart';
import 'blocos/tema_aplicativo/bloc_tema_aplicativo.dart';
import 'paginas/pagina_principal.dart';
import 'temas/fabrica_tema_aplicativo.dart';

class AplicativoLeitorPdf extends StatelessWidget {
  const AplicativoLeitorPdf({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<BlocBibliotecaPdf>(
          create: (_) => BlocBibliotecaPdf()..add(const BibliotecaPdfIniciada()),
        ),
      ],
      child: BlocBuilder<BlocTemaAplicativo, EstadoTemaAplicativo>(
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
            home: const PaginaPrincipal(),
          );
        },
      ),
    );
  }
}
