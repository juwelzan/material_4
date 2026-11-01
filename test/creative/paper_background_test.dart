import 'dart:ui';
import 'package:material_4/material_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 7.1: Paper Background & Pattern Engine Tests', () {
    test('All 20 PaperBackgroundStyle enum values are defined and distinct',
        () {
      expect(PaperBackgroundStyle.values.length, 20);
      expect(
        PaperBackgroundStyle.values.toSet().length,
        PaperBackgroundStyle.values.length,
      );
    });

    test('All 13 StationeryPatternType enum values are defined and distinct',
        () {
      expect(StationeryPatternType.values.length, 13);
      expect(
        StationeryPatternType.values.toSet().length,
        StationeryPatternType.values.length,
      );
    });

    test('All 21 RepeatingPatternType enum values are defined and distinct',
        () {
      expect(RepeatingPatternType.values.length, 21);
      expect(
        RepeatingPatternType.values.toSet().length,
        RepeatingPatternType.values.length,
      );
    });

    testWidgets(
        'Every paper background style renders cleanly on canvas without error',
        (
      tester,
    ) async {
      const testSize = Size(160, 120);
      final clipPath = Path()..addRect(Offset.zero & testSize);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      for (final style in PaperBackgroundStyle.values) {
        final config = PaperBackgroundConfig(
          style: style,
          textureIntensity: 0.6,
          grainOpacity: 0.1,
          fiberDensity: 0.4,
          hasStains: true,
          hasFolds: true,
          edgeVignette: true,
        );

        expect(
          () => PaperTextureRenderer.renderPaperBackground(
            canvas: canvas,
            size: testSize,
            clipPath: clipPath,
            config: config,
          ),
          returnsNormally,
          reason: 'Paper background style failed to render: $style',
        );
      }

      final pic = recorder.endRecording();
      pic.dispose();
    });

    testWidgets('Every stationery pattern renders cleanly on canvas', (
      tester,
    ) async {
      const testSize = Size(160, 120);
      final clipPath = Path()..addRect(Offset.zero & testSize);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      for (final style in StationeryPatternType.values) {
        final config = CreativePatternConfig(
          stationeryType: style,
          color: Colors.blueGrey,
          secondaryColor: Colors.redAccent,
          spacing: 16.0,
          scale: 1.1,
          rotation: 0.05,
        );

        expect(
          () => StationeryPatternRenderer.renderStationeryPattern(
            canvas: canvas,
            size: testSize,
            clipPath: clipPath,
            config: config,
          ),
          returnsNormally,
          reason: 'Stationery pattern failed to render: $style',
        );
      }

      final pic = recorder.endRecording();
      pic.dispose();
    });

    testWidgets('Every repeating pattern renders cleanly on canvas', (
      tester,
    ) async {
      const testSize = Size(160, 120);
      final clipPath = Path()..addRect(Offset.zero & testSize);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      for (final style in RepeatingPatternType.values) {
        final config = CreativePatternConfig(
          repeatingType: style,
          color: Colors.black26,
          spacing: 18.0,
          scale: 1.0,
        );

        expect(
          () => CreativeRepeatingPatternRenderer.renderRepeatingPattern(
            canvas: canvas,
            size: testSize,
            clipPath: clipPath,
            config: config,
          ),
          returnsNormally,
          reason: 'Repeating pattern failed to render: $style',
        );
      }

      final pic = recorder.endRecording();
      pic.dispose();
    });

  });
}
