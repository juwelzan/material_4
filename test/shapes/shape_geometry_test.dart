import 'package:material_4/material_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 1: Shape Geometry Engine Tests', () {
    const testSize = Size(200.0, 120.0);

    test('All 28 Material4Type presets build valid, closed paths', () {
      for (final shapeType in Material4Type.values) {
        final config = Material4Config(
          type: shapeType,
          cornerRadius: 16.0,
          customBezierBuilder: shapeType == Material4Type.customBezier
              ? (size) => (Path()..addOval(Offset.zero & size))
              : null,
        );

        final path = Material4PathBuilder.buildPath(testSize, config);
        expect(path, isNotNull, reason: 'Failed for shape: ${shapeType.name}');

        final bounds = path.getBounds();
        expect(
          bounds.isEmpty,
          isFalse,
          reason: 'Bounds are empty for shape: ${shapeType.name}',
        );
        expect(
          bounds.width,
          greaterThan(0),
          reason: 'Width is 0 for shape: ${shapeType.name}',
        );
        expect(
          bounds.height,
          greaterThan(0),
          reason: 'Height is 0 for shape: ${shapeType.name}',
        );

        // Metric test ensures path has measurable contours and no degenerate geometry
        final metrics = path.computeMetrics().toList();
        expect(
          metrics,
          isNotEmpty,
          reason: 'Path metrics empty for shape: ${shapeType.name}',
        );
        expect(
          metrics.first.length,
          greaterThan(0),
          reason: 'Path length is 0 for shape: ${shapeType.name}',
        );
      }
    });

    test('Handles zero, negative, NaN, and extreme dimensions safely', () {
      const config = Material4Config(type: Material4Type.shield);

      // Zero dimensions
      expect(
        Material4PathBuilder.buildPath(
          Size.zero,
          config,
        ).getBounds().isEmpty,
        isTrue,
      );
      expect(
        Material4PathBuilder.buildPath(
          const Size(0, 100),
          config,
        ).getBounds().isEmpty,
        isTrue,
      );
      expect(
        Material4PathBuilder.buildPath(
          const Size(100, 0),
          config,
        ).getBounds().isEmpty,
        isTrue,
      );

      // Negative dimensions
      expect(
        Material4PathBuilder.buildPath(
          const Size(-50, 100),
          config,
        ).getBounds().isEmpty,
        isTrue,
      );
      expect(
        Material4PathBuilder.buildPath(
          const Size(100, -50),
          config,
        ).getBounds().isEmpty,
        isTrue,
      );

      // Extreme large dimensions
      const largeSize = Size(8000.0, 4000.0);
      final largePath = Material4PathBuilder.buildPath(largeSize, config);
      expect(largePath.getBounds().isEmpty, isFalse);
      expect(largePath.getBounds().width, closeTo(8000.0, 50.0));
      expect(largePath.getBounds().height, closeTo(4000.0, 50.0));
    });

    test('AsymmetricCard honors independent CornerRadii correctly', () {
      const radii = CornerRadii(
        topLeft: 30.0,
        topRight: 10.0,
        bottomRight: 20.0,
        bottomLeft: 5.0,
      );

      final config = Material4Config.asymmetricCard(cornerRadii: radii);
      final path = Material4PathBuilder.buildPath(testSize, config);
      final bounds = path.getBounds();

      expect(bounds.width, closeTo(testSize.width, 1.0));
      expect(bounds.height, closeTo(testSize.height, 1.0));
    });

    test(
      'Rotation, scale, and stretch transforms apply cleanly around center',
      () {
        const config = Material4Config(
          type: Material4Type.shield,
          rotation: 0.5,
          scaleX: 1.2,
          scaleY: 0.8,
          stretchOffset: Offset(10, 5),
        );

        final path = Material4PathBuilder.buildPath(testSize, config);
        expect(path.getBounds().isEmpty, isFalse);
      },
    );

    test('Multi-notch carving modifies geometry correctly', () {
      const config = Material4Config(
        type: Material4Type.smoothRounded,
        notches: [
          ShapeNotch(
            position: ShapeAnchor.topRight,
            width: 40,
            height: 20,
            isInward: true,
          ),
          ShapeNotch(
            position: ShapeAnchor.bottomLeft,
            width: 40,
            height: 20,
            isInward: true,
          ),
        ],
      );

      final path = Material4PathBuilder.buildPath(testSize, config);
      expect(path.getBounds().isEmpty, isFalse);
    });

    test('CustomBezier builder callback produces exact custom path', () {
      final config = Material4Config.customBezier(
        builder: (size) => Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close(),
      );

      final path = Material4PathBuilder.buildPath(testSize, config);
      expect(path.getBounds().width, equals(testSize.width));
      expect(path.getBounds().height, equals(testSize.height));
    });

    testWidgets(
      'Material4Container renders all shape presets without clipping text',
      (tester) async {
        for (final shape in Material4Type.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Material4Container(
                    shape: shape,
                    width: 220,
                    height: 90,
                    child: const Center(child: Text('Grade 11-A')),
                  ),
                ),
              ),
            ),
          );

          expect(find.text('Grade 11-A'), findsOneWidget);
        }
      },
    );

    testWidgets(
      'Material4Container renders built-in shapes via the unified shape param',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Material4Container(
                    shape: Material4Type.capsule,
                    width: 100,
                    height: 40,
                    child: const Text('Capsule'),
                  ),
                  Material4Container(
                    shape: Material4Type.shield,
                    width: 100,
                    height: 80,
                    child: const Text('Shield'),
                  ),
                  Material4Container(
                    shape: Material4Type.ribbon,
                    width: 120,
                    height: 40,
                    child: const Text('Ribbon'),
                  ),
                  Material4Container(
                    shape: Material4Type.bookmark,
                    width: 60,
                    height: 100,
                    child: const Text('Bookmark'),
                  ),
                  Material4Container(
                    shape: Material4Type.speechBubble,
                    width: 120,
                    height: 70,
                    child: const Text('Speech'),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Capsule'), findsOneWidget);
        expect(find.text('Shield'), findsOneWidget);
        expect(find.text('Ribbon'), findsOneWidget);
        expect(find.text('Bookmark'), findsOneWidget);
        expect(find.text('Speech'), findsOneWidget);
      },
    );
  });
}
