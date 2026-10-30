import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'container/container_border.dart';
import 'material_4_config.dart';

/// Next-Generation high-performance border renderer supporting 20 unique border styles.
///
/// Designed to execute efficiently on low-end hardware (500MB–1GB RAM devices)
/// without allocating unnecessary objects during paint cycles.
class ShapeBorderPainter {
  const ShapeBorderPainter._();

  /// Paint a custom [Material4Border] along the given vector [path].
  static void paintMaterial4Border({
    required Canvas canvas,
    required Size size,
    required Path path,
    required Material4Border border,
  }) {
    if (border.width <= 0 || border.opacity <= 0) return;
    final effectiveColor = (border.color ?? const Color(0x1F1A1A1A))
        .withValues(alpha: (border.color?.a ?? 0.12) * border.opacity);
    final dummyConfig = Material4Config(
      borderStyle: border.style,
      borderProgress: border.progress,
      dashPhase: border.progress * (border.dashLength + border.dashGap) * 4.0,
      dashLength: border.dashLength,
      dashGap: border.dashGap,
      strokeAlign: border.strokeAlign,
      borderGradient: border.gradient,
      neonPulseIntensity: border.glowIntensity,
      glowBlurRadius: border.blurRadius,
    );
    paintBorder(
      canvas: canvas,
      size: size,
      path: path,
      config: dummyConfig,
      borderColor: effectiveColor,
      borderWidth: border.width,
    );
  }

  /// Paint the border along the given [path] according to [config].
  static void paintBorder({
    required Canvas canvas,
    required Size size,
    required Path path,
    required Material4Config config,
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
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    switch (config.borderStyle) {
      // 1. Original 7 Border Styles (100% Backwards Compatible)
      case BorderStyleType.solid:
        _drawSolid(
          canvas,
          path,
          borderColor,
          borderWidth,
          config.borderProgress,
        );
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
          config.borderProgress,
        );
        break;

      case BorderStyleType.dotted:
        _drawDotted(
          canvas,
          path,
          borderColor,
          borderWidth,
          config.dashGap,
          config.borderProgress,
        );
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
          config.borderProgress,
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
        _drawNoiseTextured(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.handDrawn:
        _drawHandDrawn(canvas, path, config, borderColor, borderWidth);
        break;

      // --- Universal Next-Gen Animated Border Styles ---
      case BorderStyleType.flowingBorder:
        _drawFlowingBorder(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.movingDash:
        _drawMovingDash(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.pulsatingBorder:
        _drawPulsatingBorder(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.liquidBorder:
        _drawLiquidBorder(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.waveBorder:
        _drawWaveBorder(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.zigzagBorder:
        _drawZigzagBorder(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.particleBorder:
        _drawParticleBorder(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.orbitingLightBorder:
        _drawOrbitingLightBorder(canvas, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.dualLayerBorder:
        _drawDualLayerBorder(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.shimmerBorder:
        _drawShimmerBorder(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.conicGradientBorder:
        _drawConicGradientBorder(canvas, size, path, config, borderColor, borderWidth);
        break;

      case BorderStyleType.energyBorder:
        _drawEnergyBorder(canvas, path, config, borderColor, borderWidth);
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
    double borderWidth, [
    double borderProgress = 1.0,
  ]) {
    final progress = borderProgress.clamp(0.0, 1.0);
    if (progress <= 0.0 || borderWidth <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..color = borderColor
      ..isAntiAlias = true;

    if (progress >= 1.0) {
      canvas.drawPath(path, paint);
      return;
    }

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final subPath = metric.extractPath(0.0, metric.length * progress);
      canvas.drawPath(subPath, paint);
    }
  }

  static void _drawDashed(
    Canvas canvas,
    Path path,
    Color borderColor,
    double borderWidth,
    double dashLength,
    double dashGap,
    double phaseOffset,
    Shader? shader, [
    double borderProgress = 1.0,
  ]) {
    final progress = borderProgress.clamp(0.0, 1.0);
    if (progress <= 0.0 || borderWidth <= 0) return;

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
      if (progress >= 1.0) {
        canvas.drawPath(path, dashPaint);
      } else {
        for (final metric in path.computeMetrics()) {
          if (metric.length <= 0) continue;
          canvas.drawPath(
            metric.extractPath(0.0, metric.length * progress),
            dashPaint,
          );
        }
      }
      return;
    }

    final normalizedPhase = phaseOffset % totalCycle;

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final maxDistance = metric.length * progress;
      double distance = -normalizedPhase;
      while (distance < maxDistance) {
        final start = math.max(0.0, distance);
        final end = math.min(maxDistance, distance + dashLength);
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
    double dotGap, [
    double borderProgress = 1.0,
  ]) {
    final progress = borderProgress.clamp(0.0, 1.0);
    if (progress <= 0.0 || borderWidth <= 0) return;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = borderColor
      ..isAntiAlias = true;

    final dotSpacing = math.max(1.0, dotGap + borderWidth);
    final dotRadius = borderWidth * 0.5;

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final maxDistance = metric.length * progress;
      double distance = 0.0;
      while (distance < maxDistance) {
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
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    // Outer Primary Stroke
    _drawSolid(canvas, path, borderColor, borderWidth, config.borderProgress);

    // Inner Delicate Stroke
    final gap = config.innerBorderGap;
    if (size.width > gap * 2 && size.height > gap * 2) {
      canvas.save();
      final scaleX = (size.width - gap * 2) / size.width;
      final scaleY = (size.height - gap * 2) / size.height;
      canvas.translate(gap, gap);
      canvas.scale(scaleX, scaleY);
      _drawSolid(
        canvas,
        path,
        config.innerBorderColor ?? borderColor.withValues(alpha: 0.45),
        config.innerBorderWidth,
        config.borderProgress,
      );
      canvas.restore();
    }
  }

  static void _drawGradient(
    Canvas canvas,
    Size size,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final progress = config.borderProgress.clamp(0.0, 1.0);
    if (progress <= 0.0 || borderWidth <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    if (config.borderGradient != null) {
      paint.shader = config.borderGradient!.createShader(Offset.zero & size);
    } else {
      final defaultGrad = SweepGradient(
        colors: [borderColor, borderColor.withValues(alpha: 0.3), borderColor],
      );
      paint.shader = defaultGrad.createShader(Offset.zero & size);
    }

    if (progress >= 1.0) {
      canvas.drawPath(path, paint);
      return;
    }

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final subPath = metric.extractPath(0.0, metric.length * progress);
      canvas.drawPath(subPath, paint);
    }
  }

  static void _drawNeo3D(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    // Bold Solid Outline
    _drawSolid(canvas, path, borderColor, borderWidth, config.borderProgress);

    // Hard Offset 3D Shadow Line
    canvas.save();
    canvas.translate(config.neoOffset.dx, config.neoOffset.dy);
    _drawSolid(
      canvas,
      path,
      config.neoColor,
      borderWidth,
      config.borderProgress,
    );
    canvas.restore();
  }

  static void _drawGlow(
    Canvas canvas,
    Path path,
    Color borderColor,
    double borderWidth,
    double blurRadius,
    Color? glowColor, [
    double borderProgress = 1.0,
  ]) {
    final progress = borderProgress.clamp(0.0, 1.0);
    if (progress <= 0.0 || borderWidth <= 0) return;

    final effectiveGlowColor = glowColor ?? borderColor;

    // Blurred Glow Outer Halo
    if (blurRadius > 0) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth * 2.2
        ..color = effectiveGlowColor.withValues(alpha: 0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius)
        ..isAntiAlias = true;

      if (progress >= 1.0) {
        canvas.drawPath(path, glowPaint);
      } else {
        for (final metric in path.computeMetrics()) {
          if (metric.length <= 0) continue;
          canvas.drawPath(
            metric.extractPath(0.0, metric.length * progress),
            glowPaint,
          );
        }
      }
    }

    // Sharp Core Stroke
    _drawSolid(canvas, path, borderColor, borderWidth, progress);
  }

  // =========================================================================
  // --- Next-Gen Border Renderers (Phase 2) ---
  // =========================================================================

  static void _drawAnimatedGradient(
    Canvas canvas,
    Size size,
    Path path,
    Material4Config config,
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
    Material4Config config,
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
    Material4Config config,
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
    Material4Config config,
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
    Material4Config config,
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
    Material4Config config,
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
    Material4Config config,
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
    Material4Config config,
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
    Material4Config config,
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
    _drawSolid(
        canvas, path, borderColor, borderWidth * 0.8, config.borderProgress);
  }

  static void _drawInnerStroke(
    Canvas canvas,
    Size size,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    canvas.save();
    canvas.clipPath(path);
    _drawSolid(
      canvas,
      path,
      borderColor,
      borderWidth * 2.0,
      config.borderProgress,
    );
    canvas.restore();
  }

  static void _drawOuterStroke(
    Canvas canvas,
    Size size,
    Path path,
    Material4Config config,
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
    _drawSolid(
      canvas,
      path,
      borderColor,
      borderWidth * 2.0,
      config.borderProgress,
    );
    canvas.restore();
  }

  static void _drawNoiseTextured(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    // 1. Soft Base Under-Stroke
    _drawSolid(
      canvas,
      path,
      borderColor.withValues(alpha: 0.4),
      borderWidth,
      config.borderProgress,
    );

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
    Material4Config config,
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

  // =========================================================================
  // --- Universal Next-Gen Animated Border Renderers ---
  // =========================================================================

  static void _drawFlowingBorder(
    Canvas canvas,
    Size size,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final progress = config.borderProgress;
    final angle = progress * 2 * math.pi;

    final colors = (config.borderGradient?.colors ?? [
      borderColor,
      borderColor.withValues(alpha: 0.15),
      borderColor,
      borderColor.withValues(alpha: 0.9),
      borderColor,
    ]);

    paint.shader = SweepGradient(
      startAngle: angle,
      endAngle: angle + 2 * math.pi,
      colors: colors,
    ).createShader(Offset.zero & size);
    canvas.drawPath(path, paint);
  }

  static void _drawMovingDash(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final phase = config.dashPhase != 0.0
        ? config.dashPhase
        : config.borderProgress * (config.dashLength + config.dashGap) * 6.0;
    _drawDashed(
      canvas,
      path,
      borderColor,
      borderWidth,
      config.dashLength > 0 ? config.dashLength : 8.0,
      config.dashGap > 0 ? config.dashGap : 5.0,
      phase,
      config.borderGradient?.createShader(path.getBounds()),
      1.0,
    );
  }

  static void _drawPulsatingBorder(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final pulse = 0.75 + 0.35 * math.sin(config.borderProgress * 2 * math.pi);
    final currentWidth = borderWidth * pulse;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = currentWidth * 2.2
      ..color = borderColor.withValues(alpha: 0.35 * pulse)
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        config.glowBlurRadius > 0 ? config.glowBlurRadius : 6.0 * pulse,
      )
      ..isAntiAlias = true;
    canvas.drawPath(path, glowPaint);

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = currentWidth
      ..color = borderColor
      ..isAntiAlias = true;
    canvas.drawPath(path, corePaint);
  }

  static void _drawLiquidBorder(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final progress = config.borderProgress;
    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final liquidPath = Path();
      const step = 6.0;
      double dist = 0.0;
      bool first = true;

      while (dist < metric.length) {
        final tangent = metric.getTangentForOffset(dist);
        if (tangent != null) {
          final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
          final wave = math.sin((dist / metric.length * 4 * math.pi) +
                  progress * 2 * math.pi) *
              3.5;
          final pt = tangent.position + normal * wave;
          if (first) {
            liquidPath.moveTo(pt.dx, pt.dy);
            first = false;
          } else {
            liquidPath.lineTo(pt.dx, pt.dy);
          }
        }
        dist += step;
      }
      liquidPath.close();
      canvas.drawPath(liquidPath, paint);
    }
  }

  static void _drawWaveBorder(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final phase = config.borderProgress * 2 * math.pi;
    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final wavePath = Path();
      const step = 5.0;
      double dist = 0.0;
      bool first = true;

      while (dist < metric.length) {
        final tangent = metric.getTangentForOffset(dist);
        if (tangent != null) {
          final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
          final displacement = math.sin(dist * 0.15 + phase) * 2.5;
          final pt = tangent.position + normal * displacement;
          if (first) {
            wavePath.moveTo(pt.dx, pt.dy);
            first = false;
          } else {
            wavePath.lineTo(pt.dx, pt.dy);
          }
        }
        dist += step;
      }
      wavePath.close();
      canvas.drawPath(wavePath, paint);
    }
  }

  static void _drawZigzagBorder(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final zigzagPath = Path();
      const step = 8.0;
      double dist = 0.0;
      bool first = true;
      bool flip = false;

      while (dist < metric.length) {
        final tangent = metric.getTangentForOffset(dist);
        if (tangent != null) {
          final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
          final pt = tangent.position + normal * (flip ? 2.5 : -2.5);
          flip = !flip;
          if (first) {
            zigzagPath.moveTo(pt.dx, pt.dy);
            first = false;
          } else {
            zigzagPath.lineTo(pt.dx, pt.dy);
          }
        }
        dist += step;
      }
      zigzagPath.close();
      canvas.drawPath(zigzagPath, paint);
    }
  }

  static void _drawParticleBorder(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 0.6
      ..color = borderColor.withValues(alpha: 0.2)
      ..isAntiAlias = true;
    canvas.drawPath(path, basePaint);

    final sparkPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = borderColor
      ..isAntiAlias = true;

    final progress = config.borderProgress;
    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      const count = 16;
      for (int i = 0; i < count; i++) {
        final t = ((i / count) + progress) % 1.0;
        final tangent = metric.getTangentForOffset(t * metric.length);
        if (tangent != null) {
          final r =
              borderWidth * (1.2 + 0.6 * math.sin(i * 1.5 + progress * 6));
          canvas.drawCircle(tangent.position, r, sparkPaint);
        }
      }
    }
  }

  static void _drawOrbitingLightBorder(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 0.7
      ..color = borderColor.withValues(alpha: 0.18)
      ..isAntiAlias = true;
    canvas.drawPath(path, basePaint);

    final progress = config.borderProgress;
    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final cometLength = metric.length * 0.22;
      final headDist = (progress * metric.length) % metric.length;

      const segments = 12;
      for (int i = 0; i < segments; i++) {
        final tailDist = headDist - (i * (cometLength / segments));
        final clampedDist =
            tailDist < 0 ? tailDist + metric.length : tailDist;
        final alpha = (1.0 - (i / segments)).clamp(0.0, 1.0);
        final segmentPath = metric.extractPath(
          clampedDist,
          math.min(clampedDist + (cometLength / segments), metric.length),
        );
        final cometPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth * (1.0 + (1.0 - i / segments) * 0.8)
          ..color = borderColor.withValues(alpha: alpha)
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true;
        canvas.drawPath(segmentPath, cometPaint);
      }
    }
  }

  static void _drawDualLayerBorder(
    Canvas canvas,
    Size size,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor
      ..isAntiAlias = true;
    canvas.drawPath(path, outerPaint);

    canvas.save();
    canvas.clipPath(path);
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 0.6
      ..color = borderColor.withValues(alpha: 0.45)
      ..isAntiAlias = true;
    canvas.drawPath(path, innerPaint);
    canvas.restore();
  }

  static void _drawShimmerBorder(
    Canvas canvas,
    Size size,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor.withValues(alpha: 0.35)
      ..isAntiAlias = true;
    canvas.drawPath(path, basePaint);

    final progress = config.borderProgress;
    final w = size.width;
    final beamX = (progress * 2.0 - 0.5) * w;

    final shimmerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 1.4
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          borderColor.withValues(alpha: 0.0),
          Colors.white,
          borderColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(beamX - w * 0.25, 0, w * 0.5, size.height))
      ..isAntiAlias = true;
    canvas.drawPath(path, shimmerPaint);
  }

  static void _drawConicGradientBorder(
    Canvas canvas,
    Size size,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..isAntiAlias = true;

    final progress = config.borderProgress;
    final angle = progress * 2 * math.pi;

    paint.shader = SweepGradient(
      startAngle: angle,
      endAngle: angle + 2 * math.pi,
      colors: config.borderGradient?.colors ??
          const [
            Color(0xFFFF0055),
            Color(0xFFFFAA00),
            Color(0xFF00FFCC),
            Color(0xFF0066FF),
            Color(0xFFFF0055),
          ],
    ).createShader(Offset.zero & size);

    canvas.drawPath(path, paint);
  }

  static void _drawEnergyBorder(
    Canvas canvas,
    Path path,
    Material4Config config,
    Color borderColor,
    double borderWidth,
  ) {
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2.5
      ..color = borderColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0)
      ..isAntiAlias = true;
    canvas.drawPath(path, glowPaint);

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = Color.lerp(borderColor, Colors.white, 0.7)!
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final progress = config.borderProgress;
    for (final metric in path.computeMetrics()) {
      if (metric.length <= 0) continue;
      final plasmaPath = Path();
      const step = 5.0;
      double dist = 0.0;
      bool first = true;

      while (dist < metric.length) {
        final tangent = metric.getTangentForOffset(dist);
        if (tangent != null) {
          final normal = Offset(-tangent.vector.dy, tangent.vector.dx);
          final jitter = math.sin(dist * 0.8 + progress * 24.0) *
              math.cos(dist * 0.4 + progress * 16.0) *
              2.0;
          final pt = tangent.position + normal * jitter;
          if (first) {
            plasmaPath.moveTo(pt.dx, pt.dy);
            first = false;
          } else {
            plasmaPath.lineTo(pt.dx, pt.dy);
          }
        }
        dist += step;
      }
      plasmaPath.close();
      canvas.drawPath(plasmaPath, corePaint);
    }
  }
}
