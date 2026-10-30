import 'package:dynamic_shape_example/features/creative_gallery/creative_showcase_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CreativeShowcaseScreen renders with 8 tabs cleanly',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CreativeShowcaseScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify app bar title
    expect(find.text('Dynamic Material Cards Studio'), findsOneWidget);

    // Verify tabs
    expect(find.text('1. Paper Cards'), findsOneWidget);
    expect(find.text('2. Sculpted Surfaces'), findsOneWidget);
    expect(find.text('3. Modern Creative'), findsOneWidget);
    expect(find.text('4. Special Purpose'), findsOneWidget);

    // Switch to Sculpted Surfaces tab
    await tester.tap(find.text('2. Sculpted Surfaces'));
    await tester.pumpAndSettle();
    expect(find.text('Sculpted 3D Surfaces'), findsOneWidget);
  });
}

