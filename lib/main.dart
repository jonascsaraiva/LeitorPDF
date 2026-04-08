import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'bloc/app_theme/app_theme_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    BlocProvider<AppThemeBloc>(
      create: (_) => AppThemeBloc()..add(const AppThemeStarted()),
      child: const PdfReaderApp(),
    ),
  );
}
