import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_4/material_4.dart';

/// Complete interactive showcase screen for the Material 4 Universal Container System.
///
/// Features:
/// 1. Universal Shapes Gallery (12 new vector geometries)
/// 2. Procedural Texture Explorer (24 GPU procedural textures)
/// 3. Procedural Background Patterns (17 clipped patterns)
/// 4. Animated Vector Borders (12 next-gen border styles)
/// 5. Topological Vector Shape Morphing & Physics Studio
/// 6. Predefined Composition Presets (Glass, Neon, Carbon, Liquid, Paper, etc.)
/// 7. Live Code Generator with copy-to-clipboard
class UniversalContainerShowcaseScreen extends StatefulWidget {
  final bool isEmbedded;

  const UniversalContainerShowcaseScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<UniversalContainerShowcaseScreen> createState() =>
      _UniversalContainerShowcaseScreenState();
}

class _UniversalContainerShowcaseScreenState
    extends State<UniversalContainerShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Selected state for Live Playground
  Material4Type _selectedShape = Material4Type.continuousSquircle;
  Material4TextureType _selectedTexture = Material4TextureType.carbonFiber;
  Material4PatternType _selectedPattern = Material4PatternType.none;
  BorderStyleType _selectedBorder = BorderStyleType.flowingBorder;
  double _borderWidth = 2.0;
  double _textureOpacity = 0.35;
  double _patternSpacing = 16.0;
  bool _animateBorder = true;
  bool _animateTexture = false;
  bool _animatePattern = false;

  // Morphing Studio Controller
  late final Material4MorphController _morphController;
  Material4Type _morphFrom = Material4Type.smoothRounded;
  Material4Type _morphTo = Material4Type.superellipse;
  double _scrubProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _morphController = Material4MorphController(
      initialShape: _morphFrom,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Code snippet copied to clipboard!',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF1E293B),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Universal Container System',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              bottom: _buildTabBar(),
            ),
      body: widget.isEmbedded
          ? Column(
              children: [
                _buildTabBar(),
                Expanded(child: _buildTabBarView()),
              ],
            )
          : _buildTabBarView(),
    );

    return content;
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: const Color(0xFF38BDF8),
      unselectedLabelColor: const Color(0xFF94A3B8),
      indicatorColor: const Color(0xFF38BDF8),
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
        Tab(text: '1. Shapes Gallery'),
        Tab(text: '2. Morphing Studio'),
        Tab(text: '3. Procedural Textures'),
        Tab(text: '4. Patterns Engine'),
        Tab(text: '5. Animated Borders'),
        Tab(text: '6. Presets & Playground'),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildShapesGalleryTab(),
        _buildMorphingStudioTab(),
        _buildTexturesTab(),
        _buildPatternsTab(),
        _buildBordersTab(),
        _buildPresetsPlaygroundTab(),
      ],
    );
  }

  // =========================================================================
  // --- Tab 1: Universal 12 New Shapes Gallery ---
  // =========================================================================

  Widget _buildShapesGalleryTab() {
    const newShapes = [
      (Material4Type.superellipse, 'Superellipse', 'Mathematical Lamé Curve with continuous tangent curvature'),
      (Material4Type.continuousSquircle, 'Squircle Continuous', 'High-order smooth squircle with zero corner pinch'),
      (Material4Type.asymmetricBlob, 'Asymmetric Blob', 'Organic multi-frequency harmonic sculpted silhouette'),
      (Material4Type.softDiamond, 'Soft Diamond', 'Curved concave diamond with elegant corner radii'),
      (Material4Type.roundedHexagon, 'Rounded Hexagon', 'Hexagonal technical polygon with fillet corners'),
      (Material4Type.roundedPentagon, 'Rounded Pentagon', 'Symmetric 5-sided technical polygon with corner radius'),
      (Material4Type.ticket, 'Notched Ticket', 'Card with symmetric semicircular left & right edge notches'),
      (Material4Type.flower, 'Organic Flower', '8-petal sinusoidal continuous blossom contour'),
      (Material4Type.starburst, 'Starburst', '12-point expressive promotional reward badge geometry'),
      (Material4Type.leaf, 'Botanical Leaf', 'Asymmetric organic botanical silhouette with pointed tip'),
      (Material4Type.droplet, 'Liquid Droplet', 'Fluid teardrop geometry with smooth parabolic apex'),
      (Material4Type.liquid, 'Fluid Wave Container', 'Multi-frequency crest fluid hydrodynamic boundary'),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(
          title: 'Next-Gen Vector Shapes',
          subtitle: '12 mathematically continuous organic and technical geometries with zero bitmap dependencies.',
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: newShapes.length,
          itemBuilder: (context, index) {
            final (shape, name, desc) = newShapes[index];
            final isSelected = _selectedShape == shape;

            return GestureDetector(
              onTap: () => setState(() => _selectedShape = shape),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Material4Container(
                          width: 100,
                          height: 100,
                          config: Material4Config(type: shape),
                          background: const Material4Background(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          border: const Material4Border.solid(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          child: Center(
                            child: Icon(
                              isSelected ? Icons.check_circle_rounded : Icons.auto_awesome,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: const Color(0xFF94A3B8),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // --- Tab 2: Topological Vector Shape Morphing Studio ---
  // =========================================================================

  Widget _buildMorphingStudioTab() {
    final allShapes = [
      Material4Type.smoothRounded,
      Material4Type.superellipse,
      Material4Type.continuousSquircle,
      Material4Type.asymmetricBlob,
      Material4Type.flower,
      Material4Type.roundedHexagon,
      Material4Type.ticket,
      Material4Type.starburst,
      Material4Type.droplet,
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(
          title: 'Topological Vector Shape Morphing',
          subtitle: 'Continuous contour re-sampling with Catmull-Rom spline synthesis and physics easing curves.',
        ),
        const SizedBox(height: 24),
        Center(
          child: AnimatedBuilder(
            animation: _morphController,
            builder: (context, _) {
              return Material4Container(
                width: 200,
                height: 200,
                morphController: _morphController,
                background: const Material4Background(
                  gradient: LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF6366F1), Color(0xFFD946EF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x666366F1),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                border: const Material4Border.solid(
                  color: Colors.white,
                  width: 2.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.motion_photos_on_rounded, color: Colors.white, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        '${(_morphController.morphProgress * 100).toInt()}%',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _morphController.currentShape.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        // Interactive Scrubber Slider
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Manual Scrub Interpolation',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${(_scrubProgress * 100).toStringAsFixed(1)}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _scrubProgress,
                min: 0.0,
                max: 1.0,
                activeColor: const Color(0xFF38BDF8),
                inactiveColor: const Color(0xFF334155),
                onChanged: (val) {
                  setState(() {
                    _scrubProgress = val;
                    _morphController.setProgress(val);
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // From Shape Selector
        Text(
          'From Shape:',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allShapes.map((s) {
            final isFrom = _morphFrom == s;
            return ChoiceChip(
              label: Text(s.name),
              selected: isFrom,
              onSelected: (sel) {
                if (sel) {
                  setState(() {
                    _morphFrom = s;
                    _morphController.morphTo(_morphTo);
                  });
                }
              },
              selectedColor: const Color(0xFF6366F1),
              backgroundColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: isFrom ? Colors.white : const Color(0xFF94A3B8),
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // To Shape Selector
        Text(
          'Target Shape:',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allShapes.map((s) {
            final isTo = _morphTo == s;
            return ChoiceChip(
              label: Text(s.name),
              selected: isTo,
              onSelected: (sel) {
                if (sel) {
                  setState(() {
                    _morphTo = s;
                    _morphController.morphTo(s);
                  });
                }
              },
              selectedColor: const Color(0xFF38BDF8),
              backgroundColor: const Color(0xFF1E293B),
              labelStyle: TextStyle(
                color: isTo ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                fontWeight: isTo ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // =========================================================================
  // --- Tab 3: Procedural Textures ---
  // =========================================================================

  Widget _buildTexturesTab() {
    final textures = Material4TextureType.values
        .where((t) => t != Material4TextureType.none)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(
          title: 'Procedural GPU Textures',
          subtitle: '24 mathematically deterministic textures rendered live on canvas with zero external image assets.',
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.05,
          ),
          itemCount: textures.length,
          itemBuilder: (context, index) {
            final tex = textures[index];
            final isSelected = _selectedTexture == tex;

            return GestureDetector(
              onTap: () => setState(() => _selectedTexture = tex),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Expanded(
                      child: Material4Container(
                        width: double.infinity,
                        height: double.infinity,
                        config: const Material4Config(type: Material4Type.smoothRounded),
                        background: Material4Background(
                          color: const Color(0xFF1E293B),
                          texture: Material4Texture(
                            type: tex,
                            opacity: 0.45,
                            scale: 1.0,
                          ),
                        ),
                        border: Material4Border.solid(
                          color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF475569),
                          width: 1.2,
                        ),
                        child: Center(
                          child: Icon(
                            isSelected ? Icons.check_circle : Icons.texture,
                            color: Colors.white.withValues(alpha: 0.8),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tex.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // --- Tab 4: Procedural Background Patterns ---
  // =========================================================================

  Widget _buildPatternsTab() {
    final patterns = Material4PatternType.values
        .where((p) => p != Material4PatternType.none)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(
          title: 'Procedural Background Patterns',
          subtitle: '17 mathematically generated vector pattern grids strictly clipped to container silhouettes.',
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.05,
          ),
          itemCount: patterns.length,
          itemBuilder: (context, index) {
            final pat = patterns[index];
            final isSelected = _selectedPattern == pat;

            return GestureDetector(
              onTap: () => setState(() => _selectedPattern = pat),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Expanded(
                      child: Material4Container(
                        width: double.infinity,
                        height: double.infinity,
                        config: const Material4Config(type: Material4Type.continuousSquircle),
                        background: Material4Background(
                          color: const Color(0xFF1E293B),
                          pattern: Material4Pattern(
                            type: pat,
                            color: const Color(0xFF38BDF8),
                            opacity: 0.35,
                            spacing: 14.0,
                          ),
                        ),
                        border: Material4Border.solid(
                          color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF475569),
                          width: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pat.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // --- Tab 5: Animated Vector Borders ---
  // =========================================================================

  Widget _buildBordersTab() {
    const borders = [
      (BorderStyleType.flowingBorder, 'Flowing Border', 'Rotating multi-color vector sweep gradient along contour'),
      (BorderStyleType.movingDash, 'Marching Ants', 'Equidistant vector dashes travelling with constant speed'),
      (BorderStyleType.pulsatingBorder, 'Pulsating Glow', 'Dynamic breath modulation of border luminosity and width'),
      (BorderStyleType.liquidBorder, 'Liquid Perimeter', 'Wave ripple travelling along the path silhouette'),
      (BorderStyleType.waveBorder, 'Harmonic Wave', 'Sinusoidal undulation across the container perimeter'),
      (BorderStyleType.zigzagBorder, 'Zigzag Edge', 'Mechanical high-frequency micro-teeth border stroke'),
      (BorderStyleType.particleBorder, 'Orbiting Particles', 'High-energy sparks racing along vector perimeter'),
      (BorderStyleType.orbitingLightBorder, 'Orbiting Light Beam', 'Focused luminous light focal head tracing path'),
      (BorderStyleType.dualLayerBorder, 'Dual Layer Glow', 'Inner crisp stroke with outer diffused neon aura'),
      (BorderStyleType.shimmerBorder, 'Specular Shimmer', 'Sweeping linear highlight bar refracting over contour'),
      (BorderStyleType.conicGradientBorder, 'Conic Gradient', '360-degree continuous spectrum chromatic sweep'),
      (BorderStyleType.energyBorder, 'Pulse Energy Ring', 'Double-pulse cardiac rhythm with ambient bloom'),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(
          title: 'Animated Vector Borders',
          subtitle: '12 next-gen animated border renderers calculating exact contour tangents and stroke geometries.',
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: borders.length,
          itemBuilder: (context, index) {
            final (borderStyle, name, desc) = borders[index];
            final isSelected = _selectedBorder == borderStyle;

            return GestureDetector(
              onTap: () => setState(() => _selectedBorder = borderStyle),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Expanded(
                      child: Material4Container(
                        width: double.infinity,
                        height: double.infinity,
                        config: const Material4Config(type: Material4Type.continuousSquircle),
                        background: const Material4Background(
                          color: Color(0xFF0B132B),
                        ),
                        border: Material4Border(
                          style: borderStyle,
                          color: const Color(0xFF38BDF8),
                          width: 2.2,
                          animated: true,
                          animationSpeed: 1.0,
                        ),
                        containerAnimation: const Material4ContainerAnimation(
                          borderAnimation: true,
                          borderSpeed: 1.0,
                        ),
                        child: Center(
                          child: Icon(
                            isSelected ? Icons.check_circle : Icons.blur_linear_rounded,
                            color: const Color(0xFF38BDF8),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: const Color(0xFF94A3B8),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================================
  // --- Tab 6: Presets Carousel & Live Playground ---
  // =========================================================================

  Widget _buildPresetsPlaygroundTab() {
    final presets = [
      (Material4ContainerPreset.glass, 'Frosted Glass', Icons.blur_on),
      (Material4ContainerPreset.neon, 'Cyber Neon', Icons.wb_iridescent_rounded),
      (Material4ContainerPreset.carbonTech, 'Carbon Tech', Icons.speed_rounded),
      (Material4ContainerPreset.organicCard, 'Notice Board', Icons.dashboard_rounded),
      (Material4ContainerPreset.liquid, 'Fluid Liquid', Icons.water_drop_rounded),
      (Material4ContainerPreset.holographic, 'Holographic', Icons.auto_awesome),
      (Material4ContainerPreset.paperCraft, 'Paper Craft', Icons.note_rounded),
      (Material4ContainerPreset.minimal, 'Minimal Card', Icons.crop_square_rounded),
    ];

    final generatedCode = '''
Material4Container(
  width: 280,
  height: 180,
  config: const Material4Config(
    type: Material4Type.${_selectedShape.name},
  ),
  background: Material4Background(
    color: const Color(0xFF1E293B),
    texture: const Material4Texture(
      type: Material4TextureType.${_selectedTexture.name},
      opacity: $_textureOpacity,
    ),
    pattern: const Material4Pattern(
      type: Material4PatternType.${_selectedPattern.name},
      spacing: $_patternSpacing,
    ),
  ),
  border: Material4Border(
    style: BorderStyleType.${_selectedBorder.name},
    color: const Color(0xFF38BDF8),
    width: $_borderWidth,
    animated: $_animateBorder,
  ),
  containerAnimation: const Material4ContainerAnimation(
    borderAnimation: $_animateBorder,
    textureAnimation: $_animateTexture,
    patternAnimation: $_animatePattern,
  ),
  child: const Center(
    child: Text('Material 4 Container'),
  ),
);''';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(
          title: 'Presets & Interactive Studio',
          subtitle: 'Live playground combining universal shapes, procedural textures, patterns, and animated borders.',
        ),
        const SizedBox(height: 20),
        // Live Preview Container
        Center(
          child: Material4Container(
            width: 280,
            height: 180,
            config: Material4Config(type: _selectedShape),
            background: Material4Background(
              color: const Color(0xFF1E293B),
              texture: _selectedTexture != Material4TextureType.none
                  ? Material4Texture(
                      type: _selectedTexture,
                      opacity: _textureOpacity,
                    )
                  : null,
              pattern: _selectedPattern != Material4PatternType.none
                  ? Material4Pattern(
                      type: _selectedPattern,
                      color: const Color(0xFF38BDF8),
                      opacity: 0.35,
                      spacing: _patternSpacing,
                    )
                  : null,
              shadows: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            border: Material4Border(
              style: _selectedBorder,
              color: const Color(0xFF38BDF8),
              width: _borderWidth,
              animated: _animateBorder,
            ),
            containerAnimation: Material4ContainerAnimation(
              borderAnimation: _animateBorder,
              textureAnimation: _animateTexture,
              patternAnimation: _animatePattern,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.layers_rounded, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    _selectedShape.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${_selectedTexture.name} • ${_selectedBorder.name}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Quick Presets
        Text(
          'Built-In Composition Presets:',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: presets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, idx) {
              final (preset, name, icon) = presets[idx];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedShape = preset.shape ?? Material4Type.smoothRounded;
                    _selectedTexture = preset.background.texture?.type ?? Material4TextureType.none;
                    _selectedPattern = preset.background.pattern?.type ?? Material4PatternType.none;
                    _selectedBorder = preset.border.style;
                  });
                },
                child: Container(
                  width: 110,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: const Color(0xFF38BDF8), size: 24),
                      const SizedBox(height: 6),
                      Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        // Controls: Border Width & Texture Opacity
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Border Width: ${_borderWidth.toStringAsFixed(1)} dp',
                      style: const TextStyle(color: Colors.white, fontSize: 13)),
                  Slider(
                    value: _borderWidth,
                    min: 0.5,
                    max: 6.0,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (v) => setState(() => _borderWidth = v),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Texture Opacity: ${(_textureOpacity * 100).toInt()}%',
                      style: const TextStyle(color: Colors.white, fontSize: 13)),
                  Slider(
                    value: _textureOpacity,
                    min: 0.05,
                    max: 1.0,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (v) => setState(() => _textureOpacity = v),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pattern Spacing: ${_patternSpacing.toInt()} dp',
                      style: const TextStyle(color: Colors.white, fontSize: 13)),
                  Slider(
                    value: _patternSpacing,
                    min: 8.0,
                    max: 48.0,
                    activeColor: const Color(0xFF38BDF8),
                    onChanged: (v) => setState(() => _patternSpacing = v),
                  ),
                ],
              ),
              const Divider(color: Color(0xFF334155)),
              Wrap(
                spacing: 16,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _animateBorder,
                        activeColor: const Color(0xFF38BDF8),
                        onChanged: (val) => setState(() => _animateBorder = val ?? true),
                      ),
                      const Text('Animate Border', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _animateTexture,
                        activeColor: const Color(0xFF38BDF8),
                        onChanged: (val) => setState(() => _animateTexture = val ?? false),
                      ),
                      const Text('Animate Texture', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _animatePattern,
                        activeColor: const Color(0xFF38BDF8),
                        onChanged: (val) => setState(() => _animatePattern = val ?? false),
                      ),
                      const Text('Animate Pattern', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Generated Code Block
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Declarative Code Output:',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            TextButton.icon(
              onPressed: () => _copyToClipboard(generatedCode),
              icon: const Icon(Icons.copy_rounded, size: 16, color: Color(0xFF38BDF8)),
              label: Text(
                'Copy Code',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: const Color(0xFF38BDF8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF020617),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: SelectableText(
            generatedCode,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Color(0xFF93C5FD),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: const Color(0xFF94A3B8),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
