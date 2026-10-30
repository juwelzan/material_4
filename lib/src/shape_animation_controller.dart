import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'dynamic_shape_config.dart';

/// Specialized controller for coordinating advanced shape morphing, spring physics,
/// stroke drawing, liquid animations, and tactile press effects.
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

  DynamicShapeConfig _currentConfig;
  DynamicShapeConfig? _targetConfig;
  DynamicShapeConfig? _previousConfig;
  Curve _morphCurve = Curves.easeInOutCubic;

  bool _isDisposed = false;

  /// Current shape configuration including interpolated animated parameters.
  DynamicShapeConfig get currentConfig => _computeCurrentConfig();

  /// Whether this controller has been disposed.
  bool get isDisposed => _isDisposed;

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
    DynamicShapeConfig initialConfig = const DynamicShapeConfig(),
    this.respectReducedMotion = true,
  }) : _currentConfig = initialConfig {
    _morphController =
        AnimationController(
            vsync: vsync,
            duration: const Duration(milliseconds: 400),
          )
          ..addListener(_onTick)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && _targetConfig != null) {
              _currentConfig = _targetConfig!;
              _previousConfig = null;
              _targetConfig = null;
            }
          });

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

  /// Morph smoothly from the current configuration to [target].
  TickerFuture morphTo(
    DynamicShapeConfig target, {
    Duration duration = const Duration(milliseconds: 450),
    Curve curve = Curves.easeInOutCubic,
    bool reducedMotion = false,
  }) {
    if (_isDisposed) return TickerFuture.complete();

    if (reducedMotion && respectReducedMotion) {
      _currentConfig = target;
      _previousConfig = null;
      _targetConfig = null;
      notifyListeners();
      return TickerFuture.complete();
    }

    _previousConfig = currentConfig;
    _targetConfig = target;
    _morphCurve = curve;
    _morphController.duration = duration;

    return _morphController.forward(from: 0.0);
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
    final effectiveSpring =
        spring ??
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
  DynamicShapeConfig _computeCurrentConfig() {
    var base = _currentConfig;

    if (_targetConfig != null && _previousConfig != null) {
      final t = _morphCurve.transform(_morphController.value);
      base = _interpolateConfigs(_previousConfig!, _targetConfig!, t);
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
    }

    return base;
  }

  static DynamicShapeConfig _interpolateConfigs(
    DynamicShapeConfig a,
    DynamicShapeConfig b,
    double t,
  ) {
    // When t crosses 0.5, switch categorical presets (type, borderStyle, pattern, anchor)
    final dominant = t < 0.5 ? a : b;

    return dominant.copyWith(
      cornerRadius: _lerpDouble(a.cornerRadius, b.cornerRadius, t),
      tabWidth: _lerpDouble(a.tabWidth, b.tabWidth, t),
      tabHeight: _lerpDouble(a.tabHeight, b.tabHeight, t),
      filletRadius: _lerpDouble(a.filletRadius, b.filletRadius, t),
      scallopRadius: _lerpDouble(a.scallopRadius, b.scallopRadius, t),
      waveAmplitude: _lerpDouble(a.waveAmplitude, b.waveAmplitude, t),
      waveCount: _lerpDouble(a.waveCount, b.waveCount, t),
      skewAngle: _lerpDouble(a.skewAngle, b.skewAngle, t),
      ribbonFoldDepth: _lerpDouble(a.ribbonFoldDepth, b.ribbonFoldDepth, t),
      rotation: _lerpDouble(a.rotation, b.rotation, t),
      scaleX: _lerpDouble(a.scaleX, b.scaleX, t),
      scaleY: _lerpDouble(a.scaleY, b.scaleY, t),
      stretchOffset:
          Offset.lerp(a.stretchOffset, b.stretchOffset, t) ?? a.stretchOffset,
      borderProgress: _lerpDouble(a.borderProgress, b.borderProgress, t),
      dashPhase: _lerpDouble(a.dashPhase, b.dashPhase, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  void dispose() {
    _isDisposed = true;
    _morphController.dispose();
    _pulseController.dispose();
    _strokeDrawController.dispose();
    _pressController.dispose();
    super.dispose();
  }
}
