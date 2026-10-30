import 'package:flutter/material.dart';

/// Available paper-inspired tactile background material styles.
enum PaperBackgroundStyle {
  /// Clean, bright premium stationery paper with delicate micro-texture.
  plainWhite,

  /// Warm natural ivory / cream stationery stock with soft warm undertones.
  warmCream,

  /// Aged sepia antique paper with gentle patina and perimeter aging.
  vintage,

  /// Weathered, yellowed pulp newsprint with visible cellulose specks.
  oldNewspaper,

  /// Eco-friendly recycled craft paper with organic botanical flecks.
  recycled,

  /// Artisanal heavy cotton paper with uneven pulp distribution.
  handmade,

  /// Coarse organic paper with long, visible directional plant fibers.
  roughFiber,

  /// Heavyweight natural brown kraft wrapping paper.
  kraft,

  /// Heavy 300gsm cold-press watercolor paper with deep pebbled tooth.
  watercolor,

  /// Woven artist canvas with orthogonal warp and weft textured grain.
  canvas,

  /// Thick, dense matte cardstock with uniform microscopic grain.
  cardstock,

  /// Paper with realistic 3D geometric crumpled relief and shadow facets.
  crumpled,

  /// Letter/origami paper with crisp geometric fold crease highlights and shadows.
  folded,

  /// Historical translucent animal vellum/parchment with mottled clouding.
  parchment,

  /// Delicate Japanese washi rice paper with semi-translucent long fibers.
  rice,

  /// Luxury bookbinder linen stationery with woven tactile threads.
  softLinen,

  /// Classic school exercise notebook off-white pulp stock.
  notebook,

  /// Technical drafting paper stock with subtle cool grid substrate.
  graph,

  /// Cyanotype architectural blueprint paper in deep Prussian blue.
  blueprint,

  /// Vivid canary yellow (or pastel) sticky note paper with adhesive depth.
  stickyNote,
}

/// Notebook and stationery patterns.
enum StationeryPatternType {
  /// Horizontal ruled writing lines.
  horizontalRuled,

  /// Vertical ledger column lines.
  verticalRuled,

  /// Standard quad millimeter grid lines.
  gridLines,

  /// Bullet journal matrix dot grid.
  dotGrid,

  /// Major and minor subdivision engineering drafting graph.
  engineeringGraph,

  /// 60-degree triangular isometric drafting grid.
  isometricGrid,

  /// 5-line musical manuscript staves with measure gaps.
  musicManuscript,

  /// 3-line penmanship handwriting guide (baseline, midline, ascender).
  handwritingGuide,

  /// Vertical red/pink left margin rule with horizontal ruling.
  marginLine,

  /// Punched spiral binder holes along an edge.
  notebookSpiralHoles,

  /// Sewn book spine binding edge tape with stitching.
  notebookBindingEdge,

  /// Jagged perforated remnants of sheets torn from a spiral notebook.
  tornNotebookEdge,

  /// Delicate corner botanical filigree stationery watermark.
  decorativeStationery,
}

/// Creative repeating decorative patterns.
enum RepeatingPatternType {
  /// Classic uniform polka dots.
  polkaDots,

  /// Delicate miniature circular dots.
  smallCircles,

  /// 45-degree diagonal stripes.
  diagonalStripes,

  /// Clean horizontal stripes.
  horizontalStripes,

  /// Crisp vertical pin-stripes.
  verticalStripes,

  /// Orthogonal crosshatch diamond lines.
  crosshatch,

  /// Alternating checkerboard squares.
  checkerboard,

  /// Hexagonal beehive grid tiles.
  hexagonalGrid,

  /// Triangular tessellation grid.
  triangularGrid,

  /// Argyle/rhombus diamond pattern.
  diamondPattern,

  /// Sinusoidal wave ripples.
  wavePattern,

  /// Sharp sawtooth zigzag chevron stripes.
  zigzagPattern,

  /// Organic honeycomb hexagons with rounded cells.
  honeycomb,

  /// Concentric circular radar rings.
  concentricCircles,

  /// Mediterranean geometric ceramic tiles.
  geometricTiles,

  /// Minimal botanical leaf and flower motifs.
  minimalFloral,

  /// Fluid abstract amoeba organic shapes.
  abstractOrganic,

  /// Stochastic organic dots with natural biological scattering.
  randomOrganicDots,

  /// Joyful festive geometric confetti specks.
  confetti,

  /// Retro pop-art printing halftone dot matrix.
  halftone,

  /// Geological topographic elevation contour lines.
  topographicContour,
}

/// Configuration for realistic physical paper background rendering.
class PaperBackgroundConfig {
  /// The paper material style.
  final PaperBackgroundStyle style;

  /// Custom base tint color (overrides the preset's natural default).
  final Color? baseColor;

  /// Overall tactile texture intensity (0.0 = smooth, 1.0 = heavy tooth).
  final double textureIntensity;

  /// Microscopic paper grain particle size (0.5 to 4.0).
  final double grainSize;

  /// Opacity of the paper grain stipple (0.0 to 1.0).
  final double grainOpacity;

  /// Density of organic plant/cellulose fibers embedded in the sheet (0.0 to 1.0).
  final double fiberDensity;

  /// Color of embedded fibers.
  final Color? fiberColor;

  /// Optional subtle ambient gradient across the sheet.
  final Gradient? backgroundGradient;

  /// Fine procedural noise intensity (0.0 to 1.0).
  final double noiseIntensity;

  /// Whether to render organic aging spots or tea/coffee stains.
  final bool hasStains;

  /// Color of aging stains.
  final Color? stainColor;

  /// Number of aging stains (1 to 5).
  final int stainCount;

  /// Whether to render 3D crease fold relief lines.
  final bool hasFolds;

  /// Number of crease fold lines.
  final int foldCount;

  /// Whether to render edge darkening/vignette.
  final bool edgeVignette;

  /// Vignette darkness opacity (0.0 to 1.0).
  final double vignetteOpacity;

  /// Deterministic seed for reproducible procedural fiber and stain distribution.
  final int seed;

  const PaperBackgroundConfig({
    this.style = PaperBackgroundStyle.plainWhite,
    this.baseColor,
    this.textureIntensity = 0.5,
    this.grainSize = 1.2,
    this.grainOpacity = 0.08,
    this.fiberDensity = 0.2,
    this.fiberColor,
    this.backgroundGradient,
    this.noiseIntensity = 0.06,
    this.hasStains = false,
    this.stainColor,
    this.stainCount = 2,
    this.hasFolds = false,
    this.foldCount = 2,
    this.edgeVignette = false,
    this.vignetteOpacity = 0.15,
    this.seed = 42,
  });

  /// Factory preset: Vintage Parchment.
  factory PaperBackgroundConfig.vintage({
    Color? baseColor,
    bool hasStains = true,
    bool edgeVignette = true,
    int seed = 101,
  }) {
    return PaperBackgroundConfig(
      style: PaperBackgroundStyle.vintage,
      baseColor: baseColor ?? const Color(0xFFF4ECD8),
      textureIntensity: 0.7,
      grainOpacity: 0.12,
      fiberDensity: 0.4,
      hasStains: hasStains,
      stainColor: const Color(0xFF8D6E4F),
      edgeVignette: edgeVignette,
      vignetteOpacity: 0.22,
      seed: seed,
    );
  }

  /// Factory preset: Natural Brown Kraft Paper.
  factory PaperBackgroundConfig.kraft({
    Color? baseColor,
    double textureIntensity = 0.8,
    int seed = 88,
  }) {
    return PaperBackgroundConfig(
      style: PaperBackgroundStyle.kraft,
      baseColor: baseColor ?? const Color(0xFFD2B48C),
      textureIntensity: textureIntensity,
      grainSize: 1.5,
      grainOpacity: 0.16,
      fiberDensity: 0.6,
      fiberColor: const Color(0xFF8B5A2B),
      seed: seed,
    );
  }

  /// Factory preset: Sticky Note Paper.
  factory PaperBackgroundConfig.stickyNote({
    Color baseColor = const Color(0xFFFFF9A6),
    double textureIntensity = 0.3,
  }) {
    return PaperBackgroundConfig(
      style: PaperBackgroundStyle.stickyNote,
      baseColor: baseColor,
      textureIntensity: textureIntensity,
      grainOpacity: 0.05,
      fiberDensity: 0.05,
    );
  }

  /// Factory preset: Architectural Blueprint Paper.
  factory PaperBackgroundConfig.blueprint({
    Color baseColor = const Color(0xFF1A365D),
  }) {
    return PaperBackgroundConfig(
      style: PaperBackgroundStyle.blueprint,
      baseColor: baseColor,
      textureIntensity: 0.4,
      grainOpacity: 0.08,
      fiberDensity: 0.1,
    );
  }

  /// Factory preset: Cold-Press Watercolor Paper.
  factory PaperBackgroundConfig.watercolor({
    Color baseColor = const Color(0xFFF9F7F1),
  }) {
    return PaperBackgroundConfig(
      style: PaperBackgroundStyle.watercolor,
      baseColor: baseColor,
      textureIntensity: 0.85,
      grainSize: 2.0,
      grainOpacity: 0.14,
      fiberDensity: 0.3,
    );
  }

  PaperBackgroundConfig copyWith({
    PaperBackgroundStyle? style,
    Color? baseColor,
    double? textureIntensity,
    double? grainSize,
    double? grainOpacity,
    double? fiberDensity,
    Color? fiberColor,
    Gradient? backgroundGradient,
    double? noiseIntensity,
    bool? hasStains,
    Color? stainColor,
    int? stainCount,
    bool? hasFolds,
    int? foldCount,
    bool? edgeVignette,
    double? vignetteOpacity,
    int? seed,
  }) {
    return PaperBackgroundConfig(
      style: style ?? this.style,
      baseColor: baseColor ?? this.baseColor,
      textureIntensity: textureIntensity ?? this.textureIntensity,
      grainSize: grainSize ?? this.grainSize,
      grainOpacity: grainOpacity ?? this.grainOpacity,
      fiberDensity: fiberDensity ?? this.fiberDensity,
      fiberColor: fiberColor ?? this.fiberColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      noiseIntensity: noiseIntensity ?? this.noiseIntensity,
      hasStains: hasStains ?? this.hasStains,
      stainColor: stainColor ?? this.stainColor,
      stainCount: stainCount ?? this.stainCount,
      hasFolds: hasFolds ?? this.hasFolds,
      foldCount: foldCount ?? this.foldCount,
      edgeVignette: edgeVignette ?? this.edgeVignette,
      vignetteOpacity: vignetteOpacity ?? this.vignetteOpacity,
      seed: seed ?? this.seed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaperBackgroundConfig &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          baseColor == other.baseColor &&
          textureIntensity == other.textureIntensity &&
          grainSize == other.grainSize &&
          grainOpacity == other.grainOpacity &&
          fiberDensity == other.fiberDensity &&
          fiberColor == other.fiberColor &&
          backgroundGradient == other.backgroundGradient &&
          noiseIntensity == other.noiseIntensity &&
          hasStains == other.hasStains &&
          stainColor == other.stainColor &&
          stainCount == other.stainCount &&
          hasFolds == other.hasFolds &&
          foldCount == other.foldCount &&
          edgeVignette == other.edgeVignette &&
          vignetteOpacity == other.vignetteOpacity &&
          seed == other.seed;

  @override
  int get hashCode => Object.hashAll([
        style,
        baseColor,
        textureIntensity,
        grainSize,
        grainOpacity,
        fiberDensity,
        fiberColor,
        backgroundGradient,
        noiseIntensity,
        hasStains,
        stainColor,
        stainCount,
        hasFolds,
        foldCount,
        edgeVignette,
        vignetteOpacity,
        seed,
      ]);
}

/// Configuration for Stationery and Repeating patterns.
class CreativePatternConfig {
  /// Whether to use a stationery pattern.
  final StationeryPatternType? stationeryType;

  /// Whether to use a repeating pattern.
  final RepeatingPatternType? repeatingType;

  /// Primary pattern stroke / fill color.
  final Color color;

  /// Secondary color (e.g. for margin lines, engineering major grid, alternating tiles).
  final Color? secondaryColor;

  /// Spacing or unit cell size.
  final double spacing;

  /// Stroke width of lines or dots.
  final double strokeWidth;

  /// Scale multiplier (defaults to 1.0).
  final double scale;

  /// Rotation angle in radians.
  final double rotation;

  /// Linear 2D translation offset.
  final Offset offset;

  /// Opacity multiplier (0.0 to 1.0).
  final double opacity;

  const CreativePatternConfig({
    this.stationeryType,
    this.repeatingType,
    this.color = const Color(0x1F000000),
    this.secondaryColor,
    this.spacing = 20.0,
    this.strokeWidth = 1.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.offset = Offset.zero,
    this.opacity = 1.0,
  });

  /// Factory: Horizontal Notebook Ruling with red margin line.
  factory CreativePatternConfig.notebookRuling({
    Color lineColor = const Color(0x334A90E2),
    Color marginColor = const Color(0x66E94E77),
    double spacing = 24.0,
    double strokeWidth = 1.0,
  }) {
    return CreativePatternConfig(
      stationeryType: StationeryPatternType.marginLine,
      color: lineColor,
      secondaryColor: marginColor,
      spacing: spacing,
      strokeWidth: strokeWidth,
    );
  }

  /// Factory: Engineering Quad Graph.
  factory CreativePatternConfig.graphPaper({
    Color minorColor = const Color(0x1F2C5282),
    Color majorColor = const Color(0x3D2C5282),
    double spacing = 16.0,
  }) {
    return CreativePatternConfig(
      stationeryType: StationeryPatternType.engineeringGraph,
      color: minorColor,
      secondaryColor: majorColor,
      spacing: spacing,
    );
  }

  /// Factory: Dot Grid for bullet journals.
  factory CreativePatternConfig.dotGrid({
    Color color = const Color(0x33718096),
    double spacing = 16.0,
    double dotRadius = 1.2,
  }) {
    return CreativePatternConfig(
      stationeryType: StationeryPatternType.dotGrid,
      color: color,
      spacing: spacing,
      strokeWidth: dotRadius,
    );
  }

  /// Factory: Repeating Polka Dots.
  factory CreativePatternConfig.polkaDots({
    Color color = const Color(0x1F000000),
    double spacing = 20.0,
    double radius = 3.0,
  }) {
    return CreativePatternConfig(
      repeatingType: RepeatingPatternType.polkaDots,
      color: color,
      spacing: spacing,
      strokeWidth: radius,
    );
  }

  /// Factory: Topographic Contour Map.
  factory CreativePatternConfig.topographic({
    Color color = const Color(0x2E2D3748),
    double spacing = 22.0,
  }) {
    return CreativePatternConfig(
      repeatingType: RepeatingPatternType.topographicContour,
      color: color,
      spacing: spacing,
    );
  }

  CreativePatternConfig copyWith({
    StationeryPatternType? stationeryType,
    RepeatingPatternType? repeatingType,
    Color? color,
    Color? secondaryColor,
    double? spacing,
    double? strokeWidth,
    double? scale,
    double? rotation,
    Offset? offset,
    double? opacity,
  }) {
    return CreativePatternConfig(
      stationeryType: stationeryType ?? this.stationeryType,
      repeatingType: repeatingType ?? this.repeatingType,
      color: color ?? this.color,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      spacing: spacing ?? this.spacing,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      offset: offset ?? this.offset,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreativePatternConfig &&
          runtimeType == other.runtimeType &&
          stationeryType == other.stationeryType &&
          repeatingType == other.repeatingType &&
          color == other.color &&
          secondaryColor == other.secondaryColor &&
          spacing == other.spacing &&
          strokeWidth == other.strokeWidth &&
          scale == other.scale &&
          rotation == other.rotation &&
          offset == other.offset &&
          opacity == other.opacity;

  @override
  int get hashCode => Object.hash(
        stationeryType,
        repeatingType,
        color,
        secondaryColor,
        spacing,
        strokeWidth,
        scale,
        rotation,
        offset,
        opacity,
      );
}

