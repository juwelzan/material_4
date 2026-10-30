import 'package:flutter/material.dart';

import '../creative/borders/creative_border_config.dart';
import '../creative/paper/paper_background_config.dart';
import '../material_4_config.dart';

/// Style preset representing surface finish and geometry styling of the app bar.
enum Material4AppBarSurfaceType {
  /// Standard solid or theme surface.
  standard,

  /// Organic contour with smooth curved/concave bottom edge.
  organic,

  /// Sculpted neo-3D surface with tactile borders and elevation.
  sculpted,

  /// Frosted glass surface with backdrop blur filter.
  glass,

  /// Multi-stop linear or radial gradient surface.
  gradient,

  /// Detached floating card surface with margins and rounded corners.
  card,

  /// Completely transparent background blending into page contents.
  transparent,
}

/// Visual style configuration for [Material4AppBar] and [Material4SliverAppBar].
///
/// Controls background fills, gradients, elevations, shadows, frosted glass blur,
/// and direct integration with Material 4's vector shape and border engines.
@immutable
class Material4AppBarStyle {
  /// Background color for the expanded header state.
  final Color? backgroundColor;

  /// Background color for the collapsed / floating header state.
  final Color? collapsedBackgroundColor;

  /// Foreground content/text/icon color for the expanded state.
  final Color? foregroundColor;

  /// Foreground content/text/icon color for the collapsed state.
  final Color? collapsedForegroundColor;

  /// Background gradient for the expanded header.
  final Gradient? gradient;

  /// Background gradient for the collapsed / floating header.
  final Gradient? collapsedGradient;

  /// Shadow elevation for the expanded header.
  final double elevation;

  /// Shadow elevation for the collapsed / floating header.
  final double collapsedElevation;

  /// Explicit shadows for the expanded header.
  final List<BoxShadow>? shadows;

  /// Explicit shadows for the collapsed / floating header.
  final List<BoxShadow>? collapsedShadows;

  /// Backdrop blur sigma value for frosted glass effects (0.0 means disabled).
  final double backdropBlur;

  /// Material 4 shape engine configuration for the expanded header background.
  final Material4Config? shapeConfig;

  /// Material 4 shape engine configuration for the collapsed header background.
  final Material4Config? collapsedShapeConfig;

  /// Content padding inside the app bar body.
  final EdgeInsetsGeometry padding;

  /// Optional creative border styling (e.g. dashed, neon, etched, scalloped).
  final CreativeBorderConfig? creativeBorder;

  /// Optional paper background pattern (e.g. grid, blueprint, parchment).
  final PaperBackgroundConfig? paperBackground;

  /// High-level surface type classification.
  final Material4AppBarSurfaceType surfaceType;

  /// Creates a [Material4AppBarStyle] instance.
  const Material4AppBarStyle({
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.foregroundColor,
    this.collapsedForegroundColor,
    this.gradient,
    this.collapsedGradient,
    this.elevation = 0.0,
    this.collapsedElevation = 1.0,
    this.shadows,
    this.collapsedShadows,
    this.backdropBlur = 0.0,
    this.shapeConfig,
    this.collapsedShapeConfig,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.creativeBorder,
    this.paperBackground,
    this.surfaceType = Material4AppBarSurfaceType.standard,
  });

  /// Factory style for a frosted glass blur surface.
  factory Material4AppBarStyle.glass({
    Color? backgroundColor,
    Color? foregroundColor,
    double backdropBlur = 16.0,
    double elevation = 0.0,
  }) {
    return Material4AppBarStyle(
      backgroundColor: backgroundColor ?? Colors.white.withValues(alpha: 0.72),
      collapsedBackgroundColor:
          backgroundColor ?? Colors.white.withValues(alpha: 0.85),
      foregroundColor: foregroundColor ?? const Color(0xFF1E1E24),
      backdropBlur: backdropBlur,
      elevation: elevation,
      surfaceType: Material4AppBarSurfaceType.glass,
      collapsedElevation: 1.0,
    );
  }

  /// Factory style for an organic sculpted surface with custom wave/contour.
  factory Material4AppBarStyle.organic({
    Color? backgroundColor,
    Color? foregroundColor,
    Gradient? gradient,
    Material4Config? shapeConfig,
    double elevation = 2.0,
  }) {
    return Material4AppBarStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      gradient: gradient,
      shapeConfig: shapeConfig,
      elevation: elevation,
      surfaceType: Material4AppBarSurfaceType.organic,
    );
  }

  /// Factory style for a rich gradient header.
  factory Material4AppBarStyle.gradient({
    required Gradient gradient,
    Gradient? collapsedGradient,
    Color foregroundColor = Colors.white,
    double elevation = 0.0,
  }) {
    return Material4AppBarStyle(
      gradient: gradient,
      collapsedGradient: collapsedGradient ?? gradient,
      foregroundColor: foregroundColor,
      collapsedForegroundColor: foregroundColor,
      elevation: elevation,
      surfaceType: Material4AppBarSurfaceType.gradient,
    );
  }

  /// Factory style for a completely transparent header.
  static const Material4AppBarStyle transparent = Material4AppBarStyle(
    backgroundColor: Colors.transparent,
    collapsedBackgroundColor: Colors.transparent,
    elevation: 0.0,
    collapsedElevation: 0.0,
    surfaceType: Material4AppBarSurfaceType.transparent,
  );
}
