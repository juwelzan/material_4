import 'package:flutter/material.dart';

import '../../material_4_config.dart';
import '../../material_4_container.dart';
import 'sculpted_card_config.dart';
import 'sculpted_surface_painter.dart';

/// Signature card component featuring a physically elevated, 3D sculpted
/// icon plate seated over a pristine, flat, highly legible text surface.
class SculptedIconCard extends StatefulWidget {
  /// The icon displayed on the raised plate (supports [IconData] or arbitrary [Widget]).
  final dynamic icon;

  /// The main title of the card (supports [String] or [Widget]).
  final dynamic title;

  /// Optional subtitle (supports [String] or [Widget]).
  final dynamic subtitle;

  /// Optional extended description (supports [String] or [Widget]).
  final dynamic description;

  /// Optional chip or badge label/widget displayed on the card.
  final dynamic badge;

  /// Placement of the sculpted icon plate on the card.
  final SculptedIconPosition iconPosition;

  /// Custom alignment if [iconPosition] is [SculptedIconPosition.custom].
  final AlignmentGeometry? customIconAlignment;

  /// Sculpted surface finish and plate geometry configuration.
  final SculptedPlateConfig plateConfig;

  /// Base container Material 4 shape configuration.
  final Material4Config shapeConfig;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Long press callback.
  final VoidCallback? onLongPress;

  /// Overall card width.
  final double? width;

  /// Overall card height.
  final double? height;

  /// Card internal content padding.
  final EdgeInsetsGeometry padding;

  /// Card external margin.
  final EdgeInsetsGeometry? margin;

  /// Spacing between icon, title, subtitle, and description.
  final double contentSpacing;

  /// Base card background color.
  final Color backgroundColor;

  /// Optional gradient for the card background.
  final Gradient? backgroundGradient;

  /// Base card border color.
  final Color borderColor;

  /// Base card border width.
  final double borderWidth;

  /// Outer shadows for the card.
  final List<BoxShadow>? shadows;

  /// Text alignment.
  final TextAlign textAlign;

  /// Text direction for RTL and Bengali support.
  final TextDirection? textDirection;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Subtitle text style.
  final TextStyle? subtitleStyle;

  /// Description text style.
  final TextStyle? descriptionStyle;

  /// Badge background color.
  final Color? badgeColor;

  /// Badge text color.
  final Color? badgeTextColor;

  /// Whether the card is enabled and interactive.
  final bool enabled;

  /// Whether the card is visually selected.
  final bool selected;

  const SculptedIconCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.description,
    this.badge,
    this.iconPosition = SculptedIconPosition.topLeft,
    this.customIconAlignment,
    this.plateConfig = const SculptedPlateConfig(),
    this.shapeConfig = const Material4Config(
      type: Material4Type.smoothRounded,
      cornerRadius: 18.0,
    ),
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
    this.contentSpacing = 8.0,
    this.backgroundColor = const Color(0xFFF7F5F2),
    this.backgroundGradient,
    this.borderColor = const Color(0x14000000),
    this.borderWidth = 1.0,
    this.shadows = const [
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 10.0,
        offset: Offset(0, 4),
      ),
    ],
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.badgeColor,
    this.badgeTextColor,
    this.enabled = true,
    this.selected = false,
  });

  /// Factory: Embossed Signature Card.
  factory SculptedIconCard.embossed({
    Key? key,
    required dynamic icon,
    required dynamic title,
    dynamic subtitle,
    dynamic description,
    dynamic badge,
    SculptedIconPosition iconPosition = SculptedIconPosition.topLeft,
    VoidCallback? onTap,
    Color backgroundColor = const Color(0xFFF7F5F2),
  }) {
    return SculptedIconCard(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      description: description,
      badge: badge,
      iconPosition: iconPosition,
      plateConfig: const SculptedPlateConfig(
        style: SculptedSurfaceStyle.embossed,
      ),
      backgroundColor: backgroundColor,
      onTap: onTap,
    );
  }

  /// Factory: Neumorphic Dual-Lighting Card.
  factory SculptedIconCard.neumorphic({
    Key? key,
    required dynamic icon,
    required dynamic title,
    dynamic subtitle,
    SculptedIconPosition iconPosition = SculptedIconPosition.topLeft,
    VoidCallback? onTap,
    Color backgroundColor = const Color(0xFFE0E5EC),
  }) {
    return SculptedIconCard(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconPosition: iconPosition,
      plateConfig: SculptedPlateConfig.neumorphic(
        surfaceColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      borderWidth: 0.0,
      shadows: const [
        BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 10.0,
          offset: Offset(5, 5),
        ),
        BoxShadow(
          color: Color(0xCCFFFFFF),
          blurRadius: 10.0,
          offset: Offset(-5, -5),
        ),
      ],
      onTap: onTap,
    );
  }

  /// Factory: Soft Claymorphic Card.
  factory SculptedIconCard.clay({
    Key? key,
    required dynamic icon,
    required dynamic title,
    dynamic subtitle,
    SculptedIconPosition iconPosition = SculptedIconPosition.centerLeft,
    VoidCallback? onTap,
    Color backgroundColor = const Color(0xFFF0EAE1),
    Color? plateColor = const Color(0xFFFFF9F0),
  }) {
    return SculptedIconCard(
      key: key,
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconPosition: iconPosition,
      plateConfig: SculptedPlateConfig.clay(
        surfaceColor: plateColor,
      ),
      backgroundColor: backgroundColor,
      onTap: onTap,
    );
  }

  @override
  State<SculptedIconCard> createState() => _SculptedIconCardState();
}

class _SculptedIconCardState extends State<SculptedIconCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;
  bool _isFocused = false;

  void _handleTapDown(TapDownDetails _) {
    if (!widget.enabled) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (!widget.enabled) return;
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    if (!widget.enabled) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveDirection =
        widget.textDirection ?? Directionality.of(context);

    // Build the 3D tactile icon plate
    final iconPlateWidget = _buildSculptedIconPlate();

    // Build the flat, clean text & content area
    final textContentWidget = _buildTextContent(context);

    // Arrange icon plate and text area based on iconPosition so they NEVER collide
    final contentLayout = _buildComposedLayout(
      iconPlate: iconPlateWidget,
      textContent: textContentWidget,
      direction: effectiveDirection,
    );

    // Material4 container as the base card
    final cardWidget = Material4Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      color: widget.selected
          ? Color.alphaBlend(
              Theme.of(context).primaryColor.withValues(alpha: 0.08),
              widget.backgroundColor,
            )
          : widget.backgroundColor,
      gradient: widget.backgroundGradient,
      borderColor: widget.selected || _isFocused
          ? Theme.of(context).primaryColor
          : widget.borderColor,
      borderWidth: widget.selected || _isFocused ? 2.0 : widget.borderWidth,
      shadows: widget.shadows,
      config: widget.shapeConfig,
      child: contentLayout,
    );

    // Interactive gestures and semantics
    final accessibilityLabel = _deriveSemanticLabel();

    return Semantics(
      button: widget.onTap != null,
      enabled: widget.enabled,
      selected: widget.selected,
      label: accessibilityLabel,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        onShowFocusHighlight: (f) => setState(() => _isFocused = f),
        onShowHoverHighlight: (h) => setState(() => _isHovered = h),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.enabled ? widget.onTap : null,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedScale(
            scale: _isPressed ? 0.98 : (_isHovered ? 1.01 : 1.0),
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            child: Opacity(
              opacity: widget.enabled ? 1.0 : 0.5,
              child: cardWidget,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSculptedIconPlate() {
    final cfg = widget.plateConfig;

    Widget iconWidget;
    if (widget.icon is IconData) {
      iconWidget = Icon(
        widget.icon as IconData,
        size: cfg.iconSize,
        color: cfg.iconColor ??
            (cfg.style == SculptedSurfaceStyle.debossed
                ? Colors.black54
                : Colors.black87),
      );
    } else if (widget.icon is Widget) {
      iconWidget = widget.icon as Widget;
    } else {
      iconWidget = const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeInOut,
      width: cfg.size,
      height: cfg.size,
      child: CustomPaint(
        painter: SculptedSurfacePainter(
          config: cfg,
          isPressed: _isPressed && cfg.pressInteractive,
          isHovered: _isHovered,
          cardBackgroundColor: widget.backgroundColor,
        ),
        child: Center(
          child: AnimatedSlide(
            offset: _isPressed && cfg.pressInteractive
                ? const Offset(0.0, 0.05)
                : Offset.zero,
            duration: const Duration(milliseconds: 100),
            child: iconWidget,
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    final theme = Theme.of(context);

    // Title
    Widget titleWidget;
    if (widget.title is Widget) {
      titleWidget = widget.title as Widget;
    } else {
      titleWidget = Text(
        widget.title.toString(),
        style: widget.titleStyle ??
            theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
        textAlign: widget.textAlign,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Subtitle
    Widget? subtitleWidget;
    if (widget.subtitle != null) {
      if (widget.subtitle is Widget) {
        subtitleWidget = widget.subtitle as Widget;
      } else {
        subtitleWidget = Text(
          widget.subtitle.toString(),
          style: widget.subtitleStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
                height: 1.3,
              ),
          textAlign: widget.textAlign,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      }
    }

    // Description
    Widget? descWidget;
    if (widget.description != null) {
      if (widget.description is Widget) {
        descWidget = widget.description as Widget;
      } else {
        descWidget = Text(
          widget.description.toString(),
          style: widget.descriptionStyle ??
              theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF94A3B8),
                height: 1.4,
              ),
          textAlign: widget.textAlign,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        );
      }
    }

    // Badge
    Widget? badgeWidget;
    if (widget.badge != null) {
      if (widget.badge is Widget) {
        badgeWidget = widget.badge as Widget;
      } else {
        badgeWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          decoration: BoxDecoration(
            color:
                widget.badgeColor ?? theme.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            widget.badge.toString(),
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: widget.badgeTextColor ?? theme.primaryColor,
            ),
          ),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : (widget.textAlign == TextAlign.end
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start),
      children: [
        if (badgeWidget != null) ...[
          badgeWidget,
          const SizedBox(height: 4.0),
        ],
        titleWidget,
        if (subtitleWidget != null) ...[
          SizedBox(height: widget.contentSpacing * 0.5),
          subtitleWidget,
        ],
        if (descWidget != null) ...[
          SizedBox(height: widget.contentSpacing * 0.75),
          descWidget,
        ],
      ],
    );
  }

  Widget _buildComposedLayout({
    required Widget iconPlate,
    required Widget textContent,
    required TextDirection direction,
  }) {
    switch (widget.iconPosition) {
      // 1. Top Left
      case SculptedIconPosition.topLeft:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            iconPlate,
            SizedBox(height: widget.contentSpacing * 1.5),
            textContent,
          ],
        );

      // 2. Top Center
      case SculptedIconPosition.topCenter:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconPlate,
            SizedBox(height: widget.contentSpacing * 1.5),
            textContent,
          ],
        );

      // 3. Top Right
      case SculptedIconPosition.topRight:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            iconPlate,
            SizedBox(height: widget.contentSpacing * 1.5),
            textContent,
          ],
        );

      // 4. Center Left (Row: Icon on left, Content on right)
      case SculptedIconPosition.centerLeft:
      case SculptedIconPosition.floatingLeft:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconPlate,
            SizedBox(width: widget.contentSpacing * 1.5),
            Expanded(child: textContent),
          ],
        );

      // 5. Center Right (Row: Content on left, Icon on right)
      case SculptedIconPosition.centerRight:
      case SculptedIconPosition.floatingRight:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: textContent),
            SizedBox(width: widget.contentSpacing * 1.5),
            iconPlate,
          ],
        );

      // 6. Bottom Left
      case SculptedIconPosition.bottomLeft:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textContent,
            SizedBox(height: widget.contentSpacing * 1.5),
            iconPlate,
          ],
        );

      // 7. Bottom Center
      case SculptedIconPosition.bottomCenter:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textContent,
            SizedBox(height: widget.contentSpacing * 1.5),
            iconPlate,
          ],
        );

      // 8. Bottom Right
      case SculptedIconPosition.bottomRight:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            textContent,
            SizedBox(height: widget.contentSpacing * 1.5),
            iconPlate,
          ],
        );

      // 9. Floating Top / Floating Corner / Custom
      case SculptedIconPosition.floatingTop:
      case SculptedIconPosition.floatingCorner:
      case SculptedIconPosition.custom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: widget.customIconAlignment ?? Alignment.topLeft,
              child: iconPlate,
            ),
            SizedBox(height: widget.contentSpacing * 1.5),
            textContent,
          ],
        );
    }
  }

  String _deriveSemanticLabel() {
    final titleStr = widget.title is String ? widget.title as String : '';
    final subStr =
        widget.subtitle is String ? ', ${widget.subtitle as String}' : '';
    return '$titleStr$subStr';
  }
}
