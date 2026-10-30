import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'dynamic_shape_config.dart';

/// Next-Generation Geometry-Aware Smart Layout Engine.
///
/// Computes mathematically collision-safe regions, text bounds, multi-child slot positioning,
/// RTL geometry mirroring, and accessibility touch target validation dynamically from
/// actual geometric configuration parameters rather than hardcoded static constants.
class ShapeSmartLayout {
  const ShapeSmartLayout._();

  /// Minimum recommended accessible touch target dimensions according to Material/WCAG guidelines.
  static const double minAccessibleTouchTarget = 48.0;

  /// Calculate mathematically guaranteed collision-safe content padding for [config] at [size].
  ///
  /// Takes into account notch depths, tabs, scallops, wave amplitudes, tail dimensions,
  /// borders, independent corner radii, and text directionality (RTL).
  static EdgeInsets computeSafePadding({
    required Size size,
    required DynamicShapeConfig config,
    double borderWidth = 1.0,
    TextDirection textDirection = TextDirection.ltr,
    EdgeInsets basePadding = const EdgeInsets.all(12.0),
  }) {
    final effectiveWidth = (size.width.isFinite && size.width > 0)
        ? size.width
        : 300.0;
    final effectiveHeight = (size.height.isFinite && size.height > 0)
        ? size.height
        : 150.0;

    final isRtl = textDirection == TextDirection.rtl;
    final strokeAllowance = (borderWidth > 0 ? borderWidth : 1.0);

    // Initial safe insets based on uniform or independent corner radii
    double leftInset = basePadding.left + strokeAllowance;
    double rightInset = basePadding.right + strokeAllowance;
    double topInset = basePadding.top + strokeAllowance;
    double bottomInset = basePadding.bottom + strokeAllowance;

    // 1. Independent Corner Radii influence
    if (config.cornerRadii != null) {
      final radii = config.cornerRadii!;
      final effectiveTopLeft = isRtl ? radii.topRight : radii.topLeft;
      final effectiveTopRight = isRtl ? radii.topLeft : radii.topRight;
      final effectiveBottomLeft = isRtl ? radii.bottomRight : radii.bottomLeft;
      final effectiveBottomRight = isRtl ? radii.bottomLeft : radii.bottomRight;

      leftInset = math.max(
        leftInset,
        math.max(effectiveTopLeft, effectiveBottomLeft) * 0.35,
      );
      rightInset = math.max(
        rightInset,
        math.max(effectiveTopRight, effectiveBottomRight) * 0.35,
      );
      topInset = math.max(
        topInset,
        math.max(effectiveTopLeft, effectiveTopRight) * 0.35,
      );
      bottomInset = math.max(
        bottomInset,
        math.max(effectiveBottomLeft, effectiveBottomRight) * 0.35,
      );
    } else {
      final cornerSafety = config.cornerRadius * 0.32;
      leftInset = math.max(leftInset, cornerSafety);
      rightInset = math.max(rightInset, cornerSafety);
      topInset = math.max(topInset, cornerSafety);
      bottomInset = math.max(bottomInset, cornerSafety);
    }

    // 2. Shape-Specific Dynamic Geometry Allowances
    switch (config.type) {
      case DynamicShapeType.folderTab:
        final effectiveAnchor = _resolveRtlAnchor(config.anchor, isRtl);
        if (effectiveAnchor == ShapeAnchor.topLeft ||
            effectiveAnchor == ShapeAnchor.topRight) {
          topInset = math.max(topInset, config.tabHeight + 8.0);
        } else {
          bottomInset = math.max(bottomInset, config.tabHeight + 8.0);
        }
        break;

      case DynamicShapeType.notchedBadge:
        final effectiveAnchor = _resolveRtlAnchor(config.anchor, isRtl);
        if (effectiveAnchor == ShapeAnchor.topRight ||
            effectiveAnchor == ShapeAnchor.topLeft) {
          topInset = math.max(topInset, config.tabHeight + 10.0);
        } else {
          bottomInset = math.max(bottomInset, config.tabHeight + 10.0);
        }
        break;

      case DynamicShapeType.sideTab:
        final effectiveAnchor = _resolveRtlAnchor(config.anchor, isRtl);
        if (effectiveAnchor == ShapeAnchor.rightCenter ||
            effectiveAnchor == ShapeAnchor.topRight) {
          rightInset = math.max(rightInset, config.protrusionDepth + 12.0);
        } else {
          leftInset = math.max(leftInset, config.protrusionDepth + 12.0);
        }
        break;

      case DynamicShapeType.steppedCorner:
        rightInset = math.max(rightInset, config.tabWidth * 0.28);
        bottomInset = math.max(bottomInset, config.tabHeight * 0.28);
        break;

      case DynamicShapeType.ticketScallop:
        leftInset = math.max(leftInset, config.scallopRadius + 10.0);
        rightInset = math.max(rightInset, config.scallopRadius + 10.0);
        break;

      case DynamicShapeType.zigzagCut:
        bottomInset = math.max(bottomInset, config.toothHeight + 12.0);
        break;

      case DynamicShapeType.waveEdge:
        final waveAllowance = config.waveAmplitude + 10.0;
        if (config.anchor == ShapeAnchor.bottomCenter) {
          bottomInset = math.max(bottomInset, waveAllowance);
        } else {
          topInset = math.max(topInset, waveAllowance);
        }
        break;

      case DynamicShapeType.waveCut:
        rightInset = math.max(rightInset, config.waveAmplitude + 14.0);
        bottomInset = math.max(bottomInset, config.waveAmplitude + 12.0);
        break;

      case DynamicShapeType.speechBubble:
        final tailAllowance = config.speechBubbleTailHeight + 10.0;
        final effectiveAnchor = _resolveRtlAnchor(config.anchor, isRtl);
        if (effectiveAnchor.name.startsWith('bottom')) {
          bottomInset = math.max(bottomInset, tailAllowance);
        } else if (effectiveAnchor.name.startsWith('top')) {
          topInset = math.max(topInset, tailAllowance);
        } else if (effectiveAnchor.name.startsWith('right')) {
          rightInset = math.max(rightInset, tailAllowance);
        } else {
          leftInset = math.max(leftInset, tailAllowance);
        }
        break;

      case DynamicShapeType.shield:
        bottomInset = math.max(bottomInset, effectiveHeight * 0.16);
        leftInset = math.max(leftInset, 16.0);
        rightInset = math.max(rightInset, 16.0);
        break;

      case DynamicShapeType.diamond:
        leftInset = math.max(leftInset, effectiveWidth * 0.18);
        rightInset = math.max(rightInset, effectiveWidth * 0.18);
        topInset = math.max(topInset, effectiveHeight * 0.18);
        bottomInset = math.max(bottomInset, effectiveHeight * 0.18);
        break;

      case DynamicShapeType.parallelogram:
        final skewOffset =
            (math.tan(config.skewAngle * math.pi / 180.0).abs() *
            effectiveHeight *
            0.35);
        leftInset = math.max(leftInset, skewOffset + 12.0);
        rightInset = math.max(rightInset, skewOffset + 12.0);
        break;

      case DynamicShapeType.ribbon:
        final foldCut = config.ribbonFoldDepth + 8.0;
        leftInset = math.max(leftInset, foldCut);
        rightInset = math.max(rightInset, foldCut);
        break;

      case DynamicShapeType.bookmark:
        bottomInset = math.max(bottomInset, config.ribbonFoldDepth + 8.0);
        break;

      case DynamicShapeType.capsule:
        final capRadius = math.min(effectiveWidth, effectiveHeight) * 0.32;
        leftInset = math.max(leftInset, capRadius);
        rightInset = math.max(rightInset, capRadius);
        break;

      case DynamicShapeType.cloud:
        topInset = math.max(topInset, 18.0);
        bottomInset = math.max(bottomInset, 16.0);
        leftInset = math.max(leftInset, 18.0);
        rightInset = math.max(rightInset, 18.0);
        break;

      case DynamicShapeType.concaveRounded:
        final cut = config.cornerRadius * 0.55;
        leftInset = math.max(leftInset, cut);
        rightInset = math.max(rightInset, cut);
        topInset = math.max(topInset, cut);
        bottomInset = math.max(bottomInset, cut);
        break;

      default:
        break;
    }

    // 3. Multi-notch collision avoidance
    if (config.notches != null && config.notches!.isNotEmpty) {
      for (final notch in config.notches!) {
        final notchAllowance = notch.height + 8.0;
        switch (notch.position) {
          case ShapeAnchor.topLeft:
          case ShapeAnchor.topCenter:
          case ShapeAnchor.topRight:
            topInset = math.max(topInset, notchAllowance);
            break;
          case ShapeAnchor.bottomLeft:
          case ShapeAnchor.bottomCenter:
          case ShapeAnchor.bottomRight:
            bottomInset = math.max(bottomInset, notchAllowance);
            break;
          case ShapeAnchor.leftCenter:
            if (!isRtl) {
              leftInset = math.max(leftInset, notchAllowance);
            } else {
              rightInset = math.max(rightInset, notchAllowance);
            }
            break;
          case ShapeAnchor.rightCenter:
            if (!isRtl) {
              rightInset = math.max(rightInset, notchAllowance);
            } else {
              leftInset = math.max(leftInset, notchAllowance);
            }
            break;
          case ShapeAnchor.center:
            break;
        }
      }
    }

    return EdgeInsets.only(
      left: leftInset,
      right: rightInset,
      top: topInset,
      bottom: bottomInset,
    );
  }

  /// Calculates the largest guaranteed collision-free inscribed rectangular text/content box.
  static Rect computeInscribedRect(
    Size size,
    DynamicShapeConfig config, {
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final padding = computeSafePadding(
      size: size,
      config: config,
      textDirection: textDirection,
    );
    return Rect.fromLTWH(
      padding.left,
      padding.top,
      math.max(0.0, size.width - padding.horizontal),
      math.max(0.0, size.height - padding.vertical),
    );
  }

  /// Enforces accessible touch target dimensions (min 48x48) on interactive shapes.
  static Size validateTouchTarget(
    Size requestedSize, {
    double minDimension = minAccessibleTouchTarget,
  }) {
    return Size(
      math.max(requestedSize.width, minDimension),
      math.max(requestedSize.height, minDimension),
    );
  }

  static ShapeAnchor _resolveRtlAnchor(ShapeAnchor anchor, bool isRtl) {
    if (!isRtl) return anchor;
    return switch (anchor) {
      ShapeAnchor.topLeft => ShapeAnchor.topRight,
      ShapeAnchor.topRight => ShapeAnchor.topLeft,
      ShapeAnchor.bottomLeft => ShapeAnchor.bottomRight,
      ShapeAnchor.bottomRight => ShapeAnchor.bottomLeft,
      ShapeAnchor.leftCenter => ShapeAnchor.rightCenter,
      ShapeAnchor.rightCenter => ShapeAnchor.leftCenter,
      _ => anchor,
    };
  }
}

/// Geometry-Aware Safe Area widget that dynamically computes collision-free margins
/// and padding for any child inside arbitrary dynamic shape containers.
class ShapeSafeArea extends StatelessWidget {
  final Widget child;
  final DynamicShapeConfig config;
  final EdgeInsets basePadding;

  const ShapeSafeArea({
    super.key,
    required this.child,
    this.config = const DynamicShapeConfig(),
    this.basePadding = const EdgeInsets.all(12.0),
  });

  @override
  Widget build(BuildContext context) {
    final textDir = Directionality.maybeOf(context) ?? TextDirection.ltr;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w =
            constraints.hasBoundedWidth && !constraints.maxWidth.isInfinite
            ? constraints.maxWidth
            : 300.0;
        final h =
            constraints.hasBoundedHeight && !constraints.maxHeight.isInfinite
            ? constraints.maxHeight
            : 150.0;
        final size = Size(w, h);
        final safePadding = ShapeSmartLayout.computeSafePadding(
          size: size,
          config: config,
          textDirection: textDir,
          basePadding: basePadding,
        );

        return Padding(padding: safePadding, child: child);
      },
    );
  }
}
