import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_shape/dynamic_shape.dart';

void main() {
  group('ShapeGeometryInterpolator Unit Tests', () {
    test('ShapeRadius and ShapeCorners interpolation (circular and elliptical)',
        () {
      const cornersA = ShapeCorners(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(20.0),
        bottomRight: Radius.circular(30.0),
        bottomLeft: Radius.circular(40.0),
      );

      const cornersB = ShapeCorners(
        topLeft: Radius.elliptical(30.0, 50.0),
        topRight: Radius.elliptical(40.0, 60.0),
        bottomRight: Radius.elliptical(50.0, 70.0),
        bottomLeft: Radius.elliptical(60.0, 80.0),
      );

      // Midpoint t = 0.5
      final midpoint = ShapeCorners.lerp(cornersA, cornersB, 0.5);

      expect(midpoint.topLeft.x, closeTo(20.0, 0.001));
      expect(midpoint.topLeft.y, closeTo(30.0, 0.001));
      expect(midpoint.topRight.x, closeTo(30.0, 0.001));
      expect(midpoint.topRight.y, closeTo(40.0, 0.001));
      expect(midpoint.bottomRight.x, closeTo(40.0, 0.001));
      expect(midpoint.bottomRight.y, closeTo(50.0, 0.001));
      expect(midpoint.bottomLeft.x, closeTo(50.0, 0.001));
      expect(midpoint.bottomLeft.y, closeTo(60.0, 0.001));

      // Boundary values
      expect(ShapeCorners.lerp(cornersA, cornersB, 0.0), equals(cornersA));
      expect(ShapeCorners.lerp(cornersA, cornersB, 1.0), equals(cornersB));
    });

    test('ShapeTransform interpolation with shortest angular arc', () {
      const transformA = ShapeTransform(
        rotation: 0.1,
        scaleX: 1.0,
        scaleY: 1.0,
        skewX: 0.0,
        skewY: 0.0,
        origin: Alignment.topLeft,
      );

      const transformB = ShapeTransform(
        rotation: 0.5,
        scaleX: 1.5,
        scaleY: 2.0,
        skewX: 0.2,
        skewY: 0.4,
        origin: Alignment.bottomRight,
      );

      final lerped = ShapeTransform.lerp(transformA, transformB, 0.5);

      expect(lerped.rotation, closeTo(0.3, 0.001));
      expect(lerped.scaleX, closeTo(1.25, 0.001));
      expect(lerped.scaleY, closeTo(1.5, 0.001));
      expect(lerped.skewX, closeTo(0.1, 0.001));
      expect(lerped.skewY, closeTo(0.2, 0.001));
      expect(lerped.origin, equals(Alignment.center));
    });

    test('ShapeNotch interpolation with same polarity and opposite polarity',
        () {
      const notchA = ShapeNotch(
        edge: ShapeEdge.top,
        positionFactor: 0.2,
        width: 40.0,
        depth: 20.0,
        isInward: true,
      );

      const notchB = ShapeNotch(
        edge: ShapeEdge.top,
        positionFactor: 0.8,
        width: 80.0,
        depth: 40.0,
        isInward: true,
      );

      // Same polarity midpoint
      final sameLerp = ShapeNotch.lerp(notchA, notchB, 0.5);
      expect(sameLerp.positionFactor, closeTo(0.5, 0.001));
      expect(sameLerp.width, closeTo(60.0, 0.001));
      expect(sameLerp.depth, closeTo(30.0, 0.001));
      expect(sameLerp.isInward, isTrue);

      // Opposite polarity transition (inward -> outward tab)
      final notchOutward = notchB.copyWith(isInward: false);

      // At t = 0.25, depth shrinks toward 0 while still inward
      final midInward = ShapeNotch.lerp(notchA, notchOutward, 0.25);
      expect(midInward.isInward, isTrue);
      expect(midInward.depth, closeTo(10.0, 0.001));

      // At t = 0.75, depth grows from 0 with new outward polarity
      final midOutward = ShapeNotch.lerp(notchA, notchOutward, 0.75);
      expect(midOutward.isInward, isFalse);
      expect(midOutward.depth, closeTo(20.0, 0.001));
    });

    test('ShapeNotch.lerpList handles differing notch counts', () {
      final listA = [
        const ShapeNotch(edge: ShapeEdge.top, width: 60.0, depth: 30.0),
      ];
      final listB = [
        const ShapeNotch(edge: ShapeEdge.top, width: 60.0, depth: 30.0),
        const ShapeNotch(edge: ShapeEdge.bottom, width: 40.0, depth: 20.0),
      ];

      final lerped = ShapeNotch.lerpList(listA, listB, 0.5);
      expect(lerped.length, equals(2));
      // First notch unchanged
      expect(lerped[0].depth, closeTo(30.0, 0.001));
      // Second notch expanding from 0 to 20 -> at t=0.5 depth is 10.0
      expect(lerped[1].depth, closeTo(10.0, 0.001));
      expect(lerped[1].width, closeTo(20.0, 0.001));
    });

    test('DynamicShapeConfig.lerp interpolates all core parameters cleanly',
        () {
      const configA = DynamicShapeConfig(
        cornerRadius: 10.0,
        tabWidth: 50.0,
        tabHeight: 25.0,
        waveAmplitude: 6.0,
        waveCount: 2.0,
        skewAngle: 0.1,
      );

      const configB = DynamicShapeConfig(
        cornerRadius: 30.0,
        tabWidth: 90.0,
        tabHeight: 45.0,
        waveAmplitude: 14.0,
        waveCount: 6.0,
        skewAngle: 0.5,
      );

      final lerped = DynamicShapeConfig.lerp(configA, configB, 0.5);

      expect(lerped.cornerRadius, closeTo(20.0, 0.001));
      expect(lerped.tabWidth, closeTo(70.0, 0.001));
      expect(lerped.tabHeight, closeTo(35.0, 0.001));
      expect(lerped.waveAmplitude, closeTo(10.0, 0.001));
      expect(lerped.waveCount, closeTo(4.0, 0.001));
      expect(lerped.skewAngle, closeTo(0.3, 0.001));
    });
  });

  group('ShapeMorphEngine Unit Tests', () {
    test(
        'Morph compatibility classification identifies compatible shape families',
        () {
      // Rounded / Squircle family
      expect(
        ShapeMorphEngine.canMorphGeometrically(
          DynamicShapeType.capsule,
          DynamicShapeType.squircle,
        ),
        isTrue,
      );
      expect(
        ShapeMorphEngine.canMorphGeometrically(
          DynamicShapeType.smoothRounded,
          DynamicShapeType.asymmetricCard,
        ),
        isTrue,
      );

      // Notched / Tabbed family
      expect(
        ShapeMorphEngine.canMorphGeometrically(
          DynamicShapeType.smoothRounded,
          DynamicShapeType.ticketScallop,
        ),
        isTrue,
      );
      expect(
        ShapeMorphEngine.canMorphGeometrically(
          DynamicShapeType.ticketScallop,
          DynamicShapeType.notchedBadge,
        ),
        isTrue,
      );

      // Polygons family
      expect(
        ShapeMorphEngine.canMorphGeometrically(
          DynamicShapeType.diamond,
          DynamicShapeType.octagon,
        ),
        isTrue,
      );
      expect(
        ShapeMorphEngine.canMorphGeometrically(
          DynamicShapeType.shield,
          DynamicShapeType.hexagonSoft,
        ),
        isTrue,
      );

      // Incompatible topologies
      expect(
        ShapeMorphEngine.canMorphGeometrically(
          DynamicShapeType.octagon,
          DynamicShapeType.folderTab,
        ),
        isFalse,
      );
    });

    test(
        'Normalized sampling morph generates continuous vector paths for arbitrary shapes',
        () {
      const fromConfig = DynamicShapeConfig(type: DynamicShapeType.octagon);
      const toConfig = DynamicShapeConfig(type: DynamicShapeType.folderTab);
      const size = Size(200.0, 200.0);

      final pathAt0 = ShapeMorphEngine.computeMorphedPath(
        fromConfig: fromConfig,
        toConfig: toConfig,
        size: size,
        progress: 0.0,
      );
      expect(pathAt0.getBounds().isEmpty, isFalse);

      final pathAt50 = ShapeMorphEngine.computeMorphedPath(
        fromConfig: fromConfig,
        toConfig: toConfig,
        size: size,
        progress: 0.5,
        fallback: ShapeMorphFallback.compatibleNormalized,
      );
      expect(pathAt50.getBounds().isEmpty, isFalse);

      final pathAt100 = ShapeMorphEngine.computeMorphedPath(
        fromConfig: fromConfig,
        toConfig: toConfig,
        size: size,
        progress: 1.0,
      );
      expect(pathAt100.getBounds().isEmpty, isFalse);
    });
  });

  group('ShapePhysicsSimulation Unit Tests', () {
    test('Physics presets configure valid springs and simulations', () {
      const styles = ShapePhysicsStyle.values;
      for (final style in styles) {
        final physics = ShapePhysicsSimulation.fromStyle(style);
        expect(physics.mass, greaterThan(0.0));
        expect(physics.stiffness, greaterThan(0.0));
        expect(physics.damping, greaterThan(0.0));

        final sim = physics.createSimulation(start: 0.0, end: 1.0);
        expect(sim.x(0.0), closeTo(0.0, 0.001));
        // Verify the simulation settles over time
        expect(sim.x(5.0), closeTo(1.0, 0.05));
      }
    });
  });

  group('ShapeAnimationController Unit Tests', () {
    testWidgets('Controller morphTo updates currentConfig smoothly',
        (tester) async {
      final controller = ShapeAnimationController(
        vsync: tester,
        initialConfig: const DynamicShapeConfig(cornerRadius: 10.0),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicShapeContainer(
              controller: controller,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      expect(controller.currentConfig.cornerRadius, equals(10.0));

      controller.morphTo(
        const DynamicShapeConfig(cornerRadius: 30.0),
        duration: const Duration(milliseconds: 200),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.currentConfig.cornerRadius, greaterThan(10.0));
      expect(controller.currentConfig.cornerRadius, lessThan(30.0));

      await tester.pumpAndSettle();
      expect(controller.currentConfig.cornerRadius, closeTo(30.0, 0.01));
      expect(controller.isAnimating, isFalse);

      controller.dispose();
    });

    testWidgets(
        'Interrupted morph transitions smoothly from active state without jump',
        (tester) async {
      final controller = ShapeAnimationController(
        vsync: tester,
        initialConfig: const DynamicShapeConfig(cornerRadius: 10.0),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicShapeContainer(
              controller: controller,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      // Start morph to 40.0
      controller.morphTo(
        const DynamicShapeConfig(cornerRadius: 40.0),
        duration: const Duration(milliseconds: 400),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      final midRadius = controller.currentConfig.cornerRadius;
      expect(midRadius, greaterThan(15.0));

      // Interrupt with new target 80.0
      controller.morphTo(
        const DynamicShapeConfig(cornerRadius: 80.0),
        duration: const Duration(milliseconds: 400),
      );

      // Immediate next frame must start from midRadius, not snap to 10.0 or 40.0
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      expect(controller.currentConfig.cornerRadius, closeTo(midRadius, 2.0));

      await tester.pumpAndSettle();
      expect(controller.currentConfig.cornerRadius, closeTo(80.0, 0.01));

      controller.dispose();
    });

    testWidgets('Reversing morph transition returns to previous configuration',
        (tester) async {
      final controller = ShapeAnimationController(
        vsync: tester,
        initialConfig: const DynamicShapeConfig(cornerRadius: 10.0),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicShapeContainer(
              controller: controller,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      controller.morphTo(
        const DynamicShapeConfig(cornerRadius: 50.0),
        duration: const Duration(milliseconds: 200),
      );
      await tester.pumpAndSettle();
      expect(controller.currentConfig.cornerRadius, closeTo(50.0, 0.01));

      controller.reverseMorph(duration: const Duration(milliseconds: 200));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.currentConfig.cornerRadius, lessThan(50.0));

      await tester.pumpAndSettle();
      expect(controller.currentConfig.cornerRadius, closeTo(10.0, 0.01));

      controller.dispose();
    });
  });

  group('ShapeAnimationSequence Tests', () {
    testWidgets('Multi-step sequence executes steps in designated order',
        (tester) async {
      final controller = ShapeAnimationController(
        vsync: tester,
        initialConfig: const DynamicShapeConfig(cornerRadius: 0.0),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicShapeContainer(
              controller: controller,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      final sequence = ShapeAnimationSequence.builder()
          .then(
            config: const DynamicShapeConfig(cornerRadius: 20.0),
            duration: const Duration(milliseconds: 100),
          )
          .then(
            config: const DynamicShapeConfig(cornerRadius: 50.0),
            duration: const Duration(milliseconds: 100),
          );

      expect(sequence.steps.length, equals(2));

      final future = controller.runSequence(sequence);

      // Advance through first step
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.currentConfig.cornerRadius, closeTo(20.0, 1.0));

      // Advance through second step
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      await future;
      expect(controller.currentConfig.cornerRadius, closeTo(50.0, 1.0));

      controller.dispose();
    });
  });

  group('Reduced Motion & Accessibility Tests', () {
    testWidgets(
        'Reduced motion preference causes immediate target state application',
        (tester) async {
      final controller = ShapeAnimationController(
        vsync: tester,
        initialConfig: const DynamicShapeConfig(cornerRadius: 10.0),
        respectReducedMotion: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicShapeContainer(
              controller: controller,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      controller.morphTo(
        const DynamicShapeConfig(cornerRadius: 45.0),
        duration: const Duration(milliseconds: 500),
        reducedMotion: true,
      );

      // Target state should be applied immediately without ticking
      expect(controller.currentConfig.cornerRadius, equals(45.0));

      controller.dispose();
    });

    testWidgets(
        'AnimatedDynamicShapeContainer honors disableAnimations in MediaQuery',
        (tester) async {
      double targetCornerRadius = 10.0;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Center(
                    child: AnimatedDynamicShapeContainer(
                      duration: const Duration(milliseconds: 400),
                      config:
                          DynamicShapeConfig(cornerRadius: targetCornerRadius),
                      width: 100,
                      height: 100,
                      onTap: () {
                        setState(() {
                          targetCornerRadius = 50.0;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AnimatedDynamicShapeContainer));
      await tester.pump();

      // Because animations are disabled, next immediate frame carries final target value
      final renderBox = tester.renderObject<RenderDynamicShape>(
        find.byType(DynamicShapeRenderWidget),
      );
      expect(renderBox.config.cornerRadius, equals(50.0));
    });
  });

  group('Public Animation Widgets Integration Tests', () {
    testWidgets('ShapeMorphTransition renders and transitions between shapes',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ShapeMorphTransition(
                from: DynamicShapeType.capsule,
                to: DynamicShapeType.squircle,
                duration: Duration(milliseconds: 300),
                width: 150,
                height: 150,
                child: Text('Morph Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Morph Content'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byType(DynamicShapeContainer), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Morph Content'), findsOneWidget);
    });

    testWidgets('DynamicShapeContainer with animation config morphs implicitly',
        (tester) async {
      DynamicShapeType activeShape = DynamicShapeType.smoothRounded;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Center(
                  child: DynamicShapeContainer(
                    shape: activeShape,
                    animation: const ShapeAnimationConfig(
                      duration: Duration(milliseconds: 300),
                    ),
                    width: 200,
                    height: 200,
                    onTap: () {
                      setState(() {
                        activeShape = DynamicShapeType.asymmetricCard;
                      });
                    },
                    child: const Text('Tap to Morph'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(AnimatedDynamicShapeContainer), findsOneWidget);
      await tester.tap(find.text('Tap to Morph'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(find.text('Tap to Morph'), findsOneWidget);
    });
  });

  group('RenderBox Invalidation & Mid-Animation Hit Testing', () {
    testWidgets(
        'Hit testing during animation reflects active interpolated contour',
        (tester) async {
      final controller = ShapeAnimationController(
        vsync: tester,
        // Start as diamond (where top-left (10, 10) is outside the diamond)
        initialConfig: const DynamicShapeConfig(type: DynamicShapeType.diamond),
      );

      bool containerTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: DynamicShapeContainer(
                controller: controller,
                width: 200,
                height: 200,
                onTap: () {
                  containerTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      // In diamond shape, top-left corner (10, 10) misses
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(containerTapped, isFalse);

      // Now animate to smoothRounded with cornerRadius 0 (full rectangle)
      controller.animateConfig(
        const DynamicShapeConfig(
          type: DynamicShapeType.smoothRounded,
          cornerRadius: 0.0,
        ),
        duration: const Duration(milliseconds: 400),
      );

      // Advance to completion
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // In rectangle, top-left (10, 10) now hits
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(containerTapped, isTrue);

      controller.dispose();
    });

    testWidgets(
        'Corner, notch, and transform individual animations execute accurately',
        (tester) async {
      final controller = ShapeAnimationController(
        vsync: tester,
        initialConfig: const DynamicShapeConfig(
          corners: ShapeCorners.all(Radius.circular(10.0)),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DynamicShapeContainer(
              controller: controller,
              width: 150,
              height: 150,
            ),
          ),
        ),
      );

      // 1. Independent corner animation
      controller.animateCorners(
        const ShapeCorners.all(Radius.circular(40.0)),
        duration: const Duration(milliseconds: 200),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(controller.currentConfig.resolvedCorners.topLeft.x,
          closeTo(40.0, 0.01));

      // 2. Independent notch animation
      controller.animateNotch(
        [const ShapeNotch(edge: ShapeEdge.top, width: 50.0, depth: 30.0)],
        duration: const Duration(milliseconds: 200),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(
          controller.currentConfig.notches?.first.depth, closeTo(30.0, 0.01));

      // 3. Independent transform animation
      controller.animateTransform(
        const ShapeTransform(scaleX: 1.5, scaleY: 1.2),
        duration: const Duration(milliseconds: 200),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(controller.currentConfig.resolvedTransform.scaleX,
          closeTo(1.5, 0.01));
      expect(controller.currentConfig.resolvedTransform.scaleY,
          closeTo(1.2, 0.01));

      controller.dispose();
    });
  });
}
