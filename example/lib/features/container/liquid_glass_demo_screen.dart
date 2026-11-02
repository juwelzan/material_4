import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_4/material_4.dart';

/// Liquid Glass as Apple describes it, built with [Material4Container]:
///
/// * regular / clear (with dimming) / tinted glass,
/// * small glass that flips light ↔ dark with the content scrolling under it,
/// * larger glass that is thicker and more opaque,
/// * `.interactive()` controls that flex and light up under the finger,
/// * a `GlassEffectContainer`-style group whose buttons melt together,
/// * materialize in / out,
/// * pointer hover (lift / highlight, light follows the cursor) and a
///   right-click / long-press glass context menu,
/// * one shared light for all glass (pointer or orbiting), help tags and
///   keyboard focus.
class LiquidGlassDemoScreen extends StatefulWidget {
  const LiquidGlassDemoScreen({super.key});

  @override
  State<LiquidGlassDemoScreen> createState() => _LiquidGlassDemoScreenState();
}

class _LiquidGlassDemoScreenState extends State<LiquidGlassDemoScreen>
    with SingleTickerProviderStateMixin {
  // Start offset for screenshots, e.g. --dart-define=M4_GLASS_SCROLL=700.
  final _scroll = ScrollController(
    initialScrollOffset: const int.fromEnvironment('M4_GLASS_SCROLL')
        .toDouble(),
  );
  bool _merged = true;
  bool _showCard = true;
  int _likes = 0;
  bool _sweepLight = false;

  // A light source orbiting the screen: every glass highlight turns with it.
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );
  late final Animation<double> _sweepAngle = _sweep.drive(
    Tween(begin: 0.0, end: 2 * math.pi),
  );

  void _toggleSweep() {
    setState(() => _sweepLight = !_sweepLight);
    _sweepLight ? _sweep.repeat() : _sweep.stop();
  }

  @override
  void dispose() {
    _sweep.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // One shared light for all glass: it sits at the mouse pointer on
    // desktop / web / iPad, or orbits the screen when "Sweep light" is on.
    return Material4GlassLight(
      followPointer: true,
      angle: _sweepLight ? _sweepAngle : null,
      child: _page(context),
    );
  }

  Widget _page(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return GlassContentAwareScope(
      // The black scaffold shows through unpainted content, so tell the
      // sampler; otherwise it assumes white in light mode.
      backgroundColor: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // ---- Content layer (sampled for light/dark adaptation) ----
            Positioned.fill(
              child: GlassContentAwareContent(
                child: ListView(
                  controller: _scroll,
                  padding: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.paddingOf(context).top + 72,
                    0,
                    140,
                  ),
                  children: [
                    _section('Regular · larger glass is thicker'),
                    const _Photo(
                      colors: [Color(0xFFFDE68A), Color(0xFFF472B6)],
                    ),
                    _onPhoto(
                      const [Color(0xFF38BDF8), Color(0xFF818CF8)],
                      Material4Container(
                        shape: Material4Type.squircle,
                        width: double.infinity,
                        height: 150,
                        config: const Material4Config(
                          type: Material4Type.arch,
                          cornerRadius: 34,
                        ),
                        liquidGlass: const Material4LiquidGlass(
                          followTheme: true,
                          settings: LiquidGlassSettings(
                            specularSharpness: GlassSpecularSharpness.sharp,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Now Playing',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Liquid Afternoon',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _section('Clear · over media, with 35 % dimming'),
                    _onPhoto(
                      const [
                        Color(0xFFFFF7AE),
                        Color(0xFF34D399),
                        Color(0xFF0EA5E9),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final icon in [
                            Icons.skip_previous_rounded,
                            Icons.pause_rounded,
                            Icons.skip_next_rounded,
                          ])
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Material4Container(
                                shape: Material4Type.capsule,
                                width: 64,
                                height: 64,
                                liquidGlass: const Material4LiquidGlass.clear(
                                  dimming: .35,
                                ),
                                onTap: () {},
                                child: Icon(icon, size: 32),
                              ),
                            ),
                        ],
                      ),
                    ),
                    _section('Tint · prominent action'),
                    _onPhoto(
                      const [Color(0xFFE0E7FF), Color(0xFFFBCFE8)],
                      Material4Container(
                        shape: Material4Type.capsule,
                        width: 220,
                        height: 56,
                        liquidGlass: const Material4LiquidGlass.control(
                          tint: Color(0xFFFF9500),
                        ),
                        onTap: () => setState(() => _likes++),
                        child: Center(
                          child: Text(
                            'Add to Bag · $_likes',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _section(
                      'Pointer · hover lifts, right-click / long-press = menu',
                    ),
                    _onPhoto(
                      const [Color(0xFF0F766E), Color(0xFF22D3EE)],
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (final (icon, label) in [
                                (Icons.photo_rounded, 'Photos'),
                                (Icons.ios_share_rounded, 'Share'),
                                (Icons.favorite_rounded, 'Favorite'),
                              ])
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Material4Container(
                                    shape: Material4Type.capsule,
                                    width: 60,
                                    height: 60,
                                    liquidGlass: Material4LiquidGlass(
                                      contextMenu: _menu(context),
                                      // Help tag after resting the pointer;
                                      // Tab focuses, Enter / Space activate.
                                      tooltip: label,
                                      haptics: true,
                                    ),
                                    onTap: () {},
                                    child: Icon(icon, size: 28),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Material4Container(
                            shape: Material4Type.capsule,
                            width: 200,
                            height: 44,
                            liquidGlass: Material4LiquidGlass(
                              tooltip: 'Orbit one light around every glass',
                              tint: _sweepLight
                                  ? const Color(0xFF0A84FF)
                                  : null,
                            ),
                            onTap: _toggleSweep,
                            child: Center(
                              child: Text(
                                _sweepLight ? 'Light: sweep' : 'Light: pointer',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Material4Container(
                            shape: Material4Type.squircle,
                            width: double.infinity,
                            height: 140,
                            config: const Material4Config(
                              type: Material4Type.squircle,
                              cornerRadius: 30,
                            ),
                            liquidGlass: Material4LiquidGlass(
                              // Large glass: highlight (no movement); the
                              // light follows the cursor.
                              contextMenu: _menu(context),
                              // A custom lifted preview while the menu is open.
                              contextMenuPreview: (context) => Container(
                                width: 260,
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0F766E),
                                      Color(0xFF22D3EE),
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Preview',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Hover me · right-click me',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _section('Materialize'),
                    _onPhoto(
                      const [Color(0xFF1E1B4B), Color(0xFF7C3AED)],
                      Column(
                        children: [
                          Material4Container(
                            shape: Material4Type.capsule,
                            width: 180,
                            height: 48,
                            liquidGlass: const Material4LiquidGlass(),
                            onTap: () => setState(() => _showCard = !_showCard),
                            child: Center(
                              child: Text(
                                _showCard ? 'Hide card' : 'Show card',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Material4Container(
                            shape: Material4Type.squircle,
                            height: 110,
                            config: const Material4Config(
                              type: Material4Type.squircle,
                              cornerRadius: 30,
                            ),
                            liquidGlass: Material4LiquidGlass(
                              visible: _showCard,
                            ),
                            child: const Center(
                              child: Text(
                                'Materialized glass',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _section('Custom shapes (clipped glass)'),
                    _onPhoto(
                      const [Color(0xFFFFEDD5), Color(0xFFFB7185)],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material4Container(
                            customShape: Material4CustomShape.star(
                              points: 6,
                              innerRadiusRatio: .62,
                              cornerRadius: 10,
                            ),
                            width: 140,
                            height: 140,
                            liquidGlass: const Material4LiquidGlass(),
                            onTap: () {},
                            child: const Center(child: Text('Star')),
                          ),
                          Material4Container(
                            shape: Material4Type.hexagonSoft,
                            width: 140,
                            height: 140,
                            liquidGlass: const Material4LiquidGlass(),
                            child: const Center(child: Text('Hexagon')),
                          ),
                        ],
                      ),
                    ),
                    const _Photo(
                      colors: [Color(0xFF020617), Color(0xFF0F172A)],
                    ),
                    const _Photo(
                      colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
                    ),
                  ],
                ),
              ),
            ),

            // ---- Functional layer: floating glass ----
            // Small title pill: flips light/dark with the content beneath.
            Positioned(
              top: MediaQuery.paddingOf(context).top + 12,
              left: 0,
              right: 0,
              child: Center(
                child: Material4Container(
                  shape: Material4Type.concaveRounded,
                  config: Material4Config(
                    type: Material4Type.concaveRounded,
                    cornerRadius: 4,
                  ),
                  width: 180,
                  height: 44,
                  child: Center(
                    child: Text(
                      'Liquid Glass',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Toolbar: a group whose buttons melt into one another.
            Positioned(
              left: 0,
              right: 0,
              bottom: bottom + 20,
              child: Center(
                child: Material4GlassGroup(
                  spacing: 24,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _toolButton(Icons.edit_rounded),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 450),
                        curve: Curves.easeInOutCubic,
                        width: _merged ? 4 : 36,
                      ),
                      _toolButton(Icons.brush_rounded),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 450),
                        curve: Curves.easeInOutCubic,
                        width: _merged ? 4 : 36,
                      ),
                      _toolButton(
                        _merged
                            ? Icons.unfold_more_rounded
                            : Icons.unfold_less_rounded,
                        onTap: () => setState(() => _merged = !_merged),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _menu(BuildContext context) {
    void say(String what) => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(what)));
    return [
      GlassContextMenuAction(
        icon: const Icon(Icons.copy_rounded),
        onPressed: () => say('Copy'),
        child: const Text('Copy'),
      ),
      GlassContextMenuAction(
        icon: const Icon(Icons.ios_share_rounded),
        onPressed: () => say('Share'),
        child: const Text('Share'),
      ),
      GlassContextMenuAction(
        icon: const Icon(Icons.favorite_border_rounded),
        onPressed: () => say('Favorite'),
        child: const Text('Favorite'),
      ),
      const GlassMenuDivider(),
      GlassContextMenuAction(
        icon: const Icon(Icons.delete_outline_rounded),
        isDestructive: true,
        onPressed: () => say('Delete'),
        child: const Text('Delete'),
      ),
    ];
  }

  Widget _toolButton(IconData icon, {VoidCallback? onTap}) =>
      Material4Container(
        shape: Material4Type.capsule,
        width: 56,
        height: 56,
        liquidGlass: const Material4LiquidGlass(),
        onTap: onTap ?? () {},
        child: Icon(icon, size: 26),
      );

  Widget _section(String title) => Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF475569),
      ),
    ),
  );

  /// Places [child] over colourful, detailed "media" so the lensing shows.
  Widget _onPhoto(List<Color> colors, Widget child) => Stack(
    children: [
      Positioned.fill(child: _Photo(colors: colors, height: null)),
      Padding(padding: const EdgeInsets.all(24), child: child),
    ],
  );
}

/// Stand-in for a photo: a gradient with stripes and dots, so refraction and
/// edge lensing are easy to see.
class _Photo extends StatelessWidget {
  final List<Color> colors;
  final double? height;
  const _Photo({required this.colors, this.height = 160});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _PhotoPainter(colors),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PhotoPainter extends CustomPainter {
  final List<Color> colors;
  const _PhotoPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ).createShader(rect),
    );
    final line = Paint()
      ..color = Colors.white.withValues(alpha: .35)
      ..strokeWidth = 3;
    for (double x = -size.height; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), line);
    }
    final dot = Paint()..color = Colors.black.withValues(alpha: .25);
    for (double y = 14; y < size.height; y += 30) {
      for (double x = 14; x < size.width; x += 30) {
        canvas.drawCircle(Offset(x, y), 4, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_PhotoPainter old) => old.colors != colors;
}
