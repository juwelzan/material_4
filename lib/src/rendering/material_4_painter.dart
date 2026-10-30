import 'package:flutter/material.dart';

import '../creative/borders/creative_border_painter.dart';
import '../creative/paper/paper_texture_renderer.dart';
import '../creative/paper/repeating_patterns.dart';
import '../creative/paper/stationery_patterns.dart';
import '../material_4_config.dart';
import '../shape_background_renderer.dart';
import '../shape_border_painter.dart';
import '../shape_pattern.dart';

/// Canvas drawing coordinator for [RenderMaterial4].
///
/// Encapsulates modular direct rendering routines for the complete 8-step painting pipeline:
/// - Stage 2: Outer shadows (Neo-3D hard block, soft drop shadows, ambient glow halo)
/// - Stage 3: Shape background fills & procedural background effects
/// - Stage 4: Procedural pattern textures (stripes, dots, grid, waves)
/// - Stage 5: Tactile inset inner shadows (claymorphic / sculpted depth)
/// - Stage 6: Composite border profiles (all 20 border styles, stroke alignments, and reveals)
/// - Stage 7: Foreground decorations (holographic shimmer light sweep)
class Material4Painter {
  const Material4Painter._();

  /// Stage 2: Outer Shadows.
  ///
  /// Renders Neo-3D brutalist offset blocks, soft multi-layer drop shadows,
  /// or ambient colored outer glow halos.
  static void paintOuterShadows({
    required Canvas canvas,
    required Size size,
    required Path path,
    required Material4Config config,
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

    // 2. Soft Multi-Layer Drop Shadows (if provided and not neo3d)
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
  }

  /// Stage 3: Shape Background & Procedural Background Effects.
  ///
  /// Renders glassmorphic backdrop tints, solid color fills, linear/radial/sweep gradients,
  /// and all procedural effects (meshGradient, noise, liquidGradient, animatedWaves, particles, aurora, etc.).
  static void paintBackground({
    required Canvas canvas,
    required Size size,
    required Path path,
    required Material4Config config,
    Color? color,
    Gradient? gradient,
  }) {
    if (size.width <= 0 || size.height <= 0) return;

    // Glassmorphic Frosted Tint
    if (config.isGlassmorphic) {
      canvas.save();
      canvas.clipPath(path);
      final tintPaint = Paint()
        ..color = config.glassTint ?? Colors.white.withValues(alpha: 0.15);
      canvas.drawPath(path, tintPaint);
      canvas.restore();
    }

    // Core Background Fill & Next-Gen Procedural Effects
    ShapeBackgroundRenderer.renderBackground(
      canvas: canvas,
      size: size,
      clipPath: path,
      config: config,
      baseColor: color,
      baseGradient: gradient,
    );

    // Tactile Physical Paper Material (Phase 7.1)
    if (config.paperBackground != null) {
      PaperTextureRenderer.renderPaperBackground(
        canvas: canvas,
        size: size,
        clipPath: path,
        config: config.paperBackground!,
      );
    }
  }

  /// Stage 4: Background Patterns.
  ///
  /// Renders procedural pattern textures (stripes, dots, grid, waves) clipped to the shape contour.
  static void paintPatterns({
    required Canvas canvas,
    required Size size,
    required Path path,
    required Material4Config config,
    Color? color,
  }) {
    if (size.width <= 0 || size.height <= 0) return;

    // Creative Stationery & Repeating Patterns (Phase 7.1)
    if (config.creativePattern != null) {
      final cp = config.creativePattern!;
      if (cp.stationeryType != null) {
        StationeryPatternRenderer.renderStationeryPattern(
          canvas: canvas,
          size: size,
          clipPath: path,
          config: cp,
        );
      } else if (cp.repeatingType != null) {
        CreativeRepeatingPatternRenderer.renderRepeatingPattern(
          canvas: canvas,
          size: size,
          clipPath: path,
          config: cp,
        );
      }
    }

    if (config.pattern == ShapePattern.none) return;

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

  /// Stage 5: Background Effects & Inner Shadows.
  ///
  /// Renders tactile inset inner shadows for claymorphic and sculpted depth effects.
  static void paintInnerShadows({
    required Canvas canvas,
    required Size size,
    required Path path,
    required Material4Config config,
  }) {
    if (size.width <= 0 || size.height <= 0) return;
    if (config.innerShadows == null || config.innerShadows!.isEmpty) return;

    for (final innerShadow in config.innerShadows!) {
      _drawInnerShadow(canvas, path, innerShadow, size);
    }
  }

  /// Stage 6: Distinctive Borders.
  ///
  /// Renders the shape border along the contour according to [config.borderStyle] (all 20 styles),
  /// stroke alignment, and animated borderProgress / dashPhase.
  static void paintBorders({
    required Canvas canvas,
    required Size size,
    required Path path,
    required Material4Config config,
    Color borderColor = const Color(0x18000000),
    double borderWidth = 1.0,
  }) {
    if (size.width <= 0 || size.height <= 0) return;

    // Advanced Creative Border Engine (Phase 7.1)
    if (config.creativeBorder != null) {
      CreativeBorderPainter.paintCreativeBorder(
        canvas: canvas,
        size: size,
        path: path,
        config: config.creativeBorder!,
      );
      return;
    }

    ShapeBorderPainter.paintBorder(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }

  /// Stage 7: Foreground Decorations.
  ///
  /// Renders holographic shimmer light sweep across the shape surface.
  static void paintForegroundDecorations({
    required Canvas canvas,
    required Size size,
    required Path path,
    required Material4Config config,
  }) {
    if (size.width <= 0 || size.height <= 0) return;
    if (!config.isShimmering) return;

    _drawShimmer(canvas, path, size, config.shimmerProgress);
  }

  /// Executes full shape canvas drawing pipeline (stages 2 through 7).
  ///
  /// Legacy adapters and external painters can call this to reproduce the complete
  /// Canvas drawing pass without managing the individual sub-stages.
  static void paintShape({
    required Canvas canvas,
    required Size size,
    required Path path,
    required Material4Config config,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x18000000),
    double borderWidth = 1.0,
    List<BoxShadow>? shadows,
  }) {
    if (size.width <= 0 || size.height <= 0) return;

    // Stage 2: Outer Shadows
    paintOuterShadows(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
    );

    // Stage 3: Shape Background & Procedural Effects
    paintBackground(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
      color: color,
      gradient: gradient,
    );

    // Stage 4: Background Patterns
    paintPatterns(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
      color: color,
    );

    // Stage 5: Inner Shadows
    paintInnerShadows(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
    );

    // Stage 6: Borders
    paintBorders(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );

    // Stage 7: Foreground Decorations
    paintForegroundDecorations(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
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
    Canvas canvas,
    Path path,
    Size size,
    double progress,
  ) {
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
