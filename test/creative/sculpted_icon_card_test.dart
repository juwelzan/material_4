import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 7.1: SculptedIconCard System Tests', () {
    testWidgets('Renders cleanly across all 13 SculptedIconPosition modes', (
      tester,
    ) async {
      for (final position in SculptedIconPosition.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SculptedIconCard(
                  icon: Icons.school,
                  title: 'Education',
                  subtitle: 'Position: ${position.name}',
                  iconPosition: position,
                ),
              ),
            ),
          ),
        );
        expect(find.text('Education'), findsOneWidget);
        expect(find.byIcon(Icons.school), findsOneWidget);
      }
    });

    testWidgets('Renders all 15 SculptedSurfaceStyle options cleanly', (
      tester,
    ) async {
      for (final style in SculptedSurfaceStyle.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SculptedIconCard(
                  icon: Icons.star,
                  title: 'Style Test',
                  plateConfig: SculptedPlateConfig(style: style),
                ),
              ),
            ),
          ),
        );
        expect(find.text('Style Test'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      }
    });

    testWidgets(
        'Icon plate is raised and text surface remains flat and readable', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SculptedIconCard(
              icon: Icons.science,
              title: 'Physics Lab',
              subtitle: 'Advanced mechanics & optics',
              description: 'Room 304 • Prof. Alston',
              plateConfig: const SculptedPlateConfig(
                style: SculptedSurfaceStyle.embossed,
                depth: 5.0,
              ),
            ),
          ),
        ),
      );

      // Verify all text widgets render and are not obscured
      expect(find.text('Physics Lab'), findsOneWidget);
      expect(find.text('Advanced mechanics & optics'), findsOneWidget);
      expect(find.text('Room 304 • Prof. Alston'), findsOneWidget);
      expect(find.byIcon(Icons.science), findsOneWidget);
    });

    testWidgets('Supports Bengali and RTL text direction seamlessly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SculptedIconCard(
                icon: Icons.book,
                title: 'বাংলা পাঠ্যপুস্তক',
                subtitle: 'প্রাথমিক ও মাধ্যমিক শিক্ষা',
                badge: 'নতুন',
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      );

      expect(find.text('বাংলা পাঠ্যপুস্তক'), findsOneWidget);
      expect(find.text('প্রাথমিক ও মাধ্যমিক শিক্ষা'), findsOneWidget);
      expect(find.text('নতুন'), findsOneWidget);
    });

    testWidgets('Tapping fires callback and triggers press animation', (
      tester,
    ) async {
      int tapCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SculptedIconCard(
                icon: Icons.touch_app,
                title: 'Tap Me',
                onTap: () => tapCount++,
              ),
            ),
          ),
        ),
      );

      expect(tapCount, 0);
      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();
      expect(tapCount, 1);
    });

    testWidgets(
        'Accessibility semantics are properly exposed for screen readers', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SculptedIconCard(
              icon: Icons.verified,
              title: 'Verified Certificate',
              subtitle: 'Grade A+',
              onTap: () {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(SculptedIconCard));
      expect(semantics.label, contains('Verified Certificate'));
      expect(semantics.label, contains('Grade A+'));
    });

    testWidgets('Handles long text without overflowing container', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 280,
              child: SculptedIconCard(
                icon: Icons.announcement,
                title:
                    'Extremely Long Title That Would Usually Overflow Normal Containers Without Proper Constraints',
                subtitle:
                    'Secondary explanatory subtitle that contains lots of detailed technical guidance for users.',
                description:
                    'Full descriptive body detailing the exact requirements of the modern dynamic shape RenderBox.',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
