import 'dart:ui';

import 'package:material_4/material_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 2: Border Engine Comprehensive Tests', () {
    test('All 40 BorderStyleType enum values are defined and distinct', () {
      expect(BorderStyleType.values.length, 40);
      expect(
        BorderStyleType.values.toSet().length,
        BorderStyleType.values.length,
      );
    });

    testWidgets('Every border style renders cleanly on canvas without error', (
      tester,
    ) async {
      const testSize = Size(200, 120);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      for (final style in BorderStyleType.values) {
        final config = Material4Config(
          type: Material4Type.smoothRounded,
          borderStyle: style,
          borderProgress: 0.5,
          dashPhase: 3.0,
          cornerBorderLength: 16.0,
          multiLayerBorders: const [
            BorderLayer(color: Colors.blue, width: 2.0, offset: 0.0),
            BorderLayer(color: Colors.purple, width: 1.0, offset: 4.0),
          ],
        );

        final path = Material4PathBuilder.buildPath(testSize, config);

        expect(
          () => ShapeBorderPainter.paintBorder(
            canvas: canvas,
            size: testSize,
            path: path,
            config: config,
            borderColor: Colors.teal,
            borderWidth: 2.0,
          ),
          returnsNormally,
          reason: 'Failed to render border style: $style',
        );
      }

      final picture = recorder.endRecording();
      picture.dispose();
    });

    testWidgets('Guards against zero and negative border widths safely', (
      tester,
    ) async {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const testSize = Size(100, 100);
      final path = Path()..addRect(Offset.zero & testSize);
      const config = Material4Config(borderStyle: BorderStyleType.solid);

      // BorderWidth 0.0
      expect(
        () => ShapeBorderPainter.paintBorder(
          canvas: canvas,
          size: testSize,
          path: path,
          config: config,
          borderColor: Colors.red,
          borderWidth: 0.0,
        ),
        returnsNormally,
      );

      // BorderWidth negative
      expect(
        () => ShapeBorderPainter.paintBorder(
          canvas: canvas,
          size: testSize,
          path: path,
          config: config,
          borderColor: Colors.red,
          borderWidth: -2.0,
        ),
        returnsNormally,
      );

      // Fully transparent border
      expect(
        () => ShapeBorderPainter.paintBorder(
          canvas: canvas,
          size: testSize,
          path: path,
          config: config,
          borderColor: Colors.transparent,
          borderWidth: 2.0,
        ),
        returnsNormally,
      );

      // Zero size
      expect(
        () => ShapeBorderPainter.paintBorder(
          canvas: canvas,
          size: Size.zero,
          path: path,
          config: config,
          borderColor: Colors.blue,
          borderWidth: 2.0,
        ),
        returnsNormally,
      );

      final picture = recorder.endRecording();
      picture.dispose();
    });

    testWidgets('All 6 MetallicType presets render cleanly', (tester) async {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const testSize = Size(150, 100);
      final path = Path()..addRect(Offset.zero & testSize);

      for (final metal in MetallicType.values) {
        final config = Material4Config(
          borderStyle: BorderStyleType.metallic,
          metallicType: metal,
        );

        expect(
          () => ShapeBorderPainter.paintBorder(
            canvas: canvas,
            size: testSize,
            path: path,
            config: config,
            borderColor: Colors.amber,
            borderWidth: 2.5,
          ),
          returnsNormally,
          reason: 'Metallic type $metal failed to render',
        );
      }

      final picture = recorder.endRecording();
      picture.dispose();
    });

    testWidgets('Stroke alignments (center, inside, outside) render cleanly', (
      tester,
    ) async {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      const testSize = Size(120, 80);
      final path = Path()..addOval(Offset.zero & testSize);

      for (final align in ShapeStrokeAlign.values) {
        final config = Material4Config(
          borderStyle: BorderStyleType.neonPulse,
          strokeAlign: align,
        );

        expect(
          () => ShapeBorderPainter.paintBorder(
            canvas: canvas,
            size: testSize,
            path: path,
            config: config,
            borderColor: Colors.cyan,
            borderWidth: 3.0,
          ),
          returnsNormally,
        );
      }

      final picture = recorder.endRecording();
      picture.dispose();
    });

    testWidgets(
      'Material4Container convenience border factories render in widget tree',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const Material4Container(
                      width: 100,
                      height: 50,
                      border: Material4Border.neon(),
                      child: Text('Neon'),
                    ),
                    Material4Container(
                      width: 100,
                      height: 50,
                      config: const Material4Config(
                        borderStyle: BorderStyleType.metallic,
                        metallicType: MetallicType.gold,
                      ),
                      child: const Text('Metallic Gold'),
                    ),
                    const Material4Container(
                      width: 100,
                      height: 50,
                      border: Material4Border.rainbow(),
                      child: Text('Rainbow'),
                    ),
                    Material4Container(
                      width: 100,
                      height: 50,
                      config: const Material4Config(
                        borderStyle: BorderStyleType.multiLayer,
                        multiLayerBorders: [
                          BorderLayer(color: Colors.red, width: 2.0),
                          BorderLayer(
                            color: Colors.blue,
                            width: 1.0,
                            offset: 4.0,
                          ),
                        ],
                      ),
                      child: const Text('Multi-Layer'),
                    ),
                    Material4Container(
                      width: 100,
                      height: 50,
                      config: const Material4Config(
                        borderStyle: BorderStyleType.cornerOnly,
                      ),
                      child: const Text('Corner Only'),
                    ),
                    const Material4Container(
                      width: 100,
                      height: 50,
                      border: Material4Border.styled(BorderStyleType.handDrawn),
                      child: Text('Hand Drawn'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Neon'), findsOneWidget);
        expect(find.text('Metallic Gold'), findsOneWidget);
        expect(find.text('Rainbow'), findsOneWidget);
        expect(find.text('Multi-Layer'), findsOneWidget);
        expect(find.text('Corner Only'), findsOneWidget);
        expect(find.text('Hand Drawn'), findsOneWidget);
      },
    );
  });
}
