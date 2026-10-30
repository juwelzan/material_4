import 'dart:math' as math;
import 'package:flutter/rendering.dart';

import '../material_4_config.dart';

/// Collision handling policy when sibling children or boundaries conflict.
enum ShapeCollisionPolicy {
  /// Allow child overlapping without modification (e.g. decorative stacked layers).
  allow,

  /// Issue a diagnostic warning while leaving child coordinates untouched.
  warn,

  /// Nudge/reposition child along the layout axis to the next collision-free coordinate.
  reposition,

  /// Constrain or clip child dimensions to strictly prevent overlapping.
  prevent,
}

/// Diagnostic severity classification.
enum ShapeDiagnosticSeverity {
  info,
  warning,
  error,
}

/// Diagnostic report describing child placement issues, collisions, or boundary breaches.
class ShapeLayoutDiagnostic {
  /// Index of the child within the parent container.
  final int childIndex;

  /// Diagnostic explanation message.
  final String message;

  /// Severity level of this diagnostic.
  final ShapeDiagnosticSeverity severity;

  /// Candidate rectangle where child was attempted to be placed.
  final Rect? candidateRect;

  /// Safe boundary rect against which placement was tested.
  final Rect? safeRegion;

  const ShapeLayoutDiagnostic({
    required this.childIndex,
    required this.message,
    this.severity = ShapeDiagnosticSeverity.warning,
    this.candidateRect,
    this.safeRegion,
  });

  @override
  String toString() =>
      'ShapeLayoutDiagnostic(#$childIndex: $message, severity: $severity)';
}

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
    required Material4Config config,
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
    if (config.type == Material4Type.steppedCorner) {
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
    required Material4Config config,
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

  /// Verifies whether two rectangular child bounds overlap.
  static bool hasOverlap(Rect a, Rect b) => a.overlaps(b);

  /// Attempts to resolve child overlapping according to [policy].
  ///
  /// In [ShapeCollisionPolicy.reposition] mode, shifts [candidateRect] downward
  /// (or rightward) by increments of [spacing] until it no longer overlaps [placedRects]
  /// or hits [safeBounds]. Returns the resolved rect and whether it was repositioned.
  static ({Rect rect, bool repositioned, bool collisionAvoided})
      resolveChildPosition({
    required Rect candidateRect,
    required List<Rect> placedRects,
    required Rect safeBounds,
    ShapeCollisionPolicy policy = ShapeCollisionPolicy.reposition,
    double spacing = 8.0,
    Axis direction = Axis.vertical,
  }) {
    if (policy == ShapeCollisionPolicy.allow || placedRects.isEmpty) {
      return (
        rect: candidateRect,
        repositioned: false,
        collisionAvoided: true,
      );
    }

    bool hasOverlap = false;
    for (final placed in placedRects) {
      if (candidateRect.overlaps(placed)) {
        hasOverlap = true;
        break;
      }
    }

    if (!hasOverlap) {
      return (
        rect: candidateRect,
        repositioned: false,
        collisionAvoided: true,
      );
    }

    if (policy == ShapeCollisionPolicy.warn) {
      return (
        rect: candidateRect,
        repositioned: false,
        collisionAvoided: false,
      );
    }

    if (policy == ShapeCollisionPolicy.reposition) {
      var current = candidateRect;
      const maxAttempts = 20;
      for (int i = 0; i < maxAttempts; i++) {
        if (direction == Axis.vertical) {
          current = current.shift(Offset(0, spacing));
        } else {
          current = current.shift(Offset(spacing, 0));
        }

        // Must remain inside safeBounds
        if (!safeBounds.contains(current.topLeft) ||
            !safeBounds.contains(current.bottomRight)) {
          break; // cannot reposition further inside safeBounds
        }

        bool collision = false;
        for (final placed in placedRects) {
          if (current.overlaps(placed)) {
            collision = true;
            break;
          }
        }
        if (!collision) {
          return (
            rect: current,
            repositioned: true,
            collisionAvoided: true,
          );
        }
      }
    }

    return (
      rect: candidateRect,
      repositioned: false,
      collisionAvoided: false,
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

  static Rect? _computeSteppedCornerCutout(Material4Config config, Size size) {
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
