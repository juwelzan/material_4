import 'dart:ui';
import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 7.1: Creative Border Engine Tests', () {
    test('All 38 CreativeBorderStyle enum values are defined and distinct', () {
      expect(CreativeBorderStyle.values.length, 38);
      expect(
        CreativeBorderStyle.values.toSet().length,
        CreativeBorderStyle.values.length,
      );
    });

    test('Torn paper geometry is 100% deterministic between frames', () {
      const size = Size(200, 100);
      final config = CreativeBorderConfig.tornPaper(
        seed: 42,
        tearIntensity: 0.6,
        edges: BorderEdges.all,
      );

      final path1 = TornPaperBorder.buildTornPath(size, config);
      final path2 = TornPaperBorder.buildTornPath(size, config);

      expect(path1.getBounds(), equals(path2.getBounds()));
      final metrics1 = path1.computeMetrics().first;
      final metrics2 = path2.computeMetrics().first;
      expect(metrics1.length, equals(metrics2.length));

      for (double d = 0; d < metrics1.length; d += 10.0) {
        final t1 = metrics1.getTangentForOffset(d);
        final t2 = metrics2.getTangentForOffset(d);
        expect(t1!.position, equals(t2!.position));
      }
    });

    test('Torn paper supports independent edge configurations', () {
      const size = Size(150, 100);

      // Only top torn
      final topOnlyConfig = CreativeBorderConfig.tornPaper(
        edges: BorderEdges.topOnly,
        tearIntensity: 0.8,
      );
      final topPath = TornPaperBorder.buildTornPath(size, topOnlyConfig);
      expect(topPath.getBounds().isEmpty, isFalse);

      // Only bottom torn
      final bottomOnlyConfig = CreativeBorderConfig.tornPaper(
        edges: BorderEdges.bottomOnly,
        tearIntensity: 0.8,
      );
      final bottomPath = TornPaperBorder.buildTornPath(size, bottomOnlyConfig);
      expect(bottomPath.getBounds().isEmpty, isFalse);

      // Horizontal only
      final horizConfig = CreativeBorderConfig.tornPaper(
        edges: BorderEdges.horizontal,
      );
      final horizPath = TornPaperBorder.buildTornPath(size, horizConfig);
      expect(horizPath.getBounds().isEmpty, isFalse);
    });

    testWidgets(
        'Every creative border style renders cleanly on canvas without error', (
      tester,
    ) async {
      const testSize = Size(180, 100);
      final path = Path()..addRect(Offset.zero & testSize);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      for (final style in CreativeBorderStyle.values) {
        final config = CreativeBorderConfig(
          style: style,
          width: 3.0,
          color: Colors.brown,
          secondaryColor: Colors.amber,
          edges: BorderEdges.all,
          animationProgress: 0.5,
        );

        expect(
          () => CreativeBorderPainter.paintCreativeBorder(
            canvas: canvas,
            size: testSize,
            path: path,
            config: config,
          ),
          returnsNormally,
          reason: 'Creative border style failed to paint: $style',
        );
      }

      final pic = recorder.endRecording();
      pic.dispose();
    });

    test('CreativeBorderCache enforces maximum bound limit without leak', () {
      CreativeBorderCache.clear();
      expect(CreativeBorderCache.entryCount, 0);

      for (int i = 0; i < 70; i++) {
        CreativeBorderCache.getOrCreatePath('test_key_$i', () {
          return Path()..addRect(Rect.fromLTWH(0, 0, i.toDouble() + 10, 50));
        });
      }

      expect(CreativeBorderCache.entryCount,
          lessThanOrEqualTo(CreativeBorderCache.maxEntries));
      CreativeBorderCache.clear();
      expect(CreativeBorderCache.entryCount, 0);
    });

    test('Border stroke alignment inside and outside clip correctly', () {
      const testSize = Size(100, 100);
      final path = Path()..addRect(Offset.zero & testSize);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      for (final align in ShapeStrokeAlign.values) {
        final config = CreativeBorderConfig(
          style: CreativeBorderStyle.stitch,
          strokeAlign: align,
          width: 4.0,
        );

        expect(
          () => CreativeBorderPainter.paintCreativeBorder(
            canvas: canvas,
            size: testSize,
            path: path,
            config: config,
          ),
          returnsNormally,
        );
      }

      final pic = recorder.endRecording();
      pic.dispose();
    });
  });
}
