import 'package:flutter/material.dart';

import 'dynamic_shape_config.dart';
import 'dynamic_shape_container.dart';

/// Implicitly animated wrapper around [DynamicShapeContainer].
/// Automatically interpolates corner radii, tab dimensions, colors, and shadows
/// with smooth fluid transitions when state changes.
class AnimatedDynamicShapeContainer extends ImplicitlyAnimatedWidget {
  final Widget? child;
  final DynamicShapeConfig config;
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

  const AnimatedDynamicShapeContainer({
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
  AnimatedWidgetBaseState<AnimatedDynamicShapeContainer> createState() =>
      _AnimatedDynamicShapeContainerState();
}

class _AnimatedDynamicShapeContainerState
    extends AnimatedWidgetBaseState<AnimatedDynamicShapeContainer> {
  DynamicShapeConfigTween? _configTween;
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
      (dynamic value) =>
          DynamicShapeConfigTween(begin: value as DynamicShapeConfig),
    ) as DynamicShapeConfigTween?;

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

    return DynamicShapeContainer(
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

/// Specialized [Tween] for interpolating [DynamicShapeConfig] instances.
class DynamicShapeConfigTween extends Tween<DynamicShapeConfig> {
  DynamicShapeConfigTween({super.begin, super.end});

  @override
  DynamicShapeConfig lerp(double t) {
    if (begin == null && end == null) return const DynamicShapeConfig();
    if (begin == null) return end!;
    if (end == null) return begin!;
    return DynamicShapeConfig.lerp(begin!, end!, t);
  }
}
