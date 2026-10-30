import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../dynamic_shape_config.dart';
import '../../dynamic_shape_container.dart';
import '../borders/creative_border_config.dart';
import '../materials/dynamic_material.dart';
import '../paper/paper_background_config.dart';
import 'card_interaction_config.dart';
import 'sculpted_card_config.dart';

/// Available icon position anchors on [MaterialDynamicCard].
enum CardIconPosition {
  /// Icon is positioned inline before the text content (left in LTR, right in RTL).
  leading,

  /// Icon is positioned inline after the text content (right in LTR, left in RTL).
  trailing,

  /// Icon is positioned stacked above the text content.
  top,

  /// Icon is positioned stacked below the text content.
  bottom,

  /// Icon plate hovers dynamically elevated overlapping the primary top-leading corner.
  floatingCorner,

  /// Centered horizontally and vertically or centered above content.
  center,

  /// Sub-pixel custom alignment using [MaterialDynamicCard.customIconAlignment].
  custom,
}

/// Physical surface elevation style for card elements (icon plate or content container).
enum CardSurfaceType {
  /// Flat surface with zero elevation difference from parent.
  flat,

  /// Raised surface physically elevated above parent with directional lighting and cast shadow.
  raised,

  /// Recessed surface carved into parent with dark inner shadow and bright specular rim.
  recessed,

  /// Elevated floating surface with deep ambient diffusion shadow.
  floating,
}

/// A master, highly tactile, universal dynamic card component combining:
/// - Physical material models ([DynamicMaterial], [DynamicMaterialConfig])
/// - Parametric shape geometry ([DynamicShapeType], [DynamicShapeConfig])
/// - Flexible icon surfaces and positions ([CardIconPosition], [CardSurfaceType])
/// - Multi-layer typography hierarchy with overflow protection and Bengali/RTL support
/// - Responsive spring physics, hover elevations, and accordion expansions ([CardInteractionConfig])
class MaterialDynamicCard extends StatefulWidget {
  /// Physical material finish of the card.
  final DynamicMaterial? material;

  /// Detailed material configuration. If provided, takes precedence over [material].
  final DynamicMaterialConfig? materialConfig;

  /// Geometric dynamic shape preset for the container boundary.
  final DynamicShapeType shape;

  /// Corner radius for standard rounded shapes.
  final double cornerRadius;

  /// Custom corners configuration.
  final ShapeCorners? corners;

  /// Custom edges contour configuration.
  final ShapeEdges? edges;

  /// Base or custom dynamic shape configuration.
  final DynamicShapeConfig? shapeConfig;

  /// Creative border style (torn paper, deckled edge, stamps, stitched, neon, etc.).
  final CreativeBorderConfig? creativeBorder;

  /// Paper texture background configuration for stationery cards.
  final PaperBackgroundConfig? paperBackground;

  /// Icon or graphic element displayed on the card (accepts [Widget] or [IconData]).
  final dynamic icon;

  /// Placement of the icon relative to card content.
  final CardIconPosition iconPosition;

  /// Tactile surface treatment of the icon plate.
  final CardSurfaceType iconSurface;

  /// Geometric boundary shape of the icon plate.
  final SculptedPlateShape iconPlateShape;

  /// Size of the icon plate container in logical pixels.
  final double iconPlateSize;

  /// Size of the icon inside the plate.
  final double? iconSize;

  /// Color of the icon inside the plate.
  final Color? iconColor;

  /// Background color of the icon plate.
  final Color? iconBackgroundColor;

  /// Custom alignment when [iconPosition] is [CardIconPosition.custom].
  final AlignmentGeometry? customIconAlignment;

  /// Tactile surface finish of the content body container.
  final CardSurfaceType contentSurface;

  /// Card primary headline (accepts [String] or [Widget]).
  final dynamic title;

  /// Secondary subtitle text (accepts [String] or [Widget]).
  final dynamic subtitle;

  /// Extended descriptive text body (accepts [String] or [Widget]).
  final dynamic description;

  /// Metadata chip or info text (e.g. date, category, author).
  final dynamic metadata;

  /// Small badge, tag, or pill chip (e.g. "NEW", "PRO", status).
  final dynamic badge;

  /// Action widget (e.g. button, switch, icon button) placed at the bottom or end.
  final Widget? action;

  /// Trailing widget placed at the far end (e.g. chevron or auxiliary icon).
  final Widget? trailing;

  /// Custom primary child widget. If provided, replaces standard text layout.
  final Widget? child;

  /// Optional child revealed when [expanded] is true.
  final Widget? expandableChild;

  /// Base container width.
  final double? width;

  /// Base container height.
  final double? height;

  /// Content interior padding.
  final EdgeInsetsGeometry padding;

  /// Outer margin surrounding the card.
  final EdgeInsetsGeometry? margin;

  /// Vertical and horizontal spacing between content elements.
  final double contentSpacing;

  /// Base card background color.
  final Color? backgroundColor;

  /// Base card background gradient.
  final Gradient? backgroundGradient;

  /// Base card border color.
  final Color? borderColor;

  /// Base card border width.
  final double borderWidth;

  /// Outer drop shadows.
  final List<BoxShadow>? shadows;

  /// Inner depth shadows.
  final List<BoxShadow>? innerShadows;

  /// Typography styling for the title.
  final TextStyle? titleStyle;

  /// Typography styling for the subtitle.
  final TextStyle? subtitleStyle;

  /// Typography styling for the description.
  final TextStyle? descriptionStyle;

  /// Typography styling for the metadata.
  final TextStyle? metadataStyle;

  /// Color of the badge background.
  final Color? badgeColor;

  /// Color of the badge text.
  final Color? badgeTextColor;

  /// Text alignment.
  final TextAlign textAlign;

  /// Explicit text direction for RTL or Bengali typography.
  final TextDirection? textDirection;

  /// Maximum lines for the title before ellipsis.
  final int? titleMaxLines;

  /// Maximum lines for the description before ellipsis.
  final int? descriptionMaxLines;

  /// Interaction and motion configuration.
  final CardInteractionConfig interaction;

  /// Click / tap callback.
  final VoidCallback? onTap;

  /// Long press callback.
  final VoidCallback? onLongPress;

  /// Whether the card is selected.
  final bool selected;

  /// Callback when selected state changes.
  final ValueChanged<bool>? onSelectedChanged;

  /// Whether the card is in an expanded accordion state.
  final bool expanded;

  /// Callback when expanded state changes.
  final ValueChanged<bool>? onExpandedChanged;

  /// Whether the card responds to interactions.
  final bool enabled;

  const MaterialDynamicCard({
    super.key,
    this.material,
    this.materialConfig,
    this.shape = DynamicShapeType.smoothRounded,
    this.cornerRadius = 16.0,
    this.corners,
    this.edges,
    this.shapeConfig,
    this.creativeBorder,
    this.paperBackground,
    this.icon,
    this.iconPosition = CardIconPosition.leading,
    this.iconSurface = CardSurfaceType.flat,
    this.iconPlateShape = SculptedPlateShape.circle,
    this.iconPlateSize = 48.0,
    this.iconSize,
    this.iconColor,
    this.iconBackgroundColor,
    this.customIconAlignment,
    this.contentSurface = CardSurfaceType.flat,
    this.title,
    this.subtitle,
    this.description,
    this.metadata,
    this.badge,
    this.action,
    this.trailing,
    this.child,
    this.expandableChild,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.contentSpacing = 12.0,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.borderWidth = 1.0,
    this.shadows,
    this.innerShadows,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.metadataStyle,
    this.badgeColor,
    this.badgeTextColor,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.titleMaxLines = 2,
    this.descriptionMaxLines = 3,
    this.interaction = const CardInteractionConfig(),
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.onSelectedChanged,
    this.expanded = false,
    this.onExpandedChanged,
    this.enabled = true,
  });

  @override
  State<MaterialDynamicCard> createState() => _MaterialDynamicCardState();
}

class _MaterialDynamicCardState extends State<MaterialDynamicCard>
    with SingleTickerProviderStateMixin {
  late bool _isHovered;
  late bool _isPressed;
  late bool _isFocused;
  late bool _isSelected;
  late bool _isExpanded;

  AnimationController? _expandController;
  Animation<double>? _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isHovered = false;
    _isPressed = false;
    _isFocused = false;
    _isSelected = widget.selected;
    _isExpanded = widget.expanded;

    if (widget.expandableChild != null) {
      _expandController = AnimationController(
        vsync: this,
        duration: widget.interaction.expandDuration,
      );
      _expandAnimation = CurvedAnimation(
        parent: _expandController!,
        curve: widget.interaction.curve,
      );
      if (_isExpanded) {
        _expandController!.value = 1.0;
      }
    }
  }

  @override
  void didUpdateWidget(covariant MaterialDynamicCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      setState(() => _isSelected = widget.selected);
    }
    if (widget.expanded != oldWidget.expanded) {
      setState(() => _isExpanded = widget.expanded);
      if (_expandController != null) {
        if (_isExpanded) {
          _expandController!.forward();
        } else {
          _expandController!.reverse();
        }
      }
    }
  }

  @override
  void dispose() {
    _expandController?.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled) return;

    if (widget.onSelectedChanged != null) {
      final newSelected = !_isSelected;
      setState(() => _isSelected = newSelected);
      widget.onSelectedChanged!(newSelected);
    }

    if (widget.expandableChild != null && widget.onExpandedChanged != null) {
      final newExpanded = !_isExpanded;
      setState(() => _isExpanded = newExpanded);
      if (newExpanded) {
        _expandController?.forward();
      } else {
        _expandController?.reverse();
      }
      widget.onExpandedChanged!(newExpanded);
    } else if (widget.expandableChild != null) {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _expandController?.forward();
        } else {
          _expandController?.reverse();
        }
      });
    }

    widget.onTap?.call();
  }

  DynamicMaterialConfig _resolveMaterialConfig(ThemeData theme) {
    if (widget.materialConfig != null) {
      return widget.materialConfig!;
    }
    final mat = widget.material ?? DynamicMaterial.cardstock;
    switch (mat) {
      case DynamicMaterial.paper:
        return DynamicMaterialConfig.paper();
      case DynamicMaterial.cardstock:
        return DynamicMaterialConfig.cardstock(
          color: widget.backgroundColor ?? theme.cardColor,
        );
      case DynamicMaterial.clay:
        return DynamicMaterialConfig.clay(
          color: widget.backgroundColor ?? theme.cardColor,
        );
      case DynamicMaterial.ceramic:
        return DynamicMaterialConfig.ceramic(
          color: widget.backgroundColor ?? Colors.white,
        );
      case DynamicMaterial.glass:
        return DynamicMaterialConfig.glass();
      case DynamicMaterial.plastic:
        return DynamicMaterialConfig.plastic(
          color: widget.backgroundColor ?? theme.cardColor,
        );
      case DynamicMaterial.metal:
        return DynamicMaterialConfig.metal();
      case DynamicMaterial.softFabric:
        return DynamicMaterialConfig.softFabric(
          color: widget.backgroundColor ?? theme.cardColor,
        );
      case DynamicMaterial.stone:
        return DynamicMaterialConfig.stone();
      case DynamicMaterial.rubber:
        return DynamicMaterialConfig.rubber();
      case DynamicMaterial.matte:
        return DynamicMaterialConfig.matte(
          color: widget.backgroundColor ?? theme.cardColor,
        );
      case DynamicMaterial.glossy:
        return DynamicMaterialConfig.glossy(
          color: widget.backgroundColor ?? theme.cardColor,
        );
    }
  }

  DynamicShapeConfig _buildFinalShapeConfig(
    DynamicMaterialConfig matConfig,
    ThemeData theme,
  ) {
    if (widget.shapeConfig != null) {
      return widget.shapeConfig!;
    }

    DynamicShapeType shapeType = widget.shape;
    if (_isHovered && widget.interaction.morphShapeOnHover != null) {
      shapeType = widget.interaction.morphShapeOnHover!;
    } else if (_isSelected && widget.interaction.morphShapeOnSelect != null) {
      shapeType = widget.interaction.morphShapeOnSelect!;
    }

    final baseConfig = matConfig.toShapeConfig(
      shapeType: shapeType,
      cornerRadius: widget.cornerRadius,
      corners: widget.corners,
      edges: widget.edges,
    );

    // Merge overrides
    return baseConfig.copyWith(
      creativeBorder: widget.creativeBorder ?? baseConfig.creativeBorder,
      paperBackground: widget.paperBackground ?? baseConfig.paperBackground,
      innerShadows: widget.innerShadows ?? baseConfig.innerShadows,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matConfig = _resolveMaterialConfig(theme);
    final shapeConfig = _buildFinalShapeConfig(matConfig, theme);

    // Resolve colors & state
    Color finalBgColor = widget.backgroundColor ?? matConfig.surfaceColor;
    if (!widget.enabled) {
      finalBgColor = finalBgColor.withValues(alpha: 0.6);
    } else if (_isSelected && widget.interaction.selectedColor != null) {
      finalBgColor = widget.interaction.selectedColor!;
    } else if (_isHovered && widget.interaction.hoverColor != null) {
      finalBgColor = widget.interaction.hoverColor!;
    }

    Color finalBorderColor = widget.borderColor ?? matConfig.borderColor;
    if (_isSelected && widget.interaction.selectedBorderColor != null) {
      finalBorderColor = widget.interaction.selectedBorderColor!;
    } else if (_isFocused && widget.interaction.focusColor != null) {
      finalBorderColor = widget.interaction.focusColor!;
    }

    List<BoxShadow> finalShadows = widget.shadows ?? matConfig.buildShadows();
    if (_isHovered && widget.interaction.enableHoverElevation) {
      final multiplier = widget.interaction.hoverElevationMultiplier;
      finalShadows = finalShadows
          .map((s) => BoxShadow(
                color: s.color,
                offset: s.offset * multiplier,
                blurRadius: s.blurRadius * multiplier,
                spreadRadius: s.spreadRadius * multiplier,
              ))
          .toList();
    }

    // Build layout elements
    final textDir = widget.textDirection ??
        Directionality.maybeOf(context) ??
        TextDirection.ltr;
    final isFloatingIcon =
        widget.iconPosition == CardIconPosition.floatingCorner;

    Widget cardBody = _buildCardContent(theme, textDir);

    // Expandable accordion layer
    if (widget.expandableChild != null && _expandAnimation != null) {
      cardBody = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          cardBody,
          SizeTransition(
            sizeFactor: _expandAnimation!,
            axis: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.only(top: widget.contentSpacing),
              child: widget.expandableChild!,
            ),
          ),
        ],
      );
    }

    // Content surface wrapper
    cardBody = _wrapContentSurface(cardBody, theme);

    // If floatingCorner, position icon over container
    Widget innerLayout;
    if (isFloatingIcon && widget.icon != null) {
      innerLayout = Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: widget.iconPlateSize * 0.4,
              left:
                  textDir == TextDirection.ltr ? widget.iconPlateSize * 0.2 : 0,
              right:
                  textDir == TextDirection.rtl ? widget.iconPlateSize * 0.2 : 0,
            ),
            child: cardBody,
          ),
          PositionedDirectional(
            start: 0,
            top: -widget.iconPlateSize * 0.25,
            child: _buildIconPlate(theme),
          ),
        ],
      );
    } else {
      innerLayout = cardBody;
    }

    // RenderBox dynamic container
    Widget cardContainer = DynamicShapeContainer(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      color: finalBgColor,
      gradient: widget.backgroundGradient ?? matConfig.gradient,
      borderColor: finalBorderColor,
      borderWidth: widget.borderWidth,
      shadows: finalShadows,
      config: shapeConfig,
      child: innerLayout,
    );

    // Interactive spring scaling & hover feedback
    final isInteractive = widget.enabled &&
        (widget.onTap != null ||
            widget.onLongPress != null ||
            widget.onSelectedChanged != null ||
            widget.expandableChild != null);

    if (isInteractive) {
      double scale = 1.0;
      if (_isPressed && widget.interaction.enablePressScale) {
        scale = widget.interaction.pressedScale;
      }

      cardContainer = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: FocusableActionDetector(
          onShowFocusHighlight: (v) => setState(() => _isFocused = v),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: _handleTap,
            onLongPress: widget.enabled ? widget.onLongPress : null,
            child: AnimatedScale(
              scale: scale,
              duration: widget.interaction.transitionDuration,
              curve: widget.interaction.curve,
              child: cardContainer,
            ),
          ),
        ),
      );
    }

    return cardContainer;
  }

  Widget _wrapContentSurface(Widget child, ThemeData theme) {
    if (widget.contentSurface == CardSurfaceType.flat) {
      return child;
    }

    final isDark = theme.brightness == Brightness.dark;
    List<BoxShadow> shadows;
    if (widget.contentSurface == CardSurfaceType.raised) {
      shadows = [
        BoxShadow(
          color: isDark ? Colors.black38 : const Color(0x18000000),
          offset: const Offset(0, 2),
          blurRadius: 6,
        ),
      ];
    } else if (widget.contentSurface == CardSurfaceType.recessed) {
      shadows = [
        BoxShadow(
          color: isDark ? Colors.black54 : const Color(0x22000000),
          offset: const Offset(1, 1),
          blurRadius: 3,
          spreadRadius: -1,
        ),
      ];
    } else {
      shadows = [
        BoxShadow(
          color: isDark ? Colors.black54 : const Color(0x33000000),
          offset: const Offset(0, 6),
          blurRadius: 16,
        ),
      ];
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(math.max(4.0, widget.cornerRadius - 4.0)),
        boxShadow: shadows,
      ),
      child: child,
    );
  }

  Widget _buildIconPlate(ThemeData theme) {
    if (widget.icon == null) return const SizedBox.shrink();

    final isDark = theme.brightness == Brightness.dark;
    final plateBg = widget.iconBackgroundColor ??
        (isDark
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surface);
    final iconColor = widget.iconColor ?? theme.colorScheme.primary;
    final iconSz = widget.iconSize ?? (widget.iconPlateSize * 0.5);

    Widget iconWidget;
    if (widget.icon is IconData) {
      iconWidget =
          Icon(widget.icon as IconData, size: iconSz, color: iconColor);
    } else if (widget.icon is Widget) {
      iconWidget = widget.icon as Widget;
    } else {
      iconWidget = const SizedBox.shrink();
    }

    List<BoxShadow> shadows = [];
    switch (widget.iconSurface) {
      case CardSurfaceType.flat:
        shadows = [];
        break;
      case CardSurfaceType.raised:
        shadows = [
          BoxShadow(
            color: isDark ? Colors.black45 : const Color(0x2A000000),
            offset: const Offset(1, 3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: isDark ? Colors.white12 : Colors.white70,
            offset: const Offset(-1, -1),
            blurRadius: 3,
          ),
        ];
        break;
      case CardSurfaceType.recessed:
        shadows = [
          BoxShadow(
            color: isDark ? Colors.black54 : const Color(0x26000000),
            offset: const Offset(1, 1),
            blurRadius: 4,
          ),
        ];
        break;
      case CardSurfaceType.floating:
        shadows = [
          BoxShadow(
            color: isDark ? Colors.black54 : const Color(0x33000000),
            offset: const Offset(0, 6),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ];
        break;
    }

    BoxShape boxShape = BoxShape.rectangle;
    BorderRadius? borderRadius;
    if (widget.iconPlateShape == SculptedPlateShape.circle) {
      boxShape = BoxShape.circle;
    } else {
      borderRadius = BorderRadius.circular(12.0);
    }

    return Container(
      width: widget.iconPlateSize,
      height: widget.iconPlateSize,
      decoration: BoxDecoration(
        color: plateBg,
        shape: boxShape,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      alignment: Alignment.center,
      child: iconWidget,
    );
  }

  Widget _buildCardContent(ThemeData theme, TextDirection textDir) {
    if (widget.child != null) {
      return widget.child!;
    }

    final hasIcon = widget.icon != null &&
        widget.iconPosition != CardIconPosition.floatingCorner;
    final iconPlate = hasIcon ? _buildIconPlate(theme) : null;

    final textColumn = _buildTextColumn(theme);

    switch (widget.iconPosition) {
      case CardIconPosition.leading:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconPlate != null) ...[
              iconPlate,
              SizedBox(width: widget.contentSpacing),
            ],
            Expanded(child: textColumn),
            if (widget.trailing != null) ...[
              SizedBox(width: widget.contentSpacing),
              widget.trailing!,
            ],
          ],
        );

      case CardIconPosition.trailing:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: textColumn),
            if (iconPlate != null) ...[
              SizedBox(width: widget.contentSpacing),
              iconPlate,
            ],
            if (widget.trailing != null) ...[
              SizedBox(width: widget.contentSpacing),
              widget.trailing!,
            ],
          ],
        );

      case CardIconPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: widget.textAlign == TextAlign.center
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            if (iconPlate != null) ...[
              iconPlate,
              SizedBox(height: widget.contentSpacing),
            ],
            textColumn,
            if (widget.action != null) ...[
              SizedBox(height: widget.contentSpacing),
              widget.action!,
            ],
          ],
        );

      case CardIconPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: widget.textAlign == TextAlign.center
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            textColumn,
            if (iconPlate != null) ...[
              SizedBox(height: widget.contentSpacing),
              iconPlate,
            ],
            if (widget.action != null) ...[
              SizedBox(height: widget.contentSpacing),
              widget.action!,
            ],
          ],
        );

      case CardIconPosition.center:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconPlate != null) ...[
              iconPlate,
              SizedBox(height: widget.contentSpacing),
            ],
            textColumn,
            if (widget.action != null) ...[
              SizedBox(height: widget.contentSpacing),
              widget.action!,
            ],
          ],
        );

      case CardIconPosition.custom:
        return Stack(
          children: [
            textColumn,
            if (iconPlate != null)
              Align(
                alignment: widget.customIconAlignment ?? Alignment.topRight,
                child: iconPlate,
              ),
          ],
        );

      case CardIconPosition.floatingCorner:
        return textColumn;
    }
  }

  Widget _buildTextColumn(ThemeData theme) {
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    Widget? titleWidget;
    if (widget.title is String) {
      titleWidget = Text(
        widget.title as String,
        style: widget.titleStyle ??
            textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
        textAlign: widget.textAlign,
        maxLines: widget.titleMaxLines,
        overflow: widget.titleMaxLines != null ? TextOverflow.ellipsis : null,
      );
    } else if (widget.title is Widget) {
      titleWidget = widget.title as Widget;
    }

    Widget? subtitleWidget;
    if (widget.subtitle is String) {
      subtitleWidget = Text(
        widget.subtitle as String,
        style: widget.subtitleStyle ??
            textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
        textAlign: widget.textAlign,
      );
    } else if (widget.subtitle is Widget) {
      subtitleWidget = widget.subtitle as Widget;
    }

    Widget? descWidget;
    if (widget.description is String) {
      descWidget = Text(
        widget.description as String,
        style: widget.descriptionStyle ??
            textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.white60 : Colors.black45,
            ),
        textAlign: widget.textAlign,
        maxLines: widget.descriptionMaxLines,
        overflow:
            widget.descriptionMaxLines != null ? TextOverflow.ellipsis : null,
      );
    } else if (widget.description is Widget) {
      descWidget = widget.description as Widget;
    }

    Widget? badgeWidget;
    if (widget.badge is String) {
      badgeWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: widget.badgeColor ?? theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          widget.badge as String,
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w600,
            color:
                widget.badgeTextColor ?? theme.colorScheme.onPrimaryContainer,
          ),
        ),
      );
    } else if (widget.badge is Widget) {
      badgeWidget = widget.badge as Widget;
    }

    Widget? metaWidget;
    if (widget.metadata is String) {
      metaWidget = Text(
        widget.metadata as String,
        style: widget.metadataStyle ??
            textTheme.labelSmall?.copyWith(
              color: isDark ? Colors.white54 : Colors.black38,
            ),
        textAlign: widget.textAlign,
      );
    } else if (widget.metadata is Widget) {
      metaWidget = widget.metadata as Widget;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (badgeWidget != null || metaWidget != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badgeWidget != null) badgeWidget,
              if (badgeWidget != null && metaWidget != null)
                const SizedBox(width: 8.0),
              if (metaWidget != null) Flexible(child: metaWidget),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
        if (titleWidget != null) titleWidget,
        if (subtitleWidget != null) ...[
          const SizedBox(height: 4.0),
          subtitleWidget,
        ],
        if (descWidget != null) ...[
          const SizedBox(height: 6.0),
          descWidget,
        ],
        if (widget.action != null &&
            widget.iconPosition != CardIconPosition.top &&
            widget.iconPosition != CardIconPosition.bottom &&
            widget.iconPosition != CardIconPosition.center) ...[
          const SizedBox(height: 10.0),
          widget.action!,
        ],
      ],
    );
  }
}
