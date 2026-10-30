import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_4/material_4.dart';

/// Complete showcase screen and interactive studio for the Material 4
/// Advanced Animated Wave Line System.
///
/// Demonstrates all 35 animated line styles across 3 categories:
/// 1. Zigzag Wave Lines (10 styles)
/// 2. Organic Wave Lines (10 styles)
/// 3. Creative Animated Lines (15 styles)
///
/// Includes an Interactive Wave Studio for real-time parameter tweaking,
/// live animation speed/amplitude/frequency modulation, and code generation.
class WaveLineShowcaseScreen extends StatefulWidget {
  /// When true, renders without Scaffold and AppBar for embedding inside tabs.
  final bool isEmbedded;

  const WaveLineShowcaseScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<WaveLineShowcaseScreen> createState() => _WaveLineShowcaseScreenState();
}

class _WaveLineShowcaseScreenState extends State<WaveLineShowcaseScreen> {
  // Category Filter
  String _selectedCategory = 'All';
  final List<String> _categories = const [
    'All',
    'Zigzag Lines',
    'Organic Waves',
    'Creative Lines',
    'Interactive Studio',
  ];

  // Global demo progress value for determinate cards
  double _globalProgress = 0.68;

  // Playground State
  Material4ProgressStyle _pgStyle = Material4ProgressStyle.neonWave;
  bool _pgIndeterminate = false;
  double _pgProgress = 0.65;
  double _pgAmplitude = 8.0;
  double _pgFrequency = 3.0;
  double _pgSpeed = 1.0;
  double _pgThickness = 3.5;
  double _pgCornerSmoothness = 0.5;
  WaveDirection _pgDirection = WaveDirection.forward;
  bool _pgPaused = false;
  Color _pgColor = const Color(0xFF00E5FF);

  final List<(String, Color)> _palette = const [
    ('Cyan Glow', Color(0xFF00E5FF)),
    ('Electric Violet', Color(0xFF8B5CF6)),
    ('Emerald', Color(0xFF10B981)),
    ('Neon Pink', Color(0xFFFF2A85)),
    ('Amber Sun', Color(0xFFF59E0B)),
    ('Royal Blue', Color(0xFF2563EB)),
  ];

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
        backgroundColor: const Color(0xFF10B981),
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

        // 1. Zigzag Wave Lines
        if (_matchesFilter('Zigzag Lines')) ...[
          _buildSectionHeader(
            title: '1. Zigzag Wave Lines (10 Styles)',
            subtitle:
                'Precision angular, oscillating, and multi-layered geometric wave profiles.',
            badge: 'ZIGZAG',
            badgeColor: const Color(0xFF8B5CF6),
          ),
          const SizedBox(height: 14),
          _buildZigzagGallery(),
          const SizedBox(height: 24),
        ],

        // 2. Organic Wave Lines
        if (_matchesFilter('Organic Waves')) ...[
          _buildSectionHeader(
            title: '2. Organic Wave Lines (10 Styles)',
            subtitle:
                'Smooth sine, fluid ocean currents, rolling harmonic undulations, and morphing swells.',
            badge: 'ORGANIC',
            badgeColor: const Color(0xFF06B6D4),
          ),
          const SizedBox(height: 14),
          _buildOrganicGallery(),
          const SizedBox(height: 24),
        ],

        // 3. Creative Animated Lines
        if (_matchesFilter('Creative Lines')) ...[
          _buildSectionHeader(
            title: '3. Creative Animated Lines (15 Styles)',
            subtitle:
                'ECG pulse lines, DNA double helixes, particle flow, audio waveforms, ribbon meshes, and neon glow.',
            badge: 'CREATIVE',
            badgeColor: const Color(0xFFFF2A85),
          ),
          const SizedBox(height: 14),
          _buildCreativeGallery(),
          const SizedBox(height: 24),
        ],

        // 4. Interactive Studio & Parameter Playground
        if (_matchesFilter('Interactive Studio')) ...[
          _buildInteractiveStudio(),
          const SizedBox(height: 24),
        ],
      ],
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(
          'Animated Wave Line Studio',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            tooltip: 'Reset Global Progress',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                _globalProgress = 0.68;
              });
            },
          ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF818CF8).withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF818CF8).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'NEW IN MATERIAL 4',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.waves_rounded, color: Color(0xFF818CF8), size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Advanced Animated Wave Line System',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '35 GPU-accelerated wave styles featuring real-time sinusoidal, zigzag, DNA helix, and particle algorithms.',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFCBD5E1),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // Live banner wave preview
          Material4ProgressBar.creativeLine(
            style: Material4ProgressStyle.neonWave,
            height: 36,
            color: const Color(0xFF38BDF8),
            waveLine: const Material4WaveLineConfig(
              amplitude: 8.0,
              frequency: 3.5,
              speed: 1.2,
              thickness: 3.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Determinate fill: ${(_globalProgress * 100).toInt()}%',
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 140,
                child: Slider(
                  value: _globalProgress,
                  min: 0.0,
                  max: 1.0,
                  activeColor: const Color(0xFF38BDF8),
                  inactiveColor: Colors.white24,
                  onChanged: (val) {
                    setState(() => _globalProgress = val);
                  },
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
        children: _categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedCategory = cat);
              },
              backgroundColor: const Color(0xFF1E293B),
              selectedColor: const Color(0xFF4F46E5),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF334155),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2, right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: badgeColor, width: 1),
          ),
          child: Text(
            badge,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required Widget previewDeterminate,
    required Widget previewIndeterminate,
    required String codeSnippet,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Copy Code',
                  icon: const Icon(Icons.copy_rounded,
                      color: Color(0xFF64748B), size: 18),
                  onPressed: () => _copyToClipboard(context, codeSnippet, title),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF334155)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Determinate Progress',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                previewDeterminate,
                const SizedBox(height: 12),
                const Text(
                  'Indeterminate Continuous Sweep',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                previewIndeterminate,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Section 1: Zigzag Gallery (10 Styles)
  // ==========================================
  Widget _buildZigzagGallery() {
    final styles = [
      (
        'Smooth Zigzag Wave',
        Material4ProgressStyle.smoothZigzagWave,
        'Rounded peak bezier transitions between zigzag inflection points.',
        const Color(0xFF8B5CF6),
      ),
      (
        'Sharp Zigzag',
        Material4ProgressStyle.sharpZigzag,
        'Classic crisp triangular sawtooth waveform with acute vertices.',
        const Color(0xFFEC4899),
      ),
      (
        'Rounded Zigzag',
        Material4ProgressStyle.roundedZigzag,
        'Gentle circular crest caps softening every peak and trough.',
        const Color(0xFF3B82F6),
      ),
      (
        'Double Zigzag',
        Material4ProgressStyle.doubleZigzag,
        'Dual paired parallel sawtooth tracks undulating synchronously.',
        const Color(0xFF10B981),
      ),
      (
        'Continuous Zigzag',
        Material4ProgressStyle.continuousZigzag,
        'High-density rapid frequency sawtooth pattern.',
        const Color(0xFFF59E0B),
      ),
      (
        'Alternating Zigzag',
        Material4ProgressStyle.alternatingZigzag,
        'Staggered alternating peak amplitudes creating asymmetric rhythm.',
        const Color(0xFF06B6D4),
      ),
      (
        'Elastic Zigzag',
        Material4ProgressStyle.elasticZigzag,
        'Dynamically expanding and compressing vertex spacing.',
        const Color(0xFFA855F7),
      ),
      (
        'Flowing Zigzag',
        Material4ProgressStyle.flowingZigzag,
        'Smooth phase-shifted continuous forward marching sawtooth.',
        const Color(0xFF14B8A6),
      ),
      (
        'Morphing Zigzag',
        Material4ProgressStyle.morphingZigzag,
        'Continuous geometry morphing between sharp triangle and rounded sine.',
        const Color(0xFFF43F5E),
      ),
      (
        'Multi-Layer Zigzag',
        Material4ProgressStyle.multiLayerZigzag,
        'Tri-layer depth stacked zigzags with staggered opacity levels.',
        const Color(0xFF6366F1),
      ),
    ];

    return Column(
      children: styles.map((item) {
        final (title, style, desc, color) = item;
        return _buildCard(
          title: title,
          description: desc,
          previewDeterminate: Material4ProgressBar.zigzag(
            value: _globalProgress,
            style: style,
            color: color,
            height: 32,
            waveLine: Material4WaveLineConfig.sharpZigzag.copyWith(
              amplitude: 7.0,
              frequency: 3.5,
              thickness: 3.0,
            ),
          ),
          previewIndeterminate: Material4ProgressBar.zigzag(
            style: style,
            color: color,
            height: 32,
            waveLine: Material4WaveLineConfig.sharpZigzag.copyWith(
              amplitude: 7.0,
              frequency: 3.5,
              thickness: 3.0,
            ),
          ),
          codeSnippet: '''Material4ProgressBar.zigzag(
  value: 0.68, // or null for indeterminate
  style: Material4ProgressStyle.${style.name},
  color: const Color(${color.toARGB32()}),
  waveLine: const Material4WaveLineConfig(
    amplitude: 7.0,
    frequency: 3.5,
    thickness: 3.0,
  ),
)''',
        );
      }).toList(),
    );
  }

  // ==========================================
  // Section 2: Organic Wave Gallery (10 Styles)
  // ==========================================
  Widget _buildOrganicGallery() {
    final styles = [
      (
        'Smooth Sine Wave',
        Material4ProgressStyle.smoothSineWave,
        'Pure harmonic sinusoidal oscillation with mathematical perfection.',
        const Color(0xFF06B6D4),
      ),
      (
        'Double Wave',
        Material4ProgressStyle.doubleWave,
        'Two intertwined harmonic sine curves shifted 180 degrees in phase.',
        const Color(0xFF3B82F6),
      ),
      (
        'Triple Wave',
        Material4ProgressStyle.tripleWave,
        'Tri-harmonic wave cluster generating complex acoustic interference.',
        const Color(0xFF8B5CF6),
      ),
      (
        'Liquid Wave',
        Material4ProgressStyle.liquidWave,
        'Fluid viscous undulation with rolling hydrodynamic crests.',
        const Color(0xFF10B981),
      ),
      (
        'Ocean Wave',
        Material4ProgressStyle.oceanWave,
        'Rolling deep-sea swells with asymmetric surging peaks.',
        const Color(0xFF0284C7),
      ),
      (
        'Soft Rolling Wave',
        Material4ProgressStyle.softRollingWave,
        'Gentle low-amplitude harmonic rolling motion for relaxed ambient UI.',
        const Color(0xFF14B8A6),
      ),
      (
        'Organic Flow Wave',
        Material4ProgressStyle.organicFlowWave,
        'Non-linear biological wave flow mimicking arterial pulse curves.',
        const Color(0xFFEC4899),
      ),
      (
        'Asymmetric Wave',
        Material4ProgressStyle.asymmetricWave,
        'Skewed crests with steep leading edges and elongated trailing slopes.',
        const Color(0xFFF59E0B),
      ),
      (
        'Randomized Organic Wave',
        Material4ProgressStyle.randomizedOrganicWave,
        'Multi-frequency procedural noise wave with natural variety.',
        const Color(0xFFA855F7),
      ),
      (
        'Morphing Wave',
        Material4ProgressStyle.morphingWave,
        'Continuous smooth amplitude and frequency modulation over time.',
        const Color(0xFFF43F5E),
      ),
    ];

    return Column(
      children: styles.map((item) {
        final (title, style, desc, color) = item;
        return _buildCard(
          title: title,
          description: desc,
          previewDeterminate: Material4ProgressBar.waveLine(
            value: _globalProgress,
            style: style,
            color: color,
            height: 32,
            waveLine: Material4WaveLineConfig.smoothSine.copyWith(
              amplitude: 8.0,
              frequency: 3.0,
              thickness: 3.5,
            ),
          ),
          previewIndeterminate: Material4ProgressBar.waveLine(
            style: style,
            color: color,
            height: 32,
            waveLine: Material4WaveLineConfig.smoothSine.copyWith(
              amplitude: 8.0,
              frequency: 3.0,
              thickness: 3.5,
            ),
          ),
          codeSnippet: '''Material4ProgressBar.waveLine(
  value: 0.68,
  style: Material4ProgressStyle.${style.name},
  color: const Color(${color.toARGB32()}),
  waveLine: const Material4WaveLineConfig(
    amplitude: 8.0,
    frequency: 3.0,
    thickness: 3.5,
  ),
)''',
        );
      }).toList(),
    );
  }

  // ==========================================
  // Section 3: Creative Line Gallery (15 Styles)
  // ==========================================
  Widget _buildCreativeGallery() {
    final styles = [
      (
        'Pulse Line (ECG / Heartbeat)',
        Material4ProgressStyle.pulseLine,
        'Medical cardiogram heartbeat waveform with sharp QRS pulse peaks.',
        const Color(0xFFEF4444),
      ),
      (
        'DNA Double Helix Line',
        Material4ProgressStyle.dnaDoubleHelixLine,
        'Intertwined molecular double helix with horizontal base-pair rungs.',
        const Color(0xFF00E5FF),
      ),
      (
        'Neon Wave',
        Material4ProgressStyle.neonWave,
        'Dual-layer luminous neon bloom with hyper-bright core and soft halo.',
        const Color(0xFFFF2A85),
      ),
      (
        'Shimmer Wave',
        Material4ProgressStyle.shimmerWave,
        'Reflective specular glare sweep traversing across the wave trajectory.',
        const Color(0xFFFBBF24),
      ),
      (
        'Snake Line',
        Material4ProgressStyle.snakeLine,
        'Curving slithering serpentine path with tapered tail dynamics.',
        const Color(0xFF10B981),
      ),
      (
        'Ribbon Flow',
        Material4ProgressStyle.ribbonFlow,
        'Dual-boundary filled ribbon mesh twisting gracefully in 2D space.',
        const Color(0xFF8B5CF6),
      ),
      (
        'Moving Dots Line',
        Material4ProgressStyle.movingDotsLine,
        'Constellation of discrete orbiting nodes traveling along sinusoidal rails.',
        const Color(0xFF38BDF8),
      ),
      (
        'Particle Flow Line',
        Material4ProgressStyle.particleFlowLine,
        'Dissolving micro-particle trail orbiting the leading crest point.',
        const Color(0xFFA855F7),
      ),
      (
        'Orbiting Dot Line',
        Material4ProgressStyle.orbitingDotLine,
        'Satellite dot in helical planar orbit around the primary progress spine.',
        const Color(0xFFF59E0B),
      ),
      (
        'Audio Waveform Line',
        Material4ProgressStyle.audioWaveformLine,
        'Symmetric sound-wave envelope simulating master voice recording.',
        const Color(0xFF06B6D4),
      ),
      (
        'Equalizer Line',
        Material4ProgressStyle.equalizerLine,
        'Graphic acoustic equalizer vertical pin bars pulsating along progress.',
        const Color(0xFF10B981),
      ),
      (
        'Gradient Flow Line',
        Material4ProgressStyle.gradientFlowLine,
        'Multi-stop chromatic gradient sweep cycling along the active wave path.',
        const Color(0xFF6366F1),
      ),
      (
        'Breathing Line',
        Material4ProgressStyle.breathingLine,
        'Rhythmic harmonic expansion and contraction of wave stroke and height.',
        const Color(0xFFEC4899),
      ),
      (
        'Elastic Flow Line',
        Material4ProgressStyle.elasticFlowLine,
        'Damped harmonic spring oscillation reacting to velocity changes.',
        const Color(0xFF3B82F6),
      ),
      (
        'Infinity Flow Line',
        Material4ProgressStyle.infinityFlowLine,
        'Figure-eight lemniscate harmonic curve with self-intersecting loops.',
        const Color(0xFF14B8A6),
      ),
    ];

    return Column(
      children: styles.map((item) {
        final (title, style, desc, color) = item;
        return _buildCard(
          title: title,
          description: desc,
          previewDeterminate: Material4ProgressBar.creativeLine(
            value: _globalProgress,
            style: style,
            color: color,
            height: 36,
            waveLine: const Material4WaveLineConfig(
              amplitude: 9.0,
              frequency: 3.2,
              thickness: 3.5,
            ),
          ),
          previewIndeterminate: Material4ProgressBar.creativeLine(
            style: style,
            color: color,
            height: 36,
            waveLine: const Material4WaveLineConfig(
              amplitude: 9.0,
              frequency: 3.2,
              thickness: 3.5,
            ),
          ),
          codeSnippet: '''Material4ProgressBar.creativeLine(
  value: 0.68,
  style: Material4ProgressStyle.${style.name},
  color: const Color(${color.toARGB32()}),
  waveLine: const Material4WaveLineConfig(
    amplitude: 9.0,
    frequency: 3.2,
    thickness: 3.5,
  ),
)''',
        );
      }).toList(),
    );
  }

  // ==========================================
  // Section 4: Interactive Studio / Playground
  // ==========================================
  Widget _buildInteractiveStudio() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF475569)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 8),
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
                  color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF818CF8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wave Line Parameter Studio',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Tune mathematical wave variables in real-time.',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Live Preview Container
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
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
                      _pgStyle.name,
                      style: GoogleFonts.plusJakartaSans(
                        color: _pgColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      _pgIndeterminate
                          ? 'Indeterminate'
                          : '${(_pgProgress * 100).toInt()}% Determinate',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Material4ProgressBar(
                  value: _pgIndeterminate ? null : _pgProgress,
                  style: _pgStyle,
                  fill: Material4ProgressFill(color: _pgColor),
                  height: 40,
                  waveLine: Material4WaveLineConfig(
                    amplitude: _pgAmplitude,
                    frequency: _pgFrequency,
                    speed: _pgSpeed,
                    thickness: _pgThickness,
                    cornerSmoothness: _pgCornerSmoothness,
                    direction: _pgDirection,
                    paused: _pgPaused,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Style Dropdown Selector
          const Text(
            'Select Style (35 options):',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Material4ProgressStyle>(
                value: _pgStyle,
                isExpanded: true,
                dropdownColor: const Color(0xFF1E293B),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                items: Material4ProgressStyle.values
                    .where((s) => s.isWaveLine)
                    .map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(
                      s.name,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _pgStyle = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Toggles: Mode (Determinate/Indeterminate) & Pause
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      'Indeterminate',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    const Spacer(),
                    Switch(
                      value: _pgIndeterminate,
                      activeThumbColor: const Color(0xFF6366F1),
                      onChanged: (val) =>
                          setState(() => _pgIndeterminate = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      'Pause Ticker',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    const Spacer(),
                    Switch(
                      value: _pgPaused,
                      activeThumbColor: const Color(0xFFF59E0B),
                      onChanged: (val) => setState(() => _pgPaused = val),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Slider Controls
          if (!_pgIndeterminate) ...[
            _buildSliderRow(
              'Progress',
              '${(_pgProgress * 100).toInt()}%',
              _pgProgress,
              0.0,
              1.0,
              (v) => setState(() => _pgProgress = v),
            ),
          ],
          _buildSliderRow(
            'Amplitude',
            '${_pgAmplitude.toStringAsFixed(1)} dp',
            _pgAmplitude,
            2.0,
            20.0,
            (v) => setState(() => _pgAmplitude = v),
          ),
          _buildSliderRow(
            'Frequency',
            '${_pgFrequency.toStringAsFixed(1)} cycles',
            _pgFrequency,
            1.0,
            10.0,
            (v) => setState(() => _pgFrequency = v),
          ),
          _buildSliderRow(
            'Speed',
            '${_pgSpeed.toStringAsFixed(1)}x',
            _pgSpeed,
            0.2,
            3.0,
            (v) => setState(() => _pgSpeed = v),
          ),
          _buildSliderRow(
            'Thickness',
            '${_pgThickness.toStringAsFixed(1)} dp',
            _pgThickness,
            1.5,
            8.0,
            (v) => setState(() => _pgThickness = v),
          ),
          _buildSliderRow(
            'Corner Smoothness',
            _pgCornerSmoothness.toStringAsFixed(2),
            _pgCornerSmoothness,
            0.0,
            1.0,
            (v) => setState(() => _pgCornerSmoothness = v),
          ),

          const SizedBox(height: 12),
          // Direction Selector
          const Text(
            'Wave Direction:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: WaveDirection.values.map((dir) {
                final isSelected = _pgDirection == dir;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(dir.name),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _pgDirection = dir),
                    backgroundColor: const Color(0xFF0F172A),
                    selectedColor: const Color(0xFF6366F1),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),
          // Color Palette
          const Text(
            'Wave Accent Color:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _palette.map((item) {
                final (name, col) = item;
                final isSelected = _pgColor == col;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => setState(() => _pgColor = col),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: col.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? col : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: col,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),
          // Generated Code Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'GENERATED CODE',
                      style: TextStyle(
                        color: Color(0xFF818CF8),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    InkWell(
                      onTap: () => _copyToClipboard(
                        context,
                        _generatePlaygroundCode(),
                        'Wave Line Config',
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.copy_rounded,
                              color: Color(0xFF818CF8), size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Copy Code',
                            style: TextStyle(
                              color: Color(0xFF818CF8),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SelectableText(
                  _generatePlaygroundCode(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFFCBD5E1),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(
    String label,
    String valueText,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label: $valueText',
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              activeColor: const Color(0xFF6366F1),
              inactiveColor: const Color(0xFF334155),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  String _generatePlaygroundCode() {
    final valueArg = _pgIndeterminate ? '' : '  value: ${_pgProgress.toStringAsFixed(2)},\n';
    return '''Material4ProgressBar(
$valueArg  style: Material4ProgressStyle.${_pgStyle.name},
  fill: const Material4ProgressFill(color: Color(${_pgColor.toARGB32()})),
  height: 40.0,
  waveLine: const Material4WaveLineConfig(
    amplitude: ${_pgAmplitude.toStringAsFixed(1)},
    frequency: ${_pgFrequency.toStringAsFixed(1)},
    speed: ${_pgSpeed.toStringAsFixed(1)},
    thickness: ${_pgThickness.toStringAsFixed(1)},
    cornerSmoothness: ${_pgCornerSmoothness.toStringAsFixed(2)},
    direction: WaveDirection.${_pgDirection.name},
    paused: $_pgPaused,
  ),
)''';
  }
}
