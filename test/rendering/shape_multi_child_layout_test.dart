import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('ShapeSafeRegionSet Multi-Region Partitioning Engine', () {
    test('Simple smoothRounded container computes single primary safe region',
        () {
      const config = Material4Config(
        type: Material4Type.smoothRounded,
        cornerRadius: 12.0,
      );
      const size = Size(200, 100);
      final set = ShapeSafeRegion.computeSafeRegionSet(
        size: size,
        config: config,
      );

      expect(set.isMultiRegion, isFalse);
      expect(set.regions.length, equals(1));
      expect(set.primary.left, greaterThanOrEqualTo(0));
      expect(set.primary.top, greaterThanOrEqualTo(0));
      expect(set.primary.right, lessThanOrEqualTo(200));
      expect(set.primary.bottom, lessThanOrEqualTo(100));
    });

    test('Shape with top inward notch partitions into flanking pockets', () {
      const config = Material4Config(
        type: Material4Type.smoothRounded,
        notches: [
          ShapeNotch(
            edge: ShapeEdge.top,
            positionFactor: 0.5,
            width: 40.0,
            depth: 30.0,
            isInward: true,
          ),
        ],
      );
      const size = Size(200, 100);
      final set = ShapeSafeRegion.computeSafeRegionSet(
        size: size,
        config: config,
      );

      expect(set.isMultiRegion, isTrue);
      expect(set.regions.length, greaterThanOrEqualTo(2));
      // First region after primary is the left pocket
      final leftPocket = set.regions[1];
      expect(leftPocket.right, lessThanOrEqualTo(100));
      // If right pocket exists
      if (set.regions.length > 2) {
        final rightPocket = set.regions[2];
        expect(rightPocket.left, greaterThanOrEqualTo(100));
      }
    });

    test('Ticket scallop partitions into upper and lower compartments', () {
      const config = Material4Config(
        type: Material4Type.ticketScallop,
        scallopRadius: 16.0,
      );
      const size = Size(200, 200);
      final set = ShapeSafeRegion.computeSafeRegionSet(
        size: size,
        config: config,
      );

      expect(set.isMultiRegion, isTrue);
      // Regions contain primary, upper stub, and lower body
      expect(set.regions.length, greaterThanOrEqualTo(3));
      final upper = set.regions[1];
      final lower = set.regions[2];
      expect(upper.bottom, lessThanOrEqualTo(lower.top));
    });

    test('Folder tab partitions into header tab and card body', () {
      const config = Material4Config(
        type: Material4Type.folderTab,
        tabWidth: 60.0,
        tabHeight: 25.0,
      );
      const size = Size(200, 150);
      final set = ShapeSafeRegion.computeSafeRegionSet(
        size: size,
        config: config,
      );

      expect(set.isMultiRegion, isTrue);
      final tabRegion = set.regions[1];
      expect(tabRegion.height, closeTo(26.0, 1.5));
    });

    test('Stepped corner cutouts partition safe shelf and core body', () {
      const config = Material4Config(
        type: Material4Type.steppedCorner,
        tabWidth: 30.0,
        tabHeight: 30.0,
        anchor: ShapeAnchor.topRight,
      );
      const size = Size(200, 150);
      final set = ShapeSafeRegion.computeSafeRegionSet(
        size: size,
        config: config,
      );

      expect(set.regions, isNotEmpty);
      expect(set.primary.width, greaterThan(0));
      expect(set.primary.height, greaterThan(0));
    });
  });

  group('ShapeCollisionDetector & Collision Policies', () {
    test('Detects intersecting rects and reports collision correctly', () {
      const rectA = Rect.fromLTWH(10, 10, 50, 50);
      const rectB = Rect.fromLTWH(30, 30, 50, 50);

      expect(ShapeCollisionDetector.hasOverlap(rectA, rectB), isTrue);

      const nonOverlap = Rect.fromLTWH(70, 70, 20, 20);
      expect(ShapeCollisionDetector.hasOverlap(rectA, nonOverlap), isFalse);
    });

    test('Reposition policy shifts overlapping sibling to resolve collision',
        () {
      final existingRects = [
        const Rect.fromLTWH(20, 20, 40, 40),
      ];
      const candidateRect = Rect.fromLTWH(30, 20, 40, 40);
      const safeBounds = Rect.fromLTWH(0, 0, 300, 300);

      final result = ShapeCollisionDetector.resolveChildPosition(
        candidateRect: candidateRect,
        placedRects: existingRects,
        safeBounds: safeBounds,
        policy: ShapeCollisionPolicy.reposition,
        spacing: 5.0,
      );

      expect(ShapeCollisionDetector.hasOverlap(result.rect, existingRects[0]),
          isFalse);
      expect(safeBounds.contains(result.rect.topLeft), isTrue);
      expect(safeBounds.contains(result.rect.bottomRight), isTrue);
    });

    test('Allow policy preserves original overlapping coordinates', () {
      final existingRects = [
        const Rect.fromLTWH(20, 20, 40, 40),
      ];
      const candidateRect = Rect.fromLTWH(30, 20, 40, 40);
      const safeBounds = Rect.fromLTWH(0, 0, 300, 300);

      final result = ShapeCollisionDetector.resolveChildPosition(
        candidateRect: candidateRect,
        placedRects: existingRects,
        safeBounds: safeBounds,
        policy: ShapeCollisionPolicy.allow,
        spacing: 5.0,
      );

      expect(result.rect, equals(candidateRect));
    });
  });

  group('Material4Stack Multi-Child Layout Strategies', () {
    testWidgets('Stack strategy aligns children to specified alignments',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Stack(
              config: const Material4Config(
                type: Material4Type.smoothRounded,
              ),
              width: 300,
              height: 200,
              layoutStrategy: ShapeLayoutStrategy.stack,
              children: const [
                ShapeChild(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    key: ValueKey('child_top_left'),
                    width: 40,
                    height: 40,
                  ),
                ),
                ShapeChild(
                  alignment: Alignment.center,
                  child: SizedBox(
                    key: ValueKey('child_center'),
                    width: 60,
                    height: 60,
                  ),
                ),
                ShapeChild(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    key: ValueKey('child_bottom_right'),
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('child_top_left')), findsOneWidget);
      expect(find.byKey(const ValueKey('child_center')), findsOneWidget);
      expect(find.byKey(const ValueKey('child_bottom_right')), findsOneWidget);

      final topLeftRect =
          tester.getRect(find.byKey(const ValueKey('child_top_left')));
      final centerRect =
          tester.getRect(find.byKey(const ValueKey('child_center')));
      final bottomRightRect =
          tester.getRect(find.byKey(const ValueKey('child_bottom_right')));

      expect(topLeftRect.left, lessThan(centerRect.left));
      expect(topLeftRect.top, lessThan(centerRect.top));
      expect(centerRect.right, lessThan(bottomRightRect.right));
      expect(centerRect.bottom, lessThan(bottomRightRect.bottom));
    });

    testWidgets('Vertical flow strategy stacks children with spacing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Stack(
              config: const Material4Config(
                type: Material4Type.smoothRounded,
              ),
              width: 200,
              height: 300,
              layoutStrategy: ShapeLayoutStrategy.flowVertical,
              spacing: 12.0,
              children: const [
                SizedBox(
                  key: ValueKey('item_1'),
                  width: 100,
                  height: 30,
                ),
                SizedBox(
                  key: ValueKey('item_2'),
                  width: 100,
                  height: 40,
                ),
                SizedBox(
                  key: ValueKey('item_3'),
                  width: 100,
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      );

      final r1 = tester.getRect(find.byKey(const ValueKey('item_1')));
      final r2 = tester.getRect(find.byKey(const ValueKey('item_2')));
      final r3 = tester.getRect(find.byKey(const ValueKey('item_3')));

      // Verify vertical progression and spacing
      expect(r2.top, closeTo(r1.bottom + 12.0, 1.0));
      expect(r3.top, closeTo(r2.bottom + 12.0, 1.0));
    });

    testWidgets(
        'Horizontal flow strategy aligns children horizontally with spacing',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Stack(
              config: const Material4Config(
                type: Material4Type.smoothRounded,
              ),
              width: 300,
              height: 100,
              layoutStrategy: ShapeLayoutStrategy.flowHorizontal,
              spacing: 10.0,
              children: const [
                SizedBox(
                  key: ValueKey('h_item_1'),
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  key: ValueKey('h_item_2'),
                  width: 50,
                  height: 40,
                ),
                SizedBox(
                  key: ValueKey('h_item_3'),
                  width: 60,
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      );

      final r1 = tester.getRect(find.byKey(const ValueKey('h_item_1')));
      final r2 = tester.getRect(find.byKey(const ValueKey('h_item_2')));
      final r3 = tester.getRect(find.byKey(const ValueKey('h_item_3')));

      // Verify horizontal progression and spacing
      expect(r2.left, closeTo(r1.right + 10.0, 1.0));
      expect(r3.left, closeTo(r2.right + 10.0, 1.0));
    });

    testWidgets('Anchor strategy docks children to shape landmarks',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Stack(
              config: const Material4Config(
                type: Material4Type.smoothRounded,
              ),
              width: 200,
              height: 200,
              layoutStrategy: ShapeLayoutStrategy.anchor,
              children: const [
                ShapeChild.anchor(
                  anchor: ShapeAnchor.topLeft,
                  child: SizedBox(
                    key: ValueKey('anchor_tl'),
                    width: 30,
                    height: 30,
                  ),
                ),
                ShapeChild.anchor(
                  anchor: ShapeAnchor.center,
                  child: SizedBox(
                    key: ValueKey('anchor_c'),
                    width: 30,
                    height: 30,
                  ),
                ),
                ShapeChild.anchor(
                  anchor: ShapeAnchor.bottomRight,
                  child: SizedBox(
                    key: ValueKey('anchor_br'),
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final tl = tester.getRect(find.byKey(const ValueKey('anchor_tl')));
      final c = tester.getRect(find.byKey(const ValueKey('anchor_c')));
      final br = tester.getRect(find.byKey(const ValueKey('anchor_br')));

      expect(tl.center.dx, lessThan(c.center.dx));
      expect(tl.center.dy, lessThan(c.center.dy));
      expect(c.center.dx, lessThan(br.center.dx));
      expect(c.center.dy, lessThan(br.center.dy));
    });

    testWidgets(
        'Adaptive layout distributes children across safe regions by priority',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Stack(
              config: const Material4Config(
                type: Material4Type.ticketScallop,
                scallopRadius: 16.0,
              ),
              width: 200,
              height: 200,
              layoutStrategy: ShapeLayoutStrategy.adaptive,
              children: const [
                ShapeChild(
                  priority: 10,
                  child: SizedBox(
                    key: ValueKey('primary_child'),
                    width: 80,
                    height: 40,
                  ),
                ),
                ShapeChild(
                  priority: 1,
                  child: SizedBox(
                    key: ValueKey('secondary_child'),
                    width: 60,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('primary_child')), findsOneWidget);
      expect(find.byKey(const ValueKey('secondary_child')), findsOneWidget);
    });
  });

  group('Content Protection Modes & Diagnostics', () {
    testWidgets(
        'Strict mode records diagnostics for overflowing children without deleting them',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Stack(
              config: const Material4Config(
                type: Material4Type.smoothRounded,
              ),
              width: 100,
              height: 100,
              contentProtection: const ShapeContentProtection(
                mode: ShapeContentMode.strict,
              ),
              layoutStrategy: ShapeLayoutStrategy.stack,
              children: const [
                ShapeChild(
                  alignment: Alignment.center,
                  allowOverflow: true,
                  child: SizedBox(
                    key: ValueKey('large_child'),
                    width: 150,
                    height: 150,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // In strict mode, the widget must still be rendered and visible in tree
      expect(find.byKey(const ValueKey('large_child')), findsOneWidget);

      final renderObject = tester.renderObject<RenderMultiChildMaterial4>(
        find.byType(Material4MultiChildRenderWidget),
      );
      expect(renderObject.diagnostics, isNotEmpty);
      expect(
        renderObject.diagnostics.any((d) => d.childIndex == 0),
        isTrue,
      );
    });

    testWidgets(
        'Visible overflow expands paint bounds and maintains hit testing',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Stack(
              config: const Material4Config(
                type: Material4Type.smoothRounded,
              ),
              width: 100,
              height: 100,
              contentProtection: const ShapeContentProtection(
                mode: ShapeContentMode.visibleOverflow,
              ),
              layoutStrategy: ShapeLayoutStrategy.stack,
              children: [
                ShapeChild(
                  alignment: Alignment.center,
                  allowOverflow: true,
                  child: GestureDetector(
                    key: const ValueKey('overflow_button'),
                    onTap: () {
                      tapped = true;
                    },
                    child: Container(
                      width: 160,
                      height: 160,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('overflow_button')), findsOneWidget);

      final renderObject = tester.renderObject<RenderMultiChildMaterial4>(
        find.byType(Material4MultiChildRenderWidget),
      );
      // paintBounds must be larger than size (100x100) due to overflowing child (160x160)
      expect(renderObject.paintBounds.width, greaterThan(100));
      expect(renderObject.paintBounds.height, greaterThan(100));

      // Tap on the child
      await tester.tap(find.byKey(const ValueKey('overflow_button')));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('Material4Container Multi-Child Integration', () {
    testWidgets(
        'Material4Container with children renders RenderMultiChildMaterial4',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Container(
              width: 250,
              height: 150,
              config: const Material4Config(
                type: Material4Type.smoothRounded,
                cornerRadius: 16.0,
              ),
              layoutStrategy: ShapeLayoutStrategy.flowVertical,
              children: const [
                Text('Line 1', key: ValueKey('line1')),
                Text('Line 2', key: ValueKey('line2')),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('line1')), findsOneWidget);
      expect(find.byKey(const ValueKey('line2')), findsOneWidget);
      expect(find.byType(Material4MultiChildRenderWidget), findsOneWidget);
    });

    testWidgets(
        'Material4Container with dockedBadge renders badge cleanly in multi-child mode',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Material4Container(
              width: 250,
              height: 150,
              config: const Material4Config(
                type: Material4Type.smoothRounded,
                cornerRadius: 16.0,
              ),
              dockedBadge: const Icon(Icons.star, key: ValueKey('docked_star')),
              children: const [
                Text('Main Content', key: ValueKey('main_content')),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('main_content')), findsOneWidget);
      expect(find.byKey(const ValueKey('docked_star')), findsOneWidget);
    });
  });
}
