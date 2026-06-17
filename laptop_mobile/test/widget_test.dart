import 'package:flutter_test/flutter_test.dart';
import 'package:laptop_mobile/main.dart';

void main() {
  testWidgets('LapTopia app renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('LapTopia'), findsOneWidget);
  });
}
