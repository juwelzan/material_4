import 'dart:ui';
import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BezierSegmentConfig Tests', () {
    test('Constructs normalized cubic segment with defaults', () {
      const seg = BezierSegmentConfig(
        start: Offset.zero,
        control1: Offset(0.25, 0.5),
        control2: Offset(0.75, 0.5),
        end: Offset(1.0, 1.0),
      );

      expect(seg.isNormalized, isTrue);
      expect(seg.isFinite, isTrue);
      expect(seg.isDegenerate, isFalse);
    });

    test('Detects degenerate segments where all points collapse', () {
      const degenerateSeg = BezierSegmentConfig(
        start: Offset(0.5, 0.5),
        control1: Offset(0.5, 0.5),
        control2: Offset(0.5, 0.5),
        end: Offset(0.5, 0.5),
      );

      expect(degenerateSeg.isDegenerate, isTrue);
    });

    test('Allows intentional control points outside [0, 1] range', () {
      const segWithOvershoot = BezierSegmentConfig(
        start: Offset.zero,
        control1: Offset(-0.3, 1.5),
        control2: Offset(1.4, -0.2),
        end: Offset(1.0, 1.0),
      );

      expect(segWithOvershoot.isNormalized, isTrue);
      expect(segWithOvershoot.isFinite, isTrue);
      expect(segWithOvershoot.control1.dx, -0.3);
      expect(segWithOvershoot.control1.dy, 1.5);
    });

    test('Detects cubic loop self-intersection correctly', () {
      // Loop curve: crossing itself in parameter space t in (0, 1)
      const loopingSeg = BezierSegmentConfig(
        start: Offset(0.0, 0.0),
        control1: Offset(1.0, 2.0),
        control2: Offset(-1.0, 2.0),
        end: Offset(0.0, 0.0),
      );
      expect(loopingSeg.hasSelfIntersectionLoop(), isTrue);

      // Non-looping standard curve
      const standardSeg = BezierSegmentConfig(
        start: Offset(0.0, 0.0),
        control1: Offset(0.3, 0.1),
        control2: Offset(0.7, 0.9),
        end: Offset(1.0, 1.0),
      );
      expect(standardSeg.hasSelfIntersectionLoop(), isFalse);
    });

    test('Serialization round-trip for BezierSegmentConfig', () {
      const original = BezierSegmentConfig(
        start: Offset(0.1, 0.2),
        control1: Offset(0.3, 0.4),
        control2: Offset(0.5, 0.6),
        end: Offset(0.7, 0.8),
        isNormalized: true,
      );

      final json = original.toJson();
      final restored = BezierSegmentConfig.fromJson(json);

      expect(restored, equals(original));
      expect(restored.hashCode, equals(original.hashCode));
    });
  });

  group('CustomBezierConfig Tests', () {
    test('Validates continuity across multi-segment chain', () {
      const continuous = CustomBezierConfig(
        segments: [
          BezierSegmentConfig(
            start: Offset(0.0, 0.0),
            control1: Offset(0.2, 0.1),
            control2: Offset(0.3, 0.4),
            end: Offset(0.5, 0.5),
          ),
          BezierSegmentConfig(
            start: Offset(0.5, 0.5),
            control1: Offset(0.7, 0.6),
            control2: Offset(0.8, 0.9),
            end: Offset(1.0, 1.0),
          ),
        ],
      );

      expect(continuous.isContinuous, isTrue);
      expect(continuous.isFinite, isTrue);

      const discontinuous = CustomBezierConfig(
        segments: [
          BezierSegmentConfig(
            start: Offset(0.0, 0.0),
            control1: Offset(0.2, 0.1),
            control2: Offset(0.3, 0.4),
            end: Offset(0.5, 0.5),
          ),
          BezierSegmentConfig(
            start: Offset(0.6, 0.6), // Gap from 0.5, 0.5
            control1: Offset(0.7, 0.6),
            control2: Offset(0.8, 0.9),
            end: Offset(1.0, 1.0),
          ),
        ],
      );

      expect(discontinuous.isContinuous, isFalse);
    });

    test('toPath generates valid non-empty path from segments', () {
      const config = CustomBezierConfig(
        segments: [
          BezierSegmentConfig(
            start: Offset(0.0, 0.0),
            control1: Offset(0.5, 0.0),
            control2: Offset(1.0, 0.5),
            end: Offset(1.0, 1.0),
          ),
        ],
      );

      final path = config.toPath(const Size(200, 100));
      expect(path, isNotNull);
      final bounds = path.getBounds();
      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('Serialization round-trip for CustomBezierConfig', () {
      const original = CustomBezierConfig(
        segments: [
          BezierSegmentConfig(
            start: Offset(0.0, 0.0),
            control1: Offset(0.25, 0.5),
            control2: Offset(0.75, 0.5),
            end: Offset(1.0, 1.0),
          ),
        ],
        autoClose: true,
      );

      final json = original.toJson();
      final restored = CustomBezierConfig.fromJson(json);

      expect(restored, equals(original));
      expect(restored.hashCode, equals(original.hashCode));
    });
  });
}
