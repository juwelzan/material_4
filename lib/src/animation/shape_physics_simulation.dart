import 'package:flutter/physics.dart';

/// Motion style presets for physics-driven shape motion and tactile feedback.
enum ShapePhysicsStyle {
  smooth,
  spring,
  bouncy,
  elastic,
  snappy,
  gentle,
}

/// Physics-based spring and motion simulation configuration for shape transitions.
///
/// Wraps Flutter's [SpringDescription] and [SpringSimulation] with customizable
/// mass, stiffness, damping, and initial velocity parameters.
class ShapePhysicsSimulation {
  /// The mass of the virtual object being moved. Default: `1.0`.
  final double mass;

  /// The stiffness of the spring (spring constant k). Higher values cause faster oscillations.
  final double stiffness;

  /// The damping coefficient of the spring. Higher values cause the spring to settle faster.
  final double damping;

  /// Initial velocity at the start of the simulation.
  final double initialVelocity;

  /// Target value where the spring should settle (typically `1.0`).
  final double targetValue;

  /// Computational tolerance for determining when the simulation has come to rest.
  final Tolerance tolerance;

  const ShapePhysicsSimulation({
    this.mass = 1.0,
    this.stiffness = 300.0,
    this.damping = 20.0,
    this.initialVelocity = 0.0,
    this.targetValue = 1.0,
    this.tolerance = const Tolerance(
      distance: 1e-4,
      time: 1e-4,
      velocity: 1e-3,
    ),
  })  : assert(mass > 0.0, 'Mass must be strictly positive.'),
        assert(stiffness > 0.0, 'Stiffness must be strictly positive.'),
        assert(damping >= 0.0, 'Damping must be non-negative.');

  /// Smooth, critically-damped spring with no noticeable oscillation.
  static const ShapePhysicsSimulation smooth = ShapePhysicsSimulation(
    mass: 1.0,
    stiffness: 220.0,
    damping: 30.0,
  );

  /// Standard responsive spring with slight natural bounce.
  static const ShapePhysicsSimulation spring = ShapePhysicsSimulation(
    mass: 1.0,
    stiffness: 350.0,
    damping: 18.0,
  );

  /// Expressive underdamped spring with noticeable playful bounce.
  static const ShapePhysicsSimulation bouncy = ShapePhysicsSimulation(
    mass: 1.0,
    stiffness: 400.0,
    damping: 12.0,
  );

  /// Highly resonant elastic spring with multiple settling oscillations.
  static const ShapePhysicsSimulation elastic = ShapePhysicsSimulation(
    mass: 1.2,
    stiffness: 480.0,
    damping: 9.0,
  );

  /// Ultra-fast snappy spring designed for tactile button responses.
  static const ShapePhysicsSimulation snappy = ShapePhysicsSimulation(
    mass: 0.8,
    stiffness: 550.0,
    damping: 32.0,
  );

  /// Soft, slow-settling gentle spring for ambient UI card transitions.
  static const ShapePhysicsSimulation gentle = ShapePhysicsSimulation(
    mass: 1.2,
    stiffness: 160.0,
    damping: 24.0,
  );

  /// Factory constructing a simulation matching the specified [style].
  factory ShapePhysicsSimulation.fromStyle(ShapePhysicsStyle style) {
    switch (style) {
      case ShapePhysicsStyle.smooth:
        return ShapePhysicsSimulation.smooth;
      case ShapePhysicsStyle.spring:
        return ShapePhysicsSimulation.spring;
      case ShapePhysicsStyle.bouncy:
        return ShapePhysicsSimulation.bouncy;
      case ShapePhysicsStyle.elastic:
        return ShapePhysicsSimulation.elastic;
      case ShapePhysicsStyle.snappy:
        return ShapePhysicsSimulation.snappy;
      case ShapePhysicsStyle.gentle:
        return ShapePhysicsSimulation.gentle;
    }
  }

  /// Converts this configuration to a Flutter [SpringDescription].
  SpringDescription toSpringDescription() {
    return SpringDescription(
      mass: mass,
      stiffness: stiffness,
      damping: damping,
    );
  }

  /// Creates a live [SpringSimulation] from [start] to [end] with optional [velocity].
  SpringSimulation createSimulation({
    double start = 0.0,
    double end = 1.0,
    double velocity = 0.0,
  }) {
    final effectiveVelocity = velocity != 0.0 ? velocity : initialVelocity;
    return SpringSimulation(
      toSpringDescription(),
      start,
      end,
      effectiveVelocity,
      tolerance: tolerance,
    );
  }

  /// Creates a copy of this simulation configuration with updated fields.
  ShapePhysicsSimulation copyWith({
    double? mass,
    double? stiffness,
    double? damping,
    double? initialVelocity,
    double? targetValue,
    Tolerance? tolerance,
  }) {
    return ShapePhysicsSimulation(
      mass: mass ?? this.mass,
      stiffness: stiffness ?? this.stiffness,
      damping: damping ?? this.damping,
      initialVelocity: initialVelocity ?? this.initialVelocity,
      targetValue: targetValue ?? this.targetValue,
      tolerance: tolerance ?? this.tolerance,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShapePhysicsSimulation &&
        other.mass == mass &&
        other.stiffness == stiffness &&
        other.damping == damping &&
        other.initialVelocity == initialVelocity &&
        other.targetValue == targetValue;
  }

  @override
  int get hashCode => Object.hash(
        mass,
        stiffness,
        damping,
        initialVelocity,
        targetValue,
      );

  @override
  String toString() =>
      'ShapePhysicsSimulation(mass: $mass, stiffness: $stiffness, damping: $damping, velocity: $initialVelocity)';
}
