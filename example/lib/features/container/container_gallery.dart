import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_4/material_4.dart';

const _ink = Color(0xFF1E293B);
const _accent = Color(0xFF6366F1);

/// A labelled demo cell: the container on top, its name underneath.
class DemoTile extends StatelessWidget {
  final String label;
  final Widget child;
  const DemoTile({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Center(child: child)),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _ink,
          ),
        ),
      ],
    );
  }
}

/// Responsive grid used by every tab.
class DemoGrid extends StatelessWidget {
  final List<Widget> children;
  final double tileWidth;
  final double aspectRatio;
  const DemoGrid({
    super.key,
    required this.children,
    this.tileWidth = 150,
    this.aspectRatio = 0.95,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: tileWidth,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: aspectRatio,
      children: children,
    );
  }
}

/// Section header for tabs that mix several groups.
class DemoSection extends StatelessWidget {
  final String title;
  final String subtitle;
  const DemoSection(this.title, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: _ink)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: _ink.withValues(alpha: .6))),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Built-in shape presets
// ---------------------------------------------------------------------------

/// Every [Material4Type] rendered through the single `shape:` parameter.
class ShapesTab extends StatelessWidget {
  const ShapesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoGrid(
      children: [
        for (final type in Material4Type.values)
          DemoTile(
            label: type.name,
            child: Material4Container(
              shape: type,
              width: 120,
              height: 96,
              color: const Color(0xFFEEF2FF),
              borderColor: _accent.withValues(alpha: .55),
              borderWidth: 1.4,
              // customBezier needs a builder; give it a simple wedge.
              config: type == Material4Type.customBezier
                  ? Material4Config.customBezier(
                      builder: (s) => Path()
                        ..moveTo(0, s.height)
                        ..quadraticBezierTo(s.width / 2, -s.height * .4,
                            s.width, s.height)
                        ..close(),
                    )
                  : const Material4Config(),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Developer-defined shapes + morphing
// ---------------------------------------------------------------------------

/// Shapes a developer builds themselves via `customShape:`, plus morphing.
class CustomShapesTab extends StatelessWidget {
  const CustomShapesTab({super.key});

  static final _shapes = <String, Material4CustomShape>{
    'polygon(5, r12)': Material4CustomShape.polygon(sides: 5, cornerRadius: 12),
    'polygon(3)': Material4CustomShape.polygon(sides: 3),
    'polygon(8, r6)': Material4CustomShape.polygon(sides: 8, cornerRadius: 6),
    'star(5)': Material4CustomShape.star(points: 5, innerRadiusRatio: .45),
    'star(8, r4)': Material4CustomShape.star(
        points: 8, innerRadiusRatio: .7, cornerRadius: 4),
    'superellipse(2.5)': Material4CustomShape.superellipse(n: 2.5),
    'superellipse(6)': Material4CustomShape.superellipse(n: 6),
    'corners(40,4,40,4)': Material4CustomShape.corners(
        topLeft: 40, topRight: 4, bottomRight: 40, bottomLeft: 4),
    'bezier: heart': Material4CustomShape.bezier((s) {
      final w = s.width, h = s.height;
      return Path()
        ..moveTo(w / 2, h * .9)
        ..cubicTo(-w * .2, h * .45, w * .2, -h * .1, w / 2, h * .25)
        ..cubicTo(w * .8, -h * .1, w * 1.2, h * .45, w / 2, h * .9)
        ..close();
    }),
    'builder: wave card': Material4CustomShape.builder((s) =>
        Material4ShapeBuilder()
            .moveTo(0, 16)
            .quadraticBezierTo(0, 0, 16, 0)
            .lineTo(s.width - 16, 0)
            .quadraticBezierTo(s.width, 0, s.width, 16)
            .lineTo(s.width, s.height - 12)
            .addConvexBulge(Offset(s.width, s.height - 12),
                Offset(0, s.height - 12), 14)
            .close()),
    'from preset: shield':
        Material4CustomShape.fromType(Material4Type.shield),
    'morph 50%: hex→flower': Material4CustomShape.morph(
      from: Material4Type.roundedHexagon,
      to: Material4Type.flower,
      progress: .5,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: DemoSection('Custom shapes',
              'Material4CustomShape — polygon, star, superellipse, corners, bezier, builder'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid.extent(
            maxCrossAxisExtent: 150,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: .95,
            children: [
              for (final e in _shapes.entries)
                DemoTile(
                  label: e.key,
                  child: Material4Container(
                    customShape: e.value,
                    width: 110,
                    height: 100,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA5B4FC), Color(0xFFF0ABFC)],
                    ),
                    border: const Material4Border.solid(
                        color: Color(0xFF4338CA), width: 1.4),
                  ),
                ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: DemoSection('Live morphing',
              'containerAnimation: shapeSequence morphs through presets'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _morph(const [
                  Material4Type.squircle,
                  Material4Type.roundedHexagon,
                  Material4Type.flower,
                  Material4Type.starburst,
                ]),
                _morph(const [
                  Material4Type.capsule,
                  Material4Type.ticketScallop,
                  Material4Type.cloud,
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _morph(List<Material4Type> seq) => Material4Container(
        width: 150,
        height: 130,
        shape: seq.first,
        gradient: const LinearGradient(
          colors: [Color(0xFF22D3EE), Color(0xFF6366F1)],
        ),
        border: const Material4Border.animatedGradient(width: 2),
        containerAnimation: Material4ContainerAnimation(
          shapeSequence: seq,
          borderAnimation: true,
          shapeDuration: Duration(milliseconds: 1600 * seq.length),
          pingPong: false,
        ),
        child: const Center(
          child: Text('morph',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      );
}

// ---------------------------------------------------------------------------
// 3. All border styles
// ---------------------------------------------------------------------------

/// Every [BorderStyleType]; the moving ones animate continuously.
class BordersTab extends StatefulWidget {
  const BordersTab({super.key});

  @override
  State<BordersTab> createState() => _BordersTabState();
}

class _BordersTabState extends State<BordersTab> {
  Material4Type _shape = Material4Type.squircle;
  bool _dark = true;

  static const _animated = {
    BorderStyleType.animatedGradient,
    BorderStyleType.rainbow,
    BorderStyleType.animatedDashed,
    BorderStyleType.flowingBorder,
    BorderStyleType.movingDash,
    BorderStyleType.pulsatingBorder,
    BorderStyleType.liquidBorder,
    BorderStyleType.waveBorder,
    BorderStyleType.particleBorder,
    BorderStyleType.orbitingLightBorder,
    BorderStyleType.shimmerBorder,
    BorderStyleType.conicGradientBorder,
    BorderStyleType.energyBorder,
    BorderStyleType.railroad,
    BorderStyleType.beadChain,
    BorderStyleType.tapered,
    BorderStyleType.ropeTwist,
    BorderStyleType.segmentedGlow,
  };

  static const _shapes = [
    Material4Type.squircle,
    Material4Type.capsule,
    Material4Type.hexagonSoft,
    Material4Type.ticketScallop,
    Material4Type.cloud,
    Material4Type.starburst,
  ];

  @override
  Widget build(BuildContext context) {
    final bg = _dark ? const Color(0xFF0F172A) : Colors.white;
    final stroke = _dark ? const Color(0xFF38BDF8) : _accent;
    return ColoredBox(
      color: _dark ? const Color(0xFF020617) : const Color(0xFFF8FAFC),
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                FilterChip(
                  label: Text(_dark ? 'Dark' : 'Light'),
                  selected: _dark,
                  onSelected: (v) => setState(() => _dark = v),
                ),
                const SizedBox(width: 8),
                for (final s in _shapes) ...[
                  ChoiceChip(
                    label: Text(s.name),
                    selected: _shape == s,
                    onSelected: (_) => setState(() => _shape = s),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          Expanded(
            child: DefaultTextStyle.merge(
              style: TextStyle(color: _dark ? Colors.white70 : _ink),
              child: DemoGrid(
                children: [
                  for (final style in BorderStyleType.values)
                    _BorderCell(
                      style: style,
                      shape: _shape,
                      fill: bg,
                      stroke: stroke,
                      animated: _animated.contains(style),
                      labelColor: _dark ? Colors.white70 : _ink,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BorderCell extends StatelessWidget {
  final BorderStyleType style;
  final Material4Type shape;
  final Color fill;
  final Color stroke;
  final bool animated;
  final Color labelColor;

  const _BorderCell({
    required this.style,
    required this.shape,
    required this.fill,
    required this.stroke,
    required this.animated,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Material4Container(
              shape: shape,
              width: 116,
              height: 88,
              color: fill,
              shadows: const [],
              config: Material4Config(
                type: shape,
                borderStyle: style,
                borderGradient: const SweepGradient(colors: [
                  Color(0xFF22D3EE),
                  Color(0xFFA855F7),
                  Color(0xFFF43F5E),
                  Color(0xFF22D3EE),
                ]),
                glowColor: stroke,
                neonGlowColor: stroke,
                metallicType: MetallicType.gold,
                embossLightAngle: math.pi * 1.25,
              ),
              border: Material4Border.styled(
                style,
                width: 2.4,
                color: stroke,
                gradient: const SweepGradient(colors: [
                  Color(0xFF22D3EE),
                  Color(0xFFA855F7),
                  Color(0xFFF43F5E),
                  Color(0xFF22D3EE),
                ]),
                blurRadius: 8,
                glowIntensity: 1.2,
                animated: animated,
              ),
              containerAnimation: animated
                  ? const Material4ContainerAnimation(
                      borderAnimation: true,
                      pingPong: false,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          animated ? '${style.name} ▶' : style.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: labelColor),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Surfaces: presets, effects, textures, patterns
// ---------------------------------------------------------------------------

/// The unified `background:` object and the ready-made presets.
class SurfacesTab extends StatelessWidget {
  const SurfacesTab({super.key});

  static const _presets = {
    'minimal': Material4ContainerPreset.minimal,
    'glass': Material4ContainerPreset.glass,
    'neon': Material4ContainerPreset.neon,
    'organicCard': Material4ContainerPreset.organicCard,
    'carbonTech': Material4ContainerPreset.carbonTech,
    'liquid': Material4ContainerPreset.liquid,
    'holographic': Material4ContainerPreset.holographic,
    'paperCraft': Material4ContainerPreset.paperCraft,
  };

  static const _textures = {
    'paper': Material4Texture.paper(opacity: .35),
    'grain': Material4Texture.grain(opacity: .35),
    'marble': Material4Texture.marble(opacity: .5),
    'carbonFiber': Material4Texture.carbonFiber(opacity: .5),
    'brushedMetal': Material4Texture.brushedMetal(opacity: .5),
    'metallicFoil': Material4Texture.metallicFoil(opacity: .5),
    'holographic': Material4Texture.holographic(opacity: .6),
    'mesh': Material4Texture.mesh(opacity: .4),
  };

  static const _patterns = {
    'dots': Material4Pattern.dots(color: Color(0x554338CA)),
    'grid': Material4Pattern.grid(color: Color(0x554338CA)),
    'stripes': Material4Pattern.stripes(color: Color(0x554338CA)),
    'waves': Material4Pattern.waves(color: Color(0x554338CA)),
    'hexagonal': Material4Pattern.hexagonal(color: Color(0x554338CA)),
    'isometric': Material4Pattern.isometric(color: Color(0x554338CA)),
    'circuit': Material4Pattern.circuit(color: Color(0x554338CA)),
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop so the glass preset has something to blur.
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE0E7FF), Color(0xFFFCE7F3)],
              ),
            ),
          ),
        ),
        CustomScrollView(
          slivers: [
            _section('Presets', 'Material4Container.fromPreset(preset: ...)'),
            _grid([
              for (final e in _presets.entries)
                DemoTile(
                  label: e.key,
                  child: Material4Container.fromPreset(
                    preset: e.value,
                    width: 120,
                    height: 96,
                    padding: EdgeInsets.zero,
                  ),
                ),
            ]),
            _section('Background effects',
                'Material4Background(effect: BackgroundEffectType.*)'),
            _grid([
              for (final effect in BackgroundEffectType.values)
                DemoTile(
                  label: effect.name,
                  child: Material4Container(
                    shape: Material4Type.squircle,
                    width: 120,
                    height: 96,
                    background: Material4Background(
                      effect: effect,
                      color: const Color(0xFF6366F1),
                      meshColors: const [
                        Color(0xFF22D3EE),
                        Color(0xFFA855F7),
                        Color(0xFFF43F5E),
                        Color(0xFFFACC15),
                      ],
                    ),
                  ),
                ),
            ]),
            _section('Textures', 'Material4Background(texture: ...)'),
            _grid([
              for (final e in _textures.entries)
                DemoTile(
                  label: e.key,
                  child: Material4Container(
                    shape: Material4Type.smoothRounded,
                    width: 120,
                    height: 96,
                    background: Material4Background(
                      color: const Color(0xFF334155),
                      texture: e.value,
                    ),
                  ),
                ),
            ]),
            _section('Patterns', 'Material4Background(pattern: ...)'),
            _grid([
              for (final e in _patterns.entries)
                DemoTile(
                  label: e.key,
                  child: Material4Container(
                    shape: Material4Type.ticketScallop,
                    width: 120,
                    height: 96,
                    background: Material4Background(
                      color: Colors.white,
                      pattern: e.value,
                    ),
                    border: const Material4Border.solid(
                        color: Color(0x334338CA)),
                  ),
                ),
            ]),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ],
    );
  }

  Widget _section(String t, String s) =>
      SliverToBoxAdapter(child: DemoSection(t, s));

  Widget _grid(List<Widget> children) => SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverGrid.extent(
          maxCrossAxisExtent: 150,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: .95,
          children: children,
        ),
      );
}
