import 'package:flutter/rendering.dart';

import 'shape_content_protection.dart';

/// Strategy and policy evaluator for independent background and child clipping.
///
/// Ensures custom vector contours cleanly shape backgrounds, gradients, and borders
/// without accidentally clipping or destroying readable child content.
class ShapeClippingProtection {
  const ShapeClippingProtection._();

  /// Determines whether child rendering requires hardware path clipping.
  ///
  /// In [ShapeContentMode.adaptive] (default) and [ShapeContentMode.visibleOverflow],
  /// child clipping is disabled to guarantee zero accidental cutting off of text,
  /// badges, or icons. In [ShapeContentMode.strict], child clipping is enforced.
  static bool requiresChildClipping({
    required ShapeContentProtection protection,
    required Clip clipBehavior,
  }) {
    if (clipBehavior == Clip.none) return false;
    return protection.shouldClipChild;
  }

  /// Determines whether background painting (fills, gradients, patterns)
  /// should be clipped to the shape contour.
  static bool requiresBackgroundClipping({
    required ShapeContentProtection protection,
    required Clip clipBehavior,
  }) {
    if (clipBehavior == Clip.none) return false;
    return protection.clipBackground;
  }

  /// Validates whether a child with [childRect] safely stays within [inscribedRect]
  /// without requiring hardware clipping.
  static bool isSafeWithoutClip({
    required Rect childRect,
    required Rect inscribedRect,
  }) {
    const epsilon = 0.05;
    return childRect.left >= inscribedRect.left - epsilon &&
        childRect.top >= inscribedRect.top - epsilon &&
        childRect.right <= inscribedRect.right + epsilon &&
        childRect.bottom <= inscribedRect.bottom + epsilon;
  }
}
