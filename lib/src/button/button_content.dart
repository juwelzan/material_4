import 'package:flutter/material.dart';

import 'button_state.dart';

/// Available icon positions relative to the text label inside [Material4Button].
enum ButtonIconPosition {
  /// Icon is positioned to the left of the label (or right in RTL).
  leading,

  /// Icon is positioned to the right of the label (or left in RTL).
  trailing,

  /// Icon is stacked vertically above the label.
  top,

  /// Icon is stacked vertically below the label.
  bottom,
}

/// Content layout and dynamic feedback descriptor for [Material4Button].
@immutable
class Material4ButtonContent {
  /// Primary text label.
  final String? text;

  /// Custom label widget overriding [text].
  final Widget? labelWidget;

  /// Icon widget or leading/trailing graphic.
  final Widget? icon;

  /// Spatial placement of [icon] relative to [text].
  final ButtonIconPosition iconPosition;

  /// Spacing gap between icon and text.
  final double spacing;

  /// Custom widget displayed during [Material4ButtonState.loading].
  final Widget? loadingWidget;

  /// Custom widget displayed during [Material4ButtonState.success].
  final Widget? successWidget;

  /// Custom widget displayed during [Material4ButtonState.error].
  final Widget? errorWidget;

  /// Notification badge or accessory widget displayed at top-end corner.
  final Widget? badge;

  /// Whether to render a dropdown indicator chevron at the trailing edge.
  final bool hasDropdown;

  /// Custom dropdown indicator widget overriding standard chevron.
  final Widget? dropdownWidget;

  /// Main axis alignment for internal row/column arrangement.
  final MainAxisAlignment alignment;

  Widget? get label => labelWidget;

  const Material4ButtonContent({
    this.text,
    Widget? labelWidget,
    Widget? label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.spacing = 8.0,
    this.loadingWidget,
    this.successWidget,
    this.errorWidget,
    this.badge,
    this.hasDropdown = false,
    this.dropdownWidget,
    this.alignment = MainAxisAlignment.center,
  }) : labelWidget = labelWidget ?? label;

  /// Factory for a text-only button layout.
  factory Material4ButtonContent.text(String text) {
    return Material4ButtonContent(text: text);
  }

  /// Factory for an icon-only button layout.
  factory Material4ButtonContent.icon(Widget icon) {
    return Material4ButtonContent(icon: icon);
  }

  /// Factory for a leading icon with label.
  factory Material4ButtonContent.iconText({
    required Widget icon,
    required String text,
    double spacing = 8.0,
  }) {
    return Material4ButtonContent(
      icon: icon,
      text: text,
      iconPosition: ButtonIconPosition.leading,
      spacing: spacing,
    );
  }

  /// Factory for a trailing icon with label.
  factory Material4ButtonContent.textIcon({
    required String text,
    required Widget icon,
    double spacing = 8.0,
  }) {
    return Material4ButtonContent(
      text: text,
      icon: icon,
      iconPosition: ButtonIconPosition.trailing,
      spacing: spacing,
    );
  }

  /// Builds the effective widget tree corresponding to [state].
  Widget build({
    required BuildContext context,
    required Material4ButtonState state,
    required TextStyle textStyle,
    required Color foregroundColor,
  }) {
    // 1. Loading State
    if (state == Material4ButtonState.loading) {
      if (loadingWidget != null) return loadingWidget!;
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    // 2. Success State
    if (state == Material4ButtonState.success) {
      if (successWidget != null) return successWidget!;
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: alignment,
        children: [
          Icon(Icons.check_circle_rounded, color: foregroundColor, size: 20),
          if (text != null || labelWidget != null) ...[
            SizedBox(width: spacing),
            DefaultTextStyle.merge(
              style: textStyle.copyWith(color: foregroundColor),
              child: labelWidget ?? Text(text!),
            ),
          ],
        ],
      );
    }

    // 3. Error State
    if (state == Material4ButtonState.error) {
      if (errorWidget != null) return errorWidget!;
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: alignment,
        children: [
          Icon(Icons.error_outline_rounded, color: foregroundColor, size: 20),
          if (text != null || labelWidget != null) ...[
            SizedBox(width: spacing),
            DefaultTextStyle.merge(
              style: textStyle.copyWith(color: foregroundColor),
              child: labelWidget ?? Text(text!),
            ),
          ],
        ],
      );
    }

    // 4. Standard Idle / Hovered / Pressed / Focused / Disabled State
    final effectiveLabel = labelWidget ??
        (text != null
            ? DefaultTextStyle.merge(
                style: textStyle.copyWith(color: foregroundColor),
                child: Text(text!),
              )
            : null);

    Widget contentBody;

    if (icon == null) {
      contentBody = effectiveLabel ?? const SizedBox.shrink();
    } else if (effectiveLabel == null) {
      contentBody = IconTheme(
        data: IconThemeData(color: foregroundColor, size: 20),
        child: icon!,
      );
    } else {
      final iconThemed = IconTheme(
        data: IconThemeData(color: foregroundColor, size: 20),
        child: icon!,
      );

      switch (iconPosition) {
        case ButtonIconPosition.leading:
          contentBody = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: alignment,
            children: [
              iconThemed,
              SizedBox(width: spacing),
              effectiveLabel,
            ],
          );
          break;
        case ButtonIconPosition.trailing:
          contentBody = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: alignment,
            children: [
              effectiveLabel,
              SizedBox(width: spacing),
              iconThemed,
            ],
          );
          break;
        case ButtonIconPosition.top:
          contentBody = Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: alignment,
            children: [
              iconThemed,
              SizedBox(height: spacing),
              effectiveLabel,
            ],
          );
          break;
        case ButtonIconPosition.bottom:
          contentBody = Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: alignment,
            children: [
              effectiveLabel,
              SizedBox(height: spacing),
              iconThemed,
            ],
          );
          break;
      }
    }

    if (hasDropdown) {
      final chevron = dropdownWidget ??
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: foregroundColor,
            size: 18,
          );
      contentBody = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: alignment,
        children: [
          contentBody,
          SizedBox(width: spacing / 2),
          chevron,
        ],
      );
    }

    if (badge != null) {
      contentBody = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          contentBody,
          Positioned(
            top: -6,
            right: -10,
            child: badge!,
          ),
        ],
      );
    }

    return contentBody;
  }
}
