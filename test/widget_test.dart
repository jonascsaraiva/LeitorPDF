import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leitor_pdf/app.dart';
import 'package:leitor_pdf/bloc/app_theme/app_theme_bloc.dart';

void main() {
  testWidgets('carrega tela inicial do leitor de PDF', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider<AppThemeBloc>(
        create: (_) => AppThemeBloc(),
        child: const PdfReaderApp(),
      ),
    );

    expect(find.text('Leitor PDF'), findsOneWidget);
    expect(find.text('Recentes'), findsOneWidget);
    expect(find.text('Escolher arquivo PDF'), findsOneWidget);
  });
}
