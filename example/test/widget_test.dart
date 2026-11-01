import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';
import 'package:material_4_example/main.dart';

void main() {
  testWidgets('every gallery tab renders without exceptions', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      LiquidGlassWidgets.wrap(child: const Material4ExampleApp()),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    for (final tab in ['Shapes', 'Custom', 'Borders', 'Surfaces', 'Glass']) {
      await tester.tap(find.text(tab).last);
      // Animations loop forever, so pump frames instead of settling.
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 120));
      }
      expect(tester.takeException(), isNull, reason: 'tab $tab');
      expect(find.byType(Material4Container), findsWidgets, reason: 'tab $tab');
    }
  });

  testWidgets('liquid glass button responds to taps', (tester) async {
    await tester.pumpWidget(
      LiquidGlassWidgets.wrap(child: const Material4ExampleApp()),
    );
    await tester.tap(find.text('Glass').last);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.textContaining('Tap me'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Tap me · 1'), findsOneWidget);
  });
}
