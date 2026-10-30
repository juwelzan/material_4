import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';

import 'avatar_shape.dart';

/// Delegate interface implemented by avatar widget state to receive controller commands.
abstract class AvatarControllerHost {
  /// Starts or resumes sequence animation.
  void play();

  /// Pauses active animation in-place without resetting progress.
  void pause();

  /// Stops and resets animation to initial shape.
  void stop();

  /// Transitions forward to the next shape in sequence.
  void nextShape();

  /// Transitions backward to the previous shape in sequence.
  void previousShape();

  /// Jumps immediately to a specific index in the shape sequence.
  void jumpTo(int index);

  /// Smoothly morphs from current shape directly to [targetShape].
  void animateTo(
    Material4AvatarShape targetShape, {
    Duration? duration,
    Curve? curve,
  });
}

/// Programmatic animation controller for [Material4Avatar].
///
/// Enables external control over shape morphing, sequence playback, manual
/// step transitions, pausing, and target shape interpolation.
class Material4AvatarController extends ChangeNotifier {
  AvatarControllerHost? _host;

  bool _isPlaying = false;
  int _currentIndex = 0;
  double _morphProgress = 0.0;
  Material4AvatarShape _currentShape = Material4AvatarShape.circle();

  /// Whether shape morphing sequence is actively running.
  bool get isPlaying => _isPlaying;

  /// Index of the currently active or originating shape in the sequence.
  int get currentIndex => _currentIndex;

  /// Current normalized morph progress between originating and target shape (0.0 to 1.0).
  double get morphProgress => _morphProgress;

  /// Currently rendered shape geometry (including intermediate morphed paths).
  Material4AvatarShape get currentShape => _currentShape;

  /// Attaches an avatar host to this controller. Internal use only.
  void attach(AvatarControllerHost host) {
    _host = host;
  }

  /// Detaches an avatar host from this controller upon widget disposal.
  void detach(AvatarControllerHost host) {
    if (_host == host) {
      _host = null;
    }
  }

  /// Starts or resumes shape sequence morphing.
  void play() {
    _isPlaying = true;
    _host?.play();
    notifyListeners();
  }

  /// Alias for [play].
  void forward() => play();

  /// Pauses sequence morphing at the current interpolation progress.
  void pause() {
    _isPlaying = false;
    _host?.pause();
    notifyListeners();
  }

  /// Resumes sequence morphing from paused state.
  void resume() => play();

  /// Stops sequence morphing and resets to the starting shape.
  void stop() {
    _isPlaying = false;
    _morphProgress = 0.0;
    _host?.stop();
    notifyListeners();
  }

  /// Resets controller state.
  void reset() => stop();

  /// Advances immediately to the next shape in sequence.
  void nextShape() {
    _host?.nextShape();
  }

  /// Reverts to the previous shape in sequence.
  void previousShape() {
    _host?.previousShape();
  }

  /// Jumps directly to the shape at [index] in the sequence without animation.
  void jumpTo(int index) {
    _currentIndex = index;
    _morphProgress = 0.0;
    _host?.jumpTo(index);
    notifyListeners();
  }

  /// Smoothly morphs from the current shape to [targetShape].
  void animateTo(
    Material4AvatarShape targetShape, {
    Duration? duration,
    Curve? curve,
  }) {
    _host?.animateTo(targetShape, duration: duration, curve: curve);
  }

  /// Internal callback updating status from the host widget state.
  void updateState({
    required bool isPlaying,
    required int currentIndex,
    required double morphProgress,
    required Material4AvatarShape currentShape,
  }) {
    _isPlaying = isPlaying;
    _currentIndex = currentIndex;
    _morphProgress = morphProgress;
    _currentShape = currentShape;
    notifyListeners();
  }
}

