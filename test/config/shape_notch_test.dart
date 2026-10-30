import 'dart:ui';
import 'package:dynamic_shape/src/config/shape_corners.dart';
import 'package:dynamic_shape/src/config/shape_edge_config.dart';
import 'package:dynamic_shape/src/config/shape_notch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShapeNotch & Collision Engine Unit Tests', () {
    test('100% Backward compatibility with legacy constructor', () {
      const legacy = ShapeNotch(
        position: ShapeAnchor.topRight,
        width: 80.0,
        height: 24.0,
        filletRadius: 12.0,
        offset: 10.0,
        isInward: true,
      );

      expect(legacy.width, 80.0);
      expect(legacy.height, 24.0);
      expect(legacy.depth, 24.0);
      expect(legacy.filletRadius, 12.0);
      expect(legacy.cornerRadius, 12.0);
      expect(legacy.edge, ShapeEdge.top);
      expect(legacy.position, ShapeAnchor.topRight);
    });

    test('Modern edge and normalized placement calculation', () {
      const notch = ShapeNotch(
        edge: ShapeEdge.top,
        positionFactor: 0.5,
        width: 60.0,
        depth: 20.0,
      );

      // On width 200, centered position is 200 * 0.5 - 30 = 70
      final offset = notch.resolveEdgeOffset(200.0);
      expect(offset, 70.0);
    });

    test('Detects same-edge collisions', () {
      const n1 = ShapeNotch(
        edge: ShapeEdge.top,
        positionFactor: 0.4,
        width: 80.0,
      );
      const n2 = ShapeNotch(
        edge: ShapeEdge.top,
        positionFactor: 0.5,
        width: 80.0,
      );

      final report = ShapeNotch.evaluateNotches(
        notches: [n1, n2],
        size: const Size(200, 100),
      );

      expect(report.hasCollisions, isTrue);
      expect(
        report.collisions.any(
          (c) => c.type == ShapeNotchCollisionType.sameEdgeOverlap,
        ),
        isTrue,
      );
    });

    test('Detects edge boundary overflow and excessive depth', () {
      const overflowing = ShapeNotch(
        edge: ShapeEdge.top,
        positionFactor: 0.9,
        width: 100.0, // Overflows beyond width 200
        depth: 150.0, // Exceeds height 100
      );

      final report = ShapeNotch.evaluateNotches(
        notches: [overflowing],
        size: const Size(200, 100),
      );

      expect(report.hasCollisions, isTrue);
      expect(
        report.collisions.any(
          (c) => c.type == ShapeNotchCollisionType.edgeBoundaryOverflow,
        ),
        isTrue,
      );
      expect(
        report.collisions.any(
          (c) => c.type == ShapeNotchCollisionType.excessiveDepth,
        ),
        isTrue,
      );
    });

    test('Detects corner-radius encroachment', () {
      const nearCorner = ShapeNotch(
        edge: ShapeEdge.top,
        positionFactor: 0.1,
        width: 40.0, // starts at 200*0.1 - 20 = 0.0
      );
      // Top-left corner has radius 30
      final corners = ShapeCorners.circular(30.0);

      final report = ShapeNotch.evaluateNotches(
        notches: [nearCorner],
        size: const Size(200, 100),
        corners: corners,
      );

      expect(report.hasCollisions, isTrue);
      expect(
        report.collisions.any(
          (c) => c.type == ShapeNotchCollisionType.cornerRadiusEncroachment,
        ),
        isTrue,
      );
    });

    test('Equality, hashCode, and JSON serialization', () {
      const notch1 = ShapeNotch(
        edge: ShapeEdge.bottom,
        positionFactor: 0.3,
        width: 50.0,
        depth: 18.0,
      );
      const notch2 = ShapeNotch(
        edge: ShapeEdge.bottom,
        positionFactor: 0.3,
        width: 50.0,
        depth: 18.0,
      );

      expect(notch1, equals(notch2));
      expect(notch1.hashCode, equals(notch2.hashCode));

      final json = notch1.toJson();
      final restored = ShapeNotch.fromJson(json);
      expect(restored, equals(notch1));
    });
  });
}
