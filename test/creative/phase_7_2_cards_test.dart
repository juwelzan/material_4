import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 7.2: Card Categories Tests', () {
    testWidgets('Category A: All 12 Paper-Based Cards render cleanly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const LayeredPaperCard(child: Text('1. LayeredPaperCard')),
                  const TornPaperCard(child: Text('2. TornPaperCard')),
                  const FoldedPaperCard(child: Text('3. FoldedPaperCard')),
                  const StickyNoteCard(child: Text('4. StickyNoteCard')),
                  const VintagePaperCard(child: Text('5. VintagePaperCard')),
                  const NotebookCard(child: Text('6. NotebookCard')),
                  const KraftPaperCard(child: Text('7. KraftPaperCard')),
                  const RecycledPaperCard(child: Text('8. RecycledPaperCard')),
                  const ParchmentCard(child: Text('9. ParchmentCard')),
                  const PaperStackCard(child: Text('10. PaperStackCard')),
                  const PaperCutoutCard(
                    cutoutChild: Icon(Icons.favorite),
                    child: Text('11. PaperCutoutCard'),
                  ),
                  const PaperTicketCard(
                    stub: Text('STUB-01'),
                    child: Text('12. PaperTicketCard'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('1. LayeredPaperCard'), findsOneWidget);
      expect(find.text('2. TornPaperCard'), findsOneWidget);
      expect(find.text('3. FoldedPaperCard'), findsOneWidget);
      expect(find.text('4. StickyNoteCard'), findsOneWidget);
      expect(find.text('5. VintagePaperCard'), findsOneWidget);
      expect(find.text('6. NotebookCard'), findsOneWidget);
      expect(find.text('7. KraftPaperCard'), findsOneWidget);
      expect(find.text('8. RecycledPaperCard'), findsOneWidget);
      expect(find.text('9. ParchmentCard'), findsOneWidget);
      expect(find.text('10. PaperStackCard'), findsOneWidget);
      expect(find.text('11. PaperCutoutCard'), findsOneWidget);
      expect(find.text('12. PaperTicketCard'), findsOneWidget);
      expect(find.text('STUB-01'), findsOneWidget);
    });

    testWidgets('Category B: All 11 Sculpted Surface Cards render cleanly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  EmbossedCard(child: Text('1. EmbossedCard')),
                  DebossedCard(child: Text('2. DebossedCard')),
                  NeumorphicCard(child: Text('3. NeumorphicCard')),
                  SoftRaisedCard(child: Text('4. SoftRaisedCard')),
                  HardRaisedCard(child: Text('5. HardRaisedCard')),
                  RecessedCard(child: Text('6. RecessedCard')),
                  FloatingSurfaceCard(child: Text('7. FloatingSurfaceCard')),
                  ClayCard(child: Text('8. ClayCard')),
                  CeramicCard(child: Text('9. CeramicCard')),
                  OrganicSurfaceCard(child: Text('10. OrganicSurfaceCard')),
                  LayeredMaterialCard(child: Text('11. LayeredMaterialCard')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('1. EmbossedCard'), findsOneWidget);
      expect(find.text('2. DebossedCard'), findsOneWidget);
      expect(find.text('3. NeumorphicCard'), findsOneWidget);
      expect(find.text('4. SoftRaisedCard'), findsOneWidget);
      expect(find.text('5. HardRaisedCard'), findsOneWidget);
      expect(find.text('6. RecessedCard'), findsOneWidget);
      expect(find.text('7. FloatingSurfaceCard'), findsOneWidget);
      expect(find.text('8. ClayCard'), findsOneWidget);
      expect(find.text('9. CeramicCard'), findsOneWidget);
      expect(find.text('10. OrganicSurfaceCard'), findsOneWidget);
      expect(find.text('11. LayeredMaterialCard'), findsOneWidget);
    });

    testWidgets('Category C: All 14 Modern Creative Cards render cleanly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  GlassCard(child: Text('1. GlassCard')),
                  GradientCard(child: Text('2. GradientCard')),
                  GlowCard(child: Text('3. GlowCard')),
                  NeonCard(child: Text('4. NeonCard')),
                  MeshGradientCard(child: Text('5. MeshGradientCard')),
                  FloatingCard(child: Text('6. FloatingCard')),
                  OrganicBlobCard(child: Text('7. OrganicBlobCard')),
                  AsymmetricCard(child: Text('8. AsymmetricCard')),
                  CutCornerCard(child: Text('9. CutCornerCard')),
                  NotchedCard(child: Text('10. NotchedCard')),
                  TicketCard(child: Text('11. TicketCard')),
                  MagazineCard(
                    category: 'Design',
                    headline: '12. MagazineCard',
                  ),
                  EditorialCard(child: Text('13. EditorialCard')),
                  MinimalSurfaceCard(child: Text('14. MinimalSurfaceCard')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('1. GlassCard'), findsOneWidget);
      expect(find.text('2. GradientCard'), findsOneWidget);
      expect(find.text('3. GlowCard'), findsOneWidget);
      expect(find.text('4. NeonCard'), findsOneWidget);
      expect(find.text('5. MeshGradientCard'), findsOneWidget);
      expect(find.text('6. FloatingCard'), findsOneWidget);
      expect(find.text('7. OrganicBlobCard'), findsOneWidget);
      expect(find.text('8. AsymmetricCard'), findsOneWidget);
      expect(find.text('9. CutCornerCard'), findsOneWidget);
      expect(find.text('10. NotchedCard'), findsOneWidget);
      expect(find.text('11. TicketCard'), findsOneWidget);
      expect(find.text('12. MagazineCard'), findsOneWidget);
      expect(find.text('13. EditorialCard'), findsOneWidget);
      expect(find.text('14. MinimalSurfaceCard'), findsOneWidget);
    });

    testWidgets('Category D: All 12 Special Purpose Cards render cleanly',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const ProfileCard(
                    name: 'Dr. Jane Smith',
                    role: 'Chief Architect',
                  ),
                  const FeatureCard(
                    icon: Icons.flash_on,
                    title: 'Lightning Fast',
                    description: 'RenderBox direct canvas rendering pipeline',
                  ),
                  const ActionCard(
                    title: 'Upgrade Plan',
                    actionLabel: 'Get Started',
                  ),
                  const StatisticsCard(
                    value: '99.98%',
                    label: 'System Uptime',
                    delta: '+0.4%',
                  ),
                  const NotificationCard(
                    title: 'New Update Available',
                    message: 'Universal Dynamic Shape v2.0 is ready to install',
                  ),
                  const InformationCard(
                    title: 'Important Guidelines',
                    bulletPoints: ['Follow RenderBox rules', 'Zero saveLayer'],
                  ),
                  const MenuCard(
                    title: 'SETTINGS',
                    items: [
                      ListTile(title: Text('Account Settings')),
                    ],
                  ),
                  const CategoryCard(
                    title: 'Typography',
                    icon: Icons.font_download,
                    itemCount: 42,
                  ),
                  const ProductCard(
                    title: 'Ceramic Espresso Cup',
                    price: '\$24.00',
                    rating: 4.9,
                  ),
                  const DashboardCard(
                    title: 'Active Nodes',
                    value: '1,420',
                  ),
                  const ExpandableCard(
                    title: 'Accordion Question',
                    expandedChild: Text('Accordion Answer Details'),
                  ),
                  const SelectableCard(
                    title: 'Checkbox Card Option',
                    selected: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Dr. Jane Smith'), findsOneWidget);
      expect(find.text('Lightning Fast'), findsOneWidget);
      expect(find.text('Upgrade Plan'), findsOneWidget);
      expect(find.text('99.98%'), findsOneWidget);
      expect(find.text('New Update Available'), findsOneWidget);
      expect(find.text('Important Guidelines'), findsOneWidget);
      expect(find.text('Typography'), findsOneWidget);
      expect(find.text('Ceramic Espresso Cup'), findsOneWidget);
      expect(find.text('Active Nodes'), findsOneWidget);
      expect(find.text('Accordion Question'), findsOneWidget);
      expect(find.text('Checkbox Card Option'), findsOneWidget);
    });
  });
}

