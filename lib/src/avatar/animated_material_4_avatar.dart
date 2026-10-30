import 'package:flutter/material.dart';

import 'avatar_badge.dart';
import 'avatar_border.dart';
import 'avatar_shape.dart';
import 'avatar_status.dart';
import 'material_4_avatar.dart';

/// Implicitly animated avatar widget that morphs shape geometry, size, border,
/// and colors smoothly whenever configuration changes.
class AnimatedMaterial4Avatar extends ImplicitlyAnimatedWidget {
  /// Diameter / dimension of the avatar.
  final double size;

  /// Shape geometry of the avatar silhouette.
  final Material4AvatarShape shape;

  /// Shape border configuration.
  final Material4AvatarBorder border;

  /// Background color fill.
  final Color? backgroundColor;

  /// Primary image provider.
  final ImageProvider? image;

  /// User initials.
  final String? initials;

  /// Fallback icon.
  final IconData? icon;

  /// Custom child widget.
  final Widget? child;

  /// Online presence status.
  final Material4AvatarStatus? status;

  /// Overlay badge.
  final Material4AvatarBadge? badge;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Long press callback.
  final VoidCallback? onLongPress;

  /// Accessible semantics label.
  final String? semanticLabel;

  const AnimatedMaterial4Avatar({
    super.key,
    required super.duration,
    super.curve = Curves.easeInOutCubic,
    super.onEnd,
    this.size = 56.0,
    required this.shape,
    this.border = const Material4AvatarBorder.none(),
    this.backgroundColor,
    this.image,
    this.initials,
    this.icon,
    this.child,
    this.status,
    this.badge,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
  });

  @override
  AnimatedWidgetBaseState<AnimatedMaterial4Avatar> createState() =>
      _AnimatedMaterial4AvatarState();
}

class _AnimatedMaterial4AvatarState
    extends AnimatedWidgetBaseState<AnimatedMaterial4Avatar> {
  Tween<double>? _sizeTween;
  _AvatarShapeTween? _shapeTween;
  _AvatarBorderTween? _borderTween;
  ColorTween? _backgroundTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _sizeTween = visitor(
      _sizeTween,
      widget.size,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _shapeTween = visitor(
      _shapeTween,
      widget.shape,
      (dynamic value) =>
          _AvatarShapeTween(begin: value as Material4AvatarShape),
    ) as _AvatarShapeTween?;

    _borderTween = visitor(
      _borderTween,
      widget.border,
      (dynamic value) =>
          _AvatarBorderTween(begin: value as Material4AvatarBorder),
    ) as _AvatarBorderTween?;

    _backgroundTween = visitor(
      _backgroundTween,
      widget.backgroundColor,
      (dynamic value) => ColorTween(begin: value as Color?),
    ) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSize = _sizeTween?.evaluate(animation) ?? widget.size;
    final effectiveShape = _shapeTween?.evaluate(animation) ?? widget.shape;
    final effectiveBorder = _borderTween?.evaluate(animation) ?? widget.border;
    final effectiveBg =
        _backgroundTween?.evaluate(animation) ?? widget.backgroundColor;

    return Material4Avatar(
      size: effectiveSize,
      shape: effectiveShape,
      border: effectiveBorder,
      backgroundColor: effectiveBg,
      image: widget.image,
      initials: widget.initials,
      icon: widget.icon,
      status: widget.status,
      badge: widget.badge,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      semanticLabel: widget.semanticLabel,
      child: widget.child,
    );
  }
}

class _AvatarShapeTween extends Tween<Material4AvatarShape> {
  _AvatarShapeTween({super.begin});

  @override
  Material4AvatarShape lerp(double t) {
    return Material4AvatarShape.lerp(begin, end, t);
  }
}

class _AvatarBorderTween extends Tween<Material4AvatarBorder> {
  _AvatarBorderTween({super.begin});

  @override
  Material4AvatarBorder lerp(double t) {
    return Material4AvatarBorder.lerp(begin, end, t);
  }
}
