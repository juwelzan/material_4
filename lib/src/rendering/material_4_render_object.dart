import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import '../layout/shape_content_protection.dart';
import '../layout/shape_safe_region.dart';
import '../material_4_config.dart';
import '../material_4_path_builder.dart';
import 'material_4_clip_manager.dart';
import 'material_4_hit_test.dart';
import 'material_4_interaction.dart';
import 'material_4_layout_manager.dart';
import 'material_4_painter.dart';
import 'material_4_parent_data.dart';
import 'material_4_semantics.dart';

/// Central hardware-accelerated [RenderBox] engine for dynamic vector shapes.
///
/// Responsible for:
/// - Exact vector path generation and caching
/// - Shape-aware content protection and safe insets layout
/// - Direct Canvas rendering (backgrounds, borders, patterns, shadows, shimmer)
/// - Point-in-path hit testing with transformation coordinate mapping
/// - Fine-grained clipping and accessibility semantics
class RenderMaterial4 extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  Material4Config _config;
  Color? _color;
  Gradient? _gradient;
  Color _borderColor;
  double _borderWidth;
  List<BoxShadow>? _shadows;
  Clip _clipBehavior;
  ShapeContentProtection _contentProtection;
  ShapeHitTestBehavior _hitTestBehavior;
  Material4Interaction? _interaction;
  ShapeClipConfig? _clipConfig;
  VoidCallback? _onTap;
  VoidCallback? _onLongPress;
  VoidCallback? _onDoubleTap;
  EdgeInsetsGeometry? _padding;
  AlignmentGeometry? _alignment;
  TextDirection _textDirection;
  double? _explicitWidth;
  double? _explicitHeight;
  String? _semanticLabel;
  String? _semanticHint;

  /// Cached vector path for current [size].
  Path? _currentPath;

  RenderMaterial4({
    required Material4Config config,
    Color? color,
    Gradient? gradient,
    Color borderColor = const Color(0x18000000),
    double borderWidth = 1.0,
    List<BoxShadow>? shadows,
    Clip clipBehavior = Clip.antiAlias,
    ShapeContentProtection contentProtection = const ShapeContentProtection(),
    ShapeHitTestBehavior hitTestBehavior = ShapeHitTestBehavior.shapeContour,
    Material4Interaction? interaction,
    ShapeClipConfig? clipConfig,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    TextDirection textDirection = TextDirection.ltr,
    double? width,
    double? height,
    String? semanticLabel,
    String? semanticHint,
    RenderBox? child,
  })  : _config = config,
        _color = color,
        _gradient = gradient,
        _borderColor = borderColor,
        _borderWidth = borderWidth,
        _shadows = shadows,
        _clipBehavior = clipBehavior,
        _contentProtection = contentProtection,
        _hitTestBehavior = hitTestBehavior,
        _interaction = interaction,
        _clipConfig = clipConfig,
        _onTap = onTap,
        _onLongPress = onLongPress,
        _onDoubleTap = onDoubleTap,
        _padding = padding,
        _alignment = alignment,
        _textDirection = textDirection,
        _explicitWidth = width,
        _explicitHeight = height,
        _semanticLabel = semanticLabel,
        _semanticHint = semanticHint {
    this.child = child;
  }

  // =========================================================================
  // Property Getters & Setters with Invalidation Separation
  // =========================================================================

  Material4Config get config => _config;
  set config(Material4Config value) {
    if (_config == value) return;
    final needsLayoutRecompute = _config.cornerRadius != value.cornerRadius ||
        _config.corners != value.corners ||
        _config.edges != value.edges ||
        _config.notches != value.notches ||
        _config.transform != value.transform ||
        _config.constraints != value.constraints ||
        _config.type != value.type ||
        _config.tabWidth != value.tabWidth ||
        _config.tabHeight != value.tabHeight ||
        _config.waveCount != value.waveCount ||
        _config.waveAmplitude != value.waveAmplitude;

    _config = value;
    _currentPath = null;
    if (needsLayoutRecompute) {
      markNeedsLayout();
    } else {
      markNeedsPaint();
    }
  }

  Color? get color => _color;
  set color(Color? value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Gradient? get gradient => _gradient;
  set gradient(Gradient? value) {
    if (_gradient == value) return;
    _gradient = value;
    markNeedsPaint();
  }

  Color get borderColor => _borderColor;
  set borderColor(Color value) {
    if (_borderColor == value) return;
    _borderColor = value;
    markNeedsPaint();
  }

  double get borderWidth => _borderWidth;
  set borderWidth(double value) {
    if (_borderWidth == value) return;
    _borderWidth = value;
    markNeedsLayout();
  }

  List<BoxShadow>? get shadows => _shadows;
  set shadows(List<BoxShadow>? value) {
    if (_shadows == value) return;
    _shadows = value;
    markNeedsPaint();
  }

  Clip get clipBehavior => _clipBehavior;
  set clipBehavior(Clip value) {
    if (_clipBehavior == value) return;
    _clipBehavior = value;
    markNeedsPaint();
  }

  ShapeContentProtection get contentProtection => _contentProtection;
  set contentProtection(ShapeContentProtection value) {
    if (_contentProtection == value) return;
    _contentProtection = value;
    markNeedsLayout();
  }

  ShapeHitTestBehavior get hitTestBehavior => _hitTestBehavior;
  set hitTestBehavior(ShapeHitTestBehavior value) {
    if (_hitTestBehavior == value) return;
    _hitTestBehavior = value;
  }

  Material4Interaction? get interaction => _interaction;
  set interaction(Material4Interaction? value) {
    if (_interaction == value) return;
    _interaction = value;
  }

  ShapeClipConfig? get clipConfig => _clipConfig;
  set clipConfig(ShapeClipConfig? value) {
    if (_clipConfig == value) return;
    _clipConfig = value;
    markNeedsPaint();
  }

  VoidCallback? get onTap => _onTap;
  set onTap(VoidCallback? value) {
    if (_onTap == value) return;
    final hadTap = _onTap != null;
    _onTap = value;
    _syncRecognizers();
    if (hadTap != (_onTap != null)) {
      markNeedsSemanticsUpdate();
    }
  }

  VoidCallback? get onLongPress => _onLongPress;
  set onLongPress(VoidCallback? value) {
    if (_onLongPress == value) return;
    final hadLongPress = _onLongPress != null;
    _onLongPress = value;
    _syncRecognizers();
    if (hadLongPress != (_onLongPress != null)) {
      markNeedsSemanticsUpdate();
    }
  }

  VoidCallback? get onDoubleTap => _onDoubleTap;
  set onDoubleTap(VoidCallback? value) {
    if (_onDoubleTap == value) return;
    _onDoubleTap = value;
    _syncRecognizers();
  }

  EdgeInsetsGeometry? get padding => _padding;
  set padding(EdgeInsetsGeometry? value) {
    if (_padding == value) return;
    _padding = value;
    markNeedsLayout();
  }

  AlignmentGeometry? get alignment => _alignment;
  set alignment(AlignmentGeometry? value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  double? get explicitWidth => _explicitWidth;
  set explicitWidth(double? value) {
    if (_explicitWidth == value) return;
    _explicitWidth = value;
    markNeedsLayout();
  }

  double? get explicitHeight => _explicitHeight;
  set explicitHeight(double? value) {
    if (_explicitHeight == value) return;
    _explicitHeight = value;
    markNeedsLayout();
  }

  String? get semanticLabel => _semanticLabel;
  set semanticLabel(String? value) {
    if (_semanticLabel == value) return;
    _semanticLabel = value;
    markNeedsSemanticsUpdate();
  }

  String? get semanticHint => _semanticHint;
  set semanticHint(String? value) {
    if (_semanticHint == value) return;
    _semanticHint = value;
    markNeedsSemanticsUpdate();
  }

  TapGestureRecognizer? _tapRecognizer;
  LongPressGestureRecognizer? _longPressRecognizer;
  DoubleTapGestureRecognizer? _doubleTapRecognizer;

  void _syncRecognizers() {
    if (!attached) return;
    _tapRecognizer?.dispose();
    _tapRecognizer =
        _onTap != null ? (TapGestureRecognizer()..onTap = _onTap) : null;
    _longPressRecognizer?.dispose();
    _longPressRecognizer = _onLongPress != null
        ? (LongPressGestureRecognizer()..onLongPress = _onLongPress)
        : null;
    _doubleTapRecognizer?.dispose();
    _doubleTapRecognizer = _onDoubleTap != null
        ? (DoubleTapGestureRecognizer()..onDoubleTap = _onDoubleTap)
        : null;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _syncRecognizers();
  }

  @override
  void detach() {
    _tapRecognizer?.dispose();
    _tapRecognizer = null;
    _longPressRecognizer?.dispose();
    _longPressRecognizer = null;
    _doubleTapRecognizer?.dispose();
    _doubleTapRecognizer = null;
    super.detach();
  }

  @override
  void dispose() {
    _tapRecognizer?.dispose();
    _tapRecognizer = null;
    _longPressRecognizer?.dispose();
    _longPressRecognizer = null;
    _doubleTapRecognizer?.dispose();
    _doubleTapRecognizer = null;
    _currentPath = null;
    super.dispose();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! Material4ParentData) {
      child.parentData = Material4ParentData();
    }
  }

  // =========================================================================
  // Geometry Path Retrieval
  // =========================================================================

  /// Resolves the current vector [Path] for this RenderBox size.
  Path get currentPath {
    if (_currentPath != null) return _currentPath!;
    _currentPath = Material4PathBuilder.buildPath(size, _config);
    return _currentPath!;
  }

  EdgeInsets _computeEffectiveInsets(Size tentativeSize) {
    final base = _padding?.resolve(_textDirection) ?? EdgeInsets.zero;
    if (!_contentProtection.autoPadding ||
        _contentProtection.mode == ContentProtectionMode.visibleOverflow) {
      return base;
    }

    return ShapeSafeRegion.computeSafeInsets(
      size: tentativeSize,
      config: _config,
      basePadding: base,
      borderWidth: _borderWidth,
      textDirection: _textDirection,
    );
  }

  // =========================================================================
  // Layout & Sizing
  // =========================================================================

  @override
  void performLayout() {
    _currentPath = null;
    final w = _explicitWidth;
    final h = _explicitHeight;

    // Determine target size bounds from incoming constraints without arbitrary fallbacks
    final double tentativeWidth = w ??
        (constraints.hasBoundedWidth
            ? constraints.maxWidth
            : constraints.minWidth);
    final double tentativeHeight = h ??
        (constraints.hasBoundedHeight
            ? constraints.maxHeight
            : constraints.minHeight);
    final tentativeSize = Size(tentativeWidth, tentativeHeight);

    final insets = _computeEffectiveInsets(tentativeSize);

    if (child != null) {
      final effectiveInsets =
          _contentProtection.mode == ContentProtectionMode.visibleOverflow
              ? (_padding?.resolve(_textDirection) ?? EdgeInsets.zero)
              : insets;

      final maxAvailableW = w != null
          ? math.max(0.0, w - effectiveInsets.horizontal)
          : (constraints.hasBoundedWidth
              ? math.max(0.0, constraints.maxWidth - effectiveInsets.horizontal)
              : double.infinity);

      final maxAvailableH = h != null
          ? math.max(0.0, h - effectiveInsets.vertical)
          : (constraints.hasBoundedHeight
              ? math.max(0.0, constraints.maxHeight - effectiveInsets.vertical)
              : double.infinity);

      final minAvailableW = constraints.minWidth > 0
          ? math.max(0.0, constraints.minWidth - effectiveInsets.horizontal)
          : 0.0;
      final minAvailableH = constraints.minHeight > 0
          ? math.max(0.0, constraints.minHeight - effectiveInsets.vertical)
          : 0.0;

      final childConstraints = BoxConstraints(
        minWidth: math.min(minAvailableW, maxAvailableW),
        maxWidth: maxAvailableW,
        minHeight: math.min(minAvailableH, maxAvailableH),
        maxHeight: maxAvailableH,
      );

      child!.layout(childConstraints, parentUsesSize: true);

      // If constraints were unbounded along an axis, recompute effective insets
      // using the child's actual measured dimensions to ensure features (e.g. tabs,
      // scallops, corners) are not scaled to zero by sanitize()
      final safeReferenceSize = Size(
        w ??
            (constraints.hasBoundedWidth
                ? constraints.maxWidth
                : math.max(100.0, child!.size.width)),
        h ??
            (constraints.hasBoundedHeight
                ? constraints.maxHeight
                : math.max(100.0, child!.size.height)),
      );
      final resolvedInsets = _computeEffectiveInsets(safeReferenceSize);

      double desiredW;
      if (w != null) {
        desiredW = w;
      } else if (constraints.hasTightWidth) {
        desiredW = constraints.maxWidth;
      } else {
        desiredW = child!.size.width + resolvedInsets.horizontal;
      }

      double desiredH;
      if (h != null) {
        desiredH = h;
      } else if (constraints.hasTightHeight) {
        desiredH = constraints.maxHeight;
      } else {
        desiredH = child!.size.height + resolvedInsets.vertical;
      }

      final targetRatio = _config.resolvedTransform.targetAspectRatio;
      if (targetRatio != null && targetRatio > 0) {
        if (w != null && h == null) {
          desiredH = desiredW / targetRatio;
        } else if (h != null && w == null) {
          desiredW = desiredH * targetRatio;
        }
      }

      final clampedSize = constraints.constrain(Size(desiredW, desiredH));
      size = _config.constraints.clampSize(clampedSize);

      // Re-evaluate insets with finalized size
      final finalInsets = _computeEffectiveInsets(size);
      final childParentData = child!.parentData! as Material4ParentData;
      final availableW = math.max(0.0, size.width - finalInsets.horizontal);
      final availableH = math.max(0.0, size.height - finalInsets.vertical);

      final resolvedAlignment =
          childParentData.alignment?.resolve(_textDirection) ??
              _alignment?.resolve(_textDirection);

      if (resolvedAlignment != null) {
        final deltaX = math.max(0.0, availableW - child!.size.width);
        final deltaY = math.max(0.0, availableH - child!.size.height);
        final alignX = (resolvedAlignment.x + 1.0) / 2.0 * deltaX;
        final alignY = (resolvedAlignment.y + 1.0) / 2.0 * deltaY;
        childParentData.offset =
            Offset(finalInsets.left + alignX, finalInsets.top + alignY);
      } else {
        childParentData.offset = Offset(finalInsets.left, finalInsets.top);
      }
    } else {
      double desiredW = w ?? constraints.minWidth;
      double desiredH = h ?? constraints.minHeight;
      final targetRatio = _config.resolvedTransform.targetAspectRatio;
      if (targetRatio != null && targetRatio > 0) {
        if (w != null && h == null) {
          desiredH = desiredW / targetRatio;
        } else if (h != null && w == null) {
          desiredW = desiredH * targetRatio;
        }
      }
      final clampedSize = constraints.constrain(Size(desiredW, desiredH));
      size = _config.constraints.clampSize(clampedSize);
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final w = _explicitWidth;
    final h = _explicitHeight;

    final double tentativeWidth = w ??
        (constraints.hasBoundedWidth
            ? constraints.maxWidth
            : constraints.minWidth);
    final double tentativeHeight = h ??
        (constraints.hasBoundedHeight
            ? constraints.maxHeight
            : constraints.minHeight);
    final tentativeSize = Size(tentativeWidth, tentativeHeight);

    final insets = _computeEffectiveInsets(tentativeSize);

    if (child != null) {
      final effectiveInsets =
          _contentProtection.mode == ContentProtectionMode.visibleOverflow
              ? (_padding?.resolve(_textDirection) ?? EdgeInsets.zero)
              : insets;

      final maxAvailableW = w != null
          ? math.max(0.0, w - effectiveInsets.horizontal)
          : (constraints.hasBoundedWidth
              ? math.max(0.0, constraints.maxWidth - effectiveInsets.horizontal)
              : double.infinity);

      final maxAvailableH = h != null
          ? math.max(0.0, h - effectiveInsets.vertical)
          : (constraints.hasBoundedHeight
              ? math.max(0.0, constraints.maxHeight - effectiveInsets.vertical)
              : double.infinity);

      final minAvailableW = constraints.minWidth > 0
          ? math.max(0.0, constraints.minWidth - effectiveInsets.horizontal)
          : 0.0;
      final minAvailableH = constraints.minHeight > 0
          ? math.max(0.0, constraints.minHeight - effectiveInsets.vertical)
          : 0.0;

      final childConstraints = BoxConstraints(
        minWidth: math.min(minAvailableW, maxAvailableW),
        maxWidth: maxAvailableW,
        minHeight: math.min(minAvailableH, maxAvailableH),
        maxHeight: maxAvailableH,
      );

      final childSize = child!.getDryLayout(childConstraints);

      final safeReferenceSize = Size(
        w ??
            (constraints.hasBoundedWidth
                ? constraints.maxWidth
                : math.max(100.0, childSize.width)),
        h ??
            (constraints.hasBoundedHeight
                ? constraints.maxHeight
                : math.max(100.0, childSize.height)),
      );
      final resolvedInsets = _computeEffectiveInsets(safeReferenceSize);

      double desiredW;
      if (w != null) {
        desiredW = w;
      } else if (constraints.hasTightWidth) {
        desiredW = constraints.maxWidth;
      } else {
        desiredW = childSize.width + resolvedInsets.horizontal;
      }

      double desiredH;
      if (h != null) {
        desiredH = h;
      } else if (constraints.hasTightHeight) {
        desiredH = constraints.maxHeight;
      } else {
        desiredH = childSize.height + resolvedInsets.vertical;
      }

      final targetRatio = _config.resolvedTransform.targetAspectRatio;
      if (targetRatio != null && targetRatio > 0) {
        if (w != null && h == null) {
          desiredH = desiredW / targetRatio;
        } else if (h != null && w == null) {
          desiredW = desiredH * targetRatio;
        }
      }

      final clampedSize = constraints.constrain(Size(desiredW, desiredH));
      return _config.constraints.clampSize(clampedSize);
    } else {
      double desiredW = w ?? constraints.minWidth;
      double desiredH = h ?? constraints.minHeight;
      final targetRatio = _config.resolvedTransform.targetAspectRatio;
      if (targetRatio != null && targetRatio > 0) {
        if (w != null && h == null) {
          desiredH = desiredW / targetRatio;
        } else if (h != null && w == null) {
          desiredW = desiredH * targetRatio;
        }
      }
      final clampedSize = constraints.constrain(Size(desiredW, desiredH));
      return _config.constraints.clampSize(clampedSize);
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return Material4LayoutManager.computeMinIntrinsicWidth(
      height: height,
      child: child,
      config: _config,
      padding: _padding,
      explicitWidth: _explicitWidth,
      borderWidth: _borderWidth,
      textDirection: _textDirection,
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return Material4LayoutManager.computeMaxIntrinsicWidth(
      height: height,
      child: child,
      config: _config,
      padding: _padding,
      explicitWidth: _explicitWidth,
      borderWidth: _borderWidth,
      textDirection: _textDirection,
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return Material4LayoutManager.computeMinIntrinsicHeight(
      width: width,
      child: child,
      config: _config,
      padding: _padding,
      explicitHeight: _explicitHeight,
      borderWidth: _borderWidth,
      textDirection: _textDirection,
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return Material4LayoutManager.computeMaxIntrinsicHeight(
      width: width,
      child: child,
      config: _config,
      padding: _padding,
      explicitHeight: _explicitHeight,
      borderWidth: _borderWidth,
      textDirection: _textDirection,
    );
  }

  // =========================================================================
  // Painting & Direct Canvas Rendering Pipeline
  // =========================================================================

  @override
  Rect get paintBounds {
    var bounds = Offset.zero & size;

    // 1. Account for stroke alignment (outside or center)
    if (_borderWidth > 0 && _borderColor.a > 0) {
      final double strokeOverflow;
      switch (_config.strokeAlign) {
        case ShapeStrokeAlign.outside:
          strokeOverflow = _borderWidth;
          break;
        case ShapeStrokeAlign.center:
          strokeOverflow = _borderWidth / 2.0;
          break;
        case ShapeStrokeAlign.inside:
          strokeOverflow = 0.0;
          break;
      }
      if (strokeOverflow > 0) {
        bounds = bounds.inflate(strokeOverflow);
      }
    }

    // 2. Account for multi-layer borders if present
    if (_config.borderStyle == BorderStyleType.multiLayer &&
        _config.multiLayerBorders != null) {
      double maxLayerOffset = 0.0;
      for (final layer in _config.multiLayerBorders!) {
        final totalExtent = layer.offset + layer.width;
        if (totalExtent > maxLayerOffset) {
          maxLayerOffset = totalExtent;
        }
      }
      if (maxLayerOffset > 0) {
        bounds = bounds.inflate(maxLayerOffset);
      }
    }

    // 3. Neo-Brutalism 3D offset block
    if (_config.borderStyle == BorderStyleType.neo3d) {
      final neoBounds = (Offset.zero & size).shift(_config.neoOffset);
      bounds = bounds.expandToInclude(neoBounds);
    }

    // 4. Ambient colored glow halo
    if (_config.borderStyle == BorderStyleType.glow) {
      final glowInflation =
          (_borderWidth * 1.25) + (_config.glowBlurRadius * 2.0);
      bounds =
          bounds.expandToInclude((Offset.zero & size).inflate(glowInflation));
    }

    // 5. Neon pulse bloom halo
    if (_config.borderStyle == BorderStyleType.neonPulse) {
      final intensity = _config.neonPulseIntensity.clamp(0.1, 3.0);
      final neonInflation =
          (_borderWidth * 1.75 * intensity) + (16.0 * intensity * 2.0);
      bounds =
          bounds.expandToInclude((Offset.zero & size).inflate(neonInflation));
    }

    // Creative border expansion (Phase 7.1)
    if (_config.creativeBorder != null) {
      final cb = _config.creativeBorder!;
      final borderExtent =
          cb.width + (cb.tearShadow ? cb.tearShadowBlur * 2.0 : 0.0);
      bounds = bounds.inflate(borderExtent);
      if (cb.shadow != null) {
        final s = cb.shadow!;
        final shadowInflation = s.blurRadius * 2.0 + s.spreadRadius;
        final shadowBounds =
            (Offset.zero & size).shift(s.offset).inflate(shadowInflation);
        bounds = bounds.expandToInclude(shadowBounds);
      }
    }

    // 6. Outer drop shadows
    if (_config.borderStyle != BorderStyleType.neo3d &&
        _shadows != null &&
        _shadows!.isNotEmpty) {
      for (final shadow in _shadows!) {
        final shadowInflation = shadow.blurRadius * 2.0 + shadow.spreadRadius;
        final shadowBounds =
            (Offset.zero & size).shift(shadow.offset).inflate(shadowInflation);
        bounds = bounds.expandToInclude(shadowBounds);
      }
    }

    // 7. Child visible overflow
    if (child != null &&
        _contentProtection.mode == ContentProtectionMode.visibleOverflow) {
      final childParentData = child!.parentData as Material4ParentData?;
      if (childParentData != null) {
        final childBounds = child!.paintBounds.shift(childParentData.offset);
        bounds = bounds.expandToInclude(childBounds);
      }
    }

    // 8. Shape path bounds (handles outward tabs, outward speech bubble tails, scale > 1.0)
    final pathBounds = currentPath.getBounds();
    bounds = bounds.expandToInclude(pathBounds);

    // 9. If overflow clipping is explicitly enabled, clamp to container rectangular bounds
    if (Material4ClipManager.shouldClipOverflow(
      config: _config,
      clipConfig: _clipConfig,
    )) {
      bounds = bounds.intersect(Offset.zero & size);
    }

    return bounds;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (size.width <= 0 || size.height <= 0) return;

    if (Material4ClipManager.shouldClipOverflow(
      config: _config,
      clipConfig: _clipConfig,
    )) {
      Material4ClipManager.paintWithRectClip(
        context: context,
        offset: offset,
        clipRect: Offset.zero & size,
        clipBehavior: _clipBehavior,
        painter: (c, o) => _paintLayers(c, o),
      );
    } else {
      _paintLayers(context, offset);
    }
  }

  void _paintLayers(PaintingContext context, Offset offset) {
    // Stage 1: Calculate or retrieve shape geometry
    final path = currentPath;
    final canvas = context.canvas;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // Stage 2: Outer shadows (Neo-3D hard block, soft drop shadows, glow halo)
    Material4Painter.paintOuterShadows(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
      borderColor: _borderColor,
      borderWidth: _borderWidth,
      shadows: _shadows,
    );

    // Stage 3: Shape background & procedural background effects
    Material4Painter.paintBackground(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
      color: _color,
      gradient: _gradient,
    );

    // Stage 4: Background patterns (stripes, dots, grid, waves)
    Material4Painter.paintPatterns(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
      color: _color,
    );

    // Stage 5: Background effects & inner shadows (tactile inset shadows)
    Material4Painter.paintInnerShadows(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
    );

    // Stage 6: Distinctive borders (all 20 border styles with stroke alignment & reveal)
    Material4Painter.paintBorders(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
      borderColor: _borderColor,
      borderWidth: _borderWidth,
    );

    // Stage 7: Foreground decorations (holographic shimmer light sweep)
    Material4Painter.paintForegroundDecorations(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
    );

    canvas.restore();

    // Stage 8: Child painting with selective clipping
    if (child != null) {
      final childParentData = child!.parentData! as Material4ParentData;
      final childOffset = offset + childParentData.offset;

      if (Material4ClipManager.shouldClipChild(
        protection: _contentProtection,
        config: _config,
        clipBehavior: _clipBehavior,
        clipConfig: _clipConfig,
      )) {
        Material4ClipManager.paintWithClip(
          context: context,
          offset: offset,
          bounds: Offset.zero & size,
          clipPath: path,
          clipBehavior: _clipBehavior,
          painter: (childContext, _) {
            childContext.paintChild(child!, childOffset);
          },
        );
      } else {
        context.paintChild(child!, childOffset);
      }
    }
  }

  // =========================================================================
  // Hit Testing & Coordinate Transformations
  // =========================================================================

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.width <= 0 || size.height <= 0) return false;

    final effectiveInteraction = _interaction ??
        _config.interaction ??
        Material4Interaction(hitTestBehavior: _hitTestBehavior);

    final behavior = effectiveInteraction.hitTestBehavior;

    // 1. Point-in-shape evaluation via Material4HitTester
    final bool isInsideShapeOrBox = Material4HitTester.containsPoint(
      path: currentPath,
      size: size,
      position: position,
      config: _config,
      transform: _config.resolvedTransform,
      behavior: behavior,
      interaction: effectiveInteraction,
      pathIsTransformed: true,
    );

    // 2. DeferToChild mode: only children receive interaction, shape itself never claims hits
    if (behavior == ShapeHitTestBehavior.deferToChild) {
      if (child != null && effectiveInteraction.enableChildHitTesting) {
        final hitChild = hitTestChildren(result, position: position);
        if (hitChild) {
          result.add(BoxHitTestEntry(this, position));
          return true;
        }
      }
      return false;
    }

    // 3. Child hit testing
    final bool canHitChild = effectiveInteraction.enableChildHitTesting &&
        (_contentProtection.mode == ContentProtectionMode.visibleOverflow
            ? (Offset.zero & size).contains(position)
            : isInsideShapeOrBox);

    bool hitChild = false;
    if (canHitChild && child != null) {
      hitChild = hitTestChildren(result, position: position);
    }

    if (hitChild) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    // 4. Opaque mode: claims hit across rectangular bounds even without onTap
    if (behavior == ShapeHitTestBehavior.opaque) {
      if ((Offset.zero & size).contains(position) &&
          effectiveInteraction.enableShapeHitTesting) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
      return false;
    }

    // 5. Interactive shape body hit testing
    if (isInsideShapeOrBox) {
      if (_onTap != null || _onLongPress != null || _onDoubleTap != null) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
      if (behavior == ShapeHitTestBehavior.translucent &&
          effectiveInteraction.enableShapeHitTesting) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }

    return false;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child == null) return false;
    final childParentData = child!.parentData! as Material4ParentData;
    return result.addWithPaintOffset(
      offset: childParentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == position - childParentData.offset);
        return child!.hitTest(result, position: transformed);
      },
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final childParentData = child.parentData! as Material4ParentData;
    transform.translateByDouble(
      childParentData.offset.dx,
      childParentData.offset.dy,
      0.0,
      1.0,
    );
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    Material4Semantics.applySemantics(
      config: config,
      onTap: _onTap,
      onLongPress: _onLongPress,
      semanticLabel: _semanticLabel,
      semanticHint: _semanticHint,
    );
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapRecognizer?.addPointer(event);
      _longPressRecognizer?.addPointer(event);
      _doubleTapRecognizer?.addPointer(event);
    }
  }
}
