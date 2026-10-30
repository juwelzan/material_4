import 'dart:math' as math;
import 'package:flutter/rendering.dart';

import '../dynamic_shape_config.dart';
import '../layout/shape_content_protection.dart';
import '../layout/shape_safe_region.dart';

/// Layout and constraint coordination engine for [RenderDynamicShape].
class DynamicShapeLayoutManager {
  const DynamicShapeLayoutManager._();

  /// Computes container dimensions given incoming [constraints], explicit dimensions,
  /// and optional child measurements.
  static Size computeContainerSize({
    required BoxConstraints constraints,
    double? explicitWidth,
    double? explicitHeight,
    RenderBox? child,
    required DynamicShapeConfig config,
    required ShapeContentProtection protection,
    EdgeInsetsGeometry? padding,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    double width;
    double height;

    if (explicitWidth != null) {
      width = explicitWidth;
    } else if (constraints.hasBoundedWidth) {
      width = constraints.maxWidth;
    } else if (child != null) {
      final safeInsets = ShapeSafeRegion.computeSafeInsets(
        size: Size(constraints.minWidth, constraints.minHeight),
        config: config,
        basePadding: padding?.resolve(textDirection) ?? EdgeInsets.zero,
        borderWidth: borderWidth,
        textDirection: textDirection,
      );
      width =
          child.getMaxIntrinsicWidth(double.infinity) + safeInsets.horizontal;
    } else {
      width = constraints.minWidth;
    }

    if (explicitHeight != null) {
      height = explicitHeight;
    } else if (constraints.hasBoundedHeight) {
      height = constraints.maxHeight;
    } else if (child != null) {
      final safeInsets = ShapeSafeRegion.computeSafeInsets(
        size: Size(width, constraints.minHeight),
        config: config,
        basePadding: padding?.resolve(textDirection) ?? EdgeInsets.zero,
        borderWidth: borderWidth,
        textDirection: textDirection,
      );
      height = child.getMaxIntrinsicHeight(width) + safeInsets.vertical;
    } else {
      height = constraints.minHeight;
    }

    // Apply aspect ratio constraints if defined on config
    final targetRatio = config.resolvedTransform.targetAspectRatio;
    if (targetRatio != null && targetRatio > 0) {
      if (explicitWidth != null && explicitHeight == null) {
        height = width / targetRatio;
      } else if (explicitHeight != null && explicitWidth == null) {
        width = height * targetRatio;
      }
    }

    final rawSize = Size(width, height);
    final clampedSize = constraints.constrain(rawSize);
    return config.constraints.clampSize(clampedSize);
  }

  /// Calculates min intrinsic width.
  static double computeMinIntrinsicWidth({
    required double height,
    RenderBox? child,
    required DynamicShapeConfig config,
    EdgeInsetsGeometry? padding,
    double? explicitWidth,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (explicitWidth != null) return explicitWidth;
    if (child == null) return config.constraints.minWidth;

    final resolvedPadding = padding?.resolve(textDirection) ?? EdgeInsets.zero;
    final childMin = child.getMinIntrinsicWidth(height);
    return math.max(
      config.constraints.minWidth,
      childMin + resolvedPadding.horizontal,
    );
  }

  /// Calculates max intrinsic width.
  static double computeMaxIntrinsicWidth({
    required double height,
    RenderBox? child,
    required DynamicShapeConfig config,
    EdgeInsetsGeometry? padding,
    double? explicitWidth,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (explicitWidth != null) return explicitWidth;
    if (child == null) return config.constraints.minWidth;

    final resolvedPadding = padding?.resolve(textDirection) ?? EdgeInsets.zero;
    final childMax = child.getMaxIntrinsicWidth(height);
    return math.max(
      config.constraints.minWidth,
      childMax + resolvedPadding.horizontal,
    );
  }

  /// Calculates min intrinsic height.
  static double computeMinIntrinsicHeight({
    required double width,
    RenderBox? child,
    required DynamicShapeConfig config,
    EdgeInsetsGeometry? padding,
    double? explicitHeight,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (explicitHeight != null) return explicitHeight;
    if (child == null) return config.constraints.minHeight;

    final resolvedPadding = padding?.resolve(textDirection) ?? EdgeInsets.zero;
    final childMin = child.getMinIntrinsicHeight(width);
    return math.max(
      config.constraints.minHeight,
      childMin + resolvedPadding.vertical,
    );
  }

  /// Calculates max intrinsic height.
  static double computeMaxIntrinsicHeight({
    required double width,
    RenderBox? child,
    required DynamicShapeConfig config,
    EdgeInsetsGeometry? padding,
    double? explicitHeight,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (explicitHeight != null) return explicitHeight;
    if (child == null) return config.constraints.minHeight;

    final resolvedPadding = padding?.resolve(textDirection) ?? EdgeInsets.zero;
    final childMax = child.getMaxIntrinsicHeight(width);
    return math.max(
      config.constraints.minHeight,
      childMax + resolvedPadding.vertical,
    );
  }
}
