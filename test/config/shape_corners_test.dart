import 'dart:ui';
import 'package:material_4/src/config/shape_corners.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShapeCorners Unit Tests', () {
    test('Constructors and default values', () {
      const defaultCorners = ShapeCorners();
      expect(defaultCorners.topLeft, Radius.zero);
      expect(defaultCorners.isZero, isTrue);

      final circular = ShapeCorners.circular(16.0);
      expect(circular.topLeft, const Radius.circular(16.0));
      expect(circular.bottomRight, const Radius.circular(16.0));
      expect(circular.isZero, isFalse);

      final elliptical = ShapeCorners.elliptical(20.0, 10.0);
      expect(elliptical.topLeft, const Radius.elliptical(20.0, 10.0));
      expect(elliptical.topRight.x, 20.0);
      expect(elliptical.topRight.y, 10.0);

      const asymmetric = ShapeCorners.asymmetric();
      expect(asymmetric.topLeft.x, 32.0);
      expect(asymmetric.topRight.x, 8.0);
    });

    test('Preserves original values and detects invalid/negative values', () {
      const invalid = ShapeCorners(
        topLeft: Radius.circular(-10),
        topRight: Radius.circular(double.nan),
      );
      expect(invalid.hasInvalidValues, isTrue);
      // Original values are strictly preserved
      expect(invalid.topLeft.x, -10);
      expect(invalid.topRight.x.isNaN, isTrue);

      // Sanitization handles it safely
      final sanitized = invalid.sanitize(const Size(100, 100));
      expect(sanitized.topLeft, Radius.zero);
      expect(sanitized.topRight, Radius.zero);
      expect(sanitized.hasInvalidValues, isFalse);
    });

    test('isSatisfiedBy checks bounds correctly', () {
      final corners = ShapeCorners.circular(20);
      expect(corners.isSatisfiedBy(const Size(50, 50)), isTrue);
      expect(
          corners.isSatisfiedBy(const Size(30, 50)), isFalse); // 20 + 20 > 30
      expect(
          corners.isSatisfiedBy(const Size(50, 30)), isFalse); // 20 + 20 > 30
    });

    test('CSS-style proportional radius down-scaling', () {
      // 60 + 60 = 120 width needed, but width is only 60. Factor = 60/120 = 0.5
      final large = ShapeCorners.circular(60);
      final sanitized = large.sanitize(const Size(60, 200));

      expect(sanitized.topLeft.x, 30.0);
      expect(sanitized.topRight.x, 30.0);
      expect(sanitized.bottomLeft.x, 30.0);
      expect(sanitized.bottomRight.x, 30.0);

      // Height constraint binds
      final heightConstrained = large.sanitize(const Size(200, 60));
      expect(heightConstrained.topLeft.y, 30.0);
      expect(heightConstrained.bottomLeft.y, 30.0);
    });

    test('Elliptical radii down-scaling retains aspect ratio', () {
      const elliptical = ShapeCorners.all(Radius.elliptical(80, 40));
      // Top sum is 160, width is 80 -> factor = 0.5
      final sanitized = elliptical.sanitize(const Size(80, 100));
      expect(sanitized.topLeft.x, 40.0);
      expect(sanitized.topLeft.y, 20.0);
    });

    test('Equality, hashCode, and JSON serialization', () {
      final c1 = ShapeCorners.circular(15);
      final c2 = ShapeCorners.circular(15);
      final c3 = ShapeCorners.circular(20);

      expect(c1, equals(c2));
      expect(c1.hashCode, equals(c2.hashCode));
      expect(c1 == c3, isFalse);

      final json = c1.toJson();
      final restored = ShapeCorners.fromJson(json);
      expect(restored, equals(c1));
    });
  });
}
