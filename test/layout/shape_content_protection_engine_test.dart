import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Shape-Aware Content Protection Engine Tests', () {
    testWidgets(
        '1. Long text and multi-line text remain visible without clipping or overflow',
        (tester) async {
      const longTitle =
          'Universal Material 4 Engine ensures that long titles and descriptive sentences wrap naturally without being cut off by custom organic borders, cutouts or notches.';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container(
                width: 320,
                height: 180,
                config: const Material4Config(
                  type: Material4Type.speechBubble,
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

      expect(find.byType(Material4RenderWidget), findsOneWidget);
      expect(find.text(longTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2. Large icons remain inside safe boundaries without clipping',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Container(
                width: 140,
                height: 140,
                config: const Material4Config(
                  type: Material4Type.diamond,
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
      final containerBox = tester.getRect(find.byType(Material4RenderWidget));

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
              child: Material4Container(
                width: 200,
                height: 160,
                config: const Material4Config(
                  type: Material4Type.scallopedPetal,
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
      final containerBox = tester.getRect(find.byType(Material4RenderWidget));

      expect(imageBox.left, greaterThanOrEqualTo(containerBox.left));
      expect(imageBox.right, lessThanOrEqualTo(containerBox.right));
      expect(imageBox.top, greaterThanOrEqualTo(containerBox.top));
      expect(imageBox.bottom, lessThanOrEqualTo(containerBox.bottom));
      expect(tester.takeException(), isNull);
    });


    test(
        '5. Organic and Custom Bézier shapes compute mathematically inside safe bounds',
        () {
      const size = Size(200, 200);

      // A. Organic Blob
      const blobConfig = Material4Config(type: Material4Type.organicBlob);
      final blobBounds = ShapeSafeRegion.computeInscribedBounds(
        size: size,
        config: blobConfig,
      );

      expect(blobBounds.width, greaterThan(50));
      expect(blobBounds.height, greaterThan(50));

      final blobPath = Material4PathBuilder.buildPath(size, blobConfig);
      // Inscribed center must be strictly inside the blob path
      expect(blobPath.contains(blobBounds.center), isTrue);

      // B. Custom Bezier Lens
      final bezierConfig = Material4Config.customBezier(
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
      final bezierPath = Material4PathBuilder.buildPath(size, bezierConfig);

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
                  Material4Container(
                    width: 340,
                    height: 100,
                    config: const Material4Config(type: Material4Type.waveEdge),
                    child: const Text(
                      bengaliText,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Arabic RTL
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Material4Container(
                      width: 340,
                      height: 100,
                      config: const Material4Config(
                          type: Material4Type.asymmetricCard),
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
      const config = Material4Config(
        type: Material4Type.speechBubble,
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
              child: Material4Container.withMode(
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
              child: Material4Container.withMode(
                mode: ShapeContentMode.strict,
                width: 200,
                height: 100,
                config: const Material4Config(
                  type: Material4Type.capsule,
                ),
                child: const Text('Strictly Protected Content'),
              ),
            ),
          ),
        ),
      );

      final containerBox = tester.getRect(find.byType(Material4RenderWidget));
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
      for (final type in Material4Type.values) {
        final config = Material4Config(type: type);
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

  });
}
