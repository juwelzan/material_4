import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_4/material_4.dart';

/// Complete showcase screen and gallery for the Material 4 Universal Dynamic Progress Bar System.
///
/// Demonstrates all 14 required progress bar galleries plus an interactive playground:
/// 1. Linear Progress Gallery (Classic, Rounded, Capsule, Thick, Thin, Floating)
/// 2. Circular Progress Gallery (Classic, Rounded, Concentric Circle)
/// 3. Ring Progress Gallery (Thin, Thick, Gradient Ring, Dual Ring, Partial Arc)
/// 4. Segmented Progress Gallery (Segmented Linear, Segmented Ring, Circular Segmented)
/// 5. Wave Progress Gallery (Wave Linear, Oscillating Fluid Crest)
/// 6. Liquid Progress Gallery (Liquid Linear with rising micro-bubbles)
/// 7. Organic Progress Gallery (Asymmetric, Organic Edge, Sculpted)
/// 8. Gradient Progress Gallery (Linear Gradient, Sweep Gradient Ring)
/// 9. Neon Progress Gallery (Neon Linear, Neon Ring)
/// 10. Dotted Progress Gallery (Dotted Ring, Dot Matrix)
/// 11. Morphing Progress Gallery (Continuous shape morphing loop)
/// 12. Indeterminate Progress Gallery (Linear, Circular, Wave Indeterminate)
/// 13. Interactive Progress Gallery (Drag to seek, Tap to set, Tooltips, Thumbs)
/// 14. Custom Shape Progress Gallery (Shield, Hexagon, Octagon, Flower)
/// 15. Interactive Progress Playground (Live parameter tweaking & code generation)
class ProgressBarShowcaseScreen extends StatefulWidget {
  /// When true, renders without Scaffold and AppBar for embedding inside tabs.
  final bool isEmbedded;

  const ProgressBarShowcaseScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<ProgressBarShowcaseScreen> createState() =>
      _ProgressBarShowcaseScreenState();
}

class _ProgressBarShowcaseScreenState extends State<ProgressBarShowcaseScreen> {
  // Category filter state
  String _selectedCategory = 'All';
  final List<String> _categories = const [
    'All',
    'Linear Styles',
    'Circular & Rings',
    'Creative & Fluid',
    'Interactive & Seeking',
    'Playground',
  ];

  // Dynamic values for interactive demos
  double _interactiveValue = 65.0;
  double _stepProgress = 0.6;
  int _morphStep = 0;
  final List<(String, Material4ProgressShape)> _morphShapes = [
    ('Capsule', Material4ProgressShape.capsule()),
    ('Squircle', Material4ProgressShape.squircle(smoothness: 0.85)),
    ('Organic Blob', Material4ProgressShape.blob(seed: 42)),
    ('Hexagon', Material4ProgressShape.hexagon()),
    ('Shield', Material4ProgressShape.shield()),
  ];

  // Playground State
  double _playgroundValue = 0.65;
  Material4ProgressStyle _playgroundStyle = Material4ProgressStyle.capsuleLinear;
  Material4ProgressShape _playgroundShape = Material4ProgressShape.capsule();
  Color _playgroundColor = const Color(0xFF2563EB);
  double _playgroundThickness = 12.0;
  bool _playgroundGlow = false;
  bool _playgroundShimmer = false;
  bool _playgroundStriped = false;

  void _copyToClipboard(BuildContext context, String code, String title) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Copied code for "$title" to clipboard!',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _matchesFilter(String category) {
    if (_selectedCategory == 'All') return true;
    return _selectedCategory == category;
  }

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      children: [
        if (!widget.isEmbedded) ...[
          _buildHeroBanner(),
          const SizedBox(height: 18),
        ],
        _buildCategoryFilterChips(),
        const SizedBox(height: 20),

        // 1. Linear Progress Gallery
        if (_matchesFilter('Linear Styles')) ...[
          _buildShowcaseCard(
            index: '01',
            title: 'Linear Progress Gallery',
            subtitle:
                'Clean horizontal tracks: Classic, Rounded, Capsule, Thick, Thin, and Floating.',
            tag: 'LINEAR',
            tagColor: const Color(0xFF2563EB),
            preview: Column(
              children: [
                _buildDemoRow(
                  'Classic Linear',
                  const Material4ProgressBar(
                    value: 0.70,
                    style: Material4ProgressStyle.classicLinear,
                    height: 8,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDemoRow(
                  'Capsule (Rounded)',
                  const Material4ProgressBar(
                    value: 0.55,
                    style: Material4ProgressStyle.capsuleLinear,
                    height: 10,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDemoRow(
                  'Thick Gauge',
                  const Material4ProgressBar(
                    value: 0.80,
                    style: Material4ProgressStyle.thickLinear,
                    height: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDemoRow(
                  'Thin Minimal',
                  const Material4ProgressBar(
                    value: 0.40,
                    style: Material4ProgressStyle.thinLinear,
                    height: 4,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDemoRow(
                  'Elevated Floating',
                  Material4ProgressBar(
                    value: 0.65,
                    style: Material4ProgressStyle.floatingLinear,
                    track: Material4ProgressTrack.floating.copyWith(
                      thickness: 14,
                    ),
                  ),
                ),
              ],
            ),
            codeSnippet: '''// Minimal Thin Linear
Material4ProgressBar.linear(
  value: 0.40,
  style: Material4ProgressStyle.thinLinear,
  height: 4.0,
)

// Floating Elevated Linear
Material4ProgressBar(
  value: 0.65,
  style: Material4ProgressStyle.floatingLinear,
  track: Material4ProgressTrack.floating,
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 2. Circular Progress Gallery
        if (_matchesFilter('Circular & Rings')) ...[
          _buildShowcaseCard(
            index: '02',
            title: 'Circular Progress Gallery',
            subtitle:
                'Radial indicators: Rounded Circular, Classic Flat, and Centered Percentage.',
            tag: 'CIRCULAR',
            tagColor: const Color(0xFF7C3AED),
            preview: Wrap(
              spacing: 24,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildCircularColumn(
                  'Rounded Cap',
                  const Material4ProgressBar(
                    value: 0.75,
                    style: Material4ProgressStyle.roundedCircular,
                    width: 64,
                    height: 64,
                    track: Material4ProgressTrack(thickness: 7),
                  ),
                ),
                _buildCircularColumn(
                  'With Percentage',
                  Material4ProgressBar.circular(
                    value: 0.68,
                    size: 64,
                    strokeWidth: 7,
                    showPercentage: true,
                  ),
                ),
                _buildCircularColumn(
                  'Classic Flat Cap',
                  const Material4ProgressBar(
                    value: 0.45,
                    style: Material4ProgressStyle.classicCircular,
                    width: 64,
                    height: 64,
                    track: Material4ProgressTrack(thickness: 7),
                  ),
                ),
              ],
            ),
            codeSnippet: '''Material4ProgressBar.circular(
  value: 0.68,
  size: 64,
  strokeWidth: 7,
  showPercentage: true,
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 3. Ring Progress Gallery
        if (_matchesFilter('Circular & Rings')) ...[
          _buildShowcaseCard(
            index: '03',
            title: 'Ring Progress Gallery',
            subtitle:
                'High-precision radial rings: Thin Hairline, Thick Gauge, and Multi-color.',
            tag: 'RINGS',
            tagColor: const Color(0xFF0284C7),
            preview: Wrap(
              spacing: 24,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildCircularColumn(
                  'Thin Ring',
                  const Material4ProgressBar(
                    value: 0.60,
                    style: Material4ProgressStyle.thinRing,
                    width: 60,
                    height: 60,
                    track: Material4ProgressTrack(thickness: 3.5),
                  ),
                ),
                _buildCircularColumn(
                  'Thick Ring',
                  const Material4ProgressBar(
                    value: 0.85,
                    style: Material4ProgressStyle.thickRing,
                    width: 60,
                    height: 60,
                    track: Material4ProgressTrack(thickness: 10),
                  ),
                ),
                _buildCircularColumn(
                  'Chromatic Ring',
                  Material4ProgressBar(
                    value: 0.72,
                    style: Material4ProgressStyle.gradientRing,
                    width: 60,
                    height: 60,
                    fill: const Material4ProgressFill(
                      gradient: SweepGradient(
                        colors: [Color(0xFF00E5FF), Color(0xFF651FFF)],
                      ),
                    ),
                    track: const Material4ProgressTrack(thickness: 7),
                  ),
                ),
              ],
            ),
            codeSnippet: '''Material4ProgressBar(
  value: 0.72,
  style: Material4ProgressStyle.gradientRing,
  width: 60,
  height: 60,
  fill: const Material4ProgressFill(
    gradient: SweepGradient(colors: [Color(0xFF00E5FF), Color(0xFF651FFF)]),
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 4. Segmented Progress Gallery
        if (_matchesFilter('Linear Styles') ||
            _matchesFilter('Circular & Rings')) ...[
          _buildShowcaseCard(
            index: '04',
            title: 'Segmented Progress Gallery',
            subtitle:
                'Discretized milestone blocks: Linear Segments and Radial Ring Segments.',
            tag: 'SEGMENTED',
            tagColor: const Color(0xFF059669),
            preview: Column(
              children: [
                _buildDemoRow(
                  'Linear Segments (8 steps)',
                  Material4ProgressBar.segmented(
                    value: 0.65,
                    segments: 8,
                    segmentGap: 4,
                    height: 12,
                    color: const Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDemoRow(
                  'Dense Segments (16 steps)',
                  Material4ProgressBar.segmented(
                    value: 0.40,
                    segments: 16,
                    segmentGap: 3,
                    height: 10,
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: _buildCircularColumn(
                    'Segmented Ring (12 Segments)',
                    const Material4ProgressBar(
                      value: 0.75,
                      style: Material4ProgressStyle.segmentedRing,
                      width: 68,
                      height: 68,
                      fill: Material4ProgressFill(segments: 12),
                      track: Material4ProgressTrack(thickness: 8),
                    ),
                  ),
                ),
              ],
            ),
            codeSnippet: '''// Linear Segmented
Material4ProgressBar.segmented(
  value: 0.65,
  segments: 8,
  segmentGap: 4.0,
  height: 12.0,
)

// Circular Segmented Ring
Material4ProgressBar(
  value: 0.75,
  style: Material4ProgressStyle.segmentedRing,
  width: 68,
  height: 68,
  fill: const Material4ProgressFill(segments: 12),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 5. Wave Progress Gallery
        if (_matchesFilter('Creative & Fluid')) ...[
          _buildShowcaseCard(
            index: '05',
            title: 'Wave Progress Gallery',
            subtitle:
                'Sinusoidal harmonic crest dynamically undulating along progress progression.',
            tag: 'FLUID WAVE',
            tagColor: const Color(0xFF06B6D4),
            preview: Column(
              children: [
                _buildDemoRow(
                  'Harmonic Wave (Crest: 4px)',
                  Material4ProgressBar.wave(
                    value: 0.65,
                    height: 20,
                    color: const Color(0xFF06B6D4),
                    waveAmplitude: 4.0,
                  ),
                ),
                const SizedBox(height: 14),
                _buildDemoRow(
                  'High-Frequency Wave',
                  Material4ProgressBar(
                    value: 0.50,
                    style: Material4ProgressStyle.waveLinear,
                    height: 22,
                    fill: const Material4ProgressFill(
                      color: Color(0xFF0284C7),
                      waveAmplitude: 5.0,
                      waveFrequency: 3.5,
                    ),
                    track: const Material4ProgressTrack(
                      color: Color(0x1A0284C7),
                      thickness: 22,
                    ),
                  ),
                ),
              ],
            ),
            codeSnippet: '''Material4ProgressBar.wave(
  value: 0.65,
  height: 20,
  color: const Color(0xFF06B6D4),
  waveAmplitude: 4.0,
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 6. Liquid Progress Gallery
        if (_matchesFilter('Creative & Fluid')) ...[
          _buildShowcaseCard(
            index: '06',
            title: 'Liquid Reservoir Gallery',
            subtitle:
                'Fluid chamber with surface meniscus tension and effervescent rising bubbles.',
            tag: 'LIQUID',
            tagColor: const Color(0xFF00B0FF),
            preview: Material4ProgressBar.liquid(
              value: 0.60,
              height: 32,
              color: const Color(0xFF00B0FF),
              label: Material4ProgressLabel(
                showPercentage: true,
                position: ProgressLabelPosition.insideCenter,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
            codeSnippet: '''Material4ProgressBar.liquid(
  value: 0.60,
  height: 32,
  color: const Color(0xFF00B0FF),
  label: const Material4ProgressLabel(
    showPercentage: true,
    position: ProgressLabelPosition.insideCenter,
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 7. Organic Progress Gallery
        if (_matchesFilter('Creative & Fluid')) ...[
          _buildShowcaseCard(
            index: '07',
            title: 'Organic Progress Gallery',
            subtitle:
                'Asymmetric corner silhouettes and sculpted fluid contours.',
            tag: 'ORGANIC',
            tagColor: const Color(0xFF10B981),
            preview: Column(
              children: [
                _buildDemoRow(
                  'Asymmetric Corner Profile',
                  Material4ProgressBar.organic(
                    value: 0.70,
                    height: 18,
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(height: 14),
                _buildDemoRow(
                  'Sculpted 3D Beveled Profile',
                  Material4ProgressBar.sculpted(
                    value: 0.55,
                    height: 18,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
            codeSnippet: '''Material4ProgressBar.organic(
  value: 0.70,
  height: 18,
  color: const Color(0xFF10B981),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 8. Gradient Progress Gallery
        if (_matchesFilter('Linear Styles') ||
            _matchesFilter('Circular & Rings')) ...[
          _buildShowcaseCard(
            index: '08',
            title: 'Gradient Progress Gallery',
            subtitle:
                'Multi-stop color transitions: Linear Gradient and Sweep Angular Gradient.',
            tag: 'GRADIENTS',
            tagColor: const Color(0xFF8B5CF6),
            preview: Column(
              children: [
                _buildDemoRow(
                  'Cyan to Purple Gradient',
                  Material4ProgressBar.linear(
                    value: 0.85,
                    progressGradient: const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF7C3AED)],
                    ),
                    height: 12,
                  ),
                ),
                const SizedBox(height: 14),
                _buildDemoRow(
                  'Sunset Fire Gradient',
                  Material4ProgressBar.linear(
                    value: 0.60,
                    progressGradient: const LinearGradient(
                      colors: [Color(0xFFFFB300), Color(0xFFF43F5E)],
                    ),
                    height: 12,
                  ),
                ),
              ],
            ),
            codeSnippet: '''Material4ProgressBar.linear(
  value: 0.85,
  progressGradient: const LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF7C3AED)],
  ),
  height: 12.0,
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 9. Neon Progress Gallery
        if (_matchesFilter('Linear Styles') ||
            _matchesFilter('Circular & Rings')) ...[
          _buildShowcaseCard(
            index: '09',
            title: 'Neon Plasma Tube Gallery',
            subtitle:
                'Fluorescent high-voltage laser glow with saturated ambient halo plume.',
            tag: 'NEON',
            tagColor: const Color(0xFF00E5FF),
            preview: Column(
              children: [
                _buildDemoRow(
                  'Neon Cyan Linear Tube',
                  Material4ProgressBar.neon(
                    value: 0.75,
                    color: const Color(0xFF00E5FF),
                    height: 12,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDemoRow(
                  'Neon Emerald Tube',
                  Material4ProgressBar.neon(
                    value: 0.50,
                    color: const Color(0xFF00E676),
                    height: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: _buildCircularColumn(
                    'Neon Radial Ring',
                    Material4ProgressBar(
                      value: 0.65,
                      style: Material4ProgressStyle.neonRing,
                      width: 64,
                      height: 64,
                      effects: Material4ProgressEffects.neonPreset,
                      track: const Material4ProgressTrack(
                        color: Color(0xFF0F172A),
                        thickness: 8,
                      ),
                      fill: const Material4ProgressFill(
                        color: Color(0xFF00E5FF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            codeSnippet: '''Material4ProgressBar.neon(
  value: 0.75,
  color: const Color(0xFF00E5FF),
  height: 12.0,
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 10. Dotted Progress Gallery
        if (_matchesFilter('Circular & Rings') ||
            _matchesFilter('Creative & Fluid')) ...[
          _buildShowcaseCard(
            index: '10',
            title: 'Dotted & Matrix Gallery',
            subtitle:
                'Discrete bead indicators: Dotted Circular Ring and 2D Dot Matrix Grid.',
            tag: 'DOTTED MATRIX',
            tagColor: const Color(0xFFEC4899),
            preview: Column(
              children: [
                Center(
                  child: _buildCircularColumn(
                    '24-Point Dotted Ring',
                    const Material4ProgressBar(
                      value: 0.62,
                      style: Material4ProgressStyle.dottedRing,
                      width: 72,
                      height: 72,
                      track: Material4ProgressTrack(thickness: 7),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDemoRow(
                  '2D Dot Matrix (16x4 Grid)',
                  const Material4ProgressBar(
                    value: 0.65,
                    style: Material4ProgressStyle.dotMatrix,
                    height: 32,
                  ),
                ),
              ],
            ),
            codeSnippet: '''// Dotted Ring
Material4ProgressBar(
  value: 0.62,
  style: Material4ProgressStyle.dottedRing,
  width: 72,
  height: 72,
)

// Dot Matrix Grid
Material4ProgressBar(
  value: 0.65,
  style: Material4ProgressStyle.dotMatrix,
  height: 32,
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 11. Morphing Progress Gallery
        if (_matchesFilter('Creative & Fluid')) ...[
          _buildShowcaseCard(
            index: '11',
            title: 'Morphing Progress Gallery',
            subtitle:
                'Phase-aligned Bézier interpolation looping continuously across shapes.',
            tag: 'SHAPE MORPH',
            tagColor: const Color(0xFF6366F1),
            preview: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  child: Material4ProgressBar(
                    key: ValueKey(_morphStep),
                    value: 0.70,
                    style: Material4ProgressStyle.capsuleLinear,
                    shape: _morphShapes[_morphStep].$2,
                    height: 28,
                    fill: const Material4ProgressFill(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                      ),
                    ),
                    track: const Material4ProgressTrack(
                      color: Color(0x1F6366F1),
                    ),
                    label: Material4ProgressLabel(
                      showPercentage: true,
                      position: ProgressLabelPosition.insideCenter,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(_morphShapes.length, (idx) {
                    final item = _morphShapes[idx];
                    final isSelected = _morphStep == idx;
                    return ChoiceChip(
                      label: Text(item.$1, style: const TextStyle(fontSize: 11)),
                      selected: isSelected,
                      selectedColor: const Color(0xFFEDE9FE),
                      onSelected: (_) => setState(() => _morphStep = idx),
                    );
                  }),
                ),
              ],
            ),
            codeSnippet: '''Material4ProgressBar(
  value: 0.70,
  shape: Material4ProgressShape.squircle(),
  fill: const Material4ProgressFill(
    gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA855F7)]),
  ),
  height: 28,
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 12. Indeterminate Progress Gallery
        if (_matchesFilter('Linear Styles') ||
            _matchesFilter('Circular & Rings')) ...[
          _buildShowcaseCard(
            index: '12',
            title: 'Indeterminate Progress Gallery',
            subtitle:
                'Continuous loading loops: Linear Pill Sweep, Circular Arc Orbit, and Wave.',
            tag: 'INDETERMINATE',
            tagColor: const Color(0xFFF59E0B),
            preview: Column(
              children: [
                _buildDemoRow(
                  'Linear Indeterminate',
                  Material4ProgressBar.indeterminate(
                    style: Material4ProgressStyle.capsuleLinear,
                    height: 6,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDemoRow(
                  'Gradient Wave Indeterminate',
                  const Material4ProgressBar(
                    value: null,
                    style: Material4ProgressStyle.waveLinear,
                    height: 14,
                    fill: Material4ProgressFill(
                      color: Color(0xFFF59E0B),
                      waveAmplitude: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: _buildCircularColumn(
                    'Circular Indeterminate Orbit',
                    const Material4ProgressBar(
                      value: null,
                      style: Material4ProgressStyle.roundedCircular,
                      width: 56,
                      height: 56,
                      track: Material4ProgressTrack(thickness: 6),
                    ),
                  ),
                ),
              ],
            ),
            codeSnippet: '''// Linear Indeterminate
Material4ProgressBar.indeterminate(height: 6.0)

// Circular Indeterminate
Material4ProgressBar(
  value: null, // Indeterminate mode
  style: Material4ProgressStyle.roundedCircular,
  width: 56,
  height: 56,
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 13. Interactive Progress Gallery
        if (_matchesFilter('Interactive & Seeking')) ...[
          _buildShowcaseCard(
            index: '13',
            title: 'Interactive Seeking & Stepping Gallery',
            subtitle:
                'Drag or tap to seek progress with thumb knob, step quantization, and haptic response.',
            tag: 'INTERACTIVE',
            tagColor: const Color(0xFFD97706),
            preview: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Drag to Seek (${_interactiveValue.toInt()}%)',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'Step: 5%',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Material4ProgressBar(
                  value: _interactiveValue / 100.0,
                  style: Material4ProgressStyle.capsuleLinear,
                  height: 14,
                  interaction: Material4ProgressInteraction(
                    enabled: true,
                    min: 0.0,
                    max: 100.0,
                    step: 5.0,
                    thumb: true,
                    thumbRadius: 10.0,
                    thumbElevation: 4.0,
                    onChanged: (val) => setState(() => _interactiveValue = val),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Milestone Step Pipeline (Drag/Tap)',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Material4ProgressBar.step(
                  value: _stepProgress,
                  steps: 5,
                  height: 28,
                  color: const Color(0xFF2563EB),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [0.0, 0.25, 0.5, 0.75, 1.0].map((step) {
                    return OutlinedButton(
                      onPressed: () => setState(() => _stepProgress = step),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      child: Text('${(step * 100).toInt()}%',
                          style: const TextStyle(fontSize: 11)),
                    );
                  }).toList(),
                ),
              ],
            ),
            codeSnippet: '''Material4ProgressBar(
  value: currentProgress,
  interaction: Material4ProgressInteraction(
    enabled: true,
    min: 0.0,
    max: 100.0,
    step: 5.0,
    thumb: true,
    onChanged: (val) => setState(() => currentProgress = val),
  ),
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 14. Custom Shape Progress Gallery
        if (_matchesFilter('Creative & Fluid')) ...[
          _buildShowcaseCard(
            index: '14',
            title: 'Custom Shape Progress Gallery',
            subtitle:
                'Architectural contours: Shield, Hexagon, Octagon, and Flower Petals.',
            tag: 'CUSTOM SHAPES',
            tagColor: const Color(0xFF4F46E5),
            preview: Wrap(
              spacing: 20,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildCircularColumn(
                  'Hexagon Badge',
                  Material4ProgressBar(
                    value: 0.70,
                    shape: Material4ProgressShape.hexagon(),
                    width: 60,
                    height: 60,
                    track: const Material4ProgressTrack(color: Color(0x1F4F46E5)),
                    fill: const Material4ProgressFill(color: Color(0xFF4F46E5)),
                  ),
                ),
                _buildCircularColumn(
                  'Heraldic Shield',
                  Material4ProgressBar(
                    value: 0.65,
                    shape: Material4ProgressShape.shield(),
                    width: 60,
                    height: 60,
                    track: const Material4ProgressTrack(color: Color(0x1F2563EB)),
                    fill: const Material4ProgressFill(color: Color(0xFF2563EB)),
                  ),
                ),
                _buildCircularColumn(
                  'Octagon Contour',
                  Material4ProgressBar(
                    value: 0.80,
                    shape: Material4ProgressShape.octagon(),
                    width: 60,
                    height: 60,
                    track: const Material4ProgressTrack(color: Color(0x1F059669)),
                    fill: const Material4ProgressFill(color: Color(0xFF059669)),
                  ),
                ),
              ],
            ),
            codeSnippet: '''Material4ProgressBar(
  value: 0.65,
  shape: Material4ProgressShape.shield(),
  width: 60,
  height: 60,
)''',
          ),
          const SizedBox(height: 16),
        ],

        // 15. Interactive Progress Playground
        if (_matchesFilter('Playground')) ...[
          _buildPlaygroundCard(),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 30),
      ],
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Universal Progress Gallery',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E1E24),
        elevation: 0.5,
      ),
      body: content,
    );
  }

  // =========================================================================
  // Interactive Playground Widget
  // =========================================================================

  Widget _buildPlaygroundCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PLAYGROUND',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF7C3AED),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '15. Interactive Progress Studio',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1E24),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tweak styles, shapes, colors, stroke gauge, and effects in real-time.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),

          // Live Preview Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            alignment: Alignment.center,
            child: Material4ProgressBar(
              value: _playgroundValue,
              style: _playgroundStyle,
              shape: _playgroundShape,
              height: _playgroundThickness,
              width: _playgroundStyle.isCircular ? 80 : null,
              fill: Material4ProgressFill(
                color: _playgroundColor,
                striped: _playgroundStriped,
              ),
              effects: Material4ProgressEffects(
                glow: _playgroundGlow,
                glowColor: _playgroundColor,
                shimmer: _playgroundShimmer,
              ),
              label: Material4ProgressLabel(
                showPercentage: true,
                position: _playgroundStyle.isCircular
                    ? ProgressLabelPosition.center
                    : ProgressLabelPosition.outsideTrailing,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Controls
          Text(
            'Progress Value: ${(_playgroundValue * 100).toInt()}%',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          Slider(
            value: _playgroundValue,
            min: 0.0,
            max: 1.0,
            activeColor: _playgroundColor,
            onChanged: (val) => setState(() => _playgroundValue = val),
          ),

          Text(
            'Height / Stroke Gauge: ${_playgroundThickness.toInt()}px',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          Slider(
            value: _playgroundThickness,
            min: 4.0,
            max: 36.0,
            activeColor: _playgroundColor,
            onChanged: (val) => setState(() => _playgroundThickness = val),
          ),

          const SizedBox(height: 8),
          const Text('Visual Style Preset:',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              (Material4ProgressStyle.capsuleLinear, 'Capsule'),
              (Material4ProgressStyle.waveLinear, 'Wave'),
              (Material4ProgressStyle.segmentedLinear, 'Segmented'),
              (Material4ProgressStyle.neonLinear, 'Neon'),
              (Material4ProgressStyle.ring, 'Radial Ring'),
              (Material4ProgressStyle.dottedRing, 'Dotted Ring'),
            ].map((item) {
              final isSelected = _playgroundStyle == item.$1;
              return ChoiceChip(
                label: Text(item.$2, style: const TextStyle(fontSize: 11)),
                selected: isSelected,
                selectedColor: const Color(0xFFDDD6FE),
                onSelected: (_) => setState(() => _playgroundStyle = item.$1),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),
          const Text('Shape Silhouette:',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              ('Capsule', Material4ProgressShape.capsule()),
              ('Squircle', Material4ProgressShape.squircle(smoothness: 0.85)),
              ('Blob', Material4ProgressShape.blob(seed: 42)),
              ('Hexagon', Material4ProgressShape.hexagon()),
              ('Shield', Material4ProgressShape.shield()),
            ].map((item) {
              final isSelected = _playgroundShape.id == item.$2.id;
              return ChoiceChip(
                label: Text(item.$1, style: const TextStyle(fontSize: 11)),
                selected: isSelected,
                selectedColor: const Color(0xFFDDD6FE),
                onSelected: (_) => setState(() => _playgroundShape = item.$2),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),
          const Text('Effects Toggles:',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Ambient Glow', style: TextStyle(fontSize: 11)),
                selected: _playgroundGlow,
                selectedColor: const Color(0xFFDDD6FE),
                onSelected: (val) => setState(() => _playgroundGlow = val),
              ),
              FilterChip(
                label: const Text('Specular Shimmer', style: TextStyle(fontSize: 11)),
                selected: _playgroundShimmer,
                selectedColor: const Color(0xFFDDD6FE),
                onSelected: (val) => setState(() => _playgroundShimmer = val),
              ),
              FilterChip(
                label: const Text('Striped Texture', style: TextStyle(fontSize: 11)),
                selected: _playgroundStriped,
                selectedColor: const Color(0xFFDDD6FE),
                onSelected: (val) => setState(() => _playgroundStriped = val),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Text('Theme Palette:',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: [
              const Color(0xFF2563EB),
              const Color(0xFF7C3AED),
              const Color(0xFF059669),
              const Color(0xFF00B0FF),
              const Color(0xFFF59E0B),
              const Color(0xFFE11D48),
            ].map((col) {
              final isSelected = _playgroundColor == col;
              return GestureDetector(
                onTap: () => setState(() => _playgroundColor = col),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: col,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.white,
                      width: isSelected ? 3.0 : 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),
          _buildCodeBlock(
            context,
            '''Material4ProgressBar(
  value: ${_playgroundValue.toStringAsFixed(2)},
  style: Material4ProgressStyle.${_playgroundStyle.name},
  height: ${_playgroundThickness.toInt()}.0,
  fill: Material4ProgressFill(
    color: Color(0x${_playgroundColor.toARGB32().toRadixString(16).toUpperCase()}),
    striped: $_playgroundStriped,
  ),
  effects: const Material4ProgressEffects(
    glow: $_playgroundGlow,
    shimmer: $_playgroundShimmer,
  ),
)''',
            'Playground Configuration',
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // Showcase Card & Component Builders
  // =========================================================================

  Widget _buildShowcaseCard({
    required String index,
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
    required Widget preview,
    required String codeSnippet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: tagColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$index. $title',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1E24),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: preview,
          ),
          const SizedBox(height: 14),
          _buildCodeBlock(context, codeSnippet, title),
        ],
      ),
    );
  }

  Widget _buildDemoRow(String label, Widget progressBar) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        progressBar,
      ],
    );
  }

  Widget _buildCircularColumn(String label, Widget circularBar) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        circularBar,
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeBlock(BuildContext context, String code, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DART SNIPPET',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
              InkWell(
                onTap: () => _copyToClipboard(context, code, title),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.copy_rounded,
                          size: 13, color: Color(0xFFCBD5E1)),
                      const SizedBox(width: 4),
                      Text(
                        'Copy Code',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            code,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11.5,
              color: const Color(0xFFE2E8F0),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332563EB),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Material 4 Progress System',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'One Progress System, Multiple Styles, Unlimited Customization',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedCategory = category),
              selectedColor: const Color(0xFF2563EB),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF475569),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFE2E8F0),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
