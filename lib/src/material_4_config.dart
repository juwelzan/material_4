import 'dart:ui';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart' show BoxShadow, Gradient;

import 'config/config.dart';
import 'container/custom_shape.dart';
import 'creative/borders/creative_border_config.dart';
import 'creative/paper/paper_background_config.dart';
import 'rendering/material_4_interaction.dart';
import 'shape_pattern.dart';

export 'config/config.dart';

/// Available Material 4 shape presets that can be generated on the fly.
enum Material4Type {
  // --- Original 13 Presets (Preserved for 100% Backward Compatibility) ---
  /// File-folder tab shape (elevated or recessed tab on an edge).
  folderTab,

  /// Inward notch recessed to dock badges, chips, or counters.
  notchedBadge,

  /// Protruding bubble/puzzle tab on the side or corner.
  sideTab,

  /// Stepped or chamfered corner with smooth inner fillet.
  steppedCorner,

  /// Ticket voucher with inward circular scallops on edges.
  ticketScallop,

  /// Postage stamp with continuous scalloped perforated edges.
  postageStamp,

  /// Sawtooth / zigzag receipt cut (great for vouchers, fee receipts, exam tokens).
  zigzagCut,

  /// Cathedral dome / arch (rounded dome top with flat bottom).
  arch,

  /// Soft rounded hexagonal badge (for ranks, grades, awards).
  hexagonSoft,

  /// Diagonal chamfer ribbon corner (stylish beveled fold).
  chamferDiagonal,

  /// Asymmetrical playful organic fluid blob.
  organicBlob,

  /// Circular flower/scalloped petal shape (great for avatars/badges).
  scallopedPetal,

  /// Minimal squircle / rounded container.
  smoothRounded,

  // --- Next-Gen Shape Geometry Presets (Phase 1 Expansion) ---
  /// Card with distinct, customizable radii on all four corners.
  asymmetricCard,

  /// Pill/capsule shape with fully rounded semicircular ends.
  capsule,

  /// Wavy fluid organic crest line along an edge.
  waveEdge,

  /// Puffy organic multi-lobed cloud perimeter.
  cloud,

  /// Speech/thought balloon bubble with an integrated tail pointer.
  speechBubble,

  /// Classic heraldic / academic crest emblem shield.
  shield,

  /// Symmetrical 4-point rhombus/diamond with rounded vertices.
  diamond,

  /// Regular 8-sided polygon with rounded vertex transitions.
  octagon,

  /// Clean diagonal or horizontal wave slice cutout across the container.
  waveCut,

  /// Inward/concave circular corner cuts (vintage plaque/frame).
  concaveRounded,

  /// Outward barrel/convex curved expanding edges.
  convexRounded,

  /// Mathematical Lamé curve super-ellipse (authentic iOS-style squircle).
  squircle,

  /// Slanted parallelogram with customizable shear/skew angle.
  parallelogram,

  /// Banner ribbon with triangular swallowtail notched ends.
  ribbon,

  /// Vertical page bookmark with an inverted V-notch tail cut.
  bookmark,

  /// Fully custom Bézier geometry supplied via callback.
  customBezier,

  // --- Universal Next-Gen Shapes ---
  /// Mathematical Lamé curve super-ellipse with configurable exponent.
  superellipse,

  /// Curvature-continuous C2 squircle arc.
  continuousSquircle,

  /// Asymmetric procedural multi-control point organic blob.
  asymmetricBlob,

  /// Symmetrical diamond with outward curved convex facets.
  softDiamond,

  /// Regular 6-sided polygon with smooth corner fillets.
  roundedHexagon,

  /// Regular 5-sided polygon with smooth corner fillets.
  roundedPentagon,

  /// Event voucher ticket with opposing circular notch bites.
  ticket,

  /// Multi-petal circular botanical blossom silhouette.
  flower,

  /// Multi-pointed starburst badge emblem.
  starburst,

  /// Natural pointed botanical leaf silhouette.
  leaf,

  /// Teardrop water droplet with pointed apex and rounded base.
  droplet,

  /// Fluid organic metaball liquid droplet shape.
  liquid,
}

/// Metallic reflection lustres for metallic borders and backgrounds.
enum MetallicType { gold, chrome, bronze, silver, roseGold, titanium }

/// Stroke alignment relative to the shape boundary path.
enum ShapeStrokeAlign {
  /// Stroke is centered along the geometric path boundary (standard Flutter behavior).
  center,

  /// Stroke is constrained strictly inside the shape boundary.
  inside,

  /// Stroke is constrained strictly outside the shape boundary.
  outside,
}

/// Specification for a single border layer in a multi-layered border stack.
class BorderLayer {
  final Color color;
  final Gradient? gradient;
  final double width;
  final double
      offset; // Inset (positive) or outset (negative) from base contour
  final double dashLength;
  final double dashGap;
  final double blurRadius;
  final bool isDashed;

  const BorderLayer({
    this.color = const Color(0xFF000000),
    this.gradient,
    this.width = 1.5,
    this.offset = 0.0,
    this.dashLength = 6.0,
    this.dashGap = 4.0,
    this.blurRadius = 0.0,
    this.isDashed = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BorderLayer &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          gradient == other.gradient &&
          width == other.width &&
          offset == other.offset &&
          dashLength == other.dashLength &&
          dashGap == other.dashGap &&
          blurRadius == other.blurRadius &&
          isDashed == other.isDashed;

  @override
  int get hashCode => Object.hash(
        color,
        gradient,
        width,
        offset,
        dashLength,
        dashGap,
        blurRadius,
        isDashed,
      );
}

/// Unique border rendering styles to give containers striking visual identities.
enum BorderStyleType {
  /// Clean, crisp solid hairline stroke.
  solid,

  /// Perforated dashed stitch border (craft & ticket aesthetic).
  dashed,

  /// Fine dotted pin-hole stroke.
  dotted,

  /// Layered double frame (outer primary stroke + inner delicate frame).
  doubleStroke,

  /// Gradient stroke seamlessly transitioning colors along the contour.
  gradient,

  /// Neo-brutalism 3D hard-edge offset shadow with bold outline.
  neo3d,

  /// Soft ambient colored glow halo contouring the shape.
  glow,

  // --- Next-Gen Border Engine (Phase 2 Expansion) ---
  /// Smooth cycling animated gradient sweep along or across the contour.
  animatedGradient,

  /// Vibrant chromatic spectrum dispersion gradient along the contour.
  rainbow,

  /// Luminous pulsing neon stroke with multi-stage glow bloom.
  neonPulse,

  /// High-specular reflective metallic luster (gold, chrome, bronze, etc.).
  metallic,

  /// Concentric or stepped multi-layer border composite stack.
  multiLayer,

  /// Technical framing brackets rendered only at shape corners/vertices.
  cornerOnly,

  /// Perforated dashed stitch border shaded with a multi-stop gradient.
  gradientDashed,

  /// Animated dashed border with moving marquee phase offset along the perimeter.
  animatedDashed,

  /// Chiseled 3D bevel stroke with light and shadow relief based on light azimuth.
  embossed,

  /// Stroke confined strictly inside the shape perimeter via precise clipping.
  innerStroke,

  /// Stroke expanding strictly outward from the shape perimeter.
  outerStroke,

  /// Tactile stippled organic noise texture stroke.
  noiseTextured,

  /// Artisanal organic hand-drawn sketchy stroke with continuous harmonic jitter.
  handDrawn,

  // --- Universal Next-Gen Animated Border Styles ---
  /// Continuous flowing gradient energy sweep along the contour.
  flowingBorder,

  /// Marquee marching ants with animated phase offset.
  movingDash,

  /// Rhythmic harmonic breathing of stroke width and glow.
  pulsatingBorder,

  /// Hydrodynamic undulating wave crest boundary contouring the shape.
  liquidBorder,

  /// Sinusoidal ripple following the shape perimeter.
  waveBorder,

  /// Triangular sawtooth ripple along the boundary.
  zigzagBorder,

  /// Animated discrete energy sparks traversing the perimeter.
  particleBorder,

  /// Single or paired comets orbiting the perimeter.
  orbitingLightBorder,

  /// Concentric dual-stroke layers with opposing phase motion.
  dualLayerBorder,

  /// Specular reflective streak traversing the perimeter.
  shimmerBorder,

  /// 360-degree rotating chromatic sweep.
  conicGradientBorder,

  /// Electric plasma jitter stroke.
  energyBorder,
}

/// Visual background effect styles for Material 4 shape interiors.
enum BackgroundEffectType {
  /// Standard solid color or linear gradient fill.
  none,

  /// Multi-point coordinate bicubic color blending.
  meshGradient,

  /// Subtle tactile film grain stipple overlay.
  noise,

  /// Flowing organic fluid metaball gradient blobs.
  liquidGradient,

  /// Radial concentric spherical gradient.
  radial,

  /// Conic / angular sweep gradient.
  conic,

  /// Animated sine-based fluid wave liquid crests.
  animatedWaves,

  /// Floating ambient glowing micro-particles.
  particles,

  /// Ethereal shifting curtains of northern lights luminous bands.
  aurora,

  /// Iridescent rainbow pearl light shift.
  holographic,

  /// Frosted glassmorphism blur with rim reflection.
  frostedGlass,

  /// Specular brushed metal reflection sheen.
  metallic,
}

/// Configuration model containing all geometric, border, pattern, and depth parameters
/// needed to generate arbitrary organic, minimal, and unique shapes in Material 4.

/// Type alias for [Material4Config].
typedef Material4ShapeConfig = Material4Config;

/// Deprecated alias for [Material4Config].
@Deprecated(
    'Use Material4Config instead. This alias will be removed in a future release.')
typedef DynamicShapeConfig = Material4Config;

/// Deprecated alias for [Material4Type].
@Deprecated(
    'Use Material4Type instead. This alias will be removed in a future release.')
typedef DynamicShapeType = Material4Type;

class Material4Config {
  final Material4Type type;
  final BorderStyleType borderStyle;

  /// Base uniform corner radius of the container.
  final double cornerRadius;

  /// Independent corner radii specification (takes precedence over cornerRadius if provided).
  final CornerRadii? _cornerRadii;

  /// Modern corner configuration supporting elliptical radii and proportional scaling.
  final ShapeCorners? corners;

  /// Contour configuration for the four boundary edges.
  final ShapeEdges? edges;

  /// Anchor position for tabs, notches, steps, bubbles, or tails.
  final ShapeAnchor anchor;

  /// Custom anchor offset for sub-pixel precise alignment.
  final Offset? customAnchorOffset;

  /// Dimensions of the tab, notch, or step.
  final double tabWidth;
  final double tabHeight;

  /// Smooth transition radius for inner and outer fillets.
  final double filletRadius;

  /// Radius of ticket bites or scallops.
  final double scallopRadius;

  /// Number of scallops or petals.
  final int petalCount;

  /// Protrusion depth for side tabs.
  final double protrusionDepth;

  /// Sawtooth tooth width & height for zigzag cuts.
  final double toothWidth;
  final double toothHeight;

  /// Dashed and dotted border properties.
  final double dashLength;
  final double dashGap;

  /// Inner border properties for double-stroke styling.
  final double innerBorderGap;
  final double innerBorderWidth;
  final Color? innerBorderColor;

  /// Gradient for gradient borders.
  final Gradient? borderGradient;

  /// Neo-brutalism 3D offset and shadow color.
  final Offset neoOffset;
  final Color neoColor;

  /// Glow blur radius and color for glowing borders.
  final double glowBlurRadius;
  final Color? glowColor;

  /// Pattern texture fill (stripes, dots, grid, waves).
  final ShapePattern pattern;
  final Color? patternColor;
  final double patternSpacing;
  final double patternStrokeWidth;

  /// Tactile Inset / Debossed Inner Shadows (Claymorphic sculpted feel).
  final List<BoxShadow>? innerShadows;

  /// Glassmorphic frosted blur effect.
  final bool isGlassmorphic;
  final double glassBlur;
  final Color? glassTint;

  /// Animated holographic shimmer sweep beam.
  final bool isShimmering;
  final double shimmerProgress;

  // --- Next-Gen Geometry Parameters ---
  /// Multiple custom notches along the perimeter.
  final List<ShapeNotch>? notches;

  /// Speech bubble tail dimensions.
  final double speechBubbleTailWidth;
  final double speechBubbleTailHeight;

  /// Wave parameters for waveEdge and waveCut shapes.
  final double waveCount;
  final double waveAmplitude;

  /// Shear / skew angle for parallelogram in degrees (-45.0 to 45.0).
  final double skewAngle;

  /// Inward swallowtail cut depth for ribbon and bookmark shapes.
  final double ribbonFoldDepth;

  /// Geometric transformation configuration.
  final ShapeTransform? transform;

  final double _rotation;
  final double _scaleX;
  final double _scaleY;
  final Offset _stretchOffset;

  /// Geometric and accessibility boundary constraints.
  final ShapeConstraints constraints;

  /// Declarative parametric Bézier geometry configuration.
  final CustomBezierConfig? bezierConfig;

  /// Custom Bézier path builder callback for customBezier shape type (legacy).
  final Path Function(Size size)? customBezierBuilder;

  /// Next-Gen Universal Custom Shape Builder with fluent geometry API.
  final Material4CustomShape? customShape;

  // --- Next-Gen Border Parameters (Phase 2 Expansion) ---
  /// Animation progress for animated border effects (0.0 to 1.0).
  final double borderProgress;

  /// Phase offset in pixels for animated dashed borders.
  final double dashPhase;

  /// Layer definitions for multiLayer border styling.
  final List<BorderLayer>? multiLayerBorders;

  /// Segment length of corner bracket strokes for cornerOnly styling.
  final double cornerBorderLength;

  /// Metallic preset material when borderStyle is metallic.
  final MetallicType metallicType;

  /// Light angle in radians for embossed 3D bevel lighting.
  final double embossLightAngle;

  /// Jitter roughness amplitude for handDrawn borders.
  final double handDrawnRoughness;

  /// Glow bloom intensity multiplier for neonPulse borders.
  final double neonPulseIntensity;

  /// Custom glow color for neonPulse borders (falls back to borderColor).
  final Color? neonGlowColor;

  /// Stroke alignment relative to the shape contour (center, inside, outside).
  final ShapeStrokeAlign strokeAlign;

  // --- Next-Gen Background Effect Parameters (Phase 4 Expansion) ---
  /// Advanced procedural background effect inside the shape.
  final BackgroundEffectType backgroundEffect;

  /// Corner colors for meshGradient (topLeft, topRight, bottomLeft, bottomRight).
  final List<Color>? meshColors;

  /// Progress driver for animated background effects (waves, particles, aurora, liquid).
  final double backgroundProgress;

  /// Opacity multiplier for noise and grain overlays (0.0 to 1.0).
  final double noiseOpacity;

  /// Fill level for animated liquid waves (0.0 to 1.0).
  final double waveLevel;

  /// Number of floating ambient particles for particles background effect.
  final int particleCount;

  /// Granular layer-specific clipping configuration.
  final ShapeClipConfig? clipConfig;

  /// Shape-aware interaction, hit-testing, and pointer routing configuration.
  final Material4Interaction? interaction;

  /// Creative border configuration (torn paper, deckled edge, stamps, stitch, neon, etc.).
  final CreativeBorderConfig? creativeBorder;

  /// Tactile paper-inspired background material configuration (20 paper styles).
  final PaperBackgroundConfig? paperBackground;

  /// Creative stationery or repeating pattern configuration.
  final CreativePatternConfig? creativePattern;

  const Material4Config({
    this.type = Material4Type.smoothRounded,
    this.borderStyle = BorderStyleType.solid,
    this.cornerRadius = 24.0,
    CornerRadii? cornerRadii,
    this.corners,
    this.edges,
    this.anchor = ShapeAnchor.topRight,
    this.customAnchorOffset,
    this.tabWidth = 80.0,
    this.tabHeight = 24.0,
    this.filletRadius = 12.0,
    this.scallopRadius = 12.0,
    this.petalCount = 10,
    this.protrusionDepth = 16.0,
    this.toothWidth = 14.0,
    this.toothHeight = 8.0,
    this.dashLength = 7.0,
    this.dashGap = 4.0,
    this.innerBorderGap = 4.0,
    this.innerBorderWidth = 1.0,
    this.innerBorderColor,
    this.borderGradient,
    this.neoOffset = const Offset(4, 4),
    this.neoColor = const Color(0xFF1E1E24),
    this.glowBlurRadius = 8.0,
    this.glowColor,
    this.pattern = ShapePattern.none,
    this.patternColor,
    this.patternSpacing = 16.0,
    this.patternStrokeWidth = 1.0,
    this.innerShadows,
    this.isGlassmorphic = false,
    this.glassBlur = 14.0,
    this.glassTint,
    this.isShimmering = false,
    this.shimmerProgress = 0.0,
    this.notches,
    this.speechBubbleTailWidth = 18.0,
    this.speechBubbleTailHeight = 14.0,
    this.waveCount = 3.0,
    this.waveAmplitude = 8.0,
    this.skewAngle = 14.0,
    this.ribbonFoldDepth = 18.0,
    double rotation = 0.0,
    double scaleX = 1.0,
    double scaleY = 1.0,
    Offset stretchOffset = Offset.zero,
    this.transform,
    this.constraints = const ShapeConstraints(),
    this.bezierConfig,
    this.customBezierBuilder,
    this.customShape,
    this.borderProgress = 1.0,
    this.dashPhase = 0.0,
    this.multiLayerBorders,
    this.cornerBorderLength = 24.0,
    this.metallicType = MetallicType.gold,
    this.embossLightAngle = 0.7853981633974483,
    this.handDrawnRoughness = 1.6,
    this.neonPulseIntensity = 1.0,
    this.neonGlowColor,
    this.strokeAlign = ShapeStrokeAlign.center,
    this.backgroundEffect = BackgroundEffectType.none,
    this.meshColors,
    this.backgroundProgress = 0.0,
    this.noiseOpacity = 0.05,
    this.waveLevel = 0.5,
    this.particleCount = 12,
    this.clipConfig,
    this.interaction,
    this.creativeBorder,
    this.paperBackground,
    this.creativePattern,
  })  : _cornerRadii = cornerRadii,
        _rotation = rotation,
        _scaleX = scaleX,
        _scaleY = scaleY,
        _stretchOffset = stretchOffset;

  /// Independent corner radii specification (takes precedence over cornerRadius if provided).
  CornerRadii? get cornerRadii => _cornerRadii ?? corners?.toCornerRadii();

  /// Rotation applied to the shape in radians.
  double get rotation => (transform?.rotation) ?? _rotation;

  /// Horizontal scaling factor (1.0 = 100%).
  double get scaleX => (transform?.scaleX) ?? _scaleX;

  /// Vertical scaling factor (1.0 = 100%).
  double get scaleY => (transform?.scaleY) ?? _scaleY;

  /// Directional stretch distortion offset.
  Offset get stretchOffset => (transform?.stretchOffset) ?? _stretchOffset;

  /// Resolved four-corner radii configuration with CSS proportional downscaling support.
  ShapeCorners get resolvedCorners {
    if (corners != null) return corners!;
    if (_cornerRadii != null) return _cornerRadii!.toShapeCorners();
    return ShapeCorners.all(Radius.circular(cornerRadius));
  }

  /// Resolved geometric transformation configuration.
  ShapeTransform get resolvedTransform {
    if (transform != null) return transform!;
    if (_rotation != 0.0 ||
        _scaleX != 1.0 ||
        _scaleY != 1.0 ||
        _stretchOffset != Offset.zero) {
      return ShapeTransform(
        rotation: _rotation,
        scaleX: _scaleX,
        scaleY: _scaleY,
        stretchOffset: _stretchOffset,
      );
    }
    return ShapeTransform.identity;
  }

  // --- Factory Presets (Existing preserved 100%) ---

  factory Material4Config.folderTab({
    ShapeAnchor anchor = ShapeAnchor.topRight,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 22.0,
    double tabWidth = 75.0,
    double tabHeight = 16.0,
    double filletRadius = 10.0,
    ShapePattern pattern = ShapePattern.none,
  }) {
    return Material4Config(
      type: Material4Type.folderTab,
      borderStyle: borderStyle,
      anchor: anchor,
      cornerRadius: cornerRadius,
      tabWidth: tabWidth,
      tabHeight: tabHeight,
      filletRadius: filletRadius,
      pattern: pattern,
    );
  }

  factory Material4Config.notchedBadge({
    ShapeAnchor anchor = ShapeAnchor.topRight,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
    double notchWidth = 92.0,
    double notchHeight = 26.0,
    double filletRadius = 12.0,
  }) {
    return Material4Config(
      type: Material4Type.notchedBadge,
      borderStyle: borderStyle,
      anchor: anchor,
      cornerRadius: cornerRadius,
      tabWidth: notchWidth,
      tabHeight: notchHeight,
      filletRadius: filletRadius,
    );
  }

  factory Material4Config.sideTab({
    ShapeAnchor anchor = ShapeAnchor.rightCenter,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
    double tabWidth = 20.0,
    double tabHeight = 50.0,
    double filletRadius = 12.0,
  }) {
    return Material4Config(
      type: Material4Type.sideTab,
      borderStyle: borderStyle,
      anchor: anchor,
      cornerRadius: cornerRadius,
      protrusionDepth: tabWidth,
      tabHeight: tabHeight,
      filletRadius: filletRadius,
    );
  }

  factory Material4Config.steppedCorner({
    ShapeAnchor anchor = ShapeAnchor.bottomRight,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 22.0,
    double stepWidth = 48.0,
    double stepHeight = 44.0,
    double filletRadius = 14.0,
  }) {
    return Material4Config(
      type: Material4Type.steppedCorner,
      borderStyle: borderStyle,
      anchor: anchor,
      cornerRadius: cornerRadius,
      tabWidth: stepWidth,
      tabHeight: stepHeight,
      filletRadius: filletRadius,
    );
  }

  factory Material4Config.ticketScallop({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
    double scallopRadius = 12.0,
    ShapePattern pattern = ShapePattern.none,
  }) {
    return Material4Config(
      type: Material4Type.ticketScallop,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
      scallopRadius: scallopRadius,
      pattern: pattern,
    );
  }

  factory Material4Config.postageStamp({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 18.0,
    double scallopRadius = 6.0,
  }) {
    return Material4Config(
      type: Material4Type.postageStamp,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
      scallopRadius: scallopRadius,
    );
  }

  factory Material4Config.zigzagCut({
    BorderStyleType borderStyle = BorderStyleType.dashed,
    double cornerRadius = 20.0,
    double toothWidth = 14.0,
    double toothHeight = 8.0,
  }) {
    return Material4Config(
      type: Material4Type.zigzagCut,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
      toothWidth: toothWidth,
      toothHeight: toothHeight,
    );
  }

  factory Material4Config.arch({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
  }) {
    return Material4Config(
      type: Material4Type.arch,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
    );
  }

  factory Material4Config.hexagonSoft({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 16.0,
  }) {
    return Material4Config(
      type: Material4Type.hexagonSoft,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
    );
  }

  factory Material4Config.chamferDiagonal({
    ShapeAnchor anchor = ShapeAnchor.topRight,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 20.0,
    double chamferSize = 36.0,
  }) {
    return Material4Config(
      type: Material4Type.chamferDiagonal,
      anchor: anchor,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
      tabWidth: chamferSize,
    );
  }

  factory Material4Config.organicBlob({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 28.0,
  }) {
    return Material4Config(
      type: Material4Type.organicBlob,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
    );
  }

  factory Material4Config.scallopedPetal({
    int petalCount = 10,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
  }) {
    return Material4Config(
      type: Material4Type.scallopedPetal,
      borderStyle: borderStyle,
      petalCount: petalCount,
      cornerRadius: cornerRadius,
    );
  }

  // --- Next-Gen Shape Preset Factories ---

  /// Preset for an Asymmetric Card with 4 independent corner radii.
  factory Material4Config.asymmetricCard({
    CornerRadii cornerRadii = const CornerRadii.asymmetric(),
    ShapeCorners? corners,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.asymmetricCard,
      borderStyle: borderStyle,
      cornerRadii: cornerRadii,
      corners: corners,
    );
  }

  /// Preset for a smooth Capsule / Pill shape.
  factory Material4Config.capsule({
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.capsule,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Wave Edge container.
  factory Material4Config.waveEdge({
    ShapeAnchor anchor = ShapeAnchor.bottomCenter,
    double waveCount = 3.0,
    double waveAmplitude = 10.0,
    double cornerRadius = 20.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.waveEdge,
      anchor: anchor,
      waveCount: waveCount,
      waveAmplitude: waveAmplitude,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for an organic multi-lobed Cloud shape.
  factory Material4Config.cloud({
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.cloud,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Speech Bubble container with an integrated pointer tail.
  factory Material4Config.speechBubble({
    ShapeAnchor anchor = ShapeAnchor.bottomLeft,
    double tailWidth = 18.0,
    double tailHeight = 14.0,
    double cornerRadius = 22.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.speechBubble,
      anchor: anchor,
      speechBubbleTailWidth: tailWidth,
      speechBubbleTailHeight: tailHeight,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a classic Shield / Academic Crest emblem.
  factory Material4Config.shield({
    double cornerRadius = 20.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.shield,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Diamond / Rhombus badge.
  factory Material4Config.diamond({
    double cornerRadius = 14.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.diamond,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for an 8-sided Octagon shape.
  factory Material4Config.octagon({
    double cornerRadius = 16.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.octagon,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Wave Cut sliced container.
  factory Material4Config.waveCut({
    ShapeAnchor anchor = ShapeAnchor.bottomRight,
    double waveAmplitude = 16.0,
    double cornerRadius = 22.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.waveCut,
      anchor: anchor,
      waveAmplitude: waveAmplitude,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for Concave Rounded corners (vintage decorative frame).
  factory Material4Config.concaveRounded({
    double cornerRadius = 20.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.concaveRounded,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for Convex Rounded (barrel curved sides).
  factory Material4Config.convexRounded({
    double curvature = 16.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.convexRounded,
      waveAmplitude: curvature,
      borderStyle: borderStyle,
    );
  }

  /// Preset for true mathematical Squircle (iOS super-ellipse).
  factory Material4Config.squircle({
    double cornerRadius = 32.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.squircle,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a slanted Parallelogram badge.
  factory Material4Config.parallelogram({
    double skewAngle = 14.0,
    double cornerRadius = 16.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.parallelogram,
      skewAngle: skewAngle,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Banner Ribbon with swallowtail notches.
  factory Material4Config.ribbon({
    double foldDepth = 20.0,
    double cornerRadius = 6.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.ribbon,
      ribbonFoldDepth: foldDepth,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Bookmark with an inverted bottom V-tail.
  factory Material4Config.bookmark({
    double notchDepth = 22.0,
    double cornerRadius = 16.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.bookmark,
      ribbonFoldDepth: notchDepth,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for fully custom Bézier path geometry.
  factory Material4Config.customBezier({
    Path Function(Size size)? builder,
    CustomBezierConfig? config,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return Material4Config(
      type: Material4Type.customBezier,
      customBezierBuilder: builder,
      bezierConfig: config,
      borderStyle: borderStyle,
    );
  }

  // --- Next-Gen Border Presets (Phase 2 Expansion) ---

  /// Preset for a high-intensity pulsing neon glow border.
  factory Material4Config.neon({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
    double neonPulseIntensity = 1.0,
    Color? neonGlowColor,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.neonPulse,
      neonPulseIntensity: neonPulseIntensity,
      neonGlowColor: neonGlowColor,
    );
  }

  /// Preset for a specular reflective metallic border (gold, chrome, bronze, etc.).
  factory Material4Config.metallic({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
    MetallicType metallicType = MetallicType.gold,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.metallic,
      metallicType: metallicType,
    );
  }

  /// Preset for a full chromatic spectrum rainbow dispersion border.
  factory Material4Config.rainbow({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.rainbow,
    );
  }

  /// Preset for a multi-layered concentric border stack.
  factory Material4Config.multiLayer({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
    required List<BorderLayer> layers,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.multiLayer,
      multiLayerBorders: layers,
    );
  }

  /// Preset for technical framing bracket corners (corners rendered, edges open).
  factory Material4Config.cornerOnly({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
    double cornerLength = 24.0,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.cornerOnly,
      cornerBorderLength: cornerLength,
    );
  }

  /// Preset for an animated dashed marquee border.
  factory Material4Config.animatedDashed({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
    double dashLength = 8.0,
    double dashGap = 5.0,
    double dashPhase = 0.0,
    double progress = 0.0,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.animatedDashed,
      dashLength: dashLength,
      dashGap: dashGap,
      dashPhase: dashPhase,
      borderProgress: progress,
    );
  }

  /// Preset for a smoothly rotating animated gradient contour.
  factory Material4Config.animatedGradient({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
    double progress = 0.0,
    Gradient? gradient,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.animatedGradient,
      borderProgress: progress,
      borderGradient: gradient,
    );
  }

  /// Preset for an artisanal organic hand-drawn sketchy border.
  factory Material4Config.handDrawn({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
    double roughness = 1.6,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.handDrawn,
      handDrawnRoughness: roughness,
    );
  }

  /// Preset for a chiseled 3D embossed border with directional lighting.
  factory Material4Config.embossed({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
    double lightAngle = 0.7853981633974483,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.embossed,
      embossLightAngle: lightAngle,
    );
  }

  /// Preset for a tactile stippled noise textured border.
  factory Material4Config.noiseTextured({
    Material4Type type = Material4Type.smoothRounded,
    double cornerRadius = 24.0,
  }) {
    return Material4Config(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.noiseTextured,
    );
  }

  Material4Config copyWith({
    Material4Type? type,
    BorderStyleType? borderStyle,
    double? cornerRadius,
    CornerRadii? cornerRadii,
    ShapeCorners? corners,
    ShapeEdges? edges,
    ShapeAnchor? anchor,
    Offset? customAnchorOffset,
    double? tabWidth,
    double? tabHeight,
    double? filletRadius,
    double? scallopRadius,
    int? petalCount,
    double? protrusionDepth,
    double? toothWidth,
    double? toothHeight,
    double? dashLength,
    double? dashGap,
    double? innerBorderGap,
    double? innerBorderWidth,
    Color? innerBorderColor,
    Gradient? borderGradient,
    Offset? neoOffset,
    Color? neoColor,
    double? glowBlurRadius,
    Color? glowColor,
    ShapePattern? pattern,
    Color? patternColor,
    double? patternSpacing,
    double? patternStrokeWidth,
    List<BoxShadow>? innerShadows,
    bool? isGlassmorphic,
    double? glassBlur,
    Color? glassTint,
    bool? isShimmering,
    double? shimmerProgress,
    List<ShapeNotch>? notches,
    double? speechBubbleTailWidth,
    double? speechBubbleTailHeight,
    double? waveCount,
    double? waveAmplitude,
    double? skewAngle,
    double? ribbonFoldDepth,
    double? rotation,
    double? scaleX,
    double? scaleY,
    Offset? stretchOffset,
    ShapeTransform? transform,
    ShapeConstraints? constraints,
    CustomBezierConfig? bezierConfig,
    Path Function(Size size)? customBezierBuilder,
    Material4CustomShape? customShape,
    double? borderProgress,
    double? dashPhase,
    List<BorderLayer>? multiLayerBorders,
    double? cornerBorderLength,
    MetallicType? metallicType,
    double? embossLightAngle,
    double? handDrawnRoughness,
    double? neonPulseIntensity,
    Color? neonGlowColor,
    ShapeStrokeAlign? strokeAlign,
    BackgroundEffectType? backgroundEffect,
    List<Color>? meshColors,
    double? backgroundProgress,
    double? noiseOpacity,
    double? waveLevel,
    int? particleCount,
    ShapeClipConfig? clipConfig,
    Material4Interaction? interaction,
    CreativeBorderConfig? creativeBorder,
    PaperBackgroundConfig? paperBackground,
    CreativePatternConfig? creativePattern,
  }) {
    return Material4Config(
      type: type ?? this.type,
      borderStyle: borderStyle ?? this.borderStyle,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      cornerRadii: cornerRadii ?? _cornerRadii,
      corners: corners ?? this.corners,
      edges: edges ?? this.edges,
      anchor: anchor ?? this.anchor,
      customAnchorOffset: customAnchorOffset ?? this.customAnchorOffset,
      tabWidth: tabWidth ?? this.tabWidth,
      tabHeight: tabHeight ?? this.tabHeight,
      filletRadius: filletRadius ?? this.filletRadius,
      scallopRadius: scallopRadius ?? this.scallopRadius,
      petalCount: petalCount ?? this.petalCount,
      protrusionDepth: protrusionDepth ?? this.protrusionDepth,
      toothWidth: toothWidth ?? this.toothWidth,
      toothHeight: toothHeight ?? this.toothHeight,
      dashLength: dashLength ?? this.dashLength,
      dashGap: dashGap ?? this.dashGap,
      innerBorderGap: innerBorderGap ?? this.innerBorderGap,
      innerBorderWidth: innerBorderWidth ?? this.innerBorderWidth,
      innerBorderColor: innerBorderColor ?? this.innerBorderColor,
      borderGradient: borderGradient ?? this.borderGradient,
      neoOffset: neoOffset ?? this.neoOffset,
      neoColor: neoColor ?? this.neoColor,
      glowBlurRadius: glowBlurRadius ?? this.glowBlurRadius,
      glowColor: glowColor ?? this.glowColor,
      pattern: pattern ?? this.pattern,
      patternColor: patternColor ?? this.patternColor,
      patternSpacing: patternSpacing ?? this.patternSpacing,
      patternStrokeWidth: patternStrokeWidth ?? this.patternStrokeWidth,
      innerShadows: innerShadows ?? this.innerShadows,
      isGlassmorphic: isGlassmorphic ?? this.isGlassmorphic,
      glassBlur: glassBlur ?? this.glassBlur,
      glassTint: glassTint ?? this.glassTint,
      isShimmering: isShimmering ?? this.isShimmering,
      shimmerProgress: shimmerProgress ?? this.shimmerProgress,
      notches: notches ?? this.notches,
      speechBubbleTailWidth:
          speechBubbleTailWidth ?? this.speechBubbleTailWidth,
      speechBubbleTailHeight:
          speechBubbleTailHeight ?? this.speechBubbleTailHeight,
      waveCount: waveCount ?? this.waveCount,
      waveAmplitude: waveAmplitude ?? this.waveAmplitude,
      skewAngle: skewAngle ?? this.skewAngle,
      ribbonFoldDepth: ribbonFoldDepth ?? this.ribbonFoldDepth,
      rotation: rotation ?? _rotation,
      scaleX: scaleX ?? _scaleX,
      scaleY: scaleY ?? _scaleY,
      stretchOffset: stretchOffset ?? _stretchOffset,
      transform: transform ?? this.transform,
      constraints: constraints ?? this.constraints,
      bezierConfig: bezierConfig ?? this.bezierConfig,
      customBezierBuilder: customBezierBuilder ?? this.customBezierBuilder,
      customShape: customShape ?? this.customShape,
      borderProgress: borderProgress ?? this.borderProgress,
      dashPhase: dashPhase ?? this.dashPhase,
      multiLayerBorders: multiLayerBorders ?? this.multiLayerBorders,
      cornerBorderLength: cornerBorderLength ?? this.cornerBorderLength,
      metallicType: metallicType ?? this.metallicType,
      embossLightAngle: embossLightAngle ?? this.embossLightAngle,
      handDrawnRoughness: handDrawnRoughness ?? this.handDrawnRoughness,
      neonPulseIntensity: neonPulseIntensity ?? this.neonPulseIntensity,
      neonGlowColor: neonGlowColor ?? this.neonGlowColor,
      strokeAlign: strokeAlign ?? this.strokeAlign,
      backgroundEffect: backgroundEffect ?? this.backgroundEffect,
      meshColors: meshColors ?? this.meshColors,
      backgroundProgress: backgroundProgress ?? this.backgroundProgress,
      noiseOpacity: noiseOpacity ?? this.noiseOpacity,
      waveLevel: waveLevel ?? this.waveLevel,
      particleCount: particleCount ?? this.particleCount,
      clipConfig: clipConfig ?? this.clipConfig,
      interaction: interaction ?? this.interaction,
      creativeBorder: creativeBorder ?? this.creativeBorder,
      paperBackground: paperBackground ?? this.paperBackground,
      creativePattern: creativePattern ?? this.creativePattern,
    );
  }

  /// Serializes this configuration into a JSON-compatible map for persistence or network transport.
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'borderStyle': borderStyle.name,
        'cornerRadius': cornerRadius,
        'cornerRadii': _cornerRadii?.toJson(),
        'corners': corners?.toJson(),
        'edges': edges?.toJson(),
        'anchor': anchor.name,
        'tabWidth': tabWidth,
        'tabHeight': tabHeight,
        'filletRadius': filletRadius,
        'scallopRadius': scallopRadius,
        'petalCount': petalCount,
        'protrusionDepth': protrusionDepth,
        'toothWidth': toothWidth,
        'toothHeight': toothHeight,
        'dashLength': dashLength,
        'dashGap': dashGap,
        'innerBorderGap': innerBorderGap,
        'innerBorderWidth': innerBorderWidth,
        'rotation': rotation,
        'scaleX': scaleX,
        'scaleY': scaleY,
        'stretchOffsetX': stretchOffset.dx,
        'stretchOffsetY': stretchOffset.dy,
        'transform': transform?.toJson(),
        'constraints': constraints.toJson(),
        'bezierConfig': bezierConfig?.toJson(),
        'speechBubbleTailWidth': speechBubbleTailWidth,
        'speechBubbleTailHeight': speechBubbleTailHeight,
        'waveCount': waveCount,
        'waveAmplitude': waveAmplitude,
        'skewAngle': skewAngle,
        'ribbonFoldDepth': ribbonFoldDepth,
        'backgroundEffect': backgroundEffect.name,
        'noiseOpacity': noiseOpacity,
        'waveLevel': waveLevel,
        'particleCount': particleCount,
        'cornerBorderLength': cornerBorderLength,
        'metallicType': metallicType.name,
        'handDrawnRoughness': handDrawnRoughness,
        'neonPulseIntensity': neonPulseIntensity,
        'notches': notches?.map((n) => n.toJson()).toList(),
      };

  /// Constructs a [Material4Config] from serialized JSON data.
  factory Material4Config.fromJson(
    Map<String, dynamic> json,
  ) =>
      Material4Config(
        type: Material4Type.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => Material4Type.smoothRounded,
        ),
        borderStyle: BorderStyleType.values.firstWhere(
          (e) => e.name == json['borderStyle'],
          orElse: () => BorderStyleType.solid,
        ),
        cornerRadius: (json['cornerRadius'] as num?)?.toDouble() ?? 24.0,
        cornerRadii: json['cornerRadii'] != null
            ? CornerRadii.fromJson(json['cornerRadii'] as Map<String, dynamic>)
            : null,
        corners: json['corners'] != null
            ? ShapeCorners.fromJson(json['corners'] as Map<String, dynamic>)
            : null,
        edges: json['edges'] != null
            ? ShapeEdges.fromJson(json['edges'] as Map<String, dynamic>)
            : null,
        anchor: ShapeAnchor.values.firstWhere(
          (e) => e.name == json['anchor'],
          orElse: () => ShapeAnchor.topRight,
        ),
        tabWidth: (json['tabWidth'] as num?)?.toDouble() ?? 80.0,
        tabHeight: (json['tabHeight'] as num?)?.toDouble() ?? 24.0,
        filletRadius: (json['filletRadius'] as num?)?.toDouble() ?? 12.0,
        scallopRadius: (json['scallopRadius'] as num?)?.toDouble() ?? 12.0,
        petalCount: (json['petalCount'] as num?)?.toInt() ?? 10,
        protrusionDepth: (json['protrusionDepth'] as num?)?.toDouble() ?? 16.0,
        toothWidth: (json['toothWidth'] as num?)?.toDouble() ?? 14.0,
        toothHeight: (json['toothHeight'] as num?)?.toDouble() ?? 8.0,
        dashLength: (json['dashLength'] as num?)?.toDouble() ?? 7.0,
        dashGap: (json['dashGap'] as num?)?.toDouble() ?? 4.0,
        innerBorderGap: (json['innerBorderGap'] as num?)?.toDouble() ?? 4.0,
        innerBorderWidth: (json['innerBorderWidth'] as num?)?.toDouble() ?? 1.0,
        rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
        scaleX: (json['scaleX'] as num?)?.toDouble() ?? 1.0,
        scaleY: (json['scaleY'] as num?)?.toDouble() ?? 1.0,
        stretchOffset: Offset(
          (json['stretchOffsetX'] as num?)?.toDouble() ?? 0.0,
          (json['stretchOffsetY'] as num?)?.toDouble() ?? 0.0,
        ),
        transform: json['transform'] != null
            ? ShapeTransform.fromJson(json['transform'] as Map<String, dynamic>)
            : null,
        constraints: json['constraints'] != null
            ? ShapeConstraints.fromJson(
                json['constraints'] as Map<String, dynamic>)
            : const ShapeConstraints(),
        bezierConfig: json['bezierConfig'] != null
            ? CustomBezierConfig.fromJson(
                json['bezierConfig'] as Map<String, dynamic>)
            : null,
        speechBubbleTailWidth:
            (json['speechBubbleTailWidth'] as num?)?.toDouble() ?? 18.0,
        speechBubbleTailHeight:
            (json['speechBubbleTailHeight'] as num?)?.toDouble() ?? 14.0,
        waveCount: (json['waveCount'] as num?)?.toDouble() ?? 3.0,
        waveAmplitude: (json['waveAmplitude'] as num?)?.toDouble() ?? 8.0,
        skewAngle: (json['skewAngle'] as num?)?.toDouble() ?? 14.0,
        ribbonFoldDepth: (json['ribbonFoldDepth'] as num?)?.toDouble() ?? 18.0,
        backgroundEffect: BackgroundEffectType.values.firstWhere(
          (e) => e.name == json['backgroundEffect'],
          orElse: () => BackgroundEffectType.none,
        ),
        noiseOpacity: (json['noiseOpacity'] as num?)?.toDouble() ?? 0.05,
        waveLevel: (json['waveLevel'] as num?)?.toDouble() ?? 0.5,
        particleCount: (json['particleCount'] as num?)?.toInt() ?? 12,
        cornerBorderLength:
            (json['cornerBorderLength'] as num?)?.toDouble() ?? 24.0,
        metallicType: MetallicType.values.firstWhere(
          (e) => e.name == json['metallicType'],
          orElse: () => MetallicType.gold,
        ),
        handDrawnRoughness:
            (json['handDrawnRoughness'] as num?)?.toDouble() ?? 1.6,
        neonPulseIntensity:
            (json['neonPulseIntensity'] as num?)?.toDouble() ?? 1.0,
        notches: (json['notches'] as List?)
            ?.map((n) => ShapeNotch.fromJson(n as Map<String, dynamic>))
            .toList(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4Config &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          borderStyle == other.borderStyle &&
          cornerRadius == other.cornerRadius &&
          _cornerRadii == other._cornerRadii &&
          corners == other.corners &&
          edges == other.edges &&
          anchor == other.anchor &&
          customAnchorOffset == other.customAnchorOffset &&
          tabWidth == other.tabWidth &&
          tabHeight == other.tabHeight &&
          filletRadius == other.filletRadius &&
          scallopRadius == other.scallopRadius &&
          petalCount == other.petalCount &&
          protrusionDepth == other.protrusionDepth &&
          toothWidth == other.toothWidth &&
          toothHeight == other.toothHeight &&
          dashLength == other.dashLength &&
          dashGap == other.dashGap &&
          innerBorderGap == other.innerBorderGap &&
          innerBorderWidth == other.innerBorderWidth &&
          innerBorderColor == other.innerBorderColor &&
          borderGradient == other.borderGradient &&
          neoOffset == other.neoOffset &&
          neoColor == other.neoColor &&
          glowBlurRadius == other.glowBlurRadius &&
          glowColor == other.glowColor &&
          pattern == other.pattern &&
          patternColor == other.patternColor &&
          patternSpacing == other.patternSpacing &&
          patternStrokeWidth == other.patternStrokeWidth &&
          listEquals(innerShadows, other.innerShadows) &&
          isGlassmorphic == other.isGlassmorphic &&
          glassBlur == other.glassBlur &&
          glassTint == other.glassTint &&
          isShimmering == other.isShimmering &&
          shimmerProgress == other.shimmerProgress &&
          listEquals(notches, other.notches) &&
          speechBubbleTailWidth == other.speechBubbleTailWidth &&
          speechBubbleTailHeight == other.speechBubbleTailHeight &&
          waveCount == other.waveCount &&
          waveAmplitude == other.waveAmplitude &&
          skewAngle == other.skewAngle &&
          ribbonFoldDepth == other.ribbonFoldDepth &&
          _rotation == other._rotation &&
          _scaleX == other._scaleX &&
          _scaleY == other._scaleY &&
          _stretchOffset == other._stretchOffset &&
          transform == other.transform &&
          constraints == other.constraints &&
          bezierConfig == other.bezierConfig &&
          customBezierBuilder == other.customBezierBuilder &&
          customShape == other.customShape &&
          borderProgress == other.borderProgress &&
          dashPhase == other.dashPhase &&
          listEquals(multiLayerBorders, other.multiLayerBorders) &&
          cornerBorderLength == other.cornerBorderLength &&
          metallicType == other.metallicType &&
          embossLightAngle == other.embossLightAngle &&
          handDrawnRoughness == other.handDrawnRoughness &&
          neonPulseIntensity == other.neonPulseIntensity &&
          neonGlowColor == other.neonGlowColor &&
          strokeAlign == other.strokeAlign &&
          backgroundEffect == other.backgroundEffect &&
          listEquals(meshColors, other.meshColors) &&
          backgroundProgress == other.backgroundProgress &&
          noiseOpacity == other.noiseOpacity &&
          waveLevel == other.waveLevel &&
          particleCount == other.particleCount &&
          creativeBorder == other.creativeBorder &&
          paperBackground == other.paperBackground &&
          creativePattern == other.creativePattern;

  @override
  int get hashCode => Object.hashAll([
        type,
        borderStyle,
        cornerRadius,
        _cornerRadii,
        corners,
        edges,
        anchor,
        customAnchorOffset,
        tabWidth,
        tabHeight,
        filletRadius,
        scallopRadius,
        petalCount,
        protrusionDepth,
        toothWidth,
        toothHeight,
        dashLength,
        dashGap,
        innerBorderGap,
        innerBorderWidth,
        innerBorderColor,
        borderGradient,
        neoOffset,
        neoColor,
        glowBlurRadius,
        glowColor,
        pattern,
        patternColor,
        patternSpacing,
        patternStrokeWidth,
        innerShadows == null ? null : Object.hashAll(innerShadows!),
        isGlassmorphic,
        glassBlur,
        glassTint,
        isShimmering,
        shimmerProgress,
        notches == null ? null : Object.hashAll(notches!),
        speechBubbleTailWidth,
        speechBubbleTailHeight,
        waveCount,
        waveAmplitude,
        skewAngle,
        ribbonFoldDepth,
        _rotation,
        _scaleX,
        _scaleY,
        _stretchOffset,
        transform,
        constraints,
        bezierConfig,
        customBezierBuilder,
        customShape,
        borderProgress,
        dashPhase,
        multiLayerBorders == null ? null : Object.hashAll(multiLayerBorders!),
        cornerBorderLength,
        metallicType,
        embossLightAngle,
        handDrawnRoughness,
        neonPulseIntensity,
        neonGlowColor,
        strokeAlign,
        backgroundEffect,
        meshColors == null ? null : Object.hashAll(meshColors!),
        backgroundProgress,
        noiseOpacity,
        waveLevel,
        particleCount,
        creativeBorder,
        paperBackground,
        creativePattern,
      ]);

  /// Linearly interpolates between two [Material4Config] instances.
  static Material4Config lerp(
    Material4Config a,
    Material4Config b,
    double t,
  ) {
    if (identical(a, b)) return a;
    if (t <= 0.0) return a;
    if (t >= 1.0) return b;

    double lerpD(double v1, double v2) => v1 + (v2 - v1) * t;

    final dominant = t < 0.5 ? a : b;

    return dominant.copyWith(
      cornerRadius: lerpD(a.cornerRadius, b.cornerRadius),
      corners: ShapeCorners.lerp(a.resolvedCorners, b.resolvedCorners, t),
      transform:
          ShapeTransform.lerp(a.resolvedTransform, b.resolvedTransform, t),
      notches: ShapeNotch.lerpList(a.notches, b.notches, t),
      tabWidth: lerpD(a.tabWidth, b.tabWidth),
      tabHeight: lerpD(a.tabHeight, b.tabHeight),
      filletRadius: lerpD(a.filletRadius, b.filletRadius),
      scallopRadius: lerpD(a.scallopRadius, b.scallopRadius),
      waveAmplitude: lerpD(a.waveAmplitude, b.waveAmplitude),
      waveCount: lerpD(a.waveCount, b.waveCount),
      skewAngle: lerpD(a.skewAngle, b.skewAngle),
      ribbonFoldDepth: lerpD(a.ribbonFoldDepth, b.ribbonFoldDepth),
      borderProgress: lerpD(a.borderProgress, b.borderProgress),
      dashPhase: lerpD(a.dashPhase, b.dashPhase),
      neonPulseIntensity: lerpD(a.neonPulseIntensity, b.neonPulseIntensity),
      creativeBorder:
          CreativeBorderConfig.lerp(a.creativeBorder, b.creativeBorder, t),
      paperBackground: t < 0.5 ? a.paperBackground : b.paperBackground,
      creativePattern: t < 0.5 ? a.creativePattern : b.creativePattern,
      customShape: t < 0.5 ? a.customShape : b.customShape,
      stretchOffset:
          Offset.lerp(a.stretchOffset, b.stretchOffset, t) ?? a.stretchOffset,
    );
  }
}
