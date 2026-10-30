import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../material_4_config.dart';
import '../material_4_path_builder.dart';
import '../creative/organic/organic_card_shape.dart';
import '../creative/organic/organic_shape_path_builder.dart';

/// Defines track and fill contour geometry for [Material4ProgressBar].
///
/// Supports geometric, organic, and creative vector shapes, and provides
/// high-fidelity Bézier morphing interpolation between arbitrary contours.
@immutable
class Material4ProgressShape {
  /// Unique identifier of this shape configuration.
  final String id;

  /// Underlying vector path generator function.
  final Path Function(Size size) _pathBuilder;

  /// Optional underlying Material 4 config when generated from [fromConfig].
  final Material4Config? config;

  /// Optional underlying organic card shape when generated from [fromOrganicShape].
  final Material4CardShape? organicShape;

  /// Optional parameter map for lerp and serialization.
  final Map<String, double> parameters;

  /// Creates a custom or raw [Material4ProgressShape].
  const Material4ProgressShape.raw({
    required this.id,
    required Path Function(Size size) pathBuilder,
    this.config,
    this.organicShape,
    this.parameters = const {},
  }) : _pathBuilder = pathBuilder;

  const Material4ProgressShape._({
    required this.id,
    required Path Function(Size size) pathBuilder,
    this.config,
    this.organicShape,
    this.parameters = const {},
  }) : _pathBuilder = pathBuilder;

  /// Generates the vector [Path] for this progress shape given [size].
  Path buildPath(Size size) {
    if (size.width <= 0 || size.height <= 0) return Path();
    if (config != null) {
      return Material4PathBuilder.buildPath(size, config!);
    }
    if (organicShape != null) {
      return OrganicShapePathBuilder.buildPath(size, organicShape!);
    }
    return _pathBuilder(size);
  }

  // =========================================================================
  // 1. Geometric Shapes
  // =========================================================================

  /// Sharp rectangular shape.
  factory Material4ProgressShape.rectangle() {
    return Material4ProgressShape._(
      id: 'rectangle',
      pathBuilder: (size) =>
          Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  /// Rounded rectangle with configurable [borderRadius] (or individual corner radii).
  factory Material4ProgressShape.roundedRectangle({
    double borderRadius = 8.0,
    BorderRadius? customRadii,
  }) {
    final effectiveRadii = customRadii ?? BorderRadius.circular(borderRadius);
    return Material4ProgressShape._(
      id: 'roundedRectangle_${effectiveRadii.topLeft.x}',
      parameters: {'radius': borderRadius},
      pathBuilder: (size) {
        final path = Path();
        path.addRRect(
          effectiveRadii.toRRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        );
        return path;
      },
    );
  }

  /// Pill/capsule shape with fully rounded semicircular ends.
  factory Material4ProgressShape.capsule() {
    return Material4ProgressShape._(
      id: 'capsule',
      pathBuilder: (size) {
        final path = Path();
        final r = math.min(size.width, size.height) / 2.0;
        path.addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(r),
          ),
        );
        return path;
      },
    );
  }

  /// Circular shape bounded by the smaller dimension of [Size].
  factory Material4ProgressShape.circle() {
    return Material4ProgressShape._(
      id: 'circle',
      pathBuilder: (size) {
        final path = Path();
        final radius = math.min(size.width, size.height) / 2.0;
        final center = Offset(size.width / 2.0, size.height / 2.0);
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        return path;
      },
    );
  }

  /// Elliptical oval contour spanning the entire container width and height.
  factory Material4ProgressShape.oval() {
    return Material4ProgressShape._(
      id: 'oval',
      pathBuilder: (size) {
        final path = Path();
        path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
        return path;
      },
    );
  }

  /// Mathematical Lamé curve superellipse (authentic iOS squircle).
  factory Material4ProgressShape.squircle({double smoothness = 0.85}) {
    final s = smoothness.clamp(0.1, 1.0);
    return Material4ProgressShape._(
      id: 'squircle_$s',
      parameters: {'smoothness': s},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final minDim = math.min(w, h);
        final r = (minDim / 2.0) * s;

        path.moveTo(r, 0);
        path.lineTo(w - r, 0);
        path.cubicTo(w - r * 0.35, 0, w, r * 0.35, w, r);
        path.lineTo(w, h - r);
        path.cubicTo(w, h - r * 0.35, w - r * 0.35, h, w - r, h);
        path.lineTo(r, h);
        path.cubicTo(r * 0.35, h, 0, h - r * 0.35, 0, h - r);
        path.lineTo(0, r);
        path.cubicTo(0, r * 0.35, r * 0.35, 0, r, 0);
        path.close();
        return path;
      },
    );
  }

  /// Regular 6-sided hexagon with rounded vertices.
  factory Material4ProgressShape.hexagon({double cornerRadius = 6.0}) {
    return Material4ProgressShape._(
      id: 'hexagon_$cornerRadius',
      parameters: {'cornerRadius': cornerRadius},
      pathBuilder: (size) {
        final path = Path();
        final cx = size.width / 2.0;
        final cy = size.height / 2.0;
        final r = math.min(size.width, size.height) / 2.0;
        const sides = 6;
        const angleStep = (2 * math.pi) / sides;
        const startOffset = -math.pi / 2;

        final vertices = <Offset>[];
        for (var i = 0; i < sides; i++) {
          final angle = startOffset + i * angleStep;
          vertices.add(Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)));
        }

        path.moveTo(vertices[0].dx, vertices[0].dy);
        for (var i = 1; i < sides; i++) {
          path.lineTo(vertices[i].dx, vertices[i].dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Regular 8-sided octagon.
  factory Material4ProgressShape.octagon({double cornerRadius = 6.0}) {
    return Material4ProgressShape._(
      id: 'octagon_$cornerRadius',
      parameters: {'cornerRadius': cornerRadius},
      pathBuilder: (size) {
        final path = Path();
        final cx = size.width / 2.0;
        final cy = size.height / 2.0;
        final r = math.min(size.width, size.height) / 2.0;
        const sides = 8;
        const angleStep = (2 * math.pi) / sides;
        const startOffset = -math.pi / 8;

        final vertices = <Offset>[];
        for (var i = 0; i < sides; i++) {
          final angle = startOffset + i * angleStep;
          vertices.add(Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)));
        }

        path.moveTo(vertices[0].dx, vertices[0].dy);
        for (var i = 1; i < sides; i++) {
          path.lineTo(vertices[i].dx, vertices[i].dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Symmetrical 4-point rhombus/diamond.
  factory Material4ProgressShape.diamond({double cornerRadius = 4.0}) {
    return Material4ProgressShape._(
      id: 'diamond_$cornerRadius',
      parameters: {'cornerRadius': cornerRadius},
      pathBuilder: (size) {
        final path = Path();
        final cx = size.width / 2.0;
        final cy = size.height / 2.0;

        path.moveTo(cx, 0);
        path.lineTo(size.width, cy);
        path.lineTo(cx, size.height);
        path.lineTo(0, cy);
        path.close();
        return path;
      },
    );
  }

  /// Regular N-sided polygon.
  factory Material4ProgressShape.polygon({required int sides, double rotation = 0.0}) {
    final effectiveSides = sides < 3 ? 3 : sides;
    return Material4ProgressShape._(
      id: 'polygon_${effectiveSides}_$rotation',
      parameters: {'sides': effectiveSides.toDouble(), 'rotation': rotation},
      pathBuilder: (size) {
        final path = Path();
        final cx = size.width / 2.0;
        final cy = size.height / 2.0;
        final r = math.min(size.width, size.height) / 2.0;
        final angleStep = (2 * math.pi) / effectiveSides;
        final startOffset = -math.pi / 2 + rotation;

        for (var i = 0; i < effectiveSides; i++) {
          final angle = startOffset + i * angleStep;
          final pt = Offset(cx + r * math.cos(angle), cy + r * math.sin(angle));
          if (i == 0) {
            path.moveTo(pt.dx, pt.dy);
          } else {
            path.lineTo(pt.dx, pt.dy);
          }
        }
        path.close();
        return path;
      },
    );
  }

  // =========================================================================
  // 2. Organic Shapes
  // =========================================================================

  /// Asymmetrical playful organic fluid blob.
  factory Material4ProgressShape.blob({int seed = 42, double tension = 0.65}) {
    return Material4ProgressShape._(
      id: 'blob_${seed}_$tension',
      parameters: {'seed': seed.toDouble(), 'tension': tension},
      pathBuilder: (size) {
        final path = Path();
        final cx = size.width / 2.0;
        final cy = size.height / 2.0;
        final rx = size.width / 2.0;
        final ry = size.height / 2.0;

        const points = 7;
        final angles = List.generate(points, (i) => (2 * math.pi / points) * i);
        final radiiX = [
          rx * 0.95,
          rx * (0.82 + tension * 0.15),
          rx * 1.0,
          rx * 0.88,
          rx * (0.92 + tension * 0.08),
          rx * 0.84,
          rx * 0.98,
        ];
        final radiiY = [
          ry * (0.88 + tension * 0.1),
          ry * 0.98,
          ry * 0.82,
          ry * 1.0,
          ry * (0.85 + tension * 0.12),
          ry * 0.94,
          ry * 0.86,
        ];

        final pts = <Offset>[];
        for (var i = 0; i < points; i++) {
          pts.add(Offset(cx + radiiX[i] * math.cos(angles[i]), cy + radiiY[i] * math.sin(angles[i])));
        }

        path.moveTo(pts[0].dx, pts[0].dy);
        for (var i = 0; i < points; i++) {
          final p0 = pts[i];
          final p1 = pts[(i + 1) % points];
          final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
          path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Progress bar with distinctly asymmetrical corner radii.
  factory Material4ProgressShape.asymmetric({
    double topLeft = 18.0,
    double topRight = 4.0,
    double bottomRight = 18.0,
    double bottomLeft = 4.0,
  }) {
    return Material4ProgressShape._(
      id: 'asymmetric_${topLeft}_${topRight}_${bottomRight}_$bottomLeft',
      parameters: {
        'tl': topLeft,
        'tr': topRight,
        'br': bottomRight,
        'bl': bottomLeft,
      },
      pathBuilder: (size) {
        final path = Path();
        path.addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, size.width, size.height),
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomRight: Radius.circular(bottomRight),
            bottomLeft: Radius.circular(bottomLeft),
          ),
        );
        return path;
      },
    );
  }

  /// Wavy fluid organic crest along progress boundaries.
  factory Material4ProgressShape.wavy({int waves = 4, double crestHeight = 4.0}) {
    return Material4ProgressShape._(
      id: 'wavy_${waves}_$crestHeight',
      parameters: {'waves': waves.toDouble(), 'crestHeight': crestHeight},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final waveWidth = w / waves;

        path.moveTo(0, crestHeight);
        for (var i = 0; i < waves; i++) {
          final startX = i * waveWidth;
          path.cubicTo(
            startX + waveWidth * 0.25,
            0,
            startX + waveWidth * 0.75,
            crestHeight * 2,
            startX + waveWidth,
            crestHeight,
          );
        }
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.close();
        return path;
      },
    );
  }

  /// Inward concave circular scallop cuts on vertices.
  factory Material4ProgressShape.concave({double cutRadius = 12.0}) {
    return Material4ProgressShape._(
      id: 'concave_$cutRadius',
      parameters: {'cutRadius': cutRadius},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final r = cutRadius.clamp(0.0, math.min(w, h) / 3.0);

        path.moveTo(r, 0);
        path.lineTo(w - r, 0);
        path.arcToPoint(Offset(w, r), radius: Radius.circular(r), clockwise: false);
        path.lineTo(w, h - r);
        path.arcToPoint(Offset(w - r, h), radius: Radius.circular(r), clockwise: false);
        path.lineTo(r, h);
        path.arcToPoint(Offset(0, h - r), radius: Radius.circular(r), clockwise: false);
        path.lineTo(0, r);
        path.arcToPoint(Offset(r, 0), radius: Radius.circular(r), clockwise: false);
        path.close();
        return path;
      },
    );
  }

  /// Outward barrel/convex curved expanding edges.
  factory Material4ProgressShape.convex({double bulge = 6.0}) {
    return Material4ProgressShape._(
      id: 'convex_$bulge',
      parameters: {'bulge': bulge},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;

        path.moveTo(0, 0);
        path.quadraticBezierTo(w / 2, -bulge, w, 0);
        path.quadraticBezierTo(w + bulge, h / 2, w, h);
        path.quadraticBezierTo(w / 2, h + bulge, 0, h);
        path.quadraticBezierTo(-bulge, h / 2, 0, 0);
        path.close();
        return path;
      },
    );
  }

  /// Sculpted 3D beveled profile with chamfered corners and filleted facets.
  factory Material4ProgressShape.sculpted({double bevel = 8.0}) {
    return Material4ProgressShape._(
      id: 'sculpted_$bevel',
      parameters: {'bevel': bevel},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final b = bevel.clamp(0.0, math.min(w, h) / 4.0);

        path.moveTo(b, 0);
        path.lineTo(w - b, 0);
        path.lineTo(w, b);
        path.lineTo(w, h - b);
        path.lineTo(w - b, h);
        path.lineTo(b, h);
        path.lineTo(0, h - b);
        path.lineTo(0, b);
        path.close();
        return path;
      },
    );
  }

  /// Multi-curve serpentine profile.
  factory Material4ProgressShape.curved({double curvature = 8.0}) {
    return Material4ProgressShape._(
      id: 'curved_$curvature',
      parameters: {'curvature': curvature},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        path.moveTo(0, h * 0.2);
        path.cubicTo(w * 0.35, -curvature, w * 0.65, curvature * 2, w, h * 0.2);
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.close();
        return path;
      },
    );
  }

  /// Irregular faceted organic polygon contour.
  factory Material4ProgressShape.irregular() {
    return Material4ProgressShape._(
      id: 'irregular',
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        path.moveTo(w * 0.08, 0);
        path.lineTo(w * 0.92, h * 0.05);
        path.lineTo(w, h * 0.88);
        path.lineTo(w * 0.88, h);
        path.lineTo(w * 0.05, h * 0.95);
        path.lineTo(0, h * 0.12);
        path.close();
        return path;
      },
    );
  }

  /// Liquid reservoir container with slight meniscus sag.
  factory Material4ProgressShape.liquid({double meniscus = 4.0}) {
    return Material4ProgressShape._(
      id: 'liquid_$meniscus',
      parameters: {'meniscus': meniscus},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final r = math.min(w, h) * 0.15;

        path.moveTo(r, 0);
        path.lineTo(w - r, 0);
        path.quadraticBezierTo(w, 0, w, r);
        path.lineTo(w, h - r);
        path.quadraticBezierTo(w, h, w - r, h);
        path.quadraticBezierTo(w / 2, h - meniscus, r, h);
        path.quadraticBezierTo(0, h, 0, h - r);
        path.lineTo(0, r);
        path.quadraticBezierTo(0, 0, r, 0);
        path.close();
        return path;
      },
    );
  }

  /// Custom vector path builder specified directly via Bézier curves.
  factory Material4ProgressShape.customBezier(Path Function(Size size) builder) {
    return Material4ProgressShape._(
      id: 'customBezier_${builder.hashCode}',
      pathBuilder: builder,
    );
  }

  // =========================================================================
  // 3. Creative Shapes
  // =========================================================================

  /// Sawtooth / zigzag edges along the ends of the progress bar.
  factory Material4ProgressShape.zigzag({int teeth = 6, double toothDepth = 6.0}) {
    return Material4ProgressShape._(
      id: 'zigzag_${teeth}_$toothDepth',
      parameters: {'teeth': teeth.toDouble(), 'depth': toothDepth},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final stepY = h / teeth;

        path.moveTo(0, 0);
        path.lineTo(w, 0);
        for (var i = 0; i < teeth; i++) {
          final midY = (i + 0.5) * stepY;
          final nextY = (i + 1) * stepY;
          path.lineTo(w - toothDepth, midY);
          path.lineTo(w, nextY);
        }
        path.lineTo(0, h);
        path.close();
        return path;
      },
    );
  }

  /// Flower / scalloped petal circular badge contour.
  factory Material4ProgressShape.flower({int petals = 8}) {
    return Material4ProgressShape._(
      id: 'flower_$petals',
      parameters: {'petals': petals.toDouble()},
      pathBuilder: (size) {
        final path = Path();
        final cx = size.width / 2.0;
        final cy = size.height / 2.0;
        final r = math.min(size.width, size.height) / 2.0;
        final innerR = r * 0.82;
        final step = (2 * math.pi) / petals;

        for (var i = 0; i < petals; i++) {
          final a0 = i * step;
          final a1 = (i + 1) * step;
          final mid = (a0 + a1) / 2.0;
          final p0 = Offset(cx + innerR * math.cos(a0), cy + innerR * math.sin(a0));
          final pCtrl = Offset(cx + r * 1.08 * math.cos(mid), cy + r * 1.08 * math.sin(mid));
          final p1 = Offset(cx + innerR * math.cos(a1), cy + innerR * math.sin(a1));

          if (i == 0) path.moveTo(p0.dx, p0.dy);
          path.quadraticBezierTo(pCtrl.dx, pCtrl.dy, p1.dx, p1.dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Heraldic shield emblem contour.
  factory Material4ProgressShape.shield() {
    return Material4ProgressShape._(
      id: 'shield',
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        path.moveTo(w / 2, 0);
        path.lineTo(w, h * 0.18);
        path.cubicTo(w, h * 0.65, w * 0.72, h * 0.88, w / 2, h);
        path.cubicTo(w * 0.28, h * 0.88, 0, h * 0.65, 0, h * 0.18);
        path.close();
        return path;
      },
    );
  }

  /// Creates a [Material4ProgressShape] directly backed by a [Material4Config].
  factory Material4ProgressShape.fromConfig(Material4Config config) {
    return Material4ProgressShape._(
      id: 'config_${config.type.name}',
      config: config,
      pathBuilder: (size) => Material4PathBuilder.buildPath(size, config),
    );
  }

  /// Creates a [Material4ProgressShape] backed by a [Material4CardShape].
  factory Material4ProgressShape.fromOrganicShape(Material4CardShape organicShape) {
    return Material4ProgressShape._(
      id: 'organic_${organicShape.hashCode}',
      organicShape: organicShape,
      pathBuilder: (size) => OrganicShapePathBuilder.buildPath(size, organicShape),
    );
  }

  // =========================================================================
  // Shape Morphing & Interpolation
  // =========================================================================

  /// Interpolates linearly between [shapeA] and [shapeB] at progress [t].
  ///
  /// Uses top-center (12 o'clock) angular phase alignment and LRU-cached contour
  /// sampling to guarantee smooth morphing without spinning or self-intersection.
  static Material4ProgressShape lerp(
    Material4ProgressShape shapeA,
    Material4ProgressShape shapeB,
    double t,
  ) {
    final clampedT = t.clamp(0.0, 1.0);
    if (clampedT <= 0.0) return shapeA;
    if (clampedT >= 1.0) return shapeB;

    return Material4ProgressShape._(
      id: 'morphed_${shapeA.id}_to_${shapeB.id}_${(clampedT * 100).round()}',
      pathBuilder: (size) {
        if (size.width <= 0 || size.height <= 0) return Path();

        const samples = 64;
        final ptsA = _ContourCache.getAlignedContour(shapeA, size, samples);
        final ptsB = _ContourCache.getAlignedContour(shapeB, size, samples);

        final interpolated = List<Offset>.generate(samples, (i) {
          final a = ptsA[i];
          final b = ptsB[i];
          return Offset(
            a.dx + (b.dx - a.dx) * clampedT,
            a.dy + (b.dy - a.dy) * clampedT,
          );
        });

        final morphed = Path();
        morphed.moveTo(interpolated[0].dx, interpolated[0].dy);
        for (var i = 0; i < samples; i++) {
          final p0 = interpolated[i];
          final p1 = interpolated[(i + 1) % samples];
          final mid = Offset((p0.dx + p1.dx) / 2.0, (p0.dy + p1.dy) / 2.0);
          morphed.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
        }
        morphed.close();
        return morphed;
      },
    );
  }
}

/// Internal high-performance contour cache with 12-o'clock angular alignment.
class _ContourCache {
  static final Map<String, List<Offset>> _cache = {};
  static const int _maxCacheSize = 256;

  static List<Offset> getAlignedContour(
    Material4ProgressShape shape,
    Size size,
    int sampleCount,
  ) {
    final key = '${shape.id}_${size.width.toInt()}x${size.height.toInt()}_$sampleCount';
    final existing = _cache[key];
    if (existing != null) return existing;

    final path = shape.buildPath(size);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) {
      final fallback = List.filled(sampleCount, Offset(size.width / 2, size.height / 2));
      _cache[key] = fallback;
      return fallback;
    }

    final metric = metrics.first;
    final totalLength = metric.length;
    final rawPoints = <Offset>[];

    for (var i = 0; i < sampleCount; i++) {
      final dist = (i / sampleCount) * totalLength;
      final tangent = metric.getTangentForOffset(dist);
      rawPoints.add(tangent?.position ?? Offset.zero);
    }

    // Phase alignment: find point closest to top-center (width/2, 0)
    final topCenter = Offset(size.width / 2.0, 0.0);
    var bestIndex = 0;
    var bestDistSq = double.infinity;

    for (var i = 0; i < rawPoints.length; i++) {
      final dx = rawPoints[i].dx - topCenter.dx;
      final dy = rawPoints[i].dy - topCenter.dy;
      final distSq = dx * dx + dy * dy;
      if (distSq < bestDistSq) {
        bestDistSq = distSq;
        bestIndex = i;
      }
    }

    final aligned = <Offset>[];
    for (var i = 0; i < sampleCount; i++) {
      aligned.add(rawPoints[(bestIndex + i) % sampleCount]);
    }

    if (_cache.length >= _maxCacheSize) {
      _cache.clear();
    }
    _cache[key] = aligned;
    return aligned;
  }
}
