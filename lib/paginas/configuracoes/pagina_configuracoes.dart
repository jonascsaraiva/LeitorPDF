import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../blocos/tema_aplicativo/bloc_tema_aplicativo.dart';
import '../../localizacao/textos_aplicativo.dart';
import '../../modelos/configuracoes_tema_aplicativo.dart';
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
        final IdiomaAplicativo idiomaSelecionado = estado.configuracoes.idioma;
        final PdfScrollDirection direcaoRolagemPadrao =
            estado.configuracoes.direcaoRolagemPadrao;

        return Scaffold(
          appBar: AppBar(title: Text(context.textos.configuracoes)),
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
                      context.textos.personalizarAplicativo,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.textos.descricaoConfiguracoes,
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
                titulo: context.textos.modoDoApp,
                subtitulo: context.textos.descricaoModoApp,
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
                titulo: context.textos.leitura,
                subtitulo: context.textos.descricaoLeitura,
                filho: SegmentedButton<PdfScrollDirection>(
                  segments: <ButtonSegment<PdfScrollDirection>>[
                    ButtonSegment<PdfScrollDirection>(
                      value: PdfScrollDirection.vertical,
                      label: Text(context.textos.vertical),
                      icon: const Icon(Icons.swap_vert_rounded),
                    ),
                    ButtonSegment<PdfScrollDirection>(
                      value: PdfScrollDirection.horizontal,
                      label: Text(context.textos.horizontal),
                      icon: const Icon(Icons.swap_horiz_rounded),
                    ),
                  ],
                  selected: <PdfScrollDirection>{direcaoRolagemPadrao},
                  onSelectionChanged: (Set<PdfScrollDirection> selecao) {
                    context.read<BlocTemaAplicativo>().add(
                          DirecaoRolagemPadraoAlterada(selecao.first),
                        );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CartaoSecaoConfiguracoes(
                titulo: context.textos.idioma,
                subtitulo: context.textos.descricaoIdioma,
                filho: DropdownButtonFormField<IdiomaAplicativo>(
                  initialValue: idiomaSelecionado,
                  decoration: InputDecoration(
                    labelText: context.textos.idiomaPreferido,
                  ),
                  items: IdiomaAplicativo.values.map((IdiomaAplicativo idioma) {
                    return DropdownMenuItem<IdiomaAplicativo>(
                      value: idioma,
                      child: Text(context.textos.idiomaRotulo(idioma)),
                    );
                  }).toList(),
                  onChanged: (IdiomaAplicativo? idioma) {
                    if (idioma == null) {
                      return;
                    }
                    context.read<BlocTemaAplicativo>().add(
                          IdiomaAplicativoAlterado(idioma),
                        );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CartaoSecaoConfiguracoes(
                titulo: context.textos.paletaDeCores,
                subtitulo: context.textos.descricaoPaleta,
                filho: Row(
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
