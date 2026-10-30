import 'package:flutter/rendering.dart';

/// ParentData for children of [RenderMaterial4].
///
/// Holds the local positioning offset, alignment metadata, and layout flags
/// within the shape's coordinate frame.
class Material4ParentData extends BoxParentData {
  /// Whether this child represents a docked badge or secondary accessory.
  bool isDocked = false;

  /// Optional alignment within the safe content region.
  AlignmentGeometry? alignment;

  /// Optional clipping override for this specific child.
  bool? clipOverride;

  @override
  String toString() =>
      '${super.toString()}; isDocked=$isDocked; alignment=$alignment; clipOverride=$clipOverride';
}
