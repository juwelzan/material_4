import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_shape/dynamic_shape.dart';

void main() {
  group('RenderDynamicShape Layout & Sizing Tests', () {
    testWidgets('Sizing with explicit width and height', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 250,
              height: 120,
              config: const DynamicShapeConfig(type: DynamicShapeType.squircle),
              child: const Text('Explicit Size'),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderDynamicShape>(
        find.byType(DynamicShapeRenderWidget),
      );

      expect(renderBox.size.width, equals(250.0));
      expect(renderBox.size.height, equals(120.0));
    });

    testWidgets(
        'Sizing with loose constraints conforms to min intrinsic / constraints',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 50,
                maxWidth: 300,
                minHeight: 40,
                maxHeight: 200,
              ),
              child: DynamicShapeContainer(
                config:
                    const DynamicShapeConfig(type: DynamicShapeType.capsule),
                child: const SizedBox(width: 80, height: 30),
              ),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderDynamicShape>(
        find.byType(DynamicShapeRenderWidget),
      );

      // Child is 80x30, capsule shape adds safe insets, fits inside [50..300, 40..200]
      expect(renderBox.size.width, greaterThanOrEqualTo(80.0));
      expect(renderBox.size.height, greaterThanOrEqualTo(40.0));
      expect(renderBox.size.width, lessThanOrEqualTo(300.0));
      expect(renderBox.size.height, lessThanOrEqualTo(200.0));
    });

    testWidgets('Calculates intrinsic dimensions and dry layout correctly',
        (tester) async {
      final renderBox = RenderDynamicShape(
        config: const DynamicShapeConfig(type: DynamicShapeType.smoothRounded),
        child: RenderParagraph(
          const TextSpan(text: 'Intrinsic Text'),
          textDirection: TextDirection.ltr,
        ),
      );

      final minW = renderBox.computeMinIntrinsicWidth(50.0);
      final maxW = renderBox.computeMaxIntrinsicWidth(50.0);
      final minH = renderBox.computeMinIntrinsicHeight(100.0);
      final maxH = renderBox.computeMaxIntrinsicHeight(100.0);

      expect(minW, greaterThan(0.0));
      expect(maxW, greaterThanOrEqualTo(minW));
      expect(minH, greaterThan(0.0));
      expect(maxH, greaterThanOrEqualTo(minH));

      final drySize = renderBox.computeDryLayout(
          const BoxConstraints.tightFor(width: 200, height: 100));
      expect(drySize, equals(const Size(200, 100)));
    });
  });

  group('RenderDynamicShape Hit Testing Tests', () {
    testWidgets(
        'Point-in-path hit testing respects exact shape contour vs bounding box',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 200,
              height: 200,
              config: const DynamicShapeConfig(type: DynamicShapeType.diamond),
              hitTestBehavior: ShapeHitTestBehavior.shapeContour,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Tap top-left corner of bounding box (10, 10), which is outside a diamond contour
      final shapeFinder = find.byType(DynamicShapeRenderWidget);
      final topLeftOffset =
          tester.getTopLeft(shapeFinder) + const Offset(10, 10);
      await tester.tapAt(topLeftOffset);
      await tester.pumpAndSettle();
      expect(tapped, isFalse);

      // Tap center of diamond (100, 100), which is inside the contour
      final centerOffset = tester.getCenter(shapeFinder);
      await tester.tapAt(centerOffset);
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('Hit testing with boundingBox behavior accepts corner clicks',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 200,
              height: 200,
              config: const DynamicShapeConfig(type: DynamicShapeType.diamond),
              hitTestBehavior: ShapeHitTestBehavior.boundingBox,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      final shapeFinder = find.byType(DynamicShapeRenderWidget);
      final topLeftOffset =
          tester.getTopLeft(shapeFinder) + const Offset(10, 10);
      await tester.tapAt(topLeftOffset);
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });

  group('RenderDynamicShape Semantics & Accessibility Tests', () {
    testWidgets(
        'Interactive container reports button role in accessibility semantics',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: DynamicShapeContainer(
            width: 150,
            height: 50,
            onTap: () {},
            child: const Text('Accessible Button'),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(DynamicShapeRenderWidget)),
        matchesSemantics(
          isButton: true,
          hasTapAction: true,
          hasEnabledState: true,
          isEnabled: true,
        ),
      );

      handle.dispose();
    });
  });

  group('RenderDynamicShape Direct Canvas Painting Tests', () {
    testWidgets(
        'Renders solid color, borders, shadows, and neo-3D without errors',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RepaintBoundary(
            child: DynamicShapeContainer(
              width: 200,
              height: 100,
              color: Colors.amber,
              borderColor: Colors.black,
              borderWidth: 2.0,
              shadows: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
              ],
              config: const DynamicShapeConfig(
                type: DynamicShapeType.scallopedPetal,
                borderStyle: BorderStyleType.neo3d,
                neoColor: Colors.deepPurple,
                neoOffset: Offset(6, 6),
              ),
              child: const Text('Canvas Painted'),
            ),
          ),
        ),
      );

      expect(find.byType(DynamicShapeRenderWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders gradients, shimmer sweep, and patterns cleanly',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: DynamicShapeContainer(
            width: 220,
            height: 110,
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
            config: const DynamicShapeConfig(
              type: DynamicShapeType.waveEdge,
              pattern: ShapePattern.dotsMatrix,
              patternColor: Colors.white24,
              isShimmering: true,
              shimmerProgress: 0.5,
            ),
            child: const Icon(Icons.star, color: Colors.white),
          ),
        ),
      );

      expect(find.byType(DynamicShapeRenderWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
