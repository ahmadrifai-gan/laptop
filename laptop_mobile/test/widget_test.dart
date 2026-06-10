import 'package:flutter_test/flutter_test.dart';
import 'package:laptop_mobile/main.dart';

void main() {
  testWidgets('LapTopia app renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const LapTopiaApp());
    expect(find.text('LapTopia'), findsOneWidget);
  });
}
