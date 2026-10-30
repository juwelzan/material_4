import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'paper_background_config.dart';

/// Renderer for 21 Creative Repeating Patterns with full scale, rotation,
/// offset, opacity, and shape clipping support.
class CreativeRepeatingPatternRenderer {
  const CreativeRepeatingPatternRenderer._();

  static double _hash(int n) {
    var x = n * 0x45d9f3b;
    x = ((x >> 16) ^ x) * 0x45d9f3b;
    x = (x >> 16) ^ x;
    return (x & 0x7fffffff) / 2147483648.0;
  }

  /// Renders repeating pattern onto [canvas] clipped to [clipPath].
  static void renderRepeatingPattern({
    required Canvas canvas,
    required Size size,
    required Path clipPath,
    required CreativePatternConfig config,
  }) {
    if (config.repeatingType == null || config.opacity <= 0) return;
    if (size.width <= 0 || size.height <= 0) return;

    canvas.save();
    canvas.clipPath(clipPath);

    if (config.rotation != 0.0 ||
        config.offset != Offset.zero ||
        config.scale != 1.0) {
      canvas.translate(size.width / 2 + config.offset.dx,
          size.height / 2 + config.offset.dy);
      canvas.rotate(config.rotation);
      canvas.scale(config.scale, config.scale);
      canvas.translate(-size.width / 2, -size.height / 2);
    }

    final strokePaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..strokeWidth = config.strokeWidth
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.fill;

    switch (config.repeatingType!) {
      case RepeatingPatternType.polkaDots:
        _drawPolkaDots(canvas, size, config, fillPaint);
        break;

      case RepeatingPatternType.smallCircles:
        _drawSmallCircles(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.diagonalStripes:
        _drawDiagonalStripes(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.horizontalStripes:
        _drawHorizontalStripes(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.verticalStripes:
        _drawVerticalStripes(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.crosshatch:
        _drawCrosshatch(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.checkerboard:
        _drawCheckerboard(canvas, size, config, fillPaint);
        break;

      case RepeatingPatternType.hexagonalGrid:
        _drawHexagonalGrid(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.triangularGrid:
        _drawTriangularGrid(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.diamondPattern:
        _drawDiamondPattern(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.wavePattern:
        _drawWavePattern(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.zigzagPattern:
        _drawZigzagPattern(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.honeycomb:
        _drawHoneycomb(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.concentricCircles:
        _drawConcentricCircles(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.geometricTiles:
        _drawGeometricTiles(canvas, size, config, strokePaint);
        break;

      case RepeatingPatternType.minimalFloral:
        _drawMinimalFloral(canvas, size, config, fillPaint);
        break;

      case RepeatingPatternType.abstractOrganic:
        _drawAbstractOrganic(canvas, size, config, fillPaint);
        break;

      case RepeatingPatternType.randomOrganicDots:
        _drawRandomOrganicDots(canvas, size, config, fillPaint);
        break;

      case RepeatingPatternType.confetti:
        _drawConfetti(canvas, size, config, fillPaint);
        break;

      case RepeatingPatternType.halftone:
        _drawHalftone(canvas, size, config, fillPaint);
        break;

      case RepeatingPatternType.topographicContour:
        _drawTopographicContour(canvas, size, config, strokePaint);
        break;
    }

    canvas.restore();
  }

  static void _drawPolkaDots(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(10.0, 80.0);
    final radius = (config.strokeWidth * 1.5).clamp(1.0, spacing * 0.4);
    for (double y = spacing * 0.5; y < size.height; y += spacing) {
      for (double x = spacing * 0.5; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  static void _drawSmallCircles(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(10.0, 80.0);
    final radius = (config.spacing * 0.25).clamp(2.0, 20.0);
    for (double y = spacing * 0.5; y < size.height; y += spacing) {
      for (double x = spacing * 0.5; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  static void _drawDiagonalStripes(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(6.0, 60.0);
    final span = size.width + size.height;
    for (double d = -size.height; d < span; d += spacing) {
      canvas.drawLine(
          Offset(d, 0), Offset(d + size.height, size.height), paint);
    }
  }

  static void _drawHorizontalStripes(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(6.0, 60.0);
    for (double y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  static void _drawVerticalStripes(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(6.0, 60.0);
    for (double x = spacing; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  static void _drawCrosshatch(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(8.0, 60.0);
    final span = size.width + size.height;
    for (double d = -size.height; d < span; d += spacing) {
      canvas.drawLine(
          Offset(d, 0), Offset(d + size.height, size.height), paint);
      canvas.drawLine(
          Offset(d + size.height, 0), Offset(d, size.height), paint);
    }
  }

  static void _drawCheckerboard(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final side = config.spacing.clamp(8.0, 60.0);
    for (double y = 0; y < size.height; y += side) {
      final row = (y / side).toInt();
      for (double x = 0; x < size.width; x += side) {
        final col = (x / side).toInt();
        if ((row + col) % 2 == 0) {
          canvas.drawRect(Rect.fromLTWH(x, y, side, side), paint);
        }
      }
    }
  }

  static void _drawHexagonalGrid(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final r = config.spacing.clamp(10.0, 50.0);
    final w = r * math.sqrt(3);
    final h = r * 1.5;

    for (double y = 0; y < size.height + r; y += h) {
      final row = (y / h).toInt();
      final offsetX = (row % 2 == 1) ? w * 0.5 : 0.0;
      for (double x = -w; x < size.width + w; x += w) {
        final cx = x + offsetX;
        final cy = y;
        final hex = Path();
        for (int i = 0; i < 6; i++) {
          final angle = (i * 60) * math.pi / 180;
          final px = cx + r * math.cos(angle);
          final py = cy + r * math.sin(angle);
          if (i == 0) {
            hex.moveTo(px, py);
          } else {
            hex.lineTo(px, py);
          }
        }
        hex.close();
        canvas.drawPath(hex, paint);
      }
    }
  }

  static void _drawTriangularGrid(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final side = config.spacing.clamp(12.0, 60.0);
    final h = side * (math.sqrt(3) / 2);

    for (double y = 0; y <= size.height; y += h) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final tan60 = math.sqrt(3);
    final span = size.width + size.height * tan60;
    for (double d = -size.height * tan60; d <= span; d += side) {
      canvas.drawLine(
          Offset(d, 0), Offset(d + size.height / tan60, size.height), paint);
      canvas.drawLine(
          Offset(d, size.height), Offset(d + size.height / tan60, 0), paint);
    }
  }

  static void _drawDiamondPattern(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final step = config.spacing.clamp(12.0, 64.0);
    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        final path = Path()
          ..moveTo(x + step * 0.5, y)
          ..lineTo(x + step, y + step * 0.5)
          ..lineTo(x + step * 0.5, y + step)
          ..lineTo(x, y + step * 0.5)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  static void _drawWavePattern(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(10.0, 60.0);
    final amp = spacing * 0.35;
    for (double y = spacing; y < size.height; y += spacing) {
      final path = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 16.0) {
        final wy = y + math.sin((x / 16.0) * math.pi) * amp;
        path.lineTo(x, wy);
      }
      canvas.drawPath(path, paint);
    }
  }

  static void _drawZigzagPattern(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(10.0, 60.0);
    final tooth = spacing * 0.4;
    for (double y = spacing; y < size.height; y += spacing) {
      final path = Path()..moveTo(0, y);
      bool toggle = false;
      for (double x = 0; x < size.width; x += tooth) {
        path.lineTo(x, toggle ? y - tooth * 0.5 : y + tooth * 0.5);
        toggle = !toggle;
      }
      canvas.drawPath(path, paint);
    }
  }

  static void _drawHoneycomb(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    _drawHexagonalGrid(canvas, size, config, paint);
  }

  static void _drawConcentricCircles(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final maxR =
        math.sqrt(size.width * size.width + size.height * size.height) * 0.5;
    final spacing = config.spacing.clamp(8.0, 50.0);
    for (double r = spacing; r < maxR; r += spacing) {
      canvas.drawCircle(center, r, paint);
    }
  }

  static void _drawGeometricTiles(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final tileSize = config.spacing.clamp(16.0, 80.0);
    for (double y = 0; y < size.height; y += tileSize) {
      for (double x = 0; x < size.width; x += tileSize) {
        canvas.drawRect(Rect.fromLTWH(x, y, tileSize, tileSize), paint);
        canvas.drawCircle(
          Offset(x + tileSize * 0.5, y + tileSize * 0.5),
          tileSize * 0.35,
          paint,
        );
      }
    }
  }

  static void _drawMinimalFloral(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(20.0, 80.0);
    const petalRadius = 4.0;
    for (double y = spacing * 0.5; y < size.height; y += spacing) {
      for (double x = spacing * 0.5; x < size.width; x += spacing) {
        final center = Offset(x, y);
        canvas.drawCircle(center, petalRadius * 0.6, paint);
        for (int i = 0; i < 4; i++) {
          final a = (i * 90) * math.pi / 180;
          canvas.drawCircle(
            center +
                Offset(math.cos(a) * petalRadius, math.sin(a) * petalRadius),
            petalRadius * 0.7,
            paint,
          );
        }
      }
    }
  }

  static void _drawAbstractOrganic(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(24.0, 80.0);
    for (double y = spacing * 0.5; y < size.height; y += spacing) {
      for (double x = spacing * 0.5; x < size.width; x += spacing) {
        final r = spacing * 0.3;
        final path = Path()
          ..addOval(
            Rect.fromCenter(
              center: Offset(x, y),
              width: r * 1.5,
              height: r * 0.9,
            ),
          );
        canvas.drawPath(path, paint);
      }
    }
  }

  static void _drawRandomOrganicDots(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final count =
        ((size.width * size.height) / (config.spacing * config.spacing))
            .toInt()
            .clamp(10, 200);
    for (int i = 0; i < count; i++) {
      final s = i * 149;
      final x = _hash(s) * size.width;
      final y = _hash(s + 1) * size.height;
      final r = (config.strokeWidth * 0.8) + (_hash(s + 2) * 2.5);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  static void _drawConfetti(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final count =
        ((size.width * size.height) / (config.spacing * config.spacing))
            .toInt()
            .clamp(10, 150);
    for (int i = 0; i < count; i++) {
      final s = i * 211;
      final x = _hash(s) * size.width;
      final y = _hash(s + 1) * size.height;
      final w = 3.0 + _hash(s + 2) * 5.0;
      final h = 1.5 + _hash(s + 3) * 3.0;
      final angle = _hash(s + 4) * math.pi;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: w, height: h), paint);
      canvas.restore();
    }
  }

  static void _drawHalftone(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(8.0, 36.0);
    for (double y = spacing * 0.5; y < size.height; y += spacing) {
      final t = (y / size.height).clamp(0.0, 1.0);
      final r = (spacing * 0.45 * t).clamp(0.5, spacing * 0.45);
      for (double x = spacing * 0.5; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  static void _drawTopographicContour(
    Canvas canvas,
    Size size,
    CreativePatternConfig config,
    Paint paint,
  ) {
    final spacing = config.spacing.clamp(16.0, 60.0);
    for (double y = spacing; y < size.height; y += spacing) {
      final path = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 12.0) {
        final dy = y +
            math.sin((x / 40.0) * math.pi) * (spacing * 0.4) +
            math.cos((x / 20.0) * math.pi) * (spacing * 0.2);
        path.lineTo(x, dy);
      }
      canvas.drawPath(path, paint);
    }
  }
}
