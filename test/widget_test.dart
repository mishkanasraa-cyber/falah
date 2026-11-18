import 'package:flutter_test/flutter_test.dart';
import 'package:falah_app/main.dart';

void main() {
  testWidgets('Falah app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FalahApp());
    expect(find.text('منظومة فلاح الزراعية'), findsOneWidget);
  });
}
