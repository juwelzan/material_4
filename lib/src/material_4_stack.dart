import 'package:flutter/material.dart';

import 'dynamic_shape_config.dart';
import 'layout/shape_collision_detector.dart';
import 'layout/shape_content_protection.dart';
import 'rendering/dynamic_shape_hit_test.dart';
import 'rendering/dynamic_shape_interaction.dart';
import 'rendering/dynamic_shape_multi_child_parent_data.dart';
import 'rendering/dynamic_shape_multi_child_render_widget.dart';

/// Layout strategy determining how multiple children are positioned inside a dynamic shape.
enum ShapeLayoutStrategy {
  /// Stack layout: children are positioned according to their individual [alignment] or [anchor].
  stack,

  /// Vertical flow layout: children are stacked vertically from top to bottom within safe bounds.
  flowVertical,

  /// Horizontal flow layout: children are aligned horizontally from left to right (or RTL).
  flowHorizontal,

  /// Landmark anchor layout: each child is anchored to a geometric shape landmark.
  anchor,

  /// Adaptive layout: priority-based distribution across single or multiple partitioned safe regions.
  adaptive,
}

/// A ParentDataWidget for configuring layout options of children inside [DynamicShapeStack].
class ShapeChild extends ParentDataWidget<DynamicShapeMultiChildParentData> {
  /// Target alignment within the safe region.
  final AlignmentGeometry? alignment;

  /// Shape landmark anchor for landmark-based placement.
  final ShapeAnchor? anchor;

  /// Priority of this child in competitive or adaptive placement (higher priority placed first).
  final int priority;

  /// Margin surrounding this child.
  final EdgeInsets margin;

  /// Inner padding for this child.
  final EdgeInsets padding;

  /// Minimum width constraint override.
  final double? minWidth;

  /// Maximum width constraint override.
  final double? maxWidth;

  /// Minimum height constraint override.
  final double? minHeight;

  /// Maximum height constraint override.
  final double? maxHeight;

  /// Whether this child is permitted to render outside shape safe boundaries.
  final bool allowOverflow;

  /// Collision policy governing behavior when this child overlaps siblings.
  final ShapeCollisionPolicy collisionPolicy;

  /// Rendering z-index stack order.
  final int zIndex;

  /// Optional clipping override for this child.
  final bool? clipOverride;

  const ShapeChild({
    super.key,
    required super.child,
    this.alignment,
    this.anchor,
    this.priority = 0,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.allowOverflow = false,
    this.collisionPolicy = ShapeCollisionPolicy.reposition,
    this.zIndex = 0,
    this.clipOverride,
  });

  /// Factory for positioning a child with explicit alignment within the safe region.
  const ShapeChild.aligned({
    Key? key,
    required Widget child,
    required AlignmentGeometry alignment,
    int priority = 0,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    bool allowOverflow = false,
    ShapeCollisionPolicy collisionPolicy = ShapeCollisionPolicy.reposition,
    int zIndex = 0,
    bool? clipOverride,
  }) : this(
          key: key,
          child: child,
          alignment: alignment,
          priority: priority,
          margin: margin,
          padding: padding,
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight,
          allowOverflow: allowOverflow,
          collisionPolicy: collisionPolicy,
          zIndex: zIndex,
          clipOverride: clipOverride,
        );

  /// Factory for docking a child to a shape landmark anchor.
  const ShapeChild.anchor({
    Key? key,
    required Widget child,
    required ShapeAnchor anchor,
    int priority = 0,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    bool allowOverflow = false,
    ShapeCollisionPolicy collisionPolicy = ShapeCollisionPolicy.reposition,
    int zIndex = 0,
    bool? clipOverride,
  }) : this(
          key: key,
          child: child,
          anchor: anchor,
          priority: priority,
          margin: margin,
          padding: padding,
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight,
          allowOverflow: allowOverflow,
          collisionPolicy: collisionPolicy,
          zIndex: zIndex,
          clipOverride: clipOverride,
        );

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is DynamicShapeMultiChildParentData);
    final parentData =
        renderObject.parentData! as DynamicShapeMultiChildParentData;
    bool needsLayout = false;

    if (parentData.alignment != alignment) {
      parentData.alignment = alignment;
      needsLayout = true;
    }
    if (parentData.anchor != anchor) {
      parentData.anchor = anchor;
      needsLayout = true;
    }
    if (parentData.priority != priority) {
      parentData.priority = priority;
      needsLayout = true;
    }
    if (parentData.margin != margin) {
      parentData.margin = margin;
      needsLayout = true;
    }
    if (parentData.padding != padding) {
      parentData.padding = padding;
      needsLayout = true;
    }
    if (parentData.minWidth != minWidth ||
        parentData.maxWidth != maxWidth ||
        parentData.minHeight != minHeight ||
        parentData.maxHeight != maxHeight) {
      parentData.minWidth = minWidth;
      parentData.maxWidth = maxWidth;
      parentData.minHeight = minHeight;
      parentData.maxHeight = maxHeight;
      needsLayout = true;
    }
    if (parentData.allowOverflow != allowOverflow) {
      parentData.allowOverflow = allowOverflow;
      needsLayout = true;
    }
    if (parentData.collisionPolicy != collisionPolicy) {
      parentData.collisionPolicy = collisionPolicy;
      needsLayout = true;
    }
    if (parentData.zIndex != zIndex) {
      parentData.zIndex = zIndex;
      needsLayout = true;
    }
    if (parentData.clipOverride != clipOverride) {
      parentData.clipOverride = clipOverride;
      needsLayout = true;
    }

    if (needsLayout) {
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass =>
      DynamicShapeMultiChildRenderWidget;
}

/// A shape-aware multi-child layout container.
///
/// Intelligently measures, positions, constrains and protects multiple child widgets
/// according to the actual generated custom shape geometry, safe regions, and collision policies.
class DynamicShapeStack extends StatelessWidget {
  /// The list of children to lay out inside the shape.
  final List<Widget> children;

  /// The dynamic vector shape configuration.
  final DynamicShapeConfig config;

  /// Base background fill color.
  final Color? color;

  /// Background gradient.
  final Gradient? gradient;

  /// Shape border stroke color.
  final Color borderColor;

  /// Shape border stroke width.
  final double borderWidth;

  /// Multi-layer outer shadows.
  final List<BoxShadow>? shadows;

  /// Clipping behavior for children.
  final Clip clipBehavior;

  /// Geometry-aware content protection mode.
  final ShapeContentProtection contentProtection;

  /// Point-in-path hit testing strategy.
  final ShapeHitTestBehavior hitTestBehavior;

  /// Shape-aware interaction and pointer routing configuration.
  final DynamicShapeInteraction? interaction;

  /// Granular layer-specific clipping configuration.
  final ShapeClipConfig? clipConfig;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Optional long-press callback.
  final VoidCallback? onLongPress;

  /// Optional double-tap callback.
  final VoidCallback? onDoubleTap;

  /// Outer padding within the shape boundary.
  final EdgeInsetsGeometry? padding;

  /// Default alignment for children that do not specify one.
  final AlignmentGeometry alignment;

  /// Layout strategy governing child positioning.
  final ShapeLayoutStrategy layoutStrategy;

  /// Inter-child spacing for flow layouts.
  final double spacing;

  /// Default collision policy.
  final ShapeCollisionPolicy collisionPolicy;

  /// Explicit width constraint.
  final double? width;

  /// Explicit height constraint.
  final double? height;

  /// Accessibility semantic label.
  final String? semanticLabel;

  /// Accessibility semantic hint.
  final String? semanticHint;

  const DynamicShapeStack({
    super.key,
    required this.children,
    this.config = const DynamicShapeConfig(),
    this.color,
    this.gradient,
    this.borderColor = const Color(0x18000000),
    this.borderWidth = 1.0,
    this.shadows,
    this.clipBehavior = Clip.antiAlias,
    this.contentProtection = const ShapeContentProtection(),
    this.hitTestBehavior = ShapeHitTestBehavior.shapeContour,
    this.interaction,
    this.clipConfig,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.padding,
    this.alignment = Alignment.center,
    this.layoutStrategy = ShapeLayoutStrategy.stack,
    this.spacing = 8.0,
    this.collisionPolicy = ShapeCollisionPolicy.reposition,
    this.width,
    this.height,
    this.semanticLabel,
    this.semanticHint,
  });

  /// Multi-child container that arranges children in a vertical flow.
  const DynamicShapeStack.vertical({
    super.key,
    required this.children,
    this.config = const DynamicShapeConfig(),
    this.color,
    this.gradient,
    this.borderColor = const Color(0x18000000),
    this.borderWidth = 1.0,
    this.shadows,
    this.clipBehavior = Clip.antiAlias,
    this.contentProtection = const ShapeContentProtection(),
    this.hitTestBehavior = ShapeHitTestBehavior.shapeContour,
    this.interaction,
    this.clipConfig,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.padding,
    this.alignment = Alignment.center,
    this.spacing = 8.0,
    this.collisionPolicy = ShapeCollisionPolicy.reposition,
    this.width,
    this.height,
    this.semanticLabel,
    this.semanticHint,
  }) : layoutStrategy = ShapeLayoutStrategy.flowVertical;

  /// Multi-child container that arranges children in a horizontal flow.
  const DynamicShapeStack.horizontal({
    super.key,
    required this.children,
    this.config = const DynamicShapeConfig(),
    this.color,
    this.gradient,
    this.borderColor = const Color(0x18000000),
    this.borderWidth = 1.0,
    this.shadows,
    this.clipBehavior = Clip.antiAlias,
    this.contentProtection = const ShapeContentProtection(),
    this.hitTestBehavior = ShapeHitTestBehavior.shapeContour,
    this.interaction,
    this.clipConfig,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.padding,
    this.alignment = Alignment.center,
    this.spacing = 8.0,
    this.collisionPolicy = ShapeCollisionPolicy.reposition,
    this.width,
    this.height,
    this.semanticLabel,
    this.semanticHint,
  }) : layoutStrategy = ShapeLayoutStrategy.flowHorizontal;

  /// Multi-child container that anchors children to landmark positions.
  const DynamicShapeStack.anchor({
    super.key,
    required this.children,
    this.config = const DynamicShapeConfig(),
    this.color,
    this.gradient,
    this.borderColor = const Color(0x18000000),
    this.borderWidth = 1.0,
    this.shadows,
    this.clipBehavior = Clip.antiAlias,
    this.contentProtection = const ShapeContentProtection(),
    this.hitTestBehavior = ShapeHitTestBehavior.shapeContour,
    this.interaction,
    this.clipConfig,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.padding,
    this.alignment = Alignment.center,
    this.spacing = 8.0,
    this.collisionPolicy = ShapeCollisionPolicy.reposition,
    this.width,
    this.height,
    this.semanticLabel,
    this.semanticHint,
  }) : layoutStrategy = ShapeLayoutStrategy.anchor;

  /// Multi-child container that adaptively distributes children across available safe regions.
  const DynamicShapeStack.adaptive({
    super.key,
    required this.children,
    this.config = const DynamicShapeConfig(),
    this.color,
    this.gradient,
    this.borderColor = const Color(0x18000000),
    this.borderWidth = 1.0,
    this.shadows,
    this.clipBehavior = Clip.antiAlias,
    this.contentProtection = const ShapeContentProtection(),
    this.hitTestBehavior = ShapeHitTestBehavior.shapeContour,
    this.interaction,
    this.clipConfig,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.padding,
    this.alignment = Alignment.center,
    this.spacing = 8.0,
    this.collisionPolicy = ShapeCollisionPolicy.reposition,
    this.width,
    this.height,
    this.semanticLabel,
    this.semanticHint,
  }) : layoutStrategy = ShapeLayoutStrategy.adaptive;

  @override
  Widget build(BuildContext context) {
    return DynamicShapeMultiChildRenderWidget(
      config: config,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      clipBehavior: clipBehavior,
      contentProtection: contentProtection,
      hitTestBehavior: hitTestBehavior,
      interaction: interaction,
      clipConfig: clipConfig,
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      padding: padding,
      alignment: alignment,
      layoutStrategy: layoutStrategy,
      spacing: spacing,
      collisionPolicy: collisionPolicy,
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      width: width,
      height: height,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      children: children,
    );
  }
}
