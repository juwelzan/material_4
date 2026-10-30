import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('ShapeContentProtection Modes', () {
    test('Default mode is strict with child clipping', () {
      const protection = ShapeContentProtection.strict();
      expect(protection.mode, equals(ContentProtectionMode.strict));
      expect(protection.shouldClipChild, isTrue);
    });

    test('Adaptive mode maximizes readable area and avoids hard child clipping',
        () {
      const protection = ShapeContentProtection.adaptive();
      expect(protection.mode, equals(ContentProtectionMode.adaptive));
      expect(protection.shouldClipChild, isFalse);
    });

    test(
        'VisibleOverflow mode allows badges to render outside boundaries without clip',
        () {
      const protection = ShapeContentProtection.visibleOverflow();
      expect(protection.mode, equals(ContentProtectionMode.visibleOverflow));
      expect(protection.shouldClipChild, isFalse);
    });
  });

  group('ShapeSafeRegion & Content Protection Geometry', () {
    test('Calculates insets for inward notches avoiding content collision', () {
      const config = Material4Config(
        type: Material4Type.smoothRounded,
        notches: [
          ShapeNotch(
            edge: ShapeEdge.top,
            positionFactor: 0.5,
            width: 60.0,
            depth: 25.0,
            isInward: true,
          ),
          ShapeNotch(
            edge: ShapeEdge.left,
            positionFactor: 0.5,
            width: 40.0,
            depth: 30.0,
            isInward: true,
          ),
        ],
      );

      final insets = ShapeSafeRegion.computeSafeInsets(
        size: const Size(200, 200),
        config: config,
        basePadding: const EdgeInsets.all(8.0),
      );

      // Top should be >= notch depth (25.0) + stroke
      expect(insets.top, greaterThanOrEqualTo(25.0));
      // Left should be >= notch depth (30.0) + stroke
      expect(insets.left, greaterThanOrEqualTo(30.0));
    });

    test('Outward tabs do not intrude on interior safe insets', () {
      const inwardConfig = Material4Config(
        notches: [
          ShapeNotch(
            edge: ShapeEdge.top,
            positionFactor: 0.5,
            width: 60.0,
            depth: 25.0,
            isInward: true,
          ),
        ],
      );
      const outwardConfig = Material4Config(
        notches: [
          ShapeNotch(
            edge: ShapeEdge.top,
            positionFactor: 0.5,
            width: 60.0,
            depth: 25.0,
            isInward: false,
          ),
        ],
      );

      final inwardInsets = ShapeSafeRegion.computeSafeInsets(
        size: const Size(200, 200),
        config: inwardConfig,
      );
      final outwardInsets = ShapeSafeRegion.computeSafeInsets(
        size: const Size(200, 200),
        config: outwardConfig,
      );

      expect(inwardInsets.top, greaterThan(outwardInsets.top));
    });

    test('RTL mirrors horizontal safe insets correctly', () {
      const config = Material4Config(
        type: Material4Type.asymmetricCard,
        corners: ShapeCorners(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      );

      final ltrInsets = ShapeSafeRegion.computeSafeInsets(
        size: const Size(200, 100),
        config: config,
        textDirection: TextDirection.ltr,
      );
      final rtlInsets = ShapeSafeRegion.computeSafeInsets(
        size: const Size(200, 100),
        config: config,
        textDirection: TextDirection.rtl,
      );

      // In LTR, topLeft radius (50) affects left insets
      // In RTL, the large radius (50) shifts to the right side
      expect(ltrInsets.left, equals(rtlInsets.right));
      expect(ltrInsets.right, equals(rtlInsets.left));
    });
  });

  group('ShapeCollisionDetector Tests', () {
    test('Detects safe child position inside safe bounds', () {
      const config = Material4Config(
        notches: [
          ShapeNotch(
            edge: ShapeEdge.top,
            positionFactor: 0.5,
            width: 50,
            depth: 20,
            isInward: true,
          ),
        ],
      );

      final report = ShapeCollisionDetector.detectCollision(
        candidateRect: const Rect.fromLTWH(20, 30, 80, 40),
        shapeSize: const Size(200, 200),
        config: config,
        safeInsets:
            const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10),
      );

      expect(report.hasCollision, isFalse);
    });

    test('Flags collision when child overlaps inward notch pocket', () {
      const config = Material4Config(
        notches: [
          ShapeNotch(
            edge: ShapeEdge.top,
            positionFactor: 0.5,
            width: 80,
            depth: 30,
            isInward: true,
          ),
        ],
      );

      // Candidate at center top (60 to 140 X, 0 to 40 Y) directly collides with notch
      final report = ShapeCollisionDetector.detectCollision(
        candidateRect: const Rect.fromLTWH(80, 5, 40, 20),
        shapeSize: const Size(200, 200),
        config: config,
        safeInsets: const EdgeInsets.only(top: 35),
      );

      expect(report.hasCollision, isTrue);
      expect(report.collisions.any((c) => c.contains('inward notch')), isTrue);
    });
  });

  group('ShapeTextFitter & Multilingual / Bengali / RTL Support', () {
    test('Measures Bengali text accurately without font reduction or clipping',
        () {
      const bengaliText = 'ডাইনামিক শেইপ ইঞ্জিন এবং টেক্সট প্রোটেকশন';
      final size = ShapeTextFitter.measureText(
        text: bengaliText,
        style: const TextStyle(fontSize: 16.0),
        maxWidth: 300.0,
      );

      expect(size.width, greaterThan(0.0));
      expect(size.height, greaterThan(0.0));
      expect(size.width, lessThanOrEqualTo(300.0));
    });

    test('Measures Arabic RTL text accurately', () {
      const arabicText = 'محرك الأشكال الديناميكي لنظام فلاتر';
      final size = ShapeTextFitter.measureText(
        text: arabicText,
        style: const TextStyle(fontSize: 16.0),
        maxWidth: 300.0,
        textDirection: TextDirection.rtl,
      );

      expect(size.width, greaterThan(0.0));
      expect(size.height, greaterThan(0.0));
      expect(size.width, lessThanOrEqualTo(300.0));
    });

    test('Computes optimal font size for bounded inscribed region', () {
      const sampleText = 'Universal Material 4 Content Protection';
      final optimalSize = ShapeTextFitter.computeOptimalFontSize(
        text: sampleText,
        targetSize: const Size(120, 40),
        minFontSize: 8.0,
        maxFontSize: 24.0,
      );

      expect(optimalSize, greaterThanOrEqualTo(8.0));
      expect(optimalSize, lessThanOrEqualTo(24.0));
    });

    test('fitsWithin correctly verifies rectangular capacity', () {
      const shortText = 'OK';
      const longText =
          'This is a very long multiline text description that will exceed small bounds easily.';

      final smallBounds = const Rect.fromLTWH(0, 0, 40, 30);
      expect(ShapeTextFitter.fitsWithin(text: shortText, bounds: smallBounds),
          isTrue);
      expect(
          ShapeTextFitter.fitsWithin(
              text: longText, bounds: smallBounds, maxLines: 1),
          isFalse);
    });
  });

  group('ShapeAnchorPlacer & ShapeContentPlacer Tests', () {
    test('Resolves anchor coordinates for shapes', () {
      const size = Size(200, 100);

      expect(
        ShapeAnchorPlacer.resolveAnchorPoint(
            size: size, anchor: ShapeAnchor.topLeft),
        equals(Offset.zero),
      );
      expect(
        ShapeAnchorPlacer.resolveAnchorPoint(
            size: size, anchor: ShapeAnchor.bottomRight),
        equals(const Offset(200, 100)),
      );
      expect(
        ShapeAnchorPlacer.resolveAnchorPoint(
            size: size, anchor: ShapeAnchor.center),
        equals(const Offset(100, 50)),
      );
    });

    test('Resolves notch pocket dock center correctly', () {
      const notch = ShapeNotch(
        edge: ShapeEdge.top,
        positionFactor: 0.5,
        width: 60,
        depth: 20,
      );

      final center = ShapeAnchorPlacer.resolveNotchCenter(
        size: const Size(200, 100),
        notch: notch,
      );

      expect(center, equals(const Offset(100, 10)));
    });

    test('Computes docked accessory offset with padding', () {
      final offset = ShapeContentPlacer.computeAccessoryOffset(
        shapeSize: const Size(200, 100),
        accessorySize: const Size(24, 24),
        anchor: ShapeAnchor.topRight,
        padding: const EdgeInsets.only(top: 4, right: 8),
      );

      expect(offset.dx, equals(200 - 12 - 8));
      expect(offset.dy, equals(0 - 12 + 4));
    });
  });

  group('Widget Content Protection Integration Tests', () {
    testWidgets(
        'Renders Bengali multiline text in Material4Container without error',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Material4Container(
              width: 260,
              height: 120,
              config: const Material4Config(
                type: Material4Type.waveEdge,
              ),
              contentProtection: const ShapeContentProtection.strict(),
              child: const Text(
                'বাংলা টেক্সট কন্টেন্ট সুরক্ষা টেস্ট। এই টেক্সটটি কোনোভাবেই কাটা পড়বে না।',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Material4RenderWidget), findsOneWidget);
      expect(find.textContaining('বাংলা টেক্সট কন্টেন্ট সুরক্ষা টেস্ট'),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'Visible overflow allows docked accessories to project outside shape',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Material4Container(
              width: 150,
              height: 80,
              contentProtection: const ShapeContentProtection.visibleOverflow(),
              dockedBadge: Container(
                key: const ValueKey('docked_chip'),
                width: 30,
                height: 30,
                color: Colors.red,
              ),
              child: const Text('Main Card'),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('docked_chip')), findsOneWidget);
      expect(find.text('Main Card'), findsOneWidget);
    });
  });
}
