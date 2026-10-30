import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'paper_background_config.dart';

/// Next-Generation high-fidelity paper texture rendering engine.
///
/// Produces realistic physical stationery and craft paper materials natively
/// on Flutter Canvas through layered procedural physics:
/// 1. Base sheet cellulose tint and natural substrate color
/// 2. Ambient lighting and spectral shading gradient
/// 3. Tactile grain stipple and tooth depressions
/// 4. Embedded organic plant/cellulose fibers
/// 5. Material-specific tactile passes (canvas weave, watercolor tooth, origami folds, crumples)
/// 6. Aging spots and tea/water stains
/// 7. Perimeter edge darkening and patina vignette
class PaperTextureRenderer {
  const PaperTextureRenderer._();

  static double _hash(int n) {
    var x = n * 0x45d9f3b;
    x = ((x >> 16) ^ x) * 0x45d9f3b;
    x = (x >> 16) ^ x;
    return (x & 0x7fffffff) / 2147483648.0;
  }

  /// Default natural color palette for each paper preset.
  static Color getDefaultBaseColor(PaperBackgroundStyle style) {
    switch (style) {
      case PaperBackgroundStyle.plainWhite:
        return const Color(0xFFFCFCFB);
      case PaperBackgroundStyle.warmCream:
        return const Color(0xFFF9F4EB);
      case PaperBackgroundStyle.vintage:
        return const Color(0xFFF3E7CE);
      case PaperBackgroundStyle.oldNewspaper:
        return const Color(0xFFECE4D0);
      case PaperBackgroundStyle.recycled:
        return const Color(0xFFE2DAC8);
      case PaperBackgroundStyle.handmade:
        return const Color(0xFFF6F0E4);
      case PaperBackgroundStyle.roughFiber:
        return const Color(0xFFE8DECB);
      case PaperBackgroundStyle.kraft:
        return const Color(0xFFD4B791);
      case PaperBackgroundStyle.watercolor:
        return const Color(0xFFFAF7F0);
      case PaperBackgroundStyle.canvas:
        return const Color(0xFFF5EFE1);
      case PaperBackgroundStyle.cardstock:
        return const Color(0xFFF7F5F0);
      case PaperBackgroundStyle.crumpled:
        return const Color(0xFFF2ECE0);
      case PaperBackgroundStyle.folded:
        return const Color(0xFFFAF5ED);
      case PaperBackgroundStyle.parchment:
        return const Color(0xFFEDE0C4);
      case PaperBackgroundStyle.rice:
        return const Color(0xFFFAF8F5);
      case PaperBackgroundStyle.softLinen:
        return const Color(0xFFF5EFE6);
      case PaperBackgroundStyle.notebook:
        return const Color(0xFFFAF9F5);
      case PaperBackgroundStyle.graph:
        return const Color(0xFFF4F7F9);
      case PaperBackgroundStyle.blueprint:
        return const Color(0xFF1B3A57);
      case PaperBackgroundStyle.stickyNote:
        return const Color(0xFFFFF9A6);
    }
  }

  /// Renders the complete paper background onto [canvas] clipped to [clipPath].
  static void renderPaperBackground({
    required Canvas canvas,
    required Size size,
    required Path clipPath,
    required PaperBackgroundConfig config,
  }) {
    if (size.width <= 0 || size.height <= 0) return;

    canvas.save();
    canvas.clipPath(clipPath);

    final baseColor = config.baseColor ?? getDefaultBaseColor(config.style);
    final isDark = baseColor.computeLuminance() < 0.3;

    // 1. Base Sheet Substrate Fill
    final fillPaint = Paint()..style = PaintingStyle.fill;
    if (config.backgroundGradient != null) {
      fillPaint.shader = config.backgroundGradient!.createShader(
        Offset.zero & size,
      );
      canvas.drawRect(Offset.zero & size, fillPaint);
    } else {
      fillPaint.color = baseColor;
      canvas.drawRect(Offset.zero & size, fillPaint);

      // Subtle ambient diagonal lighting gradient (top-left natural light)
      final lightShader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          (isDark ? Colors.white : Colors.white)
              .withValues(alpha: isDark ? 0.05 : 0.08),
          Colors.transparent,
          (isDark ? Colors.black : const Color(0xFF4A3B32)).withValues(
            alpha: isDark ? 0.12 : 0.04,
          ),
        ],
      ).createShader(Offset.zero & size);
      canvas.drawRect(Offset.zero & size, Paint()..shader = lightShader);
    }

    // 2. Microscopic Paper Tooth & Grain Stipple
    _renderPaperGrain(canvas, size, config, isDark);

    // 3. Embedded Organic Cellulose / Plant Fibers
    if (config.fiberDensity > 0.0) {
      _renderPaperFibers(canvas, size, config, isDark);
    }

    // 4. Material-Specific Physical Characteristics
    _renderMaterialPass(canvas, size, config, isDark);

    // 5. Crease Folds (if enabled or style is folded / crumpled)
    if (config.hasFolds ||
        config.style == PaperBackgroundStyle.folded ||
        config.style == PaperBackgroundStyle.crumpled) {
      _renderCreaseFolds(canvas, size, config, isDark);
    }

    // 6. Vintage Aging / Water / Tea Stains
    if (config.hasStains || config.style == PaperBackgroundStyle.vintage) {
      _renderAgingStains(canvas, size, config, isDark);
    }

    // 7. Perimeter Edge Patina & Vignette
    if (config.edgeVignette ||
        config.style == PaperBackgroundStyle.vintage ||
        config.style == PaperBackgroundStyle.oldNewspaper) {
      _renderEdgeVignette(canvas, size, config, isDark);
    }

    canvas.restore();
  }

  /// Procedural deterministic paper grain stipple.
  static void _renderPaperGrain(
    Canvas canvas,
    Size size,
    PaperBackgroundConfig config,
    bool isDark,
  ) {
    final grainPaint = Paint()..style = PaintingStyle.fill;
    final dotColor = isDark ? Colors.white : Colors.black;
    final grainOpacity = (config.grainOpacity * config.textureIntensity).clamp(
      0.01,
      0.4,
    );

    final step = math.max(6.0, 16.0 / (config.grainSize * 1.5));
    final radius = (config.grainSize * 0.4).clamp(0.4, 2.0);

    for (double y = 0; y < size.height; y += step) {
      final rowIndex = (y / step).toInt();
      for (double x = 0; x < size.width; x += step) {
        final colIndex = (x / step).toInt();
        final seed = config.seed + (rowIndex * 503) + (colIndex * 101);
        final rnd = _hash(seed);

        if (rnd > 0.4) {
          final alpha = (rnd * grainOpacity).clamp(0.0, 1.0);
          grainPaint.color = dotColor.withValues(alpha: alpha);
          final jitterX = (_hash(seed + 1) - 0.5) * (step * 0.6);
          final jitterY = (_hash(seed + 2) - 0.5) * (step * 0.6);
          canvas.drawCircle(
            Offset(x + jitterX, y + jitterY),
            radius,
            grainPaint,
          );
        }
      }
    }
  }

  /// Embedded natural fibers (wood pulp, kozo, cotton).
  static void _renderPaperFibers(
    Canvas canvas,
    Size size,
    PaperBackgroundConfig config,
    bool isDark,
  ) {
    final fiberColor = config.fiberColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.15)
            : const Color(0xFF6B533E).withValues(alpha: 0.22));

    final fiberPaint = Paint()
      ..color = fiberColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75
      ..strokeCap = StrokeCap.round;

    final fiberCount =
        ((size.width * size.height) / 3200.0 * config.fiberDensity)
            .toInt()
            .clamp(5, 120);

    for (int i = 0; i < fiberCount; i++) {
      final s = config.seed + (i * 97);
      final startX = _hash(s) * size.width;
      final startY = _hash(s + 1) * size.height;
      final length = 4.0 + (_hash(s + 2) * 12.0);
      final angle = _hash(s + 3) * math.pi * 2;
      final curvature = (_hash(s + 4) - 0.5) * 4.0;

      final p1 = Offset(startX, startY);
      final p2 = Offset(
        startX + math.cos(angle) * (length * 0.5) - math.sin(angle) * curvature,
        startY + math.sin(angle) * (length * 0.5) + math.cos(angle) * curvature,
      );
      final p3 = Offset(
        startX + math.cos(angle) * length,
        startY + math.sin(angle) * length,
      );

      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..quadraticBezierTo(p2.dx, p2.dy, p3.dx, p3.dy);
      canvas.drawPath(path, fiberPaint);
    }
  }

  /// Material-specific tactile passes.
  static void _renderMaterialPass(
    Canvas canvas,
    Size size,
    PaperBackgroundConfig config,
    bool isDark,
  ) {
    switch (config.style) {
      case PaperBackgroundStyle.canvas:
        _renderCanvasWeave(canvas, size, isDark);
        break;

      case PaperBackgroundStyle.watercolor:
        _renderWatercolorTooth(canvas, size, isDark);
        break;

      case PaperBackgroundStyle.stickyNote:
        _renderStickyNoteAdhesive(canvas, size);
        break;

      case PaperBackgroundStyle.blueprint:
        _renderBlueprintSubstrate(canvas, size);
        break;

      case PaperBackgroundStyle.recycled:
      case PaperBackgroundStyle.oldNewspaper:
        _renderCelluloseFlecks(canvas, size, config.seed, isDark);
        break;

      case PaperBackgroundStyle.rice:
        _renderWashiFibers(canvas, size, config.seed);
        break;

      case PaperBackgroundStyle.softLinen:
        _renderLinenThreads(canvas, size, isDark);
        break;

      default:
        break;
    }
  }

  /// Canvas orthogonal warp and weft weave.
  static void _renderCanvasWeave(Canvas canvas, Size size, bool isDark) {
    final lightPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.white).withValues(alpha: 0.12)
      ..strokeWidth = 1.0;
    final shadowPaint = Paint()
      ..color = (isDark ? Colors.black : const Color(0xFF6B5848))
          .withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    const spacing = 5.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), shadowPaint);
      canvas.drawLine(Offset(x + 1, 0), Offset(x + 1, size.height), lightPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), shadowPaint);
      canvas.drawLine(Offset(0, y + 1), Offset(size.width, y + 1), lightPaint);
    }
  }

  /// Watercolor cold-press pebbled tooth wells.
  static void _renderWatercolorTooth(Canvas canvas, Size size, bool isDark) {
    final toothPaint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF4A3F35))
          .withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    for (double y = 4; y < size.height; y += 8) {
      for (double x = 4; x < size.width; x += 8) {
        final seed = (y * 31 + x * 17).toInt();
        final r = 1.5 + _hash(seed) * 2.0;
        canvas.drawCircle(Offset(x, y), r, toothPaint);
      }
    }
  }

  /// Sticky note top adhesive strip band and bottom lift shadow.
  static void _renderStickyNoteAdhesive(Canvas canvas, Size size) {
    // Top adhesive strip band (subtly darker translucent strip)
    final stripHeight = math.min(28.0, size.height * 0.22);
    final stripShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withValues(alpha: 0.07),
        Colors.black.withValues(alpha: 0.02),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, stripHeight));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, stripHeight),
      Paint()..shader = stripShader,
    );

    // Bottom page curling depth shadow
    final curlShader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black.withValues(alpha: 0.08),
      ],
    ).createShader(Rect.fromLTWH(0, size.height - 12, size.width, 12));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - 12, size.width, 12),
      Paint()..shader = curlShader,
    );
  }

  /// Blueprint fine technical grid substrate.
  static void _renderBlueprintSubstrate(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF64B5F6).withValues(alpha: 0.14)
      ..strokeWidth = 0.5;

    const spacing = 12.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  /// Flecks of recycled plant pulp and ink particles.
  static void _renderCelluloseFlecks(
    Canvas canvas,
    Size size,
    int seed,
    bool isDark,
  ) {
    final fleckPaint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF4E3629))
          .withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    const count = 35;
    for (int i = 0; i < count; i++) {
      final s = seed + (i * 131);
      final x = _hash(s) * size.width;
      final y = _hash(s + 1) * size.height;
      final w = 1.0 + _hash(s + 2) * 2.5;
      final h = 1.0 + _hash(s + 3) * 1.8;
      canvas.drawRect(Rect.fromLTWH(x, y, w, h), fleckPaint);
    }
  }

  /// Delicate Japanese washi rice paper long fibers.
  static void _renderWashiFibers(Canvas canvas, Size size, int seed) {
    final fiberPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    const count = 18;
    for (int i = 0; i < count; i++) {
      final s = seed + (i * 223);
      final x1 = _hash(s) * size.width;
      final y1 = _hash(s + 1) * size.height;
      final x2 = x1 + (_hash(s + 2) - 0.5) * 60.0;
      final y2 = y1 + (_hash(s + 3) - 0.5) * 60.0;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), fiberPaint);
    }
  }

  /// Linen threads.
  static void _renderLinenThreads(Canvas canvas, Size size, bool isDark) {
    final threadPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04)
      ..strokeWidth = 0.8;

    for (double y = 0; y < size.height; y += 4.0) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), threadPaint);
    }
  }

  /// 3D origami/crease fold highlight and shadow lines.
  static void _renderCreaseFolds(
    Canvas canvas,
    Size size,
    PaperBackgroundConfig config,
    bool isDark,
  ) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.14)
      ..strokeWidth = 1.8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.2;

    // Center diagonal letter fold
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), shadowPaint);
    canvas.drawLine(const Offset(1, -1),
        Offset(size.width + 1, size.height - 1), highlightPaint);

    if (config.foldCount > 1) {
      // Horizontal trifold line
      final y = size.height * 0.33;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), shadowPaint);
      canvas.drawLine(
          Offset(0, y - 1), Offset(size.width, y - 1), highlightPaint);
    }
  }

  /// Vintage aging tea/water stains.
  static void _renderAgingStains(
    Canvas canvas,
    Size size,
    PaperBackgroundConfig config,
    bool isDark,
  ) {
    final stainColor = config.stainColor ?? const Color(0xFF7A583A);
    final count = config.stainCount.clamp(1, 4);

    for (int i = 0; i < count; i++) {
      final s = config.seed + (i * 389);
      final cx = _hash(s) * size.width;
      final cy = _hash(s + 1) * size.height;
      final r = 16.0 + _hash(s + 2) * 32.0;

      // Outer evaporation ring (darker perimeter where solute dried)
      final ringPaint = Paint()
        ..color = stainColor.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawCircle(Offset(cx, cy), r, ringPaint);

      // Inner faint wash
      final washPaint = Paint()
        ..color = stainColor.withValues(alpha: 0.05)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
      canvas.drawCircle(Offset(cx, cy), r * 0.85, washPaint);
    }
  }

  /// Perimeter edge patina & vignette.
  static void _renderEdgeVignette(
    Canvas canvas,
    Size size,
    PaperBackgroundConfig config,
    bool isDark,
  ) {
    final vignetteShader = RadialGradient(
      center: Alignment.center,
      radius: 0.85,
      colors: [
        Colors.transparent,
        (isDark ? Colors.black : const Color(0xFF533B26)).withValues(
          alpha: config.vignetteOpacity,
        ),
      ],
    ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, Paint()..shader = vignetteShader);
  }
}
