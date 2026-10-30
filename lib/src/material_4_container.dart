import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'animated_material_4.dart';
import 'animation/shape_animation_config.dart';
import 'animation/shape_animation_controller.dart';
import 'material_4_config.dart';
import 'material_4_path_builder.dart';
import 'material_4_stack.dart';
import 'layout/shape_collision_detector.dart';
import 'layout/shape_content_protection.dart';
import 'rendering/material_4_hit_test.dart';
import 'rendering/material_4_interaction.dart';
import 'rendering/material_4_multi_child_render_widget.dart';
import 'rendering/material_4_painter.dart';
import 'rendering/material_4_render_widget.dart';
import 'shape_pattern.dart';

/// CustomClipper that clips any child widget to the exact contour
/// of the configured Material 4 shape.
class Material4Clipper extends CustomClipper<Path> {
  final Material4Config config;

  const Material4Clipper({required this.config});

  @override
  Path getClip(Size size) {
    return Material4PathBuilder.buildPath(size, config);
  }

  @override
  bool shouldReclip(covariant Material4Clipper oldClipper) {
    return oldClipper.config != config;
  }
}

/// Legacy adapter if a [CustomPainter] is directly needed.
///
/// Under normal usage, [Material4Container] and [Material4RenderWidget]
/// draw directly using [RenderMaterial4] and [Material4Painter.paintShape].
class Material4CustomPainter extends CustomPainter {
  final Material4Config config;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;

  const Material4CustomPainter({
    required this.config,
    this.color,
    this.gradient,
    this.borderColor = const Color(0x18000000),
    this.borderWidth = 1.0,
    this.shadows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Material4PathBuilder.buildPath(size, config);
    Material4Painter.paintShape(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
    );
  }

  @override
  bool shouldRepaint(covariant Material4CustomPainter oldDelegate) {
    return oldDelegate.config != config ||
        oldDelegate.color != color ||
        oldDelegate.gradient != gradient ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.shadows != shadows;
  }
}

/// A universal, modular shape container widget that dynamically transforms
/// its geometry, patterns, frosted glassmorphism, inner shadows, and border styling.

/// Type alias for [Material4Container].
typedef Material4ShapeContainer = Material4Container;

class Material4Container extends StatelessWidget {
  final Widget? child;

  /// Optional multiple children. When provided and non-empty, [RenderMultiChildMaterial4]
  /// is used for intelligent geometry-aware multi-child layout.
  final List<Widget>? children;

  final Material4Config config;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final Clip clipBehavior;

  /// Shape-aware content protection mode ensuring child readability and bounds.
  final ShapeContentProtection contentProtection;

  /// Hit testing strategy (exact shape contour vs rectangular bounding box).
  final ShapeHitTestBehavior hitTestBehavior;

  /// Shape-aware interaction, hit-testing, and pointer routing configuration.
  final Material4Interaction? interaction;

  /// Granular layer-specific clipping configuration.
  final ShapeClipConfig? clipConfig;

  /// Optional child alignment inside the container's safe content area.
  final AlignmentGeometry? alignment;

  /// Layout strategy governing multi-child positioning when [children] is provided.
  final ShapeLayoutStrategy layoutStrategy;

  /// Inter-child spacing for flow layouts.
  final double childrenSpacing;

  /// Collision policy governing behavior when multiple children overlap.
  final ShapeCollisionPolicy collisionPolicy;

  /// Optional accessory/badge to dock into the notch or tab
  final Widget? dockedBadge;
  final Alignment badgeAlignment;
  final EdgeInsets badgePadding;

  /// Accessibility semantic label.
  final String? semanticLabel;

  /// Accessibility semantic hint.
  final String? semanticHint;

  /// Optional Material 4 shape type preset overriding [config.type].
  final Material4Type? shape;

  /// Optional animation configuration for automatic shape morphing.
  final ShapeAnimationConfig? animation;

  /// Optional shape animation controller for programmatic motion orchestration.
  final ShapeAnimationController? controller;

  const Material4Container({
    super.key,
    this.config = const Material4Config(),
    this.shape,
    this.animation,
    this.controller,
    this.child,
    this.children,
    this.width,
    this.height,
    this.padding,
    this.alignment,
    this.layoutStrategy = ShapeLayoutStrategy.stack,
    this.childrenSpacing = 8.0,
    this.collisionPolicy = ShapeCollisionPolicy.reposition,
    this.margin,
    this.color,
    this.gradient,
    this.borderColor = const Color(0x1F1A1A1A),
    this.borderWidth = 1.0,
    this.shadows = const [
      BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 4)),
    ],
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.clipBehavior = Clip.antiAlias,
    this.contentProtection = const ShapeContentProtection(),
    this.hitTestBehavior = ShapeHitTestBehavior.shapeContour,
    this.interaction,
    this.clipConfig,
    this.dockedBadge,
    this.badgeAlignment = Alignment.topRight,
    this.badgePadding = EdgeInsets.zero,
    this.semanticLabel,
    this.semanticHint,
  });

  /// Factory constructor for direct [ShapeContentMode] selection.
  Material4Container.withMode({
    super.key,
    this.config = const Material4Config(),
    this.shape,
    this.animation,
    this.controller,
    this.child,
    this.children,
    required ShapeContentMode mode,
    this.width,
    this.height,
    this.padding,
    this.alignment,
    this.layoutStrategy = ShapeLayoutStrategy.stack,
    this.childrenSpacing = 8.0,
    this.collisionPolicy = ShapeCollisionPolicy.reposition,
    this.margin,
    this.color,
    this.gradient,
    this.borderColor = const Color(0x1F1A1A1A),
    this.borderWidth = 1.0,
    this.shadows = const [
      BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 4)),
    ],
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.clipBehavior = Clip.antiAlias,
    this.hitTestBehavior = ShapeHitTestBehavior.shapeContour,
    this.interaction,
    this.clipConfig,
    this.dockedBadge,
    this.badgeAlignment = Alignment.topRight,
    this.badgePadding = EdgeInsets.zero,
    this.semanticLabel,
    this.semanticHint,
  }) : contentProtection = ShapeContentProtection(mode: mode);

  /// Quick accessor to the active content layout mode.
  ShapeContentMode get contentMode => contentProtection.mode;

  /// Factory for Frosted Glassmorphism Container with dynamic path clipping
  factory Material4Container.glass({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double glassBlur = 16.0,
    Color glassTint = const Color(0x28FFFFFF),
    Color borderColor = const Color(0x40FFFFFF),
    double borderWidth = 1.2,
    VoidCallback? onTap,
    Widget? dockedBadge,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(
        isGlassmorphic: true,
        glassBlur: glassBlur,
        glassTint: glassTint,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: glassTint,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      dockedBadge: dockedBadge,
      child: child,
    );
  }

  /// Factory for Patterned Container (stripes, dots, grid, waves)
  factory Material4Container.patterned({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    ShapePattern pattern = ShapePattern.dotsMatrix,
    Color? patternColor,
    double patternSpacing = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(
        pattern: pattern,
        patternColor: patternColor,
        patternSpacing: patternSpacing,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Sculpted Claymorphic Container with Inset Inner Shadow
  factory Material4Container.innerShadow({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    List<BoxShadow> innerShadows = const [
      BoxShadow(color: Color(0x18000000), blurRadius: 8, offset: Offset(2, 3)),
      BoxShadow(
        color: Color(0x44FFFFFF),
        blurRadius: 6,
        offset: Offset(-2, -2),
      ),
    ],
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(innerShadows: innerShadows),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Luminous Pulsing Neon Bloom Border
  factory Material4Container.neon({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color neonColor = const Color(0xFF00E5FF),
    double borderWidth = 2.0,
    double pulseIntensity = 1.0,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.neonPulse,
        neonPulseIntensity: pulseIntensity,
        neonGlowColor: neonColor,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: neonColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Specular Reflective Metallic Border
  factory Material4Container.metallic({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    MetallicType metallicType = MetallicType.gold,
    double borderWidth = 2.0,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.metallic,
        metallicType: metallicType,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: const Color(0xFFFFD54F),
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Chromatic Dispersion Rainbow Border
  factory Material4Container.rainbow({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double borderWidth = 2.0,
    double progress = 0.0,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.rainbow,
        borderProgress: progress,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: const Color(0xFFFF3B30),
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Multi-Layered Concentric Border Stack
  factory Material4Container.multiLayer({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    required List<BorderLayer> layers,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.multiLayer,
        multiLayerBorders: layers,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor:
          layers.isNotEmpty ? layers.first.color : const Color(0xFF000000),
      borderWidth: layers.isNotEmpty ? layers.first.width : 1.5,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Technical Corner Framing Brackets
  factory Material4Container.cornerOnly({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color borderColor = const Color(0xFF1E1E24),
    double borderWidth = 2.0,
    double cornerLength = 24.0,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.cornerOnly,
        cornerBorderLength: cornerLength,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Artisanal Hand-Drawn Sketchy Border
  factory Material4Container.handDrawn({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color borderColor = const Color(0xFF1E1E24),
    double borderWidth = 1.5,
    double roughness = 1.6,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.handDrawn,
        handDrawnRoughness: roughness,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Folder Tab Container (e.g. Marks Entry)
  factory Material4Container.folderTab({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    ShapePattern pattern = ShapePattern.none,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    ShapeAnchor anchor = ShapeAnchor.topRight,
    double cornerRadius = 22.0,
    double tabWidth = 72.0,
    double tabHeight = 16.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.folderTab(
        anchor: anchor,
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        tabWidth: tabWidth,
        tabHeight: tabHeight,
        pattern: pattern,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Inward Notched Container (e.g. Today's Timetable with docked badge)
  factory Material4Container.notchedBadge({
    Key? key,
    Widget? child,
    Widget? dockedBadge,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    ShapeAnchor anchor = ShapeAnchor.topRight,
    double cornerRadius = 24.0,
    double notchWidth = 92.0,
    double notchHeight = 26.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.notchedBadge(
        anchor: anchor,
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        notchWidth: notchWidth,
        notchHeight: notchHeight,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      dockedBadge: dockedBadge,
      badgeAlignment: anchor == ShapeAnchor.topRight
          ? Alignment.topRight
          : (anchor == ShapeAnchor.bottomRight
              ? Alignment.bottomRight
              : Alignment.topLeft),
      child: child,
    );
  }

  /// Factory for Side Tab / Protruding Bubble Container (e.g. Notice Board)
  factory Material4Container.sideTab({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double protrusionDepth = 16.0,
    double tabHeight = 44.0,
    double cornerRadius = 22.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.sideTab(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        tabWidth: protrusionDepth,
        tabHeight: tabHeight,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Stepped Corner Container (e.g. Take Attendance or Daily Register)
  factory Material4Container.steppedCorner({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    ShapeAnchor anchor = ShapeAnchor.bottomRight,
    double stepWidth = 48.0,
    double stepHeight = 42.0,
    double cornerRadius = 22.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.steppedCorner(
        anchor: anchor,
        borderStyle: borderStyle,
        stepWidth: stepWidth,
        stepHeight: stepHeight,
        cornerRadius: cornerRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Ticket Scallop Container (e.g. Pending Marks)
  factory Material4Container.ticket({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    ShapePattern pattern = ShapePattern.none,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double cornerRadius = 22.0,
    double scallopRadius = 10.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.ticketScallop(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        scallopRadius: scallopRadius,
        pattern: pattern,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Postage Stamp with serrated perforated border
  factory Material4Container.postageStamp({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double cornerRadius = 18.0,
    double scallopRadius = 6.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.postageStamp(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        scallopRadius: scallopRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Zigzag Receipt cut container (great for vouchers, payment tokens)
  factory Material4Container.zigzagReceipt({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.dashed,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double toothWidth = 14.0,
    double toothHeight = 8.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.zigzagCut(
        borderStyle: borderStyle,
        toothWidth: toothWidth,
        toothHeight: toothHeight,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Cathedral Arch / Dome Top Container
  factory Material4Container.arch({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double cornerRadius = 24.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.arch(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Soft Hexagon Badge Container
  factory Material4Container.hexagon({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double cornerRadius = 14.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.hexagonSoft(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Diagonal Chamfer Ribbon Corner Container
  factory Material4Container.chamferDiagonal({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    ShapeAnchor anchor = ShapeAnchor.topRight,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double chamferSize = 36.0,
    double cornerRadius = 20.0,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.chamferDiagonal(
        anchor: anchor,
        borderStyle: borderStyle,
        chamferSize: chamferSize,
        cornerRadius: cornerRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Organic Asymmetric Fluid Blob Container
  factory Material4Container.organicBlob({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.organicBlob(borderStyle: borderStyle),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Scalloped Petal / Flower (e.g. Profile Avatar)
  factory Material4Container.scallopedPetal({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    int petalCount = 10,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.scallopedPetal(
        borderStyle: borderStyle,
        petalCount: petalCount,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Neo-Brutalist 3D Hard Offset Shadow Container
  factory Material4Container.neo3d({
    Key? key,
    Widget? child,
    Material4Config config = const Material4Config(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0xFF1E1E24),
    double borderWidth = 1.8,
    Offset neoOffset = const Offset(4, 4),
    Color neoColor = const Color(0xFF1E1E24),
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.neo3d,
        neoOffset: neoOffset,
        neoColor: neoColor,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Asymmetric Card Container
  factory Material4Container.asymmetricCard({
    Key? key,
    Widget? child,
    CornerRadii cornerRadii = const CornerRadii.asymmetric(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.asymmetricCard(
        cornerRadii: cornerRadii,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Capsule / Pill Container
  factory Material4Container.capsule({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.capsule(borderStyle: borderStyle),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Wave Edge Container
  factory Material4Container.waveEdge({
    Key? key,
    Widget? child,
    ShapeAnchor anchor = ShapeAnchor.bottomCenter,
    double waveCount = 3.0,
    double waveAmplitude = 10.0,
    double cornerRadius = 20.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.waveEdge(
        anchor: anchor,
        waveCount: waveCount,
        waveAmplitude: waveAmplitude,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Cloud Shape Container
  factory Material4Container.cloud({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.cloud(borderStyle: borderStyle),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Speech Bubble Container
  factory Material4Container.speechBubble({
    Key? key,
    Widget? child,
    ShapeAnchor anchor = ShapeAnchor.bottomLeft,
    double tailWidth = 18.0,
    double tailHeight = 14.0,
    double cornerRadius = 22.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.speechBubble(
        anchor: anchor,
        tailWidth: tailWidth,
        tailHeight: tailHeight,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Shield / Academic Crest Container
  factory Material4Container.shield({
    Key? key,
    Widget? child,
    double cornerRadius = 20.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.shield(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Diamond Badge Container
  factory Material4Container.diamond({
    Key? key,
    Widget? child,
    double cornerRadius = 14.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.diamond(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Regular 8-sided Octagon Container
  factory Material4Container.octagon({
    Key? key,
    Widget? child,
    double cornerRadius = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.octagon(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Wave Cut Sliced Container
  factory Material4Container.waveCut({
    Key? key,
    Widget? child,
    ShapeAnchor anchor = ShapeAnchor.bottomRight,
    double waveAmplitude = 16.0,
    double cornerRadius = 22.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.waveCut(
        anchor: anchor,
        waveAmplitude: waveAmplitude,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Concave Rounded Frame Container
  factory Material4Container.concaveRounded({
    Key? key,
    Widget? child,
    double cornerRadius = 20.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.concaveRounded(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Convex Rounded Barrel Container
  factory Material4Container.convexRounded({
    Key? key,
    Widget? child,
    double curvature = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.convexRounded(
        curvature: curvature,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Squircle (iOS super-ellipse) Container
  factory Material4Container.squircle({
    Key? key,
    Widget? child,
    double cornerRadius = 32.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.squircle(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Slanted Parallelogram Container
  factory Material4Container.parallelogram({
    Key? key,
    Widget? child,
    double skewAngle = 14.0,
    double cornerRadius = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.parallelogram(
        skewAngle: skewAngle,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Banner Ribbon Container
  factory Material4Container.ribbon({
    Key? key,
    Widget? child,
    double foldDepth = 20.0,
    double cornerRadius = 6.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.ribbon(
        foldDepth: foldDepth,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Hanging Bookmark Container
  factory Material4Container.bookmark({
    Key? key,
    Widget? child,
    double notchDepth = 22.0,
    double cornerRadius = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.bookmark(
        notchDepth: notchDepth,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Custom Bézier Geometry Container
  factory Material4Container.customBezier({
    Key? key,
    Widget? child,
    required Path Function(Size size) builder,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return Material4Container(
      key: key,
      config: Material4Config.customBezier(
        builder: builder,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveConfig =
        shape != null ? config.copyWith(type: shape) : config;

    if (animation != null) {
      return AnimatedMaterial4Container(
        key: key,
        duration: animation!.duration,
        curve: animation!.curve,
        config: effectiveConfig,
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        color: color,
        gradient: gradient,
        borderColor: borderColor,
        borderWidth: borderWidth,
        shadows: shadows,
        onTap: onTap,
        dockedBadge: dockedBadge,
        child: child,
      );
    }

    if (controller != null) {
      return AnimatedBuilder(
        animation: controller!,
        builder: (context, _) {
          return _buildRenderTree(context, controller!.currentConfig);
        },
      );
    }

    return _buildRenderTree(context, effectiveConfig);
  }

  Widget _buildRenderTree(
    BuildContext context,
    Material4Config activeConfig,
  ) {
    final hasMultiChild = children != null && children!.isNotEmpty;
    Widget rendered;

    if (hasMultiChild) {
      final multiChildren = List<Widget>.from(children!);
      if (dockedBadge != null) {
        multiChildren.add(
          ShapeChild.aligned(
            alignment: badgeAlignment,
            margin: badgePadding,
            child: dockedBadge!,
          ),
        );
      }
      rendered = Material4MultiChildRenderWidget(
        config: activeConfig,
        color: color,
        gradient: gradient,
        borderColor: borderColor,
        borderWidth: borderWidth,
        shadows: shadows,
        clipBehavior: clipBehavior,
        contentProtection: contentProtection,
        hitTestBehavior: hitTestBehavior,
        interaction: interaction ?? activeConfig.interaction,
        clipConfig: clipConfig ?? activeConfig.clipConfig,
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        padding: padding,
        alignment: alignment ?? Alignment.center,
        width: width,
        height: height,
        layoutStrategy: layoutStrategy,
        spacing: childrenSpacing,
        collisionPolicy: collisionPolicy,
        semanticLabel: semanticLabel,
        semanticHint: semanticHint,
        children: multiChildren,
      );
    } else {
      Widget content = child ?? const SizedBox.shrink();

      // If a docked badge is specified
      if (dockedBadge != null) {
        content = Stack(
          children: [
            content,
            Positioned.fill(
              child: Align(
                alignment: badgeAlignment,
                child: Padding(padding: badgePadding, child: dockedBadge!),
              ),
            ),
          ],
        );
      }

      rendered = Material4RenderWidget(
        config: activeConfig,
        color: color,
        gradient: gradient,
        borderColor: borderColor,
        borderWidth: borderWidth,
        shadows: shadows,
        clipBehavior: clipBehavior,
        contentProtection: contentProtection,
        hitTestBehavior: hitTestBehavior,
        interaction: interaction ?? activeConfig.interaction,
        clipConfig: clipConfig ?? activeConfig.clipConfig,
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        padding: padding,
        alignment: alignment,
        width: width,
        height: height,
        semanticLabel: semanticLabel,
        semanticHint: semanticHint,
        child: content,
      );
    }

    if (activeConfig.isGlassmorphic) {
      rendered = ClipPath(
        clipper: Material4Clipper(config: activeConfig),
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: activeConfig.glassBlur,
            sigmaY: activeConfig.glassBlur,
          ),
          child: rendered,
        ),
      );
    }

    if (margin != null) {
      rendered = Padding(padding: margin!, child: rendered);
    }

    return rendered;
  }
}
