import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'progress_shape.dart';

/// Configuration for the active progressing fill of a [Material4ProgressBar].
@immutable
class Material4ProgressFill {
  /// Primary solid fill color.
  final Color? color;

  /// Primary gradient fill.
  final Gradient? gradient;

  /// Secondary color (used for dual-layer buffers, striped background, or shadow).
  final Color? secondaryColor;

  /// Secondary gradient for buffer or background layer.
  final Gradient? secondaryGradient;

  /// Color stops mapping progress ratios (0.0 to 1.0) to dynamic checkpoint colors.
  final Map<double, Color>? multiColors;

  /// Outline border width around the active filled shape.
  final double borderWidth;

  /// Outline border color around the active filled shape.
  final Color? borderColor;

  /// Corner radius override for the active fill.
  final BorderRadius? borderRadius;

  /// Whether diagonal barber-pole stripes are painted over the fill.
  final bool striped;

  /// Color of diagonal stripes if [striped] is true.
  final Color stripeColor;

  /// Thickness of diagonal stripes in pixels.
  final double stripeWidth;

  /// Gap between diagonal stripes in pixels.
  final double stripeGap;

  /// Angle of diagonal stripes in radians (default 45° = pi / 4).
  final double stripeAngle;

  /// Peak amplitude of fluid wave crest in pixels.
  final double waveAmplitude;

  /// Frequency of fluid wave cycles per width.
  final double waveFrequency;

  /// Viscosity smoothing factor for liquid meniscus (0.0 to 1.0).
  final double liquidViscosity;

  /// Whether rising effervescent micro-bubbles render inside liquid fill.
  final bool liquidBubbles;

  /// Number of active rising liquid micro-bubbles.
  final int bubbleCount;

  /// Total count of discrete segments for segmented progress styles.
  final int segments;

  /// Spacing gap between adjacent segments in pixels.
  final double segmentGap;

  /// Progression direction (default [AxisDirection.right]).
  final AxisDirection direction;

  /// Custom shape override for the fill if different from track.
  final Material4ProgressShape? shape;

  /// Creates a [Material4ProgressFill] configuration.
  const Material4ProgressFill({
    this.color,
    this.gradient,
    this.secondaryColor,
    this.secondaryGradient,
    this.multiColors,
    this.borderWidth = 0.0,
    this.borderColor,
    this.borderRadius,
    this.striped = false,
    this.stripeColor = const Color(0x33FFFFFF),
    this.stripeWidth = 8.0,
    this.stripeGap = 8.0,
    this.stripeAngle = math.pi / 4.0,
    this.waveAmplitude = 4.0,
    this.waveFrequency = 2.0,
    this.liquidViscosity = 0.5,
    this.liquidBubbles = false,
    this.bubbleCount = 6,
    this.segments = 10,
    this.segmentGap = 4.0,
    this.direction = AxisDirection.right,
    this.shape,
  });

  /// Standard solid fill preset with brand blue.
  static const Material4ProgressFill solid = Material4ProgressFill(
    color: Color(0xFF2563EB),
  );

  /// Modern vibrant cyan-to-purple gradient preset.
  static const Material4ProgressFill modernGradient = Material4ProgressFill(
    gradient: LinearGradient(
      colors: [Color(0xFF00E5FF), Color(0xFF651FFF)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
  );

  /// Diagonal barber-pole striped fill preset.
  static const Material4ProgressFill stripedPreset = Material4ProgressFill(
    color: Color(0xFF2563EB),
    striped: true,
    stripeColor: Color(0x4DFFFFFF),
    stripeWidth: 8.0,
    stripeGap: 8.0,
  );

  /// Dynamic undulating wave fill preset.
  static const Material4ProgressFill wavePreset = Material4ProgressFill(
    color: Color(0xFF00B0FF),
    waveAmplitude: 5.0,
    waveFrequency: 2.5,
  );

  /// Effervescent liquid reservoir fill preset with bubbles.
  static const Material4ProgressFill liquidPreset = Material4ProgressFill(
    color: Color(0xFF00E5FF),
    waveAmplitude: 4.0,
    liquidBubbles: true,
    bubbleCount: 8,
  );

  /// Discretized segmented fill preset.
  static const Material4ProgressFill segmentedPreset = Material4ProgressFill(
    color: Color(0xFF10B981),
    segments: 10,
    segmentGap: 4.0,
  );

  /// Resolves the effective color for [value] based on [multiColors] thresholds.
  Color resolveColor(double value, Color fallback) {
    if (multiColors == null || multiColors!.isEmpty) {
      return color ?? fallback;
    }
    final sortedKeys = multiColors!.keys.toList()..sort();
    Color matched = color ?? fallback;
    for (final threshold in sortedKeys) {
      if (value >= threshold) {
        matched = multiColors![threshold]!;
      }
    }
    return matched;
  }

  /// Creates a copy of this fill configuration with modified parameters.
  Material4ProgressFill copyWith({
    Color? color,
    Gradient? gradient,
    Color? secondaryColor,
    Gradient? secondaryGradient,
    Map<double, Color>? multiColors,
    double? borderWidth,
    Color? borderColor,
    BorderRadius? borderRadius,
    bool? striped,
    Color? stripeColor,
    double? stripeWidth,
    double? stripeGap,
    double? stripeAngle,
    double? waveAmplitude,
    double? waveFrequency,
    double? liquidViscosity,
    bool? liquidBubbles,
    int? bubbleCount,
    int? segments,
    double? segmentGap,
    AxisDirection? direction,
    Material4ProgressShape? shape,
  }) {
    return Material4ProgressFill(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      multiColors: multiColors ?? this.multiColors,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      striped: striped ?? this.striped,
      stripeColor: stripeColor ?? this.stripeColor,
      stripeWidth: stripeWidth ?? this.stripeWidth,
      stripeGap: stripeGap ?? this.stripeGap,
      stripeAngle: stripeAngle ?? this.stripeAngle,
      waveAmplitude: waveAmplitude ?? this.waveAmplitude,
      waveFrequency: waveFrequency ?? this.waveFrequency,
      liquidViscosity: liquidViscosity ?? this.liquidViscosity,
      liquidBubbles: liquidBubbles ?? this.liquidBubbles,
      bubbleCount: bubbleCount ?? this.bubbleCount,
      segments: segments ?? this.segments,
      segmentGap: segmentGap ?? this.segmentGap,
      direction: direction ?? this.direction,
      shape: shape ?? this.shape,
    );
  }
}

