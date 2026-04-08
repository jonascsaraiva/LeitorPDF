import 'package:flutter/material.dart';

import 'biblioteca/pagina_biblioteca.dart';
import 'configuracoes/pagina_configuracoes.dart';
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
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_rounded),
            label: 'Biblioteca',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Configuracoes',
          ),
        ],
      ),
    );
  }
}
