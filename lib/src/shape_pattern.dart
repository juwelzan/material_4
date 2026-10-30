import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Available background pattern textures for Material 4 shape containers.
enum ShapePattern {
  none,

  /// Diagonal craft/exam stripes (caution/voucher style)
  diagonalStripes,

  /// Polka dot / math notebook dot matrix
  dotsMatrix,

  /// Technical graph paper / blueprint grid lines
  gridLines,

  /// Concentric security guilloche waves (certificate/diploma style)
  guillocheWaves,

  /// Subtle diagonal cross-hatch linen texture
  crossHatch,
}

/// Helper to render procedural mathematical pattern textures inside clipped paths.
class ShapePatternRenderer {
  static void drawPattern({
    required Canvas canvas,
    required Path clipPath,
    required Size size,
    required ShapePattern pattern,
    required Color color,
    double spacing = 16.0,
    double strokeWidth = 1.0,
  }) {
    if (pattern == ShapePattern.none || color.a <= 0) return;

    canvas.save();
    canvas.clipPath(clipPath);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    switch (pattern) {
      case ShapePattern.none:
        break;

      case ShapePattern.diagonalStripes:
        // Draw 45-degree diagonal lines across the container
        final totalSpan = w + h;
        for (double d = -h; d < totalSpan; d += spacing) {
          canvas.drawLine(Offset(d, 0), Offset(d + h, h), paint);
        }
        break;

      case ShapePattern.dotsMatrix:
        final dotPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        final radius = strokeWidth * 1.2;
        for (double y = spacing * 0.5; y < h; y += spacing) {
          for (double x = spacing * 0.5; x < w; x += spacing) {
            canvas.drawCircle(Offset(x, y), radius, dotPaint);
          }
        }
        break;

      case ShapePattern.gridLines:
        // Horizontal grid lines
        for (double y = 0; y <= h; y += spacing) {
          canvas.drawLine(Offset(0, y), Offset(w, y), paint);
        }
        // Vertical grid lines
        for (double x = 0; x <= w; x += spacing) {
          canvas.drawLine(Offset(x, 0), Offset(x, h), paint);
        }
        break;

      case ShapePattern.guillocheWaves:
        final wavePath = Path();
        for (double y = 8; y < h; y += spacing) {
          wavePath.moveTo(0, y);
          for (double x = 0; x < w; x += 20) {
            final waveY = y + math.sin((x / 20) * math.pi) * (spacing * 0.25);
            wavePath.lineTo(x, waveY);
          }
        }
        canvas.drawPath(wavePath, paint);
        break;

      case ShapePattern.crossHatch:
        final totalSpan = w + h;
        for (double d = -h; d < totalSpan; d += spacing) {
          canvas.drawLine(Offset(d, 0), Offset(d + h, h), paint);
          canvas.drawLine(Offset(d + h, 0), Offset(d, h), paint);
        }
        break;
    }

    canvas.restore();
  }
}
