import 'package:flutter/animation.dart';

import 'shape_animation_curves.dart';
import 'shape_physics_simulation.dart';

/// Fallback strategy applied when two shapes with incompatible path topologies
/// cannot be morphed using closed-geometry parameter interpolation.
enum ShapeMorphFallback {
  /// Renders both shapes with complementary cross-fading opacities during the transition.
  crossfade,

  /// Instantly switches the shape topology at the transition midpoint (t = 0.5).
  switchAtMidpoint,

  /// Normalizes both shapes into compatible N-segment cubic bezier paths for continuous geometric deformation.
  compatibleNormalized,
}

/// Comprehensive configuration governing shape animations, morphing transitions,
/// physics-based easing, and accessibility constraints.
class ShapeAnimationConfig {
  /// The duration of the shape transition. Default: `Duration(milliseconds: 400)`.
  final Duration duration;

  /// The easing curve governing progression over time. Default: [Curves.easeInOutCubic].
  final Curve curve;

  /// Optional physics spring simulation overriding [curve] and [duration].
  final ShapePhysicsSimulation? physics;

  /// Whether to interpolate compatible geometric contours during the transition.
  final bool enableMorphing;

  /// Strategy used when morphing between topologically incompatible shapes.
  final ShapeMorphFallback morphFallback;

  /// Whether to respect system accessibility settings for reduced motion.
  final bool respectReducedMotion;

  /// Whether the animation should automatically reverse back to the start state.
  final bool reverse;

  /// Whether the animation should loop continuously.
  final bool repeat;

  /// Optional staggered delay offset when animating grouped shape cards.
  final Duration? staggerDelay;

  const ShapeAnimationConfig({
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOutCubic,
    this.physics,
    this.enableMorphing = true,
    this.morphFallback = ShapeMorphFallback.compatibleNormalized,
    this.respectReducedMotion = true,
    this.reverse = false,
    this.repeat = false,
    this.staggerDelay,
  });

  /// Standard responsive transition preset.
  static const ShapeAnimationConfig standard = ShapeAnimationConfig();

  /// Gentle, smooth card transition preset (500ms, easeOutCubic).
  static const ShapeAnimationConfig gentle = ShapeAnimationConfig(
    duration: Duration(milliseconds: 500),
    curve: ShapeCurves.gentle,
  );

  /// Snappy tactile button transition preset (200ms, easeOutCubic).
  static const ShapeAnimationConfig snappy = ShapeAnimationConfig(
    duration: Duration(milliseconds: 200),
    curve: ShapeCurves.snappy,
  );

  /// Expressive bouncy spring preset utilizing physics simulation.
  static const ShapeAnimationConfig bouncy = ShapeAnimationConfig(
    duration: Duration(milliseconds: 550),
    curve: ShapeCurves.bounce,
    physics: ShapePhysicsSimulation.bouncy,
  );

  /// Natural spring physics preset.
  static const ShapeAnimationConfig spring = ShapeAnimationConfig(
    duration: Duration(milliseconds: 450),
    curve: ShapeCurves.spring,
    physics: ShapePhysicsSimulation.spring,
  );

  /// Immediate transition with zero duration (useful for accessibility or instant changes).
  static const ShapeAnimationConfig immediate = ShapeAnimationConfig(
    duration: Duration.zero,
    enableMorphing: false,
  );

  /// Creates a copy of this animation configuration with updated fields.
  ShapeAnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    ShapePhysicsSimulation? physics,
    bool? enableMorphing,
    ShapeMorphFallback? morphFallback,
    bool? respectReducedMotion,
    bool? reverse,
    bool? repeat,
    Duration? staggerDelay,
  }) {
    return ShapeAnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      physics: physics ?? this.physics,
      enableMorphing: enableMorphing ?? this.enableMorphing,
      morphFallback: morphFallback ?? this.morphFallback,
      respectReducedMotion: respectReducedMotion ?? this.respectReducedMotion,
      reverse: reverse ?? this.reverse,
      repeat: repeat ?? this.repeat,
      staggerDelay: staggerDelay ?? this.staggerDelay,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShapeAnimationConfig &&
        other.duration == duration &&
        other.curve == curve &&
        other.physics == physics &&
        other.enableMorphing == enableMorphing &&
        other.morphFallback == morphFallback &&
        other.respectReducedMotion == respectReducedMotion &&
        other.reverse == reverse &&
        other.repeat == repeat &&
        other.staggerDelay == staggerDelay;
  }

  @override
  int get hashCode => Object.hash(
        duration,
        curve,
        physics,
        enableMorphing,
        morphFallback,
        respectReducedMotion,
        reverse,
        repeat,
        staggerDelay,
      );

  @override
  String toString() =>
      'ShapeAnimationConfig(duration: ${duration.inMilliseconds}ms, curve: $curve, morphing: $enableMorphing, physics: $physics)';
}

