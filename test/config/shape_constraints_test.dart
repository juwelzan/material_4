import 'dart:ui';
import 'package:dynamic_shape/src/config/shape_corners.dart';
import 'package:dynamic_shape/src/config/shape_constraints.dart';
import 'package:dynamic_shape/src/config/shape_edge_config.dart';
import 'package:dynamic_shape/src/config/shape_notch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShapeConstraints Unit Tests', () {
    test('Default and accessible presets', () {
      const constraints = ShapeConstraints();
      expect(constraints.minWidth, 4.0);
      expect(constraints.minHeight, 4.0);
      expect(constraints.maxNotchDepthRatio, 0.5);
      expect(constraints.enforceTouchTarget, isFalse);

      const accessible = ShapeConstraints.accessible;
      expect(accessible.minWidth, 48.0);
      expect(accessible.enforceTouchTarget, isTrue);
    });

    test('Dimension clamping without silent visual mutation', () {
      const constraints = ShapeConstraints(minWidth: 50.0, maxWidth: 200.0);
      final sizeSmall = constraints.clampSize(const Size(20.0, 100.0));
      expect(sizeSmall.width, 50.0);

      final sizeLarge = constraints.clampSize(const Size(300.0, 100.0));
      expect(sizeLarge.width, 200.0);
    });

    test('Touch-target accessibility diagnostics', () {
      const accessible = ShapeConstraints.accessible;
      final reportFail = accessible.evaluate(
        requestedSize: const Size(32.0, 32.0),
      );
      expect(reportFail.isSatisfied, isFalse);
      expect(
        reportFail.violations.any((v) => v.category == 'touchTarget'),
        isTrue,
      );

      final reportPass = accessible.evaluate(
        requestedSize: const Size(50.0, 50.0),
      );
      expect(reportPass.isSatisfied, isTrue);
    });

    test('Notch depth relative to perpendicular container dimension', () {
      const constraints = ShapeConstraints(maxNotchDepthRatio: 0.4);
      // Container height is 100. Max allowed notch depth on top edge is 100 * 0.4 = 40.
      const deepNotch = ShapeNotch(
        edge: ShapeEdge.top,
        width: 50.0,
        depth: 60.0, // 60 > 40
      );

      final report = constraints.evaluate(
        requestedSize: const Size(200.0, 100.0),
        notches: [deepNotch],
      );

      expect(report.isSatisfied, isFalse);
      expect(
        report.violations.any((v) => v.category == 'maxNotchDepthRatio'),
        isTrue,
      );
    });

    test('Maximum corner radius validation', () {
      const constraints = ShapeConstraints(maxCornerRadius: 20.0);
      const corners = ShapeCorners.all(Radius.circular(30.0)); // 30 > 20

      final report = constraints.evaluate(
        requestedSize: const Size(100.0, 100.0),
        corners: corners,
      );

      expect(report.isSatisfied, isFalse);
      expect(
        report.violations.any((v) => v.category == 'maxCornerRadius'),
        isTrue,
      );
    });

    test('Equality, hashCode, and JSON serialization', () {
      const sc1 = ShapeConstraints(minWidth: 10.0, maxNotchDepthRatio: 0.3);
      const sc2 = ShapeConstraints(minWidth: 10.0, maxNotchDepthRatio: 0.3);
      expect(sc1, equals(sc2));
      expect(sc1.hashCode, equals(sc2.hashCode));

      final json = sc1.toJson();
      final restored = ShapeConstraints.fromJson(json);
      expect(restored, equals(sc1));
    });
  });
}
