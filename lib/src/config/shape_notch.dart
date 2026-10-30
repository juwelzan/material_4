import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'shape_corners.dart';
import 'shape_edge_config.dart';

/// Collision and validation issue classifications for [ShapeNotch].
enum ShapeNotchCollisionType {
  /// Two or more notches overlap along the same edge.
  sameEdgeOverlap,

  /// Two notches from adjacent edges meet and collide at the corner.
  adjacentCornerOverlap,

  /// A notch encroaches into the rounded corner radius arc.
  cornerRadiusEncroachment,

  /// The notch exceeds the boundary length of the edge.
  edgeBoundaryOverflow,

  /// The notch depth exceeds the perpendicular dimension of the container.
  excessiveDepth,
}

/// Detailed collision record describing a notch layout issue.
@immutable
class ShapeNotchCollision {
  /// The type of collision or boundary constraint violation.
  final ShapeNotchCollisionType type;

  /// The primary notch causing or participating in the collision.
  final ShapeNotch notch;

  /// Secondary conflicting notch if collision is between multiple notches.
  final ShapeNotch? conflictingNotch;

  /// Human-readable diagnostic description of the conflict.
  final String message;

  /// Constructs a [ShapeNotchCollision] record.
  const ShapeNotchCollision({
    required this.type,
    required this.notch,
    this.conflictingNotch,
    required this.message,
  });

  @override
  String toString() => 'ShapeNotchCollision($type: $message)';
}

/// Diagnostic report containing detected notch collisions and recommended modifications.
@immutable
class ShapeNotchReport {
  /// All detected collisions or geometry violations.
  final List<ShapeNotchCollision> collisions;

  /// Sanitized notches with collisions resolved and bounds respected.
  /// User-defined notches are NOT silently moved; modifications are recorded in [collisions].
  final List<ShapeNotch> sanitizedNotches;

  /// Constructs a [ShapeNotchReport].
  const ShapeNotchReport({
    required this.collisions,
    required this.sanitizedNotches,
  });

  /// Whether any collisions or boundary violations were detected.
  bool get hasCollisions => collisions.isNotEmpty;
}

/// Defines the anchor position on a container for legacy and convenience placement.
enum ShapeAnchor {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  leftCenter,
  rightCenter,
  topCenter,
  bottomCenter,
  center,
}

/// Immutable specification for a cutout notch or protruding tab along a shape contour.
///
/// Fully supports normalized positioning, edge selection, custom depths,
/// corner fillets, inward/outward directions, and collision reporting.
@immutable
class ShapeNotch {
  /// The target edge along which this notch is positioned.
  final ShapeEdge edge;

  /// Normalized position along the target edge `[0.0 ... 1.0]`.
  /// For top/bottom edges, 0.0 is left, 1.0 is right.
  /// For left/right edges, 0.0 is top, 1.0 is bottom.
  final double positionFactor;

  /// Width of the notch cutout along the edge.
  final double width;

  /// Indentation depth perpendicular to the edge into (or out of) the container.
  final double depth;

  /// Corner fillet transition radius for smooth contour blending.
  final double cornerRadius;

  /// Fine absolute offset adjustment in pixels added to the normalized position.
  final double offset;

  /// True for an inward cavity pocket; false for an outward protruding tab.
  final bool isInward;

  /// Legacy anchor position preserved for 100% backward compatibility.
  final ShapeAnchor position;

  /// Optional identifier for tracking and collision reporting.
  final String? id;

  /// Whether this notch was constructed using modern normalized edge positioning.
  final bool isNormalizedPlacement;

  /// Full-parameter constructor supporting modern edge and normalized placement.
  const ShapeNotch({
    ShapeEdge? edge,
    this.positionFactor = 0.5,
    this.width = 80.0,
    double? depth,
    double? height,
    double? cornerRadius,
    double? filletRadius,
    this.offset = 0.0,
    this.isInward = true,
    ShapeAnchor? position,
    this.id,
  })  : isNormalizedPlacement = edge != null,
        edge = edge ??
            ((position == ShapeAnchor.bottomRight ||
                    position == ShapeAnchor.bottomLeft ||
                    position == ShapeAnchor.bottomCenter)
                ? ShapeEdge.bottom
                : (position == ShapeAnchor.leftCenter
                    ? ShapeEdge.left
                    : (position == ShapeAnchor.rightCenter
                        ? ShapeEdge.right
                        : ShapeEdge.top))),
        position = position ?? ShapeAnchor.topRight,
        depth = depth ?? height ?? 24.0,
        cornerRadius = cornerRadius ?? filletRadius ?? 12.0;

  /// Legacy constructor alias: returns depth as [height].
  double get height => depth;

  /// Legacy constructor alias: returns cornerRadius as [filletRadius].
  double get filletRadius => cornerRadius;

  /// Derives the target [ShapeEdge] from a legacy [ShapeAnchor].
  static ShapeEdge _deriveEdgeFromAnchor(ShapeAnchor anchor) {
    switch (anchor) {
      case ShapeAnchor.topRight:
      case ShapeAnchor.topLeft:
      case ShapeAnchor.topCenter:
        return ShapeEdge.top;
      case ShapeAnchor.bottomRight:
      case ShapeAnchor.bottomLeft:
      case ShapeAnchor.bottomCenter:
        return ShapeEdge.bottom;
      case ShapeAnchor.leftCenter:
        return ShapeEdge.left;
      case ShapeAnchor.rightCenter:
        return ShapeEdge.right;
      case ShapeAnchor.center:
        return ShapeEdge.top;
    }
  }

  /// Calculates the absolute start pixel coordinate along the target edge for [edgeLength].
  double resolveEdgeOffset(double edgeLength) {
    if (!isNormalizedPlacement) {
      if (position == ShapeAnchor.topRight ||
          position == ShapeAnchor.bottomRight) {
        // Legacy alignment from right side
        return edgeLength - width - offset;
      } else if (position == ShapeAnchor.topLeft ||
          position == ShapeAnchor.bottomLeft) {
        // Legacy alignment from left side
        return offset;
      }
    }
    // Modern normalized position centered on positionFactor
    return (edgeLength * positionFactor) - (width / 2.0) + offset;
  }

  /// Evaluates and reports collisions and boundary violations across all [notches] on [size].
  ///
  /// Detects:
  /// 1. Same-edge overlap between notches.
  /// 2. Adjacent-edge corner collisions.
  /// 3. Corner-radius encroachment.
  /// 4. Edge boundary overflow.
  /// 5. Excessive depth relative to the perpendicular container dimension.
  static ShapeNotchReport evaluateNotches({
    required List<ShapeNotch> notches,
    required Size size,
    ShapeCorners corners = ShapeCorners.zero,
  }) {
    if (notches.isEmpty || size.width <= 0 || size.height <= 0) {
      return ShapeNotchReport(collisions: const [], sanitizedNotches: notches);
    }

    final collisions = <ShapeNotchCollision>[];
    final sanitizedCorners = corners.sanitize(size);

    // Group notches by edge
    final edgeGroups = <ShapeEdge, List<ShapeNotch>>{
      ShapeEdge.top: [],
      ShapeEdge.right: [],
      ShapeEdge.bottom: [],
      ShapeEdge.left: [],
    };

    for (final notch in notches) {
      edgeGroups[notch.edge]!.add(notch);
    }

    // 1. Boundary, Excessive Depth, and Corner-Radius validation per notch
    for (final notch in notches) {
      final isHorizontal =
          notch.edge == ShapeEdge.top || notch.edge == ShapeEdge.bottom;
      final edgeLength = isHorizontal ? size.width : size.height;
      final perpLength = isHorizontal ? size.height : size.width;

      final startOffset = notch.resolveEdgeOffset(edgeLength);
      final endOffset = startOffset + notch.width;

      // Excessive depth check (depth exceeds perpendicular container dimension)
      if (notch.depth > perpLength) {
        collisions.add(
          ShapeNotchCollision(
            type: ShapeNotchCollisionType.excessiveDepth,
            notch: notch,
            message:
                'Notch depth (${notch.depth}) exceeds perpendicular dimension ($perpLength).',
          ),
        );
      }

      // Edge boundary validation
      if (startOffset < 0 || endOffset > edgeLength) {
        collisions.add(
          ShapeNotchCollision(
            type: ShapeNotchCollisionType.edgeBoundaryOverflow,
            notch: notch,
            message:
                'Notch span [$startOffset, $endOffset] overflows edge length ($edgeLength).',
          ),
        );
      }

      // Corner-radius encroachment check
      double cornerStartClamp = 0.0;
      double cornerEndClamp = 0.0;

      switch (notch.edge) {
        case ShapeEdge.top:
          cornerStartClamp = sanitizedCorners.topLeft.x;
          cornerEndClamp = edgeLength - sanitizedCorners.topRight.x;
          break;
        case ShapeEdge.bottom:
          cornerStartClamp = sanitizedCorners.bottomLeft.x;
          cornerEndClamp = edgeLength - sanitizedCorners.bottomRight.x;
          break;
        case ShapeEdge.left:
          cornerStartClamp = sanitizedCorners.topLeft.y;
          cornerEndClamp = edgeLength - sanitizedCorners.bottomLeft.y;
          break;
        case ShapeEdge.right:
          cornerStartClamp = sanitizedCorners.topRight.y;
          cornerEndClamp = edgeLength - sanitizedCorners.bottomRight.y;
          break;
      }

      if (startOffset < cornerStartClamp || endOffset > cornerEndClamp) {
        collisions.add(
          ShapeNotchCollision(
            type: ShapeNotchCollisionType.cornerRadiusEncroachment,
            notch: notch,
            message:
                'Notch span [$startOffset, $endOffset] encroaches into corner radius buffer [$cornerStartClamp, $cornerEndClamp].',
          ),
        );
      }
    }

    // 2. Same-edge collision detection
    for (final entry in edgeGroups.entries) {
      final edgeNotches = entry.value;
      final isHorizontal =
          entry.key == ShapeEdge.top || entry.key == ShapeEdge.bottom;
      final edgeLength = isHorizontal ? size.width : size.height;

      for (int i = 0; i < edgeNotches.length; i++) {
        final n1 = edgeNotches[i];
        final start1 = n1.resolveEdgeOffset(edgeLength);
        final end1 = start1 + n1.width;

        for (int j = i + 1; j < edgeNotches.length; j++) {
          final n2 = edgeNotches[j];
          final start2 = n2.resolveEdgeOffset(edgeLength);
          final end2 = start2 + n2.width;

          // Check overlap
          if (math.max(start1, start2) < math.min(end1, end2)) {
            collisions.add(
              ShapeNotchCollision(
                type: ShapeNotchCollisionType.sameEdgeOverlap,
                notch: n1,
                conflictingNotch: n2,
                message:
                    'Notch on ${entry.key} overlaps with another notch [$start1..$end1] vs [$start2..$end2].',
              ),
            );
          }
        }
      }
    }

    // 3. Adjacent-edge corner collision detection
    // e.g. top notch start < left notch depth, or top notch end > width - right notch depth
    for (final topNotch in edgeGroups[ShapeEdge.top]!) {
      final topStart = topNotch.resolveEdgeOffset(size.width);
      final topEnd = topStart + topNotch.width;

      for (final leftNotch in edgeGroups[ShapeEdge.left]!) {
        final leftStart = leftNotch.resolveEdgeOffset(size.height);
        if (topStart < leftNotch.depth && leftStart < topNotch.depth) {
          collisions.add(
            ShapeNotchCollision(
              type: ShapeNotchCollisionType.adjacentCornerOverlap,
              notch: topNotch,
              conflictingNotch: leftNotch,
              message:
                  'Top-left corner collision between top and left notches.',
            ),
          );
        }
      }

      for (final rightNotch in edgeGroups[ShapeEdge.right]!) {
        final rightStart = rightNotch.resolveEdgeOffset(size.height);
        if (topEnd > size.width - rightNotch.depth &&
            rightStart < topNotch.depth) {
          collisions.add(
            ShapeNotchCollision(
              type: ShapeNotchCollisionType.adjacentCornerOverlap,
              notch: topNotch,
              conflictingNotch: rightNotch,
              message:
                  'Top-right corner collision between top and right notches.',
            ),
          );
        }
      }
    }

    // Build sanitized notches (clamping dimensions safely without silent omission)
    final sanitized = notches.map((n) {
      final isHorizontal =
          n.edge == ShapeEdge.top || n.edge == ShapeEdge.bottom;
      final maxEdge = isHorizontal ? size.width : size.height;
      final maxDepth = isHorizontal ? size.height : size.width;

      final safeWidth = math.min(n.width, maxEdge);
      final safeDepth = math.min(n.depth, maxDepth);
      final safeFillet =
          math.min(n.cornerRadius, math.min(safeWidth, safeDepth) / 2.0);

      return n.copyWith(
        width: safeWidth,
        depth: safeDepth,
        cornerRadius: safeFillet,
      );
    }).toList();

    return ShapeNotchReport(
      collisions: collisions,
      sanitizedNotches: sanitized,
    );
  }

  /// Creates a copy with the given fields replaced.
  ShapeNotch copyWith({
    ShapeEdge? edge,
    double? positionFactor,
    double? width,
    double? depth,
    double? height,
    double? cornerRadius,
    double? filletRadius,
    double? offset,
    bool? isInward,
    ShapeAnchor? position,
    String? id,
    bool? isNormalizedPlacement,
  }) {
    return ShapeNotch(
      edge: edge ?? (isNormalizedPlacement == true ? this.edge : null),
      positionFactor: positionFactor ?? this.positionFactor,
      width: width ?? this.width,
      depth: depth ?? height ?? this.depth,
      cornerRadius: cornerRadius ?? filletRadius ?? this.cornerRadius,
      offset: offset ?? this.offset,
      isInward: isInward ?? this.isInward,
      position: position ?? this.position,
      id: id ?? this.id,
    );
  }

  /// Converts this [ShapeNotch] to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'edge': edge.name,
        'positionFactor': positionFactor,
        'width': width,
        'depth': depth,
        'height': depth,
        'cornerRadius': cornerRadius,
        'filletRadius': cornerRadius,
        'offset': offset,
        'isInward': isInward,
        'position': position.name,
        'isNormalizedPlacement': isNormalizedPlacement,
        if (id != null) 'id': id,
      };

  /// Constructs a [ShapeNotch] from serialized JSON data.
  factory ShapeNotch.fromJson(Map<String, dynamic> json) {
    final posStr = json['position'] as String?;
    final legacyPos = ShapeAnchor.values.firstWhere(
      (e) => e.name == posStr,
      orElse: () => ShapeAnchor.topRight,
    );

    final edgeStr = json['edge'] as String?;
    final isNorm = json['isNormalizedPlacement'] as bool? ?? (edgeStr != null);
    final edge = edgeStr != null
        ? ShapeEdge.values.firstWhere(
            (e) => e.name == edgeStr,
            orElse: () => _deriveEdgeFromAnchor(legacyPos),
          )
        : _deriveEdgeFromAnchor(legacyPos);

    return ShapeNotch(
      edge: isNorm ? edge : null,
      positionFactor: (json['positionFactor'] as num?)?.toDouble() ?? 0.5,
      width: (json['width'] as num?)?.toDouble() ?? 80.0,
      depth: (json['depth'] as num?)?.toDouble() ??
          (json['height'] as num?)?.toDouble() ??
          24.0,
      cornerRadius: (json['cornerRadius'] as num?)?.toDouble() ??
          (json['filletRadius'] as num?)?.toDouble() ??
          12.0,
      offset: (json['offset'] as num?)?.toDouble() ?? 0.0,
      isInward: json['isInward'] as bool? ?? true,
      position: legacyPos,
      id: json['id'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeNotch &&
          runtimeType == other.runtimeType &&
          edge == other.edge &&
          positionFactor == other.positionFactor &&
          width == other.width &&
          depth == other.depth &&
          cornerRadius == other.cornerRadius &&
          offset == other.offset &&
          isInward == other.isInward &&
          position == other.position &&
          isNormalizedPlacement == other.isNormalizedPlacement &&
          id == other.id;

  @override
  int get hashCode => Object.hash(
        edge,
        positionFactor,
        width,
        depth,
        cornerRadius,
        offset,
        isInward,
        position,
        isNormalizedPlacement,
        id,
      );
}
