import 'dart:ui';
import 'package:flutter/material.dart';

/// Style options for [Material4CardBorder].
enum CardBorderStyle {
  /// Subtle crisp outline matching the reference design (typically 1.0 - 1.5 dp).
  thinOutline,

  /// Prominent bold outline (2.5 - 4.0 dp) for high contrast or brutalist cards.
  thickOutline,

  /// Concentric parallel dual stroke pair following the custom path.
  doubleOutline,

  /// Stroke drawn strictly inset along the inner rim of the shape boundary.
  innerBorder,

  /// Stroke drawn slightly expanded outside the boundary.
  outerBorder,

  /// Hand-crafted artisanal sketch outline with micro-variations.
  handDrawn,

  /// Dual-tone sculpted 3D bevel stroke (highlight on top-left, shade on bottom-right).
  softSculpted,

  /// Sweeping multicolor linear or angular gradient stroke.
  gradient,
}

/// Border and outline configuration for [Material4Card] that strictly follows
/// the custom organic vector path geometry.
@immutable
class Material4CardBorder {
  /// Primary color of the border stroke.
  final Color color;

  /// Stroke width in logical pixels.
  final double width;

  /// Border presentation style.
  final CardBorderStyle style;

  /// Optional gradient for [CardBorderStyle.gradient].
  final Gradient? gradient;

  /// Secondary color for [CardBorderStyle.doubleOutline] or [CardBorderStyle.softSculpted].
  final Color? secondaryColor;

  /// Spacing gap for [CardBorderStyle.doubleOutline].
  final double gap;

  const Material4CardBorder({
    this.color = const Color(0xFF1E1E24),
    this.width = 1.2,
    this.style = CardBorderStyle.thinOutline,
    this.gradient,
    this.secondaryColor,
    this.gap = 2.5,
  }) : assert(width >= 0, 'Border width must be non-negative');

  /// Crisp subtle thin outline matching the reference Notice Board design.
  const Material4CardBorder.thin({
    Color color = const Color(0xFF1E1E24),
    double width = 1.2,
  }) : this(color: color, width: width, style: CardBorderStyle.thinOutline);

  /// Thick prominent border outline.
  const Material4CardBorder.thick({
    Color color = const Color(0xFF1E1E24),
    double width = 3.0,
  }) : this(color: color, width: width, style: CardBorderStyle.thickOutline);

  /// Concentric double-stroke outline.
  const Material4CardBorder.doubleLine({
    Color color = const Color(0xFF1E1E24),
    Color? secondaryColor,
    double width = 1.2,
    double gap = 2.5,
  }) : this(
          color: color,
          secondaryColor: secondaryColor ?? color,
          width: width,
          gap: gap,
          style: CardBorderStyle.doubleOutline,
        );

  /// Gradient outline following the custom path.
  const Material4CardBorder.gradient({
    required Gradient gradient,
    double width = 1.5,
  }) : this(
          gradient: gradient,
          width: width,
          style: CardBorderStyle.gradient,
        );

  /// Hand-drawn sketch style outline.
  const Material4CardBorder.handDrawn({
    Color color = const Color(0xFF1E1E24),
    double width = 1.4,
  }) : this(color: color, width: width, style: CardBorderStyle.handDrawn);

  /// Soft sculpted 3D bevel stroke.
  const Material4CardBorder.sculpted({
    Color highlight = const Color(0x66FFFFFF),
    Color shadow = const Color(0x33000000),
    double width = 1.5,
  }) : this(
          color: highlight,
          secondaryColor: shadow,
          width: width,
          style: CardBorderStyle.softSculpted,
        );

  /// Paints this border directly onto [canvas] along the exact [path] of the card.
  void paintBorder(Canvas canvas, Size size, Path path) {
    if (width <= 0) return;

    final Rect bounds = path.getBounds();

    switch (style) {
      case CardBorderStyle.gradient:
        if (gradient != null) {
          final paint = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = width
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..shader = gradient!.createShader(bounds);
          canvas.drawPath(path, paint);
        } else {
          _paintBasicStroke(canvas, path, color, width);
        }
        break;

      case CardBorderStyle.doubleOutline:
        // Outer stroke
        _paintBasicStroke(canvas, path, color, width);

        // Inner concentric stroke (drawn clipped slightly inside)
        canvas.save();
        canvas.clipPath(path);
        final innerPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = secondaryColor ?? color;
        canvas.drawPath(path, innerPaint);
        canvas.restore();
        break;

      case CardBorderStyle.innerBorder:
        canvas.save();
        canvas.clipPath(path);
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 2.0
          ..color = color;
        canvas.drawPath(path, paint);
        canvas.restore();
        break;

      case CardBorderStyle.outerBorder:
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 1.5
          ..color = color;
        canvas.drawPath(path, paint);
        break;

      case CardBorderStyle.handDrawn:
        // Dual organic sketch lines with subtle sub-pixel offset
        final sketchPaint1 = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 0.8
          ..color = color.withValues(alpha: 0.85);
        canvas.drawPath(path, sketchPaint1);

        canvas.save();
        canvas.translate(0.5, 0.4);
        final sketchPaint2 = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 0.5
          ..color = color.withValues(alpha: 0.45);
        canvas.drawPath(path, sketchPaint2);
        canvas.restore();
        break;

      case CardBorderStyle.softSculpted:
        // Highlighting upper rim and shading lower rim
        final highlightPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = color;
        canvas.drawPath(path, highlightPaint);

        canvas.save();
        canvas.translate(0.5, 0.8);
        final shadowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = secondaryColor ?? const Color(0x33000000);
        canvas.drawPath(path, shadowPaint);
        canvas.restore();
        break;

      case CardBorderStyle.thickOutline:
      case CardBorderStyle.thinOutline:
        _paintBasicStroke(canvas, path, color, width);
        break;
    }
  }

  void _paintBasicStroke(
      Canvas canvas, Path path, Color strokeColor, double strokeWidth) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = strokeColor;
    canvas.drawPath(path, paint);
  }

  Material4CardBorder copyWith({
    Color? color,
    double? width,
    CardBorderStyle? style,
    Gradient? gradient,
    Color? secondaryColor,
    double? gap,
  }) {
    return Material4CardBorder(
      color: color ?? this.color,
      width: width ?? this.width,
      style: style ?? this.style,
      gradient: gradient ?? this.gradient,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      gap: gap ?? this.gap,
    );
  }

  static Material4CardBorder lerp(
      Material4CardBorder a, Material4CardBorder b, double t) {
    return Material4CardBorder(
      color: Color.lerp(a.color, b.color, t) ?? b.color,
      width: lerpDouble(a.width, b.width, t) ?? b.width,
      style: t < 0.5 ? a.style : b.style,
      gradient: t < 0.5 ? a.gradient : b.gradient,
      secondaryColor:
          Color.lerp(a.secondaryColor, b.secondaryColor, t) ?? b.secondaryColor,
      gap: lerpDouble(a.gap, b.gap, t) ?? b.gap,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4CardBorder &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          width == other.width &&
          style == other.style &&
          gradient == other.gradient &&
          secondaryColor == other.secondaryColor &&
          gap == other.gap;

  @override
  int get hashCode =>
      Object.hash(color, width, style, gradient, secondaryColor, gap);
}
