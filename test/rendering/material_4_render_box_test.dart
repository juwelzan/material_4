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

  group('RenderDynamicShape Comprehensive Constraint & Layout Tests', () {
    testWidgets('Unbounded width inside Row sizes to child width + safe insets',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              DynamicShapeContainer(
                config: const DynamicShapeConfig(
                  type: DynamicShapeType.folderTab,
                  tabHeight: 16,
                ),
                child: const SizedBox(width: 120, height: 40),
              ),
            ],
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderDynamicShape>(
        find.byType(DynamicShapeRenderWidget),
      );

      // Child is 120 wide; folderTab adds safe insets; size is finite and > 120
      expect(renderBox.size.width.isFinite, isTrue);
      expect(renderBox.size.width, greaterThan(120.0));
      expect(renderBox.size.height, greaterThanOrEqualTo(40.0));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Unbounded height inside Column sizes to child height + safe insets',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DynamicShapeContainer(
                config: const DynamicShapeConfig(
                  type: DynamicShapeType.notchedBadge,
                  tabHeight: 20,
                ),
                child: const SizedBox(width: 80, height: 50),
              ),
            ],
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderDynamicShape>(
        find.byType(DynamicShapeRenderWidget),
      );

      expect(renderBox.size.height.isFinite, isTrue);
      expect(renderBox.size.height, greaterThan(50.0));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Completely unbounded constraints handle intrinsic sizing cleanly',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: UnconstrainedBox(
            child: DynamicShapeContainer(
              config: const DynamicShapeConfig(type: DynamicShapeType.capsule),
              child: const SizedBox(width: 90, height: 35),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderDynamicShape>(
        find.byType(DynamicShapeRenderWidget),
      );

      expect(renderBox.size.width.isFinite, isTrue);
      expect(renderBox.size.height.isFinite, isTrue);
      expect(renderBox.size.width, greaterThanOrEqualTo(90.0));
      expect(renderBox.size.height, greaterThanOrEqualTo(35.0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Respects ShapeConstraints min and max dimensions',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 50, // requested 50, but min is 120
              height: 400, // requested 400, but max is 250
              config: const DynamicShapeConfig(
                type: DynamicShapeType.smoothRounded,
                constraints: ShapeConstraints(
                  minWidth: 120,
                  maxWidth: 250,
                  minHeight: 80,
                  maxHeight: 250,
                ),
              ),
              child: const SizedBox(width: 10, height: 10),
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderDynamicShape>(
        find.byType(DynamicShapeRenderWidget),
      );

      expect(renderBox.size.width, equals(120.0));
      expect(renderBox.size.height, equals(250.0));
    });

    testWidgets('Child alignment positions child within safe content region',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 200,
              height: 200,
              alignment: Alignment.bottomRight,
              config: const DynamicShapeConfig(
                type: DynamicShapeType.smoothRounded,
                cornerRadius: 0,
              ),
              padding: const EdgeInsets.all(10),
              child: const SizedBox(
                key: Key('aligned-child'),
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
      );

      final childBox = tester.renderObject<RenderBox>(
        find.byKey(const Key('aligned-child')),
      );
      final parentData = childBox.parentData as DynamicShapeParentData;

      // Container is 200x200, padding 10 all sides => available 180x180.
      // Child is 40x40.
      // Alignment.bottomRight => offset.dx = 10 + (180 - 40) = 150, offset.dy = 10 + (180 - 40) = 150.
      expect(parentData.offset.dx, closeTo(150.0, 1.0));
      expect(parentData.offset.dy, closeTo(150.0, 1.0));
    });

    testWidgets('Nested shape containers layout and render hierarchically',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 260,
              height: 160,
              config:
                  const DynamicShapeConfig(type: DynamicShapeType.folderTab),
              child: Center(
                child: DynamicShapeContainer(
                  width: 120,
                  height: 60,
                  config: const DynamicShapeConfig(
                      type: DynamicShapeType.notchedBadge),
                  child: const Text('Inner Shape'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(DynamicShapeRenderWidget), findsNWidgets(2));
      expect(find.text('Inner Shape'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('RenderDynamicShape Lifecycle & Invalidation Tests', () {
    testWidgets('Geometry config update triggers performLayout',
        (tester) async {
      final configNotifier = ValueNotifier<DynamicShapeConfig>(
        const DynamicShapeConfig(
          type: DynamicShapeType.folderTab,
          tabHeight: 14,
        ),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: ValueListenableBuilder<DynamicShapeConfig>(
              valueListenable: configNotifier,
              builder: (context, cfg, child) {
                return DynamicShapeContainer(
                  config: cfg,
                  child: const SizedBox(width: 80, height: 40),
                );
              },
            ),
          ),
        ),
      );

      final initialHeight = tester
          .renderObject<RenderDynamicShape>(
            find.byType(DynamicShapeRenderWidget),
          )
          .size
          .height;

      // Update geometry with much taller tab
      configNotifier.value = const DynamicShapeConfig(
        type: DynamicShapeType.folderTab,
        tabHeight: 40,
      );
      await tester.pumpAndSettle();

      final updatedHeight = tester
          .renderObject<RenderDynamicShape>(
            find.byType(DynamicShapeRenderWidget),
          )
          .size
          .height;

      expect(updatedHeight, greaterThan(initialHeight));
    });

    testWidgets('Paint-only config update triggers paint without relayout',
        (tester) async {
      final colorNotifier = ValueNotifier<Color>(Colors.red);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: ValueListenableBuilder<Color>(
              valueListenable: colorNotifier,
              builder: (context, col, child) {
                return DynamicShapeContainer(
                  width: 100,
                  height: 100,
                  color: col,
                  child: const Text('Paint Only'),
                );
              },
            ),
          ),
        ),
      );

      final renderBox = tester.renderObject<RenderDynamicShape>(
        find.byType(DynamicShapeRenderWidget),
      );
      expect(renderBox.color, equals(Colors.red));

      colorNotifier.value = Colors.blue;
      await tester.pump();

      expect(renderBox.color, equals(Colors.blue));
      expect(renderBox.size, equals(const Size(100, 100)));
    });

    testWidgets('Child replacement properly mounts new child', (tester) async {
      final childNotifier = ValueNotifier<Widget>(const Text('Child One'));

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ValueListenableBuilder<Widget>(
            valueListenable: childNotifier,
            builder: (context, ch, _) {
              return DynamicShapeContainer(
                width: 120,
                height: 60,
                child: ch,
              );
            },
          ),
        ),
      );

      expect(find.text('Child One'), findsOneWidget);

      childNotifier.value = const Text('Child Two');
      await tester.pumpAndSettle();

      expect(find.text('Child One'), findsNothing);
      expect(find.text('Child Two'), findsOneWidget);
    });
  });

  group('RenderDynamicShape Child & Transformed Hit Testing Tests', () {
    testWidgets('Child GestureDetector receives touch events inside shape',
        (tester) async {
      bool childTapped = false;
      bool containerTapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 200,
              height: 200,
              onTap: () => containerTapped = true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => childTapped = true,
                child: const SizedBox(
                  key: Key('tap-target'),
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(childTapped, isTrue);
      expect(containerTapped, isFalse);
    });

    testWidgets('Nested shape container child receives gesture events',
        (tester) async {
      bool innerTapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 280,
              height: 180,
              child: Center(
                child: DynamicShapeContainer(
                  width: 120,
                  height: 60,
                  onTap: () => innerTapped = true,
                  child: const Text('Inner Tap Target'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Inner Tap Target'));
      await tester.pumpAndSettle();

      expect(innerTapped, isTrue);
    });

    testWidgets(
        'Transformed shape (rotation) handles hit test via inverted matrix',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: DynamicShapeContainer(
              width: 100,
              height: 100,
              config: DynamicShapeConfig(
                type: DynamicShapeType.smoothRounded,
                transform: ShapeTransform.degrees(degrees: 45),
              ),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      final shapeFinder = find.byType(DynamicShapeRenderWidget);
      // Center of diamond/rotated square
      await tester.tapAt(tester.getCenter(shapeFinder));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
