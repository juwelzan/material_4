import 'dart:math' as math;
import 'package:flutter/rendering.dart';

import '../material_4_config.dart';
import 'shape_anchor_placer.dart';

/// Layout specification for a horizontal slot containing leading, content, and trailing elements.
class HorizontalSlotLayoutResult {
  final Rect? leadingRect;
  final Rect contentRect;
  final Rect? trailingRect;
  final double spacing;

  const HorizontalSlotLayoutResult({
    this.leadingRect,
    required this.contentRect,
    this.trailingRect,
    this.spacing = 8.0,
  });

  @override
  String toString() =>
      'HorizontalSlotLayoutResult(leading: $leadingRect, content: $contentRect, trailing: $trailingRect)';
}

/// Smart child and accessory placement engine for dynamic vector shapes.
///
/// Handles automatic placement and non-colliding alignment for icons, badges,
/// labels, and multi-child slot compositions within safe shape boundaries.
class ShapeContentPlacer {
  const ShapeContentPlacer._();

  /// Default minimum spacing between adjacent child widgets inside Material 4 shapes.
  static const double defaultSpacing = 8.0;

  /// Computes placement offset for a docked badge or accessory of [accessorySize]
  /// docked at [anchor] on a shape of [shapeSize].
  static Offset computeAccessoryOffset({
    required Size shapeSize,
    required Size accessorySize,
    required ShapeAnchor anchor,
    EdgeInsets padding = EdgeInsets.zero,
    Material4Config config = const Material4Config(),
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final anchorPoint = ShapeAnchorPlacer.resolveAnchorPoint(
      size: shapeSize,
      anchor: anchor,
      config: config,
      textDirection: textDirection,
    );

    double x = anchorPoint.dx - (accessorySize.width / 2.0);
    double y = anchorPoint.dy - (accessorySize.height / 2.0);

    final isRtl = textDirection == TextDirection.rtl;
    final effectiveLeft = isRtl ? padding.right : padding.left;
    final effectiveRight = isRtl ? padding.left : padding.right;

    x += effectiveLeft - effectiveRight;
    y += padding.top - padding.bottom;

    return Offset(x, y);
  }

  /// Positions a badge cleanly within an inward notch pocket on [edge].
  static Rect computeBadgeInNotch({
    required Size shapeSize,
    required Size badgeSize,
    required ShapeNotch notch,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final center = ShapeAnchorPlacer.resolveNotchCenter(
      size: shapeSize,
      notch: notch,
      textDirection: textDirection,
    );

    return Rect.fromCenter(
      center: center,
      width: math.min(badgeSize.width, notch.width * 0.9),
      height: math.min(badgeSize.height, notch.depth * 0.9),
    );
  }

  /// Calculates collision-free positions for a multi-child horizontal slot
  /// (leading icon + content column + trailing badge/button) inside [safeBounds].
  static HorizontalSlotLayoutResult computeHorizontalSlotLayout({
    required Rect safeBounds,
    Size? leadingSize,
    Size? trailingSize,
    double spacing = defaultSpacing,
    TextDirection textDirection = TextDirection.ltr,
    Alignment verticalAlignment = Alignment.center,
  }) {
    final isRtl = textDirection == TextDirection.rtl;

    double currentX = safeBounds.left;
    double availableW = safeBounds.width;

    Rect? leadingRect;
    if (leadingSize != null && leadingSize.width > 0) {
      final leadW = math.min(leadingSize.width, availableW);
      final leadH = math.min(leadingSize.height, safeBounds.height);
      final leadY = safeBounds.top +
          (safeBounds.height - leadH) / 2.0 +
          verticalAlignment.y * (safeBounds.height - leadH) / 2.0;

      leadingRect = Rect.fromLTWH(currentX, leadY, leadW, leadH);
      currentX += leadW + spacing;
      availableW = math.max(0.0, availableW - leadW - spacing);
    }

    Rect? trailingRect;
    if (trailingSize != null && trailingSize.width > 0) {
      final trailW = math.min(trailingSize.width, availableW);
      final trailH = math.min(trailingSize.height, safeBounds.height);
      final trailY = safeBounds.top +
          (safeBounds.height - trailH) / 2.0 +
          verticalAlignment.y * (safeBounds.height - trailH) / 2.0;

      final trailX = safeBounds.right - trailW;
      trailingRect = Rect.fromLTWH(trailX, trailY, trailW, trailH);
      availableW = math.max(0.0, availableW - trailW - spacing);
    }

    // Remaining width is allocated to content
    final contentW = math.max(0.0, availableW);
    final contentH = safeBounds.height;
    final contentRect =
        Rect.fromLTWH(currentX, safeBounds.top, contentW, contentH);

    if (isRtl) {
      // Mirror leading and trailing for RTL layout
      return HorizontalSlotLayoutResult(
        leadingRect: trailingRect != null
            ? _mirrorRectHorizontal(trailingRect, safeBounds)
            : null,
        contentRect: _mirrorRectHorizontal(contentRect, safeBounds),
        trailingRect: leadingRect != null
            ? _mirrorRectHorizontal(leadingRect, safeBounds)
            : null,
        spacing: spacing,
      );
    }

    return HorizontalSlotLayoutResult(
      leadingRect: leadingRect,
      contentRect: contentRect,
      trailingRect: trailingRect,
      spacing: spacing,
    );
  }

  static Rect _mirrorRectHorizontal(Rect rect, Rect container) {
    final distFromLeft = rect.left - container.left;
    final newLeft = container.right - distFromLeft - rect.width;
    return Rect.fromLTWH(newLeft, rect.top, rect.width, rect.height);
  }
}
