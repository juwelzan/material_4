import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'dynamic_shape_config.dart';

/// Next-Generation high-performance background effect renderer.
///
/// Implements mesh gradients, noise textures, fluid liquid gradients,
/// animated waves, floating particles, aurora borealis, holographic sheen,
/// and metallic lustres natively using Flutter Canvas APIs.
class ShapeBackgroundRenderer {
  const ShapeBackgroundRenderer._();

  /// Paint the background effects inside [clipPath].
  static void renderBackground({
    required Canvas canvas,
    required Size size,
    required Path clipPath,
    required DynamicShapeConfig config,
    Color? baseColor,
    Gradient? baseGradient,
  }) {
    if (size.width <= 0 || size.height <= 0) return;

    canvas.save();
    canvas.clipPath(clipPath);

    // 1. Base Fill (Solid color or base gradient)
    final fillPaint = Paint()..style = PaintingStyle.fill;
    if (baseGradient != null) {
      fillPaint.shader = baseGradient.createShader(Offset.zero & size);
      canvas.drawRect(Offset.zero & size, fillPaint);
    } else {
      fillPaint.color = baseColor ?? Colors.white;
      canvas.drawRect(Offset.zero & size, fillPaint);
    }

    // 2. Procedural Next-Gen Background Effect
    switch (config.backgroundEffect) {
      case BackgroundEffectType.none:
        break;

      case BackgroundEffectType.meshGradient:
        _drawMeshGradient(canvas, size, config);
        break;

      case BackgroundEffectType.noise:
        _drawNoise(canvas, size, config.noiseOpacity);
        break;

      case BackgroundEffectType.liquidGradient:
        _drawLiquidGradient(canvas, size, config.backgroundProgress);
        break;

      case BackgroundEffectType.radial:
        _drawRadial(canvas, size, baseColor);
        break;

      case BackgroundEffectType.conic:
        _drawConic(canvas, size, config.backgroundProgress, baseColor);
        break;

      case BackgroundEffectType.animatedWaves:
        _drawAnimatedWaves(canvas, size, config);
        break;

      case BackgroundEffectType.particles:
        _drawParticles(canvas, size, config);
        break;

      case BackgroundEffectType.aurora:
        _drawAurora(canvas, size, config.backgroundProgress);
        break;

      case BackgroundEffectType.holographic:
        _drawHolographic(canvas, size, config.backgroundProgress);
        break;

      case BackgroundEffectType.frostedGlass:
        _drawFrostedGlass(canvas, size, config);
        break;

      case BackgroundEffectType.metallic:
        _drawMetallic(canvas, size, config.metallicType);
        break;
    }

    canvas.restore();
  }

  // =========================================================================
  // --- Background Effect Implementations ---
  // =========================================================================

  static void _drawMeshGradient(
    Canvas canvas,
    Size size,
    DynamicShapeConfig config,
  ) {
    final colors =
        config.meshColors ??
        const [
          Color(0xFF6C5CE7), // Top-Left
          Color(0xFFFF7675), // Top-Right
          Color(0xFF74B9FF), // Bottom-Left
          Color(0xFFA29BFE), // Bottom-Right
        ];

    final w = size.width;
    final h = size.height;
    final maxDim = math.max(w, h);

    // Render 4 overlapping radial gradient corner anchors
    final corners = [Offset.zero, Offset(w, 0), Offset(0, h), Offset(w, h)];

    for (int i = 0; i < 4 && i < colors.length; i++) {
      final paint = Paint()
        ..shader = ui.Gradient.radial(
          corners[i],
          maxDim * 0.95,
          [colors[i].withValues(alpha: 0.85), colors[i].withValues(alpha: 0.0)],
          [0.0, 1.0],
        );
      canvas.drawRect(Offset.zero & size, paint);
    }
  }

  static void _drawNoise(Canvas canvas, Size size, double opacity) {
    if (opacity <= 0) return;
    final grainPaint = Paint()..style = PaintingStyle.fill;
    final safeOpacity = opacity.clamp(0.01, 0.4);

    // Fast deterministic pseudo-random noise grid
    int seed = 12345;
    const step = 4.0;
    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF;
        final rand = (seed % 100) / 100.0;
        if (rand > 0.6) {
          final isDark = rand > 0.8;
          grainPaint.color = isDark
              ? Colors.black.withValues(alpha: safeOpacity * 0.7)
              : Colors.white.withValues(alpha: safeOpacity);
          canvas.drawRect(Rect.fromLTWH(x, y, 1.2, 1.2), grainPaint);
        }
      }
    }
  }

  static void _drawLiquidGradient(Canvas canvas, Size size, double progress) {
    final w = size.width;
    final h = size.height;
    final t = progress * 2 * math.pi;

    // Moving fluid organic metaball blobs
    final blobs = [
      Offset(w * (0.3 + 0.2 * math.sin(t)), h * (0.3 + 0.2 * math.cos(t))),
      Offset(
        w * (0.7 + 0.18 * math.cos(t * 1.3)),
        h * (0.6 + 0.22 * math.sin(t * 0.9)),
      ),
      Offset(
        w * (0.45 + 0.25 * math.sin(t * 0.7 + 1.5)),
        h * (0.8 + 0.15 * math.cos(t * 1.1)),
      ),
    ];

    const blobColors = [
      Color(0xFF6C5CE7),
      Color(0xFF00CEC9),
      Color(0xFFFD79A8),
    ];

    for (int i = 0; i < blobs.length; i++) {
      final paint = Paint()
        ..shader = ui.Gradient.radial(blobs[i], math.max(w, h) * 0.65, [
          blobColors[i].withValues(alpha: 0.6),
          blobColors[i].withValues(alpha: 0.0),
        ]);
      canvas.drawRect(Offset.zero & size, paint);
    }
  }

  static void _drawRadial(Canvas canvas, Size size, Color? baseColor) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.max(size.width, size.height) * 0.7;
    final color = baseColor ?? const Color(0xFF6C5CE7);

    final paint = Paint()
      ..shader = ui.Gradient.radial(center, radius, [
        color.withValues(alpha: 0.9),
        color.withValues(alpha: 0.2),
      ]);
    canvas.drawRect(Offset.zero & size, paint);
  }

  static void _drawConic(
    Canvas canvas,
    Size size,
    double progress,
    Color? baseColor,
  ) {
    final angle = progress * 2 * math.pi;
    final color = baseColor ?? const Color(0xFF6C5CE7);

    final paint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: angle,
        endAngle: angle + 2 * math.pi,
        colors: [
          color,
          color.withValues(alpha: 0.2),
          color.withValues(alpha: 0.9),
          color,
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, paint);
  }

  static void _drawAnimatedWaves(
    Canvas canvas,
    Size size,
    DynamicShapeConfig config,
  ) {
    final w = size.width;
    final h = size.height;
    final phase = config.backgroundProgress * 2 * math.pi;
    final baseLevel = h * (1.0 - config.waveLevel.clamp(0.0, 1.0));

    // Wave Layer 1 (Back Crest)
    final backWavePath = Path()..moveTo(0, h);
    for (double x = 0; x <= w; x += 4) {
      final y = baseLevel + math.sin((x / w * 2 * math.pi * 1.5) + phase) * 8.0;
      backWavePath.lineTo(x, y);
    }
    backWavePath.lineTo(w, h);
    backWavePath.close();

    final backPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00C6FF).withValues(alpha: 0.35),
          const Color(0xFF0072FF).withValues(alpha: 0.6),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(backWavePath, backPaint);

    // Wave Layer 2 (Front Crest)
    final frontWavePath = Path()..moveTo(0, h);
    for (double x = 0; x <= w; x += 4) {
      final y =
          baseLevel +
          math.sin((x / w * 2 * math.pi * 2.0) - phase + 1.2) * 6.0 +
          4.0;
      frontWavePath.lineTo(x, y);
    }
    frontWavePath.lineTo(w, h);
    frontWavePath.close();

    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0072FF).withValues(alpha: 0.5),
          const Color(0xFF0052D4).withValues(alpha: 0.85),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(frontWavePath, frontPaint);
  }

  static void _drawParticles(
    Canvas canvas,
    Size size,
    DynamicShapeConfig config,
  ) {
    final count = config.particleCount.clamp(4, 40);
    final progress = config.backgroundProgress;
    final particlePaint = Paint()..style = PaintingStyle.fill;

    int seed = 777;
    for (int i = 0; i < count; i++) {
      seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF;
      final startX = (seed % 1000) / 1000.0 * size.width;
      seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF;
      final startY = (seed % 1000) / 1000.0 * size.height;
      seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF;
      final radius = 1.5 + ((seed % 100) / 100.0) * 3.0;

      // Floating drift animation
      final currentY = (startY - (progress * size.height * 0.8)) % size.height;
      final currentX = startX + math.sin(progress * 2 * math.pi + i) * 6.0;

      particlePaint.color = Colors.white.withValues(alpha: 0.45);
      canvas.drawCircle(Offset(currentX, currentY), radius, particlePaint);
    }
  }

  static void _drawAurora(Canvas canvas, Size size, double progress) {
    final w = size.width;
    final h = size.height;
    final t = progress * 2 * math.pi;

    const auroraColors = [
      Color(0xFF00FFA3), // Emerald glow
      Color(0xFF00D8D6), // Vibrant cyan
      Color(0xFF9B51E0), // Deep purple
      Color(0xFFFF007A), // Hot magenta
    ];

    for (int i = 0; i < auroraColors.length; i++) {
      final xCenter = w * (0.25 * i + 0.15 * math.sin(t + i));
      final auroraPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(xCenter, 0),
          Offset(xCenter + w * 0.35, h),
          [
            auroraColors[i].withValues(alpha: 0.0),
            auroraColors[i].withValues(alpha: 0.45),
            auroraColors[i].withValues(alpha: 0.0),
          ],
          const [0.0, 0.5, 1.0],
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18.0);

      canvas.drawRect(Offset.zero & size, auroraPaint);
    }
  }

  static void _drawHolographic(Canvas canvas, Size size, double progress) {
    final angle = (progress * 2 * math.pi) % (2 * math.pi);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.max(size.width, size.height);
    final dx = math.cos(angle) * radius;
    final dy = math.sin(angle) * radius;

    const holoColors = [
      Color(0x33FF9A9E),
      Color(0x33FECFEF),
      Color(0x33A1C4FD),
      Color(0x33C2E9FB),
      Color(0x33FF9A9E),
    ];

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(cx - dx, cy - dy),
        Offset(cx + dx, cy + dy),
        holoColors,
        const [0.0, 0.25, 0.5, 0.75, 1.0],
      );

    canvas.drawRect(Offset.zero & size, paint);
  }

  static void _drawFrostedGlass(
    Canvas canvas,
    Size size,
    DynamicShapeConfig config,
  ) {
    final tint = config.glassTint ?? Colors.white.withValues(alpha: 0.18);
    final glassPaint = Paint()..color = tint;
    canvas.drawRect(Offset.zero & size, glassPaint);

    // Subtle specular light beam along top edge
    final specularPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.3));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.3),
      specularPaint,
    );
  }

  static void _drawMetallic(Canvas canvas, Size size, MetallicType type) {
    final colors = switch (type) {
      MetallicType.gold => const [
        Color(0xFFFFECB3),
        Color(0xFFFFD54F),
        Color(0xFFFFF8E1),
        Color(0xFFFFC107),
        Color(0xFFFFECB3),
      ],
      MetallicType.chrome => const [
        Color(0xFFFFFFFF),
        Color(0xFFCFD8DC),
        Color(0xFFFFFFFF),
        Color(0xFF90A4AE),
        Color(0xFFFFFFFF),
      ],
      MetallicType.silver => const [
        Color(0xFFECEFF1),
        Color(0xFFCFD8DC),
        Color(0xFFFFFFFF),
        Color(0xFFB0BEC5),
        Color(0xFFECEFF1),
      ],
      MetallicType.roseGold => const [
        Color(0xFFFCE4EC),
        Color(0xFFF48FB1),
        Color(0xFFFFFFFF),
        Color(0xFFE91E63),
        Color(0xFFFCE4EC),
      ],
      MetallicType.bronze => const [
        Color(0xFFEFEBE9),
        Color(0xFFBCAAA4),
        Color(0xFFFFFFFF),
        Color(0xFF8D6E63),
        Color(0xFFEFEBE9),
      ],
      MetallicType.titanium => const [
        Color(0xFFB0BEC5),
        Color(0xFF78909C),
        Color(0xFFCFD8DC),
        Color(0xFF455A64),
        Color(0xFFB0BEC5),
      ],
    };

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, paint);
  }
}
