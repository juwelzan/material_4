import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../material_4_config.dart';
import '../material_4_path_builder.dart';
import '../creative/organic/organic_card_shape.dart';
import '../creative/organic/organic_shape_path_builder.dart';

/// Defines the shape geometry of a [Material4Avatar].
///
/// Supports 24+ unique shapes across three major categories:
/// - **Basic Shapes**: [circle], [roundedSquare], [squircle], [oval], [capsule], [diamond], [hexagon], [octagon]
/// - **Organic Shapes**: [organicBlob], [asymmetricRounded], [softSculpted], [irregularCurve], [wavyEdge], [concaveNotch], [convexBulge], [multiCurve]
/// - **Creative Shapes**: [flower], [cloud], [star], [shield], [ticket], [abstractGeometric], [customBezier]
@immutable
class Material4AvatarShape {
  /// Unique identifier of this shape configuration.
  final String id;

  /// Custom path generator function for this shape.
  final Path Function(Size size) _pathBuilder;

  /// Optional underlying Material 4 config if created from [fromConfig].
  final Material4Config? config;

  /// Optional underlying organic card shape if created from [fromOrganicCardShape].
  final Material4CardShape? organicShape;

  /// Optional parameter map for lerp interpolation.
  final Map<String, double> parameters;

  /// Raw constructor for custom extensions and default presets.
  const Material4AvatarShape.raw({
    required this.id,
    required Path Function(Size size) pathBuilder,
    this.config,
    this.organicShape,
    this.parameters = const {},
  }) : _pathBuilder = pathBuilder;

  const Material4AvatarShape._({
    required this.id,
    required Path Function(Size size) pathBuilder,
    this.config,
    this.organicShape,
    this.parameters = const {},
  }) : _pathBuilder = pathBuilder;

  /// Generates the vector [Path] for this avatar shape given [size].
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
  // 1. Basic Shapes
  // =========================================================================

  /// Standard circular avatar.
  factory Material4AvatarShape.circle() {
    return Material4AvatarShape._(
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

  /// Rounded square with customizable [cornerRadius].
  factory Material4AvatarShape.roundedSquare({double cornerRadius = 16.0}) {
    return Material4AvatarShape._(
      id: 'roundedSquare',
      parameters: {'radius': cornerRadius},
      pathBuilder: (size) {
        final path = Path();
        final r =
            cornerRadius.clamp(0.0, math.min(size.width, size.height) / 2.0);
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

  /// Authentic iOS-style superellipse squircle with smooth curvature transitions.
  factory Material4AvatarShape.squircle({double smoothness = 0.82}) {
    return Material4AvatarShape._(
      id: 'squircle',
      parameters: {'smoothness': smoothness},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final r = math.min(w, h) * 0.28;
        final s = (smoothness.clamp(0.1, 1.0)) * r;

        path.moveTo(w / 2.0, 0);
        // Top edge to top-right
        path.lineTo(w - r, 0);
        path.cubicTo(w - r + s, 0, w, r - s, w, r);
        // Right edge to bottom-right
        path.lineTo(w, h - r);
        path.cubicTo(w, h - r + s, w - r + s, h, w - r, h);
        // Bottom edge to bottom-left
        path.lineTo(r, h);
        path.cubicTo(r - s, h, 0, h - r + s, 0, h - r);
        // Left edge to top-left
        path.lineTo(0, r);
        path.cubicTo(0, r - s, r - s, 0, r, 0);
        path.close();
        return path;
      },
    );
  }

  /// Elliptical / oval avatar.
  factory Material4AvatarShape.oval() {
    return Material4AvatarShape._(
      id: 'oval',
      pathBuilder: (size) {
        final path = Path();
        path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
        return path;
      },
    );
  }

  /// Capsule / pill avatar with fully rounded semicircular caps.
  factory Material4AvatarShape.capsule() {
    return Material4AvatarShape._(
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

  /// Symmetrical 4-point diamond (rhombus) with rounded vertices.
  factory Material4AvatarShape.diamond({double cornerRadius = 8.0}) {
    return Material4AvatarShape._(
      id: 'diamond',
      parameters: {'radius': cornerRadius},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final cx = w / 2.0;
        final cy = h / 2.0;
        final r = cornerRadius.clamp(0.0, math.min(w, h) * 0.2);

        // 4 vertices: Top, Right, Bottom, Left
        final top = Offset(cx, 0);
        final right = Offset(w, cy);
        final bottom = Offset(cx, h);
        final left = Offset(0, cy);

        if (r <= 0) {
          path.moveTo(top.dx, top.dy);
          path.lineTo(right.dx, right.dy);
          path.lineTo(bottom.dx, bottom.dy);
          path.lineTo(left.dx, left.dy);
          path.close();
        } else {
          // Rounded diamond vertices
          final t1 = Offset(cx - r * 0.7, r * 0.7);
          final t2 = Offset(cx + r * 0.7, r * 0.7);
          final r1 = Offset(w - r * 0.7, cy - r * 0.7);
          final r2 = Offset(w - r * 0.7, cy + r * 0.7);
          final b1 = Offset(cx + r * 0.7, h - r * 0.7);
          final b2 = Offset(cx - r * 0.7, h - r * 0.7);
          final l1 = Offset(r * 0.7, cy + r * 0.7);
          final l2 = Offset(r * 0.7, cy - r * 0.7);

          path.moveTo(t2.dx, t2.dy);
          path.lineTo(r1.dx, r1.dy);
          path.quadraticBezierTo(right.dx, right.dy, r2.dx, r2.dy);
          path.lineTo(b1.dx, b1.dy);
          path.quadraticBezierTo(bottom.dx, bottom.dy, b2.dx, b2.dy);
          path.lineTo(l1.dx, l1.dy);
          path.quadraticBezierTo(left.dx, left.dy, l2.dx, l2.dy);
          path.lineTo(t1.dx, t1.dy);
          path.quadraticBezierTo(top.dx, top.dy, t2.dx, t2.dy);
          path.close();
        }
        return path;
      },
    );
  }

  /// Regular 6-sided hexagon with rounded vertices.
  factory Material4AvatarShape.hexagon({double cornerRadius = 8.0}) {
    return Material4AvatarShape._(
      id: 'hexagon',
      parameters: {'radius': cornerRadius},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final cx = w / 2.0;
        final cy = h / 2.0;
        final r = math.min(w, h) / 2.0;

        final points = <Offset>[];
        for (int i = 0; i < 6; i++) {
          final angle = (i * 60.0 - 30.0) * math.pi / 180.0;
          points
              .add(Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)));
        }

        final cr = cornerRadius.clamp(0.0, r * 0.25);
        if (cr <= 0) {
          path.moveTo(points[0].dx, points[0].dy);
          for (int i = 1; i < 6; i++) {
            path.lineTo(points[i].dx, points[i].dy);
          }
          path.close();
        } else {
          for (int i = 0; i < 6; i++) {
            final prev = points[(i - 1 + 6) % 6];
            final curr = points[i];
            final next = points[(i + 1) % 6];

            final v1 = Offset(prev.dx - curr.dx, prev.dy - curr.dy);
            final len1 = math.sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
            final p1 = Offset(
                curr.dx + (v1.dx / len1) * cr, curr.dy + (v1.dy / len1) * cr);

            final v2 = Offset(next.dx - curr.dx, next.dy - curr.dy);
            final len2 = math.sqrt(v2.dx * v2.dx + v2.dy * v2.dy);
            final p2 = Offset(
                curr.dx + (v2.dx / len2) * cr, curr.dy + (v2.dy / len2) * cr);

            if (i == 0) {
              path.moveTo(p1.dx, p1.dy);
            } else {
              path.lineTo(p1.dx, p1.dy);
            }
            path.quadraticBezierTo(curr.dx, curr.dy, p2.dx, p2.dy);
          }
          path.close();
        }
        return path;
      },
    );
  }

  /// Regular 8-sided octagon with rounded vertices.
  factory Material4AvatarShape.octagon({double cornerRadius = 8.0}) {
    return Material4AvatarShape._(
      id: 'octagon',
      parameters: {'radius': cornerRadius},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final cx = w / 2.0;
        final cy = h / 2.0;
        final r = math.min(w, h) / 2.0;

        final points = <Offset>[];
        for (int i = 0; i < 8; i++) {
          final angle = (i * 45.0 - 22.5) * math.pi / 180.0;
          points
              .add(Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)));
        }

        final cr = cornerRadius.clamp(0.0, r * 0.2);
        if (cr <= 0) {
          path.moveTo(points[0].dx, points[0].dy);
          for (int i = 1; i < 8; i++) {
            path.lineTo(points[i].dx, points[i].dy);
          }
          path.close();
        } else {
          for (int i = 0; i < 8; i++) {
            final prev = points[(i - 1 + 8) % 8];
            final curr = points[i];
            final next = points[(i + 1) % 8];

            final v1 = Offset(prev.dx - curr.dx, prev.dy - curr.dy);
            final len1 = math.sqrt(v1.dx * v1.dx + v1.dy * v1.dy);
            final p1 = Offset(
                curr.dx + (v1.dx / len1) * cr, curr.dy + (v1.dy / len1) * cr);

            final v2 = Offset(next.dx - curr.dx, next.dy - curr.dy);
            final len2 = math.sqrt(v2.dx * v2.dx + v2.dy * v2.dy);
            final p2 = Offset(
                curr.dx + (v2.dx / len2) * cr, curr.dy + (v2.dy / len2) * cr);

            if (i == 0) {
              path.moveTo(p1.dx, p1.dy);
            } else {
              path.lineTo(p1.dx, p1.dy);
            }
            path.quadraticBezierTo(curr.dx, curr.dy, p2.dx, p2.dy);
          }
          path.close();
        }
        return path;
      },
    );
  }

  // =========================================================================
  // 2. Organic Shapes
  // =========================================================================

  /// Organic fluid blob avatar with smooth continuous curvature.
  factory Material4AvatarShape.organicBlob({int seed = 1}) {
    return Material4AvatarShape._(
      id: 'organicBlob',
      parameters: {'seed': seed.toDouble()},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final cx = w / 2.0;
        final cy = h / 2.0;
        final r = math.min(w, h) / 2.0;

        // 6 harmonic control vertices around the perimeter
        final angles = [0.0, 60.0, 120.0, 180.0, 240.0, 300.0];
        final radiiFactors = (seed % 2 == 0)
            ? [1.0, 0.82, 0.96, 0.78, 1.0, 0.88]
            : [0.94, 0.78, 1.0, 0.84, 0.96, 0.82];

        final pts = <Offset>[];
        for (int i = 0; i < 6; i++) {
          final rad = angles[i] * math.pi / 180.0;
          final currentR = r * radiiFactors[i];
          pts.add(Offset(
              cx + currentR * math.cos(rad), cy + currentR * math.sin(rad)));
        }

        path.moveTo((pts[0].dx + pts[5].dx) / 2, (pts[0].dy + pts[5].dy) / 2);
        for (int i = 0; i < 6; i++) {
          final curr = pts[i];
          final next = pts[(i + 1) % 6];
          final mid = Offset((curr.dx + next.dx) / 2, (curr.dy + next.dy) / 2);
          path.quadraticBezierTo(curr.dx, curr.dy, mid.dx, mid.dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Asymmetric rounded avatar with contrasting corner radii.
  factory Material4AvatarShape.asymmetricRounded({
    double rTL = 28.0,
    double rTR = 10.0,
    double rBR = 28.0,
    double rBL = 10.0,
  }) {
    return Material4AvatarShape._(
      id: 'asymmetricRounded',
      parameters: {'rTL': rTL, 'rTR': rTR, 'rBR': rBR, 'rBL': rBL},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final maxR = math.min(w, h) / 2.0;

        path.addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, w, h),
            topLeft: Radius.circular(rTL.clamp(0.0, maxR)),
            topRight: Radius.circular(rTR.clamp(0.0, maxR)),
            bottomRight: Radius.circular(rBR.clamp(0.0, maxR)),
            bottomLeft: Radius.circular(rBL.clamp(0.0, maxR)),
          ),
        );
        return path;
      },
    );
  }

  /// Soft sculpted architectural avatar with top-left dome and lateral waist pinch.
  factory Material4AvatarShape.softSculpted() {
    return Material4AvatarShape._(
      id: 'softSculpted',
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final dome = math.min(w, h) * 0.44;
        final pinch = math.min(w, h) * 0.08;

        path.moveTo(dome, 0);
        path.lineTo(w - 14, 0);
        path.quadraticBezierTo(w, 0, w, 14);

        // Right edge waist pinch
        path.lineTo(w, h * 0.32);
        path.cubicTo(w - pinch, h * 0.42, w - pinch, h * 0.58, w, h * 0.68);
        path.lineTo(w, h - 18);
        path.quadraticBezierTo(w, h, w - 18, h);

        // Bottom edge
        path.lineTo(16, h);
        path.quadraticBezierTo(0, h, 0, h - 16);

        // Left edge waist pinch
        path.lineTo(0, h * 0.68);
        path.cubicTo(pinch, h * 0.58, pinch, h * 0.42, 0, h * 0.32);
        path.lineTo(0, dome);
        path.quadraticBezierTo(0, 0, dome, 0);
        path.close();
        return path;
      },
    );
  }

  /// Irregular organic curve avatar.
  factory Material4AvatarShape.irregularCurve() {
    return Material4AvatarShape._(
      id: 'irregularCurve',
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;

        path.moveTo(w * 0.28, 0);
        path.cubicTo(
            w * 0.65, -h * 0.04, w * 0.95, h * 0.08, w * 0.98, h * 0.36);
        path.cubicTo(
            w * 1.02, h * 0.65, w * 0.92, h * 0.96, w * 0.68, h * 0.98);
        path.cubicTo(w * 0.38, w * 1.02, w * 0.08, h * 0.94, 0, h * 0.72);
        path.cubicTo(-w * 0.04, h * 0.45, w * 0.06, h * 0.08, w * 0.28, 0);
        path.close();
        return path;
      },
    );
  }

  /// Wavy fluid edge avatar with undulating perimeter.
  factory Material4AvatarShape.wavyEdge(
      {int waves = 6, double amplitude = 4.0}) {
    return Material4AvatarShape._(
      id: 'wavyEdge',
      parameters: {'waves': waves.toDouble(), 'amplitude': amplitude},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final cx = w / 2.0;
        final cy = h / 2.0;
        final baseR = (math.min(w, h) / 2.0) - amplitude;

        const int steps = 72;
        for (int i = 0; i <= steps; i++) {
          final theta = (i / steps) * 2 * math.pi;
          final r = baseR + amplitude * math.sin(waves * theta);
          final x = cx + r * math.cos(theta);
          final y = cy + r * math.sin(theta);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        return path;
      },
    );
  }

  /// Concave notch avatar featuring a smooth inward scoop on the lower-right edge.
  factory Material4AvatarShape.concaveNotch({double notchDepth = 12.0}) {
    return Material4AvatarShape._(
      id: 'concaveNotch',
      parameters: {'notchDepth': notchDepth},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final r = math.min(w, h) * 0.22;
        final nd = notchDepth.clamp(4.0, math.min(w, h) * 0.3);

        path.moveTo(r, 0);
        path.lineTo(w - r, 0);
        path.quadraticBezierTo(w, 0, w, r);

        // Right edge with lower concave scoop
        path.lineTo(w, h * 0.45);
        path.cubicTo(w - nd, h * 0.55, w - nd, h * 0.78, w, h * 0.86);
        path.lineTo(w, h - r);
        path.quadraticBezierTo(w, h, w - r, h);

        path.lineTo(r, h);
        path.quadraticBezierTo(0, h, 0, h - r);
        path.lineTo(0, r);
        path.quadraticBezierTo(0, 0, r, 0);
        path.close();
        return path;
      },
    );
  }

  /// Convex bulge avatar featuring an arched crest boundary.
  factory Material4AvatarShape.convexBulge({double bulgeHeight = 8.0}) {
    return Material4AvatarShape._(
      id: 'convexBulge',
      parameters: {'bulgeHeight': bulgeHeight},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final r = math.min(w, h) * 0.22;
        final bh = bulgeHeight.clamp(2.0, math.min(w, h) * 0.2);

        path.moveTo(r, bh);
        // Top edge with upward convex arch
        path.quadraticBezierTo(w / 2.0, 0, w - r, bh);
        path.quadraticBezierTo(w, bh, w, bh + r);

        path.lineTo(w, h - r);
        path.quadraticBezierTo(w, h, w - r, h);
        path.lineTo(r, h);
        path.quadraticBezierTo(0, h, 0, h - r);
        path.lineTo(0, bh + r);
        path.quadraticBezierTo(0, bh, r, bh);
        path.close();
        return path;
      },
    );
  }

  /// Multi-curve organic avatar with harmonic lobes.
  factory Material4AvatarShape.multiCurve() {
    return Material4AvatarShape._(
      id: 'multiCurve',
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final cx = w / 2.0;
        final cy = h / 2.0;
        final r = math.min(w, h) / 2.0;

        const int steps = 60;
        for (int i = 0; i <= steps; i++) {
          final theta = (i / steps) * 2 * math.pi;
          final rVar =
              r * (0.88 + 0.12 * math.cos(3 * theta) * math.sin(2 * theta));
          final x = cx + rVar * math.cos(theta);
          final y = cy + rVar * math.sin(theta);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        return path;
      },
    );
  }

  // =========================================================================
  // 3. Creative Shapes
  // =========================================================================

  /// Flower avatar with customizable scalloped [petals] (default 8).
  factory Material4AvatarShape.flower({int petals = 8}) {
    return Material4AvatarShape._(
      id: 'flower',
      parameters: {'petals': petals.toDouble()},
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final cx = w / 2.0;
        final cy = h / 2.0;
        final maxR = math.min(w, h) / 2.0;
        final innerR = maxR * 0.78;
        final n = petals.clamp(4, 16);

        for (int i = 0; i < n; i++) {
          final a1 = (i / n) * 2 * math.pi;
          final a2 = ((i + 1) / n) * 2 * math.pi;
          final aMid = (a1 + a2) / 2;

          final p1 =
              Offset(cx + innerR * math.cos(a1), cy + innerR * math.sin(a1));
          final pPeak =
              Offset(cx + maxR * math.cos(aMid), cy + maxR * math.sin(aMid));
          final p2 =
              Offset(cx + innerR * math.cos(a2), cy + innerR * math.sin(a2));

          if (i == 0) {
            path.moveTo(p1.dx, p1.dy);
          }
          path.quadraticBezierTo(pPeak.dx, pPeak.dy, p2.dx, p2.dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Puffy multi-lobed cloud avatar.
  factory Material4AvatarShape.cloud() {
    return Material4AvatarShape._(
      id: 'cloud',
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final cx = w / 2.0;
        final cy = h / 2.0;
        final r = math.min(w, h) / 2.0;

        // 5 overlapping puffy circular lobes
        const lobes = 5;
        for (int i = 0; i < lobes; i++) {
          final a1 = (i / lobes) * 2 * math.pi;
          final a2 = ((i + 1) / lobes) * 2 * math.pi;
          final aMid = (a1 + a2) / 2;

          final p1 = Offset(
              cx + r * 0.72 * math.cos(a1), cy + r * 0.72 * math.sin(a1));
          final pPeak =
              Offset(cx + r * math.cos(aMid), cy + r * math.sin(aMid));
          final p2 = Offset(
              cx + r * 0.72 * math.cos(a2), cy + r * 0.72 * math.sin(a2));

          if (i == 0) path.moveTo(p1.dx, p1.dy);
          path.quadraticBezierTo(pPeak.dx, pPeak.dy, p2.dx, p2.dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Symmetrical [points]-point star avatar (default 5 points) with rounded tips.
  factory Material4AvatarShape.star({
    int points = 5,
    double innerRadiusRatio = 0.58,
    double cornerRadius = 6.0,
  }) {
    return Material4AvatarShape._(
      id: 'star',
      parameters: {
        'points': points.toDouble(),
        'ratio': innerRadiusRatio,
        'radius': cornerRadius,
      },
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final cx = w / 2.0;
        final cy = h / 2.0;
        final outerR = math.min(w, h) / 2.0;
        final innerR = outerR * innerRadiusRatio.clamp(0.3, 0.8);
        final n = points.clamp(3, 12);
        final totalPts = n * 2;

        final pts = <Offset>[];
        for (int i = 0; i < totalPts; i++) {
          final isOuter = i % 2 == 0;
          final r = isOuter ? outerR : innerR;
          final angle = (i * math.pi / n) - (math.pi / 2);
          pts.add(Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)));
        }

        path.moveTo((pts[0].dx + pts[totalPts - 1].dx) / 2,
            (pts[0].dy + pts[totalPts - 1].dy) / 2);
        for (int i = 0; i < totalPts; i++) {
          final curr = pts[i];
          final next = pts[(i + 1) % totalPts];
          final mid = Offset((curr.dx + next.dx) / 2, (curr.dy + next.dy) / 2);
          path.quadraticBezierTo(curr.dx, curr.dy, mid.dx, mid.dy);
        }
        path.close();
        return path;
      },
    );
  }

  /// Classic heraldic crest shield avatar.
  factory Material4AvatarShape.shield() {
    return Material4AvatarShape._(
      id: 'shield',
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final r = w * 0.18;

        path.moveTo(r, 0);
        path.lineTo(w - r, 0);
        path.quadraticBezierTo(w, 0, w, r);

        // Sides curve inward towards bottom tip
        path.lineTo(w, h * 0.54);
        path.cubicTo(w, h * 0.78, w * 0.7, h * 0.94, w / 2.0, h);
        path.cubicTo(w * 0.3, h * 0.94, 0, h * 0.78, 0, h * 0.54);
        path.lineTo(0, r);
        path.quadraticBezierTo(0, 0, r, 0);
        path.close();
        return path;
      },
    );
  }

  /// Ticket voucher avatar with inward side scallops.
  factory Material4AvatarShape.ticket() {
    return Material4AvatarShape._(
      id: 'ticket',
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;
        final r = math.min(w, h) * 0.16;
        final scR = math.min(w, h) * 0.14;

        path.moveTo(r, 0);
        path.lineTo(w - r, 0);
        path.quadraticBezierTo(w, 0, w, r);

        // Right scallop
        path.lineTo(w, (h / 2) - scR);
        path.arcToPoint(
          Offset(w, (h / 2) + scR),
          radius: Radius.circular(scR),
          clockwise: false,
        );
        path.lineTo(w, h - r);
        path.quadraticBezierTo(w, h, w - r, h);

        path.lineTo(r, h);
        path.quadraticBezierTo(0, h, 0, h - r);

        // Left scallop
        path.lineTo(0, (h / 2) + scR);
        path.arcToPoint(
          Offset(0, (h / 2) - scR),
          radius: Radius.circular(scR),
          clockwise: false,
        );
        path.lineTo(0, r);
        path.quadraticBezierTo(0, 0, r, 0);
        path.close();
        return path;
      },
    );
  }

  /// Dynamic abstract geometric avatar with asymmetrical chamfers and facets.
  factory Material4AvatarShape.abstractGeometric() {
    return Material4AvatarShape._(
      id: 'abstractGeometric',
      pathBuilder: (size) {
        final path = Path();
        final w = size.width;
        final h = size.height;

        path.moveTo(w * 0.32, 0);
        path.lineTo(w * 0.84, 0);
        path.lineTo(w, h * 0.38);
        path.lineTo(w * 0.88, h);
        path.lineTo(w * 0.22, h * 0.94);
        path.lineTo(0, h * 0.62);
        path.lineTo(w * 0.08, h * 0.22);
        path.close();
        return path;
      },
    );
  }

  /// Fully custom Bézier path generator.
  factory Material4AvatarShape.customBezier({
    required Path Function(Size size) pathBuilder,
    String id = 'customBezier',
  }) {
    return Material4AvatarShape._(
      id: id,
      pathBuilder: pathBuilder,
    );
  }

  /// Adapts any [Material4Config] from the core Material 4 geometry engine into an avatar shape.
  factory Material4AvatarShape.fromConfig(Material4Config config) {
    return Material4AvatarShape._(
      id: 'config_${config.type.name}',
      config: config,
      pathBuilder: (size) => Material4PathBuilder.buildPath(size, config),
    );
  }

  /// Adapts any [Material4CardShape] into an avatar shape.
  factory Material4AvatarShape.fromOrganicCardShape(
      Material4CardShape cardShape) {
    return Material4AvatarShape._(
      id: 'organicCardShape',
      organicShape: cardShape,
      pathBuilder: (size) => OrganicShapePathBuilder.buildPath(size, cardShape),
    );
  }

  // =========================================================================
  // Interpolation & Equality
  // =========================================================================

  /// Linearly interpolates between two [Material4AvatarShape] instances.
  static Material4AvatarShape lerp(
    Material4AvatarShape? a,
    Material4AvatarShape? b,
    double t, {
    int samples = 72,
  }) {
    if (a == null && b == null) return Material4AvatarShape.circle();
    if (a == null) return b!;
    if (b == null) return a;
    if (t <= 0.0) return a;
    if (t >= 1.0) return b;

    return Material4AvatarShape._(
      id: 'lerp_${a.id}_to_${b.id}_${(t * 100).round()}',
      pathBuilder: (size) {
        final ptsA = _AvatarContourCache.getOrComputeSamples(a, size, samples);
        final ptsB = _AvatarContourCache.getOrComputeSamples(b, size, samples);

        if (ptsA.isEmpty) return b.buildPath(size);
        if (ptsB.isEmpty) return a.buildPath(size);

        final count = math.min(ptsA.length, ptsB.length);
        final pts = <Offset>[];
        for (int i = 0; i < count; i++) {
          final pA = ptsA[i];
          final pB = ptsB[i];
          pts.add(Offset(
            pA.dx + (pB.dx - pA.dx) * t,
            pA.dy + (pB.dy - pA.dy) * t,
          ));
        }

        final path = Path();
        path.moveTo(
          (pts.first.dx + pts.last.dx) / 2.0,
          (pts.first.dy + pts.last.dy) / 2.0,
        );
        for (int i = 0; i < count; i++) {
          final curr = pts[i];
          final next = pts[(i + 1) % count];
          final mid = Offset((curr.dx + next.dx) / 2.0, (curr.dy + next.dy) / 2.0);
          path.quadraticBezierTo(curr.dx, curr.dy, mid.dx, mid.dy);
        }
        path.close();
        return path;
      },
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material4AvatarShape &&
        other.id == id &&
        other.config == config &&
        other.organicShape == organicShape;
  }

  @override
  int get hashCode => Object.hash(id, config, organicShape);
}

/// Internal cache for contour samples and phase-aligned path points.
class _AvatarContourCache {
  static final Map<String, List<Offset>> _sampleCache = {};
  static const int _maxCacheSize = 128;

  /// Retrieves cached contour samples or computes and aligns them starting from top-center.
  static List<Offset> getOrComputeSamples(
    Material4AvatarShape shape,
    Size size,
    int samples,
  ) {
    if (size.width <= 0 || size.height <= 0) return const [];
    final key = '${shape.id}_${size.width.toInt()}x${size.height.toInt()}_$samples';
    final cached = _sampleCache[key];
    if (cached != null) return cached;

    final path = shape.buildPath(size);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return const [];

    final metric = metrics.first;
    final totalLen = metric.length;
    if (totalLen <= 0) return const [];

    final rawPts = <Offset>[];
    for (int i = 0; i < samples; i++) {
      final frac = i / samples;
      final tangent = metric.getTangentForOffset(frac * totalLen);
      rawPts.add(tangent?.position ?? Offset.zero);
    }

    // Phase alignment: find point closest to top-center (size.width / 2, 0)
    final topCenter = Offset(size.width / 2.0, 0.0);
    int bestIndex = 0;
    double bestDistSq = double.infinity;
    for (int i = 0; i < rawPts.length; i++) {
      final p = rawPts[i];
      final dx = p.dx - topCenter.dx;
      final dy = p.dy - topCenter.dy;
      final dSq = dx * dx + dy * dy;
      if (dSq < bestDistSq) {
        bestDistSq = dSq;
        bestIndex = i;
      }
    }

    // Rotate points so index 0 always begins at top-center
    final alignedPts = <Offset>[];
    for (int i = 0; i < samples; i++) {
      alignedPts.add(rawPts[(bestIndex + i) % samples]);
    }

    if (_sampleCache.length >= _maxCacheSize) {
      _sampleCache.remove(_sampleCache.keys.first);
    }
    _sampleCache[key] = alignedPts;
    return alignedPts;
  }
}

