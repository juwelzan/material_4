import 'package:flutter/material.dart';
import 'package:material_4/material_4.dart';

/// Liquid-glass containers over a busy background, to compare platforms.
class LiquidGlassDemoScreen extends StatefulWidget {
  const LiquidGlassDemoScreen({super.key});

  @override
  State<LiquidGlassDemoScreen> createState() => _LiquidGlassDemoScreenState();
}

class _LiquidGlassDemoScreenState extends State<LiquidGlassDemoScreen> {
  int _taps = 0;
  GlassQuality? _quality;

  @override
  Widget build(BuildContext context) {
    final glass = Material4LiquidGlass(quality: _quality);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liquid Glass'),
        actions: [
          PopupMenuButton<GlassQuality?>(
            tooltip: 'Quality',
            icon: const Icon(Icons.tune),
            onSelected: (q) => setState(() => _quality = q),
            itemBuilder: (_) => [
              const PopupMenuItem(value: null, child: Text('Auto')),
              for (final q in GlassQuality.values)
                PopupMenuItem(value: q, child: Text(q.name)),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _Backdrop()),
          ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Material4Container(
                shape: Material4Type.squircle,
                height: 120,
                liquidGlass: glass.copyWith(interactive: false),
                child: const Center(child: _Label('Panel · squircle')),
              ),
              const SizedBox(height: 24),
              Center(
                child: Material4Container(
                  shape: Material4Type.capsule,
                  width: 220,
                  height: 60,
                  liquidGlass: glass,
                  onTap: () => setState(() => _taps++),
                  child: Center(child: _Label('Tap me · $_taps')),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Material4Container(
                      customShape: Material4CustomShape.star(
                        points: 6,
                        innerRadiusRatio: 0.62,
                        cornerRadius: 10,
                      ),
                      height: 160,
                      liquidGlass: glass.copyWith(interactive: true),
                      border: const Material4Border.gradientGlow(width: 1.2),
                      child: const Center(child: _Label('Star')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Material4Container(
                      shape: Material4Type.hexagonSoft,
                      height: 160,
                      liquidGlass: glass.copyWith(
                        interactive: true,
                        settings: const LiquidGlassSettings(
                          thickness: 30,
                          blur: 4,
                          glassColor: Color(0x33FF4FD8),
                          chromaticAberration: 0.6,
                        ),
                      ),
                      child: const Center(child: _Label('Tinted hex')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Material4Container(
                shape: Material4Type.ticketScallop,
                height: 110,
                liquidGlass: glass.copyWith(interactive: false),
                border: const Material4Border.styled(
                  BorderStyleType.dashed,
                  width: 1.2,
                  color: Color(0x88FFFFFF),
                ),
                child: const Center(child: _Label('Ticket · custom rim')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      );
}

/// Colourful content behind the glass so refraction and blur are visible.
class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0EA5E9), Color(0xFF7C3AED), Color(0xFFF97316)],
        ),
      ),
      child: GridView.count(
        crossAxisCount: 6,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < 120; i++)
            Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: i.isEven ? BoxShape.circle : BoxShape.rectangle,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
