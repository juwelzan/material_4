import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_4/material_4.dart';

/// Complete interactive showcase screen for the Material 4 Universal Button System.
///
/// Features:
/// 1. Button Variants & Presets (Factory constructors & 18 ready-made presets)
/// 2. Shapes & Geometries (Squircle, Capsule, Soft Diamond, Ticket, Star, Hexagon, Organic)
/// 3. Interaction Animation Matrix (Press, Hover, Tap ripple, Focus)
/// 4. State Machine & Controller Studio (Loading, Success, Error, Disabled, Programmatic API)
/// 5. Textures, Patterns & Borders on Buttons
/// 6. Live Customization Studio with real-time code generator & copy-to-clipboard
class UniversalButtonShowcaseScreen extends StatefulWidget {
  final bool isEmbedded;

  const UniversalButtonShowcaseScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<UniversalButtonShowcaseScreen> createState() =>
      _UniversalButtonShowcaseScreenState();
}

class _UniversalButtonShowcaseScreenState
    extends State<UniversalButtonShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controller Studio
  late final Material4ButtonController _demoController;

  // Live Playground State
  Material4Type _selectedShape = Material4Type.continuousSquircle;
  ButtonPressAnimation _selectedPressAnim = ButtonPressAnimation.scaleDown;
  ButtonHoverAnimation _selectedHoverAnim = ButtonHoverAnimation.liftUp;
  ButtonTapAnimation _selectedTapAnim = ButtonTapAnimation.ripple;
  String _buttonText = 'Action Button';
  bool _showLeadingIcon = true;
  bool _showDropdown = false;
  bool _hasBadge = false;
  String _badgeText = 'NEW';
  bool _isLoading = false;
  bool _isDisabled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _demoController = Material4ButtonController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Button code snippet copied to clipboard!',
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
    return Scaffold(
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
                'Universal Button System',
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
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicatorColor: const Color(0xFF6366F1),
      indicatorWeight: 3,
      labelColor: Colors.white,
      unselectedLabelColor: const Color(0xFF94A3B8),
      labelStyle: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      tabs: const [
        Tab(text: 'Variants & Presets'),
        Tab(text: 'Shapes & Geometries'),
        Tab(text: 'Animation Matrix'),
        Tab(text: 'State & Controller'),
        Tab(text: 'Textures & Patterns'),
        Tab(text: 'Customization Studio'),
      ],
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildVariantsTab(),
        _buildShapesTab(),
        _buildAnimationsTab(),
        _buildStateControllerTab(),
        _buildTexturesPatternsTab(),
        _buildCustomizationStudioTab(),
      ],
    );
  }

  // ===========================================================================
  // TAB 1: VARIANTS & PRESETS
  // ===========================================================================
  Widget _buildVariantsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(
          'Universal Button Paradigms',
          'Explore all factory constructors powered by hardware-accelerated shape rendering.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Material4Button.filled(
              text: 'Filled Button',
              icon: const Icon(Icons.bolt_rounded),
              onPressed: () {},
            ),
            Material4Button.outlined(
              text: 'Outlined Button',
              icon: const Icon(Icons.layers_rounded),
              onPressed: () {},
            ),
            Material4Button.text(
              text: 'Text Button',
              icon: const Icon(Icons.touch_app_rounded),
              onPressed: () {},
            ),
            Material4Button.elevated(
              text: 'Elevated Button',
              icon: const Icon(Icons.arrow_upward_rounded),
              onPressed: () {},
            ),
            Material4Button.gradient(
              text: 'Gradient Button',
              colors: const [Color(0xFF6366F1), Color(0xFFEC4899)],
              icon: const Icon(Icons.auto_awesome_rounded),
              onPressed: () {},
            ),
            Material4Button.glass(
              text: 'Glassmorphic',
              icon: const Icon(Icons.blur_on_rounded),
              onPressed: () {},
            ),
            Material4Button.liquid(
              text: 'Liquid Fluid',
              icon: const Icon(Icons.water_drop_rounded),
              onPressed: () {},
            ),
            Material4Button.organic(
              text: 'Organic Paper',
              icon: const Icon(Icons.spa_rounded),
              onPressed: () {},
            ),
            Material4Button.neon(
              text: 'Cyberpunk Neon',
              neonColor: const Color(0xFF00E5FF),
              icon: const Icon(Icons.flash_on_rounded),
              onPressed: () {},
            ),
            Material4Button.threeD(
              text: 'Tactile 3D Push',
              faceColor: const Color(0xFF4F46E5),
              depthColor: const Color(0xFF3730A3),
              icon: const Icon(Icons.view_in_ar_rounded),
              onPressed: () {},
            ),
            Material4Button.floating(
              icon: Icons.add,
              text: 'FAB Action',
              onPressed: () {},
            ),
            Material4Button.icon(
              icon: const Icon(Icons.bookmark_border_rounded),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionHeader(
          '18 Ready-Made Presets (Material4ButtonPreset)',
          'Pre-tuned production design presets for status, surfaces, and aesthetics.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: Material4ButtonPreset.values.map((preset) {
            return Material4Button.fromPreset(
              preset: preset,
              text: preset.name.toUpperCase(),
              onPressed: () {},
            );
          }).toList(),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: SHAPES & GEOMETRIES
  // ===========================================================================
  Widget _buildShapesTab() {
    final shapes = [
      (Material4Type.smoothRounded, 'Smooth Rounded'),
      (Material4Type.squircle, 'Squircle'),
      (Material4Type.continuousSquircle, 'C2 Squircle'),
      (Material4Type.capsule, 'Pill Capsule'),
      (Material4Type.softDiamond, 'Soft Diamond'),
      (Material4Type.ticket, 'Notched Ticket'),
      (Material4Type.roundedHexagon, 'Hexagon'),
      (Material4Type.flower, 'Botanical Flower'),
      (Material4Type.starburst, 'Starburst Badge'),
      (Material4Type.asymmetricBlob, 'Asymmetric Blob'),
      (Material4Type.droplet, 'Liquid Droplet'),
      (Material4Type.leaf, 'Botanical Leaf'),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(
          'Vector Shape Engine Integration',
          'Buttons automatically adapt to any of the 41 Material4Type presets and custom polygons.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: shapes.map((shapeInfo) {
            return Material4Button(
              shape: shapeInfo.$1,
              color: const Color(0xFF1E293B),
              border: const Material4Border.solid(
                color: Color(0xFF6366F1),
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              onPressed: () {},
              child: Text(
                shapeInfo.$2,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader(
          'Mathematical Custom Shapes',
          'Procedural polygons, starbursts, and custom parametric Béziers.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Material4Button(
              customShape: Material4CustomShape.polygon(sides: 6, cornerRadius: 4),
              color: const Color(0xFF4F46E5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              onPressed: () {},
              child: const Text('6-Sided Polygon'),
            ),
            Material4Button(
              customShape: Material4CustomShape.star(points: 5, innerRadiusRatio: 0.6),
              color: const Color(0xFFD97706),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              onPressed: () {},
              child: const Text('5-Point Star'),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 3: ANIMATION MATRIX
  // ===========================================================================
  Widget _buildAnimationsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(
          'Press Animation Modes',
          'Interactive physics curves responding directly to touch and clicks.',
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            Material4Button(
              animation: const Material4ButtonAnimation(press: ButtonPressAnimation.scaleDown),
              color: const Color(0xFF4F46E5),
              onPressed: () {},
              child: const Text('Scale Down (0.95)'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(press: ButtonPressAnimation.scaleUp),
              color: const Color(0xFF0EA5E9),
              onPressed: () {},
              child: const Text('Scale Up (1.05)'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(press: ButtonPressAnimation.elastic),
              color: const Color(0xFF10B981),
              onPressed: () {},
              child: const Text('Elastic Spring'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(press: ButtonPressAnimation.bounce),
              color: const Color(0xFFF59E0B),
              onPressed: () {},
              child: const Text('Physical Bounce'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(press: ButtonPressAnimation.depthPress),
              color: const Color(0xFF8B5CF6),
              onPressed: () {},
              child: const Text('3D Depth Press'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionHeader(
          'Hover Animation Modes',
          'Subtle elevation, lighting blooms, and glowing outlines on pointer hover.',
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            Material4Button(
              animation: const Material4ButtonAnimation(hover: ButtonHoverAnimation.liftUp),
              color: const Color(0xFF1E293B),
              border: const Material4Border.solid(color: Color(0xFF475569)),
              onPressed: () {},
              child: const Text('Lift Up (-3dp)'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(hover: ButtonHoverAnimation.glow),
              color: const Color(0xFF1E293B),
              border: const Material4Border.solid(color: Color(0xFF6366F1)),
              onPressed: () {},
              child: const Text('Glow Bloom'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(hover: ButtonHoverAnimation.floating),
              color: const Color(0xFF1E293B),
              border: const Material4Border.solid(color: Color(0xFF00E5FF)),
              onPressed: () {},
              child: const Text('Floating Oscillate'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(hover: ButtonHoverAnimation.gradientMovement),
              gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)]),
              onPressed: () {},
              child: const Text('Gradient Shift'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionHeader(
          'Tap Feedback Modes',
          'Contour-clipped vector ripples, particle bursts, and luminous washes.',
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            Material4Button(
              animation: const Material4ButtonAnimation(tap: ButtonTapAnimation.ripple),
              color: const Color(0xFF4F46E5),
              onPressed: () {},
              child: const Text('Shape-Bound Ripple'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(tap: ButtonTapAnimation.waveRipple),
              color: const Color(0xFF06B6D4),
              onPressed: () {},
              child: const Text('Wave Undulation'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(tap: ButtonTapAnimation.particleBurst),
              color: const Color(0xFFEC4899),
              onPressed: () {},
              child: const Text('Particle Burst'),
            ),
            Material4Button(
              animation: const Material4ButtonAnimation(tap: ButtonTapAnimation.glowPulse),
              color: const Color(0xFF10B981),
              onPressed: () {},
              child: const Text('Glow Pulse Wash'),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 4: STATE MACHINE & CONTROLLER
  // ===========================================================================
  Widget _buildStateControllerTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(
          'Lifecycle State Machine',
          'Fixed button dimensions ensure zero layout shifts across state transitions.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            Material4Button(
              state: Material4ButtonState.idle,
              text: 'Idle State',
              onPressed: () {},
            ),
            Material4Button(
              state: Material4ButtonState.loading,
              text: 'Loading State',
              onPressed: () {},
            ),
            Material4Button(
              state: Material4ButtonState.success,
              text: 'Success State',
              onPressed: () {},
            ),
            Material4Button(
              state: Material4ButtonState.error,
              text: 'Error State',
              onPressed: () {},
            ),
            Material4Button(
              state: Material4ButtonState.disabled,
              text: 'Disabled State',
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionHeader(
          'Programmatic Material4ButtonController',
          'Command button state, async lifecycles, and feedback messages from external business logic.',
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              children: [
                Material4Button(
                  controller: _demoController,
                  width: 220,
                  height: 52,
                  text: 'Submit Application',
                  icon: const Icon(Icons.send_rounded),
                  onPressed: () {
                    _demoController.startLoading();
                    Future.delayed(const Duration(seconds: 2), () {
                      _demoController.showSuccess(message: 'Submitted!');
                    });
                  },
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                      onPressed: () => _demoController.startLoading(),
                      child: const Text('startLoading()'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF64748B)),
                      onPressed: () => _demoController.stopLoading(),
                      child: const Text('stopLoading()'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                      onPressed: () => _demoController.showSuccess(message: 'Profile Saved!'),
                      child: const Text('showSuccess()'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                      onPressed: () => _demoController.showError(message: 'Network Error!'),
                      child: const Text('showError()'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B)),
                      onPressed: () {
                        if (_demoController.isEnabled) {
                          _demoController.disable();
                        } else {
                          _demoController.enable();
                        }
                        setState(() {});
                      },
                      child: Text(_demoController.isEnabled ? 'disable()' : 'enable()'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 5: TEXTURES & PATTERNS
  // ===========================================================================
  Widget _buildTexturesPatternsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(
          'Procedural Textures on Buttons',
          'Rich micro-surface details rendered directly onto custom vector paths.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Material4Button(
              text: 'Carbon Fiber',
              background: const Material4Background(
                color: Color(0xFF1E293B),
                texture: Material4Texture.carbonFiber(opacity: 0.35),
              ),
              border: const Material4Border.solid(color: Color(0xFF475569)),
              icon: const Icon(Icons.shield_rounded),
              onPressed: () {},
            ),
            Material4Button(
              text: 'Brushed Titanium',
              background: const Material4Background(
                color: Color(0xFF334155),
                texture: Material4Texture.brushedMetal(opacity: 0.30),
              ),
              border: const Material4Border.solid(color: Color(0xFF94A3B8)),
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {},
            ),
            Material4Button(
              text: 'Luxury Foil',
              background: const Material4Background(
                gradient: LinearGradient(colors: [Color(0xFFD97706), Color(0xFFB45309)]),
                texture: Material4Texture.metallicFoil(opacity: 0.35),
              ),
              border: const Material4Border.shimmer(color: Color(0xFFFDE68A)),
              icon: const Icon(Icons.workspace_premium_rounded),
              onPressed: () {},
            ),
            Material4Button(
              text: 'Architectural Marble',
              background: const Material4Background(
                color: Color(0xFFF8FAFC),
                texture: Material4Texture.marble(opacity: 0.30),
              ),
              foregroundColor: const Color(0xFF0F172A),
              border: const Material4Border.solid(color: Color(0xFFCBD5E1)),
              icon: const Icon(Icons.account_balance_rounded),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionHeader(
          'Background Patterns on Buttons',
          'Micro-dots, technical grid lines, and decorative diagonal stripes.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Material4Button(
              text: 'Technical Grid',
              background: const Material4Background(
                color: Color(0xFF0F172A),
                pattern: Material4Pattern.grid(spacing: 12, opacity: 0.25),
              ),
              border: const Material4Border.solid(color: Color(0xFF0EA5E9)),
              icon: const Icon(Icons.grid_4x4_rounded),
              onPressed: () {},
            ),
            Material4Button(
              text: 'Micro Dots',
              background: const Material4Background(
                color: Color(0xFF4F46E5),
                pattern: Material4Pattern.dots(spacing: 10, opacity: 0.25),
              ),
              icon: const Icon(Icons.lens_blur_rounded),
              onPressed: () {},
            ),
            Material4Button(
              text: 'Diagonal Hazard',
              background: const Material4Background(
                color: Color(0xFFD97706),
                pattern: Material4Pattern.stripes(spacing: 14, opacity: 0.25),
              ),
              icon: const Icon(Icons.warning_amber_rounded),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 6: LIVE CUSTOMIZATION STUDIO
  // ===========================================================================
  Widget _buildCustomizationStudioTab() {
    final generatedCode = '''Material4Button(
  text: '$_buttonText',
  shape: Material4Type.${_selectedShape.name},
  ${_showLeadingIcon ? 'icon: const Icon(Icons.star_rounded),\n  ' : ''}${_hasBadge ? "badge: '$_badgeText',\n  " : ''}${_showDropdown ? 'hasDropdown: true,\n  ' : ''}animation: const Material4ButtonAnimation(
    press: ButtonPressAnimation.${_selectedPressAnim.name},
    hover: ButtonHoverAnimation.${_selectedHoverAnim.name},
    tap: ButtonTapAnimation.${_selectedTapAnim.name},
  ),
  isLoading: $_isLoading,
  enabled: ${!_isDisabled},
  onPressed: () {
    // Action handler
  },
)''';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(
          'Live Button Studio',
          'Customize every property in real-time and export production-ready code.',
        ),
        const SizedBox(height: 20),
        // Preview Stage
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          alignment: Alignment.center,
          child: Material4Button(
            text: _buttonText,
            shape: _selectedShape,
            icon: _showLeadingIcon ? const Icon(Icons.star_rounded) : null,
            badge: _hasBadge ? Text(_badgeText) : null,
            hasDropdown: _showDropdown,
            animation: Material4ButtonAnimation(
              press: _selectedPressAnim,
              hover: _selectedHoverAnim,
              tap: _selectedTapAnim,
            ),
            isLoading: _isLoading,
            enabled: !_isDisabled,
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 24),
        // Controls
        Card(
          color: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Button Configuration Controls',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                // Text input
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Button Label',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (val) => setState(() => _buttonText = val.isEmpty ? 'Button' : val),
                ),
                const SizedBox(height: 16),
                // Shape selector
                DropdownButtonFormField<Material4Type>(
                  initialValue: _selectedShape,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Vector Shape',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: [
                    Material4Type.smoothRounded,
                    Material4Type.squircle,
                    Material4Type.continuousSquircle,
                    Material4Type.capsule,
                    Material4Type.softDiamond,
                    Material4Type.ticket,
                    Material4Type.roundedHexagon,
                    Material4Type.flower,
                    Material4Type.starburst,
                    Material4Type.asymmetricBlob,
                  ].map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                  onChanged: (val) => setState(() => _selectedShape = val!),
                ),
                const SizedBox(height: 16),
                // Press Animation selector
                DropdownButtonFormField<ButtonPressAnimation>(
                  initialValue: _selectedPressAnim,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Press Animation',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: ButtonPressAnimation.values
                      .map((a) => DropdownMenuItem(value: a, child: Text(a.name)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedPressAnim = val!),
                ),
                const SizedBox(height: 16),
                // Hover Animation selector
                DropdownButtonFormField<ButtonHoverAnimation>(
                  initialValue: _selectedHoverAnim,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Hover Animation',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: ButtonHoverAnimation.values
                      .map((a) => DropdownMenuItem(value: a, child: Text(a.name)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedHoverAnim = val!),
                ),
                const SizedBox(height: 16),
                // Tap Animation selector
                DropdownButtonFormField<ButtonTapAnimation>(
                  initialValue: _selectedTapAnim,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Tap Ripple / Burst Animation',
                    labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: ButtonTapAnimation.values
                      .map((a) => DropdownMenuItem(value: a, child: Text(a.name)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedTapAnim = val!),
                ),
                const SizedBox(height: 16),
                // Switch Toggles
                SwitchListTile(
                  title: const Text('Show Leading Star Icon', style: TextStyle(color: Colors.white)),
                  value: _showLeadingIcon,
                  onChanged: (v) => setState(() => _showLeadingIcon = v),
                ),
                SwitchListTile(
                  title: const Text('Dropdown Chevron Indicator', style: TextStyle(color: Colors.white)),
                  value: _showDropdown,
                  onChanged: (v) => setState(() => _showDropdown = v),
                ),
                SwitchListTile(
                  title: const Text('Notification Badge', style: TextStyle(color: Colors.white)),
                  value: _hasBadge,
                  onChanged: (v) => setState(() => _hasBadge = v),
                ),
                if (_hasBadge) ...[
                  const SizedBox(height: 8),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Badge Text',
                      labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (val) => setState(() => _badgeText = val.isEmpty ? 'NEW' : val),
                  ),
                ],
                SwitchListTile(
                  title: const Text('Simulate Loading State', style: TextStyle(color: Colors.white)),
                  value: _isLoading,
                  onChanged: (v) => setState(() => _isLoading = v),
                ),
                SwitchListTile(
                  title: const Text('Disable Button', style: TextStyle(color: Colors.white)),
                  value: _isDisabled,
                  onChanged: (v) => setState(() => _isDisabled = v),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Code Output
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dart Code Snippet',
                    style: GoogleFonts.firaCode(
                      color: const Color(0xFF6366F1),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: Colors.white70, size: 20),
                    tooltip: 'Copy Code',
                    onPressed: () => _copyToClipboard(generatedCode),
                  ),
                ],
              ),
              const Divider(color: Color(0xFF1E293B)),
              SelectableText(
                generatedCode,
                style: GoogleFonts.firaCode(
                  color: const Color(0xFFE2E8F0),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
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
            fontSize: 18,
            fontWeight: FontWeight.w800,
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
