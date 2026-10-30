import 'package:material_4_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'SchoolMate app smoke test and morph card cycling without overflow',
      (WidgetTester tester) async {
    // Set realistic phone screen dimensions
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SchoolMateApp());
    expect(find.text('SchoolMate'), findsOneWidget);

    // Scroll until "Tap to Morph" is in view
    final tapToMorphFinder = find.text('Tap to Morph');
    await tester.scrollUntilVisible(
      tapToMorphFinder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Initial state of morphing card
    expect(find.text('Folder Tab (State 1)'), findsOneWidget);

    // Morph to State 2: Notched Badge
    await tester.tap(tapToMorphFinder);
    await tester.pumpAndSettle();
    expect(find.text('Notched Badge (State 2)'), findsOneWidget);

    // Morph to State 3: Ticket Scallop
    await tester.tap(tapToMorphFinder);
    await tester.pumpAndSettle();
    expect(find.text('Ticket Scallop (State 3)'), findsOneWidget);

    // Morph to State 4: Soft Hexagon (where 38px overflow previously occurred)
    await tester.tap(tapToMorphFinder);
    await tester.pumpAndSettle();
    expect(find.text('Soft Hexagon (State 4)'), findsOneWidget);

    // Morph back to State 1
    await tester.tap(tapToMorphFinder);
    await tester.pumpAndSettle();
    expect(find.text('Folder Tab (State 1)'), findsOneWidget);
  });

  testWidgets('SchoolMate app on small screen (320px) does not overflow',
      (WidgetTester tester) async {
    // Test on very narrow legacy/budget device (e.g. 320x568)
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SchoolMateApp());
    expect(find.text('SchoolMate'), findsOneWidget);

    final tapToMorphFinder = find.text('Tap to Morph');
    await tester.scrollUntilVisible(
      tapToMorphFinder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Cycle all morph steps on 320px width
    for (int i = 0; i < 4; i++) {
      await tester.tap(tapToMorphFinder);
      await tester.pumpAndSettle();
    }
  });
}
