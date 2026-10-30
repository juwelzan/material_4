import 'package:flutter/material.dart';

import 'progress_shape.dart';

/// Configuration for the background track container of a [Material4ProgressBar].
@immutable
class Material4ProgressTrack {
  /// Background color fill of the track.
  final Color? color;

  /// Optional gradient fill for the track surface.
  final Gradient? gradient;

  /// Explicit height or radial thickness of the track.
  final double? thickness;

  /// Outline border stroke width surrounding the track.
  final double borderWidth;

  /// Outline border stroke color surrounding the track.
  final Color? borderColor;

  /// Corner radius override for linear or rounded tracks.
  final BorderRadius? borderRadius;

  /// Inward padding between the outer track boundaries and the progress fill.
  final EdgeInsets padding;

  /// Elevated drop shadows cast behind the progress track.
  final List<BoxShadow>? shadows;

  /// Track opacity factor (0.0 to 1.0).
  final double opacity;

  /// Whether frosted glass backdrop filtering is active on the track surface.
  final bool glass;

  /// Glass blur intensity if [glass] is true.
  final double glassBlur;

  /// Custom shape override for track contour if different from fill contour.
  final Material4ProgressShape? shape;

  /// Creates a [Material4ProgressTrack] configuration.
  const Material4ProgressTrack({
    this.color,
    this.gradient,
    this.thickness,
    this.borderWidth = 0.0,
    this.borderColor,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.shadows,
    this.opacity = 1.0,
    this.glass = false,
    this.glassBlur = 8.0,
    this.shape,
  });

  /// Standard minimal track preset.
  static const Material4ProgressTrack minimal = Material4ProgressTrack(
    color: Color(0x14000000),
  );

  /// Modern capsule track preset with subtle border.
  static const Material4ProgressTrack modern = Material4ProgressTrack(
    color: Color(0x1F000000),
    borderWidth: 1.0,
    borderColor: Color(0x1A000000),
  );

  /// Elevated floating track with soft ambient depth shadow.
  static const Material4ProgressTrack floating = Material4ProgressTrack(
    color: Colors.white,
    shadows: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 10.0,
        offset: Offset(0, 4),
      ),
    ],
  );

  /// Frosted glassmorphism track preset.
  static const Material4ProgressTrack glassPreset = Material4ProgressTrack(
    color: Color(0x26FFFFFF),
    borderWidth: 1.0,
    borderColor: Color(0x4DFFFFFF),
    glass: true,
    glassBlur: 12.0,
  );

  /// Creates a copy of this track configuration with modified parameters.
  Material4ProgressTrack copyWith({
    Color? color,
    Gradient? gradient,
    double? thickness,
    double? borderWidth,
    Color? borderColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    List<BoxShadow>? shadows,
    double? opacity,
    bool? glass,
    double? glassBlur,
    Material4ProgressShape? shape,
  }) {
    return Material4ProgressTrack(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      thickness: thickness ?? this.thickness,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      shadows: shadows ?? this.shadows,
      opacity: opacity ?? this.opacity,
      glass: glass ?? this.glass,
      glassBlur: glassBlur ?? this.glassBlur,
      shape: shape ?? this.shape,
    );
  }
}

