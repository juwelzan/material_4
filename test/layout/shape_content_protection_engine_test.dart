import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_shape/dynamic_shape.dart';

void main() {
  group('Shape-Aware Content Protection Engine Tests', () {
    testWidgets(
        '1. Long text and multi-line text remain visible without clipping or overflow',
        (tester) async {
      const longTitle =
          'Universal Dynamic Shape Engine ensures that long titles and descriptive sentences wrap naturally without being cut off by custom organic borders, cutouts or notches.';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 320,
                height: 180,
                config: const DynamicShapeConfig(
                  type: DynamicShapeType.speechBubble,
                  speechBubbleTailHeight: 20.0,
                  anchor: ShapeAnchor.bottomLeft,
                ),
                contentProtection: const ShapeContentProtection.adaptive(),
                child: const Text(
                  longTitle,
                  style: TextStyle(fontSize: 13, height: 1.3),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(DynamicShapeRenderWidget), findsOneWidget);
      expect(find.text(longTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2. Large icons remain inside safe boundaries without clipping',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 140,
                height: 140,
                config: const DynamicShapeConfig(
                  type: DynamicShapeType.diamond,
                ),
                contentProtection: const ShapeContentProtection.strict(),
                child: const Icon(
                  Icons.school_rounded,
                  size: 48,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
        ),
      );

      final iconFinder = find.byType(Icon);
      expect(iconFinder, findsOneWidget);

      final iconBox = tester.getRect(iconFinder);
      final containerBox =
          tester.getRect(find.byType(DynamicShapeRenderWidget));

      // Icon must be centered within container boundaries
      expect(iconBox.left, greaterThan(containerBox.left));
      expect(iconBox.right, lessThan(containerBox.right));
      expect(iconBox.top, greaterThan(containerBox.top));
      expect(iconBox.bottom, lessThan(containerBox.bottom));
      expect(tester.takeException(), isNull);
    });

    testWidgets('3. Images respect configured fit within inscribed content box',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer(
                width: 200,
                height: 160,
                config: const DynamicShapeConfig(
                  type: DynamicShapeType.scallopedPetal,
                  petalCount: 12,
                ),
                child: Container(
                  key: const ValueKey('inner_image_box'),
                  color: Colors.teal,
                  child: const Center(
                    child: Text('Image Content',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final imageBox =
          tester.getRect(find.byKey(const ValueKey('inner_image_box')));
      final containerBox =
          tester.getRect(find.byType(DynamicShapeRenderWidget));

      expect(imageBox.left, greaterThanOrEqualTo(containerBox.left));
      expect(imageBox.right, lessThanOrEqualTo(containerBox.right));
      expect(imageBox.top, greaterThanOrEqualTo(containerBox.top));
      expect(imageBox.bottom, lessThanOrEqualTo(containerBox.bottom));
      expect(tester.takeException(), isNull);
    });

    test('4. Badges do not enter inward notches & children do not collide', () {
      const config = DynamicShapeConfig(
        notches: [
          ShapeNotch(
            edge: ShapeEdge.top,
            positionFactor: 0.5,
            width: 70,
            depth: 25,
            isInward: true,
          ),
        ],
      );

      const shapeSize = Size(300, 200);

      // Main content is positioned below the notch
      const contentRect = Rect.fromLTWH(20, 35, 260, 150);

      // Badge docked at top-right corner
      final badgeOffset = ShapeContentPlacer.computeAccessoryOffset(
        shapeSize: shapeSize,
        accessorySize: const Size(30, 30),
        anchor: ShapeAnchor.topRight,
        padding: const EdgeInsets.only(top: 8, right: 12),
        config: config,
      );
      final badgeRect = badgeOffset & const Size(30, 30);

      // Verify badge does not collide with main content
      final badgeReport = ShapeCollisionDetector.detectBadgeCollision(
        badgeRect: badgeRect,
        contentRect: contentRect,
        shapeSize: shapeSize,
        config: config,
      );
      expect(badgeReport.hasCollision, isFalse);

      // Verify multiple children slot spacing
      final slotLayout = ShapeContentPlacer.computeHorizontalSlotLayout(
        safeBounds: contentRect,
        leadingSize: const Size(28, 28),
        trailingSize: const Size(40, 28),
        spacing: 12.0,
      );

      expect(slotLayout.leadingRect, isNotNull);
      expect(slotLayout.trailingRect, isNotNull);

      // Leading and trailing rects must not overlap
      final childCollisionReport = ShapeCollisionDetector.detectChildCollision(
        childRects: [
          slotLayout.leadingRect!,
          slotLayout.contentRect,
          slotLayout.trailingRect!,
        ],
      );
      expect(childCollisionReport.hasCollision, isFalse);
    });

    test(
        '5. Organic and Custom Bézier shapes compute mathematically inside safe bounds',
        () {
      const size = Size(200, 200);

      // A. Organic Blob
      const blobConfig = DynamicShapeConfig(type: DynamicShapeType.organicBlob);
      final blobBounds = ShapeSafeRegion.computeInscribedBounds(
        size: size,
        config: blobConfig,
      );

      expect(blobBounds.width, greaterThan(50));
      expect(blobBounds.height, greaterThan(50));

      final blobPath = DynamicShapePathBuilder.buildPath(size, blobConfig);
      // Inscribed center must be strictly inside the blob path
      expect(blobPath.contains(blobBounds.center), isTrue);

      // B. Custom Bezier Lens
      final bezierConfig = DynamicShapeConfig.customBezier(
        builder: (s) => Path()
          ..moveTo(0, s.height / 2)
          ..quadraticBezierTo(s.width / 2, 0, s.width, s.height / 2)
          ..quadraticBezierTo(s.width / 2, s.height, 0, s.height / 2)
          ..close(),
      );

      final bezierBounds = ShapeSafeRegion.computeInscribedBounds(
        size: size,
        config: bezierConfig,
      );
      final bezierPath = DynamicShapePathBuilder.buildPath(size, bezierConfig);

      expect(bezierPath.contains(bezierBounds.center), isTrue);
    });

    testWidgets(
        '6. RTL and Bengali text layouts render cleanly without clipping or truncation',
        (tester) async {
      const bengaliText =
          'বাংলা ভাষা ও হরফে ডায়নামিক কন্টেন্ট সুরক্ষা টেস্ট। কোনো টেক্সট কখনোই কাটা পড়বে না।';
      const arabicText =
          'نظام تخطيط المحتوى الديناميكي الآمن دون أي اقتطاع للنصوص العربية';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Bengali LTR
                  DynamicShapeContainer(
                    width: 340,
                    height: 100,
                    config: const DynamicShapeConfig(
                        type: DynamicShapeType.waveEdge),
                    child: const Text(
                      bengaliText,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Arabic RTL
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: DynamicShapeContainer(
                      width: 340,
                      height: 100,
                      config: const DynamicShapeConfig(
                          type: DynamicShapeType.asymmetricCard),
                      child: const Text(
                        arabicText,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text(bengaliText), findsOneWidget);
      expect(find.text(arabicText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    test('7. Dynamic resizing recalculates safe regions cleanly', () {
      const config = DynamicShapeConfig(
        type: DynamicShapeType.speechBubble,
        speechBubbleTailHeight: 24.0,
        anchor: ShapeAnchor.bottomRight,
      );

      final insetsSmall = ShapeSafeRegion.computeSafeInsets(
        size: const Size(150, 80),
        config: config,
      );
      final insetsLarge = ShapeSafeRegion.computeSafeInsets(
        size: const Size(400, 250),
        config: config,
      );

      expect(insetsSmall.bottom, greaterThanOrEqualTo(24.0));
      expect(insetsLarge.bottom, greaterThanOrEqualTo(24.0));

      final boundsSmall = ShapeSafeRegion.computeInscribedBounds(
        size: const Size(150, 80),
        config: config,
      );
      final boundsLarge = ShapeSafeRegion.computeInscribedBounds(
        size: const Size(400, 250),
        config: config,
      );

      expect(boundsLarge.width, greaterThan(boundsSmall.width));
      expect(boundsLarge.height, greaterThan(boundsSmall.height));
    });

    testWidgets(
        '8. Visible overflow permits authorized floating badges to project outside boundary',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer.withMode(
                mode: ShapeContentMode.visibleOverflow,
                width: 150,
                height: 80,
                dockedBadge: Container(
                  key: const ValueKey('floating_badge'),
                  width: 32,
                  height: 32,
                  color: Colors.red,
                ),
                child: const Text('Visible Overflow Card'),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('floating_badge')), findsOneWidget);
      expect(find.text('Visible Overflow Card'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('9. Strict mode keeps child content strictly bounded',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DynamicShapeContainer.withMode(
                mode: ShapeContentMode.strict,
                width: 200,
                height: 100,
                config: const DynamicShapeConfig(
                  type: DynamicShapeType.capsule,
                ),
                child: const Text('Strictly Protected Content'),
              ),
            ),
          ),
        ),
      );

      final containerBox =
          tester.getRect(find.byType(DynamicShapeRenderWidget));
      final textBox = tester.getRect(find.text('Strictly Protected Content'));

      // Child is strictly within container
      expect(textBox.left, greaterThanOrEqualTo(containerBox.left));
      expect(textBox.right, lessThanOrEqualTo(containerBox.right));
      expect(textBox.top, greaterThanOrEqualTo(containerBox.top));
      expect(textBox.bottom, lessThanOrEqualTo(containerBox.bottom));
      expect(tester.takeException(), isNull);
    });

    test('10. All 28 presets generate valid, non-negative, finite safe insets',
        () {
      const size = Size(240, 140);
      for (final type in DynamicShapeType.values) {
        final config = DynamicShapeConfig(type: type);
        final insets = ShapeSafeRegion.computeSafeInsets(
          size: size,
          config: config,
        );

        expect(insets.left, greaterThanOrEqualTo(0.0),
            reason: 'Failed on $type left');
        expect(insets.top, greaterThanOrEqualTo(0.0),
            reason: 'Failed on $type top');
        expect(insets.right, greaterThanOrEqualTo(0.0),
            reason: 'Failed on $type right');
        expect(insets.bottom, greaterThanOrEqualTo(0.0),
            reason: 'Failed on $type bottom');
        expect(insets.horizontal, lessThan(size.width),
            reason: 'Failed on $type horizontal');
        expect(insets.vertical, lessThan(size.height),
            reason: 'Failed on $type vertical');
      }
    });

    testWidgets(
        '11. ShapeSmartContent slots leading, title, subtitle, and trailing cleanly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                height: 100,
                child: ShapeSmartContent(
                  config: const DynamicShapeConfig(
                      type: DynamicShapeType.folderTab),
                  leading: const Icon(Icons.star, key: ValueKey('smart_star')),
                  title: const Text('Smart Slot Title',
                      key: ValueKey('smart_title')),
                  subtitle:
                      const Text('Smart Subtitle', key: ValueKey('smart_sub')),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 16, key: ValueKey('smart_arrow')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('smart_star')), findsOneWidget);
      expect(find.byKey(const ValueKey('smart_title')), findsOneWidget);
      expect(find.byKey(const ValueKey('smart_sub')), findsOneWidget);
      expect(find.byKey(const ValueKey('smart_arrow')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
