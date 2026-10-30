import 'package:flutter/rendering.dart';

import '../dynamic_shape_config.dart';
import 'dynamic_shape_interaction.dart';

/// Interaction and hit-testing behavior modes for dynamic shapes.
enum ShapeHitTestBehavior {
  /// Hit-testing follows the exact mathematical vector contour of the dynamic shape.
  ///
  /// Points outside the rendered shape geometry (e.g. in the transparent corners of an arch,
  /// diamond, or polygon) are not intercepted, allowing underlying gestures to trigger.
  shape,

  /// Hit-testing evaluates the entire rectangular bounding box of the RenderBox,
  /// matching standard Flutter rectangular container interaction.
  rectangular,

  /// The shape receives pointer interaction throughout its rectangular bounds (including
  /// visually transparent areas) and consumes the hit event so elements behind it are blocked.
  opaque,

  /// The shape participates in hit testing within its bounds while allowing other eligible
  /// targets behind it to participate according to Flutter's normal hit-testing rules.
  translucent,

  /// The shape itself does not claim otherwise empty regions; eligible child widgets
  /// receive interaction normally.
  deferToChild;

  /// Backward-compatible alias for [shape].
  static const ShapeHitTestBehavior shapeContour = ShapeHitTestBehavior.shape;

  /// Backward-compatible alias for [rectangular].
  static const ShapeHitTestBehavior boundingBox =
      ShapeHitTestBehavior.rectangular;
}

/// Helper utilities for shape-aware interaction, hit-testing, and coordinate translation.
class DynamicShapeHitTester {
  const DynamicShapeHitTester._();

  /// Evaluates whether [position] hits the dynamic shape at [size],
  /// taking into account shape geometry, [transform], [behavior], and [interaction] settings.
  static bool containsPoint({
    required Path path,
    required Size size,
    required Offset position,
    ShapeTransform transform = ShapeTransform.identity,
    DynamicShapeConfig? config,
    ShapeHitTestBehavior behavior = ShapeHitTestBehavior.shape,
    DynamicShapeInteraction? interaction,
    bool pathIsTransformed = true,
  }) {
    // 1. Guard against non-positive dimensions, NaN, and infinite positions
    if (size.width <= 0 ||
        size.height <= 0 ||
        position.dx.isNaN ||
        position.dy.isNaN ||
        position.dx.isInfinite ||
        position.dy.isInfinite) {
      return false;
    }

    // 2. Resolve interaction configuration if provided
    final effectiveBehavior = interaction?.hitTestBehavior ?? behavior;
    if (interaction != null && !interaction.enableShapeHitTesting) {
      return false;
    }

    final containerBox = Offset.zero & size;

    // 3. DeferToChild never claims hit testing on empty shape space
    if (effectiveBehavior == ShapeHitTestBehavior.deferToChild) {
      return false;
    }

    // 4. Rectangular and Opaque modes evaluate entire container bounds
    if (effectiveBehavior == ShapeHitTestBehavior.rectangular ||
        effectiveBehavior == ShapeHitTestBehavior.opaque ||
        effectiveBehavior == ShapeHitTestBehavior.translucent) {
      return containerBox.contains(position);
    }

    // 5. Shape vector contour testing
    final Offset testPoint;
    if (!pathIsTransformed && transform.hasTransform) {
      // If path was built without transform, map position to local shape space
      final mapped = transform.tryTransformPoint(position, size, inverse: true);
      if (mapped == null) return false;
      testPoint = mapped;
    } else {
      // Path already has transform applied; test position directly (prevents double transformation)
      testPoint = position;
    }

    final bool inPath = path.contains(testPoint);
    if (inPath) return true;

    // 6. Configurable Notch Interaction:
    // If inside an inward notch cutout and notch interaction is enabled
    if (interaction?.enableNotchInteraction == true &&
        config?.notches != null &&
        config!.notches!.isNotEmpty) {
      if (isInsideInwardNotch(
        position: position,
        size: size,
        notches: config.notches!,
      )) {
        return true;
      }
    }

    // 7. Configurable Transparent Region Interaction:
    // If inside container box and transparent region interaction is enabled
    if (interaction?.enableTransparentRegionInteraction == true &&
        containerBox.contains(position)) {
      return true;
    }

    return false;
  }

  /// Verifies whether [position] falls inside any inward notch cutout on [size].
  static bool isInsideInwardNotch({
    required Offset position,
    required Size size,
    required List<ShapeNotch> notches,
  }) {
    for (final notch in notches) {
      if (!notch.isInward) continue;
      final notchRect = notch.computeNotchRect(size);
      if (notchRect.contains(position)) {
        return true;
      }
    }
    return false;
  }

  /// Verifies whether [position] falls in a visually transparent region
  /// (inside rectangular bounds but outside the vector shape path).
  static bool isInsideTransparentRegion({
    required Path path,
    required Size size,
    required Offset position,
  }) {
    final containerBox = Offset.zero & size;
    return containerBox.contains(position) && !path.contains(position);
  }
}
