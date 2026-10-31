import 'package:flutter/material.dart';

import '../container/container_background.dart';
import '../container/container_border.dart';
import '../container/container_texture.dart';
import '../container/custom_shape.dart';
import '../material_4_config.dart';
import 'button_animation.dart';

/// Predefined and customizable stylistic configuration preset for [Material4Button].
@immutable
class Material4ButtonPreset {
  final String name;
  final Material4Type? shape;
  final Material4CustomShape? customShape;
  final Material4Background background;
  final Material4Border border;
  final Material4ButtonAnimation animation;
  final Color foregroundColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final double elevation;

  const Material4ButtonPreset({
    this.name = 'custom',
    this.shape,
    this.customShape,
    this.background = const Material4Background(),
    this.border = const Material4Border(),
    this.animation = const Material4ButtonAnimation(),
    this.foregroundColor = Colors.white,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.elevation = 0.0,
  });

  /// Primary action button with prominent brand indigo gradient fill and smooth rounded shape.
  static const Material4ButtonPreset primary = Material4ButtonPreset(
    name: 'primary',
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Color(0xFF4F46E5),
      shadows: [
        BoxShadow(color: Color(0x334F46E5), blurRadius: 12, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation.subtle,
    elevation: 2.0,
  );

  /// Secondary action button with neutral slate styling.
  static const Material4ButtonPreset secondary = Material4ButtonPreset(
    name: 'secondary',
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Color(0xFFF1F5F9),
    ),
    border: Material4Border.solid(
      color: Color(0xFFCBD5E1),
      width: 1.2,
    ),
    foregroundColor: Color(0xFF1E293B),
    animation: Material4ButtonAnimation.subtle,
  );

  /// Tertiary action button with transparent background.
  static const Material4ButtonPreset tertiary = Material4ButtonPreset(
    name: 'tertiary',
    shape: Material4Type.smoothRounded,
    background: Material4Background(color: Colors.transparent),
    border: Material4Border.none,
    foregroundColor: Color(0xFF6366F1),
    animation: Material4ButtonAnimation(
      press: ButtonPressAnimation.scaleDown,
      hover: ButtonHoverAnimation.glow,
      hoverLift: 0.0,
      pressScale: 0.96,
    ),
  );

  /// Outlined button with crisp vector border stroke.
  static const Material4ButtonPreset outlined = Material4ButtonPreset(
    name: 'outlined',
    shape: Material4Type.smoothRounded,
    background: Material4Background(color: Colors.transparent),
    border: Material4Border.solid(
      color: Color(0xFF6366F1),
      width: 1.5,
    ),
    foregroundColor: Color(0xFF6366F1),
    animation: Material4ButtonAnimation.subtle,
  );

  /// Text-only minimal button.
  static const Material4ButtonPreset text = Material4ButtonPreset(
    name: 'text',
    shape: Material4Type.smoothRounded,
    background: Material4Background(color: Colors.transparent),
    border: Material4Border.none,
    foregroundColor: Color(0xFF4F46E5),
    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    animation: Material4ButtonAnimation(
      press: ButtonPressAnimation.scaleDown,
      hover: ButtonHoverAnimation.none,
      tap: ButtonTapAnimation.ripple,
      pressScale: 0.96,
    ),
  );

  /// Elevated button with rich multi-tier drop shadows and hover lift.
  static const Material4ButtonPreset elevated = Material4ButtonPreset(
    name: 'elevated',
    shape: Material4Type.squircle,
    background: Material4Background(
      color: Color(0xFF4F46E5),
      shadows: [
        BoxShadow(color: Color(0x33000000), blurRadius: 14, offset: Offset(0, 6)),
        BoxShadow(color: Color(0x224F46E5), blurRadius: 20, offset: Offset(0, 8)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation(
      press: ButtonPressAnimation.depthPress,
      hover: ButtonHoverAnimation.liftUp,
      hoverLift: -3.0,
    ),
    elevation: 4.0,
  );

  /// Vibrant chromatic multi-stop gradient button.
  static const Material4ButtonPreset gradient = Material4ButtonPreset(
    name: 'gradient',
    shape: Material4Type.continuousSquircle,
    background: Material4Background(
      gradient: LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shadows: [
        BoxShadow(color: Color(0x40EC4899), blurRadius: 16, offset: Offset(0, 6)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation(
      press: ButtonPressAnimation.elastic,
      hover: ButtonHoverAnimation.gradientMovement,
      tap: ButtonTapAnimation.particleBurst,
      pressScale: 0.94,
    ),
  );

  /// Glassmorphic button with frosted glass blur and semi-transparent tint.
  static const Material4ButtonPreset glass = Material4ButtonPreset(
    name: 'glass',
    shape: Material4Type.squircle,
    background: Material4Background(
      isGlassmorphic: true,
      glassBlur: 16.0,
      glassTint: Color(0x28FFFFFF),
      shadows: [
        BoxShadow(color: Color(0x18000000), blurRadius: 12, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.solid(
      color: Color(0x50FFFFFF),
      width: 1.2,
      strokeAlign: ShapeStrokeAlign.inside,
    ),
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation(
      press: ButtonPressAnimation.scaleDown,
      hover: ButtonHoverAnimation.glow,
      tap: ButtonTapAnimation.glowPulse,
    ),
  );

  /// Cyberpunk luminous neon button with pulsing ambient bloom.
  static const Material4ButtonPreset neon = Material4ButtonPreset(
    name: 'neon',
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Color(0xFF0F172A),
      shadows: [
        BoxShadow(color: Color(0x4000E5FF), blurRadius: 18, offset: Offset(0, 2)),
      ],
    ),
    border: Material4Border.neon(
      color: Color(0xFF00E5FF),
      width: 2.0,
      glowIntensity: 1.8,
      blurRadius: 12.0,
      animated: true,
    ),
    foregroundColor: Color(0xFF00E5FF),
    animation: Material4ButtonAnimation.neon,
  );

  /// Sculpted organic button with authentic paper texture.
  static const Material4ButtonPreset organic = Material4ButtonPreset(
    name: 'organic',
    shape: Material4Type.organicBlob,
    background: Material4Background(
      color: Color(0xFFFFFBEB),
      texture: Material4Texture.paper(opacity: 0.25),
      shadows: [
        BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.solid(
      color: Color(0xFFD97706),
      width: 1.5,
    ),
    foregroundColor: Color(0xFF92400E),
    animation: Material4ButtonAnimation(
      press: ButtonPressAnimation.spring,
      hover: ButtonHoverAnimation.shapeMorph,
      tap: ButtonTapAnimation.liquidRipple,
    ),
  );

  /// Hydrodynamic fluid wave button.
  static const Material4ButtonPreset liquid = Material4ButtonPreset(
    name: 'liquid',
    shape: Material4Type.liquid,
    background: Material4Background(
      gradient: LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shadows: [
        BoxShadow(color: Color(0x3306B6D4), blurRadius: 14, offset: Offset(0, 6)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation.fluid,
  );

  /// Floating Action Button (FAB) preset.
  static const Material4ButtonPreset floating = Material4ButtonPreset(
    name: 'floating',
    shape: Material4Type.capsule,
    background: Material4Background(
      color: Color(0xFF6366F1),
      shadows: [
        BoxShadow(color: Color(0x406366F1), blurRadius: 18, offset: Offset(0, 8)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    animation: Material4ButtonAnimation(
      press: ButtonPressAnimation.scaleDown,
      hover: ButtonHoverAnimation.liftUp,
      hoverLift: -4.0,
      pressScale: 0.94,
    ),
    elevation: 6.0,
  );

  /// Tactile 3D button compressing physically on keypress.
  static const Material4ButtonPreset threeD = Material4ButtonPreset(
    name: 'threeD',
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Color(0xFF4F46E5),
      shadows: [
        BoxShadow(color: Color(0xFF3730A3), blurRadius: 0, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation.threeD,
  );

  /// Success state confirmation button preset.
  static const Material4ButtonPreset success = Material4ButtonPreset(
    name: 'success',
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Color(0xFF10B981),
      shadows: [
        BoxShadow(color: Color(0x3310B981), blurRadius: 12, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation.subtle,
  );

  /// Destructive or high-urgency danger button preset.
  static const Material4ButtonPreset danger = Material4ButtonPreset(
    name: 'danger',
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Color(0xFFEF4444),
      shadows: [
        BoxShadow(color: Color(0x33EF4444), blurRadius: 12, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation.subtle,
  );

  /// Warning or caution action button preset.
  static const Material4ButtonPreset warning = Material4ButtonPreset(
    name: 'warning',
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Color(0xFFF59E0B),
      shadows: [
        BoxShadow(color: Color(0x33F59E0B), blurRadius: 12, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Color(0xFF451A03),
    animation: Material4ButtonAnimation.subtle,
  );

  /// Informational status button preset.
  static const Material4ButtonPreset info = Material4ButtonPreset(
    name: 'info',
    shape: Material4Type.smoothRounded,
    background: Material4Background(
      color: Color(0xFF0EA5E9),
      shadows: [
        BoxShadow(color: Color(0x330EA5E9), blurRadius: 12, offset: Offset(0, 4)),
      ],
    ),
    border: Material4Border.none,
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation.subtle,
  );

  /// Clean minimalist card-style button preset.
  static const Material4ButtonPreset minimal = Material4ButtonPreset(
    name: 'minimal',
    shape: Material4Type.smoothRounded,
    background: Material4Background(color: Colors.white),
    border: Material4Border.solid(
      color: Color(0xFFE2E8F0),
      width: 1.0,
    ),
    foregroundColor: Color(0xFF0F172A),
    animation: Material4ButtonAnimation.subtle,
  );

  /// High-end metallic gold luxury button preset.
  static const Material4ButtonPreset premium = Material4ButtonPreset(
    name: 'premium',
    shape: Material4Type.continuousSquircle,
    background: Material4Background(
      gradient: LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFD97706), Color(0xFFB45309)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      texture: Material4Texture.metallicFoil(opacity: 0.35),
      shadows: [
        BoxShadow(color: Color(0x33D97706), blurRadius: 16, offset: Offset(0, 6)),
      ],
    ),
    border: Material4Border.shimmer(
      color: Color(0xFFFDE68A),
      width: 1.8,
    ),
    foregroundColor: Colors.white,
    animation: Material4ButtonAnimation.bouncy,
  );

  /// All 18 predefined button presets.
  static const List<Material4ButtonPreset> values = [
    primary,
    secondary,
    tertiary,
    outlined,
    text,
    elevated,
    gradient,
    glass,
    neon,
    organic,
    liquid,
    floating,
    threeD,
    success,
    danger,
    warning,
    info,
    minimal,
    premium,
  ];

  Material4ButtonPreset copyWith({
    String? name,
    Material4Type? shape,
    Material4CustomShape? customShape,
    Material4Background? background,
    Material4Border? border,
    Material4ButtonAnimation? animation,
    Color? foregroundColor,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    double? elevation,
  }) {
    return Material4ButtonPreset(
      name: name ?? this.name,
      shape: shape ?? this.shape,
      customShape: customShape ?? this.customShape,
      background: background ?? this.background,
      border: border ?? this.border,
      animation: animation ?? this.animation,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      elevation: elevation ?? this.elevation,
    );
  }
}

