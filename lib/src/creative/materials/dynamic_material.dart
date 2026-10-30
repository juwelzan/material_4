import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../dynamic_shape_config.dart';
import '../../rendering/dynamic_shape_interaction.dart';
import '../borders/creative_border_config.dart';
import '../paper/paper_background_config.dart';

/// Supported physical material types for [MaterialDynamicCard].
enum DynamicMaterial {
  /// Authentic paper stationery with subtle grain and natural fiber.
  paper,

  /// Dense, opaque matte cardstock with crisp structural edges.
  cardstock,

  /// Soft, tactile claymorphic finish with volumetric ambient rim lighting.
  clay,

  /// Smooth, high-gloss ceramic finish with crisp specular reflections.
  ceramic,

  /// Frosted translucent glassmorphism with backdrop blur and luminous rim.
  glass,

  /// Modern molded polymer with smooth satin finish and subtle inner reflection.
  plastic,

  /// Specular brushed or polished metallic sheen (gold, silver, titanium, etc.).
  metal,

  /// Textured woven textile / canvas linen grain.
  softFabric,

  /// Heavy matte mineral / slate finish with tactile stippled stone grain.
  stone,

  /// High-friction soft rubber / silicone matte finish with deep inner absorption.
  rubber,

  /// Clean, low-reflectance modern flat matte surface.
  matte,

  /// High-gloss reflective surface with bright top specular highlight.
  glossy,
}

/// Comprehensive material configuration model for tactile card rendering.
class DynamicMaterialConfig {
  /// The physical material aesthetic.
  final DynamicMaterial material;

  /// Base substrate tint color.
  final Color? baseColor;

  /// Optional surface gradient override.
  final Gradient? surfaceGradient;

  /// Paper texture style when [material] is [DynamicMaterial.paper].
  final PaperBackgroundStyle? paperStyle;

  /// Visual surface roughness / tooth (0.0 = mirror smooth, 1.0 = heavy texture).
  final double roughness;

  /// Highlight specular color (light side).
  final Color? highlightColor;

  /// Shadow color (shadow side).
  final Color? shadowColor;

  /// Optional creative border configuration.
  final CreativeBorderConfig? border;

  /// 3D tactile elevation depth distance (1.0 to 24.0).
  final double depth;

  /// Overall material opacity (0.0 to 1.0).
  final double opacity;

  /// Direction of light source in radians (defaults to ~315° / top-left).
  final double lightAngle;

  const DynamicMaterialConfig({
    this.material = DynamicMaterial.paper,
    this.baseColor,
    this.surfaceGradient,
    this.paperStyle,
    this.roughness = 0.4,
    this.highlightColor,
    this.shadowColor,
    this.border,
    this.depth = 4.0,
    this.opacity = 1.0,
    this.lightAngle = 5.497787, // ~315 degrees
  });

  /// Factory: Paper Material.
  factory DynamicMaterialConfig.paper({
    Color? color,
    PaperBackgroundStyle paperStyle = PaperBackgroundStyle.plainWhite,
    double roughness = 0.4,
    double depth = 3.0,
    CreativeBorderConfig? border,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.paper,
      baseColor: color,
      paperStyle: paperStyle,
      roughness: roughness,
      depth: depth,
      border: border,
    );
  }

  /// Factory: Cardstock Material.
  factory DynamicMaterialConfig.cardstock({
    Color? color,
    double depth = 4.0,
    CreativeBorderConfig? border,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.cardstock,
      baseColor: color ?? const Color(0xFFF9F9FA),
      roughness: 0.2,
      depth: depth,
      border: border,
    );
  }

  /// Factory: Claymorphic Tactile Material.
  factory DynamicMaterialConfig.clay({
    Color? color,
    double depth = 6.0,
    CreativeBorderConfig? border,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.clay,
      baseColor: color ?? const Color(0xFFF0EAE1),
      roughness: 0.1,
      depth: depth,
      border: border,
    );
  }

  /// Factory: Glossy Ceramic Material.
  factory DynamicMaterialConfig.ceramic({
    Color? color,
    double depth = 4.0,
    CreativeBorderConfig? border,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.ceramic,
      baseColor: color ?? Colors.white,
      roughness: 0.05,
      depth: depth,
      border: border,
    );
  }

  /// Factory: Frosted Glass Material.
  factory DynamicMaterialConfig.glass({
    Color? tint,
    double blur = 16.0,
    double depth = 3.0,
    CreativeBorderConfig? border,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.glass,
      baseColor: tint ?? const Color(0x26FFFFFF),
      roughness: 0.0,
      depth: depth,
      border: border ??
          const CreativeBorderConfig(
            style: CreativeBorderStyle.doubleLine,
            width: 1.0,
            color: Color(0x4DFFFFFF),
          ),
    );
  }

  /// Factory: Satin Polymer Plastic Material.
  factory DynamicMaterialConfig.plastic({
    Color? color,
    double depth = 3.5,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.plastic,
      baseColor: color ?? const Color(0xFFF1F5F9),
      roughness: 0.15,
      depth: depth,
    );
  }

  /// Factory: Brushed / Reflective Metal Material.
  factory DynamicMaterialConfig.metal({
    Color? color,
    MetallicType type = MetallicType.silver,
    double depth = 4.0,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.metal,
      baseColor: color,
      roughness: 0.1,
      depth: depth,
    );
  }

  /// Factory: Soft Fabric / Linen Material.
  factory DynamicMaterialConfig.softFabric({
    Color? color,
    double depth = 2.5,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.softFabric,
      baseColor: color ?? const Color(0xFFF5EFE6),
      paperStyle: PaperBackgroundStyle.softLinen,
      roughness: 0.7,
      depth: depth,
    );
  }

  /// Factory: Slate Stone Material.
  factory DynamicMaterialConfig.stone({
    Color? color,
    double depth = 5.0,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.stone,
      baseColor: color ?? const Color(0xFFE2E8F0),
      roughness: 0.8,
      depth: depth,
    );
  }

  /// Factory: Soft Rubber / Silicone Material.
  factory DynamicMaterialConfig.rubber({
    Color? color,
    double depth = 3.0,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.rubber,
      baseColor: color ?? const Color(0xFF1E293B),
      roughness: 0.3,
      depth: depth,
    );
  }

  /// Factory: Ultra-clean Flat Matte Material.
  factory DynamicMaterialConfig.matte({
    Color? color,
    double depth = 3.0,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.matte,
      baseColor: color ?? const Color(0xFFF8FAFC),
      roughness: 0.05,
      depth: depth,
    );
  }

  /// Factory: High-Gloss Reflective Material.
  factory DynamicMaterialConfig.glossy({
    Color? color,
    double depth = 4.0,
  }) {
    return DynamicMaterialConfig(
      material: DynamicMaterial.glossy,
      baseColor: color ?? Colors.white,
      roughness: 0.0,
      depth: depth,
    );
  }

  /// Converts this [DynamicMaterialConfig] into an equivalent [DynamicShapeConfig]
  /// that plugs seamlessly into [RenderDynamicShape].
  DynamicShapeConfig toShapeConfig({
    DynamicShapeType shapeType = DynamicShapeType.smoothRounded,
    double cornerRadius = 16.0,
    ShapeCorners? corners,
    ShapeEdges? edges,
    ShapeTransform? transform,
    ShapeConstraints? constraints,
    DynamicShapeInteraction? interaction,
    ShapeClipConfig? clipConfig,
    CreativePatternConfig? creativePattern,
  }) {
    final lightDx = math.cos(lightAngle);
    final lightDy = math.sin(lightAngle);
    final darkOffset = Offset(-lightDx * depth, -lightDy * depth);
    final lightOffset = Offset(lightDx * depth, lightDy * depth);

    List<BoxShadow>? innerShadows;
    PaperBackgroundConfig? paperBg;
    bool isGlass = false;
    double glassBlur = 0.0;
    Color? glassTint;
    BackgroundEffectType backgroundEffect = BackgroundEffectType.none;

    switch (material) {
      case DynamicMaterial.paper:
        paperBg = PaperBackgroundConfig(
          style: paperStyle ?? PaperBackgroundStyle.plainWhite,
          textureIntensity: roughness,
        );
        break;

      case DynamicMaterial.cardstock:
        paperBg = PaperBackgroundConfig(
          style: PaperBackgroundStyle.cardstock,
          textureIntensity: roughness,
        );
        break;

      case DynamicMaterial.clay:
        innerShadows = [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.6),
            offset: lightOffset * 0.4,
            blurRadius: depth * 0.8,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            offset: darkOffset * 0.4,
            blurRadius: depth * 0.8,
          ),
        ];
        break;

      case DynamicMaterial.ceramic:
        innerShadows = [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.7),
            offset: lightOffset * 0.3,
            blurRadius: 1.5,
          ),
        ];
        break;

      case DynamicMaterial.glass:
        isGlass = true;
        glassBlur = 14.0;
        glassTint = baseColor ?? const Color(0x26FFFFFF);
        break;

      case DynamicMaterial.metal:
        backgroundEffect = BackgroundEffectType.metallic;
        break;

      case DynamicMaterial.softFabric:
        paperBg = PaperBackgroundConfig(
          style: PaperBackgroundStyle.softLinen,
          textureIntensity: roughness,
        );
        break;

      case DynamicMaterial.stone:
        paperBg = PaperBackgroundConfig(
          style: PaperBackgroundStyle.roughFiber,
          textureIntensity: roughness,
        );
        break;

      case DynamicMaterial.rubber:
        innerShadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: darkOffset * 0.5,
            blurRadius: depth,
          ),
        ];
        break;

      case DynamicMaterial.matte:
      case DynamicMaterial.plastic:
      case DynamicMaterial.glossy:
        break;
    }

    return DynamicShapeConfig(
      type: shapeType,
      cornerRadius: cornerRadius,
      corners: corners,
      edges: edges,
      transform: transform,
      constraints: constraints ?? const ShapeConstraints(),
      interaction: interaction,
      clipConfig: clipConfig,
      creativeBorder: border,
      paperBackground: paperBg,
      creativePattern: creativePattern,
      innerShadows: innerShadows,
      isGlassmorphic: isGlass,
      glassBlur: glassBlur,
      glassTint: glassTint,
      backgroundEffect: backgroundEffect,
    );
  }

  /// Calculates outer box shadows consistent with the material lighting and depth.
  List<BoxShadow> buildShadows() {
    final lightDx = math.cos(lightAngle);
    final lightDy = math.sin(lightAngle);
    final darkOffset = Offset(-lightDx * depth, -lightDy * depth);
    final lightOffset = Offset(lightDx * depth, lightDy * depth);

    switch (material) {
      case DynamicMaterial.clay:
        return [
          BoxShadow(
            color: (shadowColor ?? Colors.black).withValues(alpha: 0.14),
            blurRadius: depth * 1.6,
            offset: darkOffset * 0.7,
          ),
          BoxShadow(
            color: (highlightColor ?? Colors.white).withValues(alpha: 0.75),
            blurRadius: depth * 1.4,
            offset: lightOffset * 0.7,
          ),
        ];

      case DynamicMaterial.glass:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: depth * 2.0,
            offset: Offset(0, depth * 0.8),
          ),
        ];

      case DynamicMaterial.rubber:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: depth * 1.8,
            offset: darkOffset * 0.8,
          ),
        ];

      default:
        return [
          BoxShadow(
            color:
                (shadowColor ?? Colors.black).withValues(alpha: 0.10 * opacity),
            blurRadius: depth * 2.0,
            offset: Offset(darkOffset.dx * 0.5, math.max(2.0, depth * 0.75)),
          ),
        ];
    }
  }

  /// Effective surface color.
  Color get surfaceColor => baseColor ?? const Color(0xFFF9F9FA);

  /// Effective surface gradient.
  Gradient? get gradient => surfaceGradient;

  /// Effective border color.
  Color get borderColor => border?.color ?? const Color(0x1F000000);

  DynamicMaterialConfig copyWith({
    DynamicMaterial? material,
    Color? baseColor,
    Gradient? surfaceGradient,
    PaperBackgroundStyle? paperStyle,
    double? roughness,
    Color? highlightColor,
    Color? shadowColor,
    CreativeBorderConfig? border,
    double? depth,
    double? opacity,
    double? lightAngle,
  }) {
    return DynamicMaterialConfig(
      material: material ?? this.material,
      baseColor: baseColor ?? this.baseColor,
      surfaceGradient: surfaceGradient ?? this.surfaceGradient,
      paperStyle: paperStyle ?? this.paperStyle,
      roughness: roughness ?? this.roughness,
      highlightColor: highlightColor ?? this.highlightColor,
      shadowColor: shadowColor ?? this.shadowColor,
      border: border ?? this.border,
      depth: depth ?? this.depth,
      opacity: opacity ?? this.opacity,
      lightAngle: lightAngle ?? this.lightAngle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamicMaterialConfig &&
          runtimeType == other.runtimeType &&
          material == other.material &&
          baseColor == other.baseColor &&
          surfaceGradient == other.surfaceGradient &&
          paperStyle == other.paperStyle &&
          roughness == other.roughness &&
          highlightColor == other.highlightColor &&
          shadowColor == other.shadowColor &&
          border == other.border &&
          depth == other.depth &&
          opacity == other.opacity &&
          lightAngle == other.lightAngle;

  @override
  int get hashCode => Object.hashAll([
        material,
        baseColor,
        surfaceGradient,
        paperStyle,
        roughness,
        highlightColor,
        shadowColor,
        border,
        depth,
        opacity,
        lightAngle,
      ]);
}
