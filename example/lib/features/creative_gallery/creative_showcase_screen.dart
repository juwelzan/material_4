import 'package:dynamic_shape/dynamic_shape.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Interactive Creative Showcase Screen exhibiting Phase 7.1 features:
/// 1. Creative Borders Gallery
/// 2. Paper Background Gallery
/// 3. Notebook and Stationery Gallery
/// 4. Sculpted Icon Cards Gallery
/// 5. Embossed and Debossed Gallery
/// 6. Neumorphic Card Gallery
/// 7. Interactive Card Gallery
class CreativeShowcaseScreen extends StatefulWidget {
  const CreativeShowcaseScreen({super.key});

  @override
  State<CreativeShowcaseScreen> createState() => _CreativeShowcaseScreenState();
}

class _CreativeShowcaseScreenState extends State<CreativeShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
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
          'Creative & Tactile Studio',
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
          labelColor: const Color(0xFF5E43EE),
          unselectedLabelColor: const Color(0xFF718096),
          indicatorColor: const Color(0xFF5E43EE),
          indicatorWeight: 3.0,
          tabs: const [
            Tab(text: '1. Creative Borders'),
            Tab(text: '2. Paper Textures'),
            Tab(text: '3. Notebook & Rules'),
            Tab(text: '4. Sculpted Icon Cards'),
            Tab(text: '5. Embossed / Debossed'),
            Tab(text: '6. Neumorphism'),
            Tab(text: '7. Interactive Cards'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCreativeBordersGallery(),
          _buildPaperBackgroundGallery(),
          _buildNotebookStationeryGallery(),
          _buildSculptedIconCardsGallery(),
          _buildEmbossedDebossedGallery(),
          _buildNeumorphicGallery(),
          _buildInteractiveCardsGallery(),
        ],
      ),
    );
  }

  // =========================================================================
  // 1. Creative Borders Gallery
  // =========================================================================

  Widget _buildCreativeBordersGallery() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader('Paper & Physical Material Borders',
            'Procedural realistic ripped paper, deckled edges, burnt borders & stamps'),
        const SizedBox(height: 12),
        // Torn Paper Card
        TornPaperCard(
          tearIntensity: 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Realistic Torn Paper Edge',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Harmonic multi-octave ripped cellulose contour with microscopic paper fibers and depth shadow.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Postage Stamp Border
        DynamicShapeContainer(
          padding: const EdgeInsets.all(18),
          color: const Color(0xFFFBF8F2),
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 12,
            creativeBorder: CreativeBorderConfig.stamp(
              color: const Color(0xFF8D6E63),
              patternSize: 10,
              spacing: 14,
            ),
          ),
          child: const Text('Postage Stamp Perforations along perimeter'),
        ),
        const SizedBox(height: 16),
        // Burnt Charred Edge Card
        DynamicShapeContainer(
          padding: const EdgeInsets.all(18),
          color: const Color(0xFFFAF0E6),
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 10,
            creativeBorder: CreativeBorderConfig.burntEdge(
              tearIntensity: 0.6,
            ),
          ),
          child: const Text(
            'Charred Burnt Edge with Carbonized Rim & Amber Embers',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        // Hand-Stitched Border Card
        DynamicShapeContainer(
          padding: const EdgeInsets.all(18),
          color: Colors.white,
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 16,
            creativeBorder: CreativeBorderConfig.stitch(
              color: const Color(0xFF1976D2),
              secondaryColor: const Color(0xFF0D47A1),
              width: 2.0,
              spacing: 10,
            ),
          ),
          child: const Text('Tailored Hand-Stitch with Needle Holes'),
        ),
        const SizedBox(height: 16),
        // Neon Glow Border Card
        DynamicShapeContainer(
          padding: const EdgeInsets.all(18),
          color: const Color(0xFF121820),
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 16,
            creativeBorder: CreativeBorderConfig.neon(
              color: const Color(0xFF00E5FF),
              width: 2.5,
            ),
          ),
          child: const Text(
            'Luminous Neon Bloom Tube Border',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        // Art Deco Geometric Border
        DynamicShapeContainer(
          padding: const EdgeInsets.all(18),
          color: const Color(0xFF1A1A1A),
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 14,
            creativeBorder: CreativeBorderConfig.artDeco(
              color: const Color(0xFFD4AF37),
            ),
          ),
          child: const Text(
            '1920s Art Deco Stepped Architectural Border',
            style: TextStyle(
                color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 2. Paper Background Gallery
  // =========================================================================

  Widget _buildPaperBackgroundGallery() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader('20 Physical Paper Material Presets',
            'Tactile paper textures rendered via procedural grain, fibers, and tooth'),
        const SizedBox(height: 12),
        // Vintage Antique Paper
        const VintagePaperCard(
          child: Text(
            'Vintage Antique Parchment\nWith natural patina, edge vignette, and aged cellulose flecks.',
            style: TextStyle(fontFamily: 'serif', height: 1.4),
          ),
        ),
        const SizedBox(height: 16),
        // Natural Kraft Paper
        DynamicShapeContainer(
          padding: const EdgeInsets.all(18),
          color: const Color(0xFFD2B48C),
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 14,
            paperBackground: PaperBackgroundConfig.kraft(),
          ),
          child: const Text(
            'Natural Brown Kraft Paper\nCoarse organic wood pulp fibers and heavy tooth.',
            style: TextStyle(
                color: Color(0xFF3E2723), fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        // Cold-Press Watercolor Paper
        DynamicShapeContainer(
          padding: const EdgeInsets.all(18),
          color: const Color(0xFFFAF7F0),
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 16,
            paperBackground: PaperBackgroundConfig.watercolor(),
          ),
          child: const Text(
            '300gsm Cold-Press Watercolor Paper\nPebbled surface tooth with pigment wells.',
            style: TextStyle(color: Color(0xFF4A3B32)),
          ),
        ),
        const SizedBox(height: 16),
        // Sticky Note Paper
        const StickyNoteCard(
          child: Text(
            'Sticky Note Paper\nCanary yellow stationery with top adhesive band shadow.',
            style: TextStyle(color: Color(0xFF5D4037)),
          ),
        ),
        const SizedBox(height: 16),
        // Architectural Blueprint
        DynamicShapeContainer(
          padding: const EdgeInsets.all(18),
          color: const Color(0xFF1A365D),
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 14,
            paperBackground: PaperBackgroundConfig.blueprint(),
          ),
          child: const Text(
            'Cyanotype Architectural Blueprint\nDeep Prussian blue paper substrate with micro grid.',
            style: TextStyle(color: Colors.white, fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 3. Notebook & Stationery Gallery
  // =========================================================================

  Widget _buildNotebookStationeryGallery() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader('Notebook & Stationery Rulings',
            'College-ruled lines, margin rules, engineering grids, and penmanship guides'),
        const SizedBox(height: 12),
        // Notebook with margin
        const NotebookCard(
          height: 140,
          child: Padding(
            padding: EdgeInsets.only(left: 48, top: 8),
            child: Text(
              'Lecture Notes: Fluid Dynamics\nChapter 4: Navier-Stokes formulation\nDue Monday at 9:00 AM',
              style: TextStyle(height: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Engineering Graph Paper
        DynamicShapeContainer(
          height: 120,
          padding: const EdgeInsets.all(16),
          color: const Color(0xFFF4F7F9),
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 12,
            creativePattern: CreativePatternConfig.graphPaper(),
          ),
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Engineering Quad Graph (5x5 subdivision)',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF2C5282)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Bullet Journal Dot Grid
        DynamicShapeContainer(
          height: 120,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          config: DynamicShapeConfig(
            type: DynamicShapeType.smoothRounded,
            cornerRadius: 12,
            creativePattern: CreativePatternConfig.dotGrid(),
          ),
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Bullet Journal Dot Grid Matrix',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFF4A5568)),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 4. Sculpted Icon Cards Gallery
  // =========================================================================

  Widget _buildSculptedIconCardsGallery() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader('Sculpted Icon Cards',
            'Raised 3D icon plate with pristine, flat, readable text surface'),
        const SizedBox(height: 12),
        // Top Left Embossed Card
        SculptedIconCard.embossed(
          icon: Icons.school_rounded,
          title: 'Academic Portal',
          subtitle: 'Grade 11 Honors Physics',
          description:
              'Access lecture recordings, problem sets, and syllabus guidelines.',
          badge: 'Active Term',
          iconPosition: SculptedIconPosition.topLeft,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        // Center Left Row Card
        SculptedIconCard(
          icon: Icons.biotech_rounded,
          title: 'Molecular Biology Lab',
          subtitle: 'DNA extraction protocol',
          iconPosition: SculptedIconPosition.centerLeft,
          plateConfig: const SculptedPlateConfig(
            style: SculptedSurfaceStyle.softRaised,
            shape: SculptedPlateShape.circle,
            size: 54,
            iconColor: Color(0xFF5E43EE),
          ),
          onTap: () {},
        ),
        const SizedBox(height: 16),
        // Floating Top Card
        SculptedIconCard(
          icon: Icons.workspace_premium_rounded,
          title: 'Dean’s Honor List',
          subtitle: 'Spring 2026 Academic Excellence',
          badge: 'Scholarship',
          badgeColor: const Color(0xFFFEF3C7),
          badgeTextColor: const Color(0xFFB45309),
          iconPosition: SculptedIconPosition.floatingTop,
          plateConfig: const SculptedPlateConfig(
            style: SculptedSurfaceStyle.floating,
            iconColor: Color(0xFFD97706),
            depth: 6.0,
          ),
          onTap: () {},
        ),
        const SizedBox(height: 16),
        // Bengali Title Card (Multilingual Test)
        const SculptedIconCard(
          icon: Icons.menu_book_rounded,
          title: 'বাংলা ভাষা ও সাহিত্য',
          subtitle: 'এইচএসসি বাংলা প্রথম পত্র',
          description: 'গদ্য ও পদ্য সংকলন, ব্যাকরণ ও নির্মিতি',
          badge: 'বাধ্যতামূলক',
          iconPosition: SculptedIconPosition.centerLeft,
        ),
      ],
    );
  }

  // =========================================================================
  // 5. Embossed and Debossed Gallery
  // =========================================================================

  Widget _buildEmbossedDebossedGallery() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader('Embossed & Debossed Tactile Relief',
            'Physical 3D elevation and sunken carved surfaces'),
        const SizedBox(height: 12),
        const EmbossedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Embossed Card Surface',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 4),
              Text(
                'Projecting beveled boundary with directional top-left specular highlight.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const DebossedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Debossed Well Surface',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 4),
              Text(
                'Sunken carved relief with top shadow and bottom-right rim illumination.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const RecessedIconCard(
          icon: Icons.fingerprint_rounded,
          title: 'Biometric Access Terminal',
          subtitle: 'Carved sunken icon scanner plate',
        ),
      ],
    );
  }

  // =========================================================================
  // 6. Neumorphic Card Gallery
  // =========================================================================

  Widget _buildNeumorphicGallery() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader('Soft UI Neumorphism',
            'Directional dual-light soft bloom highlights and ambient drop shadows'),
        const SizedBox(height: 12),
        SculptedIconCard.neumorphic(
          icon: Icons.lightbulb_rounded,
          title: 'Smart Automation Hub',
          subtitle: 'Dual-directional lighting',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        const NeumorphicCard(
          child: Text(
            'Neumorphic Container Base\nPure ambient light physics on smooth squircle geometry.',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
          ),
        ),
        const SizedBox(height: 16),
        ClayCard(
          icon: Icons.palette_rounded,
          title: 'Claymorphic Marshmallow Card',
          subtitle: 'Soft volumetric rim light',
          onTap: () {},
        ),
      ],
    );
  }

  // =========================================================================
  // 7. Interactive Card Gallery
  // =========================================================================

  Widget _buildInteractiveCardsGallery() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildSectionHeader('Interactive Tactile Feedback',
            'Cards that respond dynamically to tap, press down, hover, and selection'),
        const SizedBox(height: 12),
        SculptedIconCard(
          icon: Icons.touch_app_rounded,
          title: 'Press-Interactive Plate',
          subtitle: 'Press and hold to feel the icon plate sink in',
          description:
              'The raised plate depresses on tap down while the text surface remains stable.',
          badge: 'Interactive',
          plateConfig: const SculptedPlateConfig(
            style: SculptedSurfaceStyle.embossed,
            pressInteractive: true,
            depth: 5.0,
          ),
          onTap: () {},
        ),
        const SizedBox(height: 16),
        const GlassIconCard(
          icon: Icons.shield_rounded,
          title: 'Frosted Glass Plate Card',
          subtitle: 'Backdrop glass plate with dark theme',
        ),
        const SizedBox(height: 16),
        const CouponCard(
          child: Text('Detachable 20% Discount Exam Voucher'),
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
