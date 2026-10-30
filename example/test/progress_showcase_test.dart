import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4_example/features/progress/progress_showcase_screen.dart';

void main() {
  testWidgets('ProgressBarShowcaseScreen renders hero banner and filter chips',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: ProgressBarShowcaseScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify app bar title and hero banner
    expect(find.text('Universal Progress Gallery'), findsOneWidget);
    expect(find.text('Material 4 Progress System'), findsOneWidget);
    expect(
      find.text('One Progress System, Multiple Styles, Unlimited Customization'),
      findsOneWidget,
    );

    // Verify filter chips
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Linear Styles'), findsOneWidget);
    expect(find.text('Circular & Rings'), findsOneWidget);
    expect(find.text('Creative & Fluid'), findsOneWidget);
    expect(find.text('Interactive & Seeking'), findsOneWidget);
    expect(find.text('Playground'), findsOneWidget);

    // Initial visible sections
    expect(find.text('01. Linear Progress Gallery'), findsOneWidget);
    expect(find.text('02. Circular Progress Gallery'), findsOneWidget);
  });

  testWidgets('ProgressBarShowcaseScreen filter chips switch visible categories',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: ProgressBarShowcaseScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap "Circular & Rings" chip
    await tester.tap(find.text('Circular & Rings'));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify circular section is visible
    expect(find.text('02. Circular Progress Gallery'), findsOneWidget);
    expect(find.text('03. Ring Progress Gallery'), findsOneWidget);
    // Linear section should be hidden
    expect(find.text('01. Linear Progress Gallery'), findsNothing);

    // Tap "Creative & Fluid" chip
    await tester.tap(find.text('Creative & Fluid'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('05. Wave Progress Gallery'), findsOneWidget);
    expect(find.text('06. Liquid Reservoir Gallery'), findsOneWidget);

    // Tap "Interactive & Seeking" chip
    await tester.tap(find.text('Interactive & Seeking'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      find.text('13. Interactive Seeking & Stepping Gallery'),
      findsOneWidget,
    );

    // Tap "Playground" chip
    await tester.tap(find.text('Playground'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('15. Interactive Progress Studio'), findsOneWidget);
  });

  testWidgets('ProgressBarShowcaseScreen embedded mode hides AppBar and hero',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressBarShowcaseScreen(isEmbedded: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // In embedded mode, AppBar and Hero Banner should not be present
    expect(find.text('Universal Progress Gallery'), findsNothing);
    expect(find.text('Material 4 Progress System'), findsNothing);

    // Filter chips and gallery content should still render cleanly
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Linear Styles'), findsOneWidget);
    expect(find.text('01. Linear Progress Gallery'), findsOneWidget);
  });
}
