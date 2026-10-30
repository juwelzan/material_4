import 'package:flutter/material.dart';

import '../../dynamic_shape_config.dart';

/// Available icon position anchors on [SculptedIconCard].
enum SculptedIconPosition {
  /// Top-Left corner.
  topLeft,

  /// Centered horizontally along top edge.
  topCenter,

  /// Top-Right corner.
  topRight,

  /// Vertically centered on the left edge.
  centerLeft,

  /// Vertically centered on the right edge.
  centerRight,

  /// Bottom-Left corner.
  bottomLeft,

  /// Centered horizontally along bottom edge.
  bottomCenter,

  /// Bottom-Right corner.
  bottomRight,

  /// Floating elevated above top edge (partially overlapping container boundary).
  floatingTop,

  /// Floating elevated outside left edge.
  floatingLeft,

  /// Floating elevated outside right edge.
  floatingRight,

  /// Floating elevated diagonally off the primary corner.
  floatingCorner,

  /// Custom sub-pixel fractional alignment.
  custom,
}

/// Tactile surface rendering styles for the sculpted icon plate.
enum SculptedSurfaceStyle {
  /// Icon plate surface physically raised from the background with directional highlight and shadow.
  embossed,

  /// Icon area pressed inward into the surface with top-left inner shadow and bottom-right rim highlight.
  debossed,

  /// Neumorphic soft dual-directional lighting (light highlight on top-left, soft shadow on bottom-right).
  neumorphic,

  /// Subtle gentle elevation.
  softRaised,

  /// Bold hard-edge elevation with distinct cast shadow.
  hardRaised,

  /// Icon plate appears to hover freely above the card with ambient blur shadow.
  floating,

  /// Icon sits inside a sunken carved well.
  recessed,

  /// Icon surface resembles crisp multi-layered cut craft paper with sharp cast shadows.
  paperCutout,

  /// Folded paper corner containing the icon plate.
  foldedPaper,

  /// Tactile soft matte clay-like finish with volumetric inner rim light.
  clay,

  /// Smooth glossy ceramic finish with high-specular reflective highlight.
  ceramic,

  /// Frosted glass plate with semi-translucent backdrop filter and bright specular rim.
  glass,

  /// Metallic plate with brushed sheen or metallic reflection.
  metalPlate,

  /// Multi-tier stacked material composite plate.
  layeredMaterial,

  /// Soft organic fluid raised surface.
  organicSurface,
}

/// Geometric boundary shape for the raised icon plate.
enum SculptedPlateShape {
  /// Perfectly circular plate.
  circle,

  /// Rounded square with smooth corners.
  roundedSquare,

  /// Apple-style mathematical squircle.
  squircle,

  /// Fluid organic blob shape.
  organic,

  /// Inherits and scales the parent card's dynamic shape.
  matchCard,

  /// Custom shape path.
  custom,
}

/// Configuration model for the raised icon plate on [SculptedIconCard].
class SculptedPlateConfig {
  /// Surface finish / sculpting style.
  final SculptedSurfaceStyle style;

  /// Geometric shape of the icon plate.
  final SculptedPlateShape shape;

  /// Diameter or width/height of the icon plate.
  final double size;

  /// Custom corner radius if [shape] is roundedSquare.
  final double cornerRadius;

  /// Base surface color of the plate (defaults to matching or slightly lighter than card).
  final Color? surfaceColor;

  /// Icon color on the plate.
  final Color? iconColor;

  /// Icon size.
  final double iconSize;

  /// Light source directional angle in radians (defaults to 315° / top-left).
  final double lightAngle;

  /// Highlight specular color (defaults to semi-translucent white).
  final Color highlightColor;

  /// Shadow color (defaults to soft translucent dark tone).
  final Color shadowColor;

  /// Elevation depth distance (1.0 to 12.0).
  final double depth;

  /// Whether the plate presses down into a debossed/flat state when tapped.
  final bool pressInteractive;

  /// Custom border width on the plate.
  final double borderWidth;

  /// Custom border color on the plate.
  final Color? borderColor;

  /// Custom shape config for the plate if [shape] is [SculptedPlateShape.custom].
  final DynamicShapeConfig? customShapeConfig;

  const SculptedPlateConfig({
    this.style = SculptedSurfaceStyle.embossed,
    this.shape = SculptedPlateShape.roundedSquare,
    this.size = 52.0,
    this.cornerRadius = 14.0,
    this.surfaceColor,
    this.iconColor,
    this.iconSize = 26.0,
    this.lightAngle = 5.497787, // ~315 degrees (top-left)
    this.highlightColor = const Color(0x66FFFFFF),
    this.shadowColor = const Color(0x2E000000),
    this.depth = 4.0,
    this.pressInteractive = true,
    this.borderWidth = 0.0,
    this.borderColor,
    this.customShapeConfig,
  });

  /// Factory: Neumorphic Circular Icon Plate.
  factory SculptedPlateConfig.neumorphic({
    double size = 52.0,
    Color? surfaceColor,
    Color? iconColor,
    double depth = 4.0,
  }) {
    return SculptedPlateConfig(
      style: SculptedSurfaceStyle.neumorphic,
      shape: SculptedPlateShape.circle,
      size: size,
      surfaceColor: surfaceColor,
      iconColor: iconColor,
      depth: depth,
    );
  }

  /// Factory: Paper Cutout Raised Square.
  factory SculptedPlateConfig.paperCutout({
    double size = 50.0,
    Color? surfaceColor = Colors.white,
    Color? iconColor,
  }) {
    return SculptedPlateConfig(
      style: SculptedSurfaceStyle.paperCutout,
      shape: SculptedPlateShape.roundedSquare,
      size: size,
      surfaceColor: surfaceColor,
      iconColor: iconColor,
      depth: 3.0,
      shadowColor: const Color(0x33000000),
    );
  }

  /// Factory: Soft Claymorphic Plate.
  factory SculptedPlateConfig.clay({
    double size = 54.0,
    Color? surfaceColor,
    Color? iconColor,
  }) {
    return SculptedPlateConfig(
      style: SculptedSurfaceStyle.clay,
      shape: SculptedPlateShape.roundedSquare,
      size: size,
      cornerRadius: 18.0,
      surfaceColor: surfaceColor,
      iconColor: iconColor,
      depth: 5.0,
    );
  }

  /// Factory: Frosted Glass Plate.
  factory SculptedPlateConfig.glass({
    double size = 52.0,
    Color? iconColor = Colors.white,
  }) {
    return SculptedPlateConfig(
      style: SculptedSurfaceStyle.glass,
      shape: SculptedPlateShape.roundedSquare,
      size: size,
      surfaceColor: const Color(0x26FFFFFF),
      iconColor: iconColor,
      borderWidth: 1.0,
      borderColor: const Color(0x4DFFFFFF),
      depth: 2.0,
    );
  }

  SculptedPlateConfig copyWith({
    SculptedSurfaceStyle? style,
    SculptedPlateShape? shape,
    double? size,
    double? cornerRadius,
    Color? surfaceColor,
    Color? iconColor,
    double? iconSize,
    double? lightAngle,
    Color? highlightColor,
    Color? shadowColor,
    double? depth,
    bool? pressInteractive,
    double? borderWidth,
    Color? borderColor,
    DynamicShapeConfig? customShapeConfig,
  }) {
    return SculptedPlateConfig(
      style: style ?? this.style,
      shape: shape ?? this.shape,
      size: size ?? this.size,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      lightAngle: lightAngle ?? this.lightAngle,
      highlightColor: highlightColor ?? this.highlightColor,
      shadowColor: shadowColor ?? this.shadowColor,
      depth: depth ?? this.depth,
      pressInteractive: pressInteractive ?? this.pressInteractive,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      customShapeConfig: customShapeConfig ?? this.customShapeConfig,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SculptedPlateConfig &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          shape == other.shape &&
          size == other.size &&
          cornerRadius == other.cornerRadius &&
          surfaceColor == other.surfaceColor &&
          iconColor == other.iconColor &&
          iconSize == other.iconSize &&
          lightAngle == other.lightAngle &&
          highlightColor == other.highlightColor &&
          shadowColor == other.shadowColor &&
          depth == other.depth &&
          pressInteractive == other.pressInteractive &&
          borderWidth == other.borderWidth &&
          borderColor == other.borderColor &&
          customShapeConfig == other.customShapeConfig;

  @override
  int get hashCode => Object.hashAll([
        style,
        shape,
        size,
        cornerRadius,
        surfaceColor,
        iconColor,
        iconSize,
        lightAngle,
        highlightColor,
        shadowColor,
        depth,
        pressInteractive,
        borderWidth,
        borderColor,
        customShapeConfig,
      ]);
}
