import 'package:flutter/material.dart';

import '../../dynamic_shape_config.dart';
import '../../dynamic_shape_container.dart';
import '../borders/creative_border_config.dart';
import '../paper/paper_background_config.dart';
import 'sculpted_card_config.dart';
import 'sculpted_icon_card.dart';

/// Card preset featuring realistic torn paper edges, texture, and drop shadow.
class TornPaperCard extends StatelessWidget {
  final Widget child;
  final BorderEdges edges;
  final double tearIntensity;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const TornPaperCard({
    super.key,
    required this.child,
    this.edges = BorderEdges.all,
    this.tearIntensity = 0.6,
    this.backgroundColor = const Color(0xFFF9F6F0),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      config: DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 4.0,
        creativeBorder: CreativeBorderConfig.tornPaper(
          edges: edges,
          tearIntensity: tearIntensity,
          color: const Color(0xFFE5DFD3),
        ),
        paperBackground: const PaperBackgroundConfig(
          style: PaperBackgroundStyle.handmade,
          grainOpacity: 0.08,
          fiberDensity: 0.35,
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

/// Card preset with horizontal ruled notebook paper lines and a red margin rule.
class NotebookCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const NotebookCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor = const Color(0xFFFCFAF2),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      config: DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 12.0,
        paperBackground: const PaperBackgroundConfig(
          style: PaperBackgroundStyle.notebook,
        ),
        creativePattern: CreativePatternConfig.notebookRuling(),
      ),
      child: child,
    );
  }
}

/// Card preset resembling a canary yellow desk sticky note with top adhesive shadow.
class StickyNoteCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final VoidCallback? onTap;

  const StickyNoteCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
    this.color = const Color(0xFFFFF9A6),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      shadows: const [
        BoxShadow(
          color: Color(0x24000000),
          blurRadius: 10.0,
          offset: Offset(0, 6),
        ),
      ],
      config: DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 4.0,
        paperBackground: PaperBackgroundConfig.stickyNote(baseColor: color),
      ),
      child: child,
    );
  }
}

/// Card preset with aged sepia tone, edge vignette patina, and antique texture.
class VintagePaperCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const VintagePaperCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: const Color(0xFFF4ECD8),
      config: DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 8.0,
        paperBackground: PaperBackgroundConfig.vintage(),
      ),
      child: child,
    );
  }
}

/// Card preset with stacked, stepped cardstock layers.
class LayeredPaperCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const LayeredPaperCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: const Color(0xFFFAF7F0),
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 16.0,
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.layered,
          width: 2.0,
          color: Color(0xFFDDD4C5),
        ),
      ),
      child: child,
    );
  }
}

/// Card preset with a folded origami corner crease.
class FoldedCornerCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const FoldedCornerCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: const Color(0xFFFAF7F2),
      config: const DynamicShapeConfig(
        type: DynamicShapeType.chamferDiagonal,
        tabWidth: 28.0,
        tabHeight: 28.0,
        paperBackground: PaperBackgroundConfig(
          style: PaperBackgroundStyle.folded,
          hasFolds: true,
        ),
      ),
      child: child,
    );
  }
}

/// Coupon voucher card with dashed perforations and corner notch cutouts.
class CouponCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const CouponCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: Colors.white,
      config: const DynamicShapeConfig(
        type: DynamicShapeType.ticketScallop,
        scallopRadius: 14.0,
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.couponEdge,
          width: 1.5,
          color: Color(0xFFB0BEC5),
        ),
      ),
      child: child,
    );
  }
}

/// Ticket stub card with circular edge bites and perforations.
class TicketCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const TicketCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: const Color(0xFFFFFDF8),
      config: const DynamicShapeConfig(
        type: DynamicShapeType.ticketScallop,
        scallopRadius: 16.0,
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.perforated,
          width: 1.5,
          color: Color(0xFFCFD8DC),
        ),
      ),
      child: child,
    );
  }
}

/// Card preset with raised embossed tactile styling.
class EmbossedCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;

  const EmbossedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor = const Color(0xFFF2F4F7),
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 18.0,
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.outset,
          width: 2.0,
        ),
      ),
      child: child,
    );
  }
}

/// Card preset with carved debossed recessed surface.
class DebossedCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;

  const DebossedCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor = const Color(0xFFEEF0F4),
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 18.0,
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.inset,
          width: 2.0,
        ),
      ),
      child: child,
    );
  }
}

/// Neumorphic soft light-and-dark directional card.
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.color = const Color(0xFFE0E5EC),
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderWidth: 0.0,
      shadows: const [
        BoxShadow(
          color: Color(0x2E000000),
          blurRadius: 10.0,
          offset: Offset(5, 5),
        ),
        BoxShadow(
          color: Color(0xD9FFFFFF),
          blurRadius: 10.0,
          offset: Offset(-5, -5),
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 20.0,
      ),
      child: child,
    );
  }
}

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

/// Soft matte clay-inspired card.
class ClayCard extends StatelessWidget {
  final dynamic icon;
  final dynamic title;
  final dynamic subtitle;
  final VoidCallback? onTap;

  const ClayCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SculptedIconCard.clay(
      icon: icon,
      title: title,
      subtitle: subtitle,
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

/// Organic fluid curved surface card.
class OrganicSurfaceCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;

  const OrganicSurfaceCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.color = const Color(0xFFF3EFEA),
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      config: const DynamicShapeConfig(
        type: DynamicShapeType.organicBlob,
        cornerRadius: 24.0,
        paperBackground: PaperBackgroundConfig(
          style: PaperBackgroundStyle.watercolor,
        ),
      ),
      child: child,
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
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: const Color(0xFFFAF5ED),
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
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

