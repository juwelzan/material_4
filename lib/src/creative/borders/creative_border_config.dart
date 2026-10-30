import 'package:flutter/material.dart';

import '../../dynamic_shape_config.dart';

/// Available creative border rendering styles.
enum CreativeBorderStyle {
  // --- Paper & Physical Material Borders ---
  /// Realistic irregular ripped paper boundary with fiber strands and depth shadows.
  tornPaper,

  /// Naturally uneven paper boundary with subtle organic micro-variations.
  roughPaper,

  /// Perforated paper border like a tear-off ticket or coupon with periodic bridge links.
  perforated,

  /// Repeated sharp triangular sawtooth cuts along the boundary.
  zigzagCut,

  /// Irregular handmade cutting appearance with subtle angled facets.
  scissorCut,

  /// Traditional artisanal deckled edge with feathered ragged paper fibers.
  deckledEdge,

  /// Visually charred, burned paper boundary with dark toasted scorch gradient and ember glow.
  burntEdge,

  /// Folded paper border with 3D crease highlights and corner fold lines.
  foldedPaper,

  /// Crumpled paper boundary with subtle multi-facet irregular silhouette.
  crumpledEdge,

  /// Notebook paper with spiral binder or punched sheet perforations.
  notebookEdge,

  /// Postage stamp border with continuous circular cutout perforations.
  stampEdge,

  /// Detachable coupon border with dashed tear guideline and corner notch cuts.
  couponEdge,

  // --- Decorative and Geometric Borders ---
  /// Double concentric parallel lines.
  doubleLine,

  /// Triple concentric framing lines with weighted center stroke.
  tripleLine,

  /// Smooth multi-stop linear or sweep gradient stroke.
  gradient,

  /// Full chromatic rainbow spectrum dispersion stroke.
  rainbow,

  /// Ambient colored outer glow halo contouring the path.
  glow,

  /// High-specular neon gas tube with multi-stage bloom emission.
  neon,

  /// Dashed border with smooth rounded caps on each dash segment.
  dashedRounded,

  /// Discrete spherical bead or circular dot matrix along the contour.
  dottedRounded,

  /// Realistic threaded sewing stitch with angled threads and needle holes.
  stitch,

  /// Twisted nautical rope cord with helical braided strand shading.
  rope,

  /// Interlocking metallic oval chain links.
  chain,

  /// Elegant pearl or gemstone beaded necklace border.
  beaded,

  /// Smooth sinusoidal fluid wave ribbon stroke.
  wave,

  /// Continuous circular or arched scallop petal border.
  scalloped,

  /// Expressive artisan hand-drawn wavy contour with harmonic pen jitter.
  wavyHandDrawn,

  /// Fluid undulating organic blob border with variable line thickness.
  organicBlob,

  /// Modern faceted geometric polygonal border.
  geometricPolygon,

  /// 1920s Art Deco architectural stepped chevron and geometric line motifs.
  artDeco,

  /// Vintage ornamental filigree corner flourishes and baroque accents.
  vintageDecorative,

  /// Botanical vine, leaf, and floral petal decorative border.
  floralDecorative,

  /// Technical framing brackets placed strictly at shape corners.
  cornerOnly,

  /// Technical blueprint viewfinder bracket style with precision crosshairs.
  bracket,

  /// Chiseled recessed border pressed into the surface with inner shadow.
  inset,

  /// Beveled raised border projecting out from the surface with top highlight.
  outset,

  /// Composite layered multi-tier border stack.
  layered,

  /// Smooth moving marquee or pulsing phase animated border.
  animated,
}

/// Independent configuration for which edges display creative border treatments.
class BorderEdges {
  final bool top;
  final bool right;
  final bool bottom;
  final bool left;

  const BorderEdges({
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.left = true,
  });

  /// All four edges enabled.
  static const all = BorderEdges();

  /// None of the edges enabled.
  static const none =
      BorderEdges(top: false, right: false, bottom: false, left: false);

  /// Only horizontal edges (top and bottom).
  static const horizontal = BorderEdges(left: false, right: false);

  /// Only vertical edges (left and right).
  static const vertical = BorderEdges(top: false, bottom: false);

  /// Only top edge enabled.
  static const topOnly = BorderEdges(right: false, bottom: false, left: false);

  /// Only bottom edge enabled.
  static const bottomOnly = BorderEdges(top: false, right: false, left: false);

  /// Only left edge enabled.
  static const leftOnly = BorderEdges(top: false, right: false, bottom: false);

  /// Only right edge enabled.
  static const rightOnly = BorderEdges(top: false, bottom: false, left: false);

  bool get hasAny => top || right || bottom || left;
  bool get isAll => top && right && bottom && left;

  BorderEdges copyWith({
    bool? top,
    bool? right,
    bool? bottom,
    bool? left,
  }) {
    return BorderEdges(
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorderEdges &&
          runtimeType == other.runtimeType &&
          top == other.top &&
          right == other.right &&
          bottom == other.bottom &&
          left == other.left;

  @override
  int get hashCode => Object.hash(top, right, bottom, left);
}

/// Comprehensive configuration for the Advanced Creative Border Engine.
class CreativeBorderConfig {
  /// The visual border style.
  final CreativeBorderStyle style;

  /// Selection of which edges receive the creative treatment.
  final BorderEdges edges;

  /// Base stroke width or border height.
  final double width;

  /// Primary border color.
  final Color color;

  /// Secondary color (used for stitch thread, rope shadows, burnt embers, dual lines).
  final Color? secondaryColor;

  /// Optional gradient for gradient, rainbow, or shaded borders.
  final Gradient? gradient;

  /// Tear intensity for torn, deckled, and rough paper borders (0.0 = subtle, 1.0 = deep).
  final double tearIntensity;

  /// Frequency / density of tears, waves, scallops, or stitches.
  final double frequency;

  /// Deterministic integer seed for reproducible procedural geometries.
  final int seed;

  /// Whether to render delicate microscopic paper fiber strands along torn/deckled edges.
  final bool paperFiberDetails;

  /// Fiber density (0.0 to 1.0).
  final double fiberDensity;

  /// Color for paper fiber strands.
  final Color? fiberColor;

  /// Whether to render a depth drop shadow beneath torn/cut edges.
  final bool tearShadow;

  /// Blur radius of the torn edge drop shadow.
  final double tearShadowBlur;

  /// Color of the torn edge drop shadow.
  final Color? tearShadowColor;

  /// Charred burnt edge color (defaults to dark umber / charcoal).
  final Color? charColor;

  /// Spacing between repeating elements (dots, stitches, stamps, beads).
  final double spacing;

  /// Size of repeating pattern units (stamp perforation diameter, scallop radius, bead size).
  final double patternSize;

  /// Corner radius for geometric framing borders.
  final double cornerRadius;

  /// Opacity multiplier (0.0 to 1.0).
  final double opacity;

  /// Stroke alignment relative to the boundary contour.
  final ShapeStrokeAlign strokeAlign;

  /// Animation phase progress (0.0 to 1.0) for animated/marquee borders.
  final double animationProgress;

  /// Optional outer shadow for the border.
  final BoxShadow? shadow;

  const CreativeBorderConfig({
    this.style = CreativeBorderStyle.tornPaper,
    this.edges = BorderEdges.all,
    this.width = 4.0,
    this.color = const Color(0xFF6B5B4D),
    this.secondaryColor,
    this.gradient,
    this.tearIntensity = 0.5,
    this.frequency = 12.0,
    this.seed = 42,
    this.paperFiberDetails = true,
    this.fiberDensity = 0.6,
    this.fiberColor,
    this.tearShadow = true,
    this.tearShadowBlur = 3.0,
    this.tearShadowColor,
    this.charColor,
    this.spacing = 10.0,
    this.patternSize = 8.0,
    this.cornerRadius = 8.0,
    this.opacity = 1.0,
    this.strokeAlign = ShapeStrokeAlign.center,
    this.animationProgress = 0.0,
    this.shadow,
  });

  /// Factory preset: Realistic Torn Paper Border.
  factory CreativeBorderConfig.tornPaper({
    BorderEdges edges = BorderEdges.all,
    double width = 6.0,
    Color color = const Color(0xFFF3EEE6),
    double tearIntensity = 0.6,
    double frequency = 14.0,
    int seed = 42,
    bool paperFiberDetails = true,
    bool tearShadow = true,
  }) {
    return CreativeBorderConfig(
      style: CreativeBorderStyle.tornPaper,
      edges: edges,
      width: width,
      color: color,
      tearIntensity: tearIntensity,
      frequency: frequency,
      seed: seed,
      paperFiberDetails: paperFiberDetails,
      tearShadow: tearShadow,
    );
  }

  /// Factory preset: Postage Stamp Perforations.
  factory CreativeBorderConfig.stamp({
    Color color = const Color(0xFFE0DDD5),
    double patternSize = 8.0,
    double spacing = 12.0,
    BorderEdges edges = BorderEdges.all,
  }) {
    return CreativeBorderConfig(
      style: CreativeBorderStyle.stampEdge,
      edges: edges,
      width: patternSize * 0.5,
      color: color,
      patternSize: patternSize,
      spacing: spacing,
    );
  }

  /// Factory preset: Burnt Paper Charred Boundary.
  factory CreativeBorderConfig.burntEdge({
    BorderEdges edges = BorderEdges.all,
    double tearIntensity = 0.5,
    int seed = 101,
  }) {
    return CreativeBorderConfig(
      style: CreativeBorderStyle.burntEdge,
      edges: edges,
      width: 6.0,
      color: const Color(0xFF2C1E14),
      charColor: const Color(0xFF150D08),
      secondaryColor: const Color(0xFFD4691B),
      tearIntensity: tearIntensity,
      seed: seed,
    );
  }

  /// Factory preset: Artisanal Hand-Stitched Border.
  factory CreativeBorderConfig.stitch({
    Color color = const Color(0xFF4A6572),
    Color? secondaryColor = const Color(0xFF232F34),
    double width = 2.0,
    double spacing = 8.0,
    double patternSize = 6.0,
  }) {
    return CreativeBorderConfig(
      style: CreativeBorderStyle.stitch,
      width: width,
      color: color,
      secondaryColor: secondaryColor,
      spacing: spacing,
      patternSize: patternSize,
    );
  }

  /// Factory preset: Luminous Neon Border.
  factory CreativeBorderConfig.neon({
    Color color = const Color(0xFF00FFCC),
    double width = 3.0,
    double animationProgress = 0.0,
  }) {
    return CreativeBorderConfig(
      style: CreativeBorderStyle.neon,
      width: width,
      color: color,
      secondaryColor: Colors.white,
      animationProgress: animationProgress,
    );
  }

  /// Factory preset: Double Line Frame.
  factory CreativeBorderConfig.doubleLine({
    Color color = const Color(0xFF333333),
    double width = 1.5,
    double spacing = 3.0,
  }) {
    return CreativeBorderConfig(
      style: CreativeBorderStyle.doubleLine,
      width: width,
      color: color,
      spacing: spacing,
    );
  }

  /// Factory preset: Art Deco Geometric Border.
  factory CreativeBorderConfig.artDeco({
    Color color = const Color(0xFFD4AF37),
    Color secondaryColor = const Color(0xFF2B2516),
    double width = 2.5,
  }) {
    return CreativeBorderConfig(
      style: CreativeBorderStyle.artDeco,
      width: width,
      color: color,
      secondaryColor: secondaryColor,
    );
  }

  CreativeBorderConfig copyWith({
    CreativeBorderStyle? style,
    BorderEdges? edges,
    double? width,
    Color? color,
    Color? secondaryColor,
    Gradient? gradient,
    double? tearIntensity,
    double? frequency,
    int? seed,
    bool? paperFiberDetails,
    double? fiberDensity,
    Color? fiberColor,
    bool? tearShadow,
    double? tearShadowBlur,
    Color? tearShadowColor,
    Color? charColor,
    double? spacing,
    double? patternSize,
    double? cornerRadius,
    double? opacity,
    ShapeStrokeAlign? strokeAlign,
    double? animationProgress,
    BoxShadow? shadow,
  }) {
    return CreativeBorderConfig(
      style: style ?? this.style,
      edges: edges ?? this.edges,
      width: width ?? this.width,
      color: color ?? this.color,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      gradient: gradient ?? this.gradient,
      tearIntensity: tearIntensity ?? this.tearIntensity,
      frequency: frequency ?? this.frequency,
      seed: seed ?? this.seed,
      paperFiberDetails: paperFiberDetails ?? this.paperFiberDetails,
      fiberDensity: fiberDensity ?? this.fiberDensity,
      fiberColor: fiberColor ?? this.fiberColor,
      tearShadow: tearShadow ?? this.tearShadow,
      tearShadowBlur: tearShadowBlur ?? this.tearShadowBlur,
      tearShadowColor: tearShadowColor ?? this.tearShadowColor,
      charColor: charColor ?? this.charColor,
      spacing: spacing ?? this.spacing,
      patternSize: patternSize ?? this.patternSize,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      opacity: opacity ?? this.opacity,
      strokeAlign: strokeAlign ?? this.strokeAlign,
      animationProgress: animationProgress ?? this.animationProgress,
      shadow: shadow ?? this.shadow,
    );
  }

  /// Linear interpolation between two [CreativeBorderConfig]s.
  static CreativeBorderConfig? lerp(
    CreativeBorderConfig? a,
    CreativeBorderConfig? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    if (t <= 0.0) return a;
    if (t >= 1.0) return b;

    return CreativeBorderConfig(
      style: t < 0.5 ? a.style : b.style,
      edges: t < 0.5 ? a.edges : b.edges,
      width: a.width + (b.width - a.width) * t,
      color: Color.lerp(a.color, b.color, t) ?? a.color,
      secondaryColor: Color.lerp(a.secondaryColor, b.secondaryColor, t),
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      tearIntensity: a.tearIntensity + (b.tearIntensity - a.tearIntensity) * t,
      frequency: a.frequency + (b.frequency - a.frequency) * t,
      seed: t < 0.5 ? a.seed : b.seed,
      paperFiberDetails: t < 0.5 ? a.paperFiberDetails : b.paperFiberDetails,
      fiberDensity: a.fiberDensity + (b.fiberDensity - a.fiberDensity) * t,
      fiberColor: Color.lerp(a.fiberColor, b.fiberColor, t),
      tearShadow: t < 0.5 ? a.tearShadow : b.tearShadow,
      tearShadowBlur:
          a.tearShadowBlur + (b.tearShadowBlur - a.tearShadowBlur) * t,
      tearShadowColor: Color.lerp(a.tearShadowColor, b.tearShadowColor, t),
      charColor: Color.lerp(a.charColor, b.charColor, t),
      spacing: a.spacing + (b.spacing - a.spacing) * t,
      patternSize: a.patternSize + (b.patternSize - a.patternSize) * t,
      cornerRadius: a.cornerRadius + (b.cornerRadius - a.cornerRadius) * t,
      opacity: a.opacity + (b.opacity - a.opacity) * t,
      strokeAlign: t < 0.5 ? a.strokeAlign : b.strokeAlign,
      animationProgress:
          a.animationProgress + (b.animationProgress - a.animationProgress) * t,
      shadow: BoxShadow.lerp(a.shadow, b.shadow, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreativeBorderConfig &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          edges == other.edges &&
          width == other.width &&
          color == other.color &&
          secondaryColor == other.secondaryColor &&
          gradient == other.gradient &&
          tearIntensity == other.tearIntensity &&
          frequency == other.frequency &&
          seed == other.seed &&
          paperFiberDetails == other.paperFiberDetails &&
          fiberDensity == other.fiberDensity &&
          fiberColor == other.fiberColor &&
          tearShadow == other.tearShadow &&
          tearShadowBlur == other.tearShadowBlur &&
          tearShadowColor == other.tearShadowColor &&
          charColor == other.charColor &&
          spacing == other.spacing &&
          patternSize == other.patternSize &&
          cornerRadius == other.cornerRadius &&
          opacity == other.opacity &&
          strokeAlign == other.strokeAlign &&
          animationProgress == other.animationProgress &&
          shadow == other.shadow;

  @override
  int get hashCode => Object.hashAll([
        style,
        edges,
        width,
        color,
        secondaryColor,
        gradient,
        tearIntensity,
        frequency,
        seed,
        paperFiberDetails,
        fiberDensity,
        fiberColor,
        tearShadow,
        tearShadowBlur,
        tearShadowColor,
        charColor,
        spacing,
        patternSize,
        cornerRadius,
        opacity,
        strokeAlign,
        animationProgress,
        shadow,
      ]);
}
