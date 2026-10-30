import 'dart:ui';

import 'package:material_4/material_4.dart';
import 'package:flutter/material.dart' hide BorderStyle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RenderMaterial4 paintBounds Expansion Tests', () {
    testWidgets('Default zero-border, zero-shadow paintBounds equals size', (
      tester,
    ) async {
      await tester.pumpWidget(
        Center(
          child: Material4RenderWidget(
            config: const Material4Config(
              type: Material4Type.smoothRounded,
            ),
            width: 200,
            height: 100,
            borderWidth: 0,
            borderColor: Colors.transparent,
          ),
        ),
      );

      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      expect(renderBox.size, const Size(200, 100));
      expect(renderBox.paintBounds, const Rect.fromLTWH(0, 0, 200, 100));
    });

    testWidgets('Centered border inflates paintBounds by half border width', (
      tester,
    ) async {
      await tester.pumpWidget(
        Center(
          child: Material4RenderWidget(
            config: const Material4Config(
              type: Material4Type.smoothRounded,
              strokeAlign: ShapeStrokeAlign.center,
            ),
            width: 200,
            height: 100,
            borderWidth: 10,
            borderColor: Colors.black,
          ),
        ),
      );

      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      expect(renderBox.paintBounds, const Rect.fromLTWH(-5, -5, 210, 110));
    });

    testWidgets('Outside border inflates paintBounds by full border width', (
      tester,
    ) async {
      await tester.pumpWidget(
        Center(
          child: Material4RenderWidget(
            config: const Material4Config(
              type: Material4Type.smoothRounded,
              strokeAlign: ShapeStrokeAlign.outside,
            ),
            width: 200,
            height: 100,
            borderWidth: 12,
            borderColor: Colors.black,
          ),
        ),
      );

      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      expect(renderBox.paintBounds, const Rect.fromLTWH(-12, -12, 224, 124));
    });

    testWidgets('Inside border does not inflate paintBounds', (
      tester,
    ) async {
      await tester.pumpWidget(
        Center(
          child: Material4RenderWidget(
            config: const Material4Config(
              type: Material4Type.smoothRounded,
              strokeAlign: ShapeStrokeAlign.inside,
            ),
            width: 200,
            height: 100,
            borderWidth: 12,
            borderColor: Colors.black,
          ),
        ),
      );

      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      expect(renderBox.paintBounds, const Rect.fromLTWH(0, 0, 200, 100));
    });

    testWidgets('Neo-3D hard block offset expands paintBounds', (
      tester,
    ) async {
      await tester.pumpWidget(
        Center(
          child: Material4RenderWidget(
            config: const Material4Config(
              type: Material4Type.smoothRounded,
              borderStyle: BorderStyleType.neo3d,
              neoOffset: Offset(14, 18),
              neoColor: Colors.black,
              strokeAlign: ShapeStrokeAlign.inside,
            ),
            width: 150,
            height: 80,
            borderWidth: 4,
            borderColor: Colors.black,
          ),
        ),
      );

      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      final bounds = renderBox.paintBounds;
      expect(bounds.left, 0.0);
      expect(bounds.top, 0.0);
      expect(bounds.right, greaterThanOrEqualTo(150 + 14));
      expect(bounds.bottom, greaterThanOrEqualTo(80 + 18));
    });

    testWidgets('Ambient glow halo expands paintBounds to contain outer blur', (
      tester,
    ) async {
      await tester.pumpWidget(
        Center(
          child: Material4RenderWidget(
            config: const Material4Config(
              type: Material4Type.smoothRounded,
              borderStyle: BorderStyleType.glow,
              glowBlurRadius: 24,
              glowColor: Colors.cyan,
              strokeAlign: ShapeStrokeAlign.inside,
            ),
            width: 100,
            height: 100,
            borderWidth: 4,
            borderColor: Colors.cyan,
          ),
        ),
      );

      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      final bounds = renderBox.paintBounds;
      expect(bounds.left, lessThan(-24));
      expect(bounds.top, lessThan(-24));
      expect(bounds.right, greaterThan(124));
      expect(bounds.bottom, greaterThan(124));
    });

    testWidgets(
        'Outer drop shadows expand paintBounds to prevent shadow clipping', (
      tester,
    ) async {
      await tester.pumpWidget(
        Center(
          child: Material4RenderWidget(
            config: const Material4Config(
              type: Material4Type.smoothRounded,
              strokeAlign: ShapeStrokeAlign.inside,
            ),
            width: 120,
            height: 80,
            borderWidth: 0,
            borderColor: Colors.transparent,
            shadows: const [
              BoxShadow(
                color: Color(0x66000000),
                offset: Offset(0, 16),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
        ),
      );

      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      final bounds = renderBox.paintBounds;
      expect(bounds.left, lessThan(0));
      expect(bounds.bottom, greaterThanOrEqualTo(80 + 16 + 20));
    });

    testWidgets('Multi-layer borders expand paintBounds by max layer extent', (
      tester,
    ) async {
      await tester.pumpWidget(
        Center(
          child: Material4RenderWidget(
            config: const Material4Config(
              type: Material4Type.smoothRounded,
              borderStyle: BorderStyleType.multiLayer,
              multiLayerBorders: [
                BorderLayer(color: Colors.blue, width: 2, offset: 0),
                BorderLayer(color: Colors.green, width: 3, offset: 8),
                BorderLayer(color: Colors.red, width: 4, offset: 16),
              ],
              strokeAlign: ShapeStrokeAlign.inside,
            ),
            width: 140,
            height: 90,
            borderWidth: 2,
            borderColor: Colors.blue,
          ),
        ),
      );

      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      final bounds = renderBox.paintBounds;
      // Max layer extent is 16 offset + 4 width = 20
      expect(bounds.left, -20.0);
      expect(bounds.top, -20.0);
      expect(bounds.right, 140 + 20.0);
      expect(bounds.bottom, 90 + 20.0);
    });
  });

  group('Direct Canvas Rendering Pipeline Stages', () {
    test('All discrete stage methods can be called independently without error',
        () {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const testSize = Size(200, 100);
      const config = Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 16,
        borderStyle: BorderStyleType.solid,
        pattern: ShapePattern.diagonalStripes,
        innerShadows: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
        isShimmering: true,
        shimmerProgress: 0.5,
      );
      final path = Material4PathBuilder.buildPath(testSize, config);

      expect(
        () => Material4Painter.paintOuterShadows(
          canvas: canvas,
          size: testSize,
          path: path,
          config: config,
          shadows: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        returnsNormally,
      );

      expect(
        () => Material4Painter.paintBackground(
          canvas: canvas,
          size: testSize,
          path: path,
          config: config,
          color: Colors.blue,
          gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
        ),
        returnsNormally,
      );

      expect(
        () => Material4Painter.paintPatterns(
          canvas: canvas,
          size: testSize,
          path: path,
          config: config,
          color: Colors.blue,
        ),
        returnsNormally,
      );

      expect(
        () => Material4Painter.paintInnerShadows(
          canvas: canvas,
          size: testSize,
          path: path,
          config: config,
        ),
        returnsNormally,
      );

      expect(
        () => Material4Painter.paintBorders(
          canvas: canvas,
          size: testSize,
          path: path,
          config: config,
          borderColor: Colors.teal,
          borderWidth: 2,
        ),
        returnsNormally,
      );

      expect(
        () => Material4Painter.paintForegroundDecorations(
          canvas: canvas,
          size: testSize,
          path: path,
          config: config,
        ),
        returnsNormally,
      );

      final picture = recorder.endRecording();
      expect(picture, isNotNull);
    });

    test('All procedural background effects execute through painting pipeline',
        () {
      const testSize = Size(160, 90);
      for (final effect in BackgroundEffectType.values) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        final config = Material4Config(
          type: Material4Type.smoothRounded,
          backgroundEffect: effect,
          meshColors: const [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow
          ],
          backgroundProgress: 0.45,
          waveLevel: 0.6,
          particleCount: 8,
        );
        final path = Material4PathBuilder.buildPath(testSize, config);

        expect(
          () => Material4Painter.paintBackground(
            canvas: canvas,
            size: testSize,
            path: path,
            config: config,
            color: Colors.indigo,
          ),
          returnsNormally,
          reason: 'Failed to paint background effect: $effect',
        );

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      }
    });

    test('All procedural pattern styles execute through painting pipeline', () {
      const testSize = Size(150, 80);
      for (final pattern in ShapePattern.values) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        final config = Material4Config(
          type: Material4Type.smoothRounded,
          pattern: pattern,
          patternSpacing: 12,
          patternStrokeWidth: 1.5,
        );
        final path = Material4PathBuilder.buildPath(testSize, config);

        expect(
          () => Material4Painter.paintPatterns(
            canvas: canvas,
            size: testSize,
            path: path,
            config: config,
            color: Colors.white,
          ),
          returnsNormally,
          reason: 'Failed to paint pattern: $pattern',
        );

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      }
    });
  });

  group('Perimeter Stroke Reveal & Border Progress Tests', () {
    test('Solid borderProgress: 0.0, 0.5, and 1.0 render smoothly', () {
      const testSize = Size(180, 100);
      for (final progress in [0.0, 0.25, 0.5, 0.75, 1.0]) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        final config = Material4Config(
          type: Material4Type.smoothRounded,
          borderStyle: BorderStyleType.solid,
          borderProgress: progress,
        );
        final path = Material4PathBuilder.buildPath(testSize, config);

        expect(
          () => Material4Painter.paintBorders(
            canvas: canvas,
            size: testSize,
            path: path,
            config: config,
            borderColor: Colors.blueAccent,
            borderWidth: 3.0,
          ),
          returnsNormally,
          reason: 'Failed at progress: $progress',
        );

        final picture = recorder.endRecording();
        expect(picture, isNotNull);
      }
    });

    test('Dashed and dotted borders respect borderProgress progressive drawing',
        () {
      const testSize = Size(180, 100);
      for (final style in [BorderStyleType.dashed, BorderStyleType.dotted]) {
        for (final progress in [0.0, 0.5, 1.0]) {
          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);
          final config = Material4Config(
            type: Material4Type.smoothRounded,
            borderStyle: style,
            borderProgress: progress,
          );
          final path = Material4PathBuilder.buildPath(testSize, config);

          expect(
            () => Material4Painter.paintBorders(
              canvas: canvas,
              size: testSize,
              path: path,
              config: config,
              borderColor: Colors.orange,
              borderWidth: 2.5,
            ),
            returnsNormally,
          );

          final picture = recorder.endRecording();
          expect(picture, isNotNull);
        }
      }
    });

    testWidgets(
        'ShapeBorderDrawReveal renders through RenderBox pipeline without CustomPaint',
        (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ShapeBorderDrawReveal(
                size: const Size(200, 100),
                progress: 0.7,
                borderColor: Colors.pink,
                borderWidth: 3,
                config: const Material4Config(
                  type: Material4Type.smoothRounded,
                  cornerRadius: 20,
                ),
                child: const Text('Revealed Child'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Revealed Child'), findsOneWidget);
      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      expect(renderBox.config.borderProgress, 0.7);
      expect(renderBox.borderColor, Colors.pink);
      expect(renderBox.borderWidth, 3.0);
    });

    test('Legacy StrokeRevealPainter still repaints and renders cleanly', () {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const testSize = Size(120, 80);
      final painter = StrokeRevealPainter(
        config: const Material4Config(type: Material4Type.smoothRounded),
        progress: 0.6,
        borderColor: Colors.red,
        borderWidth: 2,
      );

      expect(() => painter.paint(canvas, testSize), returnsNormally);

      final oldPainter = StrokeRevealPainter(
        config: const Material4Config(type: Material4Type.smoothRounded),
        progress: 0.3,
        borderColor: Colors.red,
        borderWidth: 2,
      );
      expect(painter.shouldRepaint(oldPainter), isTrue);
    });
  });

  group('RenderMaterial4 Child Painting & Selective Clipping Tests', () {
    testWidgets('Child renders and text is visible inside RenderMaterial4', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container(
                width: 200,
                height: 100,
                color: Colors.indigo,
                borderColor: Colors.white,
                borderWidth: 2,
                child: const Text(
                  'Hello Material 4',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hello Material 4'), findsOneWidget);
    });

    testWidgets(
        'Visible overflow content mode expands paintBounds for overflowing child',
        (
      tester,
    ) async {
      await tester.pumpWidget(
        Center(
          child: Material4RenderWidget(
            config: const Material4Config(
              type: Material4Type.smoothRounded,
            ),
            width: 100,
            height: 50,
            borderWidth: 0,
            borderColor: Colors.transparent,
            alignment: const Alignment(1.5, 1.5),
            contentProtection: const ShapeContentProtection(
              mode: ContentProtectionMode.visibleOverflow,
              autoPadding: false,
            ),
            clipBehavior: Clip.none,
            child: const SizedBox(
              width: 80,
              height: 40,
            ),
          ),
        ),
      );

      final renderBox = tester
          .renderObject<RenderMaterial4>(find.byType(Material4RenderWidget));
      final bounds = renderBox.paintBounds;
      expect(bounds.right, greaterThan(100));
      expect(bounds.bottom, greaterThan(50));
    });

    testWidgets(
        'Material4CustomPainter backwards compatibility renders cleanly', (
      tester,
    ) async {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const testSize = Size(150, 75);
      const painter = Material4CustomPainter(
        config: Material4Config(
          type: Material4Type.smoothRounded,
          cornerRadius: 12,
        ),
        color: Colors.amber,
        borderColor: Colors.deepOrange,
        borderWidth: 2,
        shadows: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      );

      expect(() => painter.paint(canvas, testSize), returnsNormally);

      const oldPainter = Material4CustomPainter(
        config: Material4Config(
          type: Material4Type.smoothRounded,
          cornerRadius: 16,
        ),
        color: Colors.amber,
      );
      expect(painter.shouldRepaint(oldPainter), isTrue);
    });
  });
}
