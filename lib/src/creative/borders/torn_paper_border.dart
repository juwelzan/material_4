import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'creative_border_cache.dart';
import 'creative_border_config.dart';

/// Deterministic geometry and rendering engine for realistic Torn Paper edges.
class TornPaperBorder {
  const TornPaperBorder._();

  /// Pseudo-random hash producing consistent double in range [0, 1) for a given integer seed.
  static double _hash(int n) {
    var x = n * 0x45d9f3b;
    x = ((x >> 16) ^ x) * 0x45d9f3b;
    x = (x >> 16) ^ x;
    return (x & 0x7fffffff) / 2147483648.0;
  }

  /// Multi-octave deterministic displacement function for torn paper contour.
  static double _tearDisplacement({
    required double t,
    required int edgeIndex,
    required int seed,
    required double intensity,
    required double baseWidth,
  }) {
    final edgeSeed = seed + (edgeIndex * 1013);
    final p1 = _hash(edgeSeed + 1) * math.pi * 2;
    final p2 = _hash(edgeSeed + 2) * math.pi * 2;
    final p3 = _hash(edgeSeed + 3) * math.pi * 2;
    final p4 = _hash(edgeSeed + 4) * math.pi * 2;

    // Multi-octave harmonics: low (macro rips), mid (serrations), high (grain teeth)
    final macro = math.sin(t * math.pi * 4 + p1) * 0.45;
    final meso = math.sin(t * math.pi * 14 + p2) * 0.30;
    final micro = math.sin(t * math.pi * 32 + p3) * 0.15;
    final grain = math.cos(t * math.pi * 64 + p4) * 0.10;

    final combined = (macro + meso + micro + grain);
    return combined * baseWidth * intensity;
  }

  /// Builds the closed torn paper boundary path for a given [size] and [config].
  static Path buildTornPath(Size size, CreativeBorderConfig config) {
    final cacheKey = 'torn_${size.width.toInt()}x${size.height.toInt()}_'
        '${config.edges.top ? 1 : 0}${config.edges.right ? 1 : 0}${config.edges.bottom ? 1 : 0}${config.edges.left ? 1 : 0}_'
        '${config.tearIntensity.toStringAsFixed(2)}_${config.seed}_${config.width.toStringAsFixed(1)}';

    return CreativeBorderCache.getOrCreatePath(cacheKey, () {
      final path = Path();
      final w = size.width;
      final h = size.height;
      final intensity = config.tearIntensity.clamp(0.05, 2.0);
      final tearWidth = config.width.clamp(1.0, 32.0);
      final stepsPerEdge = math.max(30, (math.max(w, h) / 4.0).toInt());

      // 1. TOP EDGE (Left to Right)
      if (config.edges.top) {
        path.moveTo(
          0.0,
          _tearDisplacement(
            t: 0.0,
            edgeIndex: 0,
            seed: config.seed,
            intensity: intensity,
            baseWidth: tearWidth,
          ).abs(),
        );
        for (int i = 1; i <= stepsPerEdge; i++) {
          final t = i / stepsPerEdge;
          final x = w * t;
          final dy = _tearDisplacement(
            t: t,
            edgeIndex: 0,
            seed: config.seed,
            intensity: intensity,
            baseWidth: tearWidth,
          );
          path.lineTo(x, dy.abs());
        }
      } else {
        path.moveTo(0.0, 0.0);
        path.lineTo(w, 0.0);
      }

      // 2. RIGHT EDGE (Top to Bottom)
      if (config.edges.right) {
        for (int i = 1; i <= stepsPerEdge; i++) {
          final t = i / stepsPerEdge;
          final y = h * t;
          final dx = _tearDisplacement(
            t: t,
            edgeIndex: 1,
            seed: config.seed,
            intensity: intensity,
            baseWidth: tearWidth,
          );
          path.lineTo(w - dx.abs(), y);
        }
      } else {
        path.lineTo(w, h);
      }

      // 3. BOTTOM EDGE (Right to Left)
      if (config.edges.bottom) {
        for (int i = 1; i <= stepsPerEdge; i++) {
          final t = i / stepsPerEdge;
          final x = w * (1.0 - t);
          final dy = _tearDisplacement(
            t: t,
            edgeIndex: 2,
            seed: config.seed,
            intensity: intensity,
            baseWidth: tearWidth,
          );
          path.lineTo(x, h - dy.abs());
        }
      } else {
        path.lineTo(0.0, h);
      }

      // 4. LEFT EDGE (Bottom to Top)
      if (config.edges.left) {
        for (int i = 1; i <= stepsPerEdge; i++) {
          final t = i / stepsPerEdge;
          final y = h * (1.0 - t);
          final dx = _tearDisplacement(
            t: t,
            edgeIndex: 3,
            seed: config.seed,
            intensity: intensity,
            baseWidth: tearWidth,
          );
          path.lineTo(dx.abs(), y);
        }
      } else {
        path.lineTo(0.0, 0.0);
      }

      path.close();
      return path;
    });
  }

  /// Paints the complete torn paper border including shadow underlayer,
  /// fiber details, and crisp torn contour.
  static void paintTornPaper({
    required Canvas canvas,
    required Size size,
    required CreativeBorderConfig config,
  }) {
    if (size.width <= 0 || size.height <= 0) return;
    if (!config.edges.hasAny) return;

    final tornPath = buildTornPath(size, config);

    // 1. Optional Under-Edge Drop Shadow (creates realistic paper depth)
    if (config.tearShadow) {
      final shadowColor = config.tearShadowColor ??
          Colors.black.withValues(alpha: 0.18 * config.opacity);
      final shadowPaint = Paint()
        ..color = shadowColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = config.width * 0.75
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, config.tearShadowBlur);

      canvas.save();
      canvas.translate(1.0, 2.0);
      canvas.drawPath(tornPath, shadowPaint);
      canvas.restore();
    }

    // 2. Base Torn Stroke
    final borderPaint = Paint()
      ..color = config.color.withValues(alpha: config.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, config.width * 0.5)
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    if (config.gradient != null) {
      borderPaint.shader = config.gradient!.createShader(Offset.zero & size);
    }

    canvas.drawPath(tornPath, borderPaint);

    // 3. Delicate Microscopic Paper Fiber Details
    if (config.paperFiberDetails && config.fiberDensity > 0.0) {
      _paintPaperFibers(canvas, size, config);
    }
  }

  /// Draws microscopic individual paper fibers protruding along the torn edges.
  static void _paintPaperFibers(
    Canvas canvas,
    Size size,
    CreativeBorderConfig config,
  ) {
    final fiberColor = config.fiberColor ??
        config.color.withValues(alpha: 0.45 * config.opacity);
    final fiberPaint = Paint()
      ..color = fiberColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..strokeCap = StrokeCap.round;

    final count = (15 * config.fiberDensity).toInt();
    final w = size.width;
    final h = size.height;

    for (int edge = 0; edge < 4; edge++) {
      if (edge == 0 && !config.edges.top) continue;
      if (edge == 1 && !config.edges.right) continue;
      if (edge == 2 && !config.edges.bottom) continue;
      if (edge == 3 && !config.edges.left) continue;

      for (int i = 0; i < count; i++) {
        final t = (i + 0.5) / count;
        final fiberSeed = config.seed + (edge * 2000) + (i * 37);
        final length = 2.0 + (_hash(fiberSeed) * config.width * 0.8);
        final angleOffset = (_hash(fiberSeed + 1) - 0.5) * (math.pi / 3.0);

        Offset start;
        Offset dir;

        switch (edge) {
          case 0: // Top
            final dy = _tearDisplacement(
              t: t,
              edgeIndex: 0,
              seed: config.seed,
              intensity: config.tearIntensity,
              baseWidth: config.width,
            ).abs();
            start = Offset(w * t, dy);
            dir = Offset(math.sin(angleOffset), -math.cos(angleOffset));
            break;
          case 1: // Right
            final dx = _tearDisplacement(
              t: t,
              edgeIndex: 1,
              seed: config.seed,
              intensity: config.tearIntensity,
              baseWidth: config.width,
            ).abs();
            start = Offset(w - dx, h * t);
            dir = Offset(math.cos(angleOffset), math.sin(angleOffset));
            break;
          case 2: // Bottom
            final dy = _tearDisplacement(
              t: t,
              edgeIndex: 2,
              seed: config.seed,
              intensity: config.tearIntensity,
              baseWidth: config.width,
            ).abs();
            start = Offset(w * (1.0 - t), h - dy);
            dir = Offset(-math.sin(angleOffset), math.cos(angleOffset));
            break;
          case 3: // Left
          default:
            final dx = _tearDisplacement(
              t: t,
              edgeIndex: 3,
              seed: config.seed,
              intensity: config.tearIntensity,
              baseWidth: config.width,
            ).abs();
            start = Offset(dx, h * (1.0 - t));
            dir = Offset(-math.cos(angleOffset), -math.sin(angleOffset));
            break;
        }

        canvas.drawLine(start, start + (dir * length), fiberPaint);
      }
    }
  }
}
