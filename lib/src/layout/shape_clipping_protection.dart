import 'package:flutter/rendering.dart';

import 'shape_content_protection.dart';

/// Strategy evaluator for clipping protection inside dynamic shapes.
class ShapeClippingProtection {
  const ShapeClippingProtection._();

  /// Determines whether clipping should be actively enforced for [protection].
  static bool requiresClipping({
    required ShapeContentProtection protection,
    required Clip clipBehavior,
  }) {
    if (clipBehavior == Clip.none) return false;
    return protection.shouldClipChild;
  }

  /// Validates whether a child with [childRect] safely stays within [inscribedRect]
  /// without causing visual clip artifacts.
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

