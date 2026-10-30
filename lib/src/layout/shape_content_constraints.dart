import 'dart:math' as math;
import 'package:flutter/rendering.dart';

import 'shape_content_protection.dart';

/// Derives and enforces safe layout constraints for child content within dynamic shapes.
class ShapeContentConstraints {
  const ShapeContentConstraints._();

  /// Calculates safe layout constraints for child content.
  ///
  /// Guarantees that:
  /// 1. In [ShapeContentMode.strict], child dimensions never exceed the safe interior.
  /// 2. In [ShapeContentMode.adaptive], child constraints adapt to incoming parent bounds
  ///    while respecting the geometry safe insets.
  /// 3. In [ShapeContentMode.visibleOverflow], child is free to extend outside safe insets.
  /// 4. Explicit container dimensions ([explicitWidth], [explicitHeight]) always produce
  ///    finite child constraints to prevent unconstrained Stack assertion failures.
  static BoxConstraints computeChildConstraints({
    required Size shapeSize,
    required EdgeInsets safeInsets,
    required ShapeContentProtection protection,
    BoxConstraints? incomingConstraints,
    double? explicitWidth,
    double? explicitHeight,
  }) {
    if (protection.mode == ShapeContentMode.visibleOverflow) {
      if (incomingConstraints != null) {
        return incomingConstraints.loosen();
      }
      return BoxConstraints.loose(shapeSize);
    }

    final effectiveW = explicitWidth ??
        (incomingConstraints?.hasBoundedWidth == true
            ? incomingConstraints!.maxWidth
            : shapeSize.width);

    final effectiveH = explicitHeight ??
        (incomingConstraints?.hasBoundedHeight == true
            ? incomingConstraints!.maxHeight
            : shapeSize.height);

    final availableWidth = math.max(0.0, effectiveW - safeInsets.horizontal);
    final availableHeight = math.max(0.0, effectiveH - safeInsets.vertical);

    double minW = 0.0;
    double minH = 0.0;

    if (incomingConstraints != null) {
      if (incomingConstraints.minWidth > 0) {
        minW =
            math.max(0.0, incomingConstraints.minWidth - safeInsets.horizontal);
      }
      if (incomingConstraints.minHeight > 0) {
        minH =
            math.max(0.0, incomingConstraints.minHeight - safeInsets.vertical);
      }
    }

    return BoxConstraints(
      minWidth: math.min(minW, availableWidth),
      maxWidth: availableWidth,
      minHeight: math.min(minH, availableHeight),
      maxHeight: availableHeight,
    );
  }

  /// Determines if given [childSize] with [offset] exceeds the safe content bounds.
  static bool exceedsSafeBounds({
    required Size shapeSize,
    required EdgeInsets safeInsets,
    required Size childSize,
    required Offset offset,
  }) {
    final left = offset.dx;
    final top = offset.dy;
    final right = left + childSize.width;
    final bottom = top + childSize.height;

    final safeLeft = safeInsets.left;
    final safeTop = safeInsets.top;
    final safeRight = shapeSize.width - safeInsets.right;
    final safeBottom = shapeSize.height - safeInsets.bottom;

    const epsilon = 0.01;
    return left < safeLeft - epsilon ||
        top < safeTop - epsilon ||
        right > safeRight + epsilon ||
        bottom > safeBottom + epsilon;
  }

  /// Validates whether [size] satisfies minimum accessible touch target guidelines
  /// (WCAG 2.1 minimum 48×48 dp).
  static bool satisfiesTouchTarget(Size size, {double minDimension = 48.0}) {
    return size.width >= minDimension - 0.01 &&
        size.height >= minDimension - 0.01;
  }
}
