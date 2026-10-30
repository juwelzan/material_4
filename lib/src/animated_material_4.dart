import 'package:flutter/material.dart';

import 'material_4_config.dart';
import 'material_4_container.dart';

/// Implicitly animated wrapper around [Material4Container].
/// Automatically interpolates corner radii, tab dimensions, colors, and shadows
/// with smooth fluid transitions when state changes.

/// Type alias for [AnimatedMaterial4Container].
typedef AnimatedMaterial4 = AnimatedMaterial4Container;

class AnimatedMaterial4Container extends ImplicitlyAnimatedWidget {
  final Widget? child;
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
  final Widget? dockedBadge;

  const AnimatedMaterial4Container({
    super.key,
    super.curve = Curves.easeOutCubic,
    super.duration = const Duration(milliseconds: 300),
    required this.config,
    this.child,
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
    this.dockedBadge,
  });

  @override
  AnimatedWidgetBaseState<AnimatedMaterial4Container> createState() =>
      _AnimatedMaterial4ContainerState();
}

class _AnimatedMaterial4ContainerState
    extends AnimatedWidgetBaseState<AnimatedMaterial4Container> {
  Material4ConfigTween? _configTween;
  Tween<double>? _widthTween;
  Tween<double>? _heightTween;
  EdgeInsetsGeometryTween? _paddingTween;
  EdgeInsetsGeometryTween? _marginTween;
  Tween<double>? _borderWidthTween;
  ColorTween? _colorTween;
  ColorTween? _borderColorTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _configTween = visitor(
      _configTween,
      widget.config,
      (dynamic value) => Material4ConfigTween(begin: value as Material4Config),
    ) as Material4ConfigTween?;

    _widthTween = visitor(
      _widthTween,
      widget.width,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;

    _heightTween = visitor(
      _heightTween,
      widget.height,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;

    _paddingTween = visitor(
      _paddingTween,
      widget.padding,
      (dynamic value) =>
          EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry?),
    ) as EdgeInsetsGeometryTween?;

    _marginTween = visitor(
      _marginTween,
      widget.margin,
      (dynamic value) =>
          EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry?),
    ) as EdgeInsetsGeometryTween?;

    _borderWidthTween = visitor(
      _borderWidthTween,
      widget.borderWidth,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _colorTween = visitor(
      _colorTween,
      widget.color ?? Colors.transparent,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;

    _borderColorTween = visitor(
      _borderColorTween,
      widget.borderColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    final bool disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations == true;

    final animatedConfig = disableAnimations
        ? widget.config
        : (_configTween?.evaluate(animation) ?? widget.config);

    return Material4Container(
      config: animatedConfig,
      width: _widthTween?.evaluate(animation) ?? widget.width,
      height: _heightTween?.evaluate(animation) ?? widget.height,
      padding: _paddingTween?.evaluate(animation) ?? widget.padding,
      margin: _marginTween?.evaluate(animation) ?? widget.margin,
      color: _colorTween?.evaluate(animation) ?? widget.color,
      gradient: widget.gradient,
      borderColor: _borderColorTween?.evaluate(animation) ?? widget.borderColor,
      borderWidth: _borderWidthTween?.evaluate(animation) ?? widget.borderWidth,
      shadows: widget.shadows,
      onTap: widget.onTap,
      dockedBadge: widget.dockedBadge,
      child: widget.child,
    );
  }
}

/// Specialized [Tween] for interpolating [Material4Config] instances.
class Material4ConfigTween extends Tween<Material4Config> {
  Material4ConfigTween({super.begin, super.end});

  @override
  Material4Config lerp(double t) {
    if (begin == null && end == null) return const Material4Config();
    if (begin == null) return end!;
    if (end == null) return begin!;
    return Material4Config.lerp(begin!, end!, t);
  }
}
