import 'package:flutter/foundation.dart';

import 'bezier_config.dart';

/// Available contour profile styles for individual shape edges.
enum ShapeEdgeStyle {
  /// Flat, crisp collinear edge.
  straight,

  /// Outward curved circular or Bézier crest.
  convex,

  /// Inward scooped cavity or cut.
  concave,

  /// Harmonic sinusoidal wave crests.
  wave,

  /// Sawtooth triangular zigzag teeth series.
  zigzag,

  /// Custom Bézier control point contour.
  customBezier,
}

/// Identifies one of the four bounding edges of a rectangular container.
enum ShapeEdge { top, right, bottom, left }

/// Immutable configuration for a single contour edge of a dynamic shape.
@immutable
class ShapeEdgeConfig {
  /// The geometric profile style for this edge.
  final ShapeEdgeStyle style;

  /// Curvature depth for convex/concave profiles, or tooth depth for zigzag.
  final double depth;

  /// Frequency or count of waves/teeth along this edge.
  final double waveCount;

  /// Amplitude of sinusoidal waves along this edge.
  final double waveAmplitude;

  /// Phase offset (in radians) for harmonic waves.
  final double wavePhase;

  /// Width of individual sawtooth teeth when [style] is [ShapeEdgeStyle.zigzag].
  final double toothWidth;

  /// Custom Bézier segment parameters when [style] is [ShapeEdgeStyle.customBezier].
  final BezierSegmentConfig? customBezier;

  /// Whether the edge contour direction should be inverted / mirrored.
  final bool isMirrored;

  /// Default flat straight edge.
  const ShapeEdgeConfig.straight()
      : style = ShapeEdgeStyle.straight,
        depth = 0.0,
        waveCount = 0.0,
        waveAmplitude = 0.0,
        wavePhase = 0.0,
        toothWidth = 0.0,
        customBezier = null,
        isMirrored = false;

  /// Outward curved convex arc.
  const ShapeEdgeConfig.convex({
    this.depth = 16.0,
    this.isMirrored = false,
  })  : style = ShapeEdgeStyle.convex,
        waveCount = 0.0,
        waveAmplitude = 0.0,
        wavePhase = 0.0,
        toothWidth = 0.0,
        customBezier = null;

  /// Inward scooped concave arc.
  const ShapeEdgeConfig.concave({
    this.depth = 16.0,
    this.isMirrored = false,
  })  : style = ShapeEdgeStyle.concave,
        waveCount = 0.0,
        waveAmplitude = 0.0,
        wavePhase = 0.0,
        toothWidth = 0.0,
        customBezier = null;

  /// Harmonic sinusoidal wave edge.
  const ShapeEdgeConfig.wave({
    this.waveCount = 3.0,
    this.waveAmplitude = 8.0,
    this.wavePhase = 0.0,
    this.isMirrored = false,
  })  : style = ShapeEdgeStyle.wave,
        depth = waveAmplitude,
        toothWidth = 0.0,
        customBezier = null;

  /// Sawtooth triangular zigzag edge.
  const ShapeEdgeConfig.zigzag({
    this.toothWidth = 14.0,
    this.depth = 8.0,
    this.isMirrored = false,
  })  : style = ShapeEdgeStyle.zigzag,
        waveCount = 0.0,
        waveAmplitude = 0.0,
        wavePhase = 0.0,
        customBezier = null;

  /// Parametric Bézier curve edge.
  const ShapeEdgeConfig.customBezier(
    BezierSegmentConfig bezier, {
    this.isMirrored = false,
  })  : style = ShapeEdgeStyle.customBezier,
        customBezier = bezier,
        depth = 0.0,
        waveCount = 0.0,
        waveAmplitude = 0.0,
        wavePhase = 0.0,
        toothWidth = 0.0;

  /// Full-parameter constructor.
  const ShapeEdgeConfig({
    this.style = ShapeEdgeStyle.straight,
    this.depth = 0.0,
    this.waveCount = 0.0,
    this.waveAmplitude = 0.0,
    this.wavePhase = 0.0,
    this.toothWidth = 0.0,
    this.customBezier,
    this.isMirrored = false,
  });

  /// Whether this edge is flat and straight without decorative geometry.
  bool get isStraight => style == ShapeEdgeStyle.straight;

  /// Creates a copy with the given fields replaced.
  ShapeEdgeConfig copyWith({
    ShapeEdgeStyle? style,
    double? depth,
    double? waveCount,
    double? waveAmplitude,
    double? wavePhase,
    double? toothWidth,
    BezierSegmentConfig? customBezier,
    bool? isMirrored,
  }) {
    return ShapeEdgeConfig(
      style: style ?? this.style,
      depth: depth ?? this.depth,
      waveCount: waveCount ?? this.waveCount,
      waveAmplitude: waveAmplitude ?? this.waveAmplitude,
      wavePhase: wavePhase ?? this.wavePhase,
      toothWidth: toothWidth ?? this.toothWidth,
      customBezier: customBezier ?? this.customBezier,
      isMirrored: isMirrored ?? this.isMirrored,
    );
  }

  /// Converts this [ShapeEdgeConfig] to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'style': style.name,
        'depth': depth,
        'waveCount': waveCount,
        'waveAmplitude': waveAmplitude,
        'wavePhase': wavePhase,
        'toothWidth': toothWidth,
        'customBezier': customBezier?.toJson(),
        'isMirrored': isMirrored,
      };

  /// Constructs a [ShapeEdgeConfig] from serialized JSON data.
  factory ShapeEdgeConfig.fromJson(Map<String, dynamic> json) {
    return ShapeEdgeConfig(
      style: ShapeEdgeStyle.values.firstWhere(
        (e) => e.name == json['style'],
        orElse: () => ShapeEdgeStyle.straight,
      ),
      depth: (json['depth'] as num?)?.toDouble() ?? 0.0,
      waveCount: (json['waveCount'] as num?)?.toDouble() ?? 0.0,
      waveAmplitude: (json['waveAmplitude'] as num?)?.toDouble() ?? 0.0,
      wavePhase: (json['wavePhase'] as num?)?.toDouble() ?? 0.0,
      toothWidth: (json['toothWidth'] as num?)?.toDouble() ?? 0.0,
      customBezier: json['customBezier'] != null
          ? BezierSegmentConfig.fromJson(
              json['customBezier'] as Map<String, dynamic>)
          : null,
      isMirrored: json['isMirrored'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeEdgeConfig &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          depth == other.depth &&
          waveCount == other.waveCount &&
          waveAmplitude == other.waveAmplitude &&
          wavePhase == other.wavePhase &&
          toothWidth == other.toothWidth &&
          customBezier == other.customBezier &&
          isMirrored == other.isMirrored;

  @override
  int get hashCode => Object.hash(
        style,
        depth,
        waveCount,
        waveAmplitude,
        wavePhase,
        toothWidth,
        customBezier,
        isMirrored,
      );
}

/// Composite container defining contour edge configs for all four boundary edges.
@immutable
class ShapeEdges {
  /// Contour configuration for the top edge.
  final ShapeEdgeConfig top;

  /// Contour configuration for the right edge.
  final ShapeEdgeConfig right;

  /// Contour configuration for the bottom edge.
  final ShapeEdgeConfig bottom;

  /// Contour configuration for the left edge.
  final ShapeEdgeConfig left;

  /// Constructs a [ShapeEdges] with independent configurations for each edge.
  const ShapeEdges({
    this.top = const ShapeEdgeConfig.straight(),
    this.right = const ShapeEdgeConfig.straight(),
    this.bottom = const ShapeEdgeConfig.straight(),
    this.left = const ShapeEdgeConfig.straight(),
  });

  /// Constructs a [ShapeEdges] with identical configuration on all four edges.
  const ShapeEdges.all(ShapeEdgeConfig edge)
      : top = edge,
        right = edge,
        bottom = edge,
        left = edge;

  /// Constructs a [ShapeEdges] with symmetric horizontal and vertical edge configurations.
  const ShapeEdges.symmetric({
    ShapeEdgeConfig horizontal = const ShapeEdgeConfig.straight(),
    ShapeEdgeConfig vertical = const ShapeEdgeConfig.straight(),
  })  : top = horizontal,
        bottom = horizontal,
        left = vertical,
        right = vertical;

  /// Constructs a [ShapeEdges] with only selected edges defined (defaulting others to straight).
  const ShapeEdges.only({
    this.top = const ShapeEdgeConfig.straight(),
    this.right = const ShapeEdgeConfig.straight(),
    this.bottom = const ShapeEdgeConfig.straight(),
    this.left = const ShapeEdgeConfig.straight(),
  });

  /// Default flat edges on all four sides.
  static const ShapeEdges straight = ShapeEdges();

  /// Whether all four edges are standard flat straight edges.
  bool get isAllStraight =>
      top.isStraight &&
      right.isStraight &&
      bottom.isStraight &&
      left.isStraight;

  /// Creates a copy with the given edges replaced.
  ShapeEdges copyWith({
    ShapeEdgeConfig? top,
    ShapeEdgeConfig? right,
    ShapeEdgeConfig? bottom,
    ShapeEdgeConfig? left,
  }) {
    return ShapeEdges(
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
    );
  }

  /// Converts this [ShapeEdges] to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'top': top.toJson(),
        'right': right.toJson(),
        'bottom': bottom.toJson(),
        'left': left.toJson(),
      };

  /// Constructs a [ShapeEdges] from serialized JSON data.
  factory ShapeEdges.fromJson(Map<String, dynamic> json) {
    return ShapeEdges(
      top: json['top'] != null
          ? ShapeEdgeConfig.fromJson(json['top'] as Map<String, dynamic>)
          : const ShapeEdgeConfig.straight(),
      right: json['right'] != null
          ? ShapeEdgeConfig.fromJson(json['right'] as Map<String, dynamic>)
          : const ShapeEdgeConfig.straight(),
      bottom: json['bottom'] != null
          ? ShapeEdgeConfig.fromJson(json['bottom'] as Map<String, dynamic>)
          : const ShapeEdgeConfig.straight(),
      left: json['left'] != null
          ? ShapeEdgeConfig.fromJson(json['left'] as Map<String, dynamic>)
          : const ShapeEdgeConfig.straight(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShapeEdges &&
          runtimeType == other.runtimeType &&
          top == other.top &&
          right == other.right &&
          bottom == other.bottom &&
          left == other.left;

  @override
  int get hashCode => Object.hash(top, right, bottom, left);
}
