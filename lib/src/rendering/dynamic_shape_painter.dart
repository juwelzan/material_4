import 'package:flutter/material.dart';

import '../dynamic_shape_config.dart';
import '../shape_background_renderer.dart';
import '../shape_border_painter.dart';
import '../shape_pattern.dart';

/// Canvas drawing coordinator for [RenderDynamicShape].
///
/// Encapsulates direct rendering routines for background fills, procedural effects,
/// patterns, inner/inset shadows, shimmer beams, and composite border profiles
/// without relying on a separate [CustomPainter] widget layer.
class DynamicShapePainter {
  const DynamicShapePainter._();

  /// Executes full shape painting pipeline directly onto [canvas].
  static void paintShape({
    required Canvas canvas,
    required Size size,
    required Path path,
    required DynamicShapeConfig config,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x18000000),
    double borderWidth = 1.0,
    List<BoxShadow>? shadows,
  }) {
    if (size.width <= 0 || size.height <= 0) return;

    // 1. Neo-Brutalism 3D Hard Offset Block
    if (config.borderStyle == BorderStyleType.neo3d) {
      final neoPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = config.neoColor;
      canvas.save();
      canvas.translate(config.neoOffset.dx, config.neoOffset.dy);
      canvas.drawPath(path, neoPaint);
      canvas.restore();
    }

    // 2. Soft Drop Shadows (if provided and not neo3d)
    if (config.borderStyle != BorderStyleType.neo3d &&
        shadows != null &&
        shadows.isNotEmpty) {
      for (final shadow in shadows) {
        final shadowPaint = Paint()
          ..color = shadow.color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius);
        canvas.save();
        canvas.translate(shadow.offset.dx, shadow.offset.dy);
        canvas.drawPath(path, shadowPaint);
        canvas.restore();
      }
    }

    // 3. Ambient Colored Glow Halo
    if (config.borderStyle == BorderStyleType.glow) {
      final glowColor = config.glowColor ?? borderColor;
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth * 2.5
        ..color = glowColor.withValues(alpha: 0.45)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, config.glowBlurRadius);
      canvas.drawPath(path, glowPaint);
    }

    // 4. Background Fill & Next-Gen Procedural Effects
    ShapeBackgroundRenderer.renderBackground(
      canvas: canvas,
      size: size,
      clipPath: path,
      config: config,
      baseColor: color,
      baseGradient: gradient,
    );

    // 5. Procedural Pattern Textures (Stripes, Dots, Grid, Waves)
    if (config.pattern != ShapePattern.none) {
      final patternColor = config.patternColor ??
          (color != null
              ? (color.computeLuminance() > 0.5
                  ? Colors.black.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.12))
              : const Color(0x0F000000));

      ShapePatternRenderer.drawPattern(
        canvas: canvas,
        clipPath: path,
        size: size,
        pattern: config.pattern,
        color: patternColor,
        spacing: config.patternSpacing,
        strokeWidth: config.patternStrokeWidth,
      );
    }

    // 6. Tactile Inset Inner Shadow (Claymorphic / Sculpted Depth)
    if (config.innerShadows != null && config.innerShadows!.isNotEmpty) {
      for (final innerShadow in config.innerShadows!) {
        _drawInnerShadow(canvas, path, innerShadow, size);
      }
    }

    // 7. Holographic Shimmer Light Sweep
    if (config.isShimmering) {
      _drawShimmer(canvas, path, size, config.shimmerProgress);
    }

    // 8. Unique Border Rendering based on BorderStyleType
    ShapeBorderPainter.paintBorder(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }

  static void _drawInnerShadow(
    Canvas canvas,
    Path path,
    BoxShadow innerShadow,
    Size size,
  ) {
    final shadowRect = (Offset.zero & size).inflate(innerShadow.blurRadius * 2);
    final shadowPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(shadowRect)
      ..addPath(path, Offset.zero);

    final shadowPaint = Paint()
      ..color = innerShadow.color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, innerShadow.blurRadius);

    canvas.save();
    canvas.clipPath(path);
    canvas.translate(innerShadow.offset.dx, innerShadow.offset.dy);
    canvas.drawPath(shadowPath, shadowPaint);
    canvas.restore();
  }

  static void _drawShimmer(
      Canvas canvas, Path path, Size size, double progress) {
    canvas.save();
    canvas.clipPath(path);

    final sweepSpan = size.width * 2.0;
    final sweepX = -size.width + sweepSpan * progress;
    final shimmerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: 0.0),
        Colors.white.withValues(alpha: 0.35),
        Colors.white.withValues(alpha: 0.0),
      ],
      stops: const [0.35, 0.5, 0.65],
    );

    final shimmerPaint = Paint()
      ..shader = shimmerGradient.createShader(
        Rect.fromLTWH(sweepX, 0, size.width, size.height),
      );

    canvas.drawRect(Offset.zero & size, shimmerPaint);
    canvas.restore();
  }
}
