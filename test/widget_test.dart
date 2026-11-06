import 'package:flutter_test/flutter_test.dart';
import 'package:mend/main.dart';

void main() {
  testWidgets('Mend app launches and displays initial screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MendApp());
    await tester.pumpAndSettle();

    // Verify app launches successfully
    expect(find.byType(MendApp), findsOneWidget);
  });
}
