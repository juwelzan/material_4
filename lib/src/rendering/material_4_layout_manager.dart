import 'dart:math' as math;
import 'package:flutter/rendering.dart';

import '../layout/shape_content_protection.dart';
import '../layout/shape_safe_region.dart';
import '../material_4_config.dart';

/// Layout and constraint coordination engine for [RenderMaterial4].
class Material4LayoutManager {
  const Material4LayoutManager._();

  /// Computes container dimensions given incoming [constraints], explicit dimensions,
  /// and optional child measurements.
  static Size computeContainerSize({
    required BoxConstraints constraints,
    double? explicitWidth,
    double? explicitHeight,
    RenderBox? child,
    required Material4Config config,
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
    required Material4Config config,
    EdgeInsetsGeometry? padding,
    double? explicitWidth,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (explicitWidth != null) return explicitWidth;
    if (child == null) return config.constraints.minWidth;

    final resolvedPadding = padding?.resolve(textDirection) ?? EdgeInsets.zero;
    final safeInsets = ShapeSafeRegion.computeSafeInsets(
      size: Size(100.0, height > 0 ? height : 100.0),
      config: config,
      basePadding: resolvedPadding,
      borderWidth: borderWidth,
      textDirection: textDirection,
    );
    final childHeight = math.max(0.0, height - safeInsets.vertical);
    final childMin = child.getMinIntrinsicWidth(childHeight);
    return math.max(
      config.constraints.minWidth,
      childMin + safeInsets.horizontal,
    );
  }

  /// Calculates max intrinsic width.
  static double computeMaxIntrinsicWidth({
    required double height,
    RenderBox? child,
    required Material4Config config,
    EdgeInsetsGeometry? padding,
    double? explicitWidth,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (explicitWidth != null) return explicitWidth;
    if (child == null) return config.constraints.minWidth;

    final resolvedPadding = padding?.resolve(textDirection) ?? EdgeInsets.zero;
    final safeInsets = ShapeSafeRegion.computeSafeInsets(
      size: Size(100.0, height > 0 ? height : 100.0),
      config: config,
      basePadding: resolvedPadding,
      borderWidth: borderWidth,
      textDirection: textDirection,
    );
    final childHeight = math.max(0.0, height - safeInsets.vertical);
    final childMax = child.getMaxIntrinsicWidth(childHeight);
    return math.max(
      config.constraints.minWidth,
      childMax + safeInsets.horizontal,
    );
  }

  /// Calculates min intrinsic height.
  static double computeMinIntrinsicHeight({
    required double width,
    RenderBox? child,
    required Material4Config config,
    EdgeInsetsGeometry? padding,
    double? explicitHeight,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (explicitHeight != null) return explicitHeight;
    if (child == null) return config.constraints.minHeight;

    final resolvedPadding = padding?.resolve(textDirection) ?? EdgeInsets.zero;
    final safeInsets = ShapeSafeRegion.computeSafeInsets(
      size: Size(width > 0 ? width : 100.0, 100.0),
      config: config,
      basePadding: resolvedPadding,
      borderWidth: borderWidth,
      textDirection: textDirection,
    );
    final childWidth = math.max(0.0, width - safeInsets.horizontal);
    final childMin = child.getMinIntrinsicHeight(childWidth);
    return math.max(
      config.constraints.minHeight,
      childMin + safeInsets.vertical,
    );
  }

  /// Calculates max intrinsic height.
  static double computeMaxIntrinsicHeight({
    required double width,
    RenderBox? child,
    required Material4Config config,
    EdgeInsetsGeometry? padding,
    double? explicitHeight,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (explicitHeight != null) return explicitHeight;
    if (child == null) return config.constraints.minHeight;

    final resolvedPadding = padding?.resolve(textDirection) ?? EdgeInsets.zero;
    final safeInsets = ShapeSafeRegion.computeSafeInsets(
      size: Size(width > 0 ? width : 100.0, 100.0),
      config: config,
      basePadding: resolvedPadding,
      borderWidth: borderWidth,
      textDirection: textDirection,
    );
    final childWidth = math.max(0.0, width - safeInsets.horizontal);
    final childMax = child.getMaxIntrinsicHeight(childWidth);
    return math.max(
      config.constraints.minHeight,
      childMax + safeInsets.vertical,
    );
  }
}
