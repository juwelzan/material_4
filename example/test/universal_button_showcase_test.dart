import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4_example/features/button/universal_button_showcase_screen.dart';

void main() {
  testWidgets('UniversalButtonShowcaseScreen renders all 6 tabs and switches cleanly', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: UniversalButtonShowcaseScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Universal Button System'), findsOneWidget);
    expect(find.text('Variants & Presets'), findsOneWidget);
    expect(find.text('Shapes & Geometries'), findsOneWidget);
    expect(find.text('Animation Matrix'), findsOneWidget);
    expect(find.text('State & Controller'), findsOneWidget);
    expect(find.text('Textures & Patterns'), findsOneWidget);
    expect(find.text('Customization Studio'), findsOneWidget);

    // Initial Tab 1 content
    expect(find.text('Universal Button Paradigms'), findsOneWidget);

    // Switch to Shapes & Geometries
    await tester.tap(find.text('Shapes & Geometries'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Vector Shape Engine Integration'), findsOneWidget);

    // Switch to Animation Matrix
    await tester.tap(find.text('Animation Matrix'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Press Animation Modes'), findsOneWidget);

    // Switch to State & Controller
    await tester.tap(find.text('State & Controller'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Lifecycle State Machine'), findsOneWidget);

    // Switch to Textures & Patterns
    await tester.tap(find.text('Textures & Patterns'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Procedural Textures on Buttons'), findsOneWidget);

    // Switch to Customization Studio
    await tester.tap(find.text('Customization Studio'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Live Button Studio'), findsOneWidget);
    expect(find.text('Button Configuration Controls'), findsOneWidget);
  });
}
