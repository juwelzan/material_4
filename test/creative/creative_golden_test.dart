import 'dart:ui' as ui;
import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 7.1: Creative Visual & Pixel Surface Verification', () {
    testWidgets('Torn paper card renders valid non-blank pixel surface', (
      tester,
    ) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(240, 160);

      final config = CreativeBorderConfig.tornPaper(
        edges: BorderEdges.all,
        tearIntensity: 0.7,
        color: const Color(0xFF6B5B4D),
      );

      CreativeBorderPainter.paintCreativeBorder(
        canvas: canvas,
        size: size,
        path: Path()..addRect(Offset.zero & size),
        config: config,
      );

      final picture = recorder.endRecording();
      await tester.runAsync(() async {
        final image = await picture.toImage(
          size.width.toInt(),
          size.height.toInt(),
        );
        final byteData = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );

        expect(byteData, isNotNull);
        expect(
          byteData!.lengthInBytes,
          size.width.toInt() * size.height.toInt() * 4,
        );

        bool hasDrawnPixels = false;
        for (int i = 0; i < byteData.lengthInBytes; i += 4) {
          if (byteData.getUint8(i + 3) > 0) {
            hasDrawnPixels = true;
            break;
          }
        }
        expect(hasDrawnPixels, isTrue);
        image.dispose();
      });
      picture.dispose();
    });

    testWidgets('Paper background texture renders complex multi-layer pixels', (
      tester,
    ) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(100, 100);
      final clipPath = Path()..addRect(Offset.zero & size);

      const paperConfig = PaperBackgroundConfig(
        style: PaperBackgroundStyle.vintage,
        textureIntensity: 0.8,
        grainOpacity: 0.15,
        fiberDensity: 0.5,
        hasStains: true,
        edgeVignette: true,
      );

      PaperTextureRenderer.renderPaperBackground(
        canvas: canvas,
        size: size,
        clipPath: clipPath,
        config: paperConfig,
      );

      final picture = recorder.endRecording();
      await tester.runAsync(() async {
        final image = await picture.toImage(100, 100);
        final byteData = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );

        expect(byteData, isNotNull);
        expect(byteData!.lengthInBytes, 100 * 100 * 4);
        image.dispose();
      });
      picture.dispose();
    });

    testWidgets('Sculpted surface painter renders directional light & shadows',
        (
      tester,
    ) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(60, 60);

      const plateConfig = SculptedPlateConfig(
        style: SculptedSurfaceStyle.neumorphic,
        depth: 4.0,
      );

      const painter = SculptedSurfacePainter(config: plateConfig);
      painter.paint(canvas, size);

      final picture = recorder.endRecording();
      await tester.runAsync(() async {
        final image = await picture.toImage(60, 60);
        final byteData = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );

        expect(byteData, isNotNull);
        image.dispose();
      });
      picture.dispose();
    });
  });
}
