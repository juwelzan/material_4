import 'dart:async';
import 'package:flutter/material.dart';

import '../container/custom_shape.dart';
import '../material_4_config.dart';
import 'button_state.dart';

/// Programmatic motion and lifecycle controller for [Material4Button].
///
/// Enables developers to command loading, success feedback, error alerts,
/// enabled/disabled states, simulated presses, and shape morphing from outside the widget.
class Material4ButtonController extends ChangeNotifier {
  Material4ButtonState _state;
  Material4Type? _activeShape;
  Material4CustomShape? _activeCustomShape;
  bool _isDisposed = false;
  Timer? _feedbackTimer;

  Material4ButtonController({
    Material4ButtonState initialState = Material4ButtonState.idle,
    Material4Type? initialShape,
    Material4CustomShape? initialCustomShape,
  })  : _state = initialState,
        _activeShape = initialShape,
        _activeCustomShape = initialCustomShape;

  /// Current lifecycle and interaction state of the button.
  Material4ButtonState get state => _state;

  /// Whether the button is actively performing an asynchronous operation.
  bool get isLoading => _state == Material4ButtonState.loading;

  /// Whether the button is in positive success feedback mode.
  bool get isSuccess => _state == Material4ButtonState.success;

  /// Whether the button is in negative error feedback mode.
  bool get isError => _state == Material4ButtonState.error;

  /// Whether the button accepts user taps and interactions.
  bool get isEnabled => _state != Material4ButtonState.disabled;

  /// Active programmatic shape type override.
  Material4Type? get activeShape => _activeShape;

  /// Active programmatic custom shape override.
  Material4CustomShape? get activeCustomShape => _activeCustomShape;

  /// Whether this controller has been disposed.
  bool get isDisposed => _isDisposed;

  /// Transitions the button into [Material4ButtonState.loading].
  void startLoading() {
    if (_isDisposed || _state == Material4ButtonState.loading) return;
    _feedbackTimer?.cancel();
    _state = Material4ButtonState.loading;
    notifyListeners();
  }

  /// Concludes loading and restores the button to [Material4ButtonState.idle].
  void stopLoading() {
    if (_isDisposed || _state != Material4ButtonState.loading) return;
    _state = Material4ButtonState.idle;
    notifyListeners();
  }

  String? _feedbackMessage;

  /// Custom transient message associated with [showSuccess] or [showError].
  String? get feedbackMessage => _feedbackMessage;

  /// Transitions the button into [Material4ButtonState.success] for [duration],
  /// then automatically returns to [Material4ButtonState.idle].
  void showSuccess({String? message, Duration duration = const Duration(seconds: 2)}) {
    if (_isDisposed) return;
    _feedbackTimer?.cancel();
    _feedbackMessage = message;
    _state = Material4ButtonState.success;
    notifyListeners();

    _feedbackTimer = Timer(duration, () {
      if (!_isDisposed && _state == Material4ButtonState.success) {
        _feedbackMessage = null;
        _state = Material4ButtonState.idle;
        notifyListeners();
      }
    });
  }

  /// Transitions the button into [Material4ButtonState.error] for [duration],
  /// then automatically returns to [Material4ButtonState.idle].
  void showError({String? message, Duration duration = const Duration(seconds: 2)}) {
    if (_isDisposed) return;
    _feedbackTimer?.cancel();
    _feedbackMessage = message;
    _state = Material4ButtonState.error;
    notifyListeners();

    _feedbackTimer = Timer(duration, () {
      if (!_isDisposed && _state == Material4ButtonState.error) {
        _feedbackMessage = null;
        _state = Material4ButtonState.idle;
        notifyListeners();
      }
    });
  }

  /// Enables the button.
  void enable() {
    if (_isDisposed || _state != Material4ButtonState.disabled) return;
    _feedbackTimer?.cancel();
    _state = Material4ButtonState.idle;
    notifyListeners();
  }

  /// Disables the button, preventing further interactions.
  void disable() {
    if (_isDisposed || _state == Material4ButtonState.disabled) return;
    _feedbackTimer?.cancel();
    _state = Material4ButtonState.disabled;
    notifyListeners();
  }

  /// Simulates a pointer press down.
  void press() {
    if (_isDisposed || !isEnabled || _state == Material4ButtonState.pressed) return;
    _state = Material4ButtonState.pressed;
    notifyListeners();
  }

  /// Simulates releasing a pointer press.
  void release() {
    if (_isDisposed || _state != Material4ButtonState.pressed) return;
    _state = Material4ButtonState.idle;
    notifyListeners();
  }

  /// Commands the button to morph to [targetShape].
  void morphTo(Material4Type targetShape) {
    if (_isDisposed) return;
    _activeShape = targetShape;
    _activeCustomShape = null;
    notifyListeners();
  }

  /// Commands the button to morph to [targetCustomShape].
  void morphToCustom(Material4CustomShape targetCustomShape) {
    if (_isDisposed) return;
    _activeCustomShape = targetCustomShape;
    notifyListeners();
  }

  /// Resets the button back to [Material4ButtonState.idle] and clears feedback timers.
  void reset() {
    if (_isDisposed) return;
    _feedbackTimer?.cancel();
    _state = Material4ButtonState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _feedbackTimer?.cancel();
    super.dispose();
  }
}
