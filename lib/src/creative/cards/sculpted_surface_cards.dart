import 'package:flutter/material.dart';

import '../../material_4_config.dart';
import '../../material_4_container.dart';
import '../borders/creative_border_config.dart';
import '../materials/dynamic_material.dart';
import '../paper/paper_background_config.dart';
import 'sculpted_card_config.dart';
import 'sculpted_icon_card.dart';

// =============================================================================
// 1. EmbossedCard
// =============================================================================

/// Card preset with raised embossed tactile styling and directional lighting.
class EmbossedCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const EmbossedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor = const Color(0xFFF2F4F7),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      shadows: const [
        BoxShadow(
          color: Color(0x1A000000),
          offset: Offset(2, 3),
          blurRadius: 6,
        ),
        BoxShadow(
          color: Color(0xCCFFFFFF),
          offset: Offset(-2, -2),
          blurRadius: 4,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 18.0,
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.outset,
          width: 2.0,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 2. DebossedCard
// =============================================================================

/// Card preset with carved debossed recessed surface and inner depth shadow.
class DebossedCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const DebossedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor = const Color(0xFFEEF0F4),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 18.0,
        innerShadows: [
          BoxShadow(
            color: Color(0x2E000000),
            offset: Offset(2, 3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Color(0xD9FFFFFF),
            offset: Offset(-1, -1),
            blurRadius: 3,
          ),
        ],
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.inset,
          width: 2.0,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 3. NeumorphicCard
// =============================================================================

/// Neumorphic soft light-and-dark dual directional shadow card.
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final double depth;
  final VoidCallback? onTap;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.color = const Color(0xFFE0E5EC),
    this.depth = 6.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderWidth: 0.0,
      shadows: [
        BoxShadow(
          color: const Color(0x2E000000),
          blurRadius: depth * 2.0,
          offset: Offset(depth, depth),
        ),
        BoxShadow(
          color: const Color(0xD9FFFFFF),
          blurRadius: depth * 2.0,
          offset: Offset(-depth, -depth),
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 20.0,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 4. SoftRaisedCard
// =============================================================================

/// Pillowy gently elevated surface with wide ambient diffusion.
class SoftRaisedCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const SoftRaisedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(22.0),
    this.margin,
    this.backgroundColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      shadows: const [
        BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 12),
          blurRadius: 28,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Color(0x0A000000),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 24.0,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 5. HardRaisedCard
// =============================================================================

/// Architectural beveled edge card with crisp specular highlights and solid cast shadow.
class HardRaisedCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color shadowColor;
  final double elevation;
  final VoidCallback? onTap;

  const HardRaisedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor = const Color(0xFFF8F9FA),
    this.shadowColor = const Color(0xFF1E293B),
    this.elevation = 4.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: shadowColor,
      borderWidth: 1.5,
      shadows: [
        BoxShadow(
          color: shadowColor,
          offset: Offset(elevation, elevation),
          blurRadius: 0.0,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 12.0,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 6. RecessedCard
// =============================================================================

/// Carved well inside a parent surface with dark top/left shadows and specular rim highlights.
class RecessedCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const RecessedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor = const Color(0xFFECEFF1),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 16.0,
        innerShadows: [
          BoxShadow(
            color: Color(0x3D000000),
            offset: Offset(2, 3),
            blurRadius: 5,
          ),
          BoxShadow(
            color: Color(0xE6FFFFFF),
            offset: Offset(-1, -1),
            blurRadius: 3,
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 7. FloatingSurfaceCard
// =============================================================================

/// Separated elevated plate floating above background with deep ambient drop shadow.
class FloatingSurfaceCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const FloatingSurfaceCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(22.0),
    this.margin,
    this.backgroundColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x14000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x1F000000),
          offset: Offset(0, 16),
          blurRadius: 36,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Color(0x0D000000),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 20.0,
        borderStyle: BorderStyleType.solid,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 8. ClayCard
// =============================================================================

/// Soft, thick, toy-like tactile claymorphic container.
class ClayCard extends StatelessWidget {
  final dynamic icon;
  final dynamic title;
  final dynamic subtitle;
  final Widget? child;
  final Color color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const ClayCard({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.child,
    this.color = const Color(0xFFF0EAE1),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null && title != null) {
      return SculptedIconCard.clay(
        icon: icon,
        title: title,
        subtitle: subtitle,
        onTap: onTap,
      );
    }

    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      shadows: const [
        BoxShadow(
          color: Color(0x24000000),
          offset: Offset(5, 7),
          blurRadius: 14,
        ),
        BoxShadow(
          color: Color(0xCCFFFFFF),
          offset: Offset(-4, -4),
          blurRadius: 10,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 22.0,
        innerShadows: [
          BoxShadow(
            color: Color(0x66FFFFFF),
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: child ?? const SizedBox.shrink(),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 9. CeramicCard
// =============================================================================

/// High-gloss, ultra-clean polished porcelain / ceramic container with crisp specular reflections.
class CeramicCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const CeramicCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(22.0),
    this.margin,
    this.backgroundColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final matConfig = DynamicMaterialConfig.ceramic(color: backgroundColor);
    final shapeConfig = matConfig.toShapeConfig(
      shapeType: Material4Type.smoothRounded,
      cornerRadius: 18.0,
    );

    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x1A000000),
      borderWidth: 1.0,
      shadows: matConfig.buildShadows(),
      config: shapeConfig,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 10. OrganicSurfaceCard
// =============================================================================

/// Fluid non-uniform curved boundary card with natural lighting and soft watercolor tooth.
class OrganicSurfaceCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final VoidCallback? onTap;

  const OrganicSurfaceCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.color = const Color(0xFFF3EFEA),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      config: const Material4Config(
        type: Material4Type.organicBlob,
        cornerRadius: 24.0,
        paperBackground: PaperBackgroundConfig(
          style: PaperBackgroundStyle.watercolor,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 11. LayeredMaterialCard
// =============================================================================

/// Multi-tier composite combining multiple material textures into one cohesive container.
class LayeredMaterialCard extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final Color baseColor;
  final Color surfaceColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const LayeredMaterialCard({
    super.key,
    required this.child,
    this.header,
    this.baseColor = const Color(0xFFE2D9CC),
    this.surfaceColor = const Color(0xFFFFFDF8),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(6.0),
      margin: margin,
      color: baseColor,
      shadows: const [
        BoxShadow(
          color: Color(0x1F000000),
          offset: Offset(0, 6),
          blurRadius: 14,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 18.0,
        paperBackground: PaperBackgroundConfig(
          style: PaperBackgroundStyle.cardstock,
          grainOpacity: 0.08,
        ),
      ),
      child: Material4Container(
        padding: padding,
        color: surfaceColor,
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
        config: const Material4Config(
          type: Material4Type.smoothRounded,
          cornerRadius: 14.0,
          paperBackground: PaperBackgroundConfig(
            style: PaperBackgroundStyle.plainWhite,
            grainOpacity: 0.04,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) ...[
              header!,
              const SizedBox(height: 12.0),
            ],
            child,
          ],
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// Backward-Compatibility Sculpted Icon Presets
// =============================================================================

/// Card preset featuring a floating icon plate above the surface.
class FloatingIconCard extends StatelessWidget {
  final dynamic icon;
  final dynamic title;
  final dynamic subtitle;
  final VoidCallback? onTap;

  const FloatingIconCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SculptedIconCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconPosition: SculptedIconPosition.topLeft,
      plateConfig: const SculptedPlateConfig(
        style: SculptedSurfaceStyle.floating,
        depth: 6.0,
      ),
      onTap: onTap,
    );
  }
}

/// Card preset with a recessed icon well pressed into the surface.
class RecessedIconCard extends StatelessWidget {
  final dynamic icon;
  final dynamic title;
  final dynamic subtitle;
  final VoidCallback? onTap;

  const RecessedIconCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SculptedIconCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconPosition: SculptedIconPosition.centerLeft,
      plateConfig: const SculptedPlateConfig(
        style: SculptedSurfaceStyle.recessed,
        depth: 3.5,
      ),
      onTap: onTap,
    );
  }
}

/// Frosted glass icon card with translucent plate.
class GlassIconCard extends StatelessWidget {
  final dynamic icon;
  final dynamic title;
  final dynamic subtitle;
  final VoidCallback? onTap;

  const GlassIconCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SculptedIconCard(
      icon: icon,
      title: title,
      subtitle: subtitle,
      plateConfig: SculptedPlateConfig.glass(),
      backgroundColor: const Color(0xFF2C3E50),
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      subtitleStyle: const TextStyle(
        color: Colors.white70,
      ),
      onTap: onTap,
    );
  }
}

/// Multi-layered stacked physical material card.
class MaterialStackCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const MaterialStackCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: const Color(0xFFFAF5ED),
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 16.0,
        paperBackground: PaperBackgroundConfig(
          style: PaperBackgroundStyle.kraft,
          textureIntensity: 0.6,
        ),
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.layered,
          width: 3.0,
          color: Color(0xFF8B5A2B),
        ),
      ),
      child: child,
    );
  }
}
