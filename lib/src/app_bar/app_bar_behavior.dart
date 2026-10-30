import 'package:flutter/foundation.dart';

/// Enumeration of states representing the operational lifecycle of a
/// [Material4AppBar] or [Material4SliverAppBar].
enum AppBarScrollState {
  /// Header is fully expanded at or near the top of the scrollable.
  expanded,

  /// Header is actively transitioning back towards expanded state.
  expanding,

  /// Header is actively transitioning between expanded and collapsed states.
  collapsing,

  /// Header has reached its minimum height and is pinned or active.
  collapsed,

  /// Compact header is floating above content in response to reverse scrolling.
  floating,

  /// Header is actively animating off-screen downwards.
  hiding,

  /// Compact header is fully hidden off-screen during downward scroll.
  hidden,

  /// Header is actively animating into view on reverse scroll.
  revealing,
}

/// Configuration class defining the scroll physics, transition thresholds,
/// reverse scroll detection, and hysteresis of a [Material4AppBar].
@immutable
class Material4AppBarBehavior {
  /// Whether the app bar collapses into a compact header when scrolling down.
  final bool collapseOnScroll;

  /// Whether the compact app bar smoothly floats into view when the user
  /// reverses scroll direction (scrolls up) after being scrolled down.
  final bool floatingOnReverseScroll;

  /// Whether the compact app bar completely hides off-screen when the user
  /// continues scrolling down past the collapsed height.
  final bool hideOnScrollDown;

  /// Whether the app bar expands back to its full height when reaching the top.
  final bool expandOnScrollUp;

  /// Scroll distance (in logical pixels) from the top before the header begins collapsing.
  final double collapseThreshold;

  /// Minimum reverse-scroll distance (in logical pixels) required to trigger the
  /// floating compact header. Acts as hysteresis to prevent jitter/flicker.
  final double reverseScrollThreshold;

  /// Minimum scroll velocity (in logical pixels per second) to immediately trigger
  /// the floating compact header even on micro-swipes.
  final double fastScrollVelocityThreshold;

  /// Whether the app bar should automatically pin itself at the top once collapsed.
  final bool pinned;

  /// Whether the header snaps to the nearest stable state (fully expanded or compact).
  final bool snap;

  /// Resistance factor dampening collapse motion near top boundaries. Default 1.0 (linear).
  final double collapseResistance;

  /// Direction hysteresis threshold (in logical px/s) preventing scroll flip on micro-vibrations.
  final double velocityHysteresis;

  /// Momentum tracking damping factor (0.0 to 1.0) for exponential velocity smoothing.
  final double momentumDamping;

  /// Creates a [Material4AppBarBehavior] instance.
  const Material4AppBarBehavior({
    this.collapseOnScroll = true,
    this.floatingOnReverseScroll = true,
    this.hideOnScrollDown = false,
    this.expandOnScrollUp = true,
    this.collapseThreshold = 120.0,
    this.reverseScrollThreshold = 14.0,
    this.fastScrollVelocityThreshold = 650.0,
    this.pinned = true,
    this.snap = false,
    this.collapseResistance = 1.0,
    this.velocityHysteresis = 15.0,
    this.momentumDamping = 0.85,
  });

  /// Standard pinned behavior where the header collapses smoothly and remains pinned.
  static const Material4AppBarBehavior pinnedAlways = Material4AppBarBehavior(
    collapseOnScroll: true,
    floatingOnReverseScroll: false,
    hideOnScrollDown: false,
    expandOnScrollUp: true,
    pinned: true,
  );

  /// Flagship intelligent behavior: collapses on scroll down, reveals a floating
  /// compact header with drawer and profile on reverse scroll, and expands at top.
  static const Material4AppBarBehavior floatingOnReverse =
      Material4AppBarBehavior(
    collapseOnScroll: true,
    floatingOnReverseScroll: true,
    hideOnScrollDown: false,
    expandOnScrollUp: true,
    pinned: true,
    reverseScrollThreshold: 14.0,
  );

  /// Immersive behavior: hides completely on downward scroll, reveals on upward scroll.
  static const Material4AppBarBehavior hideAndFloat = Material4AppBarBehavior(
    collapseOnScroll: true,
    floatingOnReverseScroll: true,
    hideOnScrollDown: true,
    expandOnScrollUp: true,
    pinned: false,
    reverseScrollThreshold: 16.0,
  );

  /// Static non-collapsing app bar behavior.
  static const Material4AppBarBehavior staticFixed = Material4AppBarBehavior(
    collapseOnScroll: false,
    floatingOnReverseScroll: false,
    hideOnScrollDown: false,
    expandOnScrollUp: false,
    pinned: true,
  );

  /// Creates a copy of this behavior configuration with the given fields replaced.
  Material4AppBarBehavior copyWith({
    bool? collapseOnScroll,
    bool? floatingOnReverseScroll,
    bool? hideOnScrollDown,
    bool? expandOnScrollUp,
    double? collapseThreshold,
    double? reverseScrollThreshold,
    double? fastScrollVelocityThreshold,
    bool? pinned,
    bool? snap,
    double? collapseResistance,
    double? velocityHysteresis,
    double? momentumDamping,
  }) {
    return Material4AppBarBehavior(
      collapseOnScroll: collapseOnScroll ?? this.collapseOnScroll,
      floatingOnReverseScroll:
          floatingOnReverseScroll ?? this.floatingOnReverseScroll,
      hideOnScrollDown: hideOnScrollDown ?? this.hideOnScrollDown,
      expandOnScrollUp: expandOnScrollUp ?? this.expandOnScrollUp,
      collapseThreshold: collapseThreshold ?? this.collapseThreshold,
      reverseScrollThreshold:
          reverseScrollThreshold ?? this.reverseScrollThreshold,
      fastScrollVelocityThreshold:
          fastScrollVelocityThreshold ?? this.fastScrollVelocityThreshold,
      pinned: pinned ?? this.pinned,
      snap: snap ?? this.snap,
      collapseResistance: collapseResistance ?? this.collapseResistance,
      velocityHysteresis: velocityHysteresis ?? this.velocityHysteresis,
      momentumDamping: momentumDamping ?? this.momentumDamping,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material4AppBarBehavior &&
        other.collapseOnScroll == collapseOnScroll &&
        other.floatingOnReverseScroll == floatingOnReverseScroll &&
        other.hideOnScrollDown == hideOnScrollDown &&
        other.expandOnScrollUp == expandOnScrollUp &&
        other.collapseThreshold == collapseThreshold &&
        other.reverseScrollThreshold == reverseScrollThreshold &&
        other.fastScrollVelocityThreshold == fastScrollVelocityThreshold &&
        other.pinned == pinned &&
        other.snap == snap &&
        other.collapseResistance == collapseResistance &&
        other.velocityHysteresis == velocityHysteresis &&
        other.momentumDamping == momentumDamping;
  }

  @override
  int get hashCode => Object.hash(
        collapseOnScroll,
        floatingOnReverseScroll,
        hideOnScrollDown,
        expandOnScrollUp,
        collapseThreshold,
        reverseScrollThreshold,
        fastScrollVelocityThreshold,
        pinned,
        snap,
        collapseResistance,
        velocityHysteresis,
        momentumDamping,
      );
}
