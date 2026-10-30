import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../material_4_config.dart';
import 'shape_animation_config.dart';
import 'shape_animation_sequence.dart';
import 'shape_geometry_interpolator.dart';
import 'shape_physics_simulation.dart';

/// Centralized animation controller for Material 4 shapes.
///
/// Coordinates shape morphing, corner radius transitions, notch animations,
/// affine transformations, physics springs, continuous pulsing, tactile press
/// responses, and multi-step animation sequences.
///
/// Ensures memory-safe lifecycle management, disposing all internal tickers
/// and respecting accessibility reduced-motion system preferences.
class ShapeAnimationController extends ChangeNotifier {
  final TickerProvider vsync;
  final bool respectReducedMotion;

  late final AnimationController _morphController;
  late final AnimationController _pulseController;
  late final AnimationController _strokeDrawController;
  late final AnimationController _pressController;

  Material4Config _currentConfig;
  Material4Config? _targetConfig;
  Material4Config? _previousConfig;
  Curve _morphCurve = Curves.easeInOutCubic;
  ShapeMorphFallback _morphFallback = ShapeMorphFallback.compatibleNormalized;

  bool _isDisposed = false;
  bool _isReversed = false;

  /// Strategy applied when morphing between incompatible topologies.
  ShapeMorphFallback get morphFallback => _morphFallback;

  /// Current shape configuration including interpolated animated parameters.
  Material4Config get currentConfig => _computeCurrentConfig();

  /// Target shape configuration currently being animated toward.
  Material4Config? get targetConfig => _targetConfig;

  /// Whether this controller has been disposed.
  bool get isDisposed => _isDisposed;

  /// Whether a shape morphing transition is currently active.
  bool get isAnimating => _morphController.isAnimating;

  /// Normalized stroke drawing progress (0.0 = nothing drawn, 1.0 = fully drawn).
  double get strokeDrawProgress => _strokeDrawController.value;

  /// Normalized pulse animation progress (0.0 to 1.0).
  double get pulseProgress => _pulseController.value;

  /// Tactile press depression factor (0.0 = unpressed, 1.0 = fully pressed).
  double get pressProgress => _pressController.value;

  /// Morphing animation value (0.0 = previous shape, 1.0 = target shape).
  double get morphProgress => _morphController.value;

  ShapeAnimationController({
    required this.vsync,
    Material4Config initialConfig = const Material4Config(),
    this.respectReducedMotion = true,
  }) : _currentConfig = initialConfig {
    _morphController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 400),
    )
      ..addListener(_onTick)
      ..addStatusListener(_onMorphStatusChanged);

    _pulseController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1400),
    )..addListener(_onTick);

    _strokeDrawController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
      value: 1.0, // Default fully drawn
    )..addListener(_onTick);

    _pressController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 120),
    )..addListener(_onTick);
  }

  void _onTick() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void _onMorphStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && _targetConfig != null) {
      _currentConfig = _targetConfig!;
    } else if (status == AnimationStatus.dismissed && _previousConfig != null) {
      _currentConfig = _previousConfig!;
    }
  }

  /// Morph smoothly from current configuration to [target].
  TickerFuture morphTo(
    Material4Config target, {
    Duration duration = const Duration(milliseconds: 450),
    Curve curve = Curves.easeInOutCubic,
    bool reducedMotion = false,
  }) {
    return animateConfig(
      target,
      duration: duration,
      curve: curve,
      reducedMotion: reducedMotion,
    );
  }

  /// Transition smoothly to a specific [Material4Type] preset.
  TickerFuture animateTo(
    Material4Type type, {
    Duration duration = const Duration(milliseconds: 450),
    Curve curve = Curves.easeInOutCubic,
    ShapeMorphFallback fallback = ShapeMorphFallback.compatibleNormalized,
    bool reducedMotion = false,
  }) {
    final target = currentConfig.copyWith(type: type);
    _morphFallback = fallback;
    return animateConfig(
      target,
      duration: duration,
      curve: curve,
      reducedMotion: reducedMotion,
    );
  }

  /// Core transition method animating to [target] with full parameter interpolation.
  TickerFuture animateConfig(
    Material4Config target, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeInOutCubic,
    ShapePhysicsSimulation? physics,
    bool reducedMotion = false,
  }) {
    if (_isDisposed) return TickerFuture.complete();

    if (reducedMotion && respectReducedMotion) {
      _currentConfig = target;
      _previousConfig = null;
      _targetConfig = null;
      _morphController.value = 1.0;
      notifyListeners();
      return TickerFuture.complete();
    }

    // Capture currently visible configuration to prevent jumps during interrupted animations
    _previousConfig = currentConfig;
    _targetConfig = target;
    _morphCurve = curve;
    _isReversed = false;

    if (_morphController.isAnimating) {
      _morphController.stop();
    }

    if (physics != null) {
      final simulation = physics.createSimulation(
        start: 0.0,
        end: 1.0,
      );
      return _morphController.animateWith(simulation);
    }

    _morphController.duration = duration;
    return _morphController.forward(from: 0.0);
  }

  /// Animate corner radii independently without full shape transition.
  TickerFuture animateCorners(
    ShapeCorners corners, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) {
    final target = currentConfig.copyWith(corners: corners);
    return animateConfig(target, duration: duration, curve: curve);
  }

  /// Animate notches independently.
  TickerFuture animateNotch(
    List<ShapeNotch> notches, {
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOutCubic,
  }) {
    final target = currentConfig.copyWith(notches: notches);
    return animateConfig(target, duration: duration, curve: curve);
  }

  /// Animate affine transformation parameters (rotation, scale, skew, origin).
  TickerFuture animateTransform(
    ShapeTransform transform, {
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeOutCubic,
  }) {
    final target = currentConfig.copyWith(transform: transform);
    return animateConfig(target, duration: duration, curve: curve);
  }

  /// Animate using physics spring simulation.
  TickerFuture animateWithPhysics(
    Material4Config target, {
    ShapePhysicsSimulation? physics,
  }) {
    return animateConfig(
      target,
      physics: physics ?? ShapePhysicsSimulation.spring,
    );
  }

  /// Reverses an active or completed morph transition back to the previous shape.
  TickerFuture reverseMorph({Duration? duration}) {
    if (_isDisposed) return TickerFuture.complete();
    if (duration != null) {
      _morphController.duration = duration;
    }
    _isReversed = true;
    return _morphController.reverse();
  }

  /// Pauses active morphing or pulsing animations.
  void pause() {
    if (_isDisposed) return;
    _morphController.stop(canceled: false);
    _pulseController.stop(canceled: false);
  }

  /// Resumes a paused animation.
  void resume() {
    if (_isDisposed) return;
    if (_isReversed) {
      _morphController.reverse();
    } else {
      _morphController.forward();
    }
  }

  /// Stops all animations immediately and leaves shape at current interpolated state.
  void stop() {
    if (_isDisposed) return;
    _morphController.stop();
    _pulseController.stop();
    _currentConfig = currentConfig;
    _previousConfig = null;
    _targetConfig = null;
  }

  /// Resets controller back to baseline initial state.
  void reset() {
    if (_isDisposed) return;
    _morphController.reset();
    _pulseController.reset();
    _strokeDrawController.value = 1.0;
    _pressController.reset();
    _previousConfig = null;
    _targetConfig = null;
    notifyListeners();
  }

  /// Executes an orchestrated multi-step [sequence].
  Future<void> runSequence(ShapeAnimationSequence sequence) async {
    if (_isDisposed || sequence.steps.isEmpty) return;

    final loops = sequence.loopCount <= 0 ? 999999 : sequence.loopCount;
    for (int l = 0; l < loops; l++) {
      if (_isDisposed) break;

      // Forward pass
      for (final step in sequence.steps) {
        if (_isDisposed) break;
        if (step.delay > Duration.zero) {
          await Future.delayed(step.delay);
        }
        if (_isDisposed) break;
        await animateConfig(
          step.targetConfig,
          duration: step.duration,
          curve: step.curve,
        );
      }

      // Reverse pass if autoReverse is enabled
      if (sequence.autoReverse && !_isDisposed) {
        for (final step in sequence.steps.reversed) {
          if (_isDisposed) break;
          await animateConfig(
            step.targetConfig,
            duration: step.duration,
            curve: step.curve,
          );
        }
      }
    }
  }

  /// Trigger interactive tactile press down with squish compression.
  void press() {
    if (_isDisposed) return;
    _pressController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOutQuad,
    );
  }

  /// Release tactile press with spring physics rebound.
  void release({SpringDescription? spring}) {
    if (_isDisposed) return;
    final effectiveSpring = spring ??
        const SpringDescription(mass: 1.0, stiffness: 400.0, damping: 18.0);

    final simulation = SpringSimulation(
      effectiveSpring,
      _pressController.value,
      0.0,
      0.0,
    );

    _pressController.animateWith(simulation);
  }

  /// Animate stroke reveal drawing around the shape contour from 0% to 100%.
  TickerFuture startStrokeDrawing({
    Duration duration = const Duration(milliseconds: 900),
    Curve curve = Curves.easeInOutCubic,
  }) {
    if (_isDisposed) return TickerFuture.complete();
    _strokeDrawController.duration = duration;
    _strokeDrawController.reset();
    return _strokeDrawController.forward();
  }

  /// Start repeating continuous pulse / ambient neon breathing animation.
  void startPulse({
    Duration duration = const Duration(milliseconds: 1600),
    bool reverse = true,
  }) {
    if (_isDisposed) return;
    _pulseController.duration = duration;
    if (reverse) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.repeat();
    }
  }

  /// Stop pulsing and reset to base rest state.
  void stopPulse() {
    if (_isDisposed) return;
    _pulseController.stop();
    _pulseController.reset();
  }

  /// Evaluate interpolated configuration during morphing or pressing.
  Material4Config _computeCurrentConfig() {
    var base = _currentConfig;

    if (_targetConfig != null && _previousConfig != null) {
      final t = _morphCurve.transform(_morphController.value.clamp(0.0, 1.0));
      base = ShapeGeometryInterpolator.lerpConfig(
          _previousConfig!, _targetConfig!, t);
    }

    // Apply tactile press squish factor
    if (_pressController.value > 0.0) {
      final squish = _pressController.value;
      base = base.copyWith(
        scaleX: base.scaleX * (1.0 - squish * 0.04),
        scaleY: base.scaleY * (1.0 - squish * 0.04),
      );
    }

    // Apply pulse glow or border progress
    if (_pulseController.isAnimating) {
      base = base.copyWith(
        borderProgress: _pulseController.value,
        neonPulseIntensity: 0.8 + _pulseController.value * 0.6,
      );
    } else if (_strokeDrawController.isAnimating ||
        _strokeDrawController.value < 1.0) {
      base = base.copyWith(
        borderProgress: _strokeDrawController.value,
      );
    }

    return base;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _morphController.stop();
    _pulseController.stop();
    _strokeDrawController.stop();
    _pressController.stop();
    _morphController.dispose();
    _pulseController.dispose();
    _strokeDrawController.dispose();
    _pressController.dispose();
    super.dispose();
  }
}
