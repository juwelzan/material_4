import 'package:flutter/material.dart';

import 'progress_style.dart';
import 'progress_shape.dart';
import 'progress_track.dart';
import 'progress_fill.dart';
import 'progress_effects.dart';
import 'progress_animation.dart';

/// Pre-engineered design system presets for [Material4ProgressBar].
class Material4ProgressPresets {
  /// Minimal, razor-thin progress bar for unobtrusive status indication.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) minimal({Color color = const Color(0xFF2563EB), double height = 4.0}) {
    return (
      style: Material4ProgressStyle.thinLinear,
      shape: Material4ProgressShape.capsule(),
      track: Material4ProgressTrack(
        color: color.withValues(alpha: 0.12),
        thickness: height,
      ),
      fill: Material4ProgressFill(color: color),
      effects: const Material4ProgressEffects(),
      animation: Material4ProgressAnimation.snappy,
    );
  }

  /// Modern capsule progress bar with subtle border and vibrant gradient fill.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) modern({
    List<Color> gradientColors = const [Color(0xFF2563EB), Color(0xFF7C3AED)],
    double height = 10.0,
  }) {
    return (
      style: Material4ProgressStyle.gradientLinear,
      shape: Material4ProgressShape.capsule(),
      track: Material4ProgressTrack(
        color: const Color(0x14000000),
        borderWidth: 1.0,
        borderColor: const Color(0x1F000000),
        thickness: height,
      ),
      fill: Material4ProgressFill(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      effects: const Material4ProgressEffects(),
      animation: Material4ProgressAnimation.smooth,
    );
  }

  /// Asymmetrical organic progress bar with sculpted fluid perimeter.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) organic({
    Color color = const Color(0xFF059669),
    double height = 16.0,
  }) {
    return (
      style: Material4ProgressStyle.organicEdgeLinear,
      shape: Material4ProgressShape.asymmetric(
        topLeft: 12.0,
        topRight: 4.0,
        bottomRight: 12.0,
        bottomLeft: 4.0,
      ),
      track: Material4ProgressTrack(
        color: color.withValues(alpha: 0.14),
        thickness: height,
      ),
      fill: Material4ProgressFill(color: color),
      effects: const Material4ProgressEffects(),
      animation: Material4ProgressAnimation.smooth,
    );
  }

  /// Viscous liquid reservoir with undulating wave surface and effervescent bubbles.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) liquid({
    Color color = const Color(0xFF00B0FF),
    double height = 24.0,
  }) {
    return (
      style: Material4ProgressStyle.liquidLinear,
      shape: Material4ProgressShape.roundedRectangle(borderRadius: 12.0),
      track: Material4ProgressTrack(
        color: color.withValues(alpha: 0.12),
        borderWidth: 1.5,
        borderColor: color.withValues(alpha: 0.3),
        thickness: height,
      ),
      fill: Material4ProgressFill(
        color: color,
        waveAmplitude: 4.0,
        waveFrequency: 2.5,
        liquidBubbles: true,
        bubbleCount: 8,
      ),
      effects: const Material4ProgressEffects(
        glow: true,
        glowColor: Color(0x3300B0FF),
        glowRadius: 8.0,
      ),
      animation: const Material4ProgressAnimation(
        waveSpeed: 1.2,
      ),
    );
  }

  /// High-voltage fluorescent neon laser tube with saturated core and glow plume.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) neon({
    Color color = const Color(0xFF00E5FF),
    double height = 10.0,
  }) {
    return (
      style: Material4ProgressStyle.neonLinear,
      shape: Material4ProgressShape.capsule(),
      track: Material4ProgressTrack(
        color: const Color(0xFF0F172A),
        borderWidth: 1.0,
        borderColor: color.withValues(alpha: 0.4),
        thickness: height,
      ),
      fill: Material4ProgressFill(
        gradient: LinearGradient(
          colors: [color, Colors.white, color],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      effects: Material4ProgressEffects(
        neon: true,
        neonIntensity: 2.0,
        glow: true,
        glowColor: color,
        glowRadius: 16.0,
      ),
      animation: Material4ProgressAnimation.smooth,
    );
  }

  /// Translucent frosted glassmorphism progress track with specular highlight.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) glass({
    Color fillColor = const Color(0xFF6366F1),
    double height = 14.0,
  }) {
    return (
      style: Material4ProgressStyle.glassLinear,
      shape: Material4ProgressShape.capsule(),
      track: const Material4ProgressTrack(
        color: Color(0x26FFFFFF),
        borderWidth: 1.0,
        borderColor: Color(0x4DFFFFFF),
        glass: true,
        glassBlur: 12.0,
      ),
      fill: Material4ProgressFill(
        color: fillColor.withValues(alpha: 0.85),
      ),
      effects: const Material4ProgressEffects(
        glass: true,
        glassBlur: 12.0,
        shimmer: true,
      ),
      animation: Material4ProgressAnimation.smooth,
    );
  }

  /// 3D beveled and sculpted container with light-catching chamfered edges.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) sculpted({
    Color color = const Color(0xFF3B82F6),
    double height = 16.0,
  }) {
    return (
      style: Material4ProgressStyle.sculptedLinear,
      shape: Material4ProgressShape.sculpted(bevel: 6.0),
      track: Material4ProgressTrack(
        color: const Color(0xFFE2E8F0),
        borderWidth: 1.0,
        borderColor: const Color(0xFFCBD5E1),
        thickness: height,
      ),
      fill: Material4ProgressFill(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.85), color],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      effects: const Material4ProgressEffects(),
      animation: Material4ProgressAnimation.smooth,
    );
  }

  /// Harmonic sinusoidal wave crest traversing the filled progression.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) wave({
    Color color = const Color(0xFF06B6D4),
    double height = 16.0,
  }) {
    return (
      style: Material4ProgressStyle.waveLinear,
      shape: Material4ProgressShape.capsule(),
      track: Material4ProgressTrack(
        color: color.withValues(alpha: 0.12),
        thickness: height,
      ),
      fill: Material4ProgressFill(
        color: color,
        waveAmplitude: 3.5,
        waveFrequency: 2.0,
      ),
      effects: const Material4ProgressEffects(),
      animation: const Material4ProgressAnimation(waveSpeed: 1.5),
    );
  }

  /// Discretized segmented step progress split into partitioned blocks.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) segmented({
    Color color = const Color(0xFF10B981),
    int segments = 8,
    double segmentGap = 4.0,
    double height = 10.0,
  }) {
    return (
      style: Material4ProgressStyle.segmentedLinear,
      shape: Material4ProgressShape.roundedRectangle(borderRadius: 4.0),
      track: Material4ProgressTrack(
        color: color.withValues(alpha: 0.14),
        thickness: height,
      ),
      fill: Material4ProgressFill(
        color: color,
        segments: segments,
        segmentGap: segmentGap,
      ),
      effects: const Material4ProgressEffects(),
      animation: Material4ProgressAnimation.snappy,
    );
  }

  /// Continuous circular radial ring indicator.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) ring({
    Color color = const Color(0xFF6366F1),
    double strokeWidth = 8.0,
  }) {
    return (
      style: Material4ProgressStyle.ring,
      shape: Material4ProgressShape.circle(),
      track: Material4ProgressTrack(
        color: color.withValues(alpha: 0.14),
        thickness: strokeWidth,
      ),
      fill: Material4ProgressFill(color: color),
      effects: const Material4ProgressEffects(),
      animation: Material4ProgressAnimation.smooth,
    );
  }

  /// Diagonal barber-pole striped progress fill.
  static ({
    Material4ProgressStyle style,
    Material4ProgressShape shape,
    Material4ProgressTrack track,
    Material4ProgressFill fill,
    Material4ProgressEffects effects,
    Material4ProgressAnimation animation,
  }) striped({
    Color color = const Color(0xFFF59E0B),
    double height = 14.0,
  }) {
    return (
      style: Material4ProgressStyle.animatedStripedLinear,
      shape: Material4ProgressShape.capsule(),
      track: Material4ProgressTrack(
        color: color.withValues(alpha: 0.15),
        thickness: height,
      ),
      fill: Material4ProgressFill(
        color: color,
        striped: true,
        stripeColor: const Color(0x33FFFFFF),
        stripeWidth: 8.0,
        stripeGap: 8.0,
      ),
      effects: const Material4ProgressEffects(),
      animation: const Material4ProgressAnimation(stripeSpeed: 30.0),
    );
  }
}

