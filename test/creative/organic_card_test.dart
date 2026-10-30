import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Organic Card Geometry & Presets Unit Tests', () {
    test('Notice Board preset possesses lower-right concave notch geometry',
        () {
      final shape = Material4CardShape.noticeBoard(
        cornerRadius: 24.0,
        notchDepth: 18.0,
        notchWidth: 54.0,
        notchPosition: 0.68,
      );

      // Verify asymmetric corners
      expect(shape.topLeft.radius, equals(28.0));
      expect(shape.topRight.radius, equals(24.0));
      expect(shape.bottomRight.radius, equals(18.0));
      expect(shape.bottomLeft.radius, equals(22.0));

      // Verify lower-right edge concave notch
      expect(shape.rightEdge.style, equals(OrganicEdgeStyle.concaveNotch));
      expect(shape.rightEdge.depth, equals(18.0));
      expect(shape.rightEdge.width, equals(54.0));
      expect(shape.rightEdge.position, equals(0.68));
    });

    test('All 10 Material4CardShape presets have distinct geometry and hashes',
        () {
      final presets = <String, Material4CardShape>{
        'noticeBoard': Material4CardShape.noticeBoard(),
        'sculptedInfo': Material4CardShape.sculptedInfo(),
        'asymmetricFeature': Material4CardShape.asymmetricFeature(),
        'softNotch': Material4CardShape.softNotch(),
        'floatingOrganic': Material4CardShape.floatingOrganic(),
        'blobSurface': Material4CardShape.blobSurface(),
        'curvedEdge': Material4CardShape.curvedEdge(),
        'creativeDashboard': Material4CardShape.creativeDashboard(),
        'sculptedAction': Material4CardShape.sculptedAction(),
        'signature': Material4CardShape.signature(),
      };

      expect(presets.length, equals(10));

      // Verify all presets are unique
      final hashes = presets.values.map((s) => s.hashCode).toSet();
      expect(hashes.length, equals(10),
          reason:
              'Every single card shape preset must have a distinct geometry and hash');
    });

    test('Shape lerp smoothly interpolates geometry across intermediate steps',
        () {
      final a = Material4CardShape.noticeBoard(notchDepth: 10.0);
      final b = Material4CardShape.sculptedAction(actionPocketDepth: 30.0);

      final mid = Material4CardShape.lerp(a, b, 0.5);
      expect(mid.rightEdge.depth, equals(20.0));
    });
  });

  group('OrganicShapePathBuilder Mathematical Continuity & Constraints Tests',
      () {
    test('Builds valid non-empty closed paths across diverse aspect ratios',
        () {
      final shape = Material4CardShape.noticeBoard();

      final aspectRatios = [
        const Size(400, 100), // Banner (4:1)
        const Size(200, 200), // Square (1:1)
        const Size(150, 300), // Tall card (1:2)
        const Size(320, 180), // Standard card (16:9)
      ];

      for (final size in aspectRatios) {
        final path = OrganicShapePathBuilder.buildPath(size, shape);
        expect(path.getBounds().isEmpty, isFalse);
        expect(path.getBounds().width, lessThanOrEqualTo(size.width + 0.1));
        expect(path.getBounds().height, lessThanOrEqualTo(size.height + 0.1));
      }
    });

    test('Handles zero and non-positive dimensions gracefully without crash',
        () {
      final shape = Material4CardShape.noticeBoard();
      expect(
          OrganicShapePathBuilder.buildPath(Size.zero, shape)
              .getBounds()
              .isEmpty,
          isTrue);
      expect(
          OrganicShapePathBuilder.buildPath(const Size(-10, 50), shape)
              .getBounds()
              .isEmpty,
          isTrue);
      expect(
          OrganicShapePathBuilder.buildPath(const Size(50, double.nan), shape)
              .getBounds()
              .isEmpty,
          isTrue);
    });

    test(
        'Geometry-aware safe insets protect content from concave notch intrusion',
        () {
      final flatShape = const Material4CardShape();
      final notchedShape = Material4CardShape.noticeBoard(notchDepth: 22.0);

      const testSize = Size(250, 120);
      final flatInsets =
          OrganicShapePathBuilder.getSafeInsets(testSize, flatShape);
      final notchedInsets =
          OrganicShapePathBuilder.getSafeInsets(testSize, notchedShape);

      // Right inset for the notched shape must clear the 22dp concave scoop
      expect(notchedInsets.right, greaterThan(flatInsets.right));
      expect(notchedInsets.right, greaterThanOrEqualTo(22.0));
    });
  });

  group('Material4Card Widget & RenderBox Tests', () {
    testWidgets(
        'Material4Card.noticeBoard renders reference design with campaign icon',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                height: 100,
                child: Material4Card.noticeBoard(
                  title: 'Notice Board',
                  subtitle: 'Daily School Announcements',
                  icon: Icons.campaign_outlined,
                  backgroundColor: const Color(0xFFDDBCFB),
                  border: const Material4CardBorder.thin(
                    color: Color(0xFF1E1E24),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Notice Board'), findsOneWidget);
      expect(find.text('Daily School Announcements'), findsOneWidget);
      expect(find.byIcon(Icons.campaign_outlined), findsOneWidget);
      expect(find.byType(Material4Card), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Material4Card supports raw custom child layout',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Card(
                shape: Material4CardShape.noticeBoard(),
                backgroundColor: const Color(0xFFDDBCFB),
                border: const Material4CardBorder(
                  color: Colors.black87,
                  width: 1.2,
                ),
                padding: const EdgeInsets.all(24),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text('Custom Row Content'),
                    ),
                    Icon(Icons.campaign_outlined),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom Row Content'), findsOneWidget);
      expect(find.byIcon(Icons.campaign_outlined), findsOneWidget);
    });

    testWidgets(
        'Sub-pixel hit testing respects organic contour and rejects notch interior',
        (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Card(
                width: 200,
                height: 100,
                shape: Material4CardShape.noticeBoard(
                  notchDepth: 25.0,
                  notchWidth: 50.0,
                  notchPosition: 0.5,
                ),
                onTap: () {
                  tapped = true;
                },
                child: const Center(child: Text('Hit Test')),
              ),
            ),
          ),
        ),
      );

      final cardFinder = find.byType(Material4Card);
      final center = tester.getCenter(cardFinder);

      // Center click is well within the card interior
      await tester.tapAt(center);
      await tester.pumpAndSettle();
      expect(tapped, isTrue);

      // Click inside the scooped notch cavity (right edge at center is indented by 25px: x = 190)
      // Point (width - 5, height / 2) is inside the bounding box but outside the sculpted path contour!
      tapped = false;
      final cardTopLeft = tester.getTopLeft(cardFinder);
      final notchCavityPoint = cardTopLeft + const Offset(195, 50);

      await tester.tapAt(notchCavityPoint);
      await tester.pumpAndSettle();
      expect(tapped, isFalse,
          reason:
              'Clicking inside the scooped notch cavity must not hit test on the card');
    });

    testWidgets('All 10 built-in Material4Card presets render without error',
        (tester) async {
      final cards = [
        Material4Card.noticeBoard(title: 'Notice Board'),
        Material4Card.sculptedInfo(title: 'Sculpted Info'),
        Material4Card.asymmetricFeature(title: 'Asymmetric Feature'),
        Material4Card.softNotch(title: 'Soft Notch'),
        Material4Card.floatingOrganic(title: 'Floating Organic'),
        Material4Card.blobSurface(title: 'Blob Surface'),
        Material4Card.curvedEdge(title: 'Curved Edge'),
        Material4Card.creativeDashboard(title: 'Creative Dashboard'),
        Material4Card.sculptedAction(title: 'Sculpted Action'),
        Material4Card.signature(title: 'Signature Card'),
      ];

      for (int i = 0; i < cards.length; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 260,
                  height: 90,
                  child: cards[i],
                ),
              ),
            ),
          ),
        );

        expect(find.byType(Material4Card), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('AnimatedMaterial4Card executes shape morphing smoothly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedMaterial4Card(
                duration: const Duration(milliseconds: 250),
                shape: Material4CardShape.noticeBoard(),
                backgroundColor: const Color(0xFFDDBCFB),
                child: const Text('Morphing Card'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Morphing Card'), findsOneWidget);

      // Rebuild with different shape and color
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedMaterial4Card(
                duration: const Duration(milliseconds: 250),
                shape: Material4CardShape.sculptedInfo(),
                backgroundColor: const Color(0xFFD0E6FF),
                child: const Text('Morphing Card'),
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 125));
      expect(find.text('Morphing Card'), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
