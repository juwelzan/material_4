import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'dynamic_shape_config.dart';
import 'dynamic_shape_container.dart';
import 'dynamic_shape_path_builder.dart';
import 'layout/shape_content_protection.dart';
import 'rendering/dynamic_shape_render_widget.dart';

/// Tactile pressable container that reacts to touch with realistic spring physics,
/// slight scale squish, and smooth release rebound.
class ShapePressable extends StatefulWidget {
  final Widget child;
  final DynamicShapeConfig config;
  final VoidCallback? onTap;
  final double pressScale;
  final Duration duration;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const ShapePressable({
    super.key,
    required this.child,
    this.config = const DynamicShapeConfig(),
    this.onTap,
    this.pressScale = 0.96,
    this.duration = const Duration(milliseconds: 120),
    this.color,
    this.gradient,
    this.borderColor = const Color(0x1F1A1A1A),
    this.borderWidth = 1.0,
    this.shadows,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  State<ShapePressable> createState() => _ShapePressableState();
}

class _ShapePressableState extends State<ShapePressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _releaseSpring();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _releaseSpring();
  }

  void _releaseSpring() {
    final simulation = SpringSimulation(
      const SpringDescription(mass: 1.0, stiffness: 450.0, damping: 18.0),
      _controller.value,
      0.0,
      0.0,
    );
    _controller.animateWith(simulation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: DynamicShapeContainer(
              config: widget.config,
              color: widget.color,
              gradient: widget.gradient,
              borderColor: widget.borderColor,
              borderWidth: widget.borderWidth,
              shadows: widget.shadows,
              padding: widget.padding,
              margin: widget.margin,
              width: widget.width,
              height: widget.height,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Magnetic hover widget that tilts and translates dynamically toward the mouse cursor.
class ShapeMagneticHover extends StatefulWidget {
  final Widget child;
  final double maxTilt;
  final double maxOffset;

  const ShapeMagneticHover({
    super.key,
    required this.child,
    this.maxTilt = 0.08,
    this.maxOffset = 10.0,
  });

  @override
  State<ShapeMagneticHover> createState() => _ShapeMagneticHoverState();
}

class _ShapeMagneticHoverState extends State<ShapeMagneticHover>
    with SingleTickerProviderStateMixin {
  Offset _pointerOffset = Offset.zero;
  late final AnimationController _springController;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final dx = ((event.localPosition.dx - cx) / cx).clamp(-1.0, 1.0);
    final dy = ((event.localPosition.dy - cy) / cy).clamp(-1.0, 1.0);

    setState(() {
      _pointerOffset = Offset(dx, dy);
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _pointerOffset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final tx = _pointerOffset.dx * widget.maxOffset;
        final ty = _pointerOffset.dy * widget.maxOffset;

        return MouseRegion(
          onHover: (e) => _onHover(e, size),
          onExit: _onExit,
          child: TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(begin: Offset.zero, end: Offset(tx, ty)),
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutQuad,
            builder: (context, offset, child) {
              return Transform.translate(offset: offset, child: child);
            },
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Swipe gesture container that morphs smoothly between a list of shape presets
/// as the user drags horizontally or vertically.
class ShapeSwipeMorph extends StatefulWidget {
  final List<DynamicShapeConfig> shapes;
  final Widget child;
  final double width;
  final double height;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final ValueChanged<int>? onShapeChanged;

  const ShapeSwipeMorph({
    super.key,
    required this.shapes,
    required this.child,
    this.width = 300,
    this.height = 180,
    this.color,
    this.gradient,
    this.borderColor = const Color(0x1F1A1A1A),
    this.borderWidth = 1.0,
    this.onShapeChanged,
  }) : assert(
          shapes.length >= 2,
          'At least 2 shapes required for swipe morphing',
        );

  @override
  State<ShapeSwipeMorph> createState() => _ShapeSwipeMorphState();
}

class _ShapeSwipeMorphState extends State<ShapeSwipeMorph> {
  int _currentIndex = 0;
  double _dragProgress = 0.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragProgress += details.primaryDelta! / widget.width;
      _dragProgress = _dragProgress.clamp(-1.0, 1.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      if (_dragProgress > 0.35 && _currentIndex > 0) {
        _currentIndex--;
        widget.onShapeChanged?.call(_currentIndex);
      } else if (_dragProgress < -0.35 &&
          _currentIndex < widget.shapes.length - 1) {
        _currentIndex++;
        widget.onShapeChanged?.call(_currentIndex);
      }
      _dragProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nextIndex =
        (_dragProgress < 0 ? _currentIndex + 1 : _currentIndex - 1).clamp(
      0,
      widget.shapes.length - 1,
    );

    final t = _dragProgress.abs();
    final activeConfig =
        t > 0.5 ? widget.shapes[nextIndex] : widget.shapes[_currentIndex];

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: DynamicShapeContainer(
        config: activeConfig,
        width: widget.width,
        height: widget.height,
        color: widget.color,
        gradient: widget.gradient,
        borderColor: widget.borderColor,
        borderWidth: widget.borderWidth,
        child: widget.child,
      ),
    );
  }
}

/// Animated reveal widget that unmasks a shape with an expanding iris / clip transition.
class ShapeReveal extends StatelessWidget {
  final Widget child;
  final Animation<double> progress;
  final DynamicShapeConfig config;
  final Alignment origin;

  const ShapeReveal({
    super.key,
    required this.child,
    required this.progress,
    this.config = const DynamicShapeConfig(),
    this.origin = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final t = progress.value.clamp(0.0, 1.0);
        return ClipPath(
          clipper: _ShapeRevealClipper(progress: t, origin: origin),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _ShapeRevealClipper extends CustomClipper<Path> {
  final double progress;
  final Alignment origin;

  _ShapeRevealClipper({required this.progress, required this.origin});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (progress <= 0.0) return path;
    if (progress >= 1.0) {
      path.addRect(Offset.zero & size);
      return path;
    }

    final maxDim = math.sqrt(
      size.width * size.width + size.height * size.height,
    );
    final cx = size.width * (origin.x + 1.0) / 2.0;
    final cy = size.height * (origin.y + 1.0) / 2.0;

    path.addOval(
      Rect.fromCircle(center: Offset(cx, cy), radius: maxDim * progress),
    );
    return path;
  }

  @override
  bool shouldReclip(covariant _ShapeRevealClipper oldClipper) {
    return oldClipper.progress != progress || oldClipper.origin != origin;
  }
}

/// Animated perimeter stroke drawing reveal widget.
/// Progressively draws the outline contour from 0% to 100% perimeter length.
class ShapeBorderDrawReveal extends StatelessWidget {
  final Widget child;
  final DynamicShapeConfig config;
  final double progress; // 0.0 to 1.0
  final Color borderColor;
  final double borderWidth;
  final Size size;

  const ShapeBorderDrawReveal({
    super.key,
    required this.child,
    required this.size,
    this.config = const DynamicShapeConfig(),
    this.progress = 1.0,
    this.borderColor = Colors.blue,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeRenderWidget(
      config: config.copyWith(
        borderProgress: progress.clamp(0.0, 1.0),
      ),
      borderColor: borderColor,
      borderWidth: borderWidth,
      width: size.width,
      height: size.height,
      contentProtection: const ShapeContentProtection(autoPadding: false),
      clipBehavior: Clip.none,
      child: child,
    );
  }
}

/// Legacy stroke reveal painter preserved for backward compatibility.
///
/// Use [DynamicShapeRenderWidget] or [RenderDynamicShape] directly.
@Deprecated(
  'Use DynamicShapeRenderWidget or RenderDynamicShape direct rendering instead.',
)
class StrokeRevealPainter extends CustomPainter {
  final DynamicShapeConfig config;
  final double progress;
  final Color borderColor;
  final double borderWidth;

  StrokeRevealPainter({
    required this.config,
    required this.progress,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || borderWidth <= 0) return;

    final fullPath = DynamicShapePathBuilder.buildPath(size, config);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round
      ..color = borderColor
      ..isAntiAlias = true;

    if (progress >= 1.0) {
      canvas.drawPath(fullPath, paint);
      return;
    }

    for (final metric in fullPath.computeMetrics()) {
      final extractLength = metric.length * progress;
      final subPath = metric.extractPath(0.0, extractLength);
      canvas.drawPath(subPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StrokeRevealPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.config != config ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}

/// Staggered cascade entrance container that coordinates staggered entry delays
/// for child cards with fade, slide, and scale transitions.
class ShapeStaggeredGroup extends StatelessWidget {
  final List<Widget> children;
  final Animation<double> animation;
  final double staggerDelay; // fraction per child (e.g. 0.1)

  const ShapeStaggeredGroup({
    super.key,
    required this.children,
    required this.animation,
    this.staggerDelay = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(children.length, (i) {
            final start = (i * staggerDelay).clamp(0.0, 0.8);
            final end = (start + 0.35).clamp(0.0, 1.0);
            final curved = Interval(start, end, curve: Curves.easeOutCubic);
            final t = curved.transform(animation.value);

            return Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, (1.0 - t) * 32.0),
                child: Transform.scale(
                  scale: 0.9 + t * 0.1,
                  child: children[i],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
