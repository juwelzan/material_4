import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'dynamic_shape_config.dart';

/// Next-Generation high-performance border renderer supporting 20 unique border styles.
///
/// Designed to execute efficiently on low-end hardware (500MB–1GB RAM devices)
/// without allocating unnecessary objects during paint cycles.
class ShapeBorderPainter {
  const ShapeBorderPainter._();

  /// Paint the border along the given [path] according to [config].
  static void paintBorder({
    required Canvas canvas,
    required Size size,
    required Path path,
    required DynamicShapeConfig config,
    required Color borderColor,
    required double borderWidth,
  }) {
    if (borderWidth <= 0 || borderColor.a <= 0) return;
    if (size.width <= 0 || size.height <= 0) return;

    // Apply global stroke alignment clipping if specified
    if (config.strokeAlign == ShapeStrokeAlign.inside) {
      canvas.save();
      canvas.clipPath(path);
      _renderBorderContent(
        canvas,
        size,
        path,
        config,
        borderColor,
        borderWidth * 2.0,
      );
      canvas.restore();
      return;
    } else if (config.strokeAlign == ShapeStrokeAlign.outside) {
      canvas.save();
      final outerRect = (Offset.zero & size).inflate(borderWidth * 2.0);
      final inversePath = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(outerRect)
        ..addPath(path, Offset.zero);
      canvas.clipPath(inversePath);
      _renderBorderContent(
        canvas,
        size,
        path,
        config,
        borderColor,
        borderWidth * 2.0,
      );
      canvas.restore();
      return;
    }

    _renderBorderContent(canvas, size, path, config, borderColor, borderWidth);
  }

  static void _renderBorderContent(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    switch (config.borderStyle) {
      // 1. Original 7 Border Styles (100% Backwards Compatible)
      case BorderStyleType.solid:
        _drawSolid(canvas, path, borderColor, borderWidth);
        break;

      case BorderStyleType.dashed:
        _drawDashed(
          canvas,
          path,
          borderColor,
          borderWidth,
          config.dashLength,
          config.dashGap,
          0.0,
          null,
        );
        break;

      case BorderStyleType.dotted:
        _drawDotted(canvas, path, borderColor, borderWidth, config.dashGap);
        break;

      case BorderStyleType.doubleStroke:
        _drawDoubleStroke(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.gradient:
        _drawGradient(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.neo3d:
        _drawNeo3D(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.glow:
        _drawGlow(
          canvas,
          path,
          borderColor,
          borderWidth,
          config.glowBlurRadius,
          config.glowColor,
        );
        break;

      // 2. Next-Gen 13 Border Styles (Phase 2 Expansion)
      case BorderStyleType.animatedGradient:
        _drawAnimatedGradient(
          canvas,
          size,
          path,
          config,
          borderColor,
          borderWidth,
        );
        break;

      case BorderStyleType.rainbow:
        _drawRainbow(canvas, size, path, config, borderWidth);
        break;

      case BorderStyleType.neonPulse:
        _drawNeonPulse(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.metallic:
        _drawMetallic(canvas, size, path, config, borderWidth);
        break;

      case BorderStyleType.multiLayer:
        _drawMultiLayer(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.cornerOnly:
        _drawCornerOnly(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.gradientDashed:
        _drawGradientDashed(
          canvas,
          size,
          path,
          config,
          borderColor,
          borderWidth,
        );
        break;

      case BorderStyleType.animatedDashed:
        _drawAnimatedDashed(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.embossed:
        _drawEmbossed(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.innerStroke:
        _drawInnerStroke(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.outerStroke:
        _drawOuterStroke(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.noiseTextured:
        _drawNoiseTextured(canvas, path, borderColor, borderWidth);
        break;

      case BorderStyleType.handDrawn:
        _drawHandDrawn(canvas, path, config, borderColor, borderWidth);
        break;
    }
  }

  // =========================================================================
  // --- Core Renderers ---
  // =========================================================================

  static void _drawSolid(
    Canvas canvas,
    Path path,
    Color borderColor,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor
      ..isAntiAlias = true;
    canvas.drawPath(path, paint);
  }

  static void _drawDashed(
    Canvas canvas,
    Path path,
    Color borderColor,
    double borderWidth,
    double dashLength,
    double dashGap,
    double phaseOffset,
    Shader? shader,
  ) {
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    if (shader != null) {
      dashPaint.shader = shader;
    } else {
      dashPaint.color = borderColor;
    }

    final totalCycle = dashLength + dashGap;
    if (totalCycle <= 0) {
      canvas.drawPath(path, dashPaint);
      return;
    }

    final normalizedPhase = phaseOffset % totalCycle;

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      double distance = -normalizedPhase;
      while (distance < metric.length) {
        final start = math.max(0.0, distance);
        final end = math.min(metric.length, distance + dashLength);
        if (end > start) {
          final dashSubPath = metric.extractPath(start, end);
          canvas.drawPath(dashSubPath, dashPaint);
        }
        distance += totalCycle;
      }
    }
  }

  static void _drawDotted(
    Canvas canvas,
    Path path,
    Color borderColor,
    double borderWidth,
    double dotGap,
  ) {
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = borderColor
      ..isAntiAlias = true;

    final dotSpacing = math.max(1.0, dotGap + borderWidth);
    final dotRadius = borderWidth * 0.5;

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      double distance = 0.0;
      while (distance < metric.length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, dotRadius, dotPaint);
        }
        distance += dotSpacing;
      }
    }
  }

  static void _drawDoubleStroke(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    // Outer Primary Stroke
    _drawSolid(canvas, path, borderColor, borderWidth);

    // Inner Delicate Stroke
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = config.innerBorderWidth
      ..color = config.innerBorderColor ?? borderColor.withValues(alpha: 0.45)
      ..isAntiAlias = true;

    final gap = config.innerBorderGap;
    if (size.width > gap * 2 && size.height > gap * 2) {
      canvas.save();
      final scaleX = (size.width - gap * 2) / size.width;
      final scaleY = (size.height - gap * 2) / size.height;
      canvas.translate(gap, gap);
      canvas.scale(scaleX, scaleY);
      canvas.drawPath(path, innerPaint);
      canvas.restore();
    }
  }

  static void _drawGradient(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..isAntiAlias = true;

    if (config.borderGradient != null) {
      paint.shader = config.borderGradient!.createShader(Offset.zero & size);
    } else {
      final defaultGrad = SweepGradient(
        colors: [borderColor, borderColor.withValues(alpha: 0.3), borderColor],
      );
      paint.shader = defaultGrad.createShader(Offset.zero & size);
    }

    canvas.drawPath(path, paint);
  }

  static void _drawNeo3D(
    Canvas canvas,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    // Bold Solid Outline
    _drawSolid(canvas, path, borderColor, borderWidth);

    // Hard Offset 3D Shadow Line
    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = config.neoColor
      ..isAntiAlias = true;

    canvas.save();
    canvas.translate(config.neoOffset.dx, config.neoOffset.dy);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();
  }

  static void _drawGlow(
    Canvas canvas,
    Path path,
    Color borderColor,
    double borderWidth,
    double blurRadius,
    Color? glowColor,
  ) {
    final effectiveGlowColor = glowColor ?? borderColor;

    // Blurred Glow Outer Halo
    if (blurRadius > 0) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth * 2.2
        ..color = effectiveGlowColor.withValues(alpha: 0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius)
        ..isAntiAlias = true;
      canvas.drawPath(path, glowPaint);
    }

    // Sharp Core Stroke
    _drawSolid(canvas, path, borderColor, borderWidth);
  }

  // =========================================================================
  // --- Next-Gen Border Renderers (Phase 2) ---
  // =========================================================================

  static void _drawAnimatedGradient(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..isAntiAlias = true;

    final progress = config.borderProgress;
    final angle = progress * 2 * math.pi;

    if (config.borderGradient is SweepGradient) {
      final sweep = config.borderGradient as SweepGradient;
      paint.shader = SweepGradient(
        center: sweep.center,
        startAngle: sweep.startAngle + angle,
        endAngle: sweep.endAngle + angle,
        colors: sweep.colors,
        stops: sweep.stops,
        tileMode: sweep.tileMode,
      ).createShader(Offset.zero & size);
    } else {
      // Rotating directional linear gradient
      final cx = size.width / 2;
      final cy = size.height / 2;
      final radius = math.max(size.width, size.height);
      final dx = math.cos(angle) * radius;
      final dy = math.sin(angle) * radius;

      final gradient = config.borderGradient ??
          LinearGradient(
            colors: [
              borderColor,
              borderColor.withValues(alpha: 0.2),
              borderColor,
            ],
            stops: const [0.0, 0.5, 1.0],
          );

      final colors = gradient.colors;
      final stops = gradient.stops ??
          (colors.length == 2
              ? null
              : List.generate(colors.length, (i) => i / (colors.length - 1)));

      paint.shader = ui.Gradient.linear(
        Offset(cx - dx, cy - dy),
        Offset(cx + dx, cy + dy),
        colors,
        stops,
      );
    }

    canvas.drawPath(path, paint);
  }

  static void _drawRainbow(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..isAntiAlias = true;

    final rotation = config.borderProgress * 2 * math.pi;
    const colors = [
      Color(0xFFFF3B30), // Red
      Color(0xFFFF9500), // Orange
      Color(0xFFFFCC00), // Yellow
      Color(0xFF34C759), // Green
      Color(0xFF00C7BE), // Cyan
      Color(0xFF007AFF), // Blue
      Color(0xFF5856D6), // Indigo
      Color(0xFFAF52DE), // Violet
      Color(0xFFFF3B30), // Loop Red
    ];

    final sweep = SweepGradient(
      center: Alignment.center,
      startAngle: rotation,
      endAngle: rotation + 2 * math.pi,
      colors: colors,
    );

    paint.shader = sweep.createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  static void _drawNeonPulse(
    Canvas canvas,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    final intensity = config.neonPulseIntensity.clamp(0.1, 3.0);
    final glowColor = (config.neonGlowColor ?? borderColor);

    // Multi-Stage High-Luminance Bloom Passes
    // Pass 1: Wide Soft Atmospheric Halo
    final wideHaloPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 3.5 * intensity
      ..color = glowColor.withValues(alpha: (0.28 * intensity).clamp(0.0, 1.0))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 16.0 * intensity)
      ..isAntiAlias = true;
    canvas.drawPath(path, wideHaloPaint);

    // Pass 2: Intense Mid-Field Corona
    final midCoronaPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2.0 * intensity
      ..color = glowColor.withValues(alpha: (0.55 * intensity).clamp(0.0, 1.0))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6.0 * intensity)
      ..isAntiAlias = true;
    canvas.drawPath(path, midCoronaPaint);

    // Pass 3: White-Hot Concentrated Core Filament
    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = Color.lerp(glowColor, Colors.white, 0.65)!
      ..isAntiAlias = true;
    canvas.drawPath(path, corePaint);
  }

  static void _drawMetallic(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..isAntiAlias = true;

    final colors = switch (config.metallicType) {
      MetallicType.gold => const [
          Color(0xFFFFD54F),
          Color(0xFFFFB300),
          Color(0xFFFFF9C4),
          Color(0xFFFFA000),
          Color(0xFFFFE082),
        ],
      MetallicType.chrome => const [
          Color(0xFFECEFF1),
          Color(0xFF90A4AE),
          Color(0xFFFFFFFF),
          Color(0xFF607D8B),
          Color(0xFFCFD8DC),
        ],
      MetallicType.roseGold => const [
          Color(0xFFF8BBD0),
          Color(0xFFE91E63),
          Color(0xFFFCE4EC),
          Color(0xFFC2185B),
          Color(0xFFF8BBD0),
        ],
      MetallicType.silver => const [
          Color(0xFFECEFF1),
          Color(0xFFB0BEC5),
          Color(0xFFFFFFFF),
          Color(0xFF78909C),
          Color(0xFFECEFF1),
        ],
      MetallicType.bronze => const [
          Color(0xFFD7CCC8),
          Color(0xFF8D6E63),
          Color(0xFFEFEBE9),
          Color(0xFF5D4037),
          Color(0xFFD7CCC8),
        ],
      MetallicType.titanium => const [
          Color(0xFF78909C),
          Color(0xFF37474F),
          Color(0xFFB0BEC5),
          Color(0xFF263238),
          Color(0xFF78909C),
        ],
    };

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    paint.shader = gradient.createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  static void _drawMultiLayer(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    final layers = config.multiLayerBorders ??
        [
          BorderLayer(color: borderColor, width: borderWidth, offset: 0.0),
          BorderLayer(
            color: borderColor.withValues(alpha: 0.4),
            width: borderWidth * 0.7,
            offset: borderWidth + 2.5,
          ),
          BorderLayer(
            color: borderColor.withValues(alpha: 0.2),
            width: borderWidth * 0.5,
            offset: (borderWidth + 2.5) * 2.0,
          ),
        ];

    for (final layer in layers) {
      if (layer.width <= 0) continue;

      final layerPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = layer.width
        ..isAntiAlias = true;

      if (layer.gradient != null) {
        layerPaint.shader = layer.gradient!.createShader(Offset.zero & size);
      } else {
        layerPaint.color = layer.color;
      }

      if (layer.blurRadius > 0) {
        layerPaint.maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          layer.blurRadius,
        );
      }

      canvas.save();
      if (layer.offset != 0.0 &&
          size.width > layer.offset * 2 &&
          size.height > layer.offset * 2) {
        final scaleX = (size.width - layer.offset * 2) / size.width;
        final scaleY = (size.height - layer.offset * 2) / size.height;
        canvas.translate(layer.offset, layer.offset);
        canvas.scale(scaleX, scaleY);
      }

      if (layer.isDashed) {
        _drawDashed(
          canvas,
          path,
          layer.color,
          layer.width,
          layer.dashLength,
          layer.dashGap,
          0.0,
          layerPaint.shader,
        );
      } else {
        canvas.drawPath(path, layerPaint);
      }
      canvas.restore();
    }
  }

  static void _drawCornerOnly(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    final cornerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.square
      ..color = borderColor
      ..isAntiAlias = true;

    final bracketLen = config.cornerBorderLength;

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;

      // Extract bracket corners at quarter intervals or along path extremes
      final totalLen = metric.length;
      final step = totalLen / 4.0;

      for (int i = 0; i < 4; i++) {
        final center = (i * step);
        final start = math.max(0.0, center - bracketLen / 2.0);
        final end = math.min(totalLen, center + bracketLen / 2.0);

        if (end > start) {
          final bracketPath = metric.extractPath(start, end);
          canvas.drawPath(bracketPath, cornerPaint);
        }
      }
    }
  }

  static void _drawGradientDashed(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    final gradient = config.borderGradient ??
        LinearGradient(
          colors: [
            borderColor,
            borderColor.withValues(alpha: 0.1),
            borderColor,
          ],
        );

    final shader = gradient.createShader(Offset.zero & size);
    _drawDashed(
      canvas,
      path,
      borderColor,
      borderWidth,
      config.dashLength,
      config.dashGap,
      config.dashPhase,
      shader,
    );
  }

  static void _drawAnimatedDashed(
    Canvas canvas,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    final cycle = config.dashLength + config.dashGap;
    final animatedPhase = config.dashPhase + (config.borderProgress * cycle);

    _drawDashed(
      canvas,
      path,
      borderColor,
      borderWidth,
      config.dashLength,
      config.dashGap,
      animatedPhase,
      null,
    );
  }

  static void _drawEmbossed(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    final lightAngle = config.embossLightAngle;
    final cosA = math.cos(lightAngle);
    final sinA = math.sin(lightAngle);
    final offsetDist = borderWidth * 0.75;

    // Highlight (Sunward side)
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = Colors.white.withValues(alpha: 0.55)
      ..isAntiAlias = true;

    canvas.save();
    canvas.translate(-cosA * offsetDist, -sinA * offsetDist);
    canvas.drawPath(path, highlightPaint);
    canvas.restore();

    // Shadow (Opposite shade side)
    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = Colors.black.withValues(alpha: 0.35)
      ..isAntiAlias = true;

    canvas.save();
    canvas.translate(cosA * offsetDist, sinA * offsetDist);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Core Neutral Mid-Tone Stroke
    _drawSolid(canvas, path, borderColor, borderWidth * 0.8);
  }

  static void _drawInnerStroke(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    canvas.save();
    canvas.clipPath(path);
    _drawSolid(canvas, path, borderColor, borderWidth * 2.0);
    canvas.restore();
  }

  static void _drawOuterStroke(
    Canvas canvas,
    Size size,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    canvas.save();
    final outerRect = (Offset.zero & size).inflate(borderWidth * 2.0);
    final inversePath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(outerRect)
      ..addPath(path, Offset.zero);
    canvas.clipPath(inversePath);
    _drawSolid(canvas, path, borderColor, borderWidth * 2.0);
    canvas.restore();
  }

  static void _drawNoiseTextured(
    Canvas canvas,
    Path path,
    Color borderColor,
    double borderWidth,
  ) {
    // 1. Soft Base Under-Stroke
    _drawSolid(canvas, path, borderColor.withValues(alpha: 0.4), borderWidth);

    // 2. Micro-Stippled Noise Grains along Path Metrics
    final grainPaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      double distance = 0.0;
      int seed = 42;

      while (distance < metric.length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          // Fast pseudo-random jitter without allocating Random instance
          seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF;
          final jitterX = ((seed % 100) / 100.0 - 0.5) * borderWidth * 0.8;
          seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF;
          final jitterY = ((seed % 100) / 100.0 - 0.5) * borderWidth * 0.8;
          seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF;
          final alpha = 0.3 + ((seed % 100) / 100.0) * 0.7;

          grainPaint.color = borderColor.withValues(alpha: alpha);
          canvas.drawCircle(
            tangent.position + Offset(jitterX, jitterY),
            borderWidth * 0.35,
            grainPaint,
          );
        }
        distance += borderWidth * 0.9;
      }
    }
  }

  static void _drawHandDrawn(
    Canvas canvas,
    Path path,
    DynamicShapeConfig config,
    Color borderColor,
    double borderWidth,
  ) {
    final roughPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = borderColor
      ..isAntiAlias = true;

    final roughness = config.handDrawnRoughness.clamp(0.2, 8.0);

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;

      final roughPath = Path();
      const step = 8.0;
      double distance = 0.0;
      bool isFirst = true;

      while (distance < metric.length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
          final wobble =
              math.sin(distance * 0.35) * math.cos(distance * 0.12) * roughness;
          final point = tangent.position + normal * wobble;

          if (isFirst) {
            roughPath.moveTo(point.dx, point.dy);
            isFirst = false;
          } else {
            roughPath.lineTo(point.dx, point.dy);
          }
        }
        distance += step;
      }

      roughPath.close();
      canvas.drawPath(roughPath, roughPaint);
    }
  }
}
