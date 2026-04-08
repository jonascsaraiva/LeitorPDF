import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocos/tema_aplicativo/bloc_tema_aplicativo.dart';
import '../../temas/paleta_aplicativo.dart';
import 'widgets/cartao_opcao_paleta.dart';
import 'widgets/cartao_secao_configuracoes.dart';
import 'widgets/seletor_modo_tema.dart';

class PaginaConfiguracoes extends StatelessWidget {
  const PaginaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocTemaAplicativo, EstadoTemaAplicativo>(
      builder: (context, estado) {
        final PaletaAplicativo paletaSelecionada = estado.configuracoes.paleta;

        return Scaffold(
          appBar: AppBar(title: const Text('Configuracoes')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: paletaSelecionada.gradiente,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Personalize o aplicativo',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Escolha o modo de aparencia e a paleta que melhor combina com o seu leitor.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CartaoSecaoConfiguracoes(
                titulo: 'Modo do app',
                subtitulo:
                    'Voce pode usar claro, escuro ou deixar o aplicativo seguir o sistema.',
                filho: SeletorModoTema(
                  modoSelecionado: estado.configuracoes.modoTema,
                  aoAlterarModo: (ThemeMode modo) {
                    context.read<BlocTemaAplicativo>().add(
                      ModoTemaAlterado(modo),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CartaoSecaoConfiguracoes(
                titulo: 'Paleta de cores',
                subtitulo:
                    'As paletas mudam o visual geral do aplicativo e o destaque da interface.',
                filho: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: PaletaAplicativo.values.map((PaletaAplicativo paleta) {
                    return CartaoOpcaoPaleta(
                      paleta: paleta,
                      estaSelecionada: paleta == paletaSelecionada,
                      aoTocar: () {
                        context.read<BlocTemaAplicativo>().add(
                          PaletaTemaAlterada(paleta),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
