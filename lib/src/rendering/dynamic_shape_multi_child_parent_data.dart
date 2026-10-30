import 'package:flutter/rendering.dart';

import '../dynamic_shape_config.dart';
import '../layout/shape_collision_detector.dart';

/// ParentData for children of [RenderMultiChildDynamicShape].
///
/// Holds the local positioning offset, alignment metadata, priority,
/// margin/padding, collision policies, and layout constraints for multi-child shapes.
class DynamicShapeMultiChildParentData
    extends ContainerBoxParentData<RenderBox> {
  /// Optional target alignment within the safe content region.
  AlignmentGeometry? alignment;

  /// Optional shape landmark anchor for anchor-based placement.
  ShapeAnchor? anchor;

  /// Priority of this child (higher priority children are measured & placed first).
  int priority = 0;

  /// Margin surrounding this child.
  EdgeInsets margin = EdgeInsets.zero;

  /// Inner padding for this child.
  EdgeInsets padding = EdgeInsets.zero;

  /// Minimum width constraint override.
  double? minWidth;

  /// Maximum width constraint override.
  double? maxWidth;

  /// Minimum height constraint override.
  double? minHeight;

  /// Maximum height constraint override.
  double? maxHeight;

  /// Whether this specific child is permitted to overflow outside safe shape bounds.
  bool allowOverflow = false;

  /// Collision handling policy when overlapping other sibling children.
  ShapeCollisionPolicy collisionPolicy = ShapeCollisionPolicy.reposition;

  /// Stacking z-index for rendering order.
  int zIndex = 0;

  /// Optional clipping override for this specific child.
  bool? clipOverride;

  @override
  String toString() =>
      '${super.toString()}; alignment=$alignment; anchor=$anchor; priority=$priority; margin=$margin; policy=$collisionPolicy';
}
