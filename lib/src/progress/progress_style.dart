/// Comprehensive style collection for [Material4ProgressBar].
///
/// Categorized into three major domains:
/// - **Linear Styles**: Straight, horizontal or vertical progress tracks and fills.
/// - **Circular & Ring Styles**: Radial, arc, ring, and concentric circle indicators.
/// - **Creative & Organic Styles**: Wave, liquid, particle, equalizer, morphing, and sculpted indicators.
enum Material4ProgressStyle {
  // =========================================================================
  // 1. Linear Progress Styles
  // =========================================================================

  /// Classic straight linear progress bar with sharp rectangular ends.
  classicLinear,

  /// Linear progress bar with smooth rounded corner fillets.
  roundedLinear,

  /// Full capsule/pill progress bar with semicircular end caps.
  capsuleLinear,

  /// High-emphasis heavy-gauge linear progress bar with substantial height.
  thickLinear,

  /// Ultra-slim, subtle minimal progress hairline.
  thinLinear,

  /// Smooth multi-stop gradient transition along the filled progression.
  gradientLinear,

  /// Discretized segmented linear bar split into distinct partitioned steps.
  segmentedLinear,

  /// Multi-color progress track with color-shifting threshold checkpoints.
  multiColorLinear,

  /// Diagonal barber-pole striped textured progress fill.
  stripedLinear,

  /// Continuously scrolling diagonal striped progress fill.
  animatedStripedLinear,

  /// Sinusoidal oscillating wave crest flowing along the filled progression.
  waveLinear,

  /// Dynamic fluid liquid fill with animated surface meniscus and micro-bubbles.
  liquidLinear,

  /// Organic asymmetrical curved contours along the progress boundaries.
  organicEdgeLinear,

  /// Asymmetrically sculpted corner profile (e.g. sharp top-left, pill bottom-right).
  asymmetricLinear,

  /// 3D beveled and sculpted surface elevation with light-catching edge highlights.
  sculptedLinear,

  /// Dual-layered stacked linear progress showing background buffer and primary fill.
  doubleLayerLinear,

  /// Soft ambient colored luminescent halo cast around the progress fill.
  glowLinear,

  /// High-intensity fluorescent neon laser tube with saturated core and glow plume.
  neonLinear,

  /// Frosted glassmorphism progress track with background blur and specular border.
  glassLinear,

  /// Elevated progress track casting deep soft drop shadows above the background.
  floatingLinear,

  // =========================================================================
  // 2. Circular & Ring Progress Styles
  // =========================================================================

  /// Standard circular radial stroke with flat caps.
  classicCircular,

  /// Circular arc with smooth rounded spherical end caps.
  roundedCircular,

  /// Clean hollow ring with consistent radial track gauge.
  ring,

  /// Ultra-delicate thin circular track with crisp hairline stroke.
  thinRing,

  /// Bold chunky circular ring with substantial radial thickness.
  thickRing,

  /// Continuous sweeping chromatic angular gradient around the circular perimeter.
  gradientRing,

  /// Dual concentric rings displaying secondary buffer and primary value.
  dualRing,

  /// Multi-tiered concentric track arcs displaying multi-metric progress.
  multiRing,

  /// Segmented circular ring partitioned into discrete radial dashes/blocks.
  segmentedRing,

  /// Circular ring rendered as a sequence of discrete round radial dots.
  dottedRing,

  /// Circular ring rendered as a sequence of alternating dashes and gaps.
  dashedRing,

  /// High-voltage neon plasma circular tube with vivid chromatic luminescence.
  neonRing,

  /// Diffuse ambient luminous halo radiating outward from the circular fill.
  glowRing,

  /// Continuously orbiting and pulsing animated ring.
  animatedRing,

  /// Open partial circular arc (e.g. 240° speedometer gauge).
  partialArc,

  /// Dual opposing partial arcs that meet or expand symmetrically.
  doubleArc,

  /// Multi-stage concentric circles that expand outward as progress increments.
  concentricCircle,

  /// Non-circular fluid organic contour perimeter following a circular trajectory.
  organicCircular,

  // =========================================================================
  // 3. Creative & Organic Progress Styles
  // =========================================================================

  /// Full-surface fluid liquid chamber with viscous undulating wave surface.
  liquid,

  /// Horizontal or vertical harmonic wave flowing across the container.
  wave,

  /// Playful asymmetrical organic fluid blob that expands with progress.
  blob,

  /// Vector geometry morphing continuously between geometric & organic shapes.
  morphing,

  /// High-viscosity flowing fluid with surface tension effects.
  fluid,

  /// Effervescent bubble column rising through the filled reservoir.
  bubble,

  /// Orbiting celestial satellite satellite traversing a circular or elliptical path.
  orbit,

  /// Swarm of luminous micro-particles moving towards the progress threshold.
  particle,

  /// Concentric expanding water ripples pulsing outward from the core.
  ripple,

  /// Rhythmic expanding and contracting breathing pulse indicator.
  pulse,

  /// Archimedean spiral unwinding from center outwards.
  spiral,

  /// 2D rectangular dot matrix grid illuminated column by column.
  dotMatrix,

  /// Audio synthesizer graphic equalizer vertical bar spectrum analyzer.
  equalizer,

  /// Multi-stop sequential milestone step indicator connected by bridges.
  step,

  /// Chronological milestone timeline progress with illuminated nodes.
  timeline,

  /// Segmented circular disc partitioned like pie slices.
  circularSegmented,

  /// Arbitrary organic vector shape (flower, star, cloud) filling progressively.
  organicShape,

  /// Sculpted 3D embossed container with light-reactive specular depth.
  sculptedSurface;

  /// Whether this style renders in a linear (straight-line) configuration.
  bool get isLinear => switch (this) {
        classicLinear ||
        roundedLinear ||
        capsuleLinear ||
        thickLinear ||
        thinLinear ||
        gradientLinear ||
        segmentedLinear ||
        multiColorLinear ||
        stripedLinear ||
        animatedStripedLinear ||
        waveLinear ||
        liquidLinear ||
        organicEdgeLinear ||
        asymmetricLinear ||
        sculptedLinear ||
        doubleLayerLinear ||
        glowLinear ||
        neonLinear ||
        glassLinear ||
        floatingLinear =>
          true,
        _ => false,
      };

  /// Whether this style renders in a circular or radial ring configuration.
  bool get isCircular => switch (this) {
        classicCircular ||
        roundedCircular ||
        ring ||
        thinRing ||
        thickRing ||
        gradientRing ||
        dualRing ||
        multiRing ||
        segmentedRing ||
        dottedRing ||
        dashedRing ||
        neonRing ||
        glowRing ||
        animatedRing ||
        partialArc ||
        doubleArc ||
        concentricCircle ||
        organicCircular ||
        circularSegmented =>
          true,
        _ => false,
      };

  /// Whether this style renders as an organic, fluid, wave, or creative indicator.
  bool get isCreative => switch (this) {
        liquid ||
        wave ||
        blob ||
        morphing ||
        fluid ||
        bubble ||
        orbit ||
        particle ||
        ripple ||
        pulse ||
        spiral ||
        dotMatrix ||
        equalizer ||
        step ||
        timeline ||
        organicShape ||
        sculptedSurface =>
          true,
        _ => false,
      };

  /// Whether this style involves fluid wave dynamics.
  bool get isWaveOrLiquid => switch (this) {
        waveLinear || liquidLinear || liquid || wave || fluid || bubble => true,
        _ => false,
      };

  /// Whether this style involves segmented or stepped blocks.
  bool get isSegmented => switch (this) {
        segmentedLinear ||
        segmentedRing ||
        circularSegmented ||
        dotMatrix ||
        equalizer ||
        step ||
        timeline =>
          true,
        _ => false,
      };

  /// Whether this style involves dotted or dashed stroke patterns.
  bool get isDottedOrDashed => switch (this) {
        dottedRing || dashedRing || dotMatrix => true,
        _ => false,
      };

  /// Whether this style features high-intensity luminescence or neon glows.
  bool get isNeonOrGlow => switch (this) {
        glowLinear || neonLinear || neonRing || glowRing => true,
        _ => false,
      };
}
