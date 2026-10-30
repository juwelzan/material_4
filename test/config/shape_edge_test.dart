import 'dart:ui';
import 'package:material_4/src/config/bezier_config.dart';
import 'package:material_4/src/config/shape_edge_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShapeEdgeConfig & ShapeEdges Unit Tests', () {
    test('Constructors and default values', () {
      const straight = ShapeEdgeConfig.straight();
      expect(straight.isStraight, isTrue);
      expect(straight.style, ShapeEdgeStyle.straight);

      const convex = ShapeEdgeConfig.convex(depth: 24.0);
      expect(convex.isStraight, isFalse);
      expect(convex.style, ShapeEdgeStyle.convex);
      expect(convex.depth, 24.0);

      const wave = ShapeEdgeConfig.wave(waveCount: 4.0, waveAmplitude: 12.0);
      expect(wave.style, ShapeEdgeStyle.wave);
      expect(wave.waveCount, 4.0);
      expect(wave.waveAmplitude, 12.0);

      const zigzag = ShapeEdgeConfig.zigzag(toothWidth: 10.0, depth: 6.0);
      expect(zigzag.style, ShapeEdgeStyle.zigzag);
      expect(zigzag.toothWidth, 10.0);
      expect(zigzag.depth, 6.0);
    });

    test('ShapeEdges composite container configurations', () {
      const allStraight = ShapeEdges.straight;
      expect(allStraight.isAllStraight, isTrue);

      const mixed = ShapeEdges(
        top: ShapeEdgeConfig.convex(depth: 20),
        bottom: ShapeEdgeConfig.zigzag(toothWidth: 10),
      );
      expect(mixed.isAllStraight, isFalse);
      expect(mixed.top.style, ShapeEdgeStyle.convex);
      expect(mixed.bottom.style, ShapeEdgeStyle.zigzag);
      expect(mixed.left.isStraight, isTrue);
      expect(mixed.right.isStraight, isTrue);

      const symmetric = ShapeEdges.symmetric(
        horizontal: ShapeEdgeConfig.wave(waveCount: 2),
      );
      expect(symmetric.top.style, ShapeEdgeStyle.wave);
      expect(symmetric.bottom.style, ShapeEdgeStyle.wave);
    });

    test('Equality, hashCode, and JSON serialization', () {
      const e1 = ShapeEdgeConfig.convex(depth: 15.0);
      const e2 = ShapeEdgeConfig.convex(depth: 15.0);
      expect(e1, equals(e2));
      expect(e1.hashCode, equals(e2.hashCode));

      final json = e1.toJson();
      final restored = ShapeEdgeConfig.fromJson(json);
      expect(restored, equals(e1));

      const edges1 = ShapeEdges(top: ShapeEdgeConfig.wave(waveCount: 3));
      const edges2 = ShapeEdges(top: ShapeEdgeConfig.wave(waveCount: 3));
      expect(edges1, equals(edges2));

      final edgesJson = edges1.toJson();
      final edgesRestored = ShapeEdges.fromJson(edgesJson);
      expect(edgesRestored, equals(edges1));
    });
  });

  group('BezierSegmentConfig & CustomBezierConfig Unit Tests', () {
    test('Validates finite numbers and detects degenerate segments', () {
      const normal = BezierSegmentConfig(
        start: Offset.zero,
        end: Offset(100, 100),
        controlPoint1: Offset(50, 0),
      );
      expect(normal.isFinite, isTrue);
      expect(normal.isDegenerate, isFalse);

      const invalid = BezierSegmentConfig(
        start: Offset.zero,
        end: Offset(double.nan, 100),
        controlPoint1: Offset(50, 0),
      );
      expect(invalid.isFinite, isFalse);
      expect(invalid.isDegenerate, isTrue);

      // Collapsed degenerate segment
      const degenerate = BezierSegmentConfig(
        start: Offset(10, 10),
        end: Offset(10, 10),
        controlPoint1: Offset(10, 10),
      );
      expect(degenerate.isDegenerate, isTrue);
    });

    test('Continuity and path conversion', () {
      const seg1 = BezierSegmentConfig(
        start: Offset(0, 0),
        end: Offset(50, 50),
        controlPoint1: Offset(25, 0),
      );
      const seg2 = BezierSegmentConfig(
        start: Offset(50, 50),
        end: Offset(100, 0),
        controlPoint1: Offset(75, 50),
      );
      const broken = BezierSegmentConfig(
        start: Offset(60, 50),
        end: Offset(100, 0),
        controlPoint1: Offset(80, 50),
      );

      final curve = CustomBezierConfig(segments: [seg1, seg2]);
      expect(curve.isContinuous, isTrue);

      final brokenCurve = CustomBezierConfig(segments: [seg1, broken]);
      expect(brokenCurve.isContinuous, isFalse);

      final path = curve.toPath(const Size(100, 100));
      expect(path, isNotNull);
    });

    test('Geometric cubic loop self-intersection detection', () {
      // Non-intersecting standard curve
      const clean = BezierSegmentConfig(
        start: Offset(0, 0),
        end: Offset(100, 0),
        controlPoint1: Offset(30, 50),
        controlPoint2: Offset(70, 50),
      );
      expect(clean.hasSelfIntersectionLoop(), isFalse);

      // Curve where control points cross over creating a loop (inflection loop)
      const looping = BezierSegmentConfig(
        start: Offset(0, 0),
        end: Offset(100, 0),
        controlPoint1: Offset(120, 80),
        controlPoint2: Offset(-20, 80),
      );
      expect(looping.hasSelfIntersectionLoop(), isTrue);
    });
  });
}
