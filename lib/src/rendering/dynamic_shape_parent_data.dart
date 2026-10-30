import 'package:flutter/rendering.dart';

/// ParentData for children of [RenderDynamicShape].
///
/// Holds the local positioning offset and layout metadata within
/// the shape's coordinate frame.
class DynamicShapeParentData extends BoxParentData {
  /// Whether this child represents a docked badge or secondary accessory.
  bool isDocked = false;

  /// Optional alignment within the safe content region.
  Alignment? alignment;

  @override
  String toString() =>
      '${super.toString()}; isDocked=$isDocked; alignment=$alignment';
}
