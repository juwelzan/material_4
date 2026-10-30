import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4_example/features/showcase/material_4_showcase_screen.dart';

void main() {
  testWidgets(
      'Material4ShowcaseScreen renders all 10 tabs and switches cleanly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Material4ShowcaseScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify title
    expect(find.text('Material 4 Showcase'), findsOneWidget);

    // Verify tab titles exist
    expect(find.text('1. Basic Shapes'), findsOneWidget);
    expect(find.text('2. Advanced Shapes'), findsOneWidget);
    expect(find.text('3. Creative Borders'), findsOneWidget);
    expect(find.text('4. Paper Backgrounds'), findsOneWidget);
    expect(find.text('5. Advanced Effects'), findsOneWidget);
    expect(find.text('6. Sculpted Icon Cards'), findsOneWidget);
    expect(find.text('7. Material Cards'), findsOneWidget);
    expect(find.text('8. Shape Morphing'), findsOneWidget);
    expect(find.text('9. Interactive Components'), findsOneWidget);
    expect(find.text('10. Custom Configuration'), findsOneWidget);

    // Verify Tab 1 contents
    expect(find.text('1. Basic Geometries'), findsOneWidget);
    expect(find.text('Squircle'), findsOneWidget);
    expect(find.text('Folder Tab'), findsOneWidget);

    // Switch to Tab 6: Sculpted Icon Cards
    await tester.tap(find.text('6. Sculpted Icon Cards'));
    await tester.pumpAndSettle();
    expect(find.text('Academic Honors Portal'), findsOneWidget);

    // Switch to Tab 8: Shape Morphing
    await tester.tap(find.text('8. Shape Morphing'));
    await tester.pumpAndSettle();
    expect(find.text('8. Shape Animation & Morphing Engine'), findsOneWidget);
    expect(find.text('Next Morph Geometry'), findsOneWidget);

    // Trigger morphing step
    await tester.tap(find.text('Next Morph Geometry'));
    await tester.pumpAndSettle();
    expect(find.text('State 2 of 6'), findsOneWidget);

    // Switch to Tab 10: Custom Configuration
    await tester.tap(find.text('10. Custom Configuration'));
    await tester.pumpAndSettle();
    expect(find.text('10. Custom Configuration Studio'), findsOneWidget);
    expect(find.text('Live Config Preview'), findsOneWidget);
  });
}
