import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/shapes/dynamic_shape_config.dart';
import 'package:test_app/core/shapes/shape_background_renderer.dart';

void main() {
  group('Phase 4: Background Effects Tests', () {
    test('All BackgroundEffectType values are defined', () {
      expect(BackgroundEffectType.values.length, 12);
    });

    testWidgets(
      'Every background effect renders cleanly on canvas without error',
      (tester) async {
        const testSize = Size(200, 150);
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        final path = Path()..addRect(Offset.zero & testSize);

        for (final effect in BackgroundEffectType.values) {
          final config = DynamicShapeConfig(
            backgroundEffect: effect,
            backgroundProgress: 0.45,
            waveLevel: 0.6,
            particleCount: 16,
            noiseOpacity: 0.08,
            meshColors: const [
              Colors.purple,
              Colors.pink,
              Colors.blue,
              Colors.cyan,
            ],
          );

          expect(
            () => ShapeBackgroundRenderer.renderBackground(
              canvas: canvas,
              size: testSize,
              clipPath: path,
              config: config,
              baseColor: Colors.deepPurple,
            ),
            returnsNormally,
            reason: 'Background effect $effect failed to render',
          );
        }

        final picture = recorder.endRecording();
        picture.dispose();
      },
    );

    testWidgets('Handles zero and negative dimensions safely', (tester) async {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final path = Path();
      const config = DynamicShapeConfig(
        backgroundEffect: BackgroundEffectType.animatedWaves,
      );

      expect(
        () => ShapeBackgroundRenderer.renderBackground(
          canvas: canvas,
          size: Size.zero,
          clipPath: path,
          config: config,
        ),
        returnsNormally,
      );

      expect(
        () => ShapeBackgroundRenderer.renderBackground(
          canvas: canvas,
          size: const Size(-10, -10),
          clipPath: path,
          config: config,
        ),
        returnsNormally,
      );

      final picture = recorder.endRecording();
      picture.dispose();
    });
  });
}
