import 'dart:math' as math;
import 'package:material_4/src/config/shape_transform.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShapeTransform Unit Tests', () {
    test('Default identity transform', () {
      const transform = ShapeTransform.identity;
      expect(transform.hasTransform, isFalse);
      expect(transform.rotation, 0.0);
      expect(transform.scaleX, 1.0);
      expect(transform.scaleY, 1.0);
      expect(transform.skewX, 0.0);
      expect(transform.origin, Alignment.center);
    });

    test('Degrees constructor converts to radians', () {
      final transform = ShapeTransform.degrees(degrees: 90.0);
      expect(transform.rotation, closeTo(math.pi / 2, 1e-5));
      expect(transform.rotationDegrees, closeTo(90.0, 1e-5));
      expect(transform.hasTransform, isTrue);
    });

    test('Custom transformation origin and composition order', () {
      final transform = ShapeTransform(
        rotation: math.pi / 2,
        origin: Alignment.topLeft,
      );

      final matrix = transform.toMatrix4(const Size(100, 100));
      expect(matrix, isNotNull);

      // Hit-test transformation consistency
      final originalPoint = const Offset(10, 20);
      final localPoint = transform.transformPointForHitTest(
        originalPoint,
        const Size(100, 100),
      );
      expect(localPoint.dx.isFinite, isTrue);
      expect(localPoint.dy.isFinite, isTrue);
    });

    test('Separate aspect-ratio constraints', () {
      const transform = ShapeTransform(targetAspectRatio: 16.0 / 9.0);
      expect(transform.hasTransform,
          isFalse); // Aspect ratio doesn't trigger matrix transform

      final size = const Size(200, 200);
      final adjusted = transform.applyAspectRatio(size);
      expect(adjusted.width / adjusted.height, closeTo(16.0 / 9.0, 1e-4));
    });

    test('Finite and scale validations', () {
      const normal = ShapeTransform(scaleX: 1.5, scaleY: 0.8);
      expect(normal.isFinite, isTrue);
      expect(normal.hasNonZeroScale, isTrue);

      const zeroScale = ShapeTransform(scaleX: 0.0);
      expect(zeroScale.hasNonZeroScale, isFalse);

      const invalid = ShapeTransform(rotation: double.nan);
      expect(invalid.isFinite, isFalse);
    });

    test('Equality, hashCode, and JSON serialization', () {
      const t1 = ShapeTransform(rotation: 0.4, scaleX: 1.2);
      const t2 = ShapeTransform(rotation: 0.4, scaleX: 1.2);
      expect(t1, equals(t2));
      expect(t1.hashCode, equals(t2.hashCode));

      final json = t1.toJson();
      final restored = ShapeTransform.fromJson(json);
      expect(restored, equals(t1));
    });
  });
}
