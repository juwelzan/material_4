import 'package:flutter/material.dart';

import '../creative/paper/paper_background_config.dart';
import '../material_4_config.dart';
import 'container_pattern.dart';
import 'container_texture.dart';

/// Complete multi-layer background configuration for [Material4Container].
///
/// Combines solid fills, gradients, glassmorphism, tactile paper textures,
/// procedural patterns, inner shadows, and dynamic background shader effects.
@immutable
class Material4Background {
  /// Base solid background fill color.
  final Color? color;

  /// Primary surface gradient fill.
  final Gradient? gradient;

  /// Procedural geometric background pattern (stripes, dots, grid, waves, hexagons).
  final Material4Pattern? pattern;

  /// Tactile surface texture (paper, carbon fiber, brushed metal, marble, etc.).
  final Material4Texture? texture;

  /// Dynamic visual background effect (meshGradient, noise, liquidGradient, aurora, etc.).
  final BackgroundEffectType effect;

  /// Corner colors for [BackgroundEffectType.meshGradient].
  final List<Color>? meshColors;

  /// Outer drop shadows or glowing halos.
  final List<BoxShadow>? shadows;

  /// Tactile inset / debossed inner shadows (claymorphic depth).
  final List<BoxShadow>? innerShadows;

  /// Whether frosted glassmorphism is active.
  final bool isGlassmorphic;

  /// Blur sigma for frosted glassmorphism.
  final double glassBlur;

  /// Tint overlay color for frosted glassmorphism.
  final Color? glassTint;

  /// Physical stationery paper material background.
  final PaperBackgroundConfig? paperBackground;

  /// Creative stationery or repeating pattern configuration.
  final CreativePatternConfig? creativePattern;

  const Material4Background({
    this.color,
    this.gradient,
    this.pattern,
    this.texture,
    this.effect = BackgroundEffectType.none,
    this.meshColors,
    this.shadows,
    this.innerShadows,
    this.isGlassmorphic = false,
    this.glassBlur = 16.0,
    this.glassTint,
    this.paperBackground,
    this.creativePattern,
  });

  /// Preset for a clean solid color background.
  const Material4Background.color(
    Color color, {
    List<BoxShadow>? shadows,
    List<BoxShadow>? innerShadows,
  }) : this(color: color, shadows: shadows, innerShadows: innerShadows);

  /// Preset for a linear or radial gradient background.
  const Material4Background.gradient(
    Gradient gradient, {
    List<BoxShadow>? shadows,
    List<BoxShadow>? innerShadows,
  }) : this(gradient: gradient, shadows: shadows, innerShadows: innerShadows);

  /// Preset for frosted glassmorphic background with backdrop blur.
  const Material4Background.glass({
    double blur = 16.0,
    Color tint = const Color(0x28FFFFFF),
    List<BoxShadow>? shadows,
  }) : this(
          isGlassmorphic: true,
          glassBlur: blur,
          glassTint: tint,
          color: tint,
          shadows: shadows,
        );

  /// Preset for a patterned background.
  const Material4Background.pattern(
    Material4Pattern pattern, {
    Color? color,
    Gradient? gradient,
    List<BoxShadow>? shadows,
  }) : this(
          pattern: pattern,
          color: color,
          gradient: gradient,
          shadows: shadows,
        );

  /// Preset for a tactile textured background.
  const Material4Background.texture(
    Material4Texture texture, {
    Color? color,
    Gradient? gradient,
    List<BoxShadow>? shadows,
  }) : this(
          texture: texture,
          color: color,
          gradient: gradient,
          shadows: shadows,
        );

  Material4Background copyWith({
    Color? color,
    Gradient? gradient,
    Material4Pattern? pattern,
    Material4Texture? texture,
    BackgroundEffectType? effect,
    List<Color>? meshColors,
    List<BoxShadow>? shadows,
    List<BoxShadow>? innerShadows,
    bool? isGlassmorphic,
    double? glassBlur,
    Color? glassTint,
    PaperBackgroundConfig? paperBackground,
    CreativePatternConfig? creativePattern,
  }) {
    return Material4Background(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      pattern: pattern ?? this.pattern,
      texture: texture ?? this.texture,
      effect: effect ?? this.effect,
      meshColors: meshColors ?? this.meshColors,
      shadows: shadows ?? this.shadows,
      innerShadows: innerShadows ?? this.innerShadows,
      isGlassmorphic: isGlassmorphic ?? this.isGlassmorphic,
      glassBlur: glassBlur ?? this.glassBlur,
      glassTint: glassTint ?? this.glassTint,
      paperBackground: paperBackground ?? this.paperBackground,
      creativePattern: creativePattern ?? this.creativePattern,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4Background &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          gradient == other.gradient &&
          pattern == other.pattern &&
          texture == other.texture &&
          effect == other.effect &&
          isGlassmorphic == other.isGlassmorphic &&
          glassBlur == other.glassBlur &&
          glassTint == other.glassTint;

  @override
  int get hashCode => Object.hash(
        color,
        gradient,
        pattern,
        texture,
        effect,
        isGlassmorphic,
        glassBlur,
        glassTint,
      );
}

