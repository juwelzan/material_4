import 'package:flutter/material.dart';

import '../../material_4_config.dart';
import '../../material_4_container.dart';
import '../borders/creative_border_config.dart';

// =============================================================================
// 1. GlassCard
// =============================================================================

/// Frosted translucent glassmorphic card with backdrop blur and luminous rim.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color tint;
  final Color borderColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 18.0,
    this.tint = const Color(0x26FFFFFF),
    this.borderColor = const Color(0x33FFFFFF),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: tint,
      borderColor: borderColor,
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x1A000000),
          offset: Offset(0, 8),
          blurRadius: 24,
        ),
      ],
      config: Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 20.0,
        isGlassmorphic: true,
        glassBlur: blur,
        glassTint: tint,
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
// 2. GradientCard
// =============================================================================

/// Dynamic card with multi-stop linear or angular color flow and subtle surface sheen.
class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double cornerRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFD946EF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.cornerRadius = 20.0,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      gradient: gradient,
      shadows: const [
        BoxShadow(
          color: Color(0x334F46E5),
          offset: Offset(0, 8),
          blurRadius: 20,
        ),
      ],
      config: Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: cornerRadius,
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
// 3. GlowCard
// =============================================================================

/// Radiant luminous card contouring the shape perimeter with colored bloom.
class GlowCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final Color backgroundColor;
  final double glowRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GlowCard({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFF3B82F6),
    this.backgroundColor = const Color(0xFF0F172A),
    this.glowRadius = 16.0,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
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
      shadows: [
        BoxShadow(
          color: glowColor.withValues(alpha: 0.45),
          blurRadius: glowRadius,
          spreadRadius: 1,
        ),
      ],
      config: Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 18.0,
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.glow,
          color: glowColor,
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
// 4. NeonCard
// =============================================================================

/// High-specular cyberpunk gas tube neon card with vibrant luminous border.
class NeonCard extends StatelessWidget {
  final Widget child;
  final Color neonColor;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const NeonCard({
    super.key,
    required this.child,
    this.neonColor = const Color(0xFF00FFCC),
    this.backgroundColor = const Color(0xFF0A0F1D),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
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
      shadows: [
        BoxShadow(
          color: neonColor.withValues(alpha: 0.35),
          blurRadius: 20,
          spreadRadius: 1,
        ),
      ],
      config: Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 16.0,
        creativeBorder: CreativeBorderConfig.neon(
          color: neonColor,
          width: 2.5,
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
// 5. MeshGradientCard
// =============================================================================

/// Multi-point coordinate fluid color mesh card.
class MeshGradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const MeshGradientCard({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFFFF5E7E),
      Color(0xFFFF9966),
      Color(0xFF8A2387),
      Color(0xFFE94057),
    ],
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Material4Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: colors.first,
      shadows: [
        BoxShadow(
          color: colors.first.withValues(alpha: 0.3),
          offset: const Offset(0, 8),
          blurRadius: 22,
        ),
      ],
      config: Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 20.0,
        backgroundEffect: BackgroundEffectType.meshGradient,
        meshColors: colors,
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
// 6. FloatingCard
// =============================================================================

/// Multi-plane floating card with dramatic ambient elevation and smooth hover response.
class FloatingCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const FloatingCard({
    super.key,
    required this.child,
    this.elevation = 16.0,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(22.0),
    this.margin,
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
      shadows: [
        BoxShadow(
          color: const Color(0x1F000000),
          offset: Offset(0, elevation),
          blurRadius: elevation * 2.2,
          spreadRadius: 1,
        ),
        const BoxShadow(
          color: Color(0x0A000000),
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 22.0,
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
// 7. OrganicBlobCard
// =============================================================================

/// Fluid, living amoeba-like boundary card for playful, human-centered UI.
class OrganicBlobCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const OrganicBlobCard({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFFF3E8FF),
    this.gradient,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(24.0),
    this.margin,
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
      gradient: gradient,
      shadows: const [
        BoxShadow(
          color: Color(0x18000000),
          offset: Offset(0, 6),
          blurRadius: 16,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.organicBlob,
        cornerRadius: 32.0,
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
// 8. AsymmetricCard
// =============================================================================

/// Distinct, unbalanced corner radii card crafted for high-end editorial layouts.
class AsymmetricCard extends StatelessWidget {
  final Widget child;
  final ShapeCorners corners;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const AsymmetricCard({
    super.key,
    required this.child,
    this.corners = const ShapeCorners(
      topLeft: Radius.circular(36.0),
      topRight: Radius.circular(8.0),
      bottomRight: Radius.circular(36.0),
      bottomLeft: Radius.circular(8.0),
    ),
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(22.0),
    this.margin,
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
          color: Color(0x14000000),
          offset: Offset(0, 4),
          blurRadius: 12,
        ),
      ],
      config: Material4Config(
        type: Material4Type.asymmetricCard,
        corners: corners,
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
// 9. CutCornerCard
// =============================================================================

/// Modern tech / industrial card with geometric 45-degree chamfered cut corners.
class CutCornerCard extends StatelessWidget {
  final Widget child;
  final double cutSize;
  final Color backgroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const CutCornerCard({
    super.key,
    required this.child,
    this.cutSize = 20.0,
    this.backgroundColor = const Color(0xFFF1F5F9),
    this.borderColor = const Color(0xFFCBD5E1),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
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
      borderColor: borderColor ?? Colors.transparent,
      borderWidth: borderColor != null ? 1.0 : 0.0,
      shadows: const [
        BoxShadow(
          color: Color(0x12000000),
          offset: Offset(0, 4),
          blurRadius: 8,
        ),
      ],
      config: Material4Config(
        type: Material4Type.chamferDiagonal,
        tabWidth: cutSize,
        tabHeight: cutSize,
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
// 10. NotchedCard
// =============================================================================

/// Container with functional cutouts / notches along edges for badges or alignment.
class NotchedCard extends StatelessWidget {
  final Widget child;
  final ShapeAnchor notchPosition;
  final double notchWidth;
  final double notchHeight;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const NotchedCard({
    super.key,
    required this.child,
    this.notchPosition = ShapeAnchor.topCenter,
    this.notchWidth = 64.0,
    this.notchHeight = 16.0,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
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
          color: Color(0x14000000),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      config: Material4Config(
        type: Material4Type.notchedBadge,
        anchor: notchPosition,
        tabWidth: notchWidth,
        tabHeight: notchHeight,
        cornerRadius: 16.0,
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
// 11. TicketCard
// =============================================================================

/// Ticket voucher card with semi-circular notch cutouts and perforated tear line.
class TicketCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const TicketCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.backgroundColor = const Color(0xFFFFFDF8),
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
          color: Color(0x18000000),
          offset: Offset(0, 3),
          blurRadius: 8,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.ticketScallop,
        scallopRadius: 16.0,
        creativeBorder: CreativeBorderConfig(
          style: CreativeBorderStyle.perforated,
          width: 1.5,
          color: Color(0xFFCFD8DC),
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
// 12. MagazineCard
// =============================================================================

/// Bold editorial typography hierarchy card inspired by modern print publishing.
class MagazineCard extends StatelessWidget {
  final String category;
  final String headline;
  final String? excerpt;
  final String? date;
  final Widget? image;
  final Color backgroundColor;
  final Color accentColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const MagazineCard({
    super.key,
    required this.category,
    required this.headline,
    this.excerpt,
    this.date,
    this.image,
    this.backgroundColor = Colors.white,
    this.accentColor = const Color(0xFFE11D48),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(22.0),
    this.margin,
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
          color: Color(0x12000000),
          offset: Offset(0, 6),
          blurRadius: 16,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 4.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(2.0),
              child: image!,
            ),
            const SizedBox(height: 14.0),
          ],
          Text(
            category.toUpperCase(),
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            headline,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              height: 1.2,
              color: Color(0xFF0F172A),
            ),
          ),
          if (excerpt != null) ...[
            const SizedBox(height: 8.0),
            Text(
              excerpt!,
              style: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFF475569),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (date != null) ...[
            const SizedBox(height: 12.0),
            Text(
              date!,
              style: const TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 13. EditorialCard
// =============================================================================

/// Elegant monograph/museum aesthetic card with hairline framing and generous whitespace.
class EditorialCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color frameColor;
  final VoidCallback? onTap;

  const EditorialCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(28.0),
    this.margin,
    this.backgroundColor = const Color(0xFFFAF9F6),
    this.frameColor = const Color(0xFFD6D3D1),
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
      borderColor: frameColor,
      borderWidth: 0.75,
      shadows: const [
        BoxShadow(
          color: Color(0x0A000000),
          offset: Offset(0, 2),
          blurRadius: 8,
        ),
      ],
      config: const Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 2.0,
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
// 14. MinimalSurfaceCard
// =============================================================================

/// Ultra-clean minimal card with hairline boundary and nuanced surface tone.
class MinimalSurfaceCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double cornerRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const MinimalSurfaceCard({
    super.key,
    required this.child,
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.borderColor = const Color(0xFFE5E5E5),
    this.cornerRadius = 12.0,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
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
      borderColor: borderColor,
      borderWidth: 0.5,
      config: Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: cornerRadius,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}
