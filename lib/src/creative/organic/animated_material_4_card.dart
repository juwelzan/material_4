import 'package:flutter/material.dart';

import 'card_material_type.dart';
import 'material_4_card.dart';
import 'material_4_card_border.dart';
import 'organic_card_shape.dart';

/// An implicitly animated organic card that smoothly interpolates between
/// shapes, corner radii, concave notches, convex bulges, borders, and colors.
class AnimatedMaterial4Card extends ImplicitlyAnimatedWidget {
  /// Target organic shape geometry to morph towards.
  final Material4CardShape shape;

  /// Target background color.
  final Color backgroundColor;

  /// Target physical material finish.
  final CardMaterialType material;

  /// Target border configuration.
  final Material4CardBorder border;

  /// Box shadows.
  final List<BoxShadow> shadows;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// External margin.
  final EdgeInsetsGeometry? margin;

  /// Explicit width.
  final double? width;

  /// Explicit height.
  final double? height;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Child widget.
  final Widget? child;

  const AnimatedMaterial4Card({
    super.key,
    required this.shape,
    this.backgroundColor = const Color(0xFFDDBCFB),
    this.material = CardMaterialType.softPastel,
    this.border = const Material4CardBorder.thin(),
    this.shadows = const [
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.child,
    super.duration = const Duration(milliseconds: 350),
    super.curve = Curves.easeInOutCubic,
    super.onEnd,
  });

  @override
  AnimatedWidgetBaseState<AnimatedMaterial4Card> createState() =>
      _AnimatedMaterial4CardState();
}

class _AnimatedMaterial4CardState
    extends AnimatedWidgetBaseState<AnimatedMaterial4Card> {
  _Material4CardShapeTween? _shapeTween;
  ColorTween? _colorTween;
  _Material4CardBorderTween? _borderTween;
  EdgeInsetsGeometryTween? _paddingTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _shapeTween = visitor(
      _shapeTween,
      widget.shape,
      (dynamic value) =>
          _Material4CardShapeTween(begin: value as Material4CardShape),
    ) as _Material4CardShapeTween?;

    _colorTween = visitor(
      _colorTween,
      widget.backgroundColor,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;

    _borderTween = visitor(
      _borderTween,
      widget.border,
      (dynamic value) =>
          _Material4CardBorderTween(begin: value as Material4CardBorder),
    ) as _Material4CardBorderTween?;

    _paddingTween = visitor(
      _paddingTween,
      widget.padding,
      (dynamic value) =>
          EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry),
    ) as EdgeInsetsGeometryTween?;
  }

  @override
  Widget build(BuildContext context) {
    final currentShape = _shapeTween?.evaluate(animation) ?? widget.shape;
    final currentColor =
        _colorTween?.evaluate(animation) ?? widget.backgroundColor;
    final currentBorder = _borderTween?.evaluate(animation) ?? widget.border;
    final currentPadding = _paddingTween?.evaluate(animation) ?? widget.padding;

    return Material4Card(
      shape: currentShape,
      backgroundColor: currentColor,
      material: widget.material,
      border: currentBorder,
      shadows: widget.shadows,
      padding: currentPadding,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      onTap: widget.onTap,
      child: widget.child,
    );
  }
}

class _Material4CardShapeTween extends Tween<Material4CardShape> {
  _Material4CardShapeTween({super.begin});

  @override
  Material4CardShape lerp(double t) {
    if (begin == null) return end!;
    if (end == null) return begin!;
    return Material4CardShape.lerp(begin!, end!, t);
  }
}

class _Material4CardBorderTween extends Tween<Material4CardBorder> {
  _Material4CardBorderTween({super.begin});

  @override
  Material4CardBorder lerp(double t) {
    if (begin == null) return end!;
    if (end == null) return begin!;
    return Material4CardBorder.lerp(begin!, end!, t);
  }
}
