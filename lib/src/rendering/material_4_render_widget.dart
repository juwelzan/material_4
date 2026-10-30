import 'package:flutter/material.dart';

import '../dynamic_shape_config.dart';
import '../layout/shape_content_protection.dart';
import 'dynamic_shape_hit_test.dart';
import 'dynamic_shape_interaction.dart';
import 'dynamic_shape_render_object.dart';

/// Single-child RenderObjectWidget that hosts the [RenderDynamicShape] engine.
class DynamicShapeRenderWidget extends SingleChildRenderObjectWidget {
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
  final AlignmentGeometry? alignment;
  final TextDirection? textDirection;
  final double? width;
  final double? height;
  final String? semanticLabel;
  final String? semanticHint;

  const DynamicShapeRenderWidget({
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
    this.alignment,
    this.textDirection,
    this.width,
    this.height,
    this.semanticLabel,
    this.semanticHint,
    super.child,
  });

  @override
  RenderDynamicShape createRenderObject(BuildContext context) {
    return RenderDynamicShape(
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
      BuildContext context, RenderDynamicShape renderObject) {
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
      ..textDirection =
          textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr
      ..explicitWidth = width
      ..explicitHeight = height
      ..semanticLabel = semanticLabel
      ..semanticHint = semanticHint;
  }
}
