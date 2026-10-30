import 'package:flutter/material.dart';

import '../material_4_config.dart';
import '../material_4_container.dart';
import 'shape_animation_config.dart';
import 'shape_geometry_interpolator.dart';

/// Animated transition widget that morphs between two Material 4 shapes.
///
/// Can operate implicitly with specified `from` and `to` presets, or explicitly
/// driven by an external [Animation<double>].
class ShapeMorphTransition extends StatefulWidget {
  /// Starting shape preset (when [fromConfig] is omitted).
  final Material4Type? from;

  /// Ending target shape preset (when [toConfig] is omitted).
  final Material4Type? to;

  /// Full starting shape configuration.
  final Material4Config? fromConfig;

  /// Full target shape configuration.
  final Material4Config? toConfig;

  /// Optional explicit progress animation (0.0 = start shape, 1.0 = target shape).
  final Animation<double>? animation;

  /// Duration of implicit transition when [animation] is omitted.
  final Duration duration;

  /// Easing curve for implicit transition.
  final Curve curve;

  /// Fallback strategy for topologically incompatible morphs.
  final ShapeMorphFallback fallback;

  /// Width of the container.
  final double? width;

  /// Height of the container.
  final double? height;

  /// Background color.
  final Color? color;

  /// Background gradient.
  final Gradient? gradient;

  /// Border color.
  final Color borderColor;

  /// Border width.
  final double borderWidth;

  /// Drop shadows.
  final List<BoxShadow>? shadows;

  /// Child widget protected inside the shape container.
  final Widget? child;

  const ShapeMorphTransition({
    super.key,
    this.from,
    this.to,
    this.fromConfig,
    this.toConfig,
    this.animation,
    this.duration = const Duration(milliseconds: 450),
    this.curve = Curves.easeInOutCubic,
    this.fallback = ShapeMorphFallback.compatibleNormalized,
    this.width,
    this.height,
    this.color,
    this.gradient,
    this.borderColor = const Color(0x1F1A1A1A),
    this.borderWidth = 1.0,
    this.shadows,
    this.child,
  })  : assert(
          from != null || fromConfig != null,
          'Either from or fromConfig must be provided.',
        ),
        assert(
          to != null || toConfig != null,
          'Either to or toConfig must be provided.',
        );

  @override
  State<ShapeMorphTransition> createState() => _ShapeMorphTransitionState();
}

class _ShapeMorphTransitionState extends State<ShapeMorphTransition>
    with SingleTickerProviderStateMixin {
  AnimationController? _internalController;

  Animation<double> get _activeAnimation =>
      widget.animation ?? _internalController!;

  Material4Config get _startConfig =>
      widget.fromConfig ?? Material4Config(type: widget.from!);

  Material4Config get _endConfig =>
      widget.toConfig ?? Material4Config(type: widget.to!);

  @override
  void initState() {
    super.initState();
    if (widget.animation == null) {
      _internalController = AnimationController(
        vsync: this,
        duration: widget.duration,
      )..forward();
    }
  }

  @override
  void didUpdateWidget(covariant ShapeMorphTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation == null && _internalController != null) {
      if (oldWidget.duration != widget.duration) {
        _internalController!.duration = widget.duration;
      }
      if (oldWidget.to != widget.to || oldWidget.toConfig != widget.toConfig) {
        _internalController!.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _activeAnimation,
      builder: (context, child) {
        final t =
            widget.curve.transform(_activeAnimation.value.clamp(0.0, 1.0));
        final morphedConfig = ShapeGeometryInterpolator.lerpConfig(
          _startConfig,
          _endConfig,
          t,
        );

        return Material4Container(
          config: morphedConfig,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          gradient: widget.gradient,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
          shadows: widget.shadows,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
