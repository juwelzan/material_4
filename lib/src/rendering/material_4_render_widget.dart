import 'package:flutter/material.dart';

import '../layout/shape_content_protection.dart';
import '../material_4_config.dart';
import 'material_4_hit_test.dart';
import 'material_4_interaction.dart';
import 'material_4_render_object.dart';

/// Single-child RenderObjectWidget that hosts the [RenderMaterial4] engine.
class Material4RenderWidget extends SingleChildRenderObjectWidget {
  final Material4Config config;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final Clip clipBehavior;
  final ShapeContentProtection contentProtection;
  final ShapeHitTestBehavior hitTestBehavior;
  final Material4Interaction? interaction;
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

  const Material4RenderWidget({
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
  RenderMaterial4 createRenderObject(BuildContext context) {
    return RenderMaterial4(
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
  void updateRenderObject(BuildContext context, RenderMaterial4 renderObject) {
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
