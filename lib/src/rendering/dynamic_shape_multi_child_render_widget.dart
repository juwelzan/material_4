import 'package:flutter/material.dart';

import '../dynamic_shape_config.dart';
import '../dynamic_shape_stack.dart';
import '../layout/shape_collision_detector.dart';
import '../layout/shape_content_protection.dart';
import 'dynamic_shape_hit_test.dart';
import 'dynamic_shape_interaction.dart';
import 'dynamic_shape_multi_child_render_object.dart';

/// Multi-child RenderObjectWidget hosting the [RenderMultiChildDynamicShape] engine.
class DynamicShapeMultiChildRenderWidget extends MultiChildRenderObjectWidget {
  final DynamicShapeConfig config;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final Clip clipBehavior;
  final ShapeContentProtection contentProtection;
  final ShapeHitTestBehavior hitTestBehavior;
  final DynamicShapeInteraction? interaction;
  final ShapeClipConfig? clipConfig;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;
  final ShapeLayoutStrategy layoutStrategy;
  final double spacing;
  final ShapeCollisionPolicy collisionPolicy;
  final TextDirection? textDirection;
  final double? width;
  final double? height;
  final String? semanticLabel;
  final String? semanticHint;

  const DynamicShapeMultiChildRenderWidget({
    super.key,
    required this.config,
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
    this.textDirection,
    this.width,
    this.height,
    this.semanticLabel,
    this.semanticHint,
    super.children,
  });

  @override
  RenderMultiChildDynamicShape createRenderObject(BuildContext context) {
    return RenderMultiChildDynamicShape(
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
      textDirection:
          textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr,
      width: width,
      height: height,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderMultiChildDynamicShape renderObject) {
    renderObject
      ..config = config
      ..color = color
      ..gradient = gradient
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..shadows = shadows
      ..clipBehavior = clipBehavior
      ..contentProtection = contentProtection
      ..hitTestBehavior = hitTestBehavior
      ..interaction = interaction
      ..clipConfig = clipConfig
      ..onTap = onTap
      ..onLongPress = onLongPress
      ..onDoubleTap = onDoubleTap
      ..padding = padding
      ..alignment = alignment
      ..layoutStrategy = layoutStrategy
      ..spacing = spacing
      ..collisionPolicy = collisionPolicy
      ..textDirection =
          textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr
      ..explicitWidth = width
      ..explicitHeight = height
      ..semanticLabel = semanticLabel
      ..semanticHint = semanticHint;
  }
}
