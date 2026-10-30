import 'package:flutter/foundation.dart';

/// Content layout and protection modes for dynamic vector shapes.
enum ShapeContentMode {
  /// Strict mode: All child content must remain inside the shape's valid content region,
  /// with child overflow clipped with anti-aliasing.
  strict,

  /// Adaptive mode (recommended default): Automatically adjusts safe padding and layout
  /// constraints to accommodate content naturally without hard child clipping.
  adaptive,

  /// Visible overflow mode: Allows developer-authorized content (e.g. tooltips, badges,
  /// floating chips) to render outside the shape boundary without being clipped.
  visibleOverflow,
}

/// Backward compatibility alias for [ShapeContentMode].
typedef ContentProtectionMode = ShapeContentMode;

/// Configuration model governing child layout protection, safe area calculation,
/// and independent background vs child clipping.
@immutable
class ShapeContentProtection {
  /// Protection strategy governing layout and clipping.
  final ShapeContentMode mode;

  /// Whether automatic geometry-aware safe padding is dynamically applied to children.
  final bool autoPadding;

  /// Whether child content is clipped to the geometric shape contour.
  final bool clipChild;

  /// Whether shape background fills, gradients, and patterns are clipped to the shape contour.
  final bool clipBackground;

  /// Minimum accessible touch target dimension (in dp) according to Material/WCAG guidelines.
  final double minTouchTarget;

  /// Whether developer-authorized child overflow is permitted outside the shape boundary.
  final bool allowOverflow;

  /// Standard adaptive content protection (safe padding enabled, no hard child clipping).
  const ShapeContentProtection({
    this.mode = ShapeContentMode.adaptive,
    this.autoPadding = true,
    this.clipChild = false,
    this.clipBackground = true,
    this.minTouchTarget = 48.0,
    this.allowOverflow = false,
  });

  /// Strict content protection: clips children with anti-aliasing to prevent any bleed.
  const ShapeContentProtection.strict({
    this.autoPadding = true,
    this.clipChild = true,
    this.clipBackground = true,
    this.minTouchTarget = 48.0,
  })  : mode = ShapeContentMode.strict,
        allowOverflow = false;

  /// Adaptive content protection: automatically positions and insets children safely.
  const ShapeContentProtection.adaptive({
    this.autoPadding = true,
    this.clipChild = false,
    this.clipBackground = true,
    this.minTouchTarget = 48.0,
  })  : mode = ShapeContentMode.adaptive,
        allowOverflow = false;

  /// Visible overflow content protection: allows elements to extend outside the shape contour.
  const ShapeContentProtection.visibleOverflow({
    this.autoPadding = false,
    this.clipBackground = true,
    this.minTouchTarget = 48.0,
  })  : mode = ShapeContentMode.visibleOverflow,
        clipChild = false,
        allowOverflow = true;

  /// Convenience constructor creating protection from [mode].
  const ShapeContentProtection.fromMode(
    this.mode, {
    this.autoPadding = true,
    this.clipChild = false,
    this.clipBackground = true,
    this.minTouchTarget = 48.0,
  }) : allowOverflow = mode == ShapeContentMode.visibleOverflow;

  /// Whether the mode is [ShapeContentMode.strict].
  bool get isStrict => mode == ShapeContentMode.strict;

  /// Whether the mode is [ShapeContentMode.adaptive].
  bool get isAdaptive => mode == ShapeContentMode.adaptive;

  /// Whether the mode is [ShapeContentMode.visibleOverflow].
  bool get isVisibleOverflow => mode == ShapeContentMode.visibleOverflow;

  /// Evaluates whether the child subtree should be clipped to the shape path.
  bool get shouldClipChild =>
      mode == ShapeContentMode.strict ||
      (mode != ShapeContentMode.visibleOverflow && clipChild);

  /// Creates a copy with the given fields replaced.
  ShapeContentProtection copyWith({
    ShapeContentMode? mode,
    bool? autoPadding,
    bool? clipChild,
    bool? clipBackground,
    double? minTouchTarget,
    bool? allowOverflow,
  }) {
    return ShapeContentProtection(
      mode: mode ?? this.mode,
      autoPadding: autoPadding ?? this.autoPadding,
      clipChild: clipChild ?? this.clipChild,
      clipBackground: clipBackground ?? this.clipBackground,
      minTouchTarget: minTouchTarget ?? this.minTouchTarget,
      allowOverflow: allowOverflow ?? this.allowOverflow,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeContentProtection &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          autoPadding == other.autoPadding &&
          clipChild == other.clipChild &&
          clipBackground == other.clipBackground &&
          minTouchTarget == other.minTouchTarget &&
          allowOverflow == other.allowOverflow;

  @override
  int get hashCode => Object.hash(
        mode,
        autoPadding,
        clipChild,
        clipBackground,
        minTouchTarget,
        allowOverflow,
      );

  @override
  String toString() =>
      'ShapeContentProtection(mode: $mode, autoPadding: $autoPadding, clipChild: $clipChild, allowOverflow: $allowOverflow)';
}
