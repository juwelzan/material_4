import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../liquid_glass/constants/glass_defaults.dart';
import '../liquid_glass/src/engine/glass_glow.dart';
import '../liquid_glass/src/engine/liquid_glass_settings.dart';
import '../liquid_glass/src/engine/liquid_shape.dart';
import '../liquid_glass/src/engine/stretch.dart';
import '../liquid_glass/theme/glass_theme.dart';
import '../liquid_glass/theme/glass_theme_helpers.dart';
import '../liquid_glass/types/glass_quality.dart';
import '../liquid_glass/widgets/shared/adaptive_glass.dart';
import '../material_4_config.dart';
import '../material_4_path_builder.dart';

/// Liquid-glass surface for [Material4Container].
///
/// Puts real liquid glass (refraction, blur, saturation, specular rim,
/// chromatic aberration) behind the container's content and gives it the same
/// touch behaviour as iOS 26 glass: the surface inflates and stretches toward
/// the finger, brightens while pressed, and a soft glow follows the pointer.
///
/// ## The same on every platform
///
/// The glass picks the best renderer each device supports and keeps the look
/// and behaviour consistent:
///
/// | Platform | Renderer |
/// |---|---|
/// | iOS, macOS, Android (Impeller) | premium refraction shader |
/// | Web, Windows, Linux, devices without shader filters | lightweight glass shader |
/// | Low-power / adaptive downgrade / reduce-transparency | blur + saturation + rim fallback |
///
/// Interaction (stretch, press growth, glow, springs) is plain Dart animation,
/// so it behaves identically everywhere. Reduce-motion turns the stretch off.
///
/// ## Shapes
///
/// Rounded presets (`smoothRounded`, `squircle`, `continuousSquircle`,
/// `capsule`) map to the shader's native shapes and look exactly like iOS
/// glass, including its outer shadow. Every other preset and every
/// `customShape` is rendered as glass clipped to the container's own path, and
/// a specular rim is painted along that path from the same light angle, so the
/// highlight follows stars, hexagons, tickets and so on.
///
/// Keep the container's own `color` / `background` translucent (or unset) so
/// the glass stays visible.
@immutable
class Material4LiquidGlass {
  /// Glass appearance: thickness, blur, refraction, light angle and
  /// intensity, tint (`glassColor`), saturation, chromatic aberration...
  /// When null the ambient `GlassTheme` (or package defaults) applies.
  final LiquidGlassSettings? settings;

  /// Rendering tier. When null the ambient theme decides; the platform cap
  /// and adaptive scope may lower it on devices that can't run it.
  final GlassQuality? quality;

  /// Force a specific shader shape instead of the automatic mapping. Use this
  /// only when it matches the container's geometry.
  final LiquidShape? glassShape;

  /// iOS touch behaviour (press inflation, stretch toward the finger, press
  /// brightening, pointer glow). `null` turns it on exactly when the container
  /// has `onTap`, `onLongPress` or `onDoubleTap`.
  final bool? interactive;

  /// Scale reached while pressed. `null` uses iOS's native press growth.
  final double? interactionScale;

  /// How far the surface follows a drag (0 disables the stretch).
  final double stretch;

  /// Drag resistance; higher values stretch less.
  final double resistance;

  /// Colour of the pointer glow. `null` uses the native iOS sheen.
  final Color? glowColor;

  /// Glow radius relative to the surface. `null` uses the native 1.6;
  /// `0` disables the pointer glow.
  final double? glowRadius;

  /// Paint a specular rim along non-native shapes (stars, tickets...).
  final bool specularRim;

  /// Rim stroke width in logical pixels.
  final double rimWidth;

  /// Render in a dedicated layer instead of joining an enclosing glass layer.
  /// Explicit [settings] always render in their own layer (otherwise an
  /// enclosing layer would override them), so this only matters without them.
  final bool useOwnLayer;

  /// Whether nested glass may lift (extra density) over an ancestor's blur.
  final bool allowElevation;

  /// Use the live backdrop path, needed for glass over platform views such
  /// as maps or web views.
  final bool platformViewBackdrop;

  const Material4LiquidGlass({
    this.settings,
    this.quality,
    this.glassShape,
    this.interactive,
    this.interactionScale,
    this.stretch = 0.5,
    this.resistance = 0.01,
    this.glowColor,
    this.glowRadius,
    this.specularRim = true,
    this.rimWidth = 1.2,
    this.useOwnLayer = false,
    this.allowElevation = true,
    this.platformViewBackdrop = false,
  });

  /// A static (non-interactive) glass panel, like iOS sheets and cards.
  const Material4LiquidGlass.panel({
    LiquidGlassSettings? settings,
    GlassQuality? quality,
    bool specularRim = true,
  }) : this(
          settings: settings,
          quality: quality,
          specularRim: specularRim,
          interactive: false,
        );

  /// An interactive glass control, like iOS buttons and pills.
  const Material4LiquidGlass.control({
    LiquidGlassSettings? settings,
    GlassQuality? quality,
    double? interactionScale,
    double stretch = 0.5,
    Color? glowColor,
  }) : this(
          settings: settings,
          quality: quality,
          interactionScale: interactionScale,
          stretch: stretch,
          glowColor: glowColor,
          interactive: true,
        );

  /// The shader shape that reproduces [config] exactly, or null when the
  /// geometry has no native equivalent and must be clipped.
  ///
  /// No size is needed: the shader clamps every radius to half the shortest
  /// side, so a huge radius yields an exact capsule at any size.
  LiquidShape? nativeShapeFor(Material4Config config) {
    if (glassShape != null) return glassShape;
    if (config.customShape != null ||
        config.notches != null ||
        config.edges != null ||
        config.corners != null ||
        config.transform != null) {
      return null;
    }
    switch (config.type) {
      case Material4Type.smoothRounded:
      case Material4Type.squircle:
      case Material4Type.continuousSquircle:
        return LiquidRoundedSuperellipse(borderRadius: config.cornerRadius);
      case Material4Type.capsule:
        return const LiquidRoundedSuperellipse(
          borderRadius: GlassDefaults.maxSafeRadius,
        );
      default:
        return null;
    }
  }

  Material4LiquidGlass copyWith({
    LiquidGlassSettings? settings,
    GlassQuality? quality,
    LiquidShape? glassShape,
    bool? interactive,
    double? interactionScale,
    double? stretch,
    double? resistance,
    Color? glowColor,
    double? glowRadius,
    bool? specularRim,
    double? rimWidth,
    bool? useOwnLayer,
    bool? allowElevation,
    bool? platformViewBackdrop,
  }) {
    return Material4LiquidGlass(
      settings: settings ?? this.settings,
      quality: quality ?? this.quality,
      glassShape: glassShape ?? this.glassShape,
      interactive: interactive ?? this.interactive,
      interactionScale: interactionScale ?? this.interactionScale,
      stretch: stretch ?? this.stretch,
      resistance: resistance ?? this.resistance,
      glowColor: glowColor ?? this.glowColor,
      glowRadius: glowRadius ?? this.glowRadius,
      specularRim: specularRim ?? this.specularRim,
      rimWidth: rimWidth ?? this.rimWidth,
      useOwnLayer: useOwnLayer ?? this.useOwnLayer,
      allowElevation: allowElevation ?? this.allowElevation,
      platformViewBackdrop: platformViewBackdrop ?? this.platformViewBackdrop,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4LiquidGlass &&
          settings == other.settings &&
          quality == other.quality &&
          glassShape == other.glassShape &&
          interactive == other.interactive &&
          interactionScale == other.interactionScale &&
          stretch == other.stretch &&
          resistance == other.resistance &&
          glowColor == other.glowColor &&
          glowRadius == other.glowRadius &&
          specularRim == other.specularRim &&
          rimWidth == other.rimWidth &&
          useOwnLayer == other.useOwnLayer &&
          allowElevation == other.allowElevation &&
          platformViewBackdrop == other.platformViewBackdrop;

  @override
  int get hashCode => Object.hash(
        settings,
        quality,
        glassShape,
        interactive,
        interactionScale,
        stretch,
        resistance,
        glowColor,
        glowRadius,
        specularRim,
        rimWidth,
        useOwnLayer,
        allowElevation,
        platformViewBackdrop,
      );
}

/// Renders [child] on a [Material4LiquidGlass] surface shaped by [config].
///
/// Mirrors the composition the iOS glass controls use
/// (`LiquidStretch` → `AdaptiveGlass` → `GlassGlow`) so a container behaves
/// like native glass on every platform.
class Material4LiquidGlassSurface extends StatefulWidget {
  final Material4LiquidGlass glass;
  final Material4Config config;
  final bool hasTapHandler;
  final Widget child;

  const Material4LiquidGlassSurface({
    super.key,
    required this.glass,
    required this.config,
    required this.child,
    this.hasTapHandler = false,
  });

  @override
  State<Material4LiquidGlassSurface> createState() =>
      _Material4LiquidGlassSurfaceState();
}

class _Material4LiquidGlassSurfaceState
    extends State<Material4LiquidGlassSurface>
    with SingleTickerProviderStateMixin {
  // Press brightening: up over ~150 ms, gone ~60 ms after lift-off (iOS).
  late final AnimationController _press = AnimationController(
    duration: GlassDefaults.ambientLiftDuration,
    reverseDuration: GlassDefaults.ambientLiftReverseDuration,
    vsync: this,
  );
  late final Animation<double> _pressCurve =
      CurvedAnimation(parent: _press, curve: Curves.easeOut);

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  bool get _interactive => widget.glass.interactive ?? widget.hasTapHandler;

  @override
  Widget build(BuildContext context) {
    final glass = widget.glass;
    final config = widget.config;
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final interactive = _interactive;

    final quality =
        GlassThemeHelpers.resolveQuality(context, widgetQuality: glass.quality);
    final settings =
        GlassThemeHelpers.resolveSettings(context, explicit: glass.settings);
    // Explicit settings are ignored by an enclosing grouped layer, so they
    // always get their own layer; interactive glass does too (as on iOS).
    final ownLayer = glass.useOwnLayer || glass.settings != null || interactive;
    // On the minimal tier the engine removes the backdrop blur from
    // interactive surfaces, because a BackdropFilter whose bounds spring can
    // flicker there. That leaves a flat tint that no longer reads as glass,
    // so on minimal we keep the blur and drop the stretch (the bounds change)
    // instead; press brightening and the pointer glow stay.
    final minimalTier = quality == GlassQuality.minimal;

    final native = glass.nativeShapeFor(config);
    final clipper = native == null ? _Material4PathClipper(config) : null;
    final shaderShape =
        native ?? LiquidRoundedRectangle(borderRadius: config.cornerRadius);

    Widget content = widget.child;

    if (native == null && glass.specularRim) {
      content = CustomPaint(
        foregroundPainter: _SpecularRimPainter(
          config: config,
          lightAngle: settings.lightAngle,
          intensity: settings.effectiveLightIntensity.clamp(0.0, 1.0),
          width: glass.rimWidth,
        ),
        child: content,
      );
    }

    if (interactive && glass.glowRadius != 0) {
      final isDark = GlassTheme.brightnessOf(context) == Brightness.dark;
      content = GlassGlow(
        clipper: clipper ?? ShapeBorderClipper(shape: shaderShape),
        glowColor: glass.glowColor ??
            (isDark ? const Color(0x12FFFFFF) : const Color(0x1AFFFFFF)),
        glowRadius: glass.glowRadius ?? 1.6,
        glowBlurRadius: 16.0,
        hitTestBehavior: HitTestBehavior.translucent,
        child: content,
      );
    }

    final double headroom = ownLayer && interactive
        ? (LiquidStretch.nativePressGrowth / 2 + 8).ceilToDouble()
        : 0.0;

    Widget surface = interactive
        ? AnimatedBuilder(
            animation: _pressCurve,
            child: content,
            builder: (context, child) => _glass(
              shaderShape,
              settings,
              quality,
              ownLayer,
              headroom,
              _pressCurve.value,
              !minimalTier,
              child!,
            ),
          )
        : _glass(shaderShape, settings, quality, ownLayer, headroom, 0.0, false,
            content);

    if (clipper != null) {
      surface = ClipPath(
        clipper: clipper,
        clipBehavior: Clip.antiAlias,
        child: surface,
      );
    }

    if (!interactive) return surface;

    final stretchy = !reduceMotion && !minimalTier && glass.stretch > 0;
    if (stretchy) {
      surface = LiquidStretch(
        interactionScale: glass.interactionScale ?? 1.0,
        pressGrowth: glass.interactionScale == null
            ? LiquidStretch.nativePressGrowth
            : null,
        stretch: glass.stretch,
        resistance: glass.resistance,
        hitTestBehavior: HitTestBehavior.translucent,
        anchorStretchSettings: AnchorStretchSettings.nativeTremor,
        child: surface,
      );
    }
    // A stretching premium layer must not be cached in a RepaintBoundary
    // (scaling the baked texture blurs its edges); the lightweight shader
    // re-renders inside one at full resolution.
    final skipBoundary = quality == GlassQuality.minimal ||
        (quality == GlassQuality.premium && stretchy);
    if (!skipBoundary) surface = RepaintBoundary(child: surface);

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _press.forward(),
      onPointerUp: (_) => _press.reverse(),
      onPointerCancel: (_) => _press.reverse(),
      child: surface,
    );
  }

  Widget _glass(
    LiquidShape shape,
    LiquidGlassSettings settings,
    GlassQuality quality,
    bool ownLayer,
    double headroom,
    double glow,
    bool interactive,
    Widget child,
  ) {
    return AdaptiveGlass(
      shape: shape,
      settings: settings,
      quality: quality,
      useOwnLayer: ownLayer,
      allowElevation: widget.glass.allowElevation,
      glowIntensity: glow,
      isInteractive: interactive,
      platformViewBackdrop: widget.glass.platformViewBackdrop,
      clipExpansion: EdgeInsets.all(headroom),
      child: child,
    );
  }
}

class _Material4PathClipper extends CustomClipper<Path> {
  final Material4Config config;
  const _Material4PathClipper(this.config);

  @override
  Path getClip(Size size) => Material4PathBuilder.buildPath(size, config);

  @override
  bool shouldReclip(_Material4PathClipper oldClipper) =>
      oldClipper.config != config;
}

/// Specular rim drawn along an arbitrary path, lit from the shader's light
/// direction `(cos a, -sin a)`: bright on the lit edge, a dimmer counter-light
/// on the opposite edge, clear in between — the iOS glass edge highlight.
class _SpecularRimPainter extends CustomPainter {
  final Material4Config config;
  final double lightAngle;
  final double intensity;
  final double width;

  const _SpecularRimPainter({
    required this.config,
    required this.lightAngle,
    required this.intensity,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || width <= 0 || intensity <= 0) return;
    final path = Material4PathBuilder.buildPath(size, config);
    final dir = Alignment(math.cos(lightAngle), -math.sin(lightAngle));
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..shader = LinearGradient(
        begin: dir,
        end: -dir,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.75 * intensity),
          const Color(0x00FFFFFF),
          const Color(0x00FFFFFF),
          const Color(0xFFFFFFFF).withValues(alpha: 0.35 * intensity),
        ],
        stops: const [0.0, 0.35, 0.7, 1.0],
      ).createShader(rect);
    // Inside-aligned so the rim sits on the glass, not over the border.
    canvas.save();
    canvas.clipPath(path);
    canvas.drawPath(path, paint..strokeWidth = width * 2);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SpecularRimPainter old) =>
      old.config != config ||
      old.lightAngle != lightAngle ||
      old.intensity != intensity ||
      old.width != width;
}
