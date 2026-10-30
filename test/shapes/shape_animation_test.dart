import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 3: Animation Engine & Controller Tests', () {
    testWidgets('ShapeAnimationController lifecycle and disposal safety', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox())),
      );

      final vsync = tester;
      final controller = ShapeAnimationController(
        vsync: vsync,
        initialConfig: DynamicShapeConfig.folderTab(),
      );

      expect(controller.isDisposed, isFalse);
      expect(controller.strokeDrawProgress, 1.0);
      expect(controller.morphProgress, 0.0);
      expect(controller.pressProgress, 0.0);

      // Trigger pulse
      controller.startPulse(duration: const Duration(milliseconds: 500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.pulseProgress, greaterThan(0.0));

      controller.stopPulse();
      expect(controller.pulseProgress, 0.0);

      // Trigger press and release
      controller.press();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(controller.pressProgress, greaterThan(0.0));

      controller.release();
      await tester.pumpAndSettle();
      expect(controller.pressProgress, closeTo(0.0, 0.01));

      // Dispose controller
      controller.dispose();
      expect(controller.isDisposed, isTrue);

      // Calling methods after dispose does not throw or crash
      expect(() => controller.press(), returnsNormally);
      expect(() => controller.release(), returnsNormally);
      expect(() => controller.stopPulse(), returnsNormally);
      expect(
        () => controller.morphTo(DynamicShapeConfig.shield()),
        returnsNormally,
      );
    });

    testWidgets('ShapeAnimationController morphTo interpolates smoothly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox())),
      );

      final controller = ShapeAnimationController(
        vsync: tester,
        initialConfig: const DynamicShapeConfig(
          cornerRadius: 10.0,
          tabWidth: 40.0,
        ),
      );

      controller.morphTo(
        const DynamicShapeConfig(cornerRadius: 30.0, tabWidth: 80.0),
        duration: const Duration(milliseconds: 400),
      );

      // Start tick and advance to midway
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(controller.currentConfig.cornerRadius, greaterThan(10.0));
      expect(controller.currentConfig.cornerRadius, lessThan(30.0));

      // Settle
      await tester.pumpAndSettle();
      expect(controller.currentConfig.cornerRadius, closeTo(30.0, 0.1));
      expect(controller.currentConfig.tabWidth, closeTo(80.0, 0.1));

      controller.dispose();
    });

    testWidgets('Reduced motion instantly snaps without animation delay', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox())),
      );

      final controller = ShapeAnimationController(
        vsync: tester,
        initialConfig: const DynamicShapeConfig(cornerRadius: 12.0),
        respectReducedMotion: true,
      );

      controller.morphTo(
        const DynamicShapeConfig(cornerRadius: 36.0),
        reducedMotion: true,
      );

      // Snapped immediately without pumping time
      expect(controller.currentConfig.cornerRadius, 36.0);
      controller.dispose();
    });

    testWidgets('ShapePressable reacts to pointer down and up with spring', (
      tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShapePressable(
              onTap: () => tapped = true,
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Tap Me')),
      );
      await tester.pump(const Duration(milliseconds: 60));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('ShapeReveal unmasks with expanding circular clip', (
      tester,
    ) async {
      final animController = AnimationController(
        vsync: tester,
        duration: const Duration(milliseconds: 300),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShapeReveal(
              progress: animController,
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Text('Revealed'),
              ),
            ),
          ),
        ),
      );

      animController.value = 0.5;
      await tester.pump();
      expect(find.text('Revealed'), findsOneWidget);

      animController.value = 1.0;
      await tester.pump();
      expect(find.text('Revealed'), findsOneWidget);

      animController.dispose();
    });

    testWidgets('ShapeBorderDrawReveal renders stroke progressively', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShapeBorderDrawReveal(
              size: Size(120, 80),
              progress: 0.65,
              borderColor: Colors.purple,
              borderWidth: 2.5,
              child: Text('Draw Border'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Draw Border'), findsOneWidget);
    });

    testWidgets('ShapeStaggeredGroup animates cascade delay for items', (
      tester,
    ) async {
      final animController = AnimationController(
        vsync: tester,
        duration: const Duration(milliseconds: 500),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShapeStaggeredGroup(
              animation: animController,
              children: const [Text('Item 1'), Text('Item 2'), Text('Item 3')],
            ),
          ),
        ),
      );

      animController.forward();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Item 1'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Item 3'), findsOneWidget);

      animController.dispose();
    });
  });
}
