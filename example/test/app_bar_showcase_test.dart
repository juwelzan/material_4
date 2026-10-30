import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4_example/features/app_bar/app_bar_showcase_screen.dart';

void main() {
  testWidgets('AppBarShowcaseScreen renders all 7 tabs and switches cleanly',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: AppBarShowcaseScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify main screen header
    expect(find.text('Adaptive AppBar Studio'), findsOneWidget);

    // Verify initial tabs
    expect(find.text('1. Dashboard (Reference)'), findsOneWidget);
    expect(find.text('2. Profile & Morphing'), findsOneWidget);
    expect(find.text('3. Organic Wave Shape'), findsOneWidget);

    // Verify reference dashboard elements
    expect(find.text('SchoolMate Dashboard'), findsWidgets);
    expect(find.text('Dr. Sarah Mitchell'), findsWidgets);

    // Switch to Profile & Morphing tab
    await tester.tap(find.text('2. Profile & Morphing'));
    await tester.pumpAndSettle();
    expect(find.text('Alex Morgan'), findsWidgets);

    // Switch to Organic Wave Shape tab
    await tester.tap(find.text('3. Organic Wave Shape'));
    await tester.pumpAndSettle();
    expect(find.text('Organic Wave Design'), findsWidgets);

    // Switch to Frosted Glass tab
    await tester.tap(find.text('4. Frosted Glass'));
    await tester.pumpAndSettle();
    expect(find.text('Frosted Glass Header'), findsWidgets);

    // Switch to Preset Catalog tab
    final tab7Finder = find.text('7. Preset Catalog');
    await tester.ensureVisible(tab7Finder);
    await tester.tap(tab7Finder);
    await tester.pumpAndSettle();
    expect(find.text('Standard Clean AppBar'), findsOneWidget);
    expect(find.text('Large Dashboard Header'), findsOneWidget);
  });
}
