import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import '../layout/shape_anchor_placer.dart';
import '../layout/shape_collision_detector.dart';
import '../layout/shape_content_protection.dart';
import '../layout/shape_safe_region.dart';
import '../material_4_config.dart';
import '../material_4_path_builder.dart';
import '../material_4_stack.dart';
import 'material_4_clip_manager.dart';
import 'material_4_hit_test.dart';
import 'material_4_interaction.dart';
import 'material_4_multi_child_parent_data.dart';
import 'material_4_painter.dart';
import 'material_4_semantics.dart';

/// Central hardware-accelerated Multi-Child [RenderBox] engine for dynamic vector shapes.
///
/// Responsibilities:
/// - Intelligent multi-child geometry-aware measurement and positioning
/// - Multi-region safe area distribution for complex shapes (notches, scallops, tabs)
/// - Collision detection and automatic resolution across sibling children
/// - Direct Canvas rendering (backgrounds, borders, patterns, shadows, shimmer)
/// - Fine-grained clipping and accessible semantics
class RenderMultiChildMaterial4 extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, Material4MultiChildParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            Material4MultiChildParentData> {
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
  AlignmentGeometry _alignment;
  ShapeLayoutStrategy _layoutStrategy;
  double _spacing;
  ShapeCollisionPolicy _collisionPolicy;
  TextDirection _textDirection;
  double? _explicitWidth;
  double? _explicitHeight;
  String? _semanticLabel;
  String? _semanticHint;

  /// Cached vector path for current [size].
  Path? _currentPath;

  /// Diagnostic reports recorded during layout.
  final List<ShapeLayoutDiagnostic> _layoutDiagnostics = [];

  RenderMultiChildMaterial4({
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
    AlignmentGeometry alignment = Alignment.center,
    ShapeLayoutStrategy layoutStrategy = ShapeLayoutStrategy.stack,
    double spacing = 8.0,
    ShapeCollisionPolicy collisionPolicy = ShapeCollisionPolicy.reposition,
    TextDirection textDirection = TextDirection.ltr,
    double? width,
    double? height,
    String? semanticLabel,
    String? semanticHint,
    List<RenderBox>? children,
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
        _layoutStrategy = layoutStrategy,
        _spacing = spacing,
        _collisionPolicy = collisionPolicy,
        _textDirection = textDirection,
        _explicitWidth = width,
        _explicitHeight = height,
        _semanticLabel = semanticLabel,
        _semanticHint = semanticHint {
    addAll(children);
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

  AlignmentGeometry get alignment => _alignment;
  set alignment(AlignmentGeometry value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

  ShapeLayoutStrategy get layoutStrategy => _layoutStrategy;
  set layoutStrategy(ShapeLayoutStrategy value) {
    if (_layoutStrategy == value) return;
    _layoutStrategy = value;
    markNeedsLayout();
  }

  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  ShapeCollisionPolicy get collisionPolicy => _collisionPolicy;
  set collisionPolicy(ShapeCollisionPolicy value) {
    if (_collisionPolicy == value) return;
    _collisionPolicy = value;
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

  /// Diagnostic reports produced during the latest layout pass.
  List<ShapeLayoutDiagnostic> get layoutDiagnostics =>
      List.unmodifiable(_layoutDiagnostics);

  /// Convenient alias for [layoutDiagnostics].
  List<ShapeLayoutDiagnostic> get diagnostics => layoutDiagnostics;

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
    _layoutDiagnostics.clear();
    super.dispose();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! Material4MultiChildParentData) {
      child.parentData = Material4MultiChildParentData();
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

  // =========================================================================
  // Layout & Multi-Child Placement Engine
  // =========================================================================

  @override
  void performLayout() {
    _currentPath = null;
    _layoutDiagnostics.clear();

    final w = _explicitWidth;
    final h = _explicitHeight;

    final tentativeW = w ??
        (constraints.hasBoundedWidth
            ? constraints.maxWidth
            : constraints.minWidth);
    final tentativeH = h ??
        (constraints.hasBoundedHeight
            ? constraints.maxHeight
            : constraints.minHeight);
    final tentativeSize = Size(tentativeW, tentativeH);

    final resolvedPadding =
        _padding?.resolve(_textDirection) ?? EdgeInsets.zero;
    final safeRegionSet = ShapeSafeRegion.computeSafeRegionSet(
      size: tentativeSize,
      config: _config,
      basePadding: resolvedPadding,
      borderWidth: _borderWidth,
      textDirection: _textDirection,
    );

    final effectiveSafeBounds =
        _contentProtection.mode == ContentProtectionMode.visibleOverflow
            ? (Offset.zero & tentativeSize)
            : safeRegionSet.primary;

    final placedRects = <Rect>[];
    double maxContentRight = 0.0;
    double maxContentBottom = 0.0;

    switch (_layoutStrategy) {
      case ShapeLayoutStrategy.stack:
        _layoutStack(
          safeBounds: effectiveSafeBounds,
          placedRects: placedRects,
        );
        break;

      case ShapeLayoutStrategy.flowVertical:
        _layoutFlowVertical(
          safeBounds: effectiveSafeBounds,
          placedRects: placedRects,
        );
        break;

      case ShapeLayoutStrategy.flowHorizontal:
        _layoutFlowHorizontal(
          safeBounds: effectiveSafeBounds,
          placedRects: placedRects,
        );
        break;

      case ShapeLayoutStrategy.anchor:
        _layoutAnchor(
          containerSize: tentativeSize,
          placedRects: placedRects,
        );
        break;

      case ShapeLayoutStrategy.adaptive:
        _layoutAdaptive(
          safeRegionSet: safeRegionSet,
          placedRects: placedRects,
        );
        break;
    }

    // Determine content bounding footprint
    for (final rect in placedRects) {
      if (rect.right > maxContentRight) maxContentRight = rect.right;
      if (rect.bottom > maxContentBottom) maxContentBottom = rect.bottom;
    }

    // Determine final container dimensions
    double desiredW;
    if (w != null) {
      desiredW = w;
    } else if (constraints.hasTightWidth) {
      desiredW = constraints.maxWidth;
    } else {
      desiredW = math.max(
        constraints.minWidth,
        maxContentRight + safeRegionSet.insets.right,
      );
    }

    double desiredH;
    if (h != null) {
      desiredH = h;
    } else if (constraints.hasTightHeight) {
      desiredH = constraints.maxHeight;
    } else {
      desiredH = math.max(
        constraints.minHeight,
        maxContentBottom + safeRegionSet.insets.bottom,
      );
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

    // Final validation pass for strict mode diagnostics
    if (_contentProtection.mode == ContentProtectionMode.strict) {
      int idx = 0;
      RenderBox? child = firstChild;
      while (child != null) {
        final childParentData =
            child.parentData! as Material4MultiChildParentData;
        final childRect = childParentData.offset & child.size;
        if (!effectiveSafeBounds.contains(childRect.topLeft) ||
            !effectiveSafeBounds.contains(childRect.bottomRight)) {
          _layoutDiagnostics.add(
            ShapeLayoutDiagnostic(
              childIndex: idx,
              message:
                  'Child #$idx exceeds safe shape region ($effectiveSafeBounds). Content may clip.',
              severity: ShapeDiagnosticSeverity.error,
              candidateRect: childRect,
              safeRegion: effectiveSafeBounds,
            ),
          );
        }
        idx++;
        child = childParentData.nextSibling;
      }
    }
  }

  void _layoutStack({
    required Rect safeBounds,
    required List<Rect> placedRects,
  }) {
    int index = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      final childConstraints = _createChildConstraints(
        childParentData: childParentData,
        safeBounds: safeBounds,
      );

      child.layout(childConstraints, parentUsesSize: true);

      final align = childParentData.alignment ?? _alignment;
      final resolvedAlign = align.resolve(_textDirection);

      final availW = math.max(0.0, safeBounds.width - child.size.width);
      final availH = math.max(0.0, safeBounds.height - child.size.height);

      final alignOffset = resolvedAlign.alongOffset(Offset(availW, availH));
      var childRect = Rect.fromLTWH(
        safeBounds.left + alignOffset.dx + childParentData.margin.left,
        safeBounds.top + alignOffset.dy + childParentData.margin.top,
        child.size.width,
        child.size.height,
      );

      // Handle anchor positioning if configured
      if (childParentData.anchor != null) {
        final pt = ShapeAnchorPlacer.resolveAnchorPoint(
          size: Size(safeBounds.width, safeBounds.height),
          anchor: childParentData.anchor!,
          config: _config,
          textDirection: _textDirection,
        );
        childRect = Rect.fromLTWH(
          safeBounds.left +
              pt.dx -
              (child.size.width / 2.0) +
              childParentData.margin.left,
          safeBounds.top +
              pt.dy -
              (child.size.height / 2.0) +
              childParentData.margin.top,
          child.size.width,
          child.size.height,
        );
      }

      // Check collision with previously placed siblings
      final policy = childParentData.collisionPolicy;
      final resolution = ShapeCollisionDetector.resolveChildPosition(
        candidateRect: childRect,
        placedRects: placedRects,
        safeBounds: safeBounds,
        policy: policy,
        spacing: _spacing,
        direction: Axis.vertical,
      );

      if (resolution.repositioned) {
        childRect = resolution.rect;
      } else if (!resolution.collisionAvoided &&
          policy == ShapeCollisionPolicy.warn) {
        _layoutDiagnostics.add(
          ShapeLayoutDiagnostic(
            childIndex: index,
            message: 'Child overlaps with sibling elements in stack layout.',
            severity: ShapeDiagnosticSeverity.warning,
            candidateRect: childRect,
            safeRegion: safeBounds,
          ),
        );
      }

      childParentData.offset = childRect.topLeft;
      placedRects.add(childRect);

      index++;
      child = childParentData.nextSibling;
    }
  }

  void _layoutFlowVertical({
    required Rect safeBounds,
    required List<Rect> placedRects,
  }) {
    double currentY = safeBounds.top;
    RenderBox? child = firstChild;

    while (child != null) {
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      final childConstraints = _createChildConstraints(
        childParentData: childParentData,
        safeBounds: safeBounds,
        direction: Axis.vertical,
      );

      child.layout(childConstraints, parentUsesSize: true);

      final align = childParentData.alignment ?? _alignment;
      final resolvedAlign = align.resolve(_textDirection);
      final availW = math.max(0.0, safeBounds.width - child.size.width);
      final alignX = (availW / 2.0) + (resolvedAlign.x * availW / 2.0);

      final childRect = Rect.fromLTWH(
        safeBounds.left + alignX + childParentData.margin.left,
        currentY + childParentData.margin.top,
        child.size.width,
        child.size.height,
      );

      childParentData.offset = childRect.topLeft;
      placedRects.add(childRect);

      currentY +=
          child.size.height + childParentData.margin.vertical + _spacing;

      child = childParentData.nextSibling;
    }
  }

  void _layoutFlowHorizontal({
    required Rect safeBounds,
    required List<Rect> placedRects,
  }) {
    final isRtl = _textDirection == TextDirection.rtl;
    double currentX = isRtl ? safeBounds.right : safeBounds.left;
    RenderBox? child = firstChild;

    while (child != null) {
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      final childConstraints = _createChildConstraints(
        childParentData: childParentData,
        safeBounds: safeBounds,
        direction: Axis.horizontal,
      );

      child.layout(childConstraints, parentUsesSize: true);

      final align = childParentData.alignment ?? _alignment;
      final resolvedAlign = align.resolve(_textDirection);
      final availH = math.max(0.0, safeBounds.height - child.size.height);
      final alignY = (availH / 2.0) + (resolvedAlign.y * availH / 2.0);

      final double childX = isRtl
          ? (currentX - child.size.width - childParentData.margin.right)
          : (currentX + childParentData.margin.left);

      final childRect = Rect.fromLTWH(
        childX,
        safeBounds.top + alignY + childParentData.margin.top,
        child.size.width,
        child.size.height,
      );

      childParentData.offset = childRect.topLeft;
      placedRects.add(childRect);

      final step =
          child.size.width + childParentData.margin.horizontal + _spacing;
      currentX += isRtl ? -step : step;

      child = childParentData.nextSibling;
    }
  }

  void _layoutAnchor({
    required Size containerSize,
    required List<Rect> placedRects,
  }) {
    RenderBox? child = firstChild;

    while (child != null) {
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      final anchor = childParentData.anchor ?? ShapeAnchor.center;

      final childConstraints = BoxConstraints(
        minWidth: childParentData.minWidth ?? 0.0,
        maxWidth: childParentData.maxWidth ?? containerSize.width,
        minHeight: childParentData.minHeight ?? 0.0,
        maxHeight: childParentData.maxHeight ?? containerSize.height,
      );

      child.layout(childConstraints, parentUsesSize: true);

      final anchorPoint = ShapeAnchorPlacer.resolveAnchorPoint(
        size: containerSize,
        anchor: anchor,
        config: _config,
        textDirection: _textDirection,
      );

      final childRect = Rect.fromLTWH(
        anchorPoint.dx -
            (child.size.width / 2.0) +
            childParentData.margin.left -
            childParentData.margin.right,
        anchorPoint.dy -
            (child.size.height / 2.0) +
            childParentData.margin.top -
            childParentData.margin.bottom,
        child.size.width,
        child.size.height,
      );

      childParentData.offset = childRect.topLeft;
      placedRects.add(childRect);

      child = childParentData.nextSibling;
    }
  }

  void _layoutAdaptive({
    required ShapeSafeRegionSet safeRegionSet,
    required List<Rect> placedRects,
  }) {
    // 1. Collect and sort children by priority descending (highest priority placed first)
    final entries = <({RenderBox child, int priority, int originalIndex})>[];
    int idx = 0;
    RenderBox? c = firstChild;
    while (c != null) {
      final pd = c.parentData! as Material4MultiChildParentData;
      entries.add((child: c, priority: pd.priority, originalIndex: idx));
      idx++;
      c = pd.nextSibling;
    }

    entries.sort((a, b) => b.priority.compareTo(a.priority));

    for (final entry in entries) {
      final child = entry.child;
      final childParentData =
          child.parentData! as Material4MultiChildParentData;

      // Estimate dry size to find best safe region
      final estimateConstraints = BoxConstraints(
        minWidth: 0.0,
        maxWidth: safeRegionSet.primary.width,
        minHeight: 0.0,
        maxHeight: safeRegionSet.primary.height,
      );
      final drySize = child.getDryLayout(estimateConstraints);

      // Find best fitting safe region
      final targetRegion = safeRegionSet.findBestRegionForSize(drySize);

      final childConstraints = _createChildConstraints(
        childParentData: childParentData,
        safeBounds: targetRegion,
      );
      child.layout(childConstraints, parentUsesSize: true);

      final align = childParentData.alignment ?? _alignment;
      final resolvedAlign = align.resolve(_textDirection);
      final availW = math.max(0.0, targetRegion.width - child.size.width);
      final availH = math.max(0.0, targetRegion.height - child.size.height);

      final alignOffset = resolvedAlign.alongOffset(Offset(availW, availH));
      var childRect = Rect.fromLTWH(
        targetRegion.left + alignOffset.dx + childParentData.margin.left,
        targetRegion.top + alignOffset.dy + childParentData.margin.top,
        child.size.width,
        child.size.height,
      );

      final resolution = ShapeCollisionDetector.resolveChildPosition(
        candidateRect: childRect,
        placedRects: placedRects,
        safeBounds: targetRegion,
        policy: childParentData.collisionPolicy,
        spacing: _spacing,
      );

      if (resolution.repositioned) {
        childRect = resolution.rect;
      }

      childParentData.offset = childRect.topLeft;
      placedRects.add(childRect);
    }
  }

  BoxConstraints _createChildConstraints({
    required Material4MultiChildParentData childParentData,
    required Rect safeBounds,
    Axis? direction,
  }) {
    if (_contentProtection.mode == ContentProtectionMode.visibleOverflow ||
        childParentData.allowOverflow) {
      return BoxConstraints(
        minWidth: childParentData.minWidth ?? 0.0,
        maxWidth: childParentData.maxWidth ?? double.infinity,
        minHeight: childParentData.minHeight ?? 0.0,
        maxHeight: childParentData.maxHeight ?? double.infinity,
      );
    }

    final maxW = childParentData.maxWidth != null
        ? math.min(childParentData.maxWidth!, safeBounds.width)
        : (direction == Axis.horizontal ? double.infinity : safeBounds.width);

    final maxH = childParentData.maxHeight != null
        ? math.min(childParentData.maxHeight!, safeBounds.height)
        : (direction == Axis.vertical ? double.infinity : safeBounds.height);

    final minW = childParentData.minWidth != null
        ? math.min(childParentData.minWidth!, maxW)
        : 0.0;
    final minH = childParentData.minHeight != null
        ? math.min(childParentData.minHeight!, maxH)
        : 0.0;

    return BoxConstraints(
      minWidth: minW,
      maxWidth: maxW,
      minHeight: minH,
      maxHeight: maxH,
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final w = _explicitWidth;
    final h = _explicitHeight;

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

  // =========================================================================
  // Intrinsic Dimensions
  // =========================================================================

  @override
  double computeMinIntrinsicWidth(double height) {
    double width = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      final childW = child.getMinIntrinsicWidth(height) +
          childParentData.margin.horizontal;
      if (_layoutStrategy == ShapeLayoutStrategy.flowHorizontal) {
        width += childW + _spacing;
      } else {
        if (childW > width) width = childW;
      }
      child = childParentData.nextSibling;
    }
    final insets =
        _padding?.resolve(_textDirection).horizontal ?? _borderWidth * 2.0;
    return width + insets;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    double width = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      final childW = child.getMaxIntrinsicWidth(height) +
          childParentData.margin.horizontal;
      if (_layoutStrategy == ShapeLayoutStrategy.flowHorizontal) {
        width += childW + _spacing;
      } else {
        if (childW > width) width = childW;
      }
      child = childParentData.nextSibling;
    }
    final insets =
        _padding?.resolve(_textDirection).horizontal ?? _borderWidth * 2.0;
    return width + insets;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    double height = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      final childH =
          child.getMinIntrinsicHeight(width) + childParentData.margin.vertical;
      if (_layoutStrategy == ShapeLayoutStrategy.flowVertical) {
        height += childH + _spacing;
      } else {
        if (childH > height) height = childH;
      }
      child = childParentData.nextSibling;
    }
    final insets =
        _padding?.resolve(_textDirection).vertical ?? _borderWidth * 2.0;
    return height + insets;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    double height = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      final childH =
          child.getMaxIntrinsicHeight(width) + childParentData.margin.vertical;
      if (_layoutStrategy == ShapeLayoutStrategy.flowVertical) {
        height += childH + _spacing;
      } else {
        if (childH > height) height = childH;
      }
      child = childParentData.nextSibling;
    }
    final insets =
        _padding?.resolve(_textDirection).vertical ?? _borderWidth * 2.0;
    return height + insets;
  }

  // =========================================================================
  // Painting & Direct Canvas Rendering Pipeline
  // =========================================================================

  @override
  Rect get paintBounds {
    var bounds = Offset.zero & size;

    // 1. Account for stroke alignment
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

    // 2. Multi-layer borders
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

    // 7. Child visible overflow across all children
    if (_contentProtection.mode == ContentProtectionMode.visibleOverflow) {
      RenderBox? child = firstChild;
      while (child != null) {
        final childParentData =
            child.parentData as Material4MultiChildParentData?;
        if (childParentData != null) {
          final childBounds = child.paintBounds.shift(childParentData.offset);
          bounds = bounds.expandToInclude(childBounds);
        }
        child = childParentData?.nextSibling;
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
    // Stage 1: Vector Path Geometry
    final path = currentPath;
    final canvas = context.canvas;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // Stage 2: Outer Shadows
    Material4Painter.paintOuterShadows(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
      borderColor: _borderColor,
      borderWidth: _borderWidth,
      shadows: _shadows,
    );

    // Stage 3: Shape Background & Procedural Effects
    Material4Painter.paintBackground(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
      color: _color,
      gradient: _gradient,
    );

    // Stage 4: Background Patterns
    Material4Painter.paintPatterns(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
      color: _color,
    );

    // Stage 5: Inner Shadows
    Material4Painter.paintInnerShadows(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
    );

    // Stage 6: Distinctive Borders
    Material4Painter.paintBorders(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
      borderColor: _borderColor,
      borderWidth: _borderWidth,
    );

    // Stage 7: Foreground Decorations
    Material4Painter.paintForegroundDecorations(
      canvas: canvas,
      size: size,
      path: path,
      config: _config,
    );

    canvas.restore();

    // Stage 8: Multi-Child Painting with Selective Clipping
    if (firstChild != null) {
      final shouldClip = Material4ClipManager.shouldClipChild(
        protection: _contentProtection,
        config: _config,
        clipBehavior: _clipBehavior,
        clipConfig: _clipConfig,
      );

      if (shouldClip) {
        Material4ClipManager.paintWithClip(
          context: context,
          offset: offset,
          bounds: Offset.zero & size,
          clipPath: path,
          clipBehavior: _clipBehavior,
          painter: (childContext, _) {
            _paintChildren(childContext, offset);
          },
        );
      } else {
        _paintChildren(context, offset);
      }
    }
  }

  void _paintChildren(PaintingContext context, Offset offset) {
    // Collect children and paint in z-order
    final children = <RenderBox>[];
    RenderBox? child = firstChild;
    while (child != null) {
      children.add(child);
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      child = childParentData.nextSibling;
    }

    bool hasCustomZ = children.any(
        (c) => (c.parentData! as Material4MultiChildParentData).zIndex != 0);

    if (hasCustomZ) {
      children.sort((a, b) {
        final zA = (a.parentData! as Material4MultiChildParentData).zIndex;
        final zB = (b.parentData! as Material4MultiChildParentData).zIndex;
        return zA.compareTo(zB);
      });
    }

    for (final c in children) {
      final childParentData = c.parentData! as Material4MultiChildParentData;
      context.paintChild(c, offset + childParentData.offset);
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
      if (firstChild != null && effectiveInteraction.enableChildHitTesting) {
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
    if (canHitChild && firstChild != null) {
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
    if (firstChild == null) return false;

    // Fast path: if no custom zIndex, use default reverse linked-list order
    bool hasCustomZ = false;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      if (childParentData.zIndex != 0) {
        hasCustomZ = true;
        break;
      }
      child = childParentData.nextSibling;
    }

    if (!hasCustomZ) {
      return defaultHitTestChildren(result, position: position);
    }

    // When custom zIndex is present, hit test in reverse paint order (highest zIndex first)
    final sortedChildren = <RenderBox>[];
    child = firstChild;
    while (child != null) {
      sortedChildren.add(child);
      final childParentData =
          child.parentData! as Material4MultiChildParentData;
      child = childParentData.nextSibling;
    }

    sortedChildren.sort((a, b) {
      final zA = (a.parentData! as Material4MultiChildParentData).zIndex;
      final zB = (b.parentData! as Material4MultiChildParentData).zIndex;
      return zA.compareTo(zB);
    });

    for (int i = sortedChildren.length - 1; i >= 0; i--) {
      final c = sortedChildren[i];
      final childParentData = c.parentData! as Material4MultiChildParentData;
      final isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return c.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
    }

    return false;
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    assert(child.parent == this);
    final childParentData = child.parentData! as Material4MultiChildParentData;
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
