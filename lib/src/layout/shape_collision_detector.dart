import 'dart:math' as math;
import 'package:flutter/rendering.dart';

import '../dynamic_shape_config.dart';

/// Comprehensive collision analysis report.
class ShapeCollisionReport {
  /// Whether any collisions, boundary breaches, or child-to-child overlaps were detected.
  final bool hasCollision;

  /// Human-readable diagnostic messages for every detected conflict.
  final List<String> collisions;

  /// Bounding rect of the combined overlapping region, if any.
  final Rect? overlappingRegion;

  /// Edges along which boundary collisions occurred.
  final List<ShapeEdge> collidingEdges;

  const ShapeCollisionReport({
    required this.hasCollision,
    this.collisions = const [],
    this.overlappingRegion,
    this.collidingEdges = const [],
  });

  static const safe = ShapeCollisionReport(hasCollision: false);

  @override
  String toString() =>
      'ShapeCollisionReport(hasCollision: $hasCollision, collisions: $collisions, edges: $collidingEdges)';
}

/// Collision detection engine that evaluates whether a widget's bounds intrude
/// upon inward notches, rounded corner arcs, stepped corners, shape cut-outs,
/// or other sibling children.
class ShapeCollisionDetector {
  const ShapeCollisionDetector._();

  /// Inspects whether [candidateRect] collides with [config] features or safe boundaries on [shapeSize].
  static ShapeCollisionReport detectCollision({
    required Rect candidateRect,
    required Size shapeSize,
    required DynamicShapeConfig config,
    EdgeInsets safeInsets = EdgeInsets.zero,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    if (shapeSize.width <= 0 || shapeSize.height <= 0) {
      return ShapeCollisionReport.safe;
    }

    final collisions = <String>[];
    final collidingEdges = <ShapeEdge>[];
    Rect? overlap;

    // 1. Boundary / Safe Inset Check
    final safeRect = Rect.fromLTWH(
      safeInsets.left,
      safeInsets.top,
      math.max(0.0, shapeSize.width - safeInsets.horizontal),
      math.max(0.0, shapeSize.height - safeInsets.vertical),
    );

    const tolerance = 0.1;
    if (candidateRect.left < safeRect.left - tolerance) {
      collisions.add(
          'Left boundary breach: ${candidateRect.left} < ${safeRect.left}');
      collidingEdges.add(ShapeEdge.left);
    }
    if (candidateRect.top < safeRect.top - tolerance) {
      collisions
          .add('Top boundary breach: ${candidateRect.top} < ${safeRect.top}');
      collidingEdges.add(ShapeEdge.top);
    }
    if (candidateRect.right > safeRect.right + tolerance) {
      collisions.add(
          'Right boundary breach: ${candidateRect.right} > ${safeRect.right}');
      collidingEdges.add(ShapeEdge.right);
    }
    if (candidateRect.bottom > safeRect.bottom + tolerance) {
      collisions.add(
          'Bottom boundary breach: ${candidateRect.bottom} > ${safeRect.bottom}');
      collidingEdges.add(ShapeEdge.bottom);
    }

    // 2. Inward Notches Check
    if (config.notches != null && config.notches!.isNotEmpty) {
      for (int i = 0; i < config.notches!.length; i++) {
        final notch = config.notches![i];
        if (!notch.isInward) continue;

        final notchRect = _computeNotchRect(notch, shapeSize);
        if (notchRect != null && candidateRect.overlaps(notchRect)) {
          collisions.add('Content overlaps inward notch #$i on ${notch.edge}.');
          final inter = candidateRect.intersect(notchRect);
          overlap = overlap == null ? inter : overlap.expandToInclude(inter);
          if (!collidingEdges.contains(notch.edge)) {
            collidingEdges.add(notch.edge);
          }
        }
      }
    }

    // 3. Stepped Corner Cutout Check
    if (config.type == DynamicShapeType.steppedCorner) {
      final cornerCutout = _computeSteppedCornerCutout(config, shapeSize);
      if (cornerCutout != null && candidateRect.overlaps(cornerCutout)) {
        collisions.add(
            'Content intrudes into stepped corner cutout zone ($cornerCutout).');
        final inter = candidateRect.intersect(cornerCutout);
        overlap = overlap == null ? inter : overlap.expandToInclude(inter);
      }
    }

    return ShapeCollisionReport(
      hasCollision: collisions.isNotEmpty,
      collisions: collisions,
      overlappingRegion: overlap,
      collidingEdges: collidingEdges,
    );
  }

  /// Detects whether any two bounding boxes in [childRects] overlap each other
  /// or breach [minSpacing] distance.
  static ShapeCollisionReport detectChildCollision({
    required List<Rect> childRects,
    double minSpacing = 0.0,
  }) {
    if (childRects.length <= 1) return ShapeCollisionReport.safe;

    final collisions = <String>[];
    Rect? overlap;

    for (int i = 0; i < childRects.length; i++) {
      for (int j = i + 1; j < childRects.length; j++) {
        final rectA = childRects[i];
        final rectB = childRects[j];

        final inflatedA =
            minSpacing > 0 ? rectA.inflate(minSpacing / 2.0) : rectA;
        if (inflatedA.overlaps(rectB)) {
          collisions.add(
            'Child #$i ($rectA) collides with Child #$j ($rectB) [spacing: $minSpacing dp].',
          );
          final inter = rectA.intersect(rectB);
          if (!inter.isEmpty) {
            overlap = overlap == null ? inter : overlap.expandToInclude(inter);
          }
        }
      }
    }

    return ShapeCollisionReport(
      hasCollision: collisions.isNotEmpty,
      collisions: collisions,
      overlappingRegion: overlap,
    );
  }

  /// Evaluates whether a docked badge collides with content or inward notches.
  static ShapeCollisionReport detectBadgeCollision({
    required Rect badgeRect,
    required Rect contentRect,
    required Size shapeSize,
    required DynamicShapeConfig config,
  }) {
    final collisions = <String>[];
    Rect? overlap;

    if (badgeRect.overlaps(contentRect)) {
      collisions.add(
          'Docked badge ($badgeRect) overlaps main content area ($contentRect).');
      overlap = badgeRect.intersect(contentRect);
    }

    // Check if badge accidentally falls into an inward notch intended as a cutout
    if (config.notches != null && config.notches!.isNotEmpty) {
      for (int i = 0; i < config.notches!.length; i++) {
        final notch = config.notches![i];
        if (!notch.isInward) continue;

        final notchRect = _computeNotchRect(notch, shapeSize);
        if (notchRect != null && badgeRect.overlaps(notchRect)) {
          // If badge was intended for this notch, it's safe; otherwise flag collision
          collisions
              .add('Badge encroaches upon inward notch #$i on ${notch.edge}.');
          final inter = badgeRect.intersect(notchRect);
          overlap = overlap == null ? inter : overlap.expandToInclude(inter);
        }
      }
    }

    return ShapeCollisionReport(
      hasCollision: collisions.isNotEmpty,
      collisions: collisions,
      overlappingRegion: overlap,
    );
  }

  static Rect? _computeNotchRect(ShapeNotch notch, Size size) {
    final edgeLength =
        (notch.edge == ShapeEdge.top || notch.edge == ShapeEdge.bottom)
            ? size.width
            : size.height;
    final center = edgeLength * notch.positionFactor + notch.offset;
    final halfWidth = notch.width / 2.0;

    switch (notch.edge) {
      case ShapeEdge.top:
        return Rect.fromLTRB(
          center - halfWidth,
          0.0,
          center + halfWidth,
          notch.depth,
        );
      case ShapeEdge.bottom:
        return Rect.fromLTRB(
          center - halfWidth,
          size.height - notch.depth,
          center + halfWidth,
          size.height,
        );
      case ShapeEdge.left:
        return Rect.fromLTRB(
          0.0,
          center - halfWidth,
          notch.depth,
          center + halfWidth,
        );
      case ShapeEdge.right:
        return Rect.fromLTRB(
          size.width - notch.depth,
          center - halfWidth,
          size.width,
          center + halfWidth,
        );
    }
  }

  static Rect? _computeSteppedCornerCutout(
      DynamicShapeConfig config, Size size) {
    final w = config.tabWidth;
    final h = config.tabHeight;
    switch (config.anchor) {
      case ShapeAnchor.bottomRight:
        return Rect.fromLTWH(size.width - w, size.height - h, w, h);
      case ShapeAnchor.bottomLeft:
        return Rect.fromLTWH(0, size.height - h, w, h);
      case ShapeAnchor.topRight:
        return Rect.fromLTWH(size.width - w, 0, w, h);
      case ShapeAnchor.topLeft:
        return Rect.fromLTWH(0, 0, w, h);
      default:
        return null;
    }
  }
}
