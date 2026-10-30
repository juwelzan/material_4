import 'dart:math' as math;
import 'package:flutter/animation.dart';

/// Specialized animation curves and easing functions for shape morphing,
/// elastic contour reactions, and dynamic transitions.
class ShapeCurves {
  const ShapeCurves._();

  /// Standard smooth cubic transition with subtle deceleration.
  static const Curve smooth = Curves.easeInOutCubic;

  /// Fast acceleration followed by sudden snappy settling.
  static const Curve snappy = Curves.easeOutCubic;

  /// Expressive overshoot curve that briefly expands past the target geometry before settling.
  static const Curve bounce = _ShapeBounceCurve();

  /// Spring-like oscillating curve that settles around the target geometry.
  static const Curve spring = _ShapeSpringCurve();

  /// Anticipatory curve that briefly contracts before expanding forward to target.
  static const Curve anticipateOvershoot = ShapeAnticipateOvershootCurve();

  /// Gentle deceleration ideal for subtle UI transitions and card expansion.
  static const Curve gentle = Curves.easeOutQuad;
}

class _ShapeBounceCurve extends Curve {
  const _ShapeBounceCurve();

  @override
  double transformInternal(double t) {
    if (t == 0.0 || t == 1.0) return t;
    const p = 0.35;
    return math.pow(2.0, -10.0 * t) *
            math.sin((t - p / 4.0) * (2.0 * math.pi) / p) +
        1.0;
  }
}

class _ShapeSpringCurve extends Curve {
  const _ShapeSpringCurve();

  @override
  double transformInternal(double t) {
    if (t == 0.0 || t == 1.0) return t;
    const damping = 14.0;
    const frequency = 18.0;
    return 1.0 - math.exp(-damping * t) * math.cos(frequency * t);
  }
}

/// Curve that pulls backward before shooting forward past the target value, then settling.
class ShapeAnticipateOvershootCurve extends Curve {
  final double tension;

  const ShapeAnticipateOvershootCurve([this.tension = 2.0]);

  @override
  double transformInternal(double t) {
    if (t < 0.5) {
      final double scaled = t * 2.0;
      return 0.5 * (scaled * scaled * ((tension + 1.0) * scaled - tension));
    } else {
      final double scaled = (t - 0.5) * 2.0 - 1.0;
      return 0.5 *
          (scaled * scaled * ((tension + 1.0) * scaled + tension) + 2.0);
    }
  }
}
