import 'dart:ui';

import 'package:flutter/material.dart' show BoxShadow, Gradient;

import 'shape_pattern.dart';

/// Defines the position of tabs, notches, or cutouts on a container.
enum ShapeAnchor {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  leftCenter,
  rightCenter,
  topCenter,
  bottomCenter,
  center,
}

/// Available dynamic shape presets that can be generated on the fly.
enum DynamicShapeType {
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
}

/// Independent corner radii specification for four distinct corners.
class CornerRadii {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  const CornerRadii({
    this.topLeft = 0.0,
    this.topRight = 0.0,
    this.bottomLeft = 0.0,
    this.bottomRight = 0.0,
  });

  const CornerRadii.all(double radius)
    : topLeft = radius,
      topRight = radius,
      bottomLeft = radius,
      bottomRight = radius;

  const CornerRadii.only({
    this.topLeft = 0.0,
    this.topRight = 0.0,
    this.bottomLeft = 0.0,
    this.bottomRight = 0.0,
  });

  const CornerRadii.asymmetric({
    this.topLeft = 32.0,
    this.topRight = 8.0,
    this.bottomRight = 24.0,
    this.bottomLeft = 4.0,
  });

  CornerRadii copyWith({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return CornerRadii(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CornerRadii &&
          runtimeType == other.runtimeType &&
          topLeft == other.topLeft &&
          topRight == other.topRight &&
          bottomLeft == other.bottomLeft &&
          bottomRight == other.bottomRight;

  @override
  int get hashCode => Object.hash(topLeft, topRight, bottomLeft, bottomRight);
}

/// Multi-notch specification for embedding multiple slots/cavities into a shape contour.
class ShapeNotch {
  final ShapeAnchor position;
  final double width;
  final double height;
  final double filletRadius;
  final double offset;
  final bool isInward;

  const ShapeNotch({
    this.position = ShapeAnchor.topRight,
    this.width = 80.0,
    this.height = 24.0,
    this.filletRadius = 12.0,
    this.offset = 0.0,
    this.isInward = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeNotch &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          width == other.width &&
          height == other.height &&
          filletRadius == other.filletRadius &&
          offset == other.offset &&
          isInward == other.isInward;

  @override
  int get hashCode =>
      Object.hash(position, width, height, filletRadius, offset, isInward);
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
}

/// Visual background effect styles for dynamic shape interiors.
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
/// needed to generate arbitrary organic, minimal, and unique shapes dynamically.
class DynamicShapeConfig {
  final DynamicShapeType type;
  final BorderStyleType borderStyle;

  /// Base uniform corner radius of the container.
  final double cornerRadius;

  /// Independent corner radii specification (takes precedence over cornerRadius if provided).
  final CornerRadii? cornerRadii;

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

  /// Rotation applied to the shape in radians.
  final double rotation;

  /// Horizontal and vertical scaling factor (1.0 = 100%).
  final double scaleX;
  final double scaleY;

  /// Directional stretch distortion offset.
  final Offset stretchOffset;

  /// Custom Bézier path builder callback for customBezier shape type.
  final Path Function(Size size)? customBezierBuilder;

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

  const DynamicShapeConfig({
    this.type = DynamicShapeType.smoothRounded,
    this.borderStyle = BorderStyleType.solid,
    this.cornerRadius = 24.0,
    this.cornerRadii,
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
    this.rotation = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.stretchOffset = Offset.zero,
    this.customBezierBuilder,
    this.borderProgress = 0.0,
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
  });

  // --- Factory Presets (Existing preserved 100%) ---

  factory DynamicShapeConfig.folderTab({
    ShapeAnchor anchor = ShapeAnchor.topRight,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 22.0,
    double tabWidth = 75.0,
    double tabHeight = 16.0,
    double filletRadius = 10.0,
    ShapePattern pattern = ShapePattern.none,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.folderTab,
      borderStyle: borderStyle,
      anchor: anchor,
      cornerRadius: cornerRadius,
      tabWidth: tabWidth,
      tabHeight: tabHeight,
      filletRadius: filletRadius,
      pattern: pattern,
    );
  }

  factory DynamicShapeConfig.notchedBadge({
    ShapeAnchor anchor = ShapeAnchor.topRight,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
    double notchWidth = 92.0,
    double notchHeight = 26.0,
    double filletRadius = 12.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.notchedBadge,
      borderStyle: borderStyle,
      anchor: anchor,
      cornerRadius: cornerRadius,
      tabWidth: notchWidth,
      tabHeight: notchHeight,
      filletRadius: filletRadius,
    );
  }

  factory DynamicShapeConfig.sideTab({
    ShapeAnchor anchor = ShapeAnchor.rightCenter,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
    double tabWidth = 20.0,
    double tabHeight = 50.0,
    double filletRadius = 12.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.sideTab,
      borderStyle: borderStyle,
      anchor: anchor,
      cornerRadius: cornerRadius,
      protrusionDepth: tabWidth,
      tabHeight: tabHeight,
      filletRadius: filletRadius,
    );
  }

  factory DynamicShapeConfig.steppedCorner({
    ShapeAnchor anchor = ShapeAnchor.bottomRight,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 22.0,
    double stepWidth = 48.0,
    double stepHeight = 44.0,
    double filletRadius = 14.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.steppedCorner,
      borderStyle: borderStyle,
      anchor: anchor,
      cornerRadius: cornerRadius,
      tabWidth: stepWidth,
      tabHeight: stepHeight,
      filletRadius: filletRadius,
    );
  }

  factory DynamicShapeConfig.ticketScallop({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
    double scallopRadius = 12.0,
    ShapePattern pattern = ShapePattern.none,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.ticketScallop,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
      scallopRadius: scallopRadius,
      pattern: pattern,
    );
  }

  factory DynamicShapeConfig.postageStamp({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 18.0,
    double scallopRadius = 6.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.postageStamp,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
      scallopRadius: scallopRadius,
    );
  }

  factory DynamicShapeConfig.zigzagCut({
    BorderStyleType borderStyle = BorderStyleType.dashed,
    double cornerRadius = 20.0,
    double toothWidth = 14.0,
    double toothHeight = 8.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.zigzagCut,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
      toothWidth: toothWidth,
      toothHeight: toothHeight,
    );
  }

  factory DynamicShapeConfig.arch({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.arch,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
    );
  }

  factory DynamicShapeConfig.hexagonSoft({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 16.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.hexagonSoft,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
    );
  }

  factory DynamicShapeConfig.chamferDiagonal({
    ShapeAnchor anchor = ShapeAnchor.topRight,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 20.0,
    double chamferSize = 36.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.chamferDiagonal,
      anchor: anchor,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
      tabWidth: chamferSize,
    );
  }

  factory DynamicShapeConfig.organicBlob({
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 28.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.organicBlob,
      borderStyle: borderStyle,
      cornerRadius: cornerRadius,
    );
  }

  factory DynamicShapeConfig.scallopedPetal({
    int petalCount = 10,
    BorderStyleType borderStyle = BorderStyleType.solid,
    double cornerRadius = 24.0,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.scallopedPetal,
      borderStyle: borderStyle,
      petalCount: petalCount,
      cornerRadius: cornerRadius,
    );
  }

  // --- Next-Gen Shape Preset Factories ---

  /// Preset for an Asymmetric Card with 4 independent corner radii.
  factory DynamicShapeConfig.asymmetricCard({
    CornerRadii cornerRadii = const CornerRadii.asymmetric(),
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.asymmetricCard,
      borderStyle: borderStyle,
      cornerRadii: cornerRadii,
    );
  }

  /// Preset for a smooth Capsule / Pill shape.
  factory DynamicShapeConfig.capsule({
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.capsule,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Wave Edge container.
  factory DynamicShapeConfig.waveEdge({
    ShapeAnchor anchor = ShapeAnchor.bottomCenter,
    double waveCount = 3.0,
    double waveAmplitude = 10.0,
    double cornerRadius = 20.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.waveEdge,
      anchor: anchor,
      waveCount: waveCount,
      waveAmplitude: waveAmplitude,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for an organic multi-lobed Cloud shape.
  factory DynamicShapeConfig.cloud({
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.cloud,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Speech Bubble container with an integrated pointer tail.
  factory DynamicShapeConfig.speechBubble({
    ShapeAnchor anchor = ShapeAnchor.bottomLeft,
    double tailWidth = 18.0,
    double tailHeight = 14.0,
    double cornerRadius = 22.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.speechBubble,
      anchor: anchor,
      speechBubbleTailWidth: tailWidth,
      speechBubbleTailHeight: tailHeight,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a classic Shield / Academic Crest emblem.
  factory DynamicShapeConfig.shield({
    double cornerRadius = 20.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.shield,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Diamond / Rhombus badge.
  factory DynamicShapeConfig.diamond({
    double cornerRadius = 14.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.diamond,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for an 8-sided Octagon shape.
  factory DynamicShapeConfig.octagon({
    double cornerRadius = 16.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.octagon,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Wave Cut sliced container.
  factory DynamicShapeConfig.waveCut({
    ShapeAnchor anchor = ShapeAnchor.bottomRight,
    double waveAmplitude = 16.0,
    double cornerRadius = 22.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.waveCut,
      anchor: anchor,
      waveAmplitude: waveAmplitude,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for Concave Rounded corners (vintage decorative frame).
  factory DynamicShapeConfig.concaveRounded({
    double cornerRadius = 20.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.concaveRounded,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for Convex Rounded (barrel curved sides).
  factory DynamicShapeConfig.convexRounded({
    double curvature = 16.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.convexRounded,
      waveAmplitude: curvature,
      borderStyle: borderStyle,
    );
  }

  /// Preset for true mathematical Squircle (iOS super-ellipse).
  factory DynamicShapeConfig.squircle({
    double cornerRadius = 32.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.squircle,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a slanted Parallelogram badge.
  factory DynamicShapeConfig.parallelogram({
    double skewAngle = 14.0,
    double cornerRadius = 16.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.parallelogram,
      skewAngle: skewAngle,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Banner Ribbon with swallowtail notches.
  factory DynamicShapeConfig.ribbon({
    double foldDepth = 20.0,
    double cornerRadius = 6.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.ribbon,
      ribbonFoldDepth: foldDepth,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for a Bookmark with an inverted bottom V-tail.
  factory DynamicShapeConfig.bookmark({
    double notchDepth = 22.0,
    double cornerRadius = 16.0,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.bookmark,
      ribbonFoldDepth: notchDepth,
      cornerRadius: cornerRadius,
      borderStyle: borderStyle,
    );
  }

  /// Preset for fully custom Bézier path geometry.
  factory DynamicShapeConfig.customBezier({
    required Path Function(Size size) builder,
    BorderStyleType borderStyle = BorderStyleType.solid,
  }) {
    return DynamicShapeConfig(
      type: DynamicShapeType.customBezier,
      customBezierBuilder: builder,
      borderStyle: borderStyle,
    );
  }

  // --- Next-Gen Border Presets (Phase 2 Expansion) ---

  /// Preset for a high-intensity pulsing neon glow border.
  factory DynamicShapeConfig.neon({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
    double neonPulseIntensity = 1.0,
    Color? neonGlowColor,
  }) {
    return DynamicShapeConfig(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.neonPulse,
      neonPulseIntensity: neonPulseIntensity,
      neonGlowColor: neonGlowColor,
    );
  }

  /// Preset for a specular reflective metallic border (gold, chrome, bronze, etc.).
  factory DynamicShapeConfig.metallic({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
    MetallicType metallicType = MetallicType.gold,
  }) {
    return DynamicShapeConfig(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.metallic,
      metallicType: metallicType,
    );
  }

  /// Preset for a full chromatic spectrum rainbow dispersion border.
  factory DynamicShapeConfig.rainbow({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
  }) {
    return DynamicShapeConfig(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.rainbow,
    );
  }

  /// Preset for a multi-layered concentric border stack.
  factory DynamicShapeConfig.multiLayer({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
    required List<BorderLayer> layers,
  }) {
    return DynamicShapeConfig(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.multiLayer,
      multiLayerBorders: layers,
    );
  }

  /// Preset for technical framing bracket corners (corners rendered, edges open).
  factory DynamicShapeConfig.cornerOnly({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
    double cornerLength = 24.0,
  }) {
    return DynamicShapeConfig(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.cornerOnly,
      cornerBorderLength: cornerLength,
    );
  }

  /// Preset for an animated dashed marquee border.
  factory DynamicShapeConfig.animatedDashed({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
    double dashLength = 8.0,
    double dashGap = 5.0,
    double dashPhase = 0.0,
    double progress = 0.0,
  }) {
    return DynamicShapeConfig(
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
  factory DynamicShapeConfig.animatedGradient({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
    double progress = 0.0,
    Gradient? gradient,
  }) {
    return DynamicShapeConfig(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.animatedGradient,
      borderProgress: progress,
      borderGradient: gradient,
    );
  }

  /// Preset for an artisanal organic hand-drawn sketchy border.
  factory DynamicShapeConfig.handDrawn({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
    double roughness = 1.6,
  }) {
    return DynamicShapeConfig(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.handDrawn,
      handDrawnRoughness: roughness,
    );
  }

  /// Preset for a chiseled 3D embossed border with directional lighting.
  factory DynamicShapeConfig.embossed({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
    double lightAngle = 0.7853981633974483,
  }) {
    return DynamicShapeConfig(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.embossed,
      embossLightAngle: lightAngle,
    );
  }

  /// Preset for a tactile stippled noise textured border.
  factory DynamicShapeConfig.noiseTextured({
    DynamicShapeType type = DynamicShapeType.smoothRounded,
    double cornerRadius = 24.0,
  }) {
    return DynamicShapeConfig(
      type: type,
      cornerRadius: cornerRadius,
      borderStyle: BorderStyleType.noiseTextured,
    );
  }

  DynamicShapeConfig copyWith({
    DynamicShapeType? type,
    BorderStyleType? borderStyle,
    double? cornerRadius,
    CornerRadii? cornerRadii,
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
    Path Function(Size size)? customBezierBuilder,
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
  }) {
    return DynamicShapeConfig(
      type: type ?? this.type,
      borderStyle: borderStyle ?? this.borderStyle,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      cornerRadii: cornerRadii ?? this.cornerRadii,
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
      rotation: rotation ?? this.rotation,
      scaleX: scaleX ?? this.scaleX,
      scaleY: scaleY ?? this.scaleY,
      stretchOffset: stretchOffset ?? this.stretchOffset,
      customBezierBuilder: customBezierBuilder ?? this.customBezierBuilder,
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
    );
  }
}
