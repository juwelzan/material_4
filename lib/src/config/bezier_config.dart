import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';

/// Immutable specification for an individual Bézier segment (quadratic or cubic).
@immutable
class BezierSegmentConfig {
  /// Starting anchor point.
  final Offset start;

  /// Ending anchor point.
  final Offset end;

  /// First Bézier control point.
  final Offset controlPoint1;

  /// Optional second control point (if provided, segment is cubic; if null, quadratic).
  final Offset? controlPoint2;

  /// Whether coordinates are normalized to the unit interval `[0.0 ... 1.0]`
  /// relative to container dimensions. Note that intentional control points
  /// may extend outside `[0.0, 1.0]` to produce external crests or loops.
  final bool isNormalized;

  /// Constructs a quadratic or cubic Bézier segment.
  const BezierSegmentConfig({
    required this.start,
    required this.end,
    required this.controlPoint1,
    this.controlPoint2,
    this.isNormalized = false,
  });

  /// Whether this segment is a cubic curve with two distinct control points.
  bool get isCubic => controlPoint2 != null;

  /// Validates that all coordinates are finite numbers (not NaN or infinite).
  bool get isFinite =>
      start.dx.isFinite &&
      start.dy.isFinite &&
      end.dx.isFinite &&
      end.dy.isFinite &&
      controlPoint1.dx.isFinite &&
      controlPoint1.dy.isFinite &&
      (controlPoint2 == null ||
          (controlPoint2!.dx.isFinite && controlPoint2!.dy.isFinite));

  /// Detects whether the segment is geometrically degenerate (e.g., zero-length
  /// with control points collapsed onto the anchors, collapsing the curve into a point).
  bool get isDegenerate {
    if (!isFinite) return true;
    final isEndpointsEqual = (start - end).distanceSquared < 1e-9;
    final isCp1Equal = (start - controlPoint1).distanceSquared < 1e-9;
    final isCp2Equal =
        controlPoint2 == null || (start - controlPoint2!).distanceSquared < 1e-9;
    return isEndpointsEqual && isCp1Equal && isCp2Equal;
  }

  /// Resolves an [Offset] to absolute pixels based on container [size].
  Offset resolvePoint(Offset pt, Size size) {
    if (!isNormalized) return pt;
    return Offset(pt.dx * size.width, pt.dy * size.height);
  }

  /// Appends this curve segment to an existing [Path].
  void appendToPath(Path path, Size size) {
    final s = resolvePoint(start, size);
    final e = resolvePoint(end, size);
    final cp1 = resolvePoint(controlPoint1, size);

    if (isCubic) {
      final cp2 = resolvePoint(controlPoint2!, size);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, e.dx, e.dy);
    } else {
      path.quadraticBezierTo(cp1.dx, cp1.dy, e.dx, e.dy);
    }
  }

  /// Checks if the cubic segment has an internal self-intersection loop.
  ///
  /// For planar cubic Bézier curves, a self-intersection loop occurs if and only if
  /// the discriminant of the canonical polynomial parametrization satisfies $\Delta > 0$.
  /// Returns `true` if a loop self-intersection is geometrically detected.
  bool hasSelfIntersectionLoop() {
    if (!isCubic || isDegenerate || !isFinite) return false;

    // Convert to canonical power basis: B(t) = P0 + 3*t*(P1 - P0) + 3*t^2*(P2 - 2*P1 + P0) + t^3*(P3 - 3*P2 + 3*P1 - P0)
    final p0 = start;
    final p1 = controlPoint1;
    final p2 = controlPoint2!;
    final p3 = end;

    final a = p3 - p2 * 3.0 + p1 * 3.0 - p0;
    final b = (p2 - p1 * 2.0 + p0) * 3.0;
    final c = (p1 - p0) * 3.0;

    // A planar cubic has a loop if and only if:
    // d_x = a.dx * b.dy - a.dy * b.dx
    // d_y = a.dx * c.dy - a.dy * c.dx
    // d_z = b.dx * c.dy - b.dy * c.dx
    // discriminant: Delta = 4 * d_x * d_z - d_y^2 > 0
    final d0 = a.dx * b.dy - a.dy * b.dx;
    final d1 = a.dx * c.dy - a.dy * c.dx;
    final d2 = b.dx * c.dy - b.dy * c.dx;

    final discriminant = 4.0 * d0 * d2 - d1 * d1;

    // When discriminant > 0, the curve has real self-intersection parameters
    if (discriminant > 1e-9 && d0.abs() > 1e-9) {
      final sqrtD = math.sqrt(discriminant);
      final r1 = (-d1 - sqrtD) / (2.0 * d0);
      final r2 = (-d1 + sqrtD) / (2.0 * d0);
      // Valid loop if both parameter values are strictly within (0, 1) and distinct
      return r1 > 0.0 && r1 < 1.0 && r2 > 0.0 && r2 < 1.0 && (r1 - r2).abs() > 1e-4;
    }
    return false;
  }

  /// Creates a copy with the given fields replaced.
  BezierSegmentConfig copyWith({
    Offset? start,
    Offset? end,
    Offset? controlPoint1,
    Offset? controlPoint2,
    bool? isNormalized,
  }) {
    return BezierSegmentConfig(
      start: start ?? this.start,
      end: end ?? this.end,
      controlPoint1: controlPoint1 ?? this.controlPoint1,
      controlPoint2: controlPoint2 ?? this.controlPoint2,
      isNormalized: isNormalized ?? this.isNormalized,
    );
  }

  /// Converts this [BezierSegmentConfig] to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
    'start': {'dx': start.dx, 'dy': start.dy},
    'end': {'dx': end.dx, 'dy': end.dy},
    'cp1': {'dx': controlPoint1.dx, 'dy': controlPoint1.dy},
    'cp2': controlPoint2 != null
        ? {'dx': controlPoint2!.dx, 'dy': controlPoint2!.dy}
        : null,
    'isNormalized': isNormalized,
  };

  /// Constructs a [BezierSegmentConfig] from serialized JSON data.
  factory BezierSegmentConfig.fromJson(Map<String, dynamic> json) {
    Offset parseOffset(Map<String, dynamic> map) => Offset(
      (map['dx'] as num).toDouble(),
      (map['dy'] as num).toDouble(),
    );

    return BezierSegmentConfig(
      start: parseOffset(json['start'] as Map<String, dynamic>),
      end: parseOffset(json['end'] as Map<String, dynamic>),
      controlPoint1: parseOffset(json['cp1'] as Map<String, dynamic>),
      controlPoint2: json['cp2'] != null
          ? parseOffset(json['cp2'] as Map<String, dynamic>)
          : null,
      isNormalized: json['isNormalized'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BezierSegmentConfig &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          controlPoint1 == other.controlPoint1 &&
          controlPoint2 == other.controlPoint2 &&
          isNormalized == other.isNormalized;

  @override
  int get hashCode => Object.hash(
    start,
    end,
    controlPoint1,
    controlPoint2,
    isNormalized,
  );
}

/// Immutable multi-segment Bézier contour path configuration.
@immutable
class CustomBezierConfig {
  /// Sequence of Bézier segments defining the path.
  final List<BezierSegmentConfig> segments;

  /// Whether the path should be automatically closed back to the start point.
  final bool autoClose;

  /// Constructs a [CustomBezierConfig] with the given segments.
  const CustomBezierConfig({
    this.segments = const [],
    this.autoClose = true,
  });

  /// Validates that all segments contain finite numbers.
  bool get isFinite => segments.every((s) => s.isFinite);

  /// Validates geometric continuity (end of segment `i` matches start of segment `i+1`).
  bool get isContinuous {
    if (segments.length <= 1) return true;
    for (int i = 0; i < segments.length - 1; i++) {
      final currentEnd = segments[i].end;
      final nextStart = segments[i + 1].start;
      if ((currentEnd - nextStart).distanceSquared > 1e-5) {
        return false;
      }
    }
    return true;
  }

  /// Detects whether any segment has a self-intersection loop.
  bool hasSelfIntersections() {
    return segments.any((s) => s.hasSelfIntersectionLoop());
  }

  /// Builds a [Path] from the segment chain.
  Path toPath(Size size) {
    if (segments.isEmpty || size.width <= 0 || size.height <= 0) {
      return Path();
    }

    final path = Path();
    final firstStart = segments.first.resolvePoint(segments.first.start, size);
    path.moveTo(firstStart.dx, firstStart.dy);

    for (final segment in segments) {
      segment.appendToPath(path, size);
    }

    if (autoClose) {
      path.close();
    }

    return path;
  }

  /// Converts this [CustomBezierConfig] to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
    'segments': segments.map((s) => s.toJson()).toList(),
    'autoClose': autoClose,
  };

  /// Constructs a [CustomBezierConfig] from serialized JSON data.
  factory CustomBezierConfig.fromJson(Map<String, dynamic> json) {
    return CustomBezierConfig(
      segments: (json['segments'] as List?)
              ?.map((e) => BezierSegmentConfig.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      autoClose: json['autoClose'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomBezierConfig &&
          runtimeType == other.runtimeType &&
          listEquals(segments, other.segments) &&
          autoClose == other.autoClose;

  @override
  int get hashCode => Object.hash(Object.hashAll(segments), autoClose);
}
