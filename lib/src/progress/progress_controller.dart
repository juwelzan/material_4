import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';

import 'progress_shape.dart';

/// Delegate host interface implemented by [Material4ProgressBar] state.
abstract class ProgressControllerHost {
  /// Smoothly animates progress from current position to [targetValue].
  void animateTo(double targetValue, {Duration? duration, Curve? curve});

  /// Immediately sets progress to [targetValue] without animation.
  void jumpTo(double targetValue);

  /// Toggles between determinate and indeterminate progress modes.
  void setIndeterminate(bool indeterminate);

  /// Starts or resumes active animations.
  void play();

  /// Pauses active animations in-place.
  void pause();

  /// Stops animations and resets progress to starting threshold.
  void stop();

  /// Smoothly morphs current track/fill geometry towards [targetShape].
  void morphTo(
    Material4ProgressShape targetShape, {
    Duration? duration,
    Curve? curve,
  });
}

/// Programmatic controller for external control over [Material4ProgressBar].
///
/// Enables external value mutations, smooth interruptible transitions,
/// indeterminate mode switching, playback pausing, and shape morphing.
class Material4ProgressController extends ChangeNotifier {
  ProgressControllerHost? _host;

  double? _value;
  bool _isPlaying = true;
  Material4ProgressShape? _currentShape;

  /// Creates a [Material4ProgressController] with an optional initial [value].
  Material4ProgressController({double? initialValue}) : _value = initialValue;

  /// Current progress value (0.0 to 1.0) or null if running in indeterminate mode.
  double? get value => _value;

  /// Whether the progress bar is running in indeterminate mode.
  bool get isIndeterminate => _value == null;

  /// Whether active cyclical animations (wave, shimmer, indeterminate) are playing.
  bool get isPlaying => _isPlaying;

  /// Current vector shape geometry.
  Material4ProgressShape? get currentShape => _currentShape;

  /// Attaches a progress bar host widget. Internal use only.
  void attach(ProgressControllerHost host) {
    _host = host;
  }

  /// Detaches a progress bar host upon widget disposal.
  void detach(ProgressControllerHost host) {
    if (_host == host) {
      _host = null;
    }
  }

  /// Smoothly transitions progress from current value to [targetValue].
  void animateTo(double targetValue, {Duration? duration, Curve? curve}) {
    _value = targetValue.clamp(0.0, 1.0);
    _host?.animateTo(targetValue, duration: duration, curve: curve);
    notifyListeners();
  }

  /// Immediately jumps progress to [targetValue] without animated tweening.
  void jumpTo(double targetValue) {
    _value = targetValue.clamp(0.0, 1.0);
    _host?.jumpTo(targetValue);
    notifyListeners();
  }

  /// Switches progress bar to continuous indeterminate mode.
  void setIndeterminate(bool indeterminate) {
    if (indeterminate) {
      _value = null;
    } else {
      _value ??= 0.0;
    }
    _host?.setIndeterminate(indeterminate);
    notifyListeners();
  }

  /// Resumes or starts active cyclical animations.
  void play() {
    _isPlaying = true;
    _host?.play();
    notifyListeners();
  }

  /// Pauses active cyclical animations in-place without resetting progress.
  void pause() {
    _isPlaying = false;
    _host?.pause();
    notifyListeners();
  }

  /// Alias for [play].
  void resume() => play();

  /// Stops active animations and resets progress to zero.
  void stop() {
    _isPlaying = false;
    _value = 0.0;
    _host?.stop();
    notifyListeners();
  }

  /// Resets progress to initial zero state.
  void reset() => stop();

  /// Smoothly morphs the progress bar's geometry towards [targetShape].
  void morphTo(
    Material4ProgressShape targetShape, {
    Duration? duration,
    Curve? curve,
  }) {
    _currentShape = targetShape;
    _host?.morphTo(targetShape, duration: duration, curve: curve);
    notifyListeners();
  }

  /// Internal notification of current value update from host.
  void updateValueFromHost(double? newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}
