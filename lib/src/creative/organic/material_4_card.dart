import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../cards/material_dynamic_card.dart';
import 'card_material_type.dart';
import 'material_4_card_border.dart';
import 'organic_card_shape.dart';
import 'organic_shape_path_builder.dart';

/// A premium, hardware-accelerated organic card component for Material 4.
///
/// Implements sculpted, asymmetric, and organic geometries with smooth concave notches,
/// convex bulges, physical material finishes, path-following outlines, and geometry-aware
/// negative space.
class Material4Card extends StatefulWidget {
  /// The organic geometric shape defining the card's silhouette.
  final Material4CardShape shape;

  /// Background surface color (defaults to soft pastel lavender matching reference design).
  final Color backgroundColor;

  /// Physical material finish of the card surface.
  final CardMaterialType material;

  /// Border and outline configuration following the custom path.
  final Material4CardBorder border;

  /// Box shadows cast by the custom shape contour.
  final List<BoxShadow> shadows;

  /// Internal padding for child content (automatically combined with geometry-aware safe insets).
  final EdgeInsetsGeometry padding;

  /// External margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Explicit width in logical pixels.
  final double? width;

  /// Explicit height in logical pixels.
  final double? height;

  /// Interactive tap callback.
  final VoidCallback? onTap;

  /// Long press callback.
  final VoidCallback? onLongPress;

  /// Primary headline text or widget.
  final dynamic title;

  /// Secondary subtitle or description.
  final dynamic subtitle;

  /// Leading, trailing, or accent icon (Widget or IconData).
  final dynamic icon;

  /// Placement of the accent icon relative to content.
  final CardIconPosition iconPosition;

  /// Optional chip or badge label.
  final String? badge;

  /// Custom child widget. If specified, takes precedence over [title]/[subtitle]/[icon].
  final Widget? child;

  /// Whether to enable spring tactile press animation.
  final bool enablePressScale;

  /// Whether to enable hover elevation animation.
  final bool enableHoverElevation;

  const Material4Card({
    super.key,
    this.shape = const Material4CardShape(),
    this.backgroundColor = const Color(0xFFDDBCFB),
    this.material = CardMaterialType.softPastel,
    this.border = const Material4CardBorder.thin(),
    this.shadows = const [
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
    this.title,
    this.subtitle,
    this.icon,
    this.iconPosition = CardIconPosition.trailing,
    this.badge,
    this.child,
    this.enablePressScale = true,
    this.enableHoverElevation = true,
  });

  // =========================================================================
  // 10 Built-in Preset Constructors
  // =========================================================================

  /// 1. Primary Reference Design: Notice Board Card.
  ///
  /// Recreates the reference design with soft pastel purple/lavender, asymmetric
  /// corners, a smooth concave notch on the lower-right edge, and a crisp dark outline.
  factory Material4Card.noticeBoard({
    Key? key,
    dynamic title = 'Notice Board',
    dynamic subtitle,
    dynamic icon = Icons.campaign_outlined,
    Color backgroundColor = const Color(0xFFDDBCFB),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF1E1E24),
      width: 1.2,
    ),
    double cornerRadius = 24.0,
    double notchDepth = 18.0,
    double notchWidth = 54.0,
    double notchPosition = 0.68,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.noticeBoard(
        cornerRadius: cornerRadius,
        notchDepth: notchDepth,
        notchWidth: notchWidth,
        notchPosition: notchPosition,
      ),
      backgroundColor: backgroundColor,
      material: CardMaterialType.softPastel,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconPosition: CardIconPosition.trailing,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  /// 2. Sculpted Information Card.
  factory Material4Card.sculptedInfo({
    Key? key,
    dynamic title,
    dynamic subtitle,
    dynamic icon = Icons.info_outline_rounded,
    Color backgroundColor = const Color(0xFFD0E6FF),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF1E293B),
      width: 1.2,
    ),
    double domeRadius = 36.0,
    double waistDepth = 14.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.sculptedInfo(
        domeRadius: domeRadius,
        waistDepth: waistDepth,
      ),
      backgroundColor: backgroundColor,
      material: CardMaterialType.softPastel,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconPosition: CardIconPosition.leading,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  /// 3. Asymmetric Feature Card.
  factory Material4Card.asymmetricFeature({
    Key? key,
    dynamic title,
    dynamic subtitle,
    dynamic icon = Icons.star_border_rounded,
    Color backgroundColor = const Color(0xFFFFD8D8),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF3B1E1E),
      width: 1.2,
    ),
    double majorRadius = 38.0,
    double minorRadius = 12.0,
    double bulgeHeight = 10.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.asymmetricFeature(
        majorRadius: majorRadius,
        minorRadius: minorRadius,
        bulgeHeight: bulgeHeight,
      ),
      backgroundColor: backgroundColor,
      material: CardMaterialType.softPastel,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  /// 4. Soft Concave Notch Card.
  factory Material4Card.softNotch({
    Key? key,
    dynamic title,
    dynamic subtitle,
    dynamic icon = Icons.notifications_none_rounded,
    Color backgroundColor = const Color(0xFFD5F2E3),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF1E3A2B),
      width: 1.2,
    ),
    double cornerRadius = 22.0,
    double notchDepth = 16.0,
    double notchWidth = 64.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.softNotch(
        cornerRadius: cornerRadius,
        notchDepth: notchDepth,
        notchWidth: notchWidth,
      ),
      backgroundColor: backgroundColor,
      material: CardMaterialType.softPastel,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconPosition: CardIconPosition.leading,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  /// 5. Floating Organic Card.
  factory Material4Card.floatingOrganic({
    Key? key,
    dynamic title,
    dynamic subtitle,
    dynamic icon = Icons.auto_awesome_rounded,
    Color backgroundColor = const Color(0xFFFFF3CD),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF4A3E1E),
      width: 1.2,
    ),
    double baseRadius = 22.0,
    double organicDelta = 12.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.floatingOrganic(
        baseRadius: baseRadius,
        organicDelta: organicDelta,
      ),
      backgroundColor: backgroundColor,
      material: CardMaterialType.softPastel,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  /// 6. Fluid Pebble Blob Surface Card.
  factory Material4Card.blobSurface({
    Key? key,
    dynamic title,
    dynamic subtitle,
    dynamic icon,
    Color backgroundColor = const Color(0xFFF0E5FF),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF361E4A),
      width: 1.2,
    ),
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.blobSurface(),
      backgroundColor: backgroundColor,
      material: CardMaterialType.clay,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  /// 7. Curved Dynamic Edge Card.
  factory Material4Card.curvedEdge({
    Key? key,
    dynamic title,
    dynamic subtitle,
    dynamic icon = Icons.insights_rounded,
    Color backgroundColor = const Color(0xFFE2F0D9),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF263A1E),
      width: 1.2,
    ),
    double cornerRadius = 20.0,
    double topArchHeight = 14.0,
    double bottomScoopDepth = 12.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.curvedEdge(
        cornerRadius: cornerRadius,
        topArchHeight: topArchHeight,
        bottomScoopDepth: bottomScoopDepth,
      ),
      backgroundColor: backgroundColor,
      material: CardMaterialType.softPastel,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  /// 8. Creative Dashboard Card.
  factory Material4Card.creativeDashboard({
    Key? key,
    dynamic title,
    dynamic subtitle,
    dynamic icon = Icons.dashboard_customize_outlined,
    Color backgroundColor = const Color(0xFFE0F7FA),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF004D40),
      width: 1.2,
    ),
    double baseRadius = 20.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.creativeDashboard(baseRadius: baseRadius),
      backgroundColor: backgroundColor,
      material: CardMaterialType.softPastel,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  /// 9. Sculpted Action Pocket Card.
  factory Material4Card.sculptedAction({
    Key? key,
    dynamic title,
    dynamic subtitle,
    dynamic icon = Icons.arrow_forward_rounded,
    Color backgroundColor = const Color(0xFFFBE4D8),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF4A281E),
      width: 1.2,
    ),
    double cornerRadius = 20.0,
    double actionPocketDepth = 22.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.sculptedAction(
        cornerRadius: cornerRadius,
        actionPocketDepth: actionPocketDepth,
      ),
      backgroundColor: backgroundColor,
      material: CardMaterialType.softPastel,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconPosition: CardIconPosition.trailing,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  /// 10. Material 4 Signature Card.
  factory Material4Card.signature({
    Key? key,
    dynamic title = 'Material 4 Signature',
    dynamic subtitle = 'Organic Sculpted Geometry Engine',
    dynamic icon = Icons.verified_outlined,
    Color backgroundColor = const Color(0xFFEADBFF),
    Material4CardBorder border = const Material4CardBorder.thin(
      color: Color(0xFF2A1E4A),
      width: 1.2,
    ),
    double primaryRadius = 30.0,
    double notchDepth = 20.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    VoidCallback? onTap,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Material4Card(
      key: key,
      shape: Material4CardShape.signature(
        primaryRadius: primaryRadius,
        notchDepth: notchDepth,
      ),
      backgroundColor: backgroundColor,
      material: CardMaterialType.softPastel,
      border: border,
      padding: padding,
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconPosition: CardIconPosition.trailing,
      onTap: onTap,
      width: width,
      height: height,
      child: child,
    );
  }

  @override
  State<Material4Card> createState() => _Material4CardState();
}

class _Material4CardState extends State<Material4Card>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.975).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePressScale && widget.onTap != null) {
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePressScale && widget.onTap != null) {
      _pressController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePressScale && widget.onTap != null) {
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (widget.child != null) {
      content = widget.child!;
    } else {
      content = _buildDefaultContent();
    }

    Widget cardWidget = _Material4CardRenderWidget(
      shape: widget.shape,
      backgroundColor: widget.backgroundColor,
      material: widget.material,
      border: widget.border,
      shadows: _buildActiveShadows(),
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      child: content,
    );

    if (widget.onTap != null || widget.onLongPress != null) {
      cardWidget = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          if (widget.enableHoverElevation && mounted) {
            setState(() => _isHovered = true);
          }
        },
        onExit: (_) {
          if (widget.enableHoverElevation && mounted) {
            setState(() => _isHovered = false);
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: cardWidget,
          ),
        ),
      );
    }

    if (widget.margin != null) {
      cardWidget = Padding(padding: widget.margin!, child: cardWidget);
    }

    return cardWidget;
  }

  List<BoxShadow> _buildActiveShadows() {
    if (_isHovered) {
      return widget.shadows.map((s) {
        return BoxShadow(
          color: s.color.withValues(alpha: math.min(1.0, s.color.a * 1.5)),
          blurRadius: s.blurRadius * 1.6,
          offset: Offset(s.offset.dx, s.offset.dy + 3.0),
        );
      }).toList();
    }
    return widget.shadows;
  }

  Widget _buildDefaultContent() {
    Widget? iconWidget;
    if (widget.icon != null) {
      if (widget.icon is Widget) {
        iconWidget = widget.icon as Widget;
      } else if (widget.icon is IconData) {
        iconWidget = Icon(
          widget.icon as IconData,
          size: 26,
          color: const Color(0xFF1E1E24),
        );
      }
    }

    Widget? titleWidget;
    if (widget.title != null) {
      if (widget.title is Widget) {
        titleWidget = widget.title as Widget;
      } else {
        titleWidget = Text(
          widget.title.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Color(0xFF1E1E24),
            letterSpacing: -0.3,
          ),
        );
      }
    }

    Widget? subtitleWidget;
    if (widget.subtitle != null) {
      if (widget.subtitle is Widget) {
        subtitleWidget = widget.subtitle as Widget;
      } else {
        subtitleWidget = Text(
          widget.subtitle.toString(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: const Color(0xFF1E1E24).withValues(alpha: 0.72),
          ),
        );
      }
    }

    final textColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.iconPosition == CardIconPosition.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (titleWidget != null) titleWidget,
        if (titleWidget != null && subtitleWidget != null)
          const SizedBox(height: 3),
        if (subtitleWidget != null) subtitleWidget,
      ],
    );

    final Widget layoutWidget;
    if (iconWidget == null) {
      layoutWidget = textColumn;
    } else {
      switch (widget.iconPosition) {
        case CardIconPosition.leading:
          layoutWidget = Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 14),
              Flexible(child: textColumn),
            ],
          );
          break;

        case CardIconPosition.top:
          layoutWidget = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconWidget,
              const SizedBox(height: 6),
              Flexible(child: textColumn),
            ],
          );
          break;

        case CardIconPosition.bottom:
          layoutWidget = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: textColumn),
              const SizedBox(height: 6),
              iconWidget,
            ],
          );
          break;

        case CardIconPosition.center:
          layoutWidget = Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                iconWidget,
                const SizedBox(height: 8),
                Flexible(child: textColumn),
              ],
            ),
          );
          break;

        case CardIconPosition.trailing:
        default:
          // Reference Notice Board style: text on left, icon on right
          layoutWidget = Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: textColumn),
              const SizedBox(width: 14),
              iconWidget,
            ],
          );
          break;
      }
    }

    return layoutWidget;
  }
}

// ===========================================================================
// RenderObject Widget & RenderBox Engine
// ===========================================================================

class _Material4CardRenderWidget extends SingleChildRenderObjectWidget {
  final Material4CardShape shape;
  final Color backgroundColor;
  final CardMaterialType material;
  final Material4CardBorder border;
  final List<BoxShadow> shadows;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const _Material4CardRenderWidget({
    required this.shape,
    required this.backgroundColor,
    required this.material,
    required this.border,
    required this.shadows,
    required this.padding,
    this.width,
    this.height,
    super.child,
  });

  @override
  RenderMaterial4Card createRenderObject(BuildContext context) {
    return RenderMaterial4Card(
      shape: shape,
      backgroundColor: backgroundColor,
      material: material,
      border: border,
      shadows: shadows,
      padding: padding,
      width: width,
      height: height,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderMaterial4Card renderObject) {
    renderObject
      ..shape = shape
      ..backgroundColor = backgroundColor
      ..material = material
      ..border = border
      ..shadows = shadows
      ..padding = padding
      ..explicitWidth = width
      ..explicitHeight = height;
  }
}

/// Custom RenderBox powering [Material4Card] with exact path painting,
/// geometry-aware safe insets layout, sub-pixel hit testing, and paint/layout separation.
class RenderMaterial4Card extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  Material4CardShape _shape;
  Color _backgroundColor;
  CardMaterialType _material;
  Material4CardBorder _border;
  List<BoxShadow> _shadows;
  EdgeInsetsGeometry _padding;
  double? _explicitWidth;
  double? _explicitHeight;

  Path? _cachedPath;
  Size? _cachedPathSize;

  RenderMaterial4Card({
    required Material4CardShape shape,
    required Color backgroundColor,
    required CardMaterialType material,
    required Material4CardBorder border,
    required List<BoxShadow> shadows,
    required EdgeInsetsGeometry padding,
    double? width,
    double? height,
    RenderBox? child,
  })  : _shape = shape,
        _backgroundColor = backgroundColor,
        _material = material,
        _border = border,
        _shadows = shadows,
        _padding = padding,
        _explicitWidth = width,
        _explicitHeight = height {
    this.child = child;
  }

  // --- Properties with Invalidation Separation ---

  Material4CardShape get shape => _shape;
  set shape(Material4CardShape value) {
    if (_shape == value) return;
    _shape = value;
    _cachedPath = null;
    markNeedsLayout();
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color value) {
    if (_backgroundColor == value) return;
    _backgroundColor = value;
    markNeedsPaint();
  }

  CardMaterialType get material => _material;
  set material(CardMaterialType value) {
    if (_material == value) return;
    _material = value;
    markNeedsPaint();
  }

  Material4CardBorder get border => _border;
  set border(Material4CardBorder value) {
    if (_border == value) return;
    _border = value;
    markNeedsPaint();
  }

  List<BoxShadow> get shadows => _shadows;
  set shadows(List<BoxShadow> value) {
    if (_shadows == value) return;
    _shadows = value;
    markNeedsPaint();
  }

  EdgeInsetsGeometry get padding => _padding;
  set padding(EdgeInsetsGeometry value) {
    if (_padding == value) return;
    _padding = value;
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

  Path get currentPath {
    if (_cachedPath != null && _cachedPathSize == size) {
      return _cachedPath!;
    }
    _cachedPathSize = size;
    _cachedPath = OrganicShapePathBuilder.buildPath(size, _shape);
    return _cachedPath!;
  }

  // --- Layout Engine ---

  @override
  void performLayout() {
    final double? targetW = _explicitWidth;
    final double? targetH = _explicitHeight;

    final EdgeInsets resolvedPadding = _padding.resolve(TextDirection.ltr);

    if (child != null) {
      final safeInsets = OrganicShapePathBuilder.getSafeInsets(
        Size(targetW ?? constraints.maxWidth, targetH ?? constraints.maxHeight),
        _shape,
      );

      final totalInsets = EdgeInsets.fromLTRB(
        math.max(resolvedPadding.left, safeInsets.left),
        math.max(resolvedPadding.top, safeInsets.top),
        math.max(resolvedPadding.right, safeInsets.right),
        math.max(resolvedPadding.bottom, safeInsets.bottom),
      );

      final childConstraints = constraints.deflate(totalInsets).loosen();
      child!.layout(childConstraints, parentUsesSize: true);

      final childWidth = child!.size.width + totalInsets.horizontal;
      final childHeight = child!.size.height + totalInsets.vertical;

      final resolvedW = targetW ?? constraints.constrainWidth(childWidth);
      final resolvedH = targetH ?? constraints.constrainHeight(childHeight);

      size = Size(resolvedW, resolvedH);

      final childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset(totalInsets.left, totalInsets.top);
    } else {
      final resolvedW = targetW ?? constraints.constrainWidth(0);
      final resolvedH = targetH ?? constraints.constrainHeight(0);
      size = Size(resolvedW, resolvedH);
    }

    _cachedPath = null;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final double? targetW = _explicitWidth;
    final double? targetH = _explicitHeight;

    if (child != null) {
      final resolvedPadding = _padding.resolve(TextDirection.ltr);
      final safeInsets = OrganicShapePathBuilder.getSafeInsets(
        Size(targetW ?? constraints.maxWidth, targetH ?? constraints.maxHeight),
        _shape,
      );
      final totalInsets = EdgeInsets.fromLTRB(
        math.max(resolvedPadding.left, safeInsets.left),
        math.max(resolvedPadding.top, safeInsets.top),
        math.max(resolvedPadding.right, safeInsets.right),
        math.max(resolvedPadding.bottom, safeInsets.bottom),
      );

      final childConstraints = constraints.deflate(totalInsets).loosen();
      final childSize = child!.getDryLayout(childConstraints);

      final childWidth = childSize.width + totalInsets.horizontal;
      final childHeight = childSize.height + totalInsets.vertical;

      final resolvedW = targetW ?? constraints.constrainWidth(childWidth);
      final resolvedH = targetH ?? constraints.constrainHeight(childHeight);
      return Size(resolvedW, resolvedH);
    }

    final resolvedW = targetW ?? constraints.constrainWidth(0);
    final resolvedH = targetH ?? constraints.constrainHeight(0);
    return Size(resolvedW, resolvedH);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!size.contains(position)) return false;

    // Sub-pixel point-in-path contour precision
    if (!currentPath.contains(position)) return false;

    if (hitTestChildren(result, position: position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }

    result.add(BoxHitTestEntry(this, position));
    return true;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child == null) return false;
    final childParentData = child!.parentData! as BoxParentData;
    return result.addWithPaintOffset(
      offset: childParentData.offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        return child!.hitTest(result, position: transformed);
      },
    );
  }

  // --- Painting Pipeline ---

  @override
  void paint(PaintingContext context, Offset offset) {
    if (size.width <= 0 || size.height <= 0) return;

    final Canvas canvas = context.canvas;
    final Path path = currentPath;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // 1. Cast shadow following custom path contour
    for (final shadow in _shadows) {
      final shadowPaint = shadow.toPaint();
      final shadowPath = path.shift(shadow.offset);
      canvas.drawPath(shadowPath, shadowPaint);
    }

    // 2. Physical Material Surface
    final bounds = Rect.fromLTWH(0, 0, size.width, size.height);
    CardMaterialRenderer.paintSurface(
      canvas: canvas,
      path: path,
      bounds: bounds,
      baseColor: _backgroundColor,
      material: _material,
    );

    // 3. Child Painting (clipped to organic shape path)
    if (child != null) {
      canvas.save();
      canvas.clipPath(path, doAntiAlias: true);
      final childParentData = child!.parentData! as BoxParentData;
      context.paintChild(child!, childParentData.offset);
      canvas.restore();
    }

    // 4. Custom Path Border Outline
    _border.paintBorder(canvas, size, path);

    canvas.restore();
  }
}
