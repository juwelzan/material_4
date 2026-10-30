import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_4/material_4.dart';

/// Complete showcase screen organizing Material 4 into 10 structured sections:
/// 1. Basic Shapes
/// 2. Advanced Shapes
/// 3. Creative Borders
/// 4. Paper Backgrounds
/// 5. Advanced Effects
/// 6. Sculpted Icon Cards
/// 7. Material Cards
/// 8. Shape Morphing
/// 9. Interactive Components
/// 10. Custom Configuration
class Material4ShowcaseScreen extends StatefulWidget {
  final int initialSectionIndex;

  const Material4ShowcaseScreen({
    super.key,
    this.initialSectionIndex = 0,
  });

  @override
  State<Material4ShowcaseScreen> createState() =>
      _Material4ShowcaseScreenState();
}

class _Material4ShowcaseScreenState extends State<Material4ShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State for Section 8: Shape Morphing
  int _morphIndex = 0;
  final List<Material4Type> _morphSequence = const [
    Material4Type.folderTab,
    Material4Type.ticketScallop,
    Material4Type.notchedBadge,
    Material4Type.hexagonSoft,
    Material4Type.arch,
    Material4Type.organicBlob,
  ];

  // State for Section 10: Custom Configuration Studio
  Material4Type _customType = Material4Type.ticketScallop;
  double _customCornerRadius = 16.0;
  double _customScallopRadius = 16.0;
  double _customBorderWidth = 2.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 10,
      vsync: this,
      initialIndex: widget.initialSectionIndex.clamp(0, 9),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Material 4 Showcase',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E1E24),
        elevation: 0.5,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF5E43EE),
          unselectedLabelColor: const Color(0xFF6C757D),
          indicatorColor: const Color(0xFF5E43EE),
          indicatorWeight: 3.0,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: '1. Basic Shapes'),
            Tab(text: '2. Advanced Shapes'),
            Tab(text: '3. Creative Borders'),
            Tab(text: '4. Paper Backgrounds'),
            Tab(text: '5. Advanced Effects'),
            Tab(text: '6. Sculpted Icon Cards'),
            Tab(text: '7. Material Cards'),
            Tab(text: '8. Shape Morphing'),
            Tab(text: '9. Interactive Components'),
            Tab(text: '10. Custom Configuration'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicShapesTab(),
          _buildAdvancedShapesTab(),
          _buildCreativeBordersTab(),
          _buildPaperBackgroundsTab(),
          _buildAdvancedEffectsTab(),
          _buildSculptedIconCardsTab(),
          _buildMaterialCardsTab(),
          _buildShapeMorphingTab(),
          _buildInteractiveComponentsTab(),
          _buildCustomConfigurationTab(),
        ],
      ),
    );
  }

  // =========================================================================
  // 1. Basic Shapes
  // =========================================================================
  Widget _buildBasicShapesTab() {
    const basicShapes = [
      (Material4Type.smoothRounded, 'Squircle', 'G2 continuous super-ellipse'),
      (Material4Type.folderTab, 'Folder Tab', 'Convex/concave tab geometry'),
      (Material4Type.capsule, 'Capsule', 'Full semicircular pill caps'),
      (Material4Type.arch, 'Arch', 'Roman cathedral dome curvature'),
      (Material4Type.hexagonSoft, 'Hexagon Soft', '6-vertex rounded polygon'),
      (Material4Type.diamond, 'Diamond', 'Rhombus with rounded points'),
      (Material4Type.octagon, 'Octagon', 'Symmetrical 8-sided contour'),
      (Material4Type.shield, 'Shield', 'Tapered heraldic badge crest'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '1. Basic Geometries',
          'Foundational hardware-accelerated shapes with parameter-driven contours.',
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 175,
          ),
          itemCount: basicShapes.length,
          itemBuilder: (context, index) {
            final (type, title, subtitle) = basicShapes[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1.35,
                        child: Material4Container(
                          config: Material4Config(
                            type: type,
                            cornerRadius: 14,
                            tabWidth: 50,
                            tabHeight: 12,
                          ),
                          color:
                              const Color(0xFF5E43EE).withValues(alpha: 0.08),
                          borderColor: const Color(0xFF5E43EE),
                          borderWidth: 1.5,
                          child: const Center(
                            child: Icon(Icons.category_outlined,
                                size: 22, color: Color(0xFF5E43EE)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: const Color(0xFF1E1E24),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: const Color(0xFF7A7A85),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // 2. Advanced Shapes
  // =========================================================================
  Widget _buildAdvancedShapesTab() {
    const advancedShapes = [
      (
        Material4Type.ticketScallop,
        'Ticket Scallop',
        'Circular cutouts on sides'
      ),
      (
        Material4Type.postageStamp,
        'Postage Stamp',
        'Perforated edge sinusoidal series'
      ),
      (
        Material4Type.zigzagCut,
        'Zigzag Cut',
        'Sawtooth triangular edge vouchers'
      ),
      (
        Material4Type.chamferDiagonal,
        'Chamfer Diagonal',
        '45° corner beveled chamfer'
      ),
      (
        Material4Type.organicBlob,
        'Organic Blob',
        'Multi-quadrant fluid Bézier curve'
      ),
      (
        Material4Type.scallopedPetal,
        'Scalloped Petal',
        'Rosette flower perimeter'
      ),
      (
        Material4Type.asymmetricCard,
        'Asymmetric Card',
        'Distinct independent 4 radii'
      ),
      (Material4Type.waveEdge, 'Wave Edge', 'Fluid harmonic sinusoidal crest'),
      (Material4Type.cloud, 'Cloud', 'Multi-lobed organic perimeter'),
      (
        Material4Type.speechBubble,
        'Speech Bubble',
        'Chat balloon with directional tail'
      ),
      (Material4Type.waveCut, 'Wave Cut', 'Lateral fluid crest slice cut'),
      (
        Material4Type.concaveRounded,
        'Concave Rounded',
        'Inward curved cut corners'
      ),
      (
        Material4Type.convexRounded,
        'Convex Rounded',
        'Protruding outward pill arches'
      ),
      (
        Material4Type.parallelogram,
        'Parallelogram',
        'Directional dynamic skew polygon'
      ),
      (Material4Type.ribbon, 'Ribbon', 'Folded end ceremonial banner'),
      (Material4Type.bookmark, 'Bookmark', 'Inverted triangular hanging notch'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '2. Advanced Geometries',
          'Expressive mathematical curves, notches, tabs, and parametric cuts.',
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 175,
          ),
          itemCount: advancedShapes.length,
          itemBuilder: (context, index) {
            final (type, title, subtitle) = advancedShapes[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1.35,
                        child: Material4Container(
                          config: Material4Config(
                            type: type,
                            cornerRadius: 14,
                            scallopRadius: 10,
                            toothWidth: 8,
                            toothHeight: 6,
                            petalCount: 8,
                            waveAmplitude: 5,
                            waveCount: 3,
                            corners: type == Material4Type.asymmetricCard
                                ? ShapeCorners.only(
                                    topLeft: const Radius.circular(22),
                                    bottomRight: const Radius.circular(22),
                                    topRight: const Radius.circular(6),
                                    bottomLeft: const Radius.circular(6),
                                  )
                                : null,
                          ),
                          color:
                              const Color(0xFF00796B).withValues(alpha: 0.08),
                          borderColor: const Color(0xFF00796B),
                          borderWidth: 1.5,
                          child: const Center(
                            child: Icon(Icons.auto_awesome_mosaic_outlined,
                                size: 22, color: Color(0xFF00796B)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: const Color(0xFF1E1E24),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: const Color(0xFF7A7A85),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // 3. Creative Borders
  // =========================================================================
  Widget _buildCreativeBordersTab() {
    final borderDemos = [
      (
        'Torn Paper Border',
        CreativeBorderConfig.tornPaper(
          tearIntensity: 0.8,
          color: const Color(0xFF8D6E63),
        ),
        'Realistic fibrous paper edge with depth shadow',
      ),
      (
        'Postage Stamp Edge',
        CreativeBorderConfig.stamp(
          color: const Color(0xFF6D4C41),
          patternSize: 8.0,
          spacing: 12.0,
        ),
        'Traditional continuous circular perforated cutouts',
      ),
      (
        'Burnt / Charred Border',
        CreativeBorderConfig.burntEdge(
          tearIntensity: 0.5,
        ),
        'Weathered dark toasted scorch perimeter',
      ),
      (
        'Hand-Stitched Thread',
        CreativeBorderConfig.stitch(
          color: const Color(0xFF4A6572),
          width: 2.0,
        ),
        'Artisanal needlework perimeter stitch lines',
      ),
      (
        'Double Stroke Border',
        CreativeBorderConfig.doubleLine(
          color: const Color(0xFF1565C0),
          width: 1.5,
          spacing: 3.0,
        ),
        'Concentric parallel weighted line pair',
      ),
      (
        'Neon Bloom Border',
        CreativeBorderConfig.neon(
          color: const Color(0xFF00E5FF),
          width: 2.5,
        ),
        'Luminous gas tube with soft outer bloom',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '3. Creative Border Engine',
          'Organic paper tears, stitches, concentric strokes, and neon tubes.',
        ),
        const SizedBox(height: 16),
        ...borderDemos.map((demo) {
          final (title, borderConfig, desc) = demo;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Material4Container(
              width: double.infinity,
              height: 95,
              config: Material4Config(
                type: Material4Type.smoothRounded,
                cornerRadius: 16,
                creativeBorder: borderConfig,
              ),
              color: const Color(0xFFFFFDF9),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.border_style_rounded,
                        color: Color(0xFF5E43EE), size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: const Color(0xFF1E1E24),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            desc,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: const Color(0xFF7A7A85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // =========================================================================
  // 4. Paper Backgrounds
  // =========================================================================
  Widget _buildPaperBackgroundsTab() {
    const paperStyles = [
      (
        PaperBackgroundStyle.plainWhite,
        'Plain White Stationery',
        'Bright clean office stock'
      ),
      (
        PaperBackgroundStyle.vintage,
        'Vintage Parchment',
        'Aged sepia historical parchment'
      ),
      (
        PaperBackgroundStyle.kraft,
        'Brown Kraft Paper',
        'Natural organic fibrous pulp'
      ),
      (
        PaperBackgroundStyle.watercolor,
        'Cold-Press Watercolor',
        'Rough tooth textured sheet'
      ),
      (
        PaperBackgroundStyle.canvas,
        'Artist Canvas',
        'Orthogonal woven textile grain'
      ),
      (
        PaperBackgroundStyle.notebook,
        'Ruled Notebook',
        'College ruled lines with red margin'
      ),
      (
        PaperBackgroundStyle.graph,
        'Quad Graph Grid',
        'Precision engineering grid'
      ),
      (
        PaperBackgroundStyle.blueprint,
        'Cyanotype Blueprint',
        'Architectural deep Prussian blue'
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '4. Tactile Paper Backgrounds',
          'Procedural physical substrates with realistic grain, margins, and grids.',
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 140,
          ),
          itemCount: paperStyles.length,
          itemBuilder: (context, index) {
            final (style, name, desc) = paperStyles[index];
            final isDark = style == PaperBackgroundStyle.blueprint;

            return Material4Container(
              config: Material4Config(
                type: Material4Type.smoothRounded,
                cornerRadius: 14,
                paperBackground: PaperBackgroundConfig(style: style),
              ),
              borderColor:
                  isDark ? const Color(0xFF90CAF9) : const Color(0x22000000),
              borderWidth: 1.0,
              shadows: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color:
                              isDark ? Colors.white : const Color(0xFF1E1E24),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 9.5,
                          color:
                              isDark ? Colors.white70 : const Color(0xFF7A7A85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // 5. Advanced Effects
  // =========================================================================
  Widget _buildAdvancedEffectsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '5. Advanced Shader & Surface Effects',
          'Frosted glassmorphism, inner relief shadows, shimmer sweeps, and aurora gradients.',
        ),
        const SizedBox(height: 16),

        // 1. Frosted Glassmorphism
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF8A80),
                    Color(0xFF82B1FF),
                    Color(0xFFB388FF)
                  ],
                ),
              ),
            ),
            Material4Container.glass(
              width: 300,
              height: 100,
              glassBlur: 16.0,
              glassTint: const Color(0x33FFFFFF),
              borderColor: Colors.white.withValues(alpha: 0.6),
              borderWidth: 1.5,
              child: Center(
                child: Text(
                  'Frosted Glassmorphism with Blur',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                    shadows: const [
                      Shadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // 2. Shimmer Holographic Sweep
        Material4Container(
          width: double.infinity,
          height: 90,
          config: const Material4Config(
            type: Material4Type.steppedCorner,
            isShimmering: true,
            shimmerProgress: 0.6,
          ),
          color: const Color(0xFF1E1E24),
          borderColor: const Color(0xFF90CAF9),
          borderWidth: 1.5,
          child: Center(
            child: Text(
              'Holographic Shimmer Sweep Light',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),

        // 3. Multi-Layer Inner Shadows
        Material4Container(
          width: double.infinity,
          height: 90,
          config: const Material4Config(
            type: Material4Type.smoothRounded,
            cornerRadius: 18,
            innerShadows: [
              BoxShadow(
                color: Color(0x3D000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color(0x24FFFFFF),
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          color: const Color(0xFFE2E7ED),
          child: Center(
            child: Text(
              'Carved / Inset Inner Relief Shadows',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: const Color(0xFF37474F),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),

        // 4. Procedural Mesh Gradient
        Material4Container(
          width: double.infinity,
          height: 90,
          config: const Material4Config(
            type: Material4Type.smoothRounded,
            cornerRadius: 18,
            backgroundEffect: BackgroundEffectType.meshGradient,
            meshColors: [
              Color(0xFF5E43EE),
              Color(0xFF00E5FF),
              Color(0xFFFF4081),
              Color(0xFFFFD740),
            ],
          ),
          child: Center(
            child: Text(
              'Multi-Stop Procedural Mesh Gradient',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
                shadows: const [
                  Shadow(color: Colors.black38, blurRadius: 4),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 6. Sculpted Icon Cards
  // =========================================================================
  Widget _buildSculptedIconCardsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '6. Sculpted Icon Cards',
          '3D elevated/embossed/neumorphic icon plates seated over legible flat content.',
        ),
        const SizedBox(height: 16),

        // Embossed
        SculptedIconCard.embossed(
          icon: Icons.school_rounded,
          title: 'Academic Honors Portal',
          subtitle: 'Grade 11 Advanced Physics',
          description:
              'Access lecture recordings, problem sets, and syllabus guidelines.',
          badge: 'Active Term',
          iconPosition: SculptedIconPosition.topLeft,
          onTap: () {},
        ),
        const SizedBox(height: 16),

        // Neumorphic
        SculptedIconCard.neumorphic(
          icon: Icons.tune_rounded,
          title: 'Audio Synthesizer Lab',
          subtitle: 'Harmonic balance and dynamic equalization',
          iconPosition: SculptedIconPosition.centerLeft,
          onTap: () {},
        ),
        const SizedBox(height: 16),

        // Debossed with RTL / Bengali Script support
        SculptedIconCard(
          icon: Icons.translate_rounded,
          title: 'বাংলা ও আন্তর্জাতিক টেক্সট সাপোর্ট',
          subtitle: 'Right-to-Left and Bengali typography rendering cleanly',
          description:
              'পূর্ণাঙ্গ বাংলা ফন্ট ও লেআউট ইঞ্জিন সমন্বিত কার্ড কম্পোনেন্ট।',
          badge: 'বাংলা',
          plateConfig: const SculptedPlateConfig(
            style: SculptedSurfaceStyle.debossed,
          ),
          onTap: () {},
        ),
      ],
    );
  }

  // =========================================================================
  // 7. Material Cards
  // =========================================================================
  Widget _buildMaterialCardsTab() {
    const materials = [
      (DynamicMaterial.clay, 'Tactile Clay', Icons.brush_rounded),
      (DynamicMaterial.ceramic, 'Glazed Ceramic', Icons.coffee_rounded),
      (DynamicMaterial.metal, 'Brushed Metal', Icons.shield_rounded),
      (DynamicMaterial.glass, 'Frosted Glass', Icons.blur_on_rounded),
      (DynamicMaterial.paper, 'Artisan Paper', Icons.note_rounded),
      (DynamicMaterial.softFabric, 'Woven Fabric', Icons.texture_rounded),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '7. MaterialDynamicCard Substrates',
          'Master cards orchestrating 12 physical substrates with directional lighting.',
        ),
        const SizedBox(height: 16),
        ...materials.map((item) {
          final (material, label, icon) = item;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: MaterialDynamicCard(
              material: material,
              icon: icon,
              iconPosition: CardIconPosition.leading,
              iconSurface: CardSurfaceType.raised,
              contentSurface: CardSurfaceType.flat,
              title: '$label Material Card',
              subtitle: 'Directional lighting, roughness, and specular sheen',
              badge: material.name.toUpperCase(),
              interaction: const CardInteractionConfig(
                enablePressScale: true,
                enableHoverElevation: true,
              ),
              onTap: () {},
            ),
          );
        }),
      ],
    );
  }

  // =========================================================================
  // 8. Shape Morphing
  // =========================================================================
  Widget _buildShapeMorphingTab() {
    final currentType = _morphSequence[_morphIndex];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '8. Shape Animation & Morphing Engine',
          'Seamless geometric interpolation between arbitrary shapes with zero layout overflow.',
        ),
        const SizedBox(height: 20),
        Center(
          child: AnimatedMaterial4Container(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            config: Material4Config(
              type: currentType,
              cornerRadius: 22,
              tabWidth: 90,
              tabHeight: 22,
              scallopRadius: 18,
            ),
            width: 280,
            height: 180,
            color: const Color(0xFF5E43EE),
            borderColor: Colors.white,
            borderWidth: 2.0,
            shadows: const [
              BoxShadow(
                color: Color(0x265E43EE),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.transform_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentType.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'State ${_morphIndex + 1} of ${_morphSequence.length}',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _morphIndex = (_morphIndex + 1) % _morphSequence.length;
              });
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Next Morph Geometry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E43EE),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 9. Interactive Components
  // =========================================================================
  Widget _buildInteractiveComponentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '9. Interactive Component Suite',
          'Buttons, badges, avatars, and multi-child layout containers.',
        ),
        const SizedBox(height: 16),

        // Buttons
        Text(
          'Geometric Shape Buttons',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            ShapeButton(
              config: const Material4Config(
                type: Material4Type.ticketScallop,
                scallopRadius: 10,
              ),
              color: const Color(0xFF5E43EE),
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.confirmation_number_outlined,
                      color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('Ticket Action', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            ShapeButton(
              config: const Material4Config(
                type: Material4Type.folderTab,
                tabWidth: 50,
                tabHeight: 10,
              ),
              color: const Color(0xFF00796B),
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.folder_open_rounded,
                      color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('Folder Tab', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            ShapeButton(
              config: const Material4Config(type: Material4Type.steppedCorner),
              color: const Color(0xFFE65100),
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flash_on_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('Stepped Corner', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Avatars and Badges
        Text(
          'Shape Avatars & Badges',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ShapeAvatar(
              config: Material4Config(type: Material4Type.scallopedPetal),
              size: 64,
              borderColor: Color(0xFFFFB74D),
              fallback: Icon(Icons.person, color: Color(0xFFE65100), size: 32),
            ),
            ShapeAvatar(
              config: Material4Config(type: Material4Type.hexagonSoft),
              size: 64,
              borderColor: Color(0xFF81C784),
              fallback:
                  Icon(Icons.emoji_events, color: Color(0xFF2E7D32), size: 32),
            ),
            ShapeBadge(
              config: Material4Config(type: Material4Type.notchedBadge),
              label: 'VERIFIED',
              backgroundColor: Color(0xFFEADBFF),
              textColor: Color(0xFF5E43EE),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Multi-Child Material4Stack
        Text(
          'Multi-Child Material4Stack (Adaptive Flow)',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Material4Stack(
          config: const Material4Config(
            type: Material4Type.ticketScallop,
            scallopRadius: 18,
          ),
          color: Colors.white,
          borderColor: const Color(0xFF5E43EE),
          borderWidth: 1.5,
          children: [
            ShapeChild(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Multi-Child Inside Ticket Scallop',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // 10. Custom Configuration
  // =========================================================================
  Widget _buildCustomConfigurationTab() {
    final liveConfig = Material4Config(
      type: _customType,
      cornerRadius: _customCornerRadius,
      scallopRadius: _customScallopRadius,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader(
          '10. Custom Configuration Studio',
          'Tune geometric parameters live and inspect serialized JSON specifications.',
        ),
        const SizedBox(height: 16),

        // Live Rendered Preview
        Center(
          child: Material4Container(
            width: 260,
            height: 150,
            config: liveConfig,
            color: const Color(0xFF6750A4),
            borderColor: const Color(0xFF21005D),
            borderWidth: _customBorderWidth,
            shadows: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
            child: const Center(
              child: Text(
                'Live Config Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Controls
        Text(
          'Shape Type:',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: [
            Material4Type.ticketScallop,
            Material4Type.folderTab,
            Material4Type.steppedCorner,
            Material4Type.squircle,
            Material4Type.arch,
          ].map((type) {
            final isSel = _customType == type;
            return ChoiceChip(
              label: Text(type.name),
              selected: isSel,
              selectedColor: const Color(0xFF5E43EE),
              labelStyle: TextStyle(
                color: isSel ? Colors.white : Colors.black87,
                fontSize: 11,
              ),
              onSelected: (val) {
                if (val) setState(() => _customType = type);
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Corner Radius Slider
        _buildSlider(
          label: 'Corner Radius',
          value: _customCornerRadius,
          min: 0,
          max: 40,
          onChanged: (v) => setState(() => _customCornerRadius = v),
        ),

        // Scallop Radius Slider
        _buildSlider(
          label: 'Scallop / Tab Dimension',
          value: _customScallopRadius,
          min: 4,
          max: 30,
          onChanged: (v) => setState(() {
            _customScallopRadius = v;
          }),
        ),

        // Border Width Slider
        _buildSlider(
          label: 'Border Width',
          value: _customBorderWidth,
          min: 0.5,
          max: 6.0,
          onChanged: (v) => setState(() => _customBorderWidth = v),
        ),

        const SizedBox(height: 16),

        // JSON Spec Inspector
        Text(
          'Serialized Material4Config JSON:',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF263238),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            const JsonEncoder.withIndent('  ').convert(liveConfig.toJson()),
            style: const TextStyle(
              color: Color(0xFF80CBC4),
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // Helper Widgets
  // =========================================================================
  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: const Color(0xFF1E1E24),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: const Color(0xFF7A7A85),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            Text(
              value.toStringAsFixed(1),
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: const Color(0xFF5E43EE),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: const Color(0xFF5E43EE),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
