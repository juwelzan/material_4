import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 7.2: MaterialDynamicCard Core Tests', () {
    testWidgets('Renders all 12 DynamicMaterial types cleanly', (tester) async {
      for (final mat in DynamicMaterial.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MaterialDynamicCard(
                material: mat,
                title: 'Material: ${mat.name}',
                subtitle: 'Tactile substrate test',
              ),
            ),
          ),
        );
        expect(find.text('Material: ${mat.name}'), findsOneWidget);
        expect(find.text('Tactile substrate test'), findsOneWidget);
      }
    });

    testWidgets('Renders across all 7 CardIconPosition modes', (tester) async {
      for (final pos in CardIconPosition.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MaterialDynamicCard(
                icon: Icons.palette,
                iconPosition: pos,
                title: 'Position: ${pos.name}',
                subtitle: 'Testing layout placement',
              ),
            ),
          ),
        );
        expect(find.byIcon(Icons.palette), findsOneWidget);
        expect(find.text('Position: ${pos.name}'), findsOneWidget);
      }
    });

    testWidgets('Renders all 4 CardSurfaceType finishes for icon and content',
        (tester) async {
      for (final surface in CardSurfaceType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MaterialDynamicCard(
                icon: Icons.layers,
                iconSurface: surface,
                contentSurface: surface,
                title: 'Surface: ${surface.name}',
                subtitle: 'Testing physical relief',
              ),
            ),
          ),
        );
        expect(find.text('Surface: ${surface.name}'), findsOneWidget);
      }
    });

    testWidgets('Tapping triggers onTap callback and press animation',
        (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaterialDynamicCard(
              title: 'Interactive Card',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(tapped, isFalse);
      await tester.tap(find.text('Interactive Card'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('Selection toggle updates state and fires callback',
        (tester) async {
      bool isSelected = false;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: MaterialDynamicCard(
                  title: 'Selectable Target',
                  selected: isSelected,
                  onSelectedChanged: (val) {
                    setState(() => isSelected = val);
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(isSelected, isFalse);
      await tester.tap(find.text('Selectable Target'));
      await tester.pumpAndSettle();
      expect(isSelected, isTrue);
    });

    testWidgets('Accordion expandableChild expands and collapses smoothly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MaterialDynamicCard(
              title: 'Expandable Accordion',
              expandableChild: Text('Secret Hidden Content'),
            ),
          ),
        ),
      );

      // Tap to expand
      await tester.tap(find.text('Expandable Accordion'));
      await tester.pumpAndSettle();
      expect(find.text('Secret Hidden Content'), findsOneWidget);

      // Tap to collapse
      await tester.tap(find.text('Expandable Accordion'));
      await tester.pumpAndSettle();
    });

    testWidgets(
        'RTL and Bengali script render cleanly without crash or overflow',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: MaterialDynamicCard(
                icon: Icons.star,
                iconPosition: CardIconPosition.leading,
                title: 'বাংলা ডায়নামিক কার্ড ডিজাইন',
                subtitle: 'সহজ ও আকর্ষণীয় ইন্টারঅ্যাক্টিভ কম্পোনেন্ট',
                description: 'পদার্থবিদ্যার আলো এবং ছায়ার নিখুঁত ভারসাম্য।',
                badge: 'নতুন',
                metadata: '৩০ অক্টোবর ২০২৬',
              ),
            ),
          ),
        ),
      );

      expect(find.text('বাংলা ডায়নামিক কার্ড ডিজাইন'), findsOneWidget);
      expect(find.text('সহজ ও আকর্ষণীয় ইন্টারঅ্যাক্টিভ কম্পোনেন্ট'),
          findsOneWidget);
      expect(find.text('নতুন'), findsOneWidget);
      expect(find.text('৩০ অক্টোবর ২০২৬'), findsOneWidget);
    });

    testWidgets(
        'Long text is gracefully clipped with ellipsis without overflow',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 250.0,
              height: 140.0,
              child: MaterialDynamicCard(
                title:
                    'Extremely Long Card Headline That Should Definitely Overflow If Not Restricted Properly By Text Truncation Rules',
                description:
                    'This is a long description text that spans multiple sentences and paragraphs to stress test the overflow protection engine of the MaterialDynamicCard widget.',
                titleMaxLines: 1,
                descriptionMaxLines: 2,
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
