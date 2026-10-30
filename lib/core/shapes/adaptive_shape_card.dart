import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dynamic_shape_config.dart';
import 'dynamic_shape_container.dart';
import 'shape_pattern.dart';
import 'shape_smart_layout.dart';

/// A production-ready, highly versatile card widget designed to morph into
/// any dynamic shape while guaranteeing that titles, subtitles, and icons
/// are NEVER clipped, cut off, or overlapped.
///
/// Includes:
/// - Shape-aware safe insets calculation
/// - Tactile spring click/scale animation
/// - Haptic feedback on tap
/// - Optional auto-morph on tap
/// - Intelligent slot placement for icons, titles, and badges
class AdaptiveShapeCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? iconWidget;
  final Widget? badge;
  final DynamicShapeType shapeType;
  final ShapeAnchor anchor;
  final BorderStyleType borderStyle;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final Color? subtitleColor;
  final Color borderColor;
  final double borderWidth;
  final double? width;
  final double height;
  final VoidCallback? onTap;
  final bool enableScaleAnimation;
  final bool autoMorphOnTap;
  final ShapePattern pattern;
  final Color? patternColor;
  final bool isGlassmorphic;
  final bool hasInnerShadow;

  const AdaptiveShapeCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconWidget,
    this.badge,
    this.shapeType = DynamicShapeType.steppedCorner,
    this.anchor = ShapeAnchor.bottomRight,
    this.borderStyle = BorderStyleType.solid,
    this.color,
    this.iconColor,
    this.textColor,
    this.subtitleColor,
    this.borderColor = const Color(0x28000000),
    this.borderWidth = 1.0,
    this.width,
    this.height = 92.0,
    this.onTap,
    this.enableScaleAnimation = true,
    this.autoMorphOnTap = false,
    this.pattern = ShapePattern.none,
    this.patternColor,
    this.isGlassmorphic = false,
    this.hasInnerShadow = false,
  });

  @override
  State<AdaptiveShapeCard> createState() => _AdaptiveShapeCardState();
}

class _AdaptiveShapeCardState extends State<AdaptiveShapeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late DynamicShapeType _currentShape;
  int _shapeCycleIndex = 0;

  static const List<DynamicShapeType> _morphCycle = [
    DynamicShapeType.steppedCorner,
    DynamicShapeType.folderTab,
    DynamicShapeType.notchedBadge,
    DynamicShapeType.sideTab,
    DynamicShapeType.ticketScallop,
    DynamicShapeType.arch,
    DynamicShapeType.shield,
    DynamicShapeType.speechBubble,
    DynamicShapeType.capsule,
    DynamicShapeType.squircle,
    DynamicShapeType.ribbon,
    DynamicShapeType.bookmark,
    DynamicShapeType.hexagonSoft,
  ];

  @override
  void initState() {
    super.initState();
    _currentShape = widget.shapeType;
    _shapeCycleIndex = _morphCycle.indexOf(widget.shapeType);
    if (_shapeCycleIndex == -1) _shapeCycleIndex = 0;

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeInQuad,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AdaptiveShapeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shapeType != widget.shapeType) {
      _currentShape = widget.shapeType;
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enableScaleAnimation) {
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enableScaleAnimation) {
      _pressController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enableScaleAnimation) {
      _pressController.reverse();
    }
  }

  void _handleTap() {
    HapticFeedback.lightImpact();

    if (widget.autoMorphOnTap) {
      setState(() {
        _shapeCycleIndex = (_shapeCycleIndex + 1) % _morphCycle.length;
        _currentShape = _morphCycle[_shapeCycleIndex];
      });
    }

    widget.onTap?.call();
  }

  /// Calculates mathematically safe padding so text and icons are
  /// NEVER clipped or obscured by the shape's tabs, steps, notches, or curves.
  EdgeInsets _calculateSafePadding(
    DynamicShapeType shape,
    ShapeAnchor anchor, [
    TextDirection textDirection = TextDirection.ltr,
  ]) {
    final tempConfig = DynamicShapeConfig(
      type: shape,
      anchor: anchor,
      cornerRadius: 22.0,
      tabWidth: shape == DynamicShapeType.steppedCorner ? 44.0 : 60.0,
      tabHeight: shape == DynamicShapeType.steppedCorner ? 40.0 : 18.0,
      toothWidth: 12.0,
      toothHeight: 8.0,
      scallopRadius: 10.0,
      speechBubbleTailHeight: 14.0,
      ribbonFoldDepth: 18.0,
      waveAmplitude: 8.0,
    );

    return ShapeSmartLayout.computeSafePadding(
      size: const Size(200, 100),
      config: tempConfig,
      textDirection: textDirection,
      basePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? const Color(0xFFF9F7F2);
    final effectiveTextColor = widget.textColor ?? const Color(0xFF1E1E24);
    final effectiveSubColor = widget.subtitleColor ?? const Color(0xFF6B6B75);
    final effectiveIconColor = widget.iconColor ?? effectiveTextColor;

    final shapeConfig = DynamicShapeConfig(
      type: _currentShape,
      anchor: widget.anchor,
      borderStyle: widget.borderStyle,
      pattern: widget.pattern,
      patternColor: widget.patternColor,
      isGlassmorphic: widget.isGlassmorphic,
      innerShadows: widget.hasInnerShadow
          ? const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 6,
                offset: Offset(2, 3),
              ),
              BoxShadow(
                color: Color(0x40FFFFFF),
                blurRadius: 4,
                offset: Offset(-2, -2),
              ),
            ]
          : null,
      cornerRadius: 22.0,
      tabWidth: _currentShape == DynamicShapeType.steppedCorner ? 44.0 : 60.0,
      tabHeight: _currentShape == DynamicShapeType.steppedCorner ? 40.0 : 18.0,
      toothWidth: 12.0,
      toothHeight: 8.0,
      scallopRadius: 10.0,
    );

    final textDir = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final safePadding =
        _calculateSafePadding(_currentShape, widget.anchor, textDir);

    // Build the icon widget if provided
    Widget? iconWidget = widget.iconWidget;
    if (iconWidget == null && widget.icon != null) {
      iconWidget = Icon(widget.icon, size: 24, color: effectiveIconColor);
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: DynamicShapeContainer(
          width: widget.width,
          height: widget.height,
          config: shapeConfig,
          color: effectiveColor,
          borderColor: widget.borderColor,
          borderWidth: widget.borderWidth,
          dockedBadge: widget.badge,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Text Content Zone (safely constrained so it never touches cutouts or icons)
                  Positioned.fill(
                    child: Padding(
                      padding: safePadding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Title & Subtitle column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: effectiveTextColor,
                                    height: 1.15,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.subtitle != null &&
                                    widget.subtitle!.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    widget.subtitle!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: effectiveSubColor,
                                      height: 1.15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // If shape is NOT steppedCorner or sideTab, place icon inline on right
                          if (iconWidget != null &&
                              _currentShape != DynamicShapeType.steppedCorner &&
                              _currentShape != DynamicShapeType.sideTab &&
                              _currentShape != DynamicShapeType.folderTab)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: iconWidget,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Specialized Slot: Stepped Corner Icon placement (nestled inside the bottom-right shelf)
                  if (iconWidget != null &&
                      _currentShape == DynamicShapeType.steppedCorner)
                    Positioned(right: 12, bottom: 10, child: iconWidget),

                  // Specialized Slot: Folder Tab Icon placement (nestled inside the top-right elevated tab)
                  if (iconWidget != null &&
                      _currentShape == DynamicShapeType.folderTab)
                    Positioned(right: 12, top: 10, child: iconWidget),

                  // Specialized Slot: Side Tab Icon placement (nestled inside the protruding bubble)
                  if (iconWidget != null &&
                      _currentShape == DynamicShapeType.sideTab)
                    Positioned(
                      right: 8,
                      top: 0,
                      bottom: 0,
                      child: Center(child: iconWidget),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
