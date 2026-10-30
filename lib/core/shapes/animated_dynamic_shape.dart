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
  Tween<double>? _cornerRadiusTween;
  Tween<double>? _tabWidthTween;
  Tween<double>? _tabHeightTween;
  Tween<double>? _borderWidthTween;
  Tween<double>? _rotationTween;
  Tween<double>? _scaleXTween;
  Tween<double>? _scaleYTween;
  ColorTween? _colorTween;
  ColorTween? _borderColorTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _cornerRadiusTween = visitor(
      _cornerRadiusTween,
      widget.config.cornerRadius,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _tabWidthTween = visitor(
      _tabWidthTween,
      widget.config.tabWidth,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _tabHeightTween = visitor(
      _tabHeightTween,
      widget.config.tabHeight,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _borderWidthTween = visitor(
      _borderWidthTween,
      widget.borderWidth,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _rotationTween = visitor(
      _rotationTween,
      widget.config.rotation,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _scaleXTween = visitor(
      _scaleXTween,
      widget.config.scaleX,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _scaleYTween = visitor(
      _scaleYTween,
      widget.config.scaleY,
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
    final animatedConfig = widget.config.copyWith(
      cornerRadius:
          _cornerRadiusTween?.evaluate(animation) ?? widget.config.cornerRadius,
      tabWidth: _tabWidthTween?.evaluate(animation) ?? widget.config.tabWidth,
      tabHeight:
          _tabHeightTween?.evaluate(animation) ?? widget.config.tabHeight,
      rotation: _rotationTween?.evaluate(animation) ?? widget.config.rotation,
      scaleX: _scaleXTween?.evaluate(animation) ?? widget.config.scaleX,
      scaleY: _scaleYTween?.evaluate(animation) ?? widget.config.scaleY,
      rotation: _rotationTween?.evaluate(animation) ?? widget.config.rotation,
      scaleX: _scaleXTween?.evaluate(animation) ?? widget.config.scaleX,
      scaleY: _scaleYTween?.evaluate(animation) ?? widget.config.scaleY,
    );
    );

    return DynamicShapeContainer(
      config: animatedConfig,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
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
