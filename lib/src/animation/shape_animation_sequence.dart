import 'package:flutter/animation.dart';

import '../material_4_config.dart';

/// An individual step in a composable [ShapeAnimationSequence].
class ShapeAnimationStep {
  /// The target shape configuration to animate toward.
  final Material4Config targetConfig;

  /// The duration of this transition step.
  final Duration duration;

  /// The easing curve governing progression during this step.
  final Curve curve;

  /// Optional delay before starting this step.
  final Duration delay;

  const ShapeAnimationStep({
    required this.targetConfig,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeInOutCubic,
    this.delay = Duration.zero,
  });
}

/// Composable multi-step animation sequence for orchestrating chained shape transitions.
///
/// Supports sequential steps, delays, looping, and bidirectional reversal (yoyo).
class ShapeAnimationSequence {
  final List<ShapeAnimationStep> steps;

  /// Number of times to repeat this sequence (0 = infinite loop, 1 = run once).
  final int loopCount;

  /// Whether the sequence should reverse through its steps upon reaching the end.
  final bool autoReverse;

  const ShapeAnimationSequence({
    required this.steps,
    this.loopCount = 1,
    this.autoReverse = false,
  });

  /// Factory creating an empty builder for chaining steps fluidly.
  static ShapeAnimationSequenceBuilder builder({
    int loopCount = 1,
    bool autoReverse = false,
  }) {
    return ShapeAnimationSequenceBuilder(
      loopCount: loopCount,
      autoReverse: autoReverse,
    );
  }

  /// Total active duration of all steps and delays combined in one forward pass.
  Duration get totalForwardDuration {
    return steps.fold<Duration>(
      Duration.zero,
      (sum, step) => sum + step.duration + step.delay,
    );
  }
}

/// Fluid builder for constructing a [ShapeAnimationSequence].
class ShapeAnimationSequenceBuilder extends ShapeAnimationSequence {
  final List<ShapeAnimationStep> _mutableSteps = [];

  ShapeAnimationSequenceBuilder({
    super.loopCount = 1,
    super.autoReverse = false,
  }) : super(steps: const []);

  @override
  List<ShapeAnimationStep> get steps => List.unmodifiable(_mutableSteps);

  /// Appends a new animation step targeting [config].
  ShapeAnimationSequenceBuilder then({
    required Material4Config config,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubic,
    Duration delay = Duration.zero,
  }) {
    _mutableSteps.add(
      ShapeAnimationStep(
        targetConfig: config,
        duration: duration,
        curve: curve,
        delay: delay,
      ),
    );
    return this;
  }
}
