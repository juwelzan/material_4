import 'package:flutter/material.dart';

import 'progress_shape.dart';

/// Animation timing, easing, and dynamics configuration for [Material4ProgressBar].
@immutable
class Material4ProgressAnimation {
  /// Transition duration when animating between different progress values.
  final Duration duration;

  /// Animation curve applied when value transitions to a new target.
  final Curve curve;

  /// Loop cycle duration when running in indeterminate mode.
  final Duration indeterminateDuration;

  /// Easing curve applied to indeterminate sweeps.
  final Curve indeterminateCurve;

  /// Oscillation frequency speed of wave & liquid crests in cycles per second.
  final double waveSpeed;

  /// Translation speed of diagonal stripes across the progress fill in pixels per second.
  final double stripeSpeed;

  /// Continuous rotation speed of gradient sweeps in revolutions per second.
  final double gradientRotationSpeed;

  /// Whether indeterminate, wave, liquid, and effect animations play automatically.
  final bool autoPlay;

  /// Whether cyclical animations repeat indefinitely.
  final bool repeat;

  /// Whether cyclical animations reverse direction upon reaching end bounds (ping-pong).
  final bool reverse;

  /// Global speed multiplier scaling all internal timers (default 1.0).
  final double speedMultiplier;

  /// Whether continuous vector shape morphing is enabled.
  final bool enableMorphing;

  /// Sequence of shapes to cycle through when [enableMorphing] is true.
  final List<Material4ProgressShape> morphShapes;

  /// Duration per shape interpolation step during continuous morphing.
  final Duration morphDuration;

  /// Delay between shape morphing transitions.
  final Duration morphDelay;

  /// Whether reduced motion mode is explicitly enforced.
  final bool reducedMotion;

  /// Creates a [Material4ProgressAnimation] configuration.
  const Material4ProgressAnimation({
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
    this.indeterminateDuration = const Duration(milliseconds: 1600),
    this.indeterminateCurve = Curves.easeInOutCubic,
    this.waveSpeed = 1.0,
    this.stripeSpeed = 40.0,
    this.gradientRotationSpeed = 0.5,
    this.autoPlay = true,
    this.repeat = true,
    this.reverse = false,
    this.speedMultiplier = 1.0,
    this.enableMorphing = false,
    this.morphShapes = const [],
    this.morphDuration = const Duration(milliseconds: 1200),
    this.morphDelay = const Duration(milliseconds: 400),
    this.reducedMotion = false,
  });

  /// Snappy quick-response value transition preset.
  static const Material4ProgressAnimation snappy = Material4ProgressAnimation(
    duration: Duration(milliseconds: 250),
    curve: Curves.easeOutQuad,
  );

  /// Smooth fluid value transition preset.
  static const Material4ProgressAnimation smooth = Material4ProgressAnimation(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOutCubic,
  );

  /// Gentle slow-paced transition preset.
  static const Material4ProgressAnimation gentle = Material4ProgressAnimation(
    duration: Duration(milliseconds: 800),
    curve: Curves.easeInOutSine,
  );

  /// Spring physics rebound curve preset.
  static const Material4ProgressAnimation spring = Material4ProgressAnimation(
    duration: Duration(milliseconds: 600),
    curve: Curves.elasticOut,
  );

  /// Elastic rebound value transition preset.
  static const Material4ProgressAnimation bounce = Material4ProgressAnimation(
    duration: Duration(milliseconds: 650),
    curve: Curves.easeOutBack,
  );

  /// Creates a copy of this animation configuration with modified parameters.
  Material4ProgressAnimation copyWith({
    Duration? duration,
    Curve? curve,
    Duration? indeterminateDuration,
    Curve? indeterminateCurve,
    double? waveSpeed,
    double? stripeSpeed,
    double? gradientRotationSpeed,
    bool? autoPlay,
    bool? repeat,
    bool? reverse,
    double? speedMultiplier,
    bool? enableMorphing,
    List<Material4ProgressShape>? morphShapes,
    Duration? morphDuration,
    Duration? morphDelay,
    bool? reducedMotion,
  }) {
    return Material4ProgressAnimation(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      indeterminateDuration: indeterminateDuration ?? this.indeterminateDuration,
      indeterminateCurve: indeterminateCurve ?? this.indeterminateCurve,
      waveSpeed: waveSpeed ?? this.waveSpeed,
      stripeSpeed: stripeSpeed ?? this.stripeSpeed,
      gradientRotationSpeed: gradientRotationSpeed ?? this.gradientRotationSpeed,
      autoPlay: autoPlay ?? this.autoPlay,
      repeat: repeat ?? this.repeat,
      reverse: reverse ?? this.reverse,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      enableMorphing: enableMorphing ?? this.enableMorphing,
      morphShapes: morphShapes ?? this.morphShapes,
      morphDuration: morphDuration ?? this.morphDuration,
      morphDelay: morphDelay ?? this.morphDelay,
      reducedMotion: reducedMotion ?? this.reducedMotion,
    );
  }
}
