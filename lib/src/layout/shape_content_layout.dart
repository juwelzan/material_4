import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../material_4_config.dart';
import 'shape_content_protection.dart';
import 'shape_safe_region.dart';

/// Result data structure describing child layout geometry inside a Material 4 shape.
class ShapeLayoutResult {
  /// Calculated top-left offset for the child within the container.
  final Offset childOffset;

  /// Measured size of the child.
  final Size childSize;

  /// Collision-free safe bounds rect inside the shape contour.
  final Rect safeBounds;

  /// Safe directional insets applied to the child.
  final EdgeInsets safeInsets;

  /// Content protection mode governing this layout.
  final ShapeContentMode mode;

  const ShapeLayoutResult({
    required this.childOffset,
    required this.childSize,
    required this.safeBounds,
    required this.safeInsets,
    this.mode = ShapeContentMode.adaptive,
  });

  @override
  String toString() =>
      'ShapeLayoutResult(offset: $childOffset, size: $childSize, bounds: $safeBounds, mode: $mode)';
}

/// Content layout engine that positions and aligns children within Material 4 shapes.
class ShapeContentLayout {
  const ShapeContentLayout._();

  /// Calculates positioning for child inside [shapeSize] respecting [safeInsets]
  /// and target [alignment].
  static ShapeLayoutResult computeLayout({
    required Size shapeSize,
    required Size childSize,
    required EdgeInsets safeInsets,
    AlignmentGeometry alignment = Alignment.center,
    ShapeContentProtection protection = const ShapeContentProtection(),
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final resolvedAlignment = alignment.resolve(textDirection);

    final safeLeft = safeInsets.left;
    final safeTop = safeInsets.top;
    final safeWidth = math.max(0.0, shapeSize.width - safeInsets.horizontal);
    final safeHeight = math.max(0.0, shapeSize.height - safeInsets.vertical);
    final safeBounds = Rect.fromLTWH(safeLeft, safeTop, safeWidth, safeHeight);

    if (protection.mode == ShapeContentMode.visibleOverflow) {
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
        mode: protection.mode,
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
      mode: protection.mode,
    );
  }
}

/// A smart, geometry-aware child slot layout widget.
///
/// Automatically coordinates leading icons, titles, subtitles, and trailing badges
/// within safe shape boundaries without clipping, cutting off text, or colliding
/// with inward notches and stepped corners.
class ShapeSmartContent extends StatelessWidget {
  /// Optional leading widget (e.g. icon or avatar).
  final Widget? leading;

  /// Main title text or custom title widget.
  final Widget? title;

  /// Optional subtitle or detail text widget.
  final Widget? subtitle;

  /// Optional trailing widget (e.g. badge, button, chevron).
  final Widget? trailing;

  /// Custom child widget to display if not using slots.
  final Widget? child;

  /// Material 4 shape configuration defining the parent contour.
  final Material4Config config;

  /// Content protection mode.
  final ShapeContentMode mode;

  /// Directional base padding added on top of geometric safe insets.
  final EdgeInsets basePadding;

  /// Minimum spacing between leading, content, and trailing slots.
  final double spacing;

  /// Alignment of content inside safe bounds.
  final AlignmentGeometry alignment;

  const ShapeSmartContent({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.child,
    this.config = const Material4Config(),
    this.mode = ShapeContentMode.adaptive,
    this.basePadding = EdgeInsets.zero,
    this.spacing = 8.0,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(
            constraints.hasBoundedWidth ? constraints.maxWidth : 200.0,
            constraints.hasBoundedHeight ? constraints.maxHeight : 100.0,
          );
          final insets = ShapeSafeRegion.computeSafeInsets(
            size: size,
            config: config,
            basePadding: basePadding,
            textDirection: Directionality.of(context),
          );
          return Padding(
            padding:
                mode == ShapeContentMode.visibleOverflow ? basePadding : insets,
            child: Align(alignment: alignment, child: child!),
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final textDir = Directionality.of(context);
        final size = Size(
          constraints.hasBoundedWidth ? constraints.maxWidth : 300.0,
          constraints.hasBoundedHeight ? constraints.maxHeight : 80.0,
        );

        final insets = ShapeSafeRegion.computeSafeInsets(
          size: size,
          config: config,
          basePadding: basePadding,
          textDirection: textDir,
        );

        Widget? contentWidget;
        if (title != null || subtitle != null) {
          contentWidget = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (title != null)
                DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  child: title!,
                ),
              if (title != null && subtitle != null)
                SizedBox(height: spacing / 4.0),
              if (subtitle != null)
                DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  child: subtitle!,
                ),
            ],
          );
        }

        return Padding(
          padding:
              mode == ShapeContentMode.visibleOverflow ? basePadding : insets,
          child: Align(
            alignment: alignment,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: spacing),
                ],
                if (contentWidget != null)
                  Expanded(
                    child: Center(
                      heightFactor: 1.0,
                      child: contentWidget,
                    ),
                  ),
                if (trailing != null) ...[
                  SizedBox(width: spacing),
                  trailing!,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
