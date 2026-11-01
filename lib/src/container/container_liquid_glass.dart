import 'package:flutter/widgets.dart';

import '../liquid_glass/src/engine/liquid_shape.dart';
import '../liquid_glass/src/renderer/liquid_glass_renderer.dart'
    show LiquidGlassSettings;
import '../liquid_glass/types/glass_quality.dart';

/// Liquid-glass surface for [Material4Container].
///
/// Puts the real liquid-glass effect (refraction, blur, specular rim,
/// chromatic aberration) behind the container's content and clips it to the
/// container's own shape, preset or custom. Every visual property of the glass
/// comes from the arguments below, so the look is entirely up to the developer.
///
/// The liquid shader draws only signed-distance shapes ([LiquidShape]), so for
/// any other geometry the glass is drawn as [glassShape] and then clipped to
/// the container's path. The container's `border:` still follows that path
/// exactly, so the outline and the clipped glass match.
///
/// Keep the container's own `color`/`background` translucent (or unset) so the
/// glass stays visible underneath.
@immutable
class Material4LiquidGlass {
  /// Full liquid-glass appearance: thickness, blur, refraction, light angle,
  /// glass tint, saturation, chromatic aberration, and so on. When null the
  /// ambient `GlassTheme` / defaults apply.
  final LiquidGlassSettings? settings;

  /// Rendering quality tier (for example premium or standard). When null the
  /// ambient default is used.
  final GlassQuality? quality;

  /// Signed-distance shape the shader renders before the container's path
  /// clips it. Defaults to a rounded rectangle that uses the container's
  /// `config.cornerRadius`, which matches the rounded presets closely.
  final LiquidShape? glassShape;

  /// Optional tint painted inside the glass.
  final Color? color;

  /// Strength of the touch-driven glow (0 disables it).
  final double glowIntensity;

  /// Whether the glass renders in its own layer instead of joining an
  /// enclosing `LiquidGlassLayer` / blend group.
  final bool useOwnLayer;

  /// Whether the glass may lift (scale/shadow) on interaction.
  final bool allowElevation;

  /// Use a platform-view backdrop (for glass over native views such as maps).
  final bool platformViewBackdrop;

  const Material4LiquidGlass({
    this.settings,
    this.quality,
    this.glassShape,
    this.color,
    this.glowIntensity = 0.0,
    this.useOwnLayer = false,
    this.allowElevation = false,
    this.platformViewBackdrop = false,
  });

  /// The [LiquidShape] to render for a container with [cornerRadius].
  LiquidShape resolveShape(double cornerRadius) =>
      glassShape ?? LiquidRoundedRectangle(borderRadius: cornerRadius);

  Material4LiquidGlass copyWith({
    LiquidGlassSettings? settings,
    GlassQuality? quality,
    LiquidShape? glassShape,
    Color? color,
    double? glowIntensity,
    bool? useOwnLayer,
    bool? allowElevation,
    bool? platformViewBackdrop,
  }) {
    return Material4LiquidGlass(
      settings: settings ?? this.settings,
      quality: quality ?? this.quality,
      glassShape: glassShape ?? this.glassShape,
      color: color ?? this.color,
      glowIntensity: glowIntensity ?? this.glowIntensity,
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
          color == other.color &&
          glowIntensity == other.glowIntensity &&
          useOwnLayer == other.useOwnLayer &&
          allowElevation == other.allowElevation &&
          platformViewBackdrop == other.platformViewBackdrop;

  @override
  int get hashCode => Object.hash(settings, quality, glassShape, color,
      glowIntensity, useOwnLayer, allowElevation, platformViewBackdrop);
}
