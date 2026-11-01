import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Universal Next-Gen Shapes Vector Path Tests', () {
    const testSize = Size(240, 160);

    const newShapes = [
      Material4Type.superellipse,
      Material4Type.continuousSquircle,
      Material4Type.asymmetricBlob,
      Material4Type.softDiamond,
      Material4Type.roundedHexagon,
      Material4Type.roundedPentagon,
      Material4Type.ticket,
      Material4Type.flower,
      Material4Type.starburst,
      Material4Type.leaf,
      Material4Type.droplet,
      Material4Type.liquid,
    ];

    for (final shape in newShapes) {
      test('Shape $shape generates valid non-empty closed path with finite bounds', () {
        final config = Material4Config(type: shape);
        final path = Material4PathBuilder.buildPath(testSize, config);

        expect(path, isNotNull);
        final bounds = path.getBounds();
        expect(bounds.isEmpty, isFalse, reason: '$shape bounds should not be empty');
        expect(bounds.width, greaterThan(0.0));
        expect(bounds.height, greaterThan(0.0));
        expect(bounds.left.isFinite, isTrue);
        expect(bounds.right.isFinite, isTrue);
        expect(bounds.top.isFinite, isTrue);
        expect(bounds.bottom.isFinite, isTrue);
      });

      test('Shape $shape handles zero and degenerate dimensions gracefully without throw', () {
        final config = Material4Config(type: shape);
        expect(() => Material4PathBuilder.buildPath(Size.zero, config), returnsNormally);
        expect(() => Material4PathBuilder.buildPath(const Size(-100, -50), config), returnsNormally);
        expect(() => Material4PathBuilder.buildPath(const Size(200, 0), config), returnsNormally);
      });
    }
  });

  group('Custom Shape Builder & Fluent Vector Geometry Tests', () {
    const testSize = Size(300, 200);

    test('Material4CustomShape.polygon generates regular and rounded polygons', () {
      final triangle = Material4CustomShape.polygon(sides: 3, cornerRadius: 0);
      final trianglePath = triangle.buildPath(testSize);
      expect(trianglePath.getBounds().isEmpty, isFalse);

      final roundedOctagon = Material4CustomShape.polygon(sides: 8, cornerRadius: 12.0);
      final octPath = roundedOctagon.buildPath(testSize);
      expect(octPath.getBounds().isEmpty, isFalse);
    });

    test('Material4CustomShape.star generates valid points', () {
      final star5 = Material4CustomShape.star(points: 5, innerRadiusRatio: 0.4);
      final starPath = star5.buildPath(testSize);
      expect(starPath.getBounds().isEmpty, isFalse);
    });

    test('Material4CustomShape.superellipse generates smooth lamé curves', () {
      final superellipse = Material4CustomShape.superellipse(n: 4.5);
      final path = superellipse.buildPath(testSize);
      expect(path.getBounds().isEmpty, isFalse);
    });

    test('Material4CustomShape.corners handles independent asymmetric radii', () {
      final asymmetric = Material4CustomShape.corners(
        topLeft: 32.0,
        topRight: 8.0,
        bottomRight: 24.0,
        bottomLeft: 0.0,
      );
      final path = asymmetric.buildPath(testSize);
      expect(path.getBounds().isEmpty, isFalse);
    });

    test('Material4ShapeBuilder fluent composition with notches, bulges, and matrix', () {
      final custom = Material4CustomShape.builder((size) {
        return Material4ShapeBuilder()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..addConcaveNotch(
            Offset(size.width, 20),
            Offset(size.width, 80),
            20.0,
          )
          ..addConvexBulge(
            Offset(size.width, size.height),
            Offset(0, size.height),
            15.0,
          )
          ..close();
      });

      final path = custom.buildPath(testSize);
      expect(path.getBounds().isEmpty, isFalse);
    });
  });

  group('Shape Morphing Engine Tests', () {
    test('ShapeMorphEngine.morphPaths produces valid interpolations between shapes', () {
      final pathA = Path()..addRect(const Rect.fromLTWH(0, 0, 100, 100));
      final pathB = Path()..addOval(const Rect.fromLTWH(0, 0, 100, 100));

      final midPath = ShapeMorphEngine.morphPaths(pathA, pathB, 0.5);
      expect(midPath, isNotNull);
      final bounds = midPath.getBounds();
      expect(bounds.isEmpty, isFalse);
      expect(bounds.width, greaterThan(20.0));
      expect(bounds.height, greaterThan(20.0));
    });

    test('Material4CustomShape.morph interpolates between Material4Type presets', () {
      final morphed = Material4CustomShape.morph(
        from: Material4Type.smoothRounded,
        to: Material4Type.superellipse,
        progress: 0.5,
        physics: Curves.easeInOut,
      );

      final path = morphed.buildPath(const Size(150, 150));
      expect(path.getBounds().isEmpty, isFalse);
    });

    test('Material4MorphController coordinates programmatic transitions', () {
      final controller = Material4MorphController(
        initialShape: Material4Type.smoothRounded,
      );

      expect(controller.currentShape, Material4Type.smoothRounded);
      expect(controller.isAnimating, isFalse);

      controller.morphTo(Material4Type.superellipse);
      expect(controller.targetShape, Material4Type.superellipse);
      expect(controller.isAnimating, isTrue);

      controller.setProgress(0.65);
      expect(controller.morphProgress, 0.65);

      final currentShape = controller.currentCustomShape;
      expect(currentShape, isNotNull);
      expect(currentShape.buildPath(const Size(100, 100)).getBounds().isEmpty, isFalse);

      controller.completeMorph();
      expect(controller.currentShape, Material4Type.superellipse);
      expect(controller.isAnimating, isFalse);
      expect(controller.morphProgress, 1.0);

      controller.dispose();
      expect(controller.isDisposed, isTrue);
    });
  });

  group('Animated Border System Tests', () {
    const testSize = Size(200, 120);

    const animatedBorderStyles = [
      BorderStyleType.flowingBorder,
      BorderStyleType.movingDash,
      BorderStyleType.pulsatingBorder,
      BorderStyleType.liquidBorder,
      BorderStyleType.waveBorder,
      BorderStyleType.zigzagBorder,
      BorderStyleType.particleBorder,
      BorderStyleType.orbitingLightBorder,
      BorderStyleType.dualLayerBorder,
      BorderStyleType.shimmerBorder,
      BorderStyleType.conicGradientBorder,
      BorderStyleType.energyBorder,
    ];

    for (final style in animatedBorderStyles) {
      test('Border style $style renders cleanly across progress states', () {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        final config = Material4Config(
          type: Material4Type.superellipse,
          borderStyle: style,
          borderProgress: 0.45,
        );
        final path = Material4PathBuilder.buildPath(testSize, config);

        expect(
          () => ShapeBorderPainter.paintBorder(
            canvas: canvas,
            size: testSize,
            path: path,
            config: config,
            borderColor: Colors.indigo,
            borderWidth: 2.5,
          ),
          returnsNormally,
          reason: 'Failed to paint border $style',
        );

        final picture = recorder.endRecording();
        picture.dispose();
      });
    }

    test('Material4Border factory constructors configure expected parameters', () {
      const neonBorder = Material4Border.neon(
        color: Colors.cyan,
        width: 3.0,
        glowIntensity: 1.5,
      );
      expect(neonBorder.style, BorderStyleType.neonPulse);
      expect(neonBorder.color, Colors.cyan);
      expect(neonBorder.glowIntensity, 1.5);

      const movingDash = Material4Border.movingDash(
        color: Colors.amber,
        dashLength: 12.0,
        dashGap: 6.0,
      );
      expect(movingDash.style, BorderStyleType.movingDash);
      expect(movingDash.dashLength, 12.0);

      const animatedGrad = Material4Border.animatedGradient(
        colors: [Colors.red, Colors.blue],
      );
      expect(animatedGrad.style, BorderStyleType.animatedGradient);
      expect(animatedGrad.colors, isNotNull);
    });
  });

  group('Procedural Texture System Tests', () {
    const testSize = Size(180, 180);
    final clipPath = Path()..addRect(Offset.zero & testSize);

    for (final textureType in Material4TextureType.values) {
      test('Procedural texture $textureType renders cleanly within clip boundaries', () {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        final texture = Material4Texture(
          type: textureType,
          opacity: 0.25,
          scale: 1.2,
          progress: 0.5,
        );

        expect(
          () => Material4TextureRenderer.renderTexture(
            canvas: canvas,
            size: testSize,
            clipPath: clipPath,
            texture: texture,
            animationProgress: 0.5,
          ),
          returnsNormally,
          reason: 'Failed to render texture $textureType',
        );

        final picture = recorder.endRecording();
        picture.dispose();
      });
    }
  });

  group('Procedural Background Pattern System Tests', () {
    const testSize = Size(220, 160);
    final clipPath = Path()..addRect(Offset.zero & testSize);

    for (final patternType in Material4PatternType.values) {
      test('Background pattern $patternType renders cleanly within clip boundaries', () {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        final pattern = Material4Pattern(
          type: patternType,
          opacity: 0.2,
          spacing: 16.0,
          progress: 0.4,
        );

        expect(
          () => Material4PatternRenderer.renderPattern(
            canvas: canvas,
            size: testSize,
            clipPath: clipPath,
            pattern: pattern,
            animationProgress: 0.4,
          ),
          returnsNormally,
          reason: 'Failed to render pattern $patternType',
        );

        final picture = recorder.endRecording();
        picture.dispose();
      });
    }
  });

  group('Material4Container Widget & Preset Composition Tests', () {
    testWidgets('Renders all built-in container presets cleanly', (tester) async {
      final presets = [
        Material4ContainerPreset.glass,
        Material4ContainerPreset.neon,
        Material4ContainerPreset.organicCard,
        Material4ContainerPreset.carbonTech,
        Material4ContainerPreset.liquid,
        Material4ContainerPreset.holographic,
        Material4ContainerPreset.paperCraft,
        Material4ContainerPreset.minimal,
      ];

      for (final preset in presets) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Material4Container.fromPreset(
                  preset: preset,
                  width: 200,
                  height: 120,
                  child: const Text('Preset Test'),
                ),
              ),
            ),
          ),
        );
        expect(find.text('Preset Test'), findsOneWidget);
      }
    });

    testWidgets('Renders custom convenience factory constructors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container.fromPreset(
                preset: Material4ContainerPreset.carbonTech,
                width: 220,
                height: 140,
                child: const Text('Carbon Tech Card'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Carbon Tech Card'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container.fromPreset(
                preset: Material4ContainerPreset.organicCard,
                width: 220,
                height: 140,
                child: const Text('Organic Sculpted Card'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Organic Sculpted Card'), findsOneWidget);
    });

    testWidgets('Respects MediaQuery.disableAnimations (reduced motion accessibility)', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Material4Container(
                  width: 150,
                  height: 150,
                  containerAnimation: const Material4ContainerAnimation.sequence(
                    sequence: [
                      Material4Type.smoothRounded,
                      Material4Type.superellipse,
                      Material4Type.flower,
                    ],
                  ),
                  child: const Text('Accessible Motion'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Accessible Motion'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Accessible Motion'), findsOneWidget);
    });

    testWidgets('Handles interactive user taps properly', (tester) async {
      bool tapped = false;
      bool longPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container(
                width: 160,
                height: 80,
                onTap: () => tapped = true,
                onLongPress: () => longPressed = true,
                child: const Text('Clickable Container'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Clickable Container'));
      await tester.pump();
      expect(tapped, isTrue);

      await tester.longPress(find.text('Clickable Container'));
      await tester.pump();
      expect(longPressed, isTrue);
    });
  });
}
