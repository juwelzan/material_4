import 'package:flutter/rendering.dart';

import '../dynamic_shape_config.dart';
import '../layout/shape_content_protection.dart';

/// Coordinates clipping operations between background and child content.
class DynamicShapeClipManager {
  const DynamicShapeClipManager._();

  /// Determines whether child rendering requires path clipping.
  static bool shouldClipChild({
    required ShapeContentProtection protection,
    required DynamicShapeConfig config,
    required Clip clipBehavior,
  }) {
    if (clipBehavior == Clip.none) return false;
    return protection.shouldClipChild;
  }

  /// Pushes a clipped painting layer onto [context] if clipping is requested.
  static void paintWithClip({
    required PaintingContext context,
    required Offset offset,
    required Rect bounds,
    required Path clipPath,
    required Clip clipBehavior,
    required PaintingContextCallback painter,
  }) {
    if (clipBehavior == Clip.none) {
      painter(context, offset);
      return;
    }

    final effectivePath = clipPath.shift(offset);
    context.pushClipPath(
      true, // needsCompositing
      offset,
      bounds.shift(offset),
      effectivePath,
      painter,
      clipBehavior: clipBehavior,
    );
  }
}
