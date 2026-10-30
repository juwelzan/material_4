import 'package:flutter/material.dart';

import '../material_4_config.dart';
import 'custom_shape.dart';

/// Available physics and easing profiles for shape morph transitions.
enum Material4MorphType {
  /// Natural ease-in-out cubic bezier curve.
  smooth,

  /// Dynamic elastic overshoot with dampening.
  elastic,

  /// Harmonic spring bounce response.
  spring,

  /// Physical bouncing settling at target boundary.
  bounce,

  /// Fluid hydrodynamic wave-like swelling.
  fluid,

  /// Continuous harmonic rhythmic breathing.
  breathing,

  /// Heartbeat style double-pulse rhythm.
  pulsating,
}

/// Declarative multi-layer animation configuration for [Material4Container].
///
/// Coordinates shape morphing, animated borders, flowing textures, and moving patterns
/// under a single synchronized ticker engine with zero unnecessary widget rebuilds.
@immutable
class Material4ContainerAnimation {
  /// Whether automatic shape morphing is active.
  final bool shapeMorph;

  /// Target shape type to morph toward.
  final Material4Type? targetShape;

  /// Target custom shape to morph toward.
  final Material4CustomShape? targetCustomShape;

  /// Ordered sequence of shape presets to continuously loop through.
  final List<Material4Type>? shapeSequence;

  /// Morph transition physics profile.
  final Material4MorphType morphType;

  /// Duration of a single shape morph transition.
  final Duration shapeDuration;

  /// Custom easing curve overriding [morphType].
  final Curve? shapeCurve;

  /// Whether border animation (moving dash, rotating gradient, rainbow, neon pulse) is active.
  final bool borderAnimation;

  /// Animation speed multiplier for the border.
  final double borderSpeed;

  /// Whether texture animation (flowing marble, noise shift, holographic shimmer) is active.
  final bool textureAnimation;

  /// Animation speed multiplier for the texture.
  final double textureSpeed;

  /// Whether pattern animation (moving grid, flowing lines, rotating radial lines) is active.
  final bool patternAnimation;

  /// Animation speed multiplier for the pattern.
  final double patternSpeed;

  /// Whether the animation loops continuously.
  final bool repeat;

  /// Whether looping animates back and forth (A -> B -> A).
  final bool pingPong;

  /// Whether the animation starts automatically on mount.
  final bool autoPlay;

  /// Manually pause all tickers in this container (battery saver).
  final bool paused;

  const Material4ContainerAnimation({
    this.shapeMorph = false,
    this.targetShape,
    this.targetCustomShape,
    this.shapeSequence,
    this.morphType = Material4MorphType.smooth,
    this.shapeDuration = const Duration(milliseconds: 600),
    this.shapeCurve,
    this.borderAnimation = false,
    this.borderSpeed = 1.0,
    this.textureAnimation = false,
    this.textureSpeed = 1.0,
    this.patternAnimation = false,
    this.patternSpeed = 1.0,
    this.repeat = true,
    this.pingPong = true,
    this.autoPlay = true,
    this.paused = false,
  });

  /// Preset for a pure shape morphing animation.
  const Material4ContainerAnimation.morph({
    required Material4Type target,
    Material4MorphType type = Material4MorphType.smooth,
    Duration duration = const Duration(milliseconds: 600),
    bool pingPong = true,
    bool repeat = true,
  }) : this(
          shapeMorph: true,
          targetShape: target,
          morphType: type,
          shapeDuration: duration,
          pingPong: pingPong,
          repeat: repeat,
        );

  /// Preset for multi-shape sequence looping (e.g. Circle -> Squircle -> Blob -> Hexagon).
  const Material4ContainerAnimation.sequence({
    required List<Material4Type> sequence,
    Duration stepDuration = const Duration(milliseconds: 800),
    Material4MorphType type = Material4MorphType.smooth,
    bool borderAnimation = false,
  }) : this(
          shapeMorph: true,
          shapeSequence: sequence,
          morphType: type,
          shapeDuration: stepDuration,
          borderAnimation: borderAnimation,
          repeat: true,
          pingPong: false,
        );

  /// Resolves the effective [Curve] for shape morphing.
  Curve get resolvedCurve {
    if (shapeCurve != null) return shapeCurve!;
    switch (morphType) {
      case Material4MorphType.smooth:
        return Curves.easeInOutCubic;
      case Material4MorphType.elastic:
        return Curves.elasticOut;
      case Material4MorphType.spring:
        return Curves.easeOutBack;
      case Material4MorphType.bounce:
        return Curves.bounceOut;
      case Material4MorphType.fluid:
        return Curves.easeInOutSine;
      case Material4MorphType.breathing:
        return Curves.easeInOutQuad;
      case Material4MorphType.pulsating:
        return Curves.easeInOut;
    }
  }

  /// Whether any animation tier is configured to play.
  bool get animated =>
      autoPlay &&
      !paused &&
      (shapeMorph ||
          borderAnimation ||
          textureAnimation ||
          patternAnimation ||
          (shapeSequence != null && shapeSequence!.isNotEmpty));

  /// Single shape morph transition duration.
  Duration get duration => shapeDuration;

  /// Whether animation loops continuously.
  bool get loop => repeat;

  /// Whether animation loops in ping-pong reverse mode.
  bool get reverse => pingPong;

  /// Resolved curve for shape morphing.
  Curve get curve => resolvedCurve;

  /// Transition physics profile for morph calculations.
  Curve get physics => resolvedCurve;

  /// Convenience alias for [shapeSequence].
  List<Material4Type>? get sequence => shapeSequence;

  /// Convenience alias for [borderAnimation].
  bool get animateBorder => borderAnimation;

  /// Convenience alias for [textureAnimation].
  bool get animateTexture => textureAnimation;

  /// Convenience alias for [patternAnimation].
  bool get animatePattern => patternAnimation;

  Material4ContainerAnimation copyWith({
    bool? shapeMorph,
    Material4Type? targetShape,
    Material4CustomShape? targetCustomShape,
    List<Material4Type>? shapeSequence,
    Material4MorphType? morphType,
    Duration? shapeDuration,
    Curve? shapeCurve,
    bool? borderAnimation,
    double? borderSpeed,
    bool? textureAnimation,
    double? textureSpeed,
    bool? patternAnimation,
    double? patternSpeed,
    bool? repeat,
    bool? pingPong,
    bool? autoPlay,
    bool? paused,
  }) {
    return Material4ContainerAnimation(
      shapeMorph: shapeMorph ?? this.shapeMorph,
      targetShape: targetShape ?? this.targetShape,
      targetCustomShape: targetCustomShape ?? this.targetCustomShape,
      shapeSequence: shapeSequence ?? this.shapeSequence,
      morphType: morphType ?? this.morphType,
      shapeDuration: shapeDuration ?? this.shapeDuration,
      shapeCurve: shapeCurve ?? this.shapeCurve,
      borderAnimation: borderAnimation ?? this.borderAnimation,
      borderSpeed: borderSpeed ?? this.borderSpeed,
      textureAnimation: textureAnimation ?? this.textureAnimation,
      textureSpeed: textureSpeed ?? this.textureSpeed,
      patternAnimation: patternAnimation ?? this.patternAnimation,
      patternSpeed: patternSpeed ?? this.patternSpeed,
      repeat: repeat ?? this.repeat,
      pingPong: pingPong ?? this.pingPong,
      autoPlay: autoPlay ?? this.autoPlay,
      paused: paused ?? this.paused,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4ContainerAnimation &&
          runtimeType == other.runtimeType &&
          shapeMorph == other.shapeMorph &&
          targetShape == other.targetShape &&
          targetCustomShape == other.targetCustomShape &&
          morphType == other.morphType &&
          shapeDuration == other.shapeDuration &&
          borderAnimation == other.borderAnimation &&
          borderSpeed == other.borderSpeed &&
          textureAnimation == other.textureAnimation &&
          textureSpeed == other.textureSpeed &&
          patternAnimation == other.patternAnimation &&
          patternSpeed == other.patternSpeed &&
          repeat == other.repeat &&
          pingPong == other.pingPong &&
          autoPlay == other.autoPlay &&
          paused == other.paused;

  @override
  int get hashCode => Object.hash(
        shapeMorph,
        targetShape,
        targetCustomShape,
        morphType,
        shapeDuration,
        borderAnimation,
        borderSpeed,
        textureAnimation,
        textureSpeed,
        patternAnimation,
        patternSpeed,
        repeat,
        pingPong,
        autoPlay,
        paused,
      );
}

/// Programmatic motion controller for [Material4Container].
///
/// Enables developers to command real-time shape morphing, sequence playback,
/// manual scrub progress, and synchronized multi-layer pause/resume.
class Material4MorphController extends ChangeNotifier {
  Material4Type _currentShape;
  Material4Type? _targetShape;
  Material4CustomShape? _customShape;
  Material4CustomShape? _targetCustomShape;

  double _morphProgress = 0.0;
  bool _isAnimating = false;
  bool _isDisposed = false;

  Material4MorphController({
    Material4Type initialShape = Material4Type.smoothRounded,
    Material4CustomShape? initialCustomShape,
  })  : _currentShape = initialShape,
        _customShape = initialCustomShape;

  /// Current active shape type.
  Material4Type get currentShape => _currentShape;

  /// Target shape currently morphing toward.
  Material4Type? get targetShape => _targetShape;

  /// Active custom shape if defined.
  Material4CustomShape? get customShape => _customShape;

  /// Target custom shape if defined.
  Material4CustomShape? get targetCustomShape => _targetCustomShape;

  /// Effective vector shape geometry representing current interpolation progress.
  Material4CustomShape get currentCustomShape {
    final from = _customShape ?? Material4CustomShape.fromType(_currentShape);
    if ((_targetShape != null || _targetCustomShape != null) && _morphProgress > 0) {
      final to = _targetCustomShape ??
          Material4CustomShape.fromType(_targetShape ?? _currentShape);
      return Material4CustomShape.morph(
        from: from,
        to: to,
        progress: _morphProgress,
      );
    }
    return from;
  }

  /// Normalized morph interpolation value (0.0 = from shape, 1.0 = target shape).
  double get morphProgress => _morphProgress;

  /// Whether a morph transition is in flight.
  bool get isAnimating => _isAnimating;

  /// Whether this controller has been disposed.
  bool get isDisposed => _isDisposed;

  /// Commands the container to morph to [newShape].
  void morphTo(Material4Type newShape) {
    if (_isDisposed) return;
    if (_currentShape == newShape) return;
    _targetShape = newShape;
    _targetCustomShape = null;
    _morphProgress = 0.0;
    _isAnimating = true;
    notifyListeners();
  }

  /// Commands the container to morph to a [newCustomShape].
  void morphToCustom(Material4CustomShape newCustomShape) {
    if (_isDisposed) return;
    _targetCustomShape = newCustomShape;
    _morphProgress = 0.0;
    _isAnimating = true;
    notifyListeners();
  }

  /// Sets the normalized morph progress directly (useful for gesture drag/scrub).
  void setProgress(double progress) {
    if (_isDisposed) return;
    _morphProgress = progress.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Completes the morph, setting the target shape as current.
  void completeMorph() {
    if (_isDisposed) return;
    if (_targetShape != null) {
      _currentShape = _targetShape!;
      _targetShape = null;
    }
    if (_targetCustomShape != null) {
      _customShape = _targetCustomShape;
      _targetCustomShape = null;
    }
    _morphProgress = 1.0;
    _isAnimating = false;
    notifyListeners();
  }

  /// Resets morph progress back to starting shape.
  void reset() {
    if (_isDisposed) return;
    _targetShape = null;
    _targetCustomShape = null;
    _morphProgress = 0.0;
    _isAnimating = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
