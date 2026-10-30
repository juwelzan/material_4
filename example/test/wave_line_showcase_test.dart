import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4_example/features/progress/wave_line_showcase_screen.dart';

void main() {
  testWidgets('WaveLineShowcaseScreen renders hero banner and filter chips',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: WaveLineShowcaseScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Verify AppBar and Hero banner
    expect(find.text('Animated Wave Line Studio'), findsOneWidget);
    expect(find.text('Advanced Animated Wave Line System'), findsOneWidget);
    expect(find.text('NEW IN MATERIAL 4'), findsOneWidget);

    // Verify category chips
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Zigzag Lines'), findsOneWidget);
    expect(find.text('Organic Waves'), findsOneWidget);
    expect(find.text('Creative Lines'), findsOneWidget);
    expect(find.text('Interactive Studio'), findsOneWidget);

    // Verify initial visible sections
    expect(find.text('1. Zigzag Wave Lines (10 Styles)'), findsOneWidget);
  });

  testWidgets('WaveLineShowcaseScreen filter chips toggle sections',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: WaveLineShowcaseScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Tap "Organic Waves" filter chip
    await tester.tap(find.text('Organic Waves'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('2. Organic Wave Lines (10 Styles)'), findsOneWidget);
    expect(find.text('1. Zigzag Wave Lines (10 Styles)'), findsNothing);

    // Tap "Creative Lines" filter chip
    await tester.tap(find.text('Creative Lines'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('3. Creative Animated Lines (15 Styles)'), findsOneWidget);
    expect(find.text('2. Organic Wave Lines (10 Styles)'), findsNothing);

    // Tap "Interactive Studio" filter chip
    await tester.tap(find.text('Interactive Studio'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Wave Line Parameter Studio'), findsOneWidget);
  });

  testWidgets('WaveLineShowcaseScreen embedded mode renders cleanly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WaveLineShowcaseScreen(isEmbedded: true),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // In embedded mode, AppBar and Hero Banner should not be present
    expect(find.text('Animated Wave Line Studio'), findsNothing);
    expect(find.text('Advanced Animated Wave Line System'), findsNothing);

    // Filter chips and gallery content should still render cleanly
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Zigzag Lines'), findsOneWidget);
    expect(find.text('1. Zigzag Wave Lines (10 Styles)'), findsOneWidget);
  });

  testWidgets('Interactive Studio handles indeterminate and pause toggles',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: WaveLineShowcaseScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Tap "Interactive Studio"
    await tester.tap(find.text('Interactive Studio'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Indeterminate'), findsOneWidget);
    expect(find.text('Pause Ticker'), findsOneWidget);

    // Tap "Indeterminate" switch
    await tester.tap(find.text('Indeterminate'));
    await tester.pump(const Duration(milliseconds: 100));

    // Tap "Pause Ticker" switch
    await tester.tap(find.text('Pause Ticker'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('GENERATED CODE'), findsOneWidget);
  });
}

