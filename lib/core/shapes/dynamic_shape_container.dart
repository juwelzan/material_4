import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'dynamic_shape_config.dart';
import 'dynamic_shape_path_builder.dart';
import 'shape_background_renderer.dart';
import 'shape_border_painter.dart';
import 'shape_pattern.dart';

/// CustomClipper that clips any child widget to the exact contour
/// of the configured dynamic shape.
class DynamicShapeClipper extends CustomClipper<Path> {
  final DynamicShapeConfig config;

  const DynamicShapeClipper({required this.config});

  @override
  Path getClip(Size size) {
    return DynamicShapePathBuilder.buildPath(size, config);
  }

  @override
  bool shouldReclip(covariant DynamicShapeClipper oldClipper) {
    return oldClipper.config != config;
  }
}

/// CustomPainter that renders the background fill/gradient,
/// patterns, inner/inset shadows, shimmer sweep,
/// unique borders (dashed, dotted, double stroke, gradient, neo-3D, glow),
/// and soft drop shadows.
class DynamicShapePainter extends CustomPainter {
  final DynamicShapeConfig config;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;

  const DynamicShapePainter({
    required this.config,
    this.color,
    this.gradient,
    this.borderColor = const Color(0x18000000),
    this.borderWidth = 1.0,
    this.shadows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = DynamicShapePathBuilder.buildPath(size, config);

    // 1. Neo-Brutalism 3D Hard Offset Block
    if (config.borderStyle == BorderStyleType.neo3d) {
      final neoPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = config.neoColor;
      canvas.save();
      canvas.translate(config.neoOffset.dx, config.neoOffset.dy);
      canvas.drawPath(path, neoPaint);
      canvas.restore();
    }

    // 2. Soft Drop Shadows (if provided and not neo3d)
    if (config.borderStyle != BorderStyleType.neo3d &&
        shadows != null &&
        shadows!.isNotEmpty) {
      for (final shadow in shadows!) {
        final shadowPaint = Paint()
          ..color = shadow.color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius);
        canvas.save();
        canvas.translate(shadow.offset.dx, shadow.offset.dy);
        canvas.drawPath(path, shadowPaint);
        canvas.restore();
      }
    }

    // 3. Ambient Colored Glow Halo
    if (config.borderStyle == BorderStyleType.glow) {
      final glowColor = config.glowColor ?? borderColor;
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth * 2.5
        ..color = glowColor.withValues(alpha: 0.45)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, config.glowBlurRadius);
      canvas.drawPath(path, glowPaint);
    }

    // 4. Background Fill & Next-Gen Procedural Effects
    ShapeBackgroundRenderer.renderBackground(
      canvas: canvas,
      size: size,
      clipPath: path,
      config: config,
      baseColor: color,
      baseGradient: gradient,
    );

    // 5. Procedural Pattern Textures (Stripes, Dots, Grid, Waves)
    if (config.pattern != ShapePattern.none) {
      final patternColor =
          config.patternColor ??
          (color != null
              ? (color!.computeLuminance() > 0.5
                    ? Colors.black.withValues(alpha: 0.06)
                    : Colors.white.withValues(alpha: 0.12))
              : const Color(0x0F000000));

      ShapePatternRenderer.drawPattern(
        canvas: canvas,
        clipPath: path,
        size: size,
        pattern: config.pattern,
        color: patternColor,
        spacing: config.patternSpacing,
        strokeWidth: config.patternStrokeWidth,
      );
    }

    // 6. Tactile Inset Inner Shadow (Claymorphic / Sculpted Depth)
    if (config.innerShadows != null && config.innerShadows!.isNotEmpty) {
      for (final innerShadow in config.innerShadows!) {
        _drawInnerShadow(canvas, path, innerShadow, size);
      }
    }

    // 7. Holographic Shimmer Light Sweep
    if (config.isShimmering) {
      _drawShimmer(canvas, path, size, config.shimmerProgress);
    }

    // 8. Unique Border Rendering based on BorderStyleType
    _drawUniqueBorder(canvas, size, path);
  }

  void _drawInnerShadow(
    Canvas canvas,
    Path path,
    BoxShadow innerShadow,
    Size size,
  ) {
    final shadowRect = (Offset.zero & size).inflate(innerShadow.blurRadius * 2);
    final shadowPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(shadowRect)
      ..addPath(path, Offset.zero);

    final shadowPaint = Paint()
      ..color = innerShadow.color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, innerShadow.blurRadius);

    canvas.save();
    canvas.clipPath(path);
    canvas.translate(innerShadow.offset.dx, innerShadow.offset.dy);
    canvas.drawPath(shadowPath, shadowPaint);
    canvas.restore();
  }

  void _drawShimmer(Canvas canvas, Path path, Size size, double progress) {
    canvas.save();
    canvas.clipPath(path);

    final sweepSpan = size.width * 2.0;
    final sweepX = -size.width + sweepSpan * progress;
    final shimmerGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: 0.0),
        Colors.white.withValues(alpha: 0.35),
        Colors.white.withValues(alpha: 0.0),
      ],
      stops: const [0.35, 0.5, 0.65],
    );

    final shimmerPaint = Paint()
      ..shader = shimmerGradient.createShader(
        Rect.fromLTWH(sweepX, 0, size.width, size.height),
      );

    canvas.drawRect(Offset.zero & size, shimmerPaint);
    canvas.restore();
  }

  void _drawUniqueBorder(Canvas canvas, Size size, Path path) {
    ShapeBorderPainter.paintBorder(
      canvas: canvas,
      size: size,
      path: path,
      config: config,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }

  @override
  bool shouldRepaint(covariant DynamicShapePainter oldDelegate) {
    return oldDelegate.config != config ||
        oldDelegate.color != color ||
        oldDelegate.gradient != gradient ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.shadows != shadows;
  }
}

/// A universal, modular shape container widget that dynamically transforms
/// its geometry, patterns, frosted glassmorphism, inner shadows, and border styling.
class DynamicShapeContainer extends StatelessWidget {
  final Widget? child;
  final DynamicShapeConfig config;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  /// Optional accessory/badge to dock into the notch or tab
  final Widget? dockedBadge;
  final Alignment badgeAlignment;
  final EdgeInsets badgePadding;

  const DynamicShapeContainer({
    super.key,
    this.config = const DynamicShapeConfig(),
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderColor = const Color(0x1F1A1A1A),
    this.borderWidth = 1.0,
    this.shadows = const [
      BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 4)),
    ],
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
    this.dockedBadge,
    this.badgeAlignment = Alignment.topRight,
    this.badgePadding = EdgeInsets.zero,
  });

  /// Factory for Frosted Glassmorphism Container with dynamic path clipping
  factory DynamicShapeContainer.glass({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double glassBlur = 16.0,
    Color glassTint = const Color(0x28FFFFFF),
    Color borderColor = const Color(0x40FFFFFF),
    double borderWidth = 1.2,
    VoidCallback? onTap,
    Widget? dockedBadge,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(
        isGlassmorphic: true,
        glassBlur: glassBlur,
        glassTint: glassTint,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: glassTint,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      dockedBadge: dockedBadge,
      child: child,
    );
  }

  /// Factory for Patterned Container (stripes, dots, grid, waves)
  factory DynamicShapeContainer.patterned({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    ShapePattern pattern = ShapePattern.dotsMatrix,
    Color? patternColor,
    double patternSpacing = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(
        pattern: pattern,
        patternColor: patternColor,
        patternSpacing: patternSpacing,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Sculpted Claymorphic Container with Inset Inner Shadow
  factory DynamicShapeContainer.innerShadow({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    List<BoxShadow> innerShadows = const [
      BoxShadow(color: Color(0x18000000), blurRadius: 8, offset: Offset(2, 3)),
      BoxShadow(
        color: Color(0x44FFFFFF),
        blurRadius: 6,
        offset: Offset(-2, -2),
      ),
    ],
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(innerShadows: innerShadows),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Luminous Pulsing Neon Bloom Border
  factory DynamicShapeContainer.neon({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color neonColor = const Color(0xFF00E5FF),
    double borderWidth = 2.0,
    double pulseIntensity = 1.0,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.neonPulse,
        neonPulseIntensity: pulseIntensity,
        neonGlowColor: neonColor,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: neonColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Specular Reflective Metallic Border
  factory DynamicShapeContainer.metallic({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    MetallicType metallicType = MetallicType.gold,
    double borderWidth = 2.0,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.metallic,
        metallicType: metallicType,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: const Color(0xFFFFD54F),
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Chromatic Dispersion Rainbow Border
  factory DynamicShapeContainer.rainbow({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double borderWidth = 2.0,
    double progress = 0.0,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.rainbow,
        borderProgress: progress,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: const Color(0xFFFF3B30),
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Multi-Layered Concentric Border Stack
  factory DynamicShapeContainer.multiLayer({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    required List<BorderLayer> layers,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.multiLayer,
        multiLayerBorders: layers,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: layers.isNotEmpty
          ? layers.first.color
          : const Color(0xFF000000),
      borderWidth: layers.isNotEmpty ? layers.first.width : 1.5,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Technical Corner Framing Brackets
  factory DynamicShapeContainer.cornerOnly({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color borderColor = const Color(0xFF1E1E24),
    double borderWidth = 2.0,
    double cornerLength = 24.0,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.cornerOnly,
        cornerBorderLength: cornerLength,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Artisanal Hand-Drawn Sketchy Border
  factory DynamicShapeContainer.handDrawn({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Color borderColor = const Color(0xFF1E1E24),
    double borderWidth = 1.5,
    double roughness = 1.6,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.handDrawn,
        handDrawnRoughness: roughness,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Folder Tab Container (e.g. Marks Entry)
  factory DynamicShapeContainer.folderTab({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    ShapePattern pattern = ShapePattern.none,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    ShapeAnchor anchor = ShapeAnchor.topRight,
    double cornerRadius = 22.0,
    double tabWidth = 72.0,
    double tabHeight = 16.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.folderTab(
        anchor: anchor,
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        tabWidth: tabWidth,
        tabHeight: tabHeight,
        pattern: pattern,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Inward Notched Container (e.g. Today's Timetable with docked badge)
  factory DynamicShapeContainer.notchedBadge({
    Key? key,
    Widget? child,
    Widget? dockedBadge,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    ShapeAnchor anchor = ShapeAnchor.topRight,
    double cornerRadius = 24.0,
    double notchWidth = 92.0,
    double notchHeight = 26.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.notchedBadge(
        anchor: anchor,
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        notchWidth: notchWidth,
        notchHeight: notchHeight,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      dockedBadge: dockedBadge,
      badgeAlignment: anchor == ShapeAnchor.topRight
          ? Alignment.topRight
          : (anchor == ShapeAnchor.bottomRight
                ? Alignment.bottomRight
                : Alignment.topLeft),
      child: child,
    );
  }

  /// Factory for Side Tab / Protruding Bubble Container (e.g. Notice Board)
  factory DynamicShapeContainer.sideTab({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double protrusionDepth = 16.0,
    double tabHeight = 44.0,
    double cornerRadius = 22.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.sideTab(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        tabWidth: protrusionDepth,
        tabHeight: tabHeight,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Stepped Corner Container (e.g. Take Attendance or Daily Register)
  factory DynamicShapeContainer.steppedCorner({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    ShapeAnchor anchor = ShapeAnchor.bottomRight,
    double stepWidth = 48.0,
    double stepHeight = 42.0,
    double cornerRadius = 22.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.steppedCorner(
        anchor: anchor,
        borderStyle: borderStyle,
        stepWidth: stepWidth,
        stepHeight: stepHeight,
        cornerRadius: cornerRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Ticket Scallop Container (e.g. Pending Marks)
  factory DynamicShapeContainer.ticket({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    ShapePattern pattern = ShapePattern.none,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double cornerRadius = 22.0,
    double scallopRadius = 10.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.ticketScallop(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        scallopRadius: scallopRadius,
        pattern: pattern,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Postage Stamp with serrated perforated border
  factory DynamicShapeContainer.postageStamp({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double cornerRadius = 18.0,
    double scallopRadius = 6.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.postageStamp(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
        scallopRadius: scallopRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Zigzag Receipt cut container (great for vouchers, payment tokens)
  factory DynamicShapeContainer.zigzagReceipt({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.dashed,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double toothWidth = 14.0,
    double toothHeight = 8.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.zigzagCut(
        borderStyle: borderStyle,
        toothWidth: toothWidth,
        toothHeight: toothHeight,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Cathedral Arch / Dome Top Container
  factory DynamicShapeContainer.arch({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double cornerRadius = 24.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.arch(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Soft Hexagon Badge Container
  factory DynamicShapeContainer.hexagon({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double cornerRadius = 14.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.hexagonSoft(
        borderStyle: borderStyle,
        cornerRadius: cornerRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Diagonal Chamfer Ribbon Corner Container
  factory DynamicShapeContainer.chamferDiagonal({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    ShapeAnchor anchor = ShapeAnchor.topRight,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    double chamferSize = 36.0,
    double cornerRadius = 20.0,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.chamferDiagonal(
        anchor: anchor,
        borderStyle: borderStyle,
        chamferSize: chamferSize,
        cornerRadius: cornerRadius,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Organic Asymmetric Fluid Blob Container
  factory DynamicShapeContainer.organicBlob({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.organicBlob(borderStyle: borderStyle),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Scalloped Petal / Flower (e.g. Profile Avatar)
  factory DynamicShapeContainer.scallopedPetal({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
    int petalCount = 10,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.scallopedPetal(
        borderStyle: borderStyle,
        petalCount: petalCount,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Neo-Brutalist 3D Hard Offset Shadow Container
  factory DynamicShapeContainer.neo3d({
    Key? key,
    Widget? child,
    DynamicShapeConfig config = const DynamicShapeConfig(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0xFF1E1E24),
    double borderWidth = 1.8,
    Offset neoOffset = const Offset(4, 4),
    Color neoColor = const Color(0xFF1E1E24),
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: config.copyWith(
        borderStyle: BorderStyleType.neo3d,
        neoOffset: neoOffset,
        neoColor: neoColor,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Asymmetric Card Container
  factory DynamicShapeContainer.asymmetricCard({
    Key? key,
    Widget? child,
    CornerRadii cornerRadii = const CornerRadii.asymmetric(),
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.asymmetricCard(
        cornerRadii: cornerRadii,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Capsule / Pill Container
  factory DynamicShapeContainer.capsule({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.capsule(borderStyle: borderStyle),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Wave Edge Container
  factory DynamicShapeContainer.waveEdge({
    Key? key,
    Widget? child,
    ShapeAnchor anchor = ShapeAnchor.bottomCenter,
    double waveCount = 3.0,
    double waveAmplitude = 10.0,
    double cornerRadius = 20.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.waveEdge(
        anchor: anchor,
        waveCount: waveCount,
        waveAmplitude: waveAmplitude,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Cloud Shape Container
  factory DynamicShapeContainer.cloud({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.cloud(borderStyle: borderStyle),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Speech Bubble Container
  factory DynamicShapeContainer.speechBubble({
    Key? key,
    Widget? child,
    ShapeAnchor anchor = ShapeAnchor.bottomLeft,
    double tailWidth = 18.0,
    double tailHeight = 14.0,
    double cornerRadius = 22.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.speechBubble(
        anchor: anchor,
        tailWidth: tailWidth,
        tailHeight: tailHeight,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Shield / Academic Crest Container
  factory DynamicShapeContainer.shield({
    Key? key,
    Widget? child,
    double cornerRadius = 20.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.shield(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Diamond Badge Container
  factory DynamicShapeContainer.diamond({
    Key? key,
    Widget? child,
    double cornerRadius = 14.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.diamond(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Regular 8-sided Octagon Container
  factory DynamicShapeContainer.octagon({
    Key? key,
    Widget? child,
    double cornerRadius = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.octagon(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Wave Cut Sliced Container
  factory DynamicShapeContainer.waveCut({
    Key? key,
    Widget? child,
    ShapeAnchor anchor = ShapeAnchor.bottomRight,
    double waveAmplitude = 16.0,
    double cornerRadius = 22.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.waveCut(
        anchor: anchor,
        waveAmplitude: waveAmplitude,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Concave Rounded Frame Container
  factory DynamicShapeContainer.concaveRounded({
    Key? key,
    Widget? child,
    double cornerRadius = 20.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.concaveRounded(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Convex Rounded Barrel Container
  factory DynamicShapeContainer.convexRounded({
    Key? key,
    Widget? child,
    double curvature = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.convexRounded(
        curvature: curvature,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Squircle (iOS super-ellipse) Container
  factory DynamicShapeContainer.squircle({
    Key? key,
    Widget? child,
    double cornerRadius = 32.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.squircle(
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Slanted Parallelogram Container
  factory DynamicShapeContainer.parallelogram({
    Key? key,
    Widget? child,
    double skewAngle = 14.0,
    double cornerRadius = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.parallelogram(
        skewAngle: skewAngle,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Banner Ribbon Container
  factory DynamicShapeContainer.ribbon({
    Key? key,
    Widget? child,
    double foldDepth = 20.0,
    double cornerRadius = 6.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.ribbon(
        foldDepth: foldDepth,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Hanging Bookmark Container
  factory DynamicShapeContainer.bookmark({
    Key? key,
    Widget? child,
    double notchDepth = 22.0,
    double cornerRadius = 16.0,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.bookmark(
        notchDepth: notchDepth,
        cornerRadius: cornerRadius,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  /// Factory for Custom Bézier Geometry Container
  factory DynamicShapeContainer.customBezier({
    Key? key,
    Widget? child,
    required Path Function(Size size) builder,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x1F1A1A1A),
    double borderWidth = 1.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return DynamicShapeContainer(
      key: key,
      config: DynamicShapeConfig.customBezier(
        builder: builder,
        borderStyle: borderStyle,
      ),
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      gradient: gradient,
      borderColor: borderColor,
      borderWidth: borderWidth,
      shadows: shadows,
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = child ?? const SizedBox.shrink();

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    // Clip child to exact dynamic shape path so ripples/images/glass don't bleed
    Widget clippedContent = ClipPath(
      clipper: DynamicShapeClipper(config: config),
      clipBehavior: clipBehavior,
      child: config.isGlassmorphic
          ? BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: config.glassBlur,
                sigmaY: config.glassBlur,
              ),
              child: content,
            )
          : content,
    );

    // If a docked badge is specified
    if (dockedBadge != null) {
      clippedContent = Stack(
        children: [
          clippedContent,
          Positioned.fill(
            child: Align(
              alignment: badgeAlignment,
              child: Padding(padding: badgePadding, child: dockedBadge!),
            ),
          ),
        ],
      );
    }

    // Outer painted container
    Widget paintedContainer = CustomPaint(
      painter: DynamicShapePainter(
        config: config,
        color: color,
        gradient: gradient,
        borderColor: borderColor,
        borderWidth: borderWidth,
        shadows: shadows,
      ),
      child: SizedBox(width: width, height: height, child: clippedContent),
    );

    if (onTap != null) {
      paintedContainer = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: paintedContainer,
      );
    }

    if (margin != null) {
      paintedContainer = Padding(padding: margin!, child: paintedContainer);
    }

    return paintedContainer;
  }
}
