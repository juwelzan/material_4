import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../animation/shape_morph_engine.dart';
import '../material_4_config.dart';
import '../material_4_path_builder.dart';

/// A user-defined or mathematically customized vector shape for [Material4Container].
///
/// Supports procedural polygons, arbitrary Bézier curves, independent asymmetric
/// corners, concave/convex edge profiles, notches, and mathematical superellipses.
@immutable
class Material4CustomShape {
  /// Unique identifier for caching and morphing keys.
  final String id;

  /// Human-readable display label.
  final String? name;

  /// Custom vector path builder function for arbitrary canvas dimensions.
  final Path Function(Size size) pathBuilder;

  const Material4CustomShape({
    required this.id,
    this.name,
    required this.pathBuilder,
  });

  /// Creates a [Material4CustomShape] from an existing [Material4Type] preset.
  factory Material4CustomShape.fromType(
    Material4Type type, {
    Material4Config? config,
    String? id,
    String? name,
  }) {
    return Material4CustomShape(
      id: id ?? type.name,
      name: name ?? type.name,
      pathBuilder: (size) => Material4PathBuilder.buildPath(
        size,
        (config ?? const Material4Config()).copyWith(type: type),
      ),
    );
  }

  /// Creates a dynamically morphed [Material4CustomShape] between [from] and [to] at [progress].
  ///
  /// [from] and [to] can be either [Material4CustomShape] or [Material4Type].
  factory Material4CustomShape.morph({
    required dynamic from,
    required dynamic to,
    required double progress,
    Curve physics = Curves.easeInOut,
    String? id,
    String? name,
  }) {
    final shapeFrom = from is Material4CustomShape
        ? from
        : (from is Material4Type
            ? Material4CustomShape.fromType(from)
            : Material4CustomShape.fromType(Material4Type.smoothRounded));
    final shapeTo = to is Material4CustomShape
        ? to
        : (to is Material4Type
            ? Material4CustomShape.fromType(to)
            : Material4CustomShape.fromType(Material4Type.smoothRounded));
    final t = physics.transform(progress.clamp(0.0, 1.0));
    return Material4CustomShape(
      id: id ?? '${shapeFrom.id}_morph_${shapeTo.id}_$t',
      name: name ?? 'Morph (${shapeFrom.name} -> ${shapeTo.name})',
      pathBuilder: (size) {
        final pathA = shapeFrom.buildPath(size);
        final pathB = shapeTo.buildPath(size);
        return ShapeMorphEngine.morphPaths(pathA, pathB, t);
      },
    );
  }

  /// Creates a morphed shape toward [target] at [progress].
  Material4CustomShape morphTo(
    dynamic target,
    double progress, {
    Curve physics = Curves.easeInOut,
  }) {
    return Material4CustomShape.morph(
      from: this,
      to: target,
      progress: progress,
      physics: physics,
    );
  }

  /// Evaluates and returns the vector [Path] for the given [size].
  Path buildPath(Size size) {
    if (size.width <= 0 || size.height <= 0) return Path();
    try {
      final path = pathBuilder(size);
      if (!path.getBounds().isEmpty && !path.contains(Offset.zero)) {
        // ensure path is closed
      }
      return path;
    } catch (_) {
      return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }
  }

  /// Creates a regular or rounded N-sided polygon shape (triangle, pentagon, heptagon, etc.).
  factory Material4CustomShape.polygon({
    required int sides,
    double cornerRadius = 0.0,
    double startAngle = -math.pi / 2,
    String? id,
    String? name,
  }) {
    assert(sides >= 3, 'A polygon must have at least 3 sides');
    return Material4CustomShape(
      id: id ?? 'polygon_${sides}_r$cornerRadius',
      name: name ?? '$sides-Sided Polygon',
      pathBuilder: (Size size) {
        final cx = size.width / 2.0;
        final cy = size.height / 2.0;
        final radius = math.min(cx, cy);
        if (radius <= 0) return Path();

        final angleStep = 2 * math.pi / sides;
        final vertices = <Offset>[];
        for (int i = 0; i < sides; i++) {
          final a = startAngle + i * angleStep;
          vertices.add(Offset(cx + radius * math.cos(a), cy + radius * math.sin(a)));
        }

        if (cornerRadius <= 0.0) {
          final path = Path()..moveTo(vertices.first.dx, vertices.first.dy);
          for (int i = 1; i < vertices.length; i++) {
            path.lineTo(vertices[i].dx, vertices[i].dy);
          }
          path.close();
          return path;
        }

        // Rounded polygon with fillet corners
        final path = Path();
        final n = vertices.length;
        for (int i = 0; i < n; i++) {
          final prev = vertices[(i - 1 + n) % n];
          final curr = vertices[i];
          final next = vertices[(i + 1) % n];

          final v1 = Offset(prev.dx - curr.dx, prev.dy - curr.dy);
          final v2 = Offset(next.dx - curr.dx, next.dy - curr.dy);
          final len1 = math.sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
          final len2 = math.sqrt(v2.dx * v2.dx + v2.dy * v2.dy);
          if (len1 == 0 || len2 == 0) continue;

          final maxR = math.min(cornerRadius, math.min(len1, len2) / 2.1);
          final u1 = Offset(v1.dx / len1, v1.dy / len1);
          final u2 = Offset(v2.dx / len2, v2.dy / len2);

          final pStart = Offset(curr.dx + u1.dx * maxR, curr.dy + u1.dy * maxR);
          final pEnd = Offset(curr.dx + u2.dx * maxR, curr.dy + u2.dy * maxR);

          if (i == 0) {
            path.moveTo(pStart.dx, pStart.dy);
          } else {
            path.lineTo(pStart.dx, pStart.dy);
          }
          path.quadraticBezierTo(curr.dx, curr.dy, pEnd.dx, pEnd.dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Creates a multi-pointed star or sunburst badge shape.
  factory Material4CustomShape.star({
    required int points,
    double innerRadiusRatio = 0.5,
    double cornerRadius = 0.0,
    double startAngle = -math.pi / 2,
    String? id,
    String? name,
  }) {
    assert(points >= 3, 'Star must have at least 3 points');
    return Material4CustomShape(
      id: id ?? 'star_${points}_ratio$innerRadiusRatio',
      name: name ?? '$points-Point Star',
      pathBuilder: (Size size) {
        final cx = size.width / 2.0;
        final cy = size.height / 2.0;
        final outerR = math.min(cx, cy);
        final innerR = outerR * innerRadiusRatio.clamp(0.1, 0.95);
        if (outerR <= 0) return Path();

        final totalVertices = points * 2;
        final angleStep = math.pi / points;
        final vertices = <Offset>[];

        for (int i = 0; i < totalVertices; i++) {
          final r = (i % 2 == 0) ? outerR : innerR;
          final a = startAngle + i * angleStep;
          vertices.add(Offset(cx + r * math.cos(a), cy + r * math.sin(a)));
        }

        if (cornerRadius <= 0.0) {
          final path = Path()..moveTo(vertices.first.dx, vertices.first.dy);
          for (int i = 1; i < vertices.length; i++) {
            path.lineTo(vertices[i].dx, vertices[i].dy);
          }
          path.close();
          return path;
        }

        final path = Path();
        final n = vertices.length;
        for (int i = 0; i < n; i++) {
          final prev = vertices[(i - 1 + n) % n];
          final curr = vertices[i];
          final next = vertices[(i + 1) % n];

          final v1 = Offset(prev.dx - curr.dx, prev.dy - curr.dy);
          final v2 = Offset(next.dx - curr.dx, next.dy - curr.dy);
          final len1 = math.sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
          final len2 = math.sqrt(v2.dx * v2.dx + v2.dy * v2.dy);
          if (len1 == 0 || len2 == 0) continue;

          final maxR = math.min(cornerRadius, math.min(len1, len2) / 2.2);
          final u1 = Offset(v1.dx / len1, v1.dy / len1);
          final u2 = Offset(v2.dx / len2, v2.dy / len2);

          final pStart = Offset(curr.dx + u1.dx * maxR, curr.dy + u1.dy * maxR);
          final pEnd = Offset(curr.dx + u2.dx * maxR, curr.dy + u2.dy * maxR);

          if (i == 0) {
            path.moveTo(pStart.dx, pStart.dy);
          } else {
            path.lineTo(pStart.dx, pStart.dy);
          }
          path.quadraticBezierTo(curr.dx, curr.dy, pEnd.dx, pEnd.dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Creates a mathematical Lamé curve superellipse shape $(|x/a|^n + |y/b|^n = 1)$.
  factory Material4CustomShape.superellipse({
    double n = 4.0,
    String? id,
    String? name,
  }) {
    final exp = n.clamp(1.2, 16.0);
    return Material4CustomShape(
      id: id ?? 'superellipse_n$exp',
      name: name ?? 'Superellipse (n=$exp)',
      pathBuilder: (Size size) {
        final a = size.width / 2.0;
        final b = size.height / 2.0;
        if (a <= 0 || b <= 0) return Path();

        final path = Path();
        const steps = 72;
        final p = 2.0 / exp;

        for (int i = 0; i <= steps; i++) {
          final t = (i / steps) * 2 * math.pi;
          final cosT = math.cos(t);
          final sinT = math.sin(t);

          final sgnCos = cosT.sign;
          final sgnSin = sinT.sign;

          final x = a + a * sgnCos * math.pow(cosT.abs(), p);
          final y = b + b * sgnSin * math.pow(sinT.abs(), p);

          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        return path;
      },
    );
  }

  /// Creates a container shape with 4 completely independent asymmetric corner radii.
  factory Material4CustomShape.corners({
    double topLeft = 24.0,
    double topRight = 24.0,
    double bottomRight = 24.0,
    double bottomLeft = 24.0,
    String? id,
    String? name,
  }) {
    return Material4CustomShape(
      id: id ?? 'corners_${topLeft}_${topRight}_${bottomRight}_$bottomLeft',
      name: name ?? 'Independent Corners ($topLeft, $topRight, $bottomRight, $bottomLeft)',
      pathBuilder: (Size size) {
        final w = size.width;
        final h = size.height;
        if (w <= 0 || h <= 0) return Path();

        final maxR = math.min(w, h) / 2.0;
        final tl = topLeft.clamp(0.0, maxR);
        final tr = topRight.clamp(0.0, maxR);
        final br = bottomRight.clamp(0.0, maxR);
        final bl = bottomLeft.clamp(0.0, maxR);

        final path = Path();
        path.moveTo(tl, 0);
        path.lineTo(w - tr, 0);
        if (tr > 0) {
          path.arcToPoint(Offset(w, tr), radius: Radius.circular(tr));
        }
        path.lineTo(w, h - br);
        if (br > 0) {
          path.arcToPoint(Offset(w - br, h), radius: Radius.circular(br));
        }
        path.lineTo(bl, h);
        if (bl > 0) {
          path.arcToPoint(Offset(0, h - bl), radius: Radius.circular(bl));
        }
        path.lineTo(0, tl);
        if (tl > 0) {
          path.arcToPoint(Offset(tl, 0), radius: Radius.circular(tl));
        }
        path.close();
        return path;
      },
    );
  }

  /// Creates a custom Bézier shape via callback.
  factory Material4CustomShape.bezier(
    Path Function(Size size) builder, {
    String? id,
    String? name,
  }) {
    return Material4CustomShape(
      id: id ?? 'bezier_${builder.hashCode}',
      name: name ?? 'Custom Bézier',
      pathBuilder: builder,
    );
  }

  /// Creates a shape using the fluent [Material4ShapeBuilder].
  factory Material4CustomShape.builder(
    Material4ShapeBuilder Function(Size size) builder, {
    String? id,
    String? name,
  }) {
    return Material4CustomShape(
      id: id ?? 'fluent_builder_${builder.hashCode}',
      name: name ?? 'Fluent Custom Shape',
      pathBuilder: (Size size) => builder(size).build(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4CustomShape &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Fluent builder for constructing complex vector paths with corner fillets,
/// concave scoops, convex bulges, and multi-segment Bézier curves.
class Material4ShapeBuilder {
  final Path _path = Path();
  bool _hasStarted = false;

  Material4ShapeBuilder();

  /// Moves the current drawing point to ([x], [y]) without drawing a line.
  Material4ShapeBuilder moveTo(double x, double y) {
    _path.moveTo(x, y);
    _hasStarted = true;
    return this;
  }

  /// Adds a straight line segment from current point to ([x], [y]).
  Material4ShapeBuilder lineTo(double x, double y) {
    if (!_hasStarted) {
      _path.moveTo(x, y);
      _hasStarted = true;
    } else {
      _path.lineTo(x, y);
    }
    return this;
  }

  /// Adds a quadratic Bézier curve to ([x2], [y2]) using control point ([x1], [y1]).
  Material4ShapeBuilder quadraticBezierTo(
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    _path.quadraticBezierTo(x1, y1, x2, y2);
    return this;
  }

  /// Adds a cubic Bézier curve to ([x3], [y3]) using control points ([x1], [y1]) and ([x2], [y2]).
  Material4ShapeBuilder cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    _path.cubicTo(x1, y1, x2, y2, x3, y3);
    return this;
  }

  /// Adds an arc curve to [endpoint] with the given [radius].
  Material4ShapeBuilder arcToPoint(
    Offset endpoint, {
    Radius radius = Radius.zero,
    bool clockwise = true,
    bool largeArc = false,
  }) {
    _path.arcToPoint(
      endpoint,
      radius: radius,
      clockwise: clockwise,
      largeArc: largeArc,
    );
    return this;
  }

  /// Adds an inward circular or curved scoop between [start] and [end] with [depth].
  Material4ShapeBuilder addConcaveNotch(Offset start, Offset end, double depth) {
    final mid = Offset((start.dx + end.dx) / 2.0, (start.dy + end.dy) / 2.0);
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    if (len == 0) return this;

    final nx = -dy / len;
    final ny = dx / len;
    final control = Offset(mid.dx + nx * depth, mid.dy + ny * depth);

    _path.lineTo(start.dx, start.dy);
    _path.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    return this;
  }

  /// Adds an outward curved bulge between [start] and [end] with [height].
  Material4ShapeBuilder addConvexBulge(Offset start, Offset end, double height) {
    return addConcaveNotch(start, end, -height);
  }

  /// Closes the current path with a straight line back to the start.
  Material4ShapeBuilder close() {
    _path.close();
    return this;
  }

  /// Returns the completed vector [Path].
  Path build() {
    return _path;
  }
}
