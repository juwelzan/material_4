import 'package:flutter/material.dart';

import '../material_4_config.dart';
import 'container_animation.dart';
import 'container_background.dart';
import 'container_border.dart';
import 'container_pattern.dart';
import 'container_texture.dart';
import 'custom_shape.dart';

/// Predefined and reusable configuration presets for [Material4Container].
///
/// Encapsulates shape, border, texture, pattern, and animation compositions
/// into standalone styles that can be reused across an entire application.
@immutable
class Material4ContainerPreset {
  final Material4Type? shape;
  final Material4CustomShape? customShape;
  final Material4Background background;
  final Material4Border border;
  final Material4ContainerAnimation? animation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const Material4ContainerPreset({
    this.shape,
    this.customShape,
    this.background = const Material4Background(),
    this.border = const Material4Border(),
    this.animation,
    this.padding,
    this.margin,
  });

  /// Derives an effective [Material4Config] from this preset.
  Material4Config get config => Material4Config(
        type: shape ?? Material4Type.smoothRounded,
        customShape: customShape,
      );

  /// Preset: Frosted Glassmorphic Card.
  static const Material4ContainerPreset glass = Material4ContainerPreset(
    shape: Material4Type.squircle,
    background: Material4Background(
      isGlassmorphic: true,
      glassBlur: 18.0,
      glassTint: Color(0x24FFFFFF),
      shadows: [
        BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 8)),
      ],
    ),
    border: Material4Border.solid(
      color: Color(0x40FFFFFF),
      width: 1.2,
      strokeAlign: ShapeStrokeAlign.inside,
    ),
    padding: EdgeInsets.all(20),
  );

  /// Preset: Cyberpunk Luminous Neon Container.
  static const Material4ContainerPreset neon = Material4ContainerPreset(
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Color(0xFF0F172A),
      shadows: [
        BoxShadow(color: Color(0x3300E5FF), blurRadius: 20, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.neon(
      color: Color(0xFF00E5FF),
      width: 2.0,
      glowIntensity: 1.6,
      blurRadius: 10.0,
      animated: true,
    ),
    animation: Material4ContainerAnimation(
      borderAnimation: true,
      borderSpeed: 1.0,
    ),
    padding: EdgeInsets.all(20),
  );

  /// Preset: Organic Sculpted Notice Board Card.
  static const Material4ContainerPreset organicCard = Material4ContainerPreset(
    shape: Material4Type.organicBlob,
    background: Material4Background(
      color: Color(0xFFFFFFFF),
      texture: Material4Texture.paper(opacity: 0.15),
      shadows: [
        BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 6)),
      ],
    ),
    border: Material4Border.solid(
      color: Color(0xFFE2E8F0),
      width: 1.5,
    ),
    padding: EdgeInsets.all(22),
  );

  /// Preset: High-Tech Twill Carbon Fiber Container.
  static const Material4ContainerPreset carbonTech = Material4ContainerPreset(
    shape: Material4Type.chamferDiagonal,
    background: Material4Background(
      color: Color(0xFF18181B),
      texture: Material4Texture.carbonFiber(opacity: 0.35),
      shadows: [
        BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8)),
      ],
    ),
    border: Material4Border.movingDash(
      color: Color(0xFF38BDF8),
      width: 1.8,
      dashLength: 10.0,
      dashGap: 6.0,
    ),
    animation: Material4ContainerAnimation(
      borderAnimation: true,
      borderSpeed: 1.2,
    ),
    padding: EdgeInsets.all(20),
  );

  /// Preset: Fluid Liquid Wave Container.
  static const Material4ContainerPreset liquid = Material4ContainerPreset(
    shape: Material4Type.waveEdge,
    background: Material4Background(
      gradient: LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      pattern: Material4Pattern.waves(
        color: Color(0x33FFFFFF),
        spacing: 16.0,
        animated: true,
      ),
      shadows: [
        BoxShadow(color: Color(0x2806B6D4), blurRadius: 16, offset: Offset(0, 6)),
      ],
    ),
    border: Material4Border.solid(
      color: Color(0x40FFFFFF),
      width: 1.5,
    ),
    animation: Material4ContainerAnimation(
      patternAnimation: true,
      patternSpeed: 1.0,
    ),
    padding: EdgeInsets.all(20),
  );

  /// Preset: Shifting Holographic Rainbow Foil.
  static const Material4ContainerPreset holographic = Material4ContainerPreset(
    shape: Material4Type.octagon,
    background: Material4Background(
      color: Color(0xFF09090B),
      texture: Material4Texture.holographic(opacity: 0.45, animated: true),
      shadows: [
        BoxShadow(color: Color(0x29FF007F), blurRadius: 18, offset: Offset(0, 8)),
      ],
    ),
    border: Material4Border.rainbow(
      width: 2.2,
      animated: true,
    ),
    animation: Material4ContainerAnimation(
      borderAnimation: true,
      textureAnimation: true,
    ),
    padding: EdgeInsets.all(20),
  );

  /// Preset: Tactile Vintage Paper Craft Card.
  static const Material4ContainerPreset paperCraft = Material4ContainerPreset(
    shape: Material4Type.ticketScallop,
    background: Material4Background(
      color: Color(0xFFFEF3C7),
      texture: Material4Texture.paper(opacity: 0.25),
      pattern: Material4Pattern.grid(
        color: Color(0x1F78350F),
        spacing: 18.0,
      ),
      shadows: [
        BoxShadow(color: Color(0x18000000), blurRadius: 10, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.solid(
      color: Color(0xFFD97706),
      width: 1.5,
    ),
    padding: EdgeInsets.all(20),
  );

  /// Preset: Minimalist Modern Card.
  static const Material4ContainerPreset minimal = Material4ContainerPreset(
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Colors.white,
      shadows: [
        BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 2)),
      ],
    ),
    border: Material4Border.solid(
      color: Color(0xFFE2E8F0),
      width: 1.0,
    ),
    padding: EdgeInsets.all(18),
  );

  Material4ContainerPreset copyWith({
    Material4Type? shape,
    Material4CustomShape? customShape,
    Material4Background? background,
    Material4Border? border,
    Material4ContainerAnimation? animation,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return Material4ContainerPreset(
      shape: shape ?? this.shape,
      customShape: customShape ?? this.customShape,
      background: background ?? this.background,
      border: border ?? this.border,
      animation: animation ?? this.animation,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Material4ContainerPreset &&
          runtimeType == other.runtimeType &&
          shape == other.shape &&
          customShape == other.customShape &&
          background == other.background &&
          border == other.border &&
          animation == other.animation &&
          padding == other.padding &&
          margin == other.margin;

  @override
  int get hashCode => Object.hash(
        shape,
        customShape,
        background,
        border,
        animation,
        padding,
        margin,
      );
}
