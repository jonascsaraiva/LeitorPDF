import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leitor_pdf/aplicativo.dart';
import 'package:leitor_pdf/blocos/tema_aplicativo/bloc_tema_aplicativo.dart';

void main() {
  testWidgets('carrega tela inicial do leitor de PDF', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider<BlocTemaAplicativo>(
        create: (_) => BlocTemaAplicativo(),
        child: const AplicativoLeitorPdf(),
      ),
    );

    expect(find.text('Leitor PDF'), findsOneWidget);
    expect(find.text('Recentes'), findsOneWidget);
    expect(find.text('Escolher arquivo PDF'), findsOneWidget);
  });
}
