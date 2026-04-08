import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'aplicativo.dart';
import 'blocos/tema_aplicativo/bloc_tema_aplicativo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    BlocProvider<BlocTemaAplicativo>(
      create: (_) => BlocTemaAplicativo()..add(const TemaAplicativoIniciado()),
      child: const AplicativoLeitorPdf(),
    ),
  );
}
