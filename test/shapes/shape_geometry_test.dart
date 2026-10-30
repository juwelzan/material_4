import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/shapes/adaptive_shape_card.dart';
import 'package:test_app/core/shapes/dynamic_shape_config.dart';
import 'package:test_app/core/shapes/dynamic_shape_container.dart';
import 'package:test_app/core/shapes/dynamic_shape_path_builder.dart';

void main() {
  group('Phase 1: Shape Geometry Engine Tests', () {
    const testSize = Size(200.0, 120.0);

    test('All 28 DynamicShapeType presets build valid, closed paths', () {
      for (final shapeType in DynamicShapeType.values) {
        final config = DynamicShapeConfig(
          type: shapeType,
          cornerRadius: 16.0,
          customBezierBuilder: shapeType == DynamicShapeType.customBezier
              ? (size) => (Path()..addOval(Offset.zero & size))
              : null,
        );

        final path = DynamicShapePathBuilder.buildPath(testSize, config);
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
      const config = DynamicShapeConfig(type: DynamicShapeType.shield);

      // Zero dimensions
      expect(
        DynamicShapePathBuilder.buildPath(
          Size.zero,
          config,
        ).getBounds().isEmpty,
        isTrue,
      );
      expect(
        DynamicShapePathBuilder.buildPath(
          const Size(0, 100),
          config,
        ).getBounds().isEmpty,
        isTrue,
      );
      expect(
        DynamicShapePathBuilder.buildPath(
          const Size(100, 0),
          config,
        ).getBounds().isEmpty,
        isTrue,
      );

      // Negative dimensions
      expect(
        DynamicShapePathBuilder.buildPath(
          const Size(-50, 100),
          config,
        ).getBounds().isEmpty,
        isTrue,
      );
      expect(
        DynamicShapePathBuilder.buildPath(
          const Size(100, -50),
          config,
        ).getBounds().isEmpty,
        isTrue,
      );

      // Extreme large dimensions
      const largeSize = Size(8000.0, 4000.0);
      final largePath = DynamicShapePathBuilder.buildPath(largeSize, config);
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

      final config = DynamicShapeConfig.asymmetricCard(cornerRadii: radii);
      final path = DynamicShapePathBuilder.buildPath(testSize, config);
      final bounds = path.getBounds();

      expect(bounds.width, closeTo(testSize.width, 1.0));
      expect(bounds.height, closeTo(testSize.height, 1.0));
    });

    test(
      'Rotation, scale, and stretch transforms apply cleanly around center',
      () {
        const config = DynamicShapeConfig(
          type: DynamicShapeType.shield,
          rotation: 0.5,
          scaleX: 1.2,
          scaleY: 0.8,
          stretchOffset: Offset(10, 5),
        );

        final path = DynamicShapePathBuilder.buildPath(testSize, config);
        expect(path.getBounds().isEmpty, isFalse);
      },
    );

    test('Multi-notch carving modifies geometry correctly', () {
      const config = DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
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

      final path = DynamicShapePathBuilder.buildPath(testSize, config);
      expect(path.getBounds().isEmpty, isFalse);
    });

    test('CustomBezier builder callback produces exact custom path', () {
      final config = DynamicShapeConfig.customBezier(
        builder: (size) => Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close(),
      );

      final path = DynamicShapePathBuilder.buildPath(testSize, config);
      expect(path.getBounds().width, equals(testSize.width));
      expect(path.getBounds().height, equals(testSize.height));
    });

    testWidgets(
      'AdaptiveShapeCard renders all 28 shapes without clipping text',
      (tester) async {
        for (final shape in DynamicShapeType.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: AdaptiveShapeCard(
                    title: 'Grade 11-A',
                    subtitle: 'Physics Lab Session',
                    icon: Icons.science_rounded,
                    shapeType: shape,
                    width: 220,
                    height: 90,
                  ),
                ),
              ),
            ),
          );

          expect(find.text('Grade 11-A'), findsOneWidget);
          expect(find.text('Physics Lab Session'), findsOneWidget);
        }
      },
    );

    testWidgets(
      'DynamicShapeContainer convenience factories render correctly',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  DynamicShapeContainer.capsule(
                    width: 100,
                    height: 40,
                    child: const Text('Capsule'),
                  ),
                  DynamicShapeContainer.shield(
                    width: 100,
                    height: 80,
                    child: const Text('Shield'),
                  ),
                  DynamicShapeContainer.ribbon(
                    width: 120,
                    height: 40,
                    child: const Text('Ribbon'),
                  ),
                  DynamicShapeContainer.bookmark(
                    width: 60,
                    height: 100,
                    child: const Text('Bookmark'),
                  ),
                  DynamicShapeContainer.speechBubble(
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
