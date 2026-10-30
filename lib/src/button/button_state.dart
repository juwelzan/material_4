/// Discrete interaction and lifecycle states for [Material4Button].
enum Material4ButtonState {
  /// Default resting state when no user interaction or async operation is active.
  idle,

  /// Pointer cursor is currently hovering within the button bounds (Desktop/Web).
  hovered,

  /// Pointer is currently held down or keyboard activation key is depressed.
  pressed,

  /// Button currently holds hardware keyboard or accessibility focus.
  focused,

  /// Asynchronous action is in progress; displays a loading indicator without layout shifts.
  loading,

  /// Temporary positive confirmation state displaying success feedback.
  success,

  /// Temporary failure notification state displaying error feedback.
  error,

  /// Button is non-interactive; visual contrast is lowered and events are ignored.
  disabled,
}
