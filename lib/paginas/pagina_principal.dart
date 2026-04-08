import 'package:flutter/material.dart';

import '../localizacao/textos_aplicativo.dart';
import 'biblioteca/pagina_biblioteca.dart';
import 'configuracoes/pagina_configuracoes.dart';
import 'favoritos/pagina_favoritos.dart';
import 'inicio/pagina_inicial.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _indiceAtual = 0;

  final List<Widget> _paginas = const <Widget>[
    PaginaInicial(),
    PaginaBiblioteca(),
    PaginaFavoritos(),
    PaginaConfiguracoes(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceAtual,
        children: _paginas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceAtual,
        onDestinationSelected: (int indice) {
          setState(() {
            _indiceAtual = indice;
          });
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.home_rounded),
            label: context.textos.inicio,
          ),
          NavigationDestination(
            icon: const Icon(Icons.library_books_rounded),
            label: context.textos.historico,
          ),
          NavigationDestination(
            icon: const Icon(Icons.star_rounded),
            label: context.textos.favoritos,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_rounded),
            label: context.textos.configuracoes,
          ),
        ],
      ),
    );
  }
}
