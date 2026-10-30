import 'dart:math' as math;
import 'package:flutter/rendering.dart';

import 'shape_content_protection.dart';

/// Result data structure describing child layout geometry inside a dynamic shape.
class ShapeLayoutResult {
  final Offset childOffset;
  final Size childSize;
  final Rect safeBounds;
  final EdgeInsets safeInsets;

  const ShapeLayoutResult({
    required this.childOffset,
    required this.childSize,
    required this.safeBounds,
    required this.safeInsets,
  });

  @override
  String toString() =>
      'ShapeLayoutResult(offset: $childOffset, size: $childSize, safeBounds: $safeBounds)';
}

/// Content layout engine that positions and aligns children within dynamic shapes.
class ShapeContentLayout {
  const ShapeContentLayout._();

  /// Calculates positioning for child inside [shapeSize] respecting [safeInsets]
  /// and target [alignment].
  static ShapeLayoutResult computeLayout({
    required Size shapeSize,
    required Size childSize,
    required EdgeInsets safeInsets,
    AlignmentGeometry alignment = Alignment.center,
    ShapeContentProtection protection = const ShapeContentProtection.strict(),
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final resolvedAlignment = alignment.resolve(textDirection);

    final safeLeft = safeInsets.left;
    final safeTop = safeInsets.top;
    final safeWidth = math.max(0.0, shapeSize.width - safeInsets.horizontal);
    final safeHeight = math.max(0.0, shapeSize.height - safeInsets.vertical);
    final safeBounds = Rect.fromLTWH(safeLeft, safeTop, safeWidth, safeHeight);

    if (protection.mode == ContentProtectionMode.visibleOverflow) {
      // Free positioning across entire shape without insetting
      final freeX = (shapeSize.width - childSize.width) / 2.0 +
          resolvedAlignment.x * (shapeSize.width - childSize.width) / 2.0;
      final freeY = (shapeSize.height - childSize.height) / 2.0 +
          resolvedAlignment.y * (shapeSize.height - childSize.height) / 2.0;

      return ShapeLayoutResult(
        childOffset: Offset(freeX, freeY),
        childSize: childSize,
        safeBounds: Offset.zero & shapeSize,
        safeInsets: EdgeInsets.zero,
      );
    }

    // Align child within safe bounds
    final availableW = math.max(0.0, safeWidth - childSize.width);
    final availableH = math.max(0.0, safeHeight - childSize.height);

    final posX = safeLeft +
        (availableW / 2.0) +
        (resolvedAlignment.x * availableW / 2.0);
    final posY =
        safeTop + (availableH / 2.0) + (resolvedAlignment.y * availableH / 2.0);

    return ShapeLayoutResult(
      childOffset: Offset(posX, posY),
      childSize: childSize,
      safeBounds: safeBounds,
      safeInsets: safeInsets,
    );
  }
}
