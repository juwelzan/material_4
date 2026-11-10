import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

/// Tight bounds of the actual outline (Path.getBounds includes control points).
Rect _outlineBounds(Path path) {
  double l = double.infinity, t = double.infinity;
  double r = double.negativeInfinity, b = double.negativeInfinity;
  for (final metric in path.computeMetrics()) {
    for (double d = 0; d <= metric.length; d += 0.25) {
      final p = metric.getTangentForOffset(d)!.position;
      if (p.dx < l) l = p.dx;
      if (p.dx > r) r = p.dx;
      if (p.dy < t) t = p.dy;
      if (p.dy > b) b = p.dy;
    }
  }
  return l.isFinite ? Rect.fromLTRB(l, t, r, b) : Rect.zero;
}

void main() {
  const sizes = [
    Size(200, 120),
    Size(120, 200),
    Size(320, 56),
    Size(56, 320),
    Size(40, 40),
    Size(24, 24),
    Size(400, 400),
  ];

  group('Every preset stays inside its container', () {
    for (final type in Material4Type.values) {
      test(type.name, () {
        for (final size in sizes) {
          final path = Material4PathBuilder.buildPath(
            size,
            Material4Config(type: type),
            useCache: false,
          );
          final bounds = _outlineBounds(path);
          expect(bounds.isEmpty, isFalse, reason: '$size is empty');
          expect(
            bounds.left >= -0.5 &&
                bounds.top >= -0.5 &&
                bounds.right <= size.width + 0.5 &&
                bounds.bottom <= size.height + 0.5,
            isTrue,
            reason: '$size overflows: $bounds',
          );
        }
      });
    }
  });

  test('superellipse follows superellipseExponent', () {
    const size = Size(100, 100);
    Path build(double n) => Material4PathBuilder.buildPath(
          size,
          Material4Config(
              type: Material4Type.superellipse, superellipseExponent: n),
          useCache: false,
        );
    // A squarer exponent fills more of the corner.
    expect(build(2).contains(const Offset(10, 10)), isFalse);
    expect(build(10).contains(const Offset(10, 10)), isTrue);
  });

  test('tag shape has a punched hole', () {
    const size = Size(200, 80);
    final path = Material4PathBuilder.buildPath(
        size, const Material4Config(type: Material4Type.tag),
        useCache: false);
    expect(path.contains(const Offset(30, 40)), isFalse);
    expect(path.contains(const Offset(120, 40)), isTrue);
  });

  group('Custom shape identity includes every geometric parameter', () {
    test('polygon start angle', () {
      expect(
        Material4CustomShape.polygon(sides: 6),
        isNot(Material4CustomShape.polygon(sides: 6, startAngle: 0)),
      );
    });
    test('star corner radius', () {
      expect(
        Material4CustomShape.star(points: 5),
        isNot(Material4CustomShape.star(points: 5, cornerRadius: 4)),
      );
    });
    test('fromType config', () {
      expect(
        Material4CustomShape.fromType(Material4Type.smoothRounded,
            config: const Material4Config(cornerRadius: 4)),
        isNot(Material4CustomShape.fromType(Material4Type.smoothRounded,
            config: const Material4Config(cornerRadius: 30))),
      );
    });
  });
}
