import 'dart:ui';
import 'package:flutter/material.dart';

/// Style preset for [Material4AvatarBorder].
enum AvatarBorderStyle {
  /// No visible border.
  none,

  /// Solid single color stroke.
  solid,

  /// Multi-color gradient stroke.
  gradient,

  /// Dual concentric border strokes with an intermediate gap.
  doubleBorder,

  /// Dashed stroke following the avatar's custom vector path.
  dashed,

  /// Dotted stroke following the avatar's custom vector path.
  dotted,

  /// Radiant glowing halo border with blur filter.
  glow,

  /// Beveled sculpted border with dynamic directional lighting.
  sculpted,
}

/// Controls the alignment of the border relative to the avatar silhouette.
enum AvatarBorderOffset {
  /// Border is drawn completely inside the avatar path.
  inner,

  /// Border is centered along the avatar path contour.
  center,

  /// Border is drawn outside the avatar path.
  outer,
}

/// Advanced border configuration engine for [Material4Avatar].
///
/// Follows the exact arbitrary vector [Path] of any basic, organic, or creative shape.
@immutable
class Material4AvatarBorder {
  /// Visual style of this border.
  final AvatarBorderStyle style;

  /// Primary color of the border stroke.
  final Color color;

  /// Stroke width in logical pixels.
  final double width;

  /// Optional gradient for gradient borders.
  final Gradient? gradient;

  /// Length of each dash segment for [AvatarBorderStyle.dashed].
  final double dashLength;

  /// Spacing between dash segments for [AvatarBorderStyle.dashed] or [AvatarBorderStyle.dotted].
  final double dashGap;

  /// Outer halo glow color for [AvatarBorderStyle.glow].
  final Color? glowColor;

  /// Blur radius for [AvatarBorderStyle.glow].
  final double glowRadius;

  /// Spread distance for [AvatarBorderStyle.glow].
  final double glowSpread;

  /// Gap distance between the avatar body and the outer border stroke (e.g. story rings).
  final double gap;

  /// Color filling the gap region between avatar and border.
  final Color? gapColor;

  /// Inner stroke width for [AvatarBorderStyle.doubleBorder].
  final double innerWidth;

  /// Inner stroke color for [AvatarBorderStyle.doubleBorder].
  final Color? innerColor;

  /// Alignment of the border stroke relative to the shape contour.
  final AvatarBorderOffset offset;

  const Material4AvatarBorder({
    this.style = AvatarBorderStyle.solid,
    this.color = Colors.white,
    this.width = 2.0,
    this.gradient,
    this.dashLength = 6.0,
    this.dashGap = 4.0,
    this.glowColor,
    this.glowRadius = 6.0,
    this.glowSpread = 2.0,
    this.gap = 0.0,
    this.gapColor,
    this.innerWidth = 1.5,
    this.innerColor,
    this.offset = AvatarBorderOffset.outer,
  });

  /// No border stroke.
  const Material4AvatarBorder.none()
      : style = AvatarBorderStyle.none,
        color = Colors.transparent,
        width = 0.0,
        gradient = null,
        dashLength = 0,
        dashGap = 0,
        glowColor = null,
        glowRadius = 0,
        glowSpread = 0,
        gap = 0,
        gapColor = null,
        innerWidth = 0,
        innerColor = null,
        offset = AvatarBorderOffset.center;

  /// Solid single color border stroke.
  const Material4AvatarBorder.solid({
    Color color = Colors.white,
    double width = 2.0,
    double gap = 0.0,
    Color? gapColor,
    AvatarBorderOffset offset = AvatarBorderOffset.outer,
  }) : this(
          style: AvatarBorderStyle.solid,
          color: color,
          width: width,
          gap: gap,
          gapColor: gapColor,
          offset: offset,
        );

  /// Vibrant gradient border stroke (e.g. Instagram/stories ring).
  const Material4AvatarBorder.gradient({
    required Gradient gradient,
    double width = 2.5,
    double gap = 2.0,
    Color? gapColor,
    AvatarBorderOffset offset = AvatarBorderOffset.outer,
  }) : this(
          style: AvatarBorderStyle.gradient,
          color: Colors.white,
          width: width,
          gradient: gradient,
          gap: gap,
          gapColor: gapColor,
          offset: offset,
        );

  /// Concentric double border strokes separated by [gap].
  const Material4AvatarBorder.doubleBorder({
    Color color = Colors.white,
    Color? innerColor,
    double width = 2.0,
    double innerWidth = 1.5,
    double gap = 2.5,
    Color? gapColor,
  }) : this(
          style: AvatarBorderStyle.doubleBorder,
          color: color,
          innerColor: innerColor,
          width: width,
          innerWidth: innerWidth,
          gap: gap,
          gapColor: gapColor,
        );

  /// Dashed border stroke following the exact vector contour.
  const Material4AvatarBorder.dashed({
    Color color = Colors.white,
    double width = 2.0,
    double dashLength = 6.0,
    double dashGap = 4.0,
    double gap = 0.0,
    Color? gapColor,
  }) : this(
          style: AvatarBorderStyle.dashed,
          color: color,
          width: width,
          dashLength: dashLength,
          dashGap: dashGap,
          gap: gap,
          gapColor: gapColor,
        );

  /// Radiant glowing halo border with soft ambient blur.
  const Material4AvatarBorder.glow({
    Color color = const Color(0xFF5E43EE),
    Color? glowColor,
    double width = 2.0,
    double glowRadius = 8.0,
    double glowSpread = 2.0,
    double gap = 0.0,
  }) : this(
          style: AvatarBorderStyle.glow,
          color: color,
          glowColor: glowColor,
          width: width,
          glowRadius: glowRadius,
          glowSpread: glowSpread,
          gap: gap,
        );

  /// Sculpted dual-tone beveled border with directional specular highlights.
  const Material4AvatarBorder.sculpted({
    Color highlightColor = Colors.white,
    Color shadowColor = const Color(0xFF1E1E24),
    double width = 2.5,
  }) : this(
          style: AvatarBorderStyle.sculpted,
          color: highlightColor,
          innerColor: shadowColor,
          width: width,
        );

  /// Total extra spacing required around the avatar to accommodate this border and its gap/glow.
  double get totalMargin {
    if (style == AvatarBorderStyle.none || width <= 0) return 0.0;
    double margin = width + gap;
    if (style == AvatarBorderStyle.glow) {
      margin += glowRadius + glowSpread;
    } else if (style == AvatarBorderStyle.doubleBorder) {
      margin += innerWidth + gap;
    }
    return margin;
  }

  /// Paints this border along [path] on [canvas] scaled to [size].
  void paintBorder(
    Canvas canvas,
    Size size,
    Path path, {
    double rotationAngle = 0.0,
  }) {
    if (style == AvatarBorderStyle.none || width <= 0) return;

    final bounds = path.getBounds();

    // 1. Paint Gap Fill if specified
    if (gap > 0 && gapColor != null) {
      final gapPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = gap * 2
        ..color = gapColor!;
      canvas.drawPath(path, gapPaint);
    }

    // 2. Paint Glow if enabled
    if (style == AvatarBorderStyle.glow && glowRadius > 0) {
      final effectiveGlowColor = glowColor ?? color.withValues(alpha: 0.65);
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width + (glowSpread * 2)
        ..color = effectiveGlowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);
      canvas.drawPath(path, glowPaint);
    }

    // 3. Paint Primary Stroke based on style
    switch (style) {
      case AvatarBorderStyle.none:
        break;

      case AvatarBorderStyle.solid:
      case AvatarBorderStyle.glow:
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = color
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(path, paint);
        break;

      case AvatarBorderStyle.gradient:
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        if (gradient != null) {
          if (rotationAngle != 0.0) {
            final center = Offset(
              bounds.left + bounds.width / 2.0,
              bounds.top + bounds.height / 2.0,
            );
            paint.shader = gradient!.createShader(
              bounds,
              textDirection: TextDirection.ltr,
            );
            canvas.save();
            canvas.translate(center.dx, center.dy);
            canvas.rotate(rotationAngle);
            canvas.translate(-center.dx, -center.dy);
            canvas.drawPath(path, paint);
            canvas.restore();
            return;
          } else {
            paint.shader = gradient!.createShader(bounds);
          }
        } else {
          paint.color = color;
        }
        canvas.drawPath(path, paint);
        break;

      case AvatarBorderStyle.dashed:
      case AvatarBorderStyle.dotted:
        final dashedPath = _createDashedPath(
          path,
          dashLength: style == AvatarBorderStyle.dotted ? width : dashLength,
          dashGap: dashGap,
        );
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = style == AvatarBorderStyle.dotted
              ? StrokeCap.round
              : StrokeCap.butt
          ..strokeJoin = StrokeJoin.round;
        if (gradient != null) {
          paint.shader = gradient!.createShader(bounds);
        } else {
          paint.color = color;
        }
        canvas.drawPath(dashedPath, paint);
        break;

      case AvatarBorderStyle.doubleBorder:
        // Outer stroke
        final outerPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = color;
        canvas.drawPath(path, outerPaint);

        // Inner stroke (inset along path)
        if (innerWidth > 0) {
          final inPaint = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = innerWidth
            ..color = innerColor ?? color.withValues(alpha: 0.6);
          canvas.drawPath(path, inPaint);
        }
        break;

      case AvatarBorderStyle.sculpted:
        // Dual-pass highlight and shadow
        final lightPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              (innerColor ?? Colors.black87).withValues(alpha: 0.7),
            ],
          ).createShader(bounds);
        canvas.drawPath(path, lightPaint);
        break;
    }
  }

  /// Extracts precise dash segments along arbitrary vector [Path].
  Path _createDashedPath(
    Path source, {
    required double dashLength,
    required double dashGap,
  }) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dashLength : dashGap;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  /// Linearly interpolates between two [Material4AvatarBorder] instances.
  static Material4AvatarBorder lerp(
    Material4AvatarBorder? a,
    Material4AvatarBorder? b,
    double t,
  ) {
    if (a == null && b == null) return const Material4AvatarBorder.none();
    if (a == null) return b!;
    if (b == null) return a;
    if (t <= 0.0) return a;
    if (t >= 1.0) return b;

    return Material4AvatarBorder(
      style: t < 0.5 ? a.style : b.style,
      color: Color.lerp(a.color, b.color, t) ?? a.color,
      width: lerpDouble(a.width, b.width, t) ?? a.width,
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      dashLength: lerpDouble(a.dashLength, b.dashLength, t) ?? a.dashLength,
      dashGap: lerpDouble(a.dashGap, b.dashGap, t) ?? a.dashGap,
      glowColor: Color.lerp(a.glowColor, b.glowColor, t),
      glowRadius: lerpDouble(a.glowRadius, b.glowRadius, t) ?? a.glowRadius,
      gap: lerpDouble(a.gap, b.gap, t) ?? a.gap,
      gapColor: Color.lerp(a.gapColor, b.gapColor, t),
      offset: t < 0.5 ? a.offset : b.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material4AvatarBorder &&
        other.style == style &&
        other.color == color &&
        other.width == width &&
        other.gradient == gradient &&
        other.dashLength == dashLength &&
        other.dashGap == dashGap &&
        other.glowColor == glowColor &&
        other.glowRadius == glowRadius &&
        other.gap == gap &&
        other.gapColor == gapColor &&
        other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(
        style,
        color,
        width,
        gradient,
        dashLength,
        dashGap,
        glowColor,
        glowRadius,
        gap,
        gapColor,
        offset,
      );
}
