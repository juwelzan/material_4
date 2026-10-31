import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../container/container_background.dart';
import '../container/container_border.dart';
import '../container/container_texture.dart';
import '../container/custom_shape.dart';
import '../material_4_config.dart';
import '../material_4_container.dart';
import '../material_4_path_builder.dart';
import 'button_animation.dart';
import 'button_content.dart';
import 'button_controller.dart';
import 'button_presets.dart';
import 'button_ripple_painter.dart';
import 'button_state.dart';

/// The Universal Next-Gen Button Component for Material 4.
///
/// Encapsulates all modern button design paradigms — Filled, Outlined, Text, Elevated,
/// Gradient, Glassmorphic, Liquid, Organic, Floating, Neon, 3D, and Custom Shapes —
/// under a unified declarative architecture.
class Material4Button extends StatefulWidget {
  /// Callback invoked when the button is tapped or triggered via keyboard activation.
  final VoidCallback? onPressed;

  /// Callback invoked on sustained long press.
  final VoidCallback? onLongPress;

  /// Custom child widget. When provided, overrides [text] and [icon].
  final Widget? child;

  /// Text label string.
  final String? text;

  /// Optional icon widget placed at [iconPosition].
  final Widget? icon;

  /// Relative placement of [icon] relative to [text].
  final ButtonIconPosition iconPosition;

  /// Spacing gap between icon and text label.
  final double spacing;

  /// Vector shape geometry preset.
  final Material4Type shape;

  /// Custom vector path builder geometry, overriding [shape].
  final Material4CustomShape? customShape;

  /// Complete multi-tier background configuration.
  final Material4Background? background;

  /// Vector contour border configuration.
  final Material4Border? border;

  /// Multi-tier interaction animation configuration.
  final Material4ButtonAnimation animation;

  /// Programmatic lifecycle and motion controller.
  final Material4ButtonController? controller;

  /// Base solid fill color.
  final Color? color;

  /// Foreground color applied to text labels and icons.
  final Color? foregroundColor;

  /// Gradient fill applied to the button surface.
  final Gradient? gradient;

  /// Explicit fixed width constraint.
  final double? width;

  /// Explicit fixed height constraint.
  final double? height;

  /// Minimum interactive touch target width (defaults to 48.0 dp for WCAG compliance).
  final double minWidth;

  /// Minimum interactive touch target height (defaults to 48.0 dp for WCAG compliance).
  final double minHeight;

  /// Internal padding enclosing the button content.
  final EdgeInsetsGeometry padding;

  /// External margin around the button touch target.
  final EdgeInsetsGeometry? margin;

  /// Text style applied to [text].
  final TextStyle? textStyle;

  /// Whether the button is actively displaying a loading indicator.
  final bool isLoading;

  /// Custom widget rendered during [Material4ButtonState.loading].
  final Widget? loadingWidget;

  /// Custom widget rendered during [Material4ButtonState.success].
  final Widget? successWidget;

  /// Custom widget rendered during [Material4ButtonState.error].
  final Widget? errorWidget;

  /// Optional notification badge or accessory widget.
  final Widget? badge;

  /// Whether to render a trailing dropdown chevron.
  final bool hasDropdown;

  /// Custom dropdown widget overriding standard chevron.
  final Widget? dropdownWidget;

  /// Explicit enabled override. When false, interactions are disabled even if [onPressed] is provided.
  final bool enabled;

  /// Whether this button requests keyboard focus on initial layout.
  final bool autofocus;

  /// External focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Accessibility semantic label announced by screen readers.
  final String? semanticLabel;

  /// Accessibility semantic hint providing contextual guidance.
  final String? semanticHint;

  /// Anti-aliasing clip behavior.
  final Clip clipBehavior;

  /// Direct content descriptor for complex button arrangements.
  final Material4ButtonContent? content;

  /// Explicit state override for state-machine driven architectures.
  final Material4ButtonState? state;

  const Material4Button({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.child,
    this.text,
    this.icon,
    this.content,
    this.state,
    this.iconPosition = ButtonIconPosition.leading,
    this.spacing = 8.0,
    this.shape = Material4Type.smoothRounded,
    this.customShape,
    this.background,
    this.border,
    this.animation = const Material4ButtonAnimation(),
    this.controller,
    this.color,
    this.foregroundColor,
    this.gradient,
    this.width,
    this.height,
    this.minWidth = 48.0,
    this.minHeight = 48.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.margin,
    this.textStyle,
    this.isLoading = false,
    this.loadingWidget,
    this.successWidget,
    this.errorWidget,
    this.badge,
    this.hasDropdown = false,
    this.dropdownWidget,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.semanticHint,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Factory for a high-prominence filled action button.
  factory Material4Button.filled({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Color color = const Color(0xFF4F46E5),
    Color foregroundColor = Colors.white,
    Material4Type shape = Material4Type.smoothRounded,
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    Material4ButtonAnimation animation = Material4ButtonAnimation.subtle,
    bool isLoading = false,
    Widget? child,
  }) {
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      color: color,
      foregroundColor: foregroundColor,
      shape: shape,
      width: width,
      height: height,
      padding: padding,
      animation: animation,
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for an outlined button with a crisp vector border stroke.
  factory Material4Button.outlined({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Color borderColor = const Color(0xFF4F46E5),
    double borderWidth = 1.5,
    Color foregroundColor = const Color(0xFF4F46E5),
    Material4Type shape = Material4Type.smoothRounded,
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    Material4ButtonAnimation animation = Material4ButtonAnimation.subtle,
    bool isLoading = false,
    Widget? child,
  }) {
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      color: Colors.transparent,
      border: Material4Border.solid(color: borderColor, width: borderWidth),
      foregroundColor: foregroundColor,
      shape: shape,
      width: width,
      height: height,
      padding: padding,
      animation: animation,
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for a borderless text-only button.
  factory Material4Button.text({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Color foregroundColor = const Color(0xFF4F46E5),
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    bool isLoading = false,
    Widget? child,
  }) {
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      color: Colors.transparent,
      border: Material4Border.none,
      foregroundColor: foregroundColor,
      padding: padding,
      animation: const Material4ButtonAnimation(
        press: ButtonPressAnimation.scaleDown,
        hover: ButtonHoverAnimation.none,
        tap: ButtonTapAnimation.ripple,
        pressScale: 0.96,
      ),
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for an elevated button with prominent multi-tier drop shadows.
  factory Material4Button.elevated({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Color color = const Color(0xFF4F46E5),
    Color foregroundColor = Colors.white,
    Material4Type shape = Material4Type.squircle,
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    bool isLoading = false,
    Widget? child,
  }) {
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      shape: shape,
      background: Material4Background(
        color: color,
        shadows: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 14, offset: Offset(0, 6)),
          BoxShadow(color: Color(0x224F46E5), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      animation: const Material4ButtonAnimation(
        press: ButtonPressAnimation.depthPress,
        hover: ButtonHoverAnimation.liftUp,
        hoverLift: -3.0,
      ),
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for a vibrant multi-stop linear gradient button.
  factory Material4Button.gradient({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Gradient? gradient,
    List<Color>? colors,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Color foregroundColor = Colors.white,
    Material4Type shape = Material4Type.continuousSquircle,
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    bool isLoading = false,
    Widget? child,
  }) {
    final effectiveGradient = gradient ??
        (colors != null
            ? LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ));
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      gradient: effectiveGradient,
      foregroundColor: foregroundColor,
      shape: shape,
      width: width,
      height: height,
      padding: padding,
      animation: const Material4ButtonAnimation(
        press: ButtonPressAnimation.elastic,
        hover: ButtonHoverAnimation.gradientMovement,
        tap: ButtonTapAnimation.particleBurst,
        pressScale: 0.94,
      ),
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for a frosted glassmorphic button.
  factory Material4Button.glass({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Color foregroundColor = Colors.white,
    Material4Type shape = Material4Type.squircle,
    double blur = 16.0,
    Color tint = const Color(0x28FFFFFF),
    Color borderColor = const Color(0x50FFFFFF),
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    bool isLoading = false,
    Widget? child,
  }) {
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      shape: shape,
      background: Material4Background(
        isGlassmorphic: true,
        glassBlur: blur,
        glassTint: tint,
        shadows: const [
          BoxShadow(color: Color(0x18000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      border: Material4Border.solid(
        color: borderColor,
        width: 1.2,
        strokeAlign: ShapeStrokeAlign.inside,
      ),
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      animation: const Material4ButtonAnimation(
        press: ButtonPressAnimation.scaleDown,
        hover: ButtonHoverAnimation.glow,
        tap: ButtonTapAnimation.glowPulse,
      ),
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for a hydrodynamic fluid liquid wave button.
  factory Material4Button.liquid({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Gradient gradient = const LinearGradient(
      colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    Color foregroundColor = Colors.white,
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    bool isLoading = false,
    Widget? child,
  }) {
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      shape: Material4Type.liquid,
      gradient: gradient,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      animation: Material4ButtonAnimation.fluid,
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for a tactile sculpted organic card button with paper texture.
  factory Material4Button.organic({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Color color = const Color(0xFFFFFBEB),
    Color borderColor = const Color(0xFFD97706),
    Color foregroundColor = const Color(0xFF92400E),
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    bool isLoading = false,
    Widget? child,
  }) {
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      shape: Material4Type.organicBlob,
      background: Material4Background(
        color: color,
        texture: const Material4Texture.paper(opacity: 0.25),
        shadows: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      border: Material4Border.solid(color: borderColor, width: 1.5),
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      animation: const Material4ButtonAnimation(
        press: ButtonPressAnimation.spring,
        hover: ButtonHoverAnimation.shapeMorph,
        tap: ButtonTapAnimation.liquidRipple,
      ),
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for a Cyberpunk luminous neon button with ambient bloom.
  factory Material4Button.neon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Color color = const Color(0xFF0F172A),
    Color neonColor = const Color(0xFF00E5FF),
    Material4Type shape = Material4Type.smoothRounded,
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    bool isLoading = false,
    Widget? child,
  }) {
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      shape: shape,
      background: Material4Background(
        color: color,
        shadows: [
          BoxShadow(color: neonColor.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 2)),
        ],
      ),
      border: Material4Border.neon(
        color: neonColor,
        width: 2.0,
        glowIntensity: 1.8,
        animated: true,
      ),
      foregroundColor: neonColor,
      width: width,
      height: height,
      padding: padding,
      animation: Material4ButtonAnimation.neon,
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for a tactile physical 3D button compressing along the Y-axis.
  factory Material4Button.threeD({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    Color? color,
    Color? faceColor,
    Color depthColor = const Color(0xFF3730A3),
    Color foregroundColor = Colors.white,
    Material4Type shape = Material4Type.smoothRounded,
    double? width,
    double? height,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    bool isLoading = false,
    Widget? child,
  }) {
    final effectiveColor = faceColor ?? color ?? const Color(0xFF4F46E5);
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      shape: shape,
      background: Material4Background(
        color: effectiveColor,
        shadows: [
          BoxShadow(color: depthColor, blurRadius: 0, offset: const Offset(0, 4)),
        ],
      ),
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      animation: Material4ButtonAnimation.threeD,
      isLoading: isLoading,
      child: child,
    );
  }

  /// Factory for a Floating Action Button (FAB).
  factory Material4Button.floating({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    required dynamic icon,
    String? text,
    Color color = const Color(0xFF6366F1),
    Color foregroundColor = Colors.white,
    Material4Type shape = Material4Type.capsule,
    bool isLoading = false,
  }) {
    final Widget iconWidget = icon is IconData ? Icon(icon) : (icon as Widget);
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      icon: iconWidget,
      text: text,
      shape: shape,
      background: Material4Background(
        color: color,
        shadows: const [
          BoxShadow(color: Color(0x406366F1), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      foregroundColor: foregroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      animation: const Material4ButtonAnimation(
        press: ButtonPressAnimation.scaleDown,
        hover: ButtonHoverAnimation.liftUp,
        hoverLift: -4.0,
        pressScale: 0.94,
      ),
      isLoading: isLoading,
    );
  }

  /// Factory for an icon-only button with circular or square hit target.
  factory Material4Button.icon({
    Key? key,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    required dynamic icon,
    Widget? label,
    String? text,
    Color? color,
    Color? foregroundColor,
    Material4Type shape = Material4Type.continuousSquircle,
    double? size,
    bool isLoading = false,
    String? semanticLabel,
  }) {
    final Widget iconWidget = icon is IconData ? Icon(icon) : (icon as Widget);
    final isIconOnly = label == null && text == null;
    final effectiveSize = size ?? (isIconOnly ? 48.0 : null);
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      icon: iconWidget,
      text: text,
      shape: shape,
      color: color ?? Colors.transparent,
      foregroundColor: foregroundColor ?? const Color(0xFF4F46E5),
      width: effectiveSize,
      height: effectiveSize,
      minWidth: effectiveSize ?? 48.0,
      minHeight: effectiveSize ?? 48.0,
      padding: isIconOnly ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      animation: Material4ButtonAnimation.subtle,
      isLoading: isLoading,
      semanticLabel: semanticLabel,
      child: label,
    );
  }

  /// Factory constructing a button from a predefined [Material4ButtonPreset].
  factory Material4Button.fromPreset({
    Key? key,
    required Material4ButtonPreset preset,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    String? text,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.leading,
    double? width,
    double? height,
    bool isLoading = false,
    Widget? child,
    String? semanticLabel,
  }) {
    return Material4Button(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      text: text,
      icon: icon,
      iconPosition: iconPosition,
      shape: preset.shape ?? Material4Type.smoothRounded,
      customShape: preset.customShape,
      background: preset.background,
      border: preset.border,
      animation: preset.animation,
      foregroundColor: preset.foregroundColor,
      textStyle: preset.textStyle,
      padding: preset.padding,
      width: width,
      height: height,
      isLoading: isLoading,
      semanticLabel: semanticLabel,
      child: child,
    );
  }

  @override
  State<Material4Button> createState() => _Material4ButtonState();
}

class _Material4ButtonState extends State<Material4Button>
    with TickerProviderStateMixin {
  late final FocusNode _focusNode;
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;
  Offset _touchPosition = Offset.zero;

  // Single coordinated Tickers
  late final AnimationController _interactionAnimController;
  late final AnimationController _tapRippleController;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChanged);

    _interactionAnimController = AnimationController(
      vsync: this,
      duration: widget.animation.hoverDuration,
    );

    _tapRippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    widget.controller?.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant Material4Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _interactionAnimController.dispose();
    _tapRippleController.dispose();
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _handleControllerChanged() {
    if (mounted) setState(() {});
  }

  bool get _isInteractive {
    if (widget.state == Material4ButtonState.disabled ||
        widget.state == Material4ButtonState.loading) {
      return false;
    }
    final controllerEnabled = widget.controller?.isEnabled ?? true;
    return widget.enabled && controllerEnabled && widget.onPressed != null && !_isLoading;
  }

  bool get _isLoading {
    return widget.state == Material4ButtonState.loading || widget.isLoading || (widget.controller?.isLoading ?? false);
  }

  Material4ButtonState get _effectiveState {
    if (widget.state != null) return widget.state!;
    if (!_isInteractive && !_isLoading && !(widget.controller?.isSuccess ?? false) && !(widget.controller?.isError ?? false)) {
      return Material4ButtonState.disabled;
    }
    if (_isLoading) return Material4ButtonState.loading;
    if (widget.controller?.isSuccess ?? false) return Material4ButtonState.success;
    if (widget.controller?.isError ?? false) return Material4ButtonState.error;
    if (_isPressed) return Material4ButtonState.pressed;
    if (_isHovered) return Material4ButtonState.hovered;
    if (_isFocused) return Material4ButtonState.focused;
    return Material4ButtonState.idle;
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isInteractive) return;
    setState(() {
      _isPressed = true;
      _touchPosition = details.localPosition;
    });
    _interactionAnimController.animateTo(1.0, duration: widget.animation.pressDuration);
    _tapRippleController.forward(from: 0.0);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isInteractive) return;
    setState(() => _isPressed = false);
    _interactionAnimController.animateBack(0.0, duration: widget.animation.pressDuration);
  }

  void _handleTapCancel() {
    if (!_isInteractive) return;
    setState(() => _isPressed = false);
    _interactionAnimController.animateBack(0.0, duration: widget.animation.pressDuration);
  }

  void _handleTap() {
    if (!_isInteractive) return;
    widget.onPressed?.call();
  }

  void _handleLongPress() {
    if (!_isInteractive) return;
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final disableAnimations = mediaQuery?.disableAnimations ?? false;
    final state = _effectiveState;

    final theme = Theme.of(context);
    final effectiveForeground = widget.foregroundColor ??
        (state == Material4ButtonState.disabled ? const Color(0xFF94A3B8) : Colors.white);

    final effectiveTextStyle = widget.textStyle ??
        theme.textTheme.labelLarge ??
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);

    // Dynamic Shape
    final activeShape = widget.controller?.activeShape ?? widget.shape;
    final activeCustomShape = widget.controller?.activeCustomShape ?? widget.customShape;

    // Content Tree
    final feedbackMessage = widget.controller?.feedbackMessage;
    final effectiveContentDesc = widget.content ??
        Material4ButtonContent(
          text: (state == Material4ButtonState.success || state == Material4ButtonState.error) && feedbackMessage != null
              ? feedbackMessage
              : widget.text,
          labelWidget: (state == Material4ButtonState.success || state == Material4ButtonState.error) && feedbackMessage != null
              ? Text(feedbackMessage)
              : widget.child,
          icon: widget.icon,
          iconPosition: widget.iconPosition,
          spacing: widget.spacing,
          loadingWidget: widget.loadingWidget,
          successWidget: widget.successWidget,
          errorWidget: widget.errorWidget,
          badge: widget.badge,
          hasDropdown: widget.hasDropdown,
          dropdownWidget: widget.dropdownWidget,
        );
    final content = effectiveContentDesc.build(
      context: context,
      state: state,
      textStyle: effectiveTextStyle,
      foregroundColor: effectiveForeground,
    );

    // Background & Shadows
    Material4Background effectiveBackground = widget.background ??
        Material4Background(
          color: widget.color ?? (widget.gradient != null ? null : const Color(0xFF4F46E5)),
          gradient: widget.gradient,
        );

    if (state == Material4ButtonState.disabled) {
      effectiveBackground = effectiveBackground.copyWith(
        color: (effectiveBackground.color ?? const Color(0xFF4F46E5)).withValues(alpha: 0.4),
      );
    }

    // Border
    Material4Border effectiveBorder = widget.border ?? const Material4Border();
    if (_isFocused && widget.animation.focus == ButtonFocusAnimation.animatedFocusBorder) {
      effectiveBorder = Material4Border.movingDash(
        color: const Color(0xFF38BDF8),
        width: 2.2,
      );
    } else if (_isFocused && widget.animation.focus == ButtonFocusAnimation.glowFocus) {
      effectiveBorder = Material4Border.neon(
        color: const Color(0xFF38BDF8),
        width: 2.0,
      );
    }

    // Motion Transform Matrix
    Widget transformedContent = content;

    if (!disableAnimations) {
      double scale = 1.0;
      double dy = 0.0;

      if (_isPressed) {
        switch (widget.animation.press) {
          case ButtonPressAnimation.scaleDown:
            scale = widget.animation.pressScale;
            break;
          case ButtonPressAnimation.scaleUp:
            scale = 1.0 + (1.0 - widget.animation.pressScale);
            break;
          case ButtonPressAnimation.elastic:
          case ButtonPressAnimation.spring:
          case ButtonPressAnimation.bounce:
            scale = widget.animation.pressScale;
            break;
          case ButtonPressAnimation.threeD:
            dy = widget.animation.depthOffset;
            break;
          case ButtonPressAnimation.depthPress:
            dy = widget.animation.depthOffset * 0.75;
            scale = 0.98;
            break;
          case ButtonPressAnimation.liquidPress:
            scale = widget.animation.pressScale;
            break;
          default:
            break;
        }
      } else if (_isHovered) {
        switch (widget.animation.hover) {
          case ButtonHoverAnimation.liftUp:
            dy = widget.animation.hoverLift;
            break;
          case ButtonHoverAnimation.scale:
            scale = widget.animation.hoverScale;
            break;
          case ButtonHoverAnimation.floating:
            dy = widget.animation.hoverLift * 1.2;
            break;
          default:
            break;
        }
      }

      transformedContent = Transform.translate(
        offset: Offset(0, dy),
        child: Transform.scale(
          scale: scale,
          child: content,
        ),
      );
    }

    // Inner Button Surface
    Widget buttonSurface = LayoutBuilder(
      builder: (context, constraints) {
        final renderSize = Size(
          widget.width ?? (constraints.hasBoundedWidth ? constraints.maxWidth : 120),
          widget.height ?? (constraints.hasBoundedHeight ? constraints.maxHeight : 48),
        );
        final config = Material4Config(type: activeShape, customShape: activeCustomShape);
        final shapePath = Material4PathBuilder.buildPath(renderSize, config);

        return Stack(
          alignment: Alignment.center,
          children: [
            Material4Container(
              width: widget.width,
              height: widget.height,
              config: config,
              customShape: activeCustomShape,
              background: effectiveBackground,
              border: effectiveBorder,
              padding: widget.padding,
              clipBehavior: widget.clipBehavior,
              child: transformedContent,
            ),
            // Tap Ripple Overlay
            if (!disableAnimations && widget.animation.tap != ButtonTapAnimation.none)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _tapRippleController,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: Material4ButtonRipplePainter(
                        progress: _tapRippleController.value,
                        touchPoint: _touchPosition,
                        clipPath: shapePath,
                        tapAnimation: widget.animation.tap,
                        rippleColor: widget.animation.rippleColor ??
                            effectiveForeground.withValues(alpha: 0.35),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );

    // Interactive Wrappers: Touch Target & Accessibility
    Widget interactiveButton = MouseRegion(
      cursor: _isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (!_isInteractive) return;
        setState(() => _isHovered = true);
        _interactionAnimController.animateTo(1.0, duration: widget.animation.hoverDuration);
      },
      onExit: (_) {
        if (!_isInteractive) return;
        setState(() => _isHovered = false);
        _interactionAnimController.animateBack(0.0, duration: widget.animation.hoverDuration);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        onLongPress: widget.onLongPress != null ? _handleLongPress : null,
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onKeyEvent: (node, event) {
            if (!_isInteractive) return KeyEventResult.ignored;
            if (event is KeyDownEvent &&
                (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space)) {
              _handleTap();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: widget.minWidth,
              minHeight: widget.minHeight,
            ),
            child: Center(
              child: buttonSurface,
            ),
          ),
        ),
      ),
    );

    if (widget.margin != null) {
      interactiveButton = Padding(
        padding: widget.margin!,
        child: interactiveButton,
      );
    }

    // WCAG Semantics & Live Region
    return Semantics(
      container: true,
      button: true,
      enabled: _isInteractive,
      focusable: true,
      focused: _isFocused,
      onTap: _isInteractive ? _handleTap : null,
      onLongPress: _isInteractive && widget.onLongPress != null ? _handleLongPress : null,
      label: widget.semanticLabel ?? widget.text,
      hint: widget.semanticHint,
      excludeSemantics: widget.semanticLabel != null,
      liveRegion: _isLoading ||
          (widget.controller?.isSuccess ?? false) ||
          (widget.controller?.isError ?? false),
      child: interactiveButton,
    );
  }
}
