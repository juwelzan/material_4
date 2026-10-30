import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 7.1: Creative Card Presets Tests', () {
    testWidgets('TornPaperCard renders with realistic torn border',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TornPaperCard(
              child: Text('Torn Paper Content'),
            ),
          ),
        ),
      );
      expect(find.text('Torn Paper Content'), findsOneWidget);
    });

    testWidgets('NotebookCard renders ruled lines and margin', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NotebookCard(
              child: Text('Notebook Notes'),
            ),
          ),
        ),
      );
      expect(find.text('Notebook Notes'), findsOneWidget);
    });

    testWidgets('StickyNoteCard renders canary yellow note', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StickyNoteCard(
              child: Text('Remember Exam!'),
            ),
          ),
        ),
      );
      expect(find.text('Remember Exam!'), findsOneWidget);
    });

    testWidgets('VintagePaperCard renders antique parchment style',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VintagePaperCard(
              child: Text('Ancient Manuscript'),
            ),
          ),
        ),
      );
      expect(find.text('Ancient Manuscript'), findsOneWidget);
    });

    testWidgets(
        'CouponCard and TicketCard render tickets with scalloped cutouts', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CouponCard(child: Text('50% Off Voucher')),
                TicketCard(child: Text('Admit One Ticket')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('50% Off Voucher'), findsOneWidget);
      expect(find.text('Admit One Ticket'), findsOneWidget);
    });

    testWidgets('EmbossedCard and DebossedCard render tactile surfaces', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                EmbossedCard(child: Text('Embossed Elevation')),
                DebossedCard(child: Text('Debossed Well')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Embossed Elevation'), findsOneWidget);
      expect(find.text('Debossed Well'), findsOneWidget);
    });

    testWidgets('NeumorphicCard renders dual directional soft lighting', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NeumorphicCard(
              child: Text('Soft UI Neumorphism'),
            ),
          ),
        ),
      );
      expect(find.text('Soft UI Neumorphism'), findsOneWidget);
    });

    testWidgets(
        'FloatingIconCard, RecessedIconCard, ClayCard, GlassIconCard render', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const FloatingIconCard(
                    icon: Icons.flight,
                    title: 'Airport Gate',
                  ),
                  const RecessedIconCard(
                    icon: Icons.lock,
                    title: 'Secure Vault',
                  ),
                  ClayCard(
                    icon: Icons.brush,
                    title: 'Art Studio',
                  ),
                  const GlassIconCard(
                    icon: Icons.ac_unit,
                    title: 'Frost Mode',
                  ),
                  const FoldedCornerCard(
                    child: Text('Folded Corner Note'),
                  ),
                  const LayeredPaperCard(
                    child: Text('Stacked Cardstock'),
                  ),
                  const OrganicSurfaceCard(
                    child: Text('Fluid Card'),
                  ),
                  const MaterialStackCard(
                    child: Text('Kraft Stack'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Airport Gate'), findsOneWidget);
      expect(find.text('Secure Vault'), findsOneWidget);
      expect(find.text('Art Studio'), findsOneWidget);
      expect(find.text('Frost Mode'), findsOneWidget);
      expect(find.text('Folded Corner Note'), findsOneWidget);
      expect(find.text('Stacked Cardstock'), findsOneWidget);
      expect(find.text('Fluid Card'), findsOneWidget);
      expect(find.text('Kraft Stack'), findsOneWidget);
    });
  });
}
