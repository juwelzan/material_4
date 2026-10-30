import 'package:flutter/rendering.dart';

import '../config/shape_transform.dart';

/// Interaction and hit-testing behavior modes for dynamic shapes.
enum ShapeHitTestBehavior {
  /// Hit-testing follows the exact mathematical vector contour of the dynamic shape.
  ///
  /// Points outside the rendered shape geometry (e.g. In the transparent corners of an arch,
  /// diamond, or polygon) are not intercepted, allowing underlying gestures to trigger.
  shapeContour,

  /// Hit-testing evaluates the entire rectangular bounding box of the RenderBox,
  /// matching standard Flutter rectangular container interaction.
  boundingBox,
}

/// Helper utilities for shape-aware interaction and hit-testing.
class DynamicShapeHitTester {
  const DynamicShapeHitTester._();

  /// Evaluates whether [position] falls inside [path] at [size], accounting for [transform].
  static bool containsPoint({
    required Path path,
    required Size size,
    required Offset position,
    required ShapeTransform transform,
    ShapeHitTestBehavior behavior = ShapeHitTestBehavior.shapeContour,
  }) {
    if (size.width <= 0 || size.height <= 0) return false;

    // First check rectangular bounding box
    final rect = Offset.zero & size;
    if (!rect.contains(position)) return false;

    if (behavior == ShapeHitTestBehavior.boundingBox) {
      return true;
    }

    // Invert transformation matrix to test in local shape coordinates
    final localPoint = transform.hasTransform
        ? transform.transformPointForHitTest(position, size)
        : position;

    return path.contains(localPoint);
  }
}
