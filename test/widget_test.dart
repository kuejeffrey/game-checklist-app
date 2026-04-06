import 'package:flutter_test/flutter_test.dart';

import 'package:level_up/main.dart';

void main() {
  testWidgets('app starts on the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LevelUpApp());

    expect(find.text('Level Up'), findsOneWidget);
    expect(find.text('One step at a time'), findsOneWidget);
  });
}
