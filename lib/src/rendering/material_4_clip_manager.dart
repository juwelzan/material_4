import 'package:flutter/rendering.dart';

import '../dynamic_shape_config.dart';
import '../layout/shape_content_protection.dart';

/// Coordinates granular, independent clipping operations between background,
/// child content, shadows, borders, and visual overflow.
class DynamicShapeClipManager {
  const DynamicShapeClipManager._();

  /// Determines whether child rendering requires path clipping.
  static bool shouldClipChild({
    required ShapeContentProtection protection,
    required DynamicShapeConfig config,
    required Clip clipBehavior,
    ShapeClipConfig? clipConfig,
  }) {
    if (clipBehavior == Clip.none) return false;

    final resolvedClip = clipConfig ?? config.clipConfig;
    if (resolvedClip != null) {
      if (resolvedClip.clipChildren) return true;
      if (!resolvedClip.clipChildren &&
          protection.mode == ContentProtectionMode.visibleOverflow) {
        return false;
      }
    }

    return protection.shouldClipChild;
  }

  /// Determines whether the shape background should be clipped to the shape path.
  static bool shouldClipBackground({
    required DynamicShapeConfig config,
    ShapeClipConfig? clipConfig,
  }) {
    final resolvedClip = clipConfig ?? config.clipConfig;
    return resolvedClip?.clipBackground ?? true;
  }

  /// Determines whether shape borders should be clipped to the shape path.
  static bool shouldClipBorder({
    required DynamicShapeConfig config,
    ShapeClipConfig? clipConfig,
  }) {
    final resolvedClip = clipConfig ?? config.clipConfig;
    return resolvedClip?.clipBorder ?? false;
  }

  /// Determines whether drop shadows should be clipped to the shape path.
  static bool shouldClipShadows({
    required DynamicShapeConfig config,
    ShapeClipConfig? clipConfig,
  }) {
    final resolvedClip = clipConfig ?? config.clipConfig;
    return resolvedClip?.clipShadows ?? false;
  }

  /// Determines whether foreground effects (like shimmer sweeps) should be clipped.
  static bool shouldClipForeground({
    required DynamicShapeConfig config,
    ShapeClipConfig? clipConfig,
  }) {
    final resolvedClip = clipConfig ?? config.clipConfig;
    return resolvedClip?.clipForeground ?? false;
  }

  /// Determines whether visual overflow outside container rectangular bounds should be clipped.
  static bool shouldClipOverflow({
    required DynamicShapeConfig config,
    ShapeClipConfig? clipConfig,
  }) {
    final resolvedClip = clipConfig ?? config.clipConfig;
    return resolvedClip?.clipOverflow ?? false;
  }

  /// Pushes a clipped vector path layer onto [context] if clipping is requested.
  static void paintWithClip({
    required PaintingContext context,
    required Offset offset,
    required Rect bounds,
    required Path clipPath,
    required Clip clipBehavior,
    required PaintingContextCallback painter,
  }) {
    if (clipBehavior == Clip.none) {
      painter(context, offset);
      return;
    }

    final effectivePath = clipPath.shift(offset);
    context.pushClipPath(
      true, // needsCompositing
      offset,
      bounds.shift(offset),
      effectivePath,
      painter,
      clipBehavior: clipBehavior,
    );
  }

  /// Pushes a rectangular clip layer onto [context] when [ShapeClipConfig.clipOverflow] is enabled.
  static void paintWithRectClip({
    required PaintingContext context,
    required Offset offset,
    required Rect clipRect,
    required Clip clipBehavior,
    required PaintingContextCallback painter,
  }) {
    if (clipBehavior == Clip.none) {
      painter(context, offset);
      return;
    }

    context.pushClipRect(
      true, // needsCompositing
      offset,
      clipRect.shift(offset),
      painter,
      clipBehavior: clipBehavior,
    );
  }
}
