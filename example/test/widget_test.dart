import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('SchoolMate app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SchoolMateApp());
    expect(find.text('SchoolMate'), findsOneWidget);
  });
}
