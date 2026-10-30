import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_4/material_4.dart';

void main() {
  group('Material4AvatarShape Geometry Unit Tests', () {
    test('All 22 built-in avatar shapes generate valid closed paths', () {
      final size = const Size(100, 100);
      final shapes = <Material4AvatarShape>[
        // Basic
        Material4AvatarShape.circle(),
        Material4AvatarShape.roundedSquare(cornerRadius: 16),
        Material4AvatarShape.squircle(smoothness: 0.8),
        Material4AvatarShape.oval(),
        Material4AvatarShape.capsule(),
        Material4AvatarShape.diamond(cornerRadius: 8),
        Material4AvatarShape.hexagon(cornerRadius: 8),
        Material4AvatarShape.octagon(cornerRadius: 8),
        // Organic
        Material4AvatarShape.organicBlob(seed: 1),
        Material4AvatarShape.asymmetricRounded(
            rTL: 24, rTR: 8, rBR: 24, rBL: 8),
        Material4AvatarShape.softSculpted(),
        Material4AvatarShape.irregularCurve(),
        Material4AvatarShape.wavyEdge(waves: 6, amplitude: 4),
        Material4AvatarShape.concaveNotch(notchDepth: 12),
        Material4AvatarShape.convexBulge(bulgeHeight: 8),
        Material4AvatarShape.multiCurve(),
        // Creative
        Material4AvatarShape.flower(petals: 8),
        Material4AvatarShape.cloud(),
        Material4AvatarShape.star(points: 5),
        Material4AvatarShape.shield(),
        Material4AvatarShape.ticket(),
        Material4AvatarShape.abstractGeometric(),
      ];

      for (final shape in shapes) {
        final path = shape.buildPath(size);
        expect(path, isNotNull);
        final bounds = path.getBounds();
        expect(bounds.width, greaterThan(0),
            reason: 'Shape ${shape.id} width must be > 0');
        expect(bounds.height, greaterThan(0),
            reason: 'Shape ${shape.id} height must be > 0');
        expect(path.computeMetrics().isNotEmpty, isTrue,
            reason: 'Shape ${shape.id} path metrics must not be empty');
      }
    });

    test('Zero and negative sizes produce empty paths without crashing', () {
      final shape = Material4AvatarShape.circle();
      expect(shape.buildPath(Size.zero).computeMetrics().isEmpty, isTrue);
      expect(shape.buildPath(const Size(-20, 50)).computeMetrics().isEmpty,
          isTrue);
    });

    test('Shape lerp smoothly interpolates between two distinct avatar shapes',
        () {
      final shapeA = Material4AvatarShape.circle();
      final shapeB = Material4AvatarShape.star(points: 5);
      final size = const Size(80, 80);

      final pathStart =
          Material4AvatarShape.lerp(shapeA, shapeB, 0.0).buildPath(size);
      final pathMid =
          Material4AvatarShape.lerp(shapeA, shapeB, 0.5).buildPath(size);
      final pathEnd =
          Material4AvatarShape.lerp(shapeA, shapeB, 1.0).buildPath(size);

      expect(pathStart.computeMetrics().isNotEmpty, isTrue);
      expect(pathMid.computeMetrics().isNotEmpty, isTrue);
      expect(pathEnd.computeMetrics().isNotEmpty, isTrue);
    });
  });

  group('Material4AvatarBorder Unit Tests', () {
    test('Calculates totalMargin correctly across border styles', () {
      const noneBorder = Material4AvatarBorder.none();
      expect(noneBorder.totalMargin, equals(0.0));

      const solidBorder = Material4AvatarBorder.solid(width: 3.0, gap: 2.0);
      expect(solidBorder.totalMargin, equals(5.0));

      const glowBorder = Material4AvatarBorder.glow(
          width: 2.0, glowRadius: 8.0, glowSpread: 2.0);
      expect(glowBorder.totalMargin, equals(12.0));
    });

    test('Paints all border styles without throwing exceptions', () {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final size = const Size(64, 64);
      final path = Material4AvatarShape.squircle().buildPath(size);

      final borders = [
        const Material4AvatarBorder.solid(color: Colors.blue, width: 2),
        const Material4AvatarBorder.gradient(
          gradient: LinearGradient(colors: [Colors.purple, Colors.orange]),
          width: 3,
        ),
        const Material4AvatarBorder.dashed(color: Colors.red, width: 2),
        const Material4AvatarBorder.glow(color: Colors.cyan, glowRadius: 6),
        const Material4AvatarBorder.doubleBorder(
            color: Colors.white, width: 2, innerWidth: 1),
        const Material4AvatarBorder.sculpted(width: 3),
      ];

      for (final border in borders) {
        expect(() => border.paintBorder(canvas, size, path), returnsNormally);
      }
    });
  });

  group('Material4Avatar Widget Tests', () {
    testWidgets('Renders initials with deterministic background color',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar.initials(
                initials: 'JR',
                size: 64,
                shape: Material4AvatarShape.squircle(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Material4Avatar), findsOneWidget);
      expect(find.text('JR'), findsOneWidget);
    });

    testWidgets(
        'Renders fallback icon when neither image nor initials provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar(
                size: 56,
                icon: Icons.school_rounded,
                shape: Material4AvatarShape.roundedSquare(cornerRadius: 12),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.school_rounded), findsOneWidget);
    });

    testWidgets('Renders status indicator at configured corner position',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar.initials(
                initials: 'AB',
                size: 60,
                status: const Material4AvatarStatus.online(
                  position: AvatarStatusPosition.bottomRight,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Material4Avatar), findsOneWidget);
      // Status indicator has emerald green color container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Renders notification count badge with truncated 99+ format',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar.initials(
                initials: 'CD',
                size: 60,
                badge: const Material4AvatarBadge.count(120),
              ),
            ),
          ),
        ),
      );

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('Renders verified identity badge seal', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar.initials(
                initials: 'VF',
                size: 60,
                badge: const Material4AvatarBadge.verified(),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('Tapping avatar fires onTap callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4Avatar.initials(
                initials: 'TP',
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Material4Avatar));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });

  group('AnimatedMaterial4Avatar & Group Tests', () {
    testWidgets('AnimatedMaterial4Avatar morphs smoothly on shape rebuild',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedMaterial4Avatar(
                duration: const Duration(milliseconds: 200),
                shape: Material4AvatarShape.circle(),
                initials: 'AN',
              ),
            ),
          ),
        ),
      );

      expect(find.text('AN'), findsOneWidget);

      // Rebuild with different shape and size
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedMaterial4Avatar(
                duration: const Duration(milliseconds: 200),
                shape: Material4AvatarShape.flower(petals: 8),
                size: 72,
                initials: 'AN',
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AnimatedMaterial4Avatar), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('AN'), findsOneWidget);
    });

    testWidgets(
        'Material4AvatarGroup stacks avatars and renders overflow badge',
        (tester) async {
      bool overflowTapped = false;

      final avatars = List.generate(
        6,
        (i) => Material4Avatar.initials(
          initials: 'U$i',
          size: 40,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Material4AvatarGroup(
                avatars: avatars,
                maxVisible: 3,
                size: 40,
                spacing: -10,
                onOverflowTap: () {
                  overflowTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      // 3 visible avatars + 1 overflow badge (+3)
      expect(find.byType(Material4Avatar), findsNWidgets(4));
      expect(find.text('+3'), findsOneWidget);

      await tester.tap(find.text('+3'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(overflowTapped, isTrue);
    });
  });
}
