import 'package:flutter/material.dart';

import '../../../localizacao/textos_aplicativo.dart';
import '../../../temas/paleta_aplicativo.dart';

class SecaoCabecalhoInicio extends StatelessWidget {
  const SecaoCabecalhoInicio({
    super.key,
    required this.estaSelecionando,
    required this.paleta,
    required this.aoPressionarAbrir,
  });

  final bool estaSelecionando;
  final PaletaAplicativo paleta;
  final VoidCallback aoPressionarAbrir;

  @override
  Widget build(BuildContext context) {
    final TextTheme temaTexto = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: paleta.gradiente,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  context.textos.tituloAplicativo,
                  style: temaTexto.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.textos.descricaoNenhumPdfAberto,
            style: temaTexto.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${context.textos.paletaAtivaPrefixo} ${context.textos.tituloPaleta(paleta)}',
              style: temaTexto.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: estaSelecionando ? null : aoPressionarAbrir,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: paleta.corSemente,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            ),
            icon: estaSelecionando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.folder_open_rounded),
            label: Text(
              estaSelecionando
                  ? context.textos.buscandoPdf
                  : context.textos.escolherArquivoPdf,
            ),
          ),
        ],
      ),
    );
  }
}
