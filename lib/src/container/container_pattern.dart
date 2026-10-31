import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../shape_pattern.dart';

/// Available procedural background pattern motifs for [Material4Container].
enum Material4PatternType {
  none,

  /// Original 5 Patterns (Preserved for 100% Backward Compatibility)
  diagonalStripes,
  dotsMatrix,
  gridLines,
  guillocheWaves,
  crossHatch,

  /// Expanded Next-Gen Patterns
  checkerboard,
  hexagonalGrid,
  trianglePattern,
  wavePattern,
  zigzagPattern,
  concentricCircles,
  radialLines,
  isometricGrid,
  circuitPattern,
  meshPattern,
  flowingLines,
  pulsatingDots,
}

/// Comprehensive background pattern model for [Material4Container].
@immutable
class Material4Pattern {
  /// The pattern geometry motif.
  final Material4PatternType type;

  /// Spacing between adjacent pattern entities (pixels).
  final double spacing;

  /// Stroke width for line-based patterns or dot radius for matrix patterns.
  final double strokeWidth;

  /// Overall scale multiplier for pattern density.
  final double scale;

  /// Rotation angle in radians applied to the pattern coordinates.
  final double rotation;

  /// Coordinate translation offset.
  final Offset offset;

  /// Color override for the pattern stroke or fill.
  final Color? color;

  /// Opacity multiplier (0.0 to 1.0).
  final double opacity;

  /// Whether real-time pattern animation is enabled.
  final bool animated;

  /// Animation speed multiplier.
  final double animationSpeed;

  /// Direction vector for moving patterns.
  final Offset direction;

  /// Normalized animation phase progress (0.0 to 1.0).
  final double progress;

  const Material4Pattern({
    this.type = Material4PatternType.none,
    this.spacing = 16.0,
    this.strokeWidth = 1.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.offset = Offset.zero,
    this.color,
    this.opacity = 0.15,
    this.animated = false,
    this.animationSpeed = 1.0,
    this.direction = const Offset(1.0, 1.0),
    this.progress = 0.0,
  });

  /// Adapts a legacy [ShapePattern] enum to [Material4Pattern].
  factory Material4Pattern.fromShapePattern(
    ShapePattern pattern, {
    Color? color,
    double spacing = 16.0,
    double strokeWidth = 1.0,
  }) {
    switch (pattern) {
      case ShapePattern.none:
        return const Material4Pattern(type: Material4PatternType.none);
      case ShapePattern.diagonalStripes:
        return Material4Pattern(
          type: Material4PatternType.diagonalStripes,
          color: color,
          spacing: spacing,
          strokeWidth: strokeWidth,
        );
      case ShapePattern.dotsMatrix:
        return Material4Pattern(
          type: Material4PatternType.dotsMatrix,
          color: color,
          spacing: spacing,
          strokeWidth: strokeWidth,
        );
      case ShapePattern.gridLines:
        return Material4Pattern(
          type: Material4PatternType.gridLines,
          color: color,
          spacing: spacing,
          strokeWidth: strokeWidth,
        );
      case ShapePattern.guillocheWaves:
        return Material4Pattern(
          type: Material4PatternType.guillocheWaves,
          color: color,
          spacing: spacing,
          strokeWidth: strokeWidth,
        );
      case ShapePattern.crossHatch:
        return Material4Pattern(
          type: Material4PatternType.crossHatch,
          color: color,
          spacing: spacing,
          strokeWidth: strokeWidth,
        );
    }
  }

  /// Preset for clean orthogonal drafting grid lines.
  const Material4Pattern.grid({
    double spacing = 16.0,
    double strokeWidth = 1.0,
    Color? color,
    double opacity = 0.15,
    bool animated = false,
  }) : this(
          type: Material4PatternType.gridLines,
          spacing: spacing,
          strokeWidth: strokeWidth,
          color: color,
          opacity: opacity,
          animated: animated,
        );

  /// Preset for bullet-journal polka dot matrix.
  const Material4Pattern.dots({
    double spacing = 14.0,
    double dotRadius = 1.2,
    Color? color,
    double opacity = 0.18,
    bool animated = false,
  }) : this(
          type: Material4PatternType.dotsMatrix,
          spacing: spacing,
          strokeWidth: dotRadius,
          color: color,
          opacity: opacity,
          animated: animated,
        );

  /// Preset for technical 60-degree isometric drafting grid.
  const Material4Pattern.isometric({
    double spacing = 20.0,
    double strokeWidth = 1.0,
    Color? color,
    double opacity = 0.15,
  }) : this(
          type: Material4PatternType.isometricGrid,
          spacing: spacing,
          strokeWidth: strokeWidth,
          color: color,
          opacity: opacity,
        );

  /// Preset for organic hexagonal honeycomb grid tiles.
  const Material4Pattern.hexagonal({
    double spacing = 24.0,
    double strokeWidth = 1.0,
    Color? color,
    double opacity = 0.16,
  }) : this(
          type: Material4PatternType.hexagonalGrid,
          spacing: spacing,
          strokeWidth: strokeWidth,
          color: color,
          opacity: opacity,
        );

  /// Preset for sinusoidal wave ripples.
  const Material4Pattern.waves({
    double spacing = 18.0,
    double strokeWidth = 1.2,
    Color? color,
    double opacity = 0.18,
    bool animated = true,
  }) : this(
          type: Material4PatternType.wavePattern,
          spacing: spacing,
          strokeWidth: strokeWidth,
          color: color,
          opacity: opacity,
          animated: animated,
        );

  /// Preset for digital cyber circuit board traces.
  const Material4Pattern.circuit({
    double spacing = 22.0,
    double strokeWidth = 1.2,
    Color? color,
    double opacity = 0.22,
    bool animated = false,
  }) : this(
          type: Material4PatternType.circuitPattern,
          spacing: spacing,
          strokeWidth: strokeWidth,
          color: color,
          opacity: opacity,
          animated: animated,
        );

  /// Preset for diagonal hazard stripes.
  const Material4Pattern.stripes({
    double spacing = 16.0,
    double strokeWidth = 2.0,
    Color? color,
    double opacity = 0.18,
    bool animated = false,
  }) : this(
          type: Material4PatternType.diagonalStripes,
          spacing: spacing,
          strokeWidth: strokeWidth,
          color: color,
          opacity: opacity,
          animated: animated,
        );

  Material4Pattern copyWith({
    Material4PatternType? type,
    double? spacing,
    double? strokeWidth,
    double? scale,
    double? rotation,
    Offset? offset,
    Color? color,
    double? opacity,
    bool? animated,
    double? animationSpeed,
    Offset? direction,
    double? progress,
  }) {
    return Material4Pattern(
      type: type ?? this.type,
      spacing: spacing ?? this.spacing,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      offset: offset ?? this.offset,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      animated: animated ?? this.animated,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      direction: direction ?? this.direction,
      progress: progress ?? this.progress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4Pattern &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          spacing == other.spacing &&
          strokeWidth == other.strokeWidth &&
          scale == other.scale &&
          rotation == other.rotation &&
          offset == other.offset &&
          color == other.color &&
          opacity == other.opacity &&
          animated == other.animated &&
          animationSpeed == other.animationSpeed &&
          progress == other.progress;

  @override
  int get hashCode => Object.hash(
        type,
        spacing,
        strokeWidth,
        scale,
        rotation,
        offset,
        color,
        opacity,
        animated,
        animationSpeed,
        progress,
      );
}

/// Procedural GPU canvas renderer for [Material4Pattern].
class Material4PatternRenderer {
  const Material4PatternRenderer._();

  /// Draws the requested [pattern] onto [canvas], strictly clipped to [clipPath].
  static void renderPattern({
    required Canvas canvas,
    required Size size,
    required Path clipPath,
    required Material4Pattern pattern,
    double animationProgress = 0.0,
  }) {
    if (pattern.type == Material4PatternType.none ||
        pattern.opacity <= 0.0 ||
        size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    canvas.save();
    canvas.clipPath(clipPath);

    final w = size.width;
    final h = size.height;
    final resolvedColor = (pattern.color ?? const Color(0xFF000000)).withValues(alpha: pattern.opacity);
    final paint = Paint()
      ..color = resolvedColor
      ..strokeWidth = pattern.strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final effectiveSpacing = (pattern.spacing * pattern.scale).clamp(4.0, 200.0);
    final effectiveProgress = pattern.progress > 0.0 ? pattern.progress : animationProgress;
    final animShift = (pattern.animated || pattern.progress > 0.0)
        ? (effectiveProgress * effectiveSpacing * pattern.animationSpeed)
        : 0.0;

    switch (pattern.type) {
      case Material4PatternType.none:
        break;

      case Material4PatternType.diagonalStripes:
        final totalSpan = w + h;
        for (double d = -h + (animShift % effectiveSpacing); d < totalSpan; d += effectiveSpacing) {
          canvas.drawLine(Offset(d, 0), Offset(d + h, h), paint);
        }
        break;

      case Material4PatternType.dotsMatrix:
        final dotPaint = Paint()
          ..color = resolvedColor
          ..style = PaintingStyle.fill;
        final r = pattern.strokeWidth;
        for (double y = (effectiveSpacing * 0.5 + animShift) % effectiveSpacing; y < h; y += effectiveSpacing) {
          for (double x = effectiveSpacing * 0.5; x < w; x += effectiveSpacing) {
            canvas.drawCircle(Offset(x, y), r, dotPaint);
          }
        }
        break;

      case Material4PatternType.gridLines:
        final shiftX = animShift % effectiveSpacing;
        final shiftY = animShift % effectiveSpacing;
        for (double y = shiftY; y <= h; y += effectiveSpacing) {
          canvas.drawLine(Offset(0, y), Offset(w, y), paint);
        }
        for (double x = shiftX; x <= w; x += effectiveSpacing) {
          canvas.drawLine(Offset(x, 0), Offset(x, h), paint);
        }
        break;

      case Material4PatternType.guillocheWaves:
      case Material4PatternType.wavePattern:
        final wavePath = Path();
        final phase = pattern.animated ? (animationProgress * 2 * math.pi) : 0.0;
        for (double y = effectiveSpacing / 2; y < h; y += effectiveSpacing) {
          wavePath.moveTo(0, y);
          for (double x = 0; x <= w; x += 16) {
            final wy = y + math.sin((x / 16) + phase) * (effectiveSpacing * 0.28);
            wavePath.lineTo(x, wy);
          }
        }
        canvas.drawPath(wavePath, paint);
        break;

      case Material4PatternType.crossHatch:
        final total = w + h;
        for (double d = -h; d < total; d += effectiveSpacing) {
          canvas.drawLine(Offset(d, 0), Offset(d + h, h), paint);
          canvas.drawLine(Offset(d + h, 0), Offset(d, h), paint);
        }
        break;

      case Material4PatternType.checkerboard:
        final fillPaint = Paint()
          ..color = resolvedColor
          ..style = PaintingStyle.fill;
        for (double y = 0; y < h; y += effectiveSpacing) {
          final row = (y / effectiveSpacing).floor();
          for (double x = 0; x < w; x += effectiveSpacing) {
            final col = (x / effectiveSpacing).floor();
            if ((row + col) % 2 == 0) {
              canvas.drawRect(Rect.fromLTWH(x, y, effectiveSpacing, effectiveSpacing), fillPaint);
            }
          }
        }
        break;

      case Material4PatternType.hexagonalGrid:
        final hexRadius = effectiveSpacing / math.sqrt(3);
        final hexH = 1.5 * hexRadius;
        final hexW = math.sqrt(3) * hexRadius;

        for (double y = 0; y < h + hexH; y += hexH) {
          final row = (y / hexH).floor();
          final offsetX = (row % 2 != 0) ? hexW / 2 : 0.0;
          for (double x = -hexW; x < w + hexW; x += hexW) {
            _drawHexagon(canvas, Offset(x + offsetX, y), hexRadius, paint);
          }
        }
        break;

      case Material4PatternType.trianglePattern:
        final side = effectiveSpacing;
        final triH = side * (math.sqrt(3) / 2);
        for (double y = 0; y < h + triH; y += triH) {
          for (double x = -side; x < w + side; x += side) {
            final path = Path()
              ..moveTo(x, y)
              ..lineTo(x + side, y)
              ..lineTo(x + side / 2, y + triH)
              ..close();
            canvas.drawPath(path, paint);
          }
        }
        break;

      case Material4PatternType.zigzagPattern:
        final zigPath = Path();
        final seg = effectiveSpacing * 0.5;
        for (double y = 0; y < h + effectiveSpacing; y += effectiveSpacing) {
          zigPath.moveTo(0, y);
          bool up = true;
          for (double x = 0; x <= w; x += seg) {
            zigPath.lineTo(x, up ? y - seg * 0.5 : y + seg * 0.5);
            up = !up;
          }
        }
        canvas.drawPath(zigPath, paint);
        break;

      case Material4PatternType.concentricCircles:
        final cx = w / 2;
        final cy = h / 2;
        final maxR = math.sqrt(w * w + h * h) / 2;
        final shift = animShift % effectiveSpacing;
        for (double r = shift; r < maxR; r += effectiveSpacing) {
          canvas.drawCircle(Offset(cx, cy), r, paint);
        }
        break;

      case Material4PatternType.radialLines:
        final cx = w / 2;
        final cy = h / 2;
        const lineCount = 24;
        final angleStep = 2 * math.pi / lineCount;
        final rot = pattern.animated ? (animationProgress * 2 * math.pi) : 0.0;
        final maxLen = math.sqrt(w * w + h * h);
        for (int i = 0; i < lineCount; i++) {
          final a = rot + i * angleStep;
          canvas.drawLine(
            Offset(cx, cy),
            Offset(cx + maxLen * math.cos(a), cy + maxLen * math.sin(a)),
            paint,
          );
        }
        break;

      case Material4PatternType.isometricGrid:
        final dY = effectiveSpacing * math.tan(math.pi / 6);
        for (double y = -h; y < h * 2; y += effectiveSpacing) {
          canvas.drawLine(Offset(0, y), Offset(w, y), paint);
          canvas.drawLine(Offset(0, y), Offset(w, y + w * dY / effectiveSpacing), paint);
          canvas.drawLine(Offset(0, y), Offset(w, y - w * dY / effectiveSpacing), paint);
        }
        break;

      case Material4PatternType.circuitPattern:
        final step = effectiveSpacing;
        for (double y = step; y < h; y += step) {
          final isEven = (y / step).floor() % 2 == 0;
          canvas.drawLine(Offset(0, y), Offset(w * 0.4, y), paint);
          if (isEven) {
            canvas.drawLine(Offset(w * 0.4, y), Offset(w * 0.5, y + step * 0.5), paint);
            canvas.drawLine(Offset(w * 0.5, y + step * 0.5), Offset(w, y + step * 0.5), paint);
          } else {
            canvas.drawLine(Offset(w * 0.4, y), Offset(w * 0.5, y - step * 0.5), paint);
            canvas.drawLine(Offset(w * 0.5, y - step * 0.5), Offset(w, y - step * 0.5), paint);
          }
        }
        break;

      case Material4PatternType.meshPattern:
        for (double x = 0; x < w; x += effectiveSpacing) {
          for (double y = 0; y < h; y += effectiveSpacing) {
            canvas.drawRect(Rect.fromLTWH(x, y, effectiveSpacing - 2, effectiveSpacing - 2), paint);
          }
        }
        break;

      case Material4PatternType.flowingLines:
        final flowPath = Path();
        final phase = pattern.animated ? animationProgress * 2 * math.pi : 0.0;
        for (double y = 10; y < h; y += effectiveSpacing) {
          flowPath.moveTo(0, y);
          flowPath.cubicTo(
            w * 0.33,
            y + math.sin(phase) * 15,
            w * 0.66,
            y + math.cos(phase) * 15,
            w,
            y,
          );
        }
        canvas.drawPath(flowPath, paint);
        break;

      case Material4PatternType.pulsatingDots:
        final dotPaint = Paint()
          ..color = resolvedColor
          ..style = PaintingStyle.fill;
        final pulse = pattern.animated ? (math.sin(animationProgress * 2 * math.pi) * 0.5 + 0.5) : 1.0;
        final r = pattern.strokeWidth * (0.8 + 0.6 * pulse);
        for (double y = effectiveSpacing / 2; y < h; y += effectiveSpacing) {
          for (double x = effectiveSpacing / 2; x < w; x += effectiveSpacing) {
            canvas.drawCircle(Offset(x, y), r, dotPaint);
          }
        }
        break;
    }

    canvas.restore();
  }

  static void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * math.pi / 180;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }
}
