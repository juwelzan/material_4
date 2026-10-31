import 'dart:ui';
import 'package:flutter/material.dart';

import '../material_4_config.dart';

/// Configuration for the advanced, shape-following border system in [Material4Container].
///
/// Automatically tracks the exact contour of any shape (including during real-time
/// shape morphing) with support for moving dashes, rotating gradients, neon blooms,
/// liquid ripples, and stroke alignments.
@immutable
class Material4Border {
  /// The visual border style.
  final BorderStyleType style;

  /// Border stroke width in logical pixels.
  final double width;

  /// Primary border stroke color.
  final Color? color;

  /// Optional multi-color stops for gradient, rainbow, or multi-tone borders.
  final List<Color>? colors;

  /// Optional gradient for gradient-based borders.
  final Gradient? gradient;

  /// Alignment of the stroke relative to the shape contour (center, inside, outside).
  final ShapeStrokeAlign strokeAlign;

  /// Length of visible dash segments for dashed and marching-ant borders.
  final double dashLength;

  /// Gap between dash segments.
  final double dashGap;

  /// Glow intensity multiplier for neon, glow, and energy borders.
  final double glowIntensity;

  /// Blur radius for soft glow halos.
  final double blurRadius;

  /// Animation speed multiplier (1.0 = normal, 2.0 = fast, 0.5 = slow).
  final double animationSpeed;

  /// Whether border animation is actively enabled.
  final bool animated;

  /// Explicit animation progress (0.0 to 1.0) when driven externally.
  final double progress;

  /// Opacity multiplier for the border stroke (0.0 to 1.0).
  final double opacity;

  /// Curve applied to animated border transitions.
  final Curve animationCurve;

  const Material4Border({
    this.style = BorderStyleType.solid,
    this.width = 1.0,
    this.color,
    this.colors,
    this.gradient,
    this.strokeAlign = ShapeStrokeAlign.center,
    this.dashLength = 8.0,
    this.dashGap = 4.0,
    this.glowIntensity = 1.0,
    this.blurRadius = 0.0,
    this.animationSpeed = 1.0,
    this.animated = false,
    this.progress = 0.0,
    this.opacity = 1.0,
    this.animationCurve = Curves.linear,
  });

  /// Preset representing no border stroke.
  static const Material4Border none = Material4Border(
    style: BorderStyleType.solid,
    width: 0.0,
    color: Color(0x00000000),
    opacity: 0.0,
  );

  /// Preset for a crisp solid border.
  const Material4Border.solid({
    double width = 1.0,
    Color color = const Color(0x1F1A1A1A),
    ShapeStrokeAlign strokeAlign = ShapeStrokeAlign.center,
    double opacity = 1.0,
  }) : this(
          style: BorderStyleType.solid,
          width: width,
          color: color,
          strokeAlign: strokeAlign,
          opacity: opacity,
        );

  /// Preset for an animated gradient flowing along the contour.
  const Material4Border.animatedGradient({
    double width = 2.0,
    List<Color> colors = const [
      Color(0xFF6366F1),
      Color(0xFFEC4899),
      Color(0xFF00E5FF),
      Color(0xFF6366F1),
    ],
    double animationSpeed = 1.0,
    double progress = 0.0,
    ShapeStrokeAlign strokeAlign = ShapeStrokeAlign.center,
  }) : this(
          style: BorderStyleType.animatedGradient,
          width: width,
          colors: colors,
          animated: true,
          animationSpeed: animationSpeed,
          progress: progress,
          strokeAlign: strokeAlign,
        );

  /// Preset for a marching-ant moving dash border.
  const Material4Border.movingDash({
    double width = 1.5,
    Color color = const Color(0xFF6366F1),
    double dashLength = 8.0,
    double dashGap = 5.0,
    double animationSpeed = 1.0,
    double progress = 0.0,
    ShapeStrokeAlign strokeAlign = ShapeStrokeAlign.center,
  }) : this(
          style: BorderStyleType.movingDash,
          width: width,
          color: color,
          dashLength: dashLength,
          dashGap: dashGap,
          animated: true,
          animationSpeed: animationSpeed,
          progress: progress,
          strokeAlign: strokeAlign,
        );

  /// Preset for a luminous pulsing neon border with ambient bloom.
  const Material4Border.neon({
    double width = 2.0,
    Color color = const Color(0xFF00E5FF),
    double glowIntensity = 1.5,
    double blurRadius = 8.0,
    double animationSpeed = 1.0,
    bool animated = true,
    double progress = 0.0,
  }) : this(
          style: BorderStyleType.neonPulse,
          width: width,
          color: color,
          glowIntensity: glowIntensity,
          blurRadius: blurRadius,
          animationSpeed: animationSpeed,
          animated: animated,
          progress: progress,
        );

  /// Preset for a rainbow chromatic dispersion border.
  const Material4Border.rainbow({
    double width = 2.5,
    double animationSpeed = 1.0,
    double progress = 0.0,
    bool animated = true,
  }) : this(
          style: BorderStyleType.rainbow,
          width: width,
          animationSpeed: animationSpeed,
          progress: progress,
          animated: animated,
        );

  /// Preset for a specular reflective shimmer streak border.
  const Material4Border.shimmer({
    double width = 2.0,
    Color color = const Color(0xFFFFFFFF),
    double animationSpeed = 1.2,
    double progress = 0.0,
    bool animated = true,
  }) : this(
          style: BorderStyleType.animatedGradient,
          width: width,
          color: color,
          colors: const [
            Color(0x33FFFFFF),
            Color(0xFFFFFFFF),
            Color(0x33FFFFFF),
          ],
          animationSpeed: animationSpeed,
          progress: progress,
          animated: animated,
        );

  Material4Border copyWith({
    BorderStyleType? style,
    double? width,
    Color? color,
    List<Color>? colors,
    Gradient? gradient,
    ShapeStrokeAlign? strokeAlign,
    double? dashLength,
    double? dashGap,
    double? glowIntensity,
    double? blurRadius,
    double? animationSpeed,
    bool? animated,
    double? progress,
    double? opacity,
    Curve? animationCurve,
  }) {
    return Material4Border(
      style: style ?? this.style,
      width: width ?? this.width,
      color: color ?? this.color,
      colors: colors ?? this.colors,
      gradient: gradient ?? this.gradient,
      strokeAlign: strokeAlign ?? this.strokeAlign,
      dashLength: dashLength ?? this.dashLength,
      dashGap: dashGap ?? this.dashGap,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      blurRadius: blurRadius ?? this.blurRadius,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      animated: animated ?? this.animated,
      progress: progress ?? this.progress,
      opacity: opacity ?? this.opacity,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  /// Linearly interpolates between two [Material4Border] instances.
  static Material4Border lerp(Material4Border a, Material4Border b, double t) {
    return Material4Border(
      style: t < 0.5 ? a.style : b.style,
      width: lerpDouble(a.width, b.width, t) ?? b.width,
      color: Color.lerp(a.color, b.color, t),
      strokeAlign: t < 0.5 ? a.strokeAlign : b.strokeAlign,
      dashLength: lerpDouble(a.dashLength, b.dashLength, t) ?? b.dashLength,
      dashGap: lerpDouble(a.dashGap, b.dashGap, t) ?? b.dashGap,
      glowIntensity: lerpDouble(a.glowIntensity, b.glowIntensity, t) ?? b.glowIntensity,
      blurRadius: lerpDouble(a.blurRadius, b.blurRadius, t) ?? b.blurRadius,
      animationSpeed: lerpDouble(a.animationSpeed, b.animationSpeed, t) ?? b.animationSpeed,
      animated: t < 0.5 ? a.animated : b.animated,
      progress: lerpDouble(a.progress, b.progress, t) ?? b.progress,
      opacity: lerpDouble(a.opacity, b.opacity, t) ?? b.opacity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4Border &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          width == other.width &&
          color == other.color &&
          strokeAlign == other.strokeAlign &&
          dashLength == other.dashLength &&
          dashGap == other.dashGap &&
          glowIntensity == other.glowIntensity &&
          blurRadius == other.blurRadius &&
          animationSpeed == other.animationSpeed &&
          animated == other.animated &&
          progress == other.progress &&
          opacity == other.opacity;

  @override
  int get hashCode => Object.hash(
        style,
        width,
        color,
        strokeAlign,
        dashLength,
        dashGap,
        glowIntensity,
        blurRadius,
        animationSpeed,
        animated,
        progress,
        opacity,
      );
}
