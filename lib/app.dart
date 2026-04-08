import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/home/home_page.dart';
import 'theme/app_theme_factory.dart';
import 'bloc/app_theme/app_theme_bloc.dart';

class PdfReaderApp extends StatelessWidget {
  const PdfReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Leitor PDF',
          themeMode: state.settings.themeMode,
          theme: AppThemeFactory.createTheme(
            palette: state.settings.palette,
            brightness: Brightness.light,
          ),
          darkTheme: AppThemeFactory.createTheme(
            palette: state.settings.palette,
            brightness: Brightness.dark,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
