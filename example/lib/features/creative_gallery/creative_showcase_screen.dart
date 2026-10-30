import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Interactive Material Cards Gallery exhibiting Phase 7.2 features:
/// 1. Paper-Based Cards (12 styles)
/// 2. Sculpted Surface Cards (11 styles)
/// 3. Modern Creative Cards (14 styles)
/// 4. Special Purpose Cards (12 styles)
/// 5. Dynamic Material Studio (12 materials)
/// 6. Icon Placement & Relief Surfaces (7 positions x 4 finishes)
/// 7. Multilingual & Typography Studio (Bengali, RTL, Long text truncation)
/// 8. Interactive Spring & Accordion States
class CreativeShowcaseScreen extends StatefulWidget {
  const CreativeShowcaseScreen({super.key});

  @override
  State<CreativeShowcaseScreen> createState() => _CreativeShowcaseScreenState();
}

class _CreativeShowcaseScreenState extends State<CreativeShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Interactive Material Studio state
  DynamicMaterial _selectedMaterial = DynamicMaterial.clay;
  double _materialDepth = 6.0;

  // Interactive Selection State
  bool _card1Selected = true;
  bool _card2Selected = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: Text(
          'Dynamic Material Cards Studio',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF4F46E5),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF4F46E5),
          indicatorWeight: 3.0,
          tabs: const [
            Tab(text: '1. Paper Cards'),
            Tab(text: '2. Sculpted Surfaces'),
            Tab(text: '3. Modern Creative'),
            Tab(text: '4. Special Purpose'),
            Tab(text: '5. Material Studio'),
            Tab(text: '6. Icon & Relief'),
            Tab(text: '7. Bengali & RTL'),
            Tab(text: '8. Interactions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPaperCardsTab(),
          _buildSculptedSurfacesTab(),
          _buildModernCardsTab(),
          _buildSpecialPurposeTab(),
          _buildMaterialStudioTab(),
          _buildIconAndReliefTab(),
          _buildMultilingualTab(),
          _buildInteractionsTab(),
        ],
      ),
    );
  }

  // =========================================================================
  // 1. Paper-Based Cards
  // =========================================================================

  Widget _buildPaperCardsTab() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader(
          'Authentic Paper Craft & Stationery',
          'Physical cards with torn edges, deckled margins, tape strips, and fiber teeth',
        ),
        const SizedBox(height: 14),
        const TornPaperCard(
          child: Text(
            'TornPaperCard\nRealistic ripped boundary with embedded fiber specks and cast shadow.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
          ),
        ),
        const SizedBox(height: 16),
        const NotebookCard(
          child: Text(
            'NotebookCard\nRuled horizontal writing guides with red margin indicator.',
            style: TextStyle(color: Color(0xFF1E293B)),
          ),
        ),
        const SizedBox(height: 16),
        const StickyNoteCard(
          child: Text(
            'StickyNoteCard\nCanary yellow stationery note with translucent top adhesive tape.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
          ),
        ),
        const SizedBox(height: 16),
        const VintagePaperCard(
          child: Text(
            'VintagePaperCard\nAged parchment with scorched burnt edges and sepia patina.',
            style: TextStyle(
                fontStyle: FontStyle.italic, color: Color(0xFF3E2723)),
          ),
        ),
        const SizedBox(height: 16),
        const LayeredPaperCard(
          child: Text(
            'LayeredPaperCard\nMultiple stacked sheets with rotational skew and cascading shadows.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        const FoldedPaperCard(
          child: Text(
            'FoldedPaperCard\nOrigami corner fold with realistic crease highlight and shadow.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        const KraftPaperCard(
          child: Text(
            'KraftPaperCard\nHeavy unbleached cardboard with organic fiber inclusions.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF3E2723)),
          ),
        ),
        const SizedBox(height: 16),
        const RecycledPaperCard(
          child: Text(
            'RecycledPaperCard\nEco-friendly paper with visible cellulose flakes.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF4E342E)),
          ),
        ),
        const SizedBox(height: 16),
        const ParchmentCard(
          child: Text(
            'ParchmentCard\nHistoric manuscript parchment with deckled feathered edges.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF4A3B32)),
          ),
        ),
        const SizedBox(height: 16),
        const PaperStackCard(
          child: Text(
            'PaperStackCard\n3-sheet cascading physical depth stack.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        const PaperCutoutCard(
          cutoutChild: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cut, size: 18, color: Color(0xFF5D4037)),
              SizedBox(width: 8),
              Text('Cutout Window Silhouette',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          child: Text(
            'PaperCutoutCard\nRecessed paper craft depth with inner shadow well.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        const PaperTicketCard(
          stub: Text('ADMIT 1', style: TextStyle(fontWeight: FontWeight.bold)),
          child: Text('Concert Voucher 2026'),
        ),
      ],
    );
  }

  // =========================================================================
  // 2. Sculpted Surface Cards
  // =========================================================================

  Widget _buildSculptedSurfacesTab() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader(
          'Sculpted 3D Surfaces',
          'Physical elevations, recessed wells, claymorphism, and porcelain ceramic',
        ),
        const SizedBox(height: 14),
        const EmbossedCard(
          child: Text(
            'EmbossedCard\nPhysically raised relief with top-left specular illumination.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ),
        const SizedBox(height: 16),
        const DebossedCard(
          child: Text(
            'DebossedCard\nPressed or carved cavity with realistic inner top shadow.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ),
        const SizedBox(height: 16),
        const NeumorphicCard(
          child: Text(
            'NeumorphicCard\nBalanced twin directional lighting for soft tactility.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF334155)),
          ),
        ),
        const SizedBox(height: 16),
        const SoftRaisedCard(
          child: Text(
            'SoftRaisedCard\nGently elevated pillowy surface with wide ambient diffusion.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
          ),
        ),
        const SizedBox(height: 16),
        const HardRaisedCard(
          child: Text(
            'HardRaisedCard\nCrisp architectural bevel with solid drop shadow offset.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ),
        const SizedBox(height: 16),
        const RecessedCard(
          child: Text(
            'RecessedCard\nCarved well inside container with dark top shadow and rim light.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF334155)),
          ),
        ),
        const SizedBox(height: 16),
        const FloatingSurfaceCard(
          child: Text(
            'FloatingSurfaceCard\nSeparated elevated plate with deep ambient shadow.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ),
        const SizedBox(height: 16),
        const ClayCard(
          child: Text(
            'ClayCard\nThick, soft marshmallow claymorphism with volumetric rim lighting.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF4A3E3D)),
          ),
        ),
        const SizedBox(height: 16),
        const CeramicCard(
          child: Text(
            'CeramicCard\nUltra-clean, high-gloss polished porcelain with crisp speculars.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ),
        const SizedBox(height: 16),
        const OrganicSurfaceCard(
          child: Text(
            'OrganicSurfaceCard\nCurved fluid boundary with organic watercolor tooth.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF334155)),
          ),
        ),
        const SizedBox(height: 16),
        const LayeredMaterialCard(
          header: Text('Composite Tier Header',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          child: Text(
            'LayeredMaterialCard\nCombining multiple material textures into one cohesive container.',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 3. Modern Creative Cards
  // =========================================================================

  Widget _buildModernCardsTab() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader(
          'Modern Creative Geometries',
          'Frosted glass, neon bloom, fluid mesh, asymmetric corners, and editorial grids',
        ),
        const SizedBox(height: 14),
        const GlassCard(
          child: Text(
            'GlassCard\nFrosted translucent glassmorphism with rim reflection.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),
        ),
        const SizedBox(height: 16),
        const GradientCard(
          child: Text(
            'GradientCard\nMulti-stop linear color flow with specular highlight.',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        const GlowCard(
          child: Text(
            'GlowCard\nRadiant colored aura contouring the shape boundary.',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        const NeonCard(
          child: Text(
            'NeonCard\nCyberpunk gas tube bloom emission.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF00FFCC)),
          ),
        ),
        const SizedBox(height: 16),
        const MeshGradientCard(
          child: Text(
            'MeshGradientCard\nMulti-point coordinate fluid gradient mesh.',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        const FloatingCard(
          child: Text(
            'FloatingCard\nMulti-plane elevation with ambient drop shadow.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ),
        const SizedBox(height: 16),
        const OrganicBlobCard(
          child: Text(
            'OrganicBlobCard\nLiving amoeba-like dynamic curved boundary.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF6B21A8)),
          ),
        ),
        const SizedBox(height: 16),
        const AsymmetricCard(
          child: Text(
            'AsymmetricCard\nDistinct diagonal corner radii for editorial distinction.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ),
        const SizedBox(height: 16),
        const CutCornerCard(
          child: Text(
            'CutCornerCard\nGeometric 45-degree chamfered technical corners.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ),
        const SizedBox(height: 16),
        const NotchedCard(
          child: Text(
            'NotchedCard\nFunctional cutouts along container edge for dockable chips.',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ),
        const SizedBox(height: 16),
        const MagazineCard(
          category: 'Architecture',
          headline: 'Next-Gen Structural Geometry in Modern UI Design',
          excerpt:
              'Exploration of tactile physical computing, parametric vector shapes, and hardware acceleration.',
          date: 'OCT 30, 2026',
        ),
        const SizedBox(height: 16),
        const EditorialCard(
          child: Text(
            'EditorialCard\nMuseum monograph aesthetic with hairline framing and generous space.',
            style: TextStyle(
                fontFamily: 'serif', fontSize: 15, color: Color(0xFF1C1917)),
          ),
        ),
        const SizedBox(height: 16),
        const MinimalSurfaceCard(
          child: Text(
            'MinimalSurfaceCard\nWhisper-thin 0.5px hairline border with nuanced tone.',
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Color(0xFF334155)),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 4. Special Purpose Cards
  // =========================================================================

  Widget _buildSpecialPurposeTab() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader(
          'Special Purpose Production Cards',
          'Domain-specific cards designed for profiles, dashboards, features, and e-commerce',
        ),
        const SizedBox(height: 14),
        const ProfileCard(
          name: 'Sarah Connor',
          role: 'Principal Systems Architect',
          status: 'Available for projects',
          isOnline: true,
        ),
        const SizedBox(height: 16),
        const FeatureCard(
          icon: Icons.speed_rounded,
          title: 'Direct RenderBox Pipeline',
          description:
              'Zero CustomPaint overhead. Native direct canvas painting handles shapes, borders, and shadows seamlessly.',
          badge: 'PERFORMANCE',
        ),
        const SizedBox(height: 16),
        ActionCard(
          icon: Icons.rocket_launch_rounded,
          title: 'Launch Space Expedition',
          subtitle: 'Initialize trajectory calculation',
          actionLabel: 'Deploy Now',
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        const StatisticsCard(
          value: '\$482,900',
          label: 'Quarterly Package Impact',
          delta: '+24.8% vs last cycle',
          icon: Icons.trending_up_rounded,
        ),
        const SizedBox(height: 16),
        NotificationCard(
          title: 'Render Cache Optimized',
          message:
              'All 28 dynamic shape paths successfully cached in GPU memory.',
          timestamp: 'Just now',
          icon: Icons.check_circle_outline,
          accentColor: const Color(0xFF10B981),
          onDismiss: () {},
        ),
        const SizedBox(height: 16),
        const InformationCard(
          title: 'Implementation Specifications',
          bulletPoints: [
            '100% backward compatibility with all presets',
            'Full support for Bengali & RTL text scripts',
            'Zero layout collisions between icon plates and titles',
          ],
          footerNote: 'Flutter Universal Dynamic Shape Engine v2.0',
          icon: Icons.info_outline,
        ),
        const SizedBox(height: 16),
        const MenuCard(
          title: 'WORKSPACE PREFERENCES',
          items: [
            ListTile(
              dense: true,
              leading: Icon(Icons.brush),
              title: Text('Material Theme Settings'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.security),
              title: Text('Security & Access Rules'),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const CategoryCard(
          title: 'Creative Materials',
          icon: Icons.category,
          itemCount: 12,
        ),
        const SizedBox(height: 16),
        const ProductCard(
          title: 'Minimalist Ceramic Coffee Cup',
          price: '\$32.00',
          rating: 4.9,
        ),
        const SizedBox(height: 16),
        const DashboardCard(
          title: 'CONCURRENT ENGINE INSTANCES',
          value: '4,281',
          subtitle: 'All instances healthy',
        ),
      ],
    );
  }

  // =========================================================================
  // 5. Dynamic Material Studio
  // =========================================================================

  Widget _buildMaterialStudioTab() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader(
          'Interactive Material Studio',
          'Explore all 12 physical material finishes in real time',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DynamicMaterial.values.map((mat) {
            final isSelected = _selectedMaterial == mat;
            return ChoiceChip(
              label: Text(mat.name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedMaterial = mat);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Elevation Depth:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Slider(
                value: _materialDepth,
                min: 1.0,
                max: 18.0,
                divisions: 17,
                label: _materialDepth.toStringAsFixed(1),
                onChanged: (val) => setState(() => _materialDepth = val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        MaterialDynamicCard(
          materialConfig: DynamicMaterialConfig(
            material: _selectedMaterial,
            depth: _materialDepth,
          ),
          icon: Icons.view_in_ar_rounded,
          iconPosition: CardIconPosition.leading,
          iconSurface: CardSurfaceType.raised,
          title: 'Active Material: ${_selectedMaterial.name.toUpperCase()}',
          subtitle: 'Real-time directional lighting & specular simulation',
          description:
              'Engine translates physical roughness, depth, and specular sheen into optimized canvas operations.',
          badge: 'LIVE PREVIEW',
        ),
      ],
    );
  }

  // =========================================================================
  // 6. Icon Placement & Relief Surfaces
  // =========================================================================

  Widget _buildIconAndReliefTab() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader(
          'Icon Positions & Relief Surfaces',
          'All 7 icon layout anchors and 4 physical elevation finishes',
        ),
        const SizedBox(height: 14),
        const MaterialDynamicCard(
          icon: Icons.star_rounded,
          iconPosition: CardIconPosition.leading,
          iconSurface: CardSurfaceType.raised,
          title: 'Leading Raised Icon',
          subtitle: 'Inline before text content with 3D bevel',
        ),
        const SizedBox(height: 14),
        const MaterialDynamicCard(
          icon: Icons.bookmark_rounded,
          iconPosition: CardIconPosition.trailing,
          iconSurface: CardSurfaceType.recessed,
          title: 'Trailing Recessed Icon',
          subtitle: 'Inline after text content inside carved well',
        ),
        const SizedBox(height: 14),
        const MaterialDynamicCard(
          icon: Icons.wb_sunny_rounded,
          iconPosition: CardIconPosition.top,
          iconSurface: CardSurfaceType.floating,
          title: 'Top Floating Icon',
          subtitle: 'Stacked vertically above headline with ambient shadow',
        ),
        const SizedBox(height: 14),
        const MaterialDynamicCard(
          icon: Icons.explore_rounded,
          iconPosition: CardIconPosition.floatingCorner,
          iconSurface: CardSurfaceType.floating,
          title: 'Floating Corner Plate',
          subtitle:
              'Hovers dynamically over the top-leading container boundary',
        ),
      ],
    );
  }

  // =========================================================================
  // 7. Multilingual & Typography Studio
  // =========================================================================

  Widget _buildMultilingualTab() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader(
          'Bengali & RTL Multilingual Studio',
          'Flawless script rendering with zero collision or text truncation issues',
        ),
        const SizedBox(height: 14),
        const MaterialDynamicCard(
          icon: Icons.auto_awesome,
          iconPosition: CardIconPosition.leading,
          iconSurface: CardSurfaceType.raised,
          title: 'বাংলা ডায়নামিক শেপ কার্ড',
          subtitle: 'রেন্ডারবক্স আর্কিটেকচারে সম্পূর্ণ কাস্টম ডিজাইন',
          description:
              'বাংলা লিপির প্রতিটি যুক্তবর্ণ এবং স্বরচিহ্ন কোনো প্রকার সমস্যা ছাড়াই নিখুঁতভাবে প্রদর্শিত হয়।',
          badge: 'বাংলা',
          metadata: '৩০ অক্টোবর ২০২৬',
        ),
        const SizedBox(height: 16),
        const Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialDynamicCard(
            icon: Icons.translate_rounded,
            iconPosition: CardIconPosition.leading,
            iconSurface: CardSurfaceType.recessed,
            title: 'بطاقة التصميم الديناميكي',
            subtitle: 'دعم كامل للكتابة من اليمين إلى اليسار',
            description:
                'الرموز والأيقونات تتكيف تلقائياً مع اتجاه النص العربي.',
            badge: 'عربي',
            metadata: 'من اليمين لليسار',
          ),
        ),
        const SizedBox(height: 16),
        const MaterialDynamicCard(
          icon: Icons.wrap_text,
          title:
              'Extremely Long Title Headline That Stretches Beyond Normal Container Boundaries To Demonstrate Ellipsis',
          description:
              'This is a multi-line extended descriptive body text designed to prove that the card respects maxLines limits and clips gracefully without any RenderFlex overflow exceptions.',
          titleMaxLines: 1,
          descriptionMaxLines: 2,
          badge: 'OVERFLOW SAFE',
        ),
      ],
    );
  }

  // =========================================================================
  // 8. Interactive Spring & Accordion States
  // =========================================================================

  Widget _buildInteractionsTab() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader(
          'Interactive Spring & Accordion',
          'Responsive spring scaling, hover elevation, selection toggle, and smooth expansion',
        ),
        const SizedBox(height: 14),
        ExpandableCard(
          title: 'How does RenderBox improve performance?',
          subtitle: 'Tap to expand accordion explanation',
          expandedChild: const Text(
            'By bypassing CustomPaint widgets and painting directly on the Canvas within RenderBox.paint(), the engine eliminates intermediate layer compositing, reduces widget tree depth, and bounds path cache memory.',
            style: TextStyle(height: 1.4, color: Color(0xFF334155)),
          ),
        ),
        const SizedBox(height: 16),
        SelectableCard(
          title: 'Option A: Hardware-Accelerated Shaders',
          subtitle: 'Optimized for high framerate mobile devices',
          selected: _card1Selected,
          onSelectedChanged: (val) => setState(() => _card1Selected = val),
        ),
        const SizedBox(height: 12),
        SelectableCard(
          title: 'Option B: Procedural Noise Backgrounds',
          subtitle: 'Authentic physical paper tooth grain',
          selected: _card2Selected,
          onSelectedChanged: (val) => setState(() => _card2Selected = val),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E1E24),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF718096),
          ),
        ),
      ],
    );
  }
}
