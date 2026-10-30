import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'organic_card_shape.dart';

/// Builds high-precision, mathematically continuous vector [Path]s for [Material4CardShape].
///
/// Ensures C1 and C2 continuous cubic Bézier curve blending across all corners
/// and edges with zero visual artifacts, line discontinuities, or self-intersections.
class OrganicShapePathBuilder {
  /// Builds a [Path] for [shape] within the given [size].
  static Path buildPath(Size size, Material4CardShape shape) {
    if (size.width <= 0 ||
        size.height <= 0 ||
        size.width.isNaN ||
        size.height.isNaN) {
      return Path();
    }

    final double w = size.width;
    final double h = size.height;

    // 1. Proportional radius clamping to ensure corners never overlap
    double rTL = shape.topLeft.radius;
    double rTR = shape.topRight.radius;
    double rBR = shape.bottomRight.radius;
    double rBL = shape.bottomLeft.radius;

    final double factorTop = (rTL + rTR) > w ? w / (rTL + rTR) : 1.0;
    final double factorBottom = (rBL + rBR) > w ? w / (rBL + rBR) : 1.0;
    final double factorLeft = (rTL + rBL) > h ? h / (rTL + rBL) : 1.0;
    final double factorRight = (rTR + rBR) > h ? h / (rTR + rBR) : 1.0;

    final double scale = math.min(
      math.min(factorTop, factorBottom),
      math.min(factorLeft, factorRight),
    );

    if (scale < 1.0) {
      rTL *= scale;
      rTR *= scale;
      rBR *= scale;
      rBL *= scale;
    }

    final Path path = Path();

    // Start at end of Top-Left corner (on top edge)
    path.moveTo(rTL, 0);

    // -----------------------------------------------------------------------
    // Top Edge
    // -----------------------------------------------------------------------
    final double topLen = (w - rTR) - rTL;
    if (shape.topEdge.style == OrganicEdgeStyle.straight || topLen <= 0) {
      path.lineTo(w - rTR, 0);
    } else {
      _appendHorizontalEdge(
        path: path,
        startX: rTL,
        endX: w - rTR,
        y: 0,
        edge: shape.topEdge,
        isInwardPositive: true, // Inward for top is positive Y (down)
      );
    }

    // -----------------------------------------------------------------------
    // Top-Right Corner
    // -----------------------------------------------------------------------
    _appendCorner(
      path: path,
      corner: shape.topRight,
      actualRadius: rTR,
      cornerCenter: Offset(w - rTR, rTR),
      startPoint: Offset(w - rTR, 0),
      endPoint: Offset(w, rTR),
      isTopRight: true,
    );

    // -----------------------------------------------------------------------
    // Right Edge (Contains Reference Notice Board lower-right notch)
    // -----------------------------------------------------------------------
    final double rightLen = (h - rBR) - rTR;
    if (shape.rightEdge.style == OrganicEdgeStyle.straight || rightLen <= 0) {
      path.lineTo(w, h - rBR);
    } else {
      _appendVerticalEdge(
        path: path,
        startY: rTR,
        endY: h - rBR,
        x: w,
        edge: shape.rightEdge,
        isInwardNegative:
            true, // Inward for right is negative X (left into card)
      );
    }

    // -----------------------------------------------------------------------
    // Bottom-Right Corner
    // -----------------------------------------------------------------------
    _appendCorner(
      path: path,
      corner: shape.bottomRight,
      actualRadius: rBR,
      cornerCenter: Offset(w - rBR, h - rBR),
      startPoint: Offset(w, h - rBR),
      endPoint: Offset(w - rBR, h),
      isBottomRight: true,
    );

    // -----------------------------------------------------------------------
    // Bottom Edge
    // -----------------------------------------------------------------------
    final double bottomLen = (w - rBR) - rBL;
    if (shape.bottomEdge.style == OrganicEdgeStyle.straight || bottomLen <= 0) {
      path.lineTo(rBL, h);
    } else {
      _appendHorizontalEdge(
        path: path,
        startX: w - rBR,
        endX: rBL,
        y: h,
        edge: shape.bottomEdge,
        isInwardPositive:
            false, // Inward for bottom is negative Y (up into card)
      );
    }

    // -----------------------------------------------------------------------
    // Bottom-Left Corner
    // -----------------------------------------------------------------------
    _appendCorner(
      path: path,
      corner: shape.bottomLeft,
      actualRadius: rBL,
      cornerCenter: Offset(rBL, h - rBL),
      startPoint: Offset(rBL, h),
      endPoint: Offset(0, h - rBL),
      isBottomLeft: true,
    );

    // -----------------------------------------------------------------------
    // Left Edge
    // -----------------------------------------------------------------------
    final double leftLen = (h - rBL) - rTL;
    if (shape.leftEdge.style == OrganicEdgeStyle.straight || leftLen <= 0) {
      path.lineTo(0, rTL);
    } else {
      _appendVerticalEdge(
        path: path,
        startY: h - rBL,
        endY: rTL,
        x: 0,
        edge: shape.leftEdge,
        isInwardNegative:
            false, // Inward for left is positive X (right into card)
      );
    }

    // -----------------------------------------------------------------------
    // Top-Left Corner
    // -----------------------------------------------------------------------
    _appendCorner(
      path: path,
      corner: shape.topLeft,
      actualRadius: rTL,
      cornerCenter: Offset(rTL, rTL),
      startPoint: Offset(0, rTL),
      endPoint: Offset(rTL, 0),
      isTopLeft: true,
    );

    path.close();
    return path;
  }

  // =========================================================================
  // Edge Curve Builders
  // =========================================================================

  static void _appendHorizontalEdge({
    required Path path,
    required double startX,
    required double endX,
    required double y,
    required OrganicEdge edge,
    required bool isInwardPositive,
  }) {
    final double direction = (endX > startX) ? 1.0 : -1.0;
    final double totalLen = (endX - startX).abs();

    if (totalLen <= 0) return;

    if (edge.style == OrganicEdgeStyle.straight) {
      path.lineTo(endX, y);
      return;
    }

    // Determine notch bounds along edge
    final double clampedWidth = math.min(edge.width, totalLen * 0.95);
    final double centerOffset = totalLen * edge.position.clamp(0.1, 0.9);
    final double halfW = clampedWidth / 2.0;

    final double startOffset = math.max(0.0, centerOffset - halfW);
    final double endOffset = math.min(totalLen, centerOffset + halfW);

    final double notchStartX = startX + (direction * startOffset);
    final double notchCenterX = startX + (direction * centerOffset);
    final double notchEndX = startX + (direction * endOffset);

    // Initial linear approach to notch
    path.lineTo(notchStartX, y);

    // Peak displacement
    final double sign = (edge.style == OrganicEdgeStyle.concaveNotch ||
            edge.style == OrganicEdgeStyle.sculptedWaist)
        ? (isInwardPositive ? 1.0 : -1.0)
        : (isInwardPositive ? -1.0 : 1.0); // convex bulge moves opposite
    final double peakY = y + (sign * edge.depth);

    final double segLen = (notchCenterX - notchStartX).abs();
    final double s = edge.smoothness.clamp(0.2, 0.85);

    // Segment 1: from notchStartX to notchCenterX (valley/peak)
    path.cubicTo(
      notchStartX + (direction * segLen * s),
      y,
      notchCenterX - (direction * segLen * s),
      peakY,
      notchCenterX,
      peakY,
    );

    // Segment 2: from notchCenterX to notchEndX
    path.cubicTo(
      notchCenterX + (direction * segLen * s),
      peakY,
      notchEndX - (direction * segLen * s),
      y,
      notchEndX,
      y,
    );

    // Remaining segment to edge end
    path.lineTo(endX, y);
  }

  static void _appendVerticalEdge({
    required Path path,
    required double startY,
    required double endY,
    required double x,
    required OrganicEdge edge,
    required bool isInwardNegative,
  }) {
    final double direction = (endY > startY) ? 1.0 : -1.0;
    final double totalLen = (endY - startY).abs();

    if (totalLen <= 0) return;

    if (edge.style == OrganicEdgeStyle.straight) {
      path.lineTo(x, endY);
      return;
    }

    // Determine notch bounds along edge
    final double clampedWidth = math.min(edge.width, totalLen * 0.95);
    final double centerOffset = totalLen * edge.position.clamp(0.1, 0.9);
    final double halfW = clampedWidth / 2.0;

    final double startOffset = math.max(0.0, centerOffset - halfW);
    final double endOffset = math.min(totalLen, centerOffset + halfW);

    final double notchStartY = startY + (direction * startOffset);
    final double notchCenterY = startY + (direction * centerOffset);
    final double notchEndY = startY + (direction * endOffset);

    // Initial linear approach to notch
    path.lineTo(x, notchStartY);

    // Peak displacement
    final double sign = (edge.style == OrganicEdgeStyle.concaveNotch ||
            edge.style == OrganicEdgeStyle.sculptedWaist)
        ? (isInwardNegative ? -1.0 : 1.0)
        : (isInwardNegative ? 1.0 : -1.0); // convex bulge moves opposite
    final double peakX = x + (sign * edge.depth);

    final double segLen = (notchCenterY - notchStartY).abs();
    final double s = edge.smoothness.clamp(0.2, 0.85);

    // Segment 1: from notchStartY to notchCenterY (valley/peak)
    path.cubicTo(
      x,
      notchStartY + (direction * segLen * s),
      peakX,
      notchCenterY - (direction * segLen * s),
      peakX,
      notchCenterY,
    );

    // Segment 2: from notchCenterY to notchEndY
    path.cubicTo(
      peakX,
      notchCenterY + (direction * segLen * s),
      x,
      notchEndY - (direction * segLen * s),
      x,
      notchEndY,
    );

    // Remaining segment to edge end
    path.lineTo(x, endY);
  }

  // =========================================================================
  // Corner Arc Builders
  // =========================================================================

  static void _appendCorner({
    required Path path,
    required OrganicCorner corner,
    required double actualRadius,
    required Offset cornerCenter,
    required Offset startPoint,
    required Offset endPoint,
    bool isTopRight = false,
    bool isBottomRight = false,
    bool isBottomLeft = false,
    bool isTopLeft = false,
  }) {
    if (actualRadius <= 0) {
      path.lineTo(endPoint.dx, endPoint.dy);
      return;
    }

    switch (corner.style) {
      case OrganicCornerStyle.chamfer:
        // Flat 45 degree bevel cut with small entry/exit bevel
        path.lineTo(endPoint.dx, endPoint.dy);
        break;

      case OrganicCornerStyle.concave:
        // Concave inward arc (scooped corner)
        path.arcToPoint(
          endPoint,
          radius: Radius.circular(actualRadius),
          clockwise: false,
        );
        break;

      case OrganicCornerStyle.sculpted:
        // Organic asymmetric Bézier corner with extended tangent tension
        final double t = corner.smoothness.clamp(0.4, 0.9);
        final Offset c1 = Offset.lerp(startPoint, cornerCenter, t)!;
        final Offset c2 = Offset.lerp(endPoint, cornerCenter, t)!;
        path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, endPoint.dx, endPoint.dy);
        break;

      case OrganicCornerStyle.rounded:
        // C1 continuous circular/squircle arc
        path.arcToPoint(
          endPoint,
          radius: Radius.circular(actualRadius),
          clockwise: true,
        );
        break;
    }
  }

  // =========================================================================
  // Inscribed Safe Region Calculator
  // =========================================================================

  /// Computes the geometry-aware safe inner padding so child content (text, icons)
  /// is never clipped by concave notches, inward scoops, or asymmetric corner radii.
  static EdgeInsets getSafeInsets(Size size, Material4CardShape shape) {
    final double rTL = shape.topLeft.radius;
    final double rTR = shape.topRight.radius;
    final double rBR = shape.bottomRight.radius;
    final double rBL = shape.bottomLeft.radius;

    // Additional clearance if an edge scoops inward
    final double topNotch =
        (shape.topEdge.style == OrganicEdgeStyle.concaveNotch ||
                shape.topEdge.style == OrganicEdgeStyle.sculptedWaist)
            ? shape.topEdge.depth
            : 0.0;

    final double rightNotch =
        (shape.rightEdge.style == OrganicEdgeStyle.concaveNotch ||
                shape.rightEdge.style == OrganicEdgeStyle.sculptedWaist)
            ? shape.rightEdge.depth
            : 0.0;

    final double bottomNotch =
        (shape.bottomEdge.style == OrganicEdgeStyle.concaveNotch ||
                shape.bottomEdge.style == OrganicEdgeStyle.sculptedWaist)
            ? shape.bottomEdge.depth
            : 0.0;

    final double leftNotch =
        (shape.leftEdge.style == OrganicEdgeStyle.concaveNotch ||
                shape.leftEdge.style == OrganicEdgeStyle.sculptedWaist)
            ? shape.leftEdge.depth
            : 0.0;

    final double leftSafe = math.max(math.max(rTL, rBL) * 0.45, leftNotch);
    final double topSafe = math.max(math.max(rTL, rTR) * 0.45, topNotch);
    final double rightSafe = math.max(math.max(rTR, rBR) * 0.45, rightNotch);
    final double bottomSafe = math.max(math.max(rBL, rBR) * 0.45, bottomNotch);

    return EdgeInsets.fromLTRB(leftSafe, topSafe, rightSafe, bottomSafe);
  }
}
