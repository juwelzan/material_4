import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Available procedural texture types for [Material4Container].
enum Material4TextureType {
  none,
  paper,
  grain,
  noise,
  fabric,
  carbonFiber,
  brushedMetal,
  concrete,
  marble,
  stone,
  wood,
  leather,
  frostedGlass,
  liquid,
  holographic,
  iridescent,
  metallicFoil,
  softMatte,
  embossedPebbles,
  meshTexture,
  dottedTexture,
  crosshatchTexture,
  organicGrain,
  gradientNoise,
}

/// Comprehensive texture configuration model for [Material4Container].
@immutable
class Material4Texture {
  /// The procedural texture type.
  final Material4TextureType type;

  /// Opacity multiplier for the texture layer (0.0 to 1.0).
  final double opacity;

  /// Dimensional scale factor for texture granules/cells.
  final double scale;

  /// Density multiplier for noise/fibers/dots (0.2 to 5.0).
  final double density;

  /// Rotation angle in radians applied to the texture coordinates.
  final double rotation;

  /// Custom tint color overriding or blending with the texture.
  final Color? color;

  /// Canvas blend mode when applying texture over the container background.
  final BlendMode blendMode;

  /// Spatial coordinate offset.
  final Offset offset;

  /// Animation speed multiplier for moving or shifting textures.
  final double animationSpeed;

  /// Whether real-time texture animation is enabled.
  final bool animated;

  /// Texture relief / bump intensity (0.0 to 2.0).
  final double intensity;

  /// Normalized animation progress value (0.0 to 1.0).
  final double progress;

  const Material4Texture({
    this.type = Material4TextureType.none,
    this.opacity = 0.15,
    this.scale = 1.0,
    this.density = 1.0,
    this.rotation = 0.0,
    this.color,
    this.blendMode = BlendMode.srcOver,
    this.offset = Offset.zero,
    this.animationSpeed = 1.0,
    this.animated = false,
    this.intensity = 1.0,
    this.progress = 0.0,
  });

  /// Preset for modern twill-weave carbon fiber.
  const Material4Texture.carbonFiber({
    double opacity = 0.28,
    double scale = 1.0,
    Color? color,
    BlendMode blendMode = BlendMode.srcOver,
  }) : this(
          type: Material4TextureType.carbonFiber,
          opacity: opacity,
          scale: scale,
          color: color,
          blendMode: blendMode,
        );

  /// Preset for anisotropic brushed metal with directional grain.
  const Material4Texture.brushedMetal({
    double opacity = 0.22,
    double rotation = math.pi / 4,
    Color? color,
    BlendMode blendMode = BlendMode.srcOver,
  }) : this(
          type: Material4TextureType.brushedMetal,
          opacity: opacity,
          rotation: rotation,
          color: color,
          blendMode: blendMode,
        );

  /// Preset for authentic organic paper pulp texture.
  const Material4Texture.paper({
    double opacity = 0.18,
    double density = 1.2,
    Color? color,
    BlendMode blendMode = BlendMode.srcOver,
  }) : this(
          type: Material4TextureType.paper,
          opacity: opacity,
          density: density,
          color: color,
          blendMode: blendMode,
        );

  /// Preset for fine tactile film grain.
  const Material4Texture.grain({
    double opacity = 0.12,
    double density = 1.5,
    bool animated = false,
  }) : this(
          type: Material4TextureType.grain,
          opacity: opacity,
          density: density,
          animated: animated,
        );

  /// Preset for elegant veined architectural marble.
  const Material4Texture.marble({
    double opacity = 0.25,
    double scale = 1.2,
    Color? color,
  }) : this(
          type: Material4TextureType.marble,
          opacity: opacity,
          scale: scale,
          color: color,
        );

  /// Preset for shifting rainbow holographic foil.
  const Material4Texture.holographic({
    double opacity = 0.35,
    bool animated = true,
    double animationSpeed = 1.0,
  }) : this(
          type: Material4TextureType.holographic,
          opacity: opacity,
          animated: animated,
          animationSpeed: animationSpeed,
        );

  /// Preset for micro-perforated technical mesh grill.
  const Material4Texture.mesh({
    double opacity = 0.20,
    double scale = 1.0,
    Color? color,
  }) : this(
          type: Material4TextureType.meshTexture,
          opacity: opacity,
          scale: scale,
          color: color,
        );

  /// Preset for specular metallic foil texture.
  const Material4Texture.metallicFoil({
    double opacity = 0.25,
    double scale = 1.0,
    Color? color,
  }) : this(
          type: Material4TextureType.metallicFoil,
          opacity: opacity,
          scale: scale,
          color: color,
        );

  Material4Texture copyWith({
    Material4TextureType? type,
    double? opacity,
    double? scale,
    double? density,
    double? rotation,
    Color? color,
    BlendMode? blendMode,
    Offset? offset,
    double? animationSpeed,
    bool? animated,
    double? intensity,
    double? progress,
  }) {
    return Material4Texture(
      type: type ?? this.type,
      opacity: opacity ?? this.opacity,
      scale: scale ?? this.scale,
      density: density ?? this.density,
      rotation: rotation ?? this.rotation,
      color: color ?? this.color,
      blendMode: blendMode ?? this.blendMode,
      offset: offset ?? this.offset,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      animated: animated ?? this.animated,
      intensity: intensity ?? this.intensity,
      progress: progress ?? this.progress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4Texture &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          opacity == other.opacity &&
          scale == other.scale &&
          density == other.density &&
          rotation == other.rotation &&
          color == other.color &&
          blendMode == other.blendMode &&
          offset == other.offset &&
          animationSpeed == other.animationSpeed &&
          animated == other.animated &&
          intensity == other.intensity &&
          progress == other.progress;

  @override
  int get hashCode => Object.hash(
        type,
        opacity,
        scale,
        density,
        rotation,
        color,
        blendMode,
        offset,
        animationSpeed,
        animated,
        intensity,
        progress,
      );
}

/// GPU-accelerated procedural canvas renderer for [Material4Texture].
///
/// Uses zero external bitmap dependencies, generating mathematically
/// reproducible textures on demand with strict clip path conformance.
class Material4TextureRenderer {
  const Material4TextureRenderer._();

  /// Renders the given [texture] onto [canvas] constrained within [clipPath].
  static void renderTexture({
    required Canvas canvas,
    required Size size,
    required Path clipPath,
    required Material4Texture texture,
    double animationProgress = 0.0,
  }) {
    if (texture.type == Material4TextureType.none ||
        texture.opacity <= 0.0 ||
        size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    canvas.save();
    canvas.clipPath(clipPath);

    final w = size.width;
    final h = size.height;

    switch (texture.type) {
      case Material4TextureType.none:
        break;

      case Material4TextureType.carbonFiber:
        _renderCarbonFiber(canvas, w, h, texture);
        break;

      case Material4TextureType.brushedMetal:
        _renderBrushedMetal(canvas, w, h, texture);
        break;

      case Material4TextureType.paper:
        _renderPaper(canvas, w, h, texture);
        break;

      case Material4TextureType.grain:
      case Material4TextureType.noise:
      case Material4TextureType.organicGrain:
        _renderNoiseGrain(canvas, w, h, texture, animationProgress);
        break;

      case Material4TextureType.marble:
        _renderMarble(canvas, w, h, texture, animationProgress);
        break;

      case Material4TextureType.wood:
        _renderWoodGrain(canvas, w, h, texture);
        break;

      case Material4TextureType.meshTexture:
        _renderMesh(canvas, w, h, texture);
        break;

      case Material4TextureType.holographic:
      case Material4TextureType.iridescent:
        _renderHolographic(canvas, w, h, texture, animationProgress);
        break;

      case Material4TextureType.fabric:
      case Material4TextureType.crosshatchTexture:
        _renderFabric(canvas, w, h, texture);
        break;

      case Material4TextureType.concrete:
      case Material4TextureType.stone:
        _renderStone(canvas, w, h, texture);
        break;

      case Material4TextureType.leather:
      case Material4TextureType.embossedPebbles:
        _renderLeather(canvas, w, h, texture);
        break;

      case Material4TextureType.frostedGlass:
      case Material4TextureType.softMatte:
        _renderSoftMatte(canvas, w, h, texture);
        break;

      case Material4TextureType.metallicFoil:
        _renderMetallicFoil(canvas, w, h, texture, animationProgress);
        break;

      case Material4TextureType.liquid:
        _renderLiquidTexture(canvas, w, h, texture, animationProgress);
        break;

      case Material4TextureType.dottedTexture:
        _renderDottedTexture(canvas, w, h, texture);
        break;

      case Material4TextureType.gradientNoise:
        _renderGradientNoise(canvas, w, h, texture, animationProgress);
        break;
    }

    canvas.restore();
  }

  static void _renderCarbonFiber(Canvas canvas, double w, double h, Material4Texture texture) {
    final cellSize = 8.0 * texture.scale.clamp(0.5, 3.0);
    final paintDark = Paint()
      ..color = (texture.color ?? Colors.black).withValues(alpha: texture.opacity * 0.9)
      ..style = PaintingStyle.fill;
    final paintLight = Paint()
      ..color = (texture.color ?? Colors.white).withValues(alpha: texture.opacity * 0.4)
      ..style = PaintingStyle.fill;

    for (double y = 0; y < h; y += cellSize) {
      final rowIdx = (y / cellSize).floor();
      for (double x = 0; x < w; x += cellSize) {
        final colIdx = (x / cellSize).floor();
        final isEven = (rowIdx + colIdx) % 2 == 0;
        final rect = Rect.fromLTWH(x, y, cellSize, cellSize);
        canvas.drawRect(rect, isEven ? paintDark : paintLight);
      }
    }
  }

  static void _renderBrushedMetal(Canvas canvas, double w, double h, Material4Texture texture) {
    final paint = Paint()
      ..color = (texture.color ?? Colors.white).withValues(alpha: texture.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.save();
    canvas.translate(w / 2, h / 2);
    canvas.rotate(texture.rotation);
    canvas.translate(-w / 2, -h / 2);

    final span = math.max(w, h) * 1.5;
    for (double y = -span * 0.25; y < span; y += 3.5 / texture.density) {
      canvas.drawLine(Offset(-span * 0.25, y), Offset(span, y), paint);
    }
    canvas.restore();
  }

  static void _renderPaper(Canvas canvas, double w, double h, Material4Texture texture) {
    final fiberPaint = Paint()
      ..color = (texture.color ?? const Color(0xFF6B4423)).withValues(alpha: texture.opacity * 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final dotPaint = Paint()
      ..color = (texture.color ?? const Color(0xFF3E2723)).withValues(alpha: texture.opacity * 0.6)
      ..style = PaintingStyle.fill;

    // Fixed deterministic pseudo-random seeds
    for (int i = 0; i < (w * h * 0.0015 * texture.density).toInt(); i++) {
      final x = ((i * 137.5) % w);
      final y = ((i * 269.3) % h);
      final len = (i % 5) + 3.0;
      final angle = (i * 0.7);
      canvas.drawLine(
        Offset(x, y),
        Offset(x + len * math.cos(angle), y + len * math.sin(angle)),
        fiberPaint,
      );
      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), 0.75, dotPaint);
      }
    }
  }

  static void _renderNoiseGrain(Canvas canvas, double w, double h, Material4Texture texture, double anim) {
    final paint = Paint()
      ..color = (texture.color ?? Colors.black).withValues(alpha: texture.opacity)
      ..style = PaintingStyle.fill;

    final step = 4.0 / texture.density.clamp(0.5, 3.0);
    final shift = texture.animated ? (anim * 100) : 0.0;

    for (double y = 0; y < h; y += step) {
      for (double x = 0; x < w; x += step) {
        final v = math.sin((x + shift) * 12.9898 + (y + shift) * 78.233);
        if (v > 0.45) {
          canvas.drawRect(Rect.fromLTWH(x, y, 1.2, 1.2), paint);
        }
      }
    }
  }

  static void _renderMarble(Canvas canvas, double w, double h, Material4Texture texture, double anim) {
    final paint = Paint()
      ..color = (texture.color ?? const Color(0xFF1E293B)).withValues(alpha: texture.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final phase = texture.animated ? anim * 2 * math.pi : 0.0;
    final path = Path();

    for (double y = -h * 0.2; y < h * 1.2; y += 40.0 * texture.scale) {
      path.moveTo(0, y);
      for (double x = 0; x < w; x += 15) {
        final ny = y + math.sin((x * 0.02) + phase) * 20.0 + math.cos(x * 0.05) * 8.0;
        path.lineTo(x, ny);
      }
    }
    canvas.drawPath(path, paint);
  }

  static void _renderWoodGrain(Canvas canvas, double w, double h, Material4Texture texture) {
    final paint = Paint()
      ..color = (texture.color ?? const Color(0xFF78350F)).withValues(alpha: texture.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (double r = 10; r < math.max(w, h) * 1.5; r += 12 * texture.scale) {
      final rect = Rect.fromCenter(center: Offset(w * 0.2, h * 0.5), width: r * 2.5, height: r);
      canvas.drawOval(rect, paint);
    }
  }

  static void _renderMesh(Canvas canvas, double w, double h, Material4Texture texture) {
    final dotPaint = Paint()
      ..color = (texture.color ?? Colors.black).withValues(alpha: texture.opacity)
      ..style = PaintingStyle.fill;

    final spacing = 12.0 * texture.scale;
    final r = 1.8 * texture.scale;

    for (double y = spacing / 2; y < h; y += spacing) {
      final isOffset = ((y / spacing).floor() % 2) != 0;
      for (double x = isOffset ? spacing : spacing / 2; x < w; x += spacing) {
        canvas.drawCircle(Offset(x, y), r, dotPaint);
      }
    }
  }

  static void _renderHolographic(Canvas canvas, double w, double h, Material4Texture texture, double anim) {
    final phase = texture.animated ? anim : 0.0;
    final gradient = LinearGradient(
      begin: Alignment(-1.0 + phase * 2, -1.0),
      end: Alignment(1.0 + phase * 2, 1.0),
      colors: [
        const Color(0xFFFF007F).withValues(alpha: texture.opacity * 0.7),
        const Color(0xFF00E5FF).withValues(alpha: texture.opacity * 0.7),
        const Color(0xFF76FF03).withValues(alpha: texture.opacity * 0.7),
        const Color(0xFFFFD600).withValues(alpha: texture.opacity * 0.7),
        const Color(0xFFFF007F).withValues(alpha: texture.opacity * 0.7),
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
  }

  static void _renderFabric(Canvas canvas, double w, double h, Material4Texture texture) {
    final paint = Paint()
      ..color = (texture.color ?? Colors.black).withValues(alpha: texture.opacity * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final step = 5.0 * texture.scale;
    for (double x = 0; x < w; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), paint);
    }
    for (double y = 0; y < h; y += step) {
      canvas.drawLine(Offset(0, y), Offset(w, y), paint);
    }
  }

  static void _renderStone(Canvas canvas, double w, double h, Material4Texture texture) {
    final paintDark = Paint()
      ..color = (texture.color ?? Colors.black).withValues(alpha: texture.opacity)
      ..style = PaintingStyle.fill;
    final paintLight = Paint()
      ..color = Colors.white.withValues(alpha: texture.opacity * 0.5)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < (w * h * 0.001 * texture.density).toInt(); i++) {
      final x = ((i * 179.3) % w);
      final y = ((i * 311.7) % h);
      final r = (i % 3 == 0) ? 1.6 : 0.9;
      canvas.drawCircle(Offset(x, y), r, (i % 2 == 0) ? paintDark : paintLight);
    }
  }

  static void _renderLeather(Canvas canvas, double w, double h, Material4Texture texture) {
    final cellPaint = Paint()
      ..color = (texture.color ?? Colors.black).withValues(alpha: texture.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cell = 10.0 * texture.scale;
    for (double y = 0; y < h; y += cell) {
      for (double x = 0; x < w; x += cell) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(x + 1, y + 1, cell - 2, cell - 2), const Radius.circular(3)),
          cellPaint,
        );
      }
    }
  }

  static void _renderSoftMatte(Canvas canvas, double w, double h, Material4Texture texture) {
    final paint = Paint()
      ..color = (texture.color ?? Colors.white).withValues(alpha: texture.opacity * 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
  }

  static void _renderMetallicFoil(Canvas canvas, double w, double h, Material4Texture texture, double anim) {
    final offset = texture.animated ? anim * w : 0.0;
    final gradient = LinearGradient(
      colors: [
        Colors.transparent,
        (texture.color ?? Colors.amber).withValues(alpha: texture.opacity),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(offset - w, 0, w * 2, h))
      ..blendMode = BlendMode.screen;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
  }

  static void _renderLiquidTexture(Canvas canvas, double w, double h, Material4Texture texture, double anim) {
    final phase = texture.animated ? anim * 2 * math.pi : 0.0;
    final paint = Paint()
      ..color = (texture.color ?? Colors.cyan).withValues(alpha: texture.opacity)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final cx = (w * 0.2 * i + phase * 20) % w;
      final cy = (h * 0.15 * i + math.sin(phase + i) * 20) % h;
      canvas.drawCircle(Offset(cx, cy), 18.0 * texture.scale, paint);
    }
  }

  static void _renderDottedTexture(Canvas canvas, double w, double h, Material4Texture texture) {
    final paint = Paint()
      ..color = (texture.color ?? Colors.white).withValues(alpha: texture.opacity)
      ..style = PaintingStyle.fill;
    final step = 10.0 * texture.scale;
    for (double y = step / 2; y < h; y += step) {
      for (double x = step / 2; x < w; x += step) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  static void _renderGradientNoise(Canvas canvas, double w, double h, Material4Texture texture, double anim) {
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        (texture.color ?? Colors.purple).withValues(alpha: texture.opacity),
        Colors.transparent,
      ],
    );
    final paint = Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
  }
}
