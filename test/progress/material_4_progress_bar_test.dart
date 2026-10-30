import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Material4ProgressStyle & Shape Unit Tests', () {
    test('Style category predicates classify correctly', () {
      expect(Material4ProgressStyle.classicLinear.isLinear, isTrue);
      expect(Material4ProgressStyle.capsuleLinear.isLinear, isTrue);
      expect(Material4ProgressStyle.waveLinear.isWaveOrLiquid, isTrue);
      expect(Material4ProgressStyle.segmentedLinear.isSegmented, isTrue);

      expect(Material4ProgressStyle.classicCircular.isCircular, isTrue);
      expect(Material4ProgressStyle.ring.isCircular, isTrue);
      expect(Material4ProgressStyle.dottedRing.isDottedOrDashed, isTrue);

      expect(Material4ProgressStyle.liquid.isCreative, isTrue);
      expect(Material4ProgressStyle.wave.isCreative, isTrue);
      expect(Material4ProgressStyle.step.isSegmented, isTrue);
    });

    test('All Geometric Shapes generate valid closed paths', () {
      const testSize = Size(200, 20);
      final shapes = [
        Material4ProgressShape.rectangle(),
        Material4ProgressShape.roundedRectangle(borderRadius: 8),
        Material4ProgressShape.capsule(),
        Material4ProgressShape.circle(),
        Material4ProgressShape.oval(),
        Material4ProgressShape.squircle(),
        Material4ProgressShape.hexagon(),
        Material4ProgressShape.octagon(),
        Material4ProgressShape.diamond(),
        Material4ProgressShape.polygon(sides: 5),
      ];

      for (final shape in shapes) {
        final path = shape.buildPath(testSize);
        expect(path.computeMetrics().isNotEmpty, isTrue,
            reason: '${shape.id} produced empty metrics');
        expect(path.getBounds().isEmpty, isFalse,
            reason: '${shape.id} produced empty bounds');
      }
    });

    test('All Organic & Creative Shapes generate valid closed paths', () {
      const testSize = Size(200, 40);
      final shapes = [
        Material4ProgressShape.blob(),
        Material4ProgressShape.asymmetric(),
        Material4ProgressShape.wavy(),
        Material4ProgressShape.concave(),
        Material4ProgressShape.convex(),
        Material4ProgressShape.sculpted(),
        Material4ProgressShape.curved(),
        Material4ProgressShape.irregular(),
        Material4ProgressShape.liquid(),
        Material4ProgressShape.zigzag(),
        Material4ProgressShape.flower(),
        Material4ProgressShape.shield(),
      ];

      for (final shape in shapes) {
        final path = shape.buildPath(testSize);
        expect(path.computeMetrics().isNotEmpty, isTrue,
            reason: '${shape.id} produced empty metrics');
      }
    });

    test('Shape lerp interpolates smoothly between shapes', () {
      final circle = Material4ProgressShape.circle();
      final squircle = Material4ProgressShape.squircle();

      final morphedMid = Material4ProgressShape.lerp(circle, squircle, 0.5);
      final path = morphedMid.buildPath(const Size(100, 100));

      expect(path.computeMetrics().isNotEmpty, isTrue);
      expect(path.getBounds().width, closeTo(100, 5));
    });
  });

  group('Material4ProgressBar Widget Rendering Tests', () {
    testWidgets('Renders classic and capsule linear progress bars',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Material4ProgressBar(
                    value: 0.65,
                    style: Material4ProgressStyle.classicLinear,
                    height: 10,
                  ),
                  Material4ProgressBar(
                    value: 0.40,
                    style: Material4ProgressStyle.capsuleLinear,
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Material4ProgressBar), findsNWidgets(2));
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('Renders circular and ring progress indicators',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Row(
                children: [
                  Material4ProgressBar(
                    value: 0.75,
                    style: Material4ProgressStyle.ring,
                    width: 50,
                    height: 50,
                  ),
                  Material4ProgressBar(
                    value: 0.50,
                    style: Material4ProgressStyle.roundedCircular,
                    width: 60,
                    height: 60,
                  ),
                  Material4ProgressBar(
                    value: 0.30,
                    style: Material4ProgressStyle.dottedRing,
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Material4ProgressBar), findsNWidgets(3));
    });

    testWidgets('Renders all factory constructors cleanly without error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Material4ProgressBar.linear(value: 0.5),
                  Material4ProgressBar.circular(value: 0.7),
                  Material4ProgressBar.wave(value: 0.6),
                  Material4ProgressBar.liquid(value: 0.4),
                  Material4ProgressBar.segmented(value: 0.65),
                  Material4ProgressBar.neon(value: 0.8),
                  Material4ProgressBar.glass(value: 0.45),
                  Material4ProgressBar.sculpted(value: 0.55),
                  Material4ProgressBar.organic(value: 0.35),
                  Material4ProgressBar.step(value: 0.6),
                  Material4ProgressBar.indeterminate(),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Material4ProgressBar), findsNWidgets(11));
    });

    testWidgets('Indeterminate mode runs continuous sweep without crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Material4ProgressBar(
              value: null, // Indeterminate
              style: Material4ProgressStyle.capsuleLinear,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(Material4ProgressBar), findsOneWidget);
    });

    testWidgets('Multi-color progress resolves color thresholds properly',
        (WidgetTester tester) async {
      final fill = Material4ProgressFill(
        color: Colors.blue,
        multiColors: {
          0.3: Colors.green,
          0.7: Colors.orange,
          0.9: Colors.red,
        },
      );

      expect(fill.resolveColor(0.2, Colors.blue), equals(Colors.blue));
      expect(fill.resolveColor(0.5, Colors.blue), equals(Colors.green));
      expect(fill.resolveColor(0.8, Colors.blue), equals(Colors.orange));
      expect(fill.resolveColor(0.95, Colors.blue), equals(Colors.red));
    });
  });

  group('Smooth Interruptible Animation & Transition Tests', () {
    testWidgets('Smoothly animates between values and interrupts mid-animation',
        (WidgetTester tester) async {
      var currentValue = 0.2;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    Material4ProgressBar(
                      value: currentValue,
                      animation: const Material4ProgressAnimation(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linear,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => currentValue = 0.8);
                      },
                      child: const Text('Animate to 0.8'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => currentValue = 0.4);
                      },
                      child: const Text('Interrupt to 0.4'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
      await tester.pump();

      // Trigger first animation to 0.8
      await tester.tap(find.text('Animate to 0.8'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200)); // Halfway through

      // Interrupt mid-flight to 0.4
      await tester.tap(find.text('Interrupt to 0.4'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.byType(Material4ProgressBar), findsOneWidget);
    });
  });

  group('Programmatic Controller Tests', () {
    testWidgets('Material4ProgressController controls progress value and state',
        (WidgetTester tester) async {
      final controller = Material4ProgressController(initialValue: 0.1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4ProgressBar(
              controller: controller,
              animation: const Material4ProgressAnimation(
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(controller.value, equals(0.1));
      expect(controller.isIndeterminate, isFalse);

      // Jump to 0.75
      controller.jumpTo(0.75);
      await tester.pump();
      expect(controller.value, equals(0.75));

      // Animate to 0.90
      controller.animateTo(0.90);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(controller.value, equals(0.90));

      // Switch to indeterminate
      controller.setIndeterminate(true);
      await tester.pump();
      expect(controller.isIndeterminate, isTrue);

      // Play, pause, stop
      controller.pause();
      expect(controller.isPlaying, isFalse);
      controller.resume();
      expect(controller.isPlaying, isTrue);
      controller.stop();
      expect(controller.value, equals(0.0));

      // Morph shape
      controller.morphTo(Material4ProgressShape.squircle());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(controller.currentShape?.id, contains('squircle'));
    });
  });

  group('Interactive Seeking & Gestures Tests', () {
    testWidgets('Drag gesture seeks progress and triggers onChanged callback',
        (WidgetTester tester) async {
      double? changedVal;
      double? startVal;
      double? endVal;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 20,
                child: Material4ProgressBar(
                  value: 0.0,
                  interaction: Material4ProgressInteraction(
                    enabled: true,
                    min: 0.0,
                    max: 100.0,
                    step: 5.0,
                    onChanged: (val) => changedVal = val,
                    onChangeStart: (val) => startVal = val,
                    onChangeEnd: (val) => endVal = val,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final progressBarFinder = find.byType(Material4ProgressBar);
      expect(progressBarFinder, findsOneWidget);

      // Drag from left edge to half width (100px out of 200px = 50%)
      await tester.dragFrom(
        tester.getTopLeft(progressBarFinder),
        const Offset(100, 10),
      );
      await tester.pump();

      expect(changedVal, isNotNull);
      expect(changedVal!, closeTo(50.0, 10.0));
      expect(startVal, isNotNull);
      expect(endVal, isNotNull);
    });
  });

  group('Labels & Accessibility Tests', () {
    testWidgets('Displays formatted percentage and header text cleanly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4ProgressBar(
              value: 0.65,
              label: Material4ProgressLabel.header(
                title: 'Downloading Assets',
                showPercentage: true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Downloading Assets'), findsOneWidget);
      expect(find.text('65%'), findsOneWidget);
    });

    testWidgets('Exposes accessible Semantics node with progress value',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Material4ProgressBar(
              value: 0.85,
              semanticLabel: 'Upload Progress',
            ),
          ),
        ),
      );
      await tester.pump();

      final semantics = tester.getSemantics(find.byType(Material4ProgressBar));
      expect(semantics.label, equals('Upload Progress'));
      expect(semantics.value, equals('85%'));
    });
  });
}
