import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'animated_material_4.dart';
import 'animation/shape_animation_config.dart';
import 'animation/shape_animation_controller.dart';
import 'material_4_config.dart';
import 'material_4_path_builder.dart';
import 'container/container.dart';
import 'liquid_glass/widgets/containers/glass_container.dart';
import 'material_4_stack.dart';
import 'layout/shape_collision_detector.dart';
import 'layout/shape_content_protection.dart';
import 'rendering/material_4_hit_test.dart';
import 'rendering/material_4_interaction.dart';
import 'rendering/material_4_multi_child_render_widget.dart';
import 'rendering/material_4_painter.dart';
import 'rendering/material_4_render_widget.dart';

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

/// Type alias for [Material4Container].
typedef Material4ShapeContainer = Material4Container;

/// The single, universal Material 4 shape container.
///
/// One widget renders every container in the system — there is no separate
/// widget or named constructor per shape. You choose geometry, surface, and
/// outline through three orthogonal inputs:
///
/// 1. **Shape** — pick a built-in preset with [shape] (any [Material4Type]),
///    or supply your own geometry with [customShape] (a [Material4CustomShape]
///    built from a polygon, star, superellipse, independent corners, a raw
///    [Path] via `.bezier`, or the fluent [Material4ShapeBuilder]). When both
///    are given, [customShape] wins. Fine-grained parameters live on [config].
/// 2. **Background** — a unified [background] ([Material4Background]) describing
///    the fill color, gradient, procedural effect, texture, pattern, inner
///    shadows, and glassmorphism in one object.
/// 3. **Border** — a shape-following [border] ([Material4Border]) that tracks
///    the exact contour (even while morphing) and supports every
///    [BorderStyleType], from a crisp solid hairline to animated gradient,
///    neon, rope-twist, railroad, and bead-chain strokes.
///
/// The scalar [color], [gradient], [borderColor], and [borderWidth] arguments
/// remain as lightweight shortcuts for simple cases; whenever [background] or
/// [border] is supplied it takes precedence as the primary styling path.
///
/// ```dart
/// // Built-in preset shape + rich animated border.
/// Material4Container(
///   shape: Material4Type.hexagonSoft,
///   background: const Material4Background(color: Color(0xFF0F172A)),
///   border: const Material4Border.segmentedGlow(),
///   child: const Text('Hello'),
/// );
///
/// // Fully custom developer-supplied geometry.
/// Material4Container(
///   customShape: Material4CustomShape.polygon(sides: 5, cornerRadius: 12),
///   border: const Material4Border.ropeTwist(),
/// );
/// ```
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

  /// Next-Gen Universal Custom Shape Builder with fluent geometry API.
  final Material4CustomShape? customShape;

  /// Unified multi-layer background (solid color, gradient, pattern, texture, effects).
  final Material4Background? background;

  /// Next-Gen universal shape-following animated border.
  final Material4Border? border;

  /// Synchronized multi-layer animation configuration.
  final Material4ContainerAnimation? containerAnimation;

  /// Programmatic morph controller for dynamic shape transitions and sequences.
  final Material4MorphController? morphController;

  /// Optional real liquid-glass surface (refraction, blur, specular rim,
  /// chromatic aberration) clipped to this container's shape.
  final Material4LiquidGlass? liquidGlass;

  const Material4Container({
    super.key,
    this.config = const Material4Config(),
    this.shape,
    this.animation,
    this.controller,
    this.customShape,
    this.background,
    this.border,
    this.containerAnimation,
    this.morphController,
    this.liquidGlass,
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
    this.customShape,
    this.background,
    this.border,
    this.containerAnimation,
    this.morphController,
    this.liquidGlass,
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

  /// Factory constructor that configures the container directly from a [Material4ContainerPreset].
  factory Material4Container.fromPreset({
    Key? key,
    required Material4ContainerPreset preset,
    Widget? child,
    List<Widget>? children,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    Clip clipBehavior = Clip.antiAlias,
    String? semanticLabel,
  }) {
    return Material4Container(
      key: key,
      config: preset.config,
      customShape: preset.customShape,
      background: preset.background,
      border: preset.border,
      containerAnimation: preset.animation,
      color: preset.background.color,
      gradient: preset.background.gradient,
      shadows: preset.background.shadows,
      borderColor: preset.border.color ?? const Color(0x1F1A1A1A),
      borderWidth: preset.border.width,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      clipBehavior: clipBehavior,
      semanticLabel: semanticLabel,
      child: child,
      children: children,
    );
  }

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

  @override
  Widget build(BuildContext context) {
    var effectiveConfig = shape != null ? config.copyWith(type: shape) : config;

    if (customShape != null) {
      effectiveConfig = effectiveConfig.copyWith(customShape: customShape);
    }

    if (morphController != null) {
      return AnimatedBuilder(
        animation: morphController!,
        builder: (context, _) {
          final activeShape = morphController!.currentCustomShape;
          final morphedConfig = effectiveConfig.copyWith(
            customShape: activeShape,
            borderProgress: morphController!.morphProgress,
          );
          return _buildRenderTree(
            context,
            morphedConfig,
            activeBackground: background,
            activeBorder: border,
          );
        },
      );
    }

    if (containerAnimation != null && containerAnimation!.animated) {
      return _Material4CoordinatedAnimationContainer(
        animation: containerAnimation!,
        config: effectiveConfig,
        customShape: customShape,
        background: background,
        border: border,
        liquidGlass: liquidGlass,
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
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        clipBehavior: clipBehavior,
        contentProtection: contentProtection,
        hitTestBehavior: hitTestBehavior,
        interaction: interaction,
        clipConfig: clipConfig,
        alignment: alignment,
        dockedBadge: dockedBadge,
        badgeAlignment: badgeAlignment,
        badgePadding: badgePadding,
        semanticLabel: semanticLabel,
        semanticHint: semanticHint,
        child: child,
      );
    }

    if (animation != null) {
      Widget animated = AnimatedMaterial4Container(
        key: key,
        duration: animation!.duration,
        curve: animation!.curve,
        config: effectiveConfig,
        width: width,
        height: height,
        padding: padding,
        margin: liquidGlass == null ? margin : null,
        color: color,
        gradient: gradient,
        borderColor: borderColor,
        borderWidth: borderWidth,
        shadows: shadows,
        onTap: onTap,
        dockedBadge: dockedBadge,
        child: child,
      );
      if (liquidGlass != null) {
        animated =
            wrapMaterial4LiquidGlass(animated, effectiveConfig, liquidGlass);
        if (margin != null) {
          animated = Padding(padding: margin!, child: animated);
        }
      }
      return animated;
    }

    if (controller != null) {
      return AnimatedBuilder(
        animation: controller!,
        builder: (context, _) {
          return _buildRenderTree(
            context,
            controller!.currentConfig,
            activeBackground: background,
            activeBorder: border,
          );
        },
      );
    }

    return _buildRenderTree(
      context,
      effectiveConfig,
      activeBackground: background,
      activeBorder: border,
    );
  }

  Widget _buildRenderTree(
    BuildContext context,
    Material4Config activeConfig, {
    Material4Background? activeBackground,
    Material4Border? activeBorder,
  }) {
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
        background: activeBackground,
        border: activeBorder,
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

    rendered = wrapMaterial4LiquidGlass(rendered, activeConfig, liquidGlass);

    if (margin != null) {
      rendered = Padding(padding: margin!, child: rendered);
    }

    return rendered;
  }
}

/// Places a liquid-glass surface behind [content], clipped to the shape that
/// [config] describes. Returns [content] unchanged when [glass] is null.
Widget wrapMaterial4LiquidGlass(
  Widget content,
  Material4Config config,
  Material4LiquidGlass? glass,
) {
  if (glass == null) return content;
  return ClipPath(
    clipper: Material4Clipper(config: config),
    clipBehavior: Clip.antiAlias,
    child: GlassContainer(
      shape: glass.resolveShape(config.cornerRadius),
      settings: glass.settings,
      quality: glass.quality,
      color: glass.color,
      glowIntensity: glass.glowIntensity,
      useOwnLayer: glass.useOwnLayer,
      allowElevation: glass.allowElevation,
      platformViewBackdrop: glass.platformViewBackdrop,
      child: content,
    ),
  );
}

class _Material4CoordinatedAnimationContainer extends StatefulWidget {
  final Material4ContainerAnimation animation;
  final Material4Config config;
  final Material4CustomShape? customShape;
  final Material4Background? background;
  final Material4Border? border;
  final Material4LiquidGlass? liquidGlass;
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
  final ShapeContentProtection contentProtection;
  final ShapeHitTestBehavior hitTestBehavior;
  final Material4Interaction? interaction;
  final ShapeClipConfig? clipConfig;
  final AlignmentGeometry? alignment;
  final Widget? dockedBadge;
  final Alignment badgeAlignment;
  final EdgeInsets badgePadding;
  final String? semanticLabel;
  final String? semanticHint;
  final Widget? child;

  const _Material4CoordinatedAnimationContainer({
    required this.animation,
    required this.config,
    this.customShape,
    this.background,
    this.border,
    this.liquidGlass,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderColor = const Color(0x1F1A1A1A),
    this.borderWidth = 1.0,
    this.shadows,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.clipBehavior = Clip.antiAlias,
    this.contentProtection = const ShapeContentProtection(),
    this.hitTestBehavior = ShapeHitTestBehavior.shapeContour,
    this.interaction,
    this.clipConfig,
    this.alignment,
    this.dockedBadge,
    this.badgeAlignment = Alignment.topRight,
    this.badgePadding = EdgeInsets.zero,
    this.semanticLabel,
    this.semanticHint,
    this.child,
  });

  @override
  State<_Material4CoordinatedAnimationContainer> createState() =>
      _Material4CoordinatedAnimationContainerState();
}

class _Material4CoordinatedAnimationContainerState
    extends State<_Material4CoordinatedAnimationContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: widget.animation.duration,
    );
    if (widget.animation.loop) {
      if (widget.animation.reverse) {
        _animController.repeat(reverse: true);
      } else {
        _animController.repeat();
      }
    } else {
      _animController.forward();
    }
  }

  @override
  void didUpdateWidget(
      covariant _Material4CoordinatedAnimationContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation.duration != widget.animation.duration) {
      _animController.duration = widget.animation.duration;
    }
    if (oldWidget.animation.loop != widget.animation.loop ||
        oldWidget.animation.reverse != widget.animation.reverse) {
      _animController.reset();
      if (widget.animation.loop) {
        if (widget.animation.reverse) {
          _animController.repeat(reverse: true);
        } else {
          _animController.repeat();
        }
      } else {
        _animController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final disableAnimations = mediaQuery?.disableAnimations ?? false;

    if (disableAnimations) {
      final staticConfig =
          widget.config.copyWith(customShape: widget.customShape);
      Widget still = Material4RenderWidget(
        config: staticConfig,
        color: widget.color,
        gradient: widget.gradient,
        borderColor: widget.borderColor,
        borderWidth: widget.borderWidth,
        shadows: widget.shadows,
        clipBehavior: widget.clipBehavior,
        contentProtection: widget.contentProtection,
        hitTestBehavior: widget.hitTestBehavior,
        interaction: widget.interaction,
        clipConfig: widget.clipConfig,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onDoubleTap: widget.onDoubleTap,
        padding: widget.padding,
        alignment: widget.alignment,
        width: widget.width,
        height: widget.height,
        semanticLabel: widget.semanticLabel,
        semanticHint: widget.semanticHint,
        background: widget.background,
        border: widget.border,
        child: widget.child,
      );
      still = wrapMaterial4LiquidGlass(still, staticConfig, widget.liquidGlass);
      if (widget.margin != null) {
        still = Padding(padding: widget.margin!, child: still);
      }
      return still;
    }

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, staticChild) {
        final progress =
            widget.animation.curve.transform(_animController.value);
        final anim = widget.animation;

        // Driven shape morphing
        Material4CustomShape? activeShape = widget.customShape;
        if (anim.sequence != null && anim.sequence!.isNotEmpty) {
          final total = anim.sequence!.length;
          final stepProgress = (progress * total) % total;
          final idx = stepProgress.floor();
          final localT = stepProgress - idx;
          final fromShape = anim.sequence![idx];
          final toShape = anim.sequence![(idx + 1) % total];
          activeShape = Material4CustomShape.morph(
            from: fromShape,
            to: toShape,
            progress: localT,
            physics: anim.physics,
          );
        } else if (anim.shapeMorph &&
            (anim.targetShape != null || anim.targetCustomShape != null)) {
          final fromShape = widget.customShape ?? widget.config.type;
          final toShape = anim.targetCustomShape ?? anim.targetShape!;
          activeShape = Material4CustomShape.morph(
            from: fromShape,
            to: toShape,
            progress: progress,
            physics: anim.physics,
          );
        }

        // Driven border
        Material4Border? activeBorder = widget.border;
        if (anim.animateBorder && activeBorder != null) {
          activeBorder = activeBorder.copyWith(
            progress: (progress * anim.borderSpeed) % 1.0,
          );
        }

        // Driven pattern
        Material4Pattern? activePattern = widget.background?.pattern;
        if (anim.animatePattern && activePattern != null) {
          activePattern = activePattern.copyWith(
            progress: (progress * anim.patternSpeed) % 1.0,
          );
        }

        // Driven texture
        Material4Texture? activeTexture = widget.background?.texture;
        if (anim.animateTexture && activeTexture != null) {
          activeTexture = activeTexture.copyWith(
            progress: (progress * anim.textureSpeed) % 1.0,
          );
        }

        Material4Background? activeBackground = widget.background;
        if (activePattern != null || activeTexture != null) {
          activeBackground =
              (activeBackground ?? const Material4Background()).copyWith(
            pattern: activePattern,
            texture: activeTexture,
          );
        }

        final activeConfig = widget.config.copyWith(
          customShape: activeShape,
          borderProgress: progress,
          backgroundProgress: progress,
        );

        Widget rendered = Material4RenderWidget(
          config: activeConfig,
          color: widget.color,
          gradient: widget.gradient,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
          shadows: widget.shadows,
          clipBehavior: widget.clipBehavior,
          contentProtection: widget.contentProtection,
          hitTestBehavior: widget.hitTestBehavior,
          interaction: widget.interaction,
          clipConfig: widget.clipConfig,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onDoubleTap: widget.onDoubleTap,
          padding: widget.padding,
          alignment: widget.alignment,
          width: widget.width,
          height: widget.height,
          semanticLabel: widget.semanticLabel,
          semanticHint: widget.semanticHint,
          background: activeBackground,
          border: activeBorder,
          child: staticChild,
        );

        if (activeConfig.isGlassmorphic) {
          rendered = ClipPath(
            clipper: Material4Clipper(config: activeConfig),
            clipBehavior: widget.clipBehavior,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: activeConfig.glassBlur,
                sigmaY: activeConfig.glassBlur,
              ),
              child: rendered,
            ),
          );
        }

        rendered = wrapMaterial4LiquidGlass(
            rendered, activeConfig, widget.liquidGlass);

        if (widget.margin != null) {
          rendered = Padding(padding: widget.margin!, child: rendered);
        }

        return rendered;
      },
      child: widget.child,
    );
  }
}
