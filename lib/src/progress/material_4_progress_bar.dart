import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'progress_style.dart';
import 'progress_shape.dart';
import 'progress_track.dart';
import 'progress_fill.dart';
import 'progress_label.dart';
import 'progress_effects.dart';
import 'progress_animation.dart';
import 'progress_interaction.dart';
import 'progress_controller.dart';
import 'progress_presets.dart';
import 'progress_painter.dart';
import 'wave_line/wave_line.dart';

/// Convenient alias for [Material4ProgressBar] matching user naming preference.
typedef Material4Progress = Material4ProgressBar;

/// Material 4 — Universal Dynamic Progress Bar System.
///
/// Provides a unified, ultra-flexible progress indicator supporting linear,
/// circular, creative styles (wave, liquid, segmented, neon, glass, sculpted),
/// and advanced animated wave lines (zigzag, organic sine, DNA, ribbon, pulse).
/// Features interruptible value animations, shape morphing, interactive seeking,
/// and full accessibility semantics.
class Material4ProgressBar extends StatefulWidget {
  /// Progress value between 0.0 and 1.0, or null for continuous indeterminate mode.
  final double? value;

  /// Secondary progress value (0.0 to 1.0) for buffer or streaming indicators.
  final double? secondaryValue;

  /// Visual presentation style preset.
  final Material4ProgressStyle style;

  /// Advanced animated wave line configuration when [style.isWaveLine] is true.
  final Material4WaveLineConfig? waveLine;

  /// Contour shape geometry of the progress container and fill.
  final Material4ProgressShape shape;

  /// Background track container configuration.
  final Material4ProgressTrack track;

  /// Active progressing fill configuration.
  final Material4ProgressFill fill;

  /// Typography, counter, and label configuration.
  final Material4ProgressLabel? label;

  /// Visual effects (glow, neon, glass, shimmer, breathing, particles).
  final Material4ProgressEffects effects;

  /// Animation curves, timing, waves, stripes, and morphing configuration.
  final Material4ProgressAnimation animation;

  /// Seeking gestures, step quantization, and draggable thumb configuration.
  final Material4ProgressInteraction? interaction;

  /// Programmatic external controller.
  final Material4ProgressController? controller;

  /// Explicit bounded width.
  final double? width;

  /// Explicit bounded height.
  final double? height;

  /// Accessible screen reader label description.
  final String? semanticLabel;

  /// Accessible screen reader value description override.
  final String? semanticValue;

  /// Creates a customizable [Material4ProgressBar].
  const Material4ProgressBar({
    super.key,
    this.value,
    this.secondaryValue,
    this.style = Material4ProgressStyle.capsuleLinear,
    this.waveLine,
    this.shape = const Material4ProgressShape.raw(
      id: 'capsule',
      pathBuilder: _defaultCapsulePath,
    ),
    this.track = const Material4ProgressTrack(),
    this.fill = const Material4ProgressFill(),
    this.label,
    this.effects = const Material4ProgressEffects(),
    this.animation = const Material4ProgressAnimation(),
    this.interaction,
    this.controller,
    this.width,
    this.height,
    this.semanticLabel,
    this.semanticValue,
  });

  static Path _defaultCapsulePath(Size size) {
    final path = Path();
    final r = math.min(size.width, size.height) / 2.0;
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(r),
      ),
    );
    return path;
  }

  // =========================================================================
  // Factory Constructors
  // =========================================================================

  /// Factory for a classic or rounded linear progress bar.
  factory Material4ProgressBar.linear({
    Key? key,
    double? value,
    double? secondaryValue,
    Material4ProgressStyle style = Material4ProgressStyle.capsuleLinear,
    Material4ProgressShape? shape,
    Color? trackColor,
    Color? progressColor,
    Gradient? progressGradient,
    double height = 8.0,
    double? width,
    Material4ProgressLabel? label,
    Material4ProgressEffects effects = const Material4ProgressEffects(),
    Material4ProgressAnimation animation = Material4ProgressAnimation.smooth,
    Material4ProgressInteraction? interaction,
    Material4ProgressController? controller,
    String? semanticLabel,
  }) {
    return Material4ProgressBar(
      key: key,
      value: value,
      secondaryValue: secondaryValue,
      style: style,
      shape: shape ?? Material4ProgressShape.capsule(),
      track: Material4ProgressTrack(color: trackColor, thickness: height),
      fill: Material4ProgressFill(
        color: progressColor,
        gradient: progressGradient,
      ),
      label: label,
      effects: effects,
      animation: animation,
      interaction: interaction,
      controller: controller,
      width: width,
      height: height,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory for a circular radial progress ring.
  factory Material4ProgressBar.circular({
    Key? key,
    double? value,
    double size = 48.0,
    double strokeWidth = 6.0,
    Color? trackColor,
    Color? progressColor,
    Gradient? progressGradient,
    bool showPercentage = false,
    Widget? centerChild,
    Material4ProgressAnimation animation = Material4ProgressAnimation.smooth,
    Material4ProgressEffects effects = const Material4ProgressEffects(),
    Material4ProgressController? controller,
    String? semanticLabel,
  }) {
    return Material4ProgressBar(
      key: key,
      value: value,
      style: Material4ProgressStyle.roundedCircular,
      shape: Material4ProgressShape.circle(),
      track: Material4ProgressTrack(color: trackColor, thickness: strokeWidth),
      fill: Material4ProgressFill(
        color: progressColor,
        gradient: progressGradient,
      ),
      label: showPercentage || centerChild != null
          ? Material4ProgressLabel(
              showPercentage: showPercentage,
              position: ProgressLabelPosition.center,
              center: centerChild,
            )
          : null,
      effects: effects,
      animation: animation,
      controller: controller,
      width: size,
      height: size,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory for a fluid wave progress bar.
  factory Material4ProgressBar.wave({
    Key? key,
    double? value,
    double height = 18.0,
    double? width,
    Color? color,
    double waveAmplitude = 4.0,
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
  }) {
    final preset = Material4ProgressPresets.wave(
      color: color ?? const Color(0xFF06B6D4),
      height: height,
    );
    return Material4ProgressBar(
      key: key,
      value: value,
      style: preset.style,
      shape: preset.shape,
      track: preset.track,
      fill: preset.fill.copyWith(waveAmplitude: waveAmplitude),
      label: label,
      effects: preset.effects,
      animation: preset.animation,
      controller: controller,
      width: width,
      height: height,
    );
  }

  /// Factory for an effervescent liquid reservoir progress bar with micro-bubbles.
  factory Material4ProgressBar.liquid({
    Key? key,
    double? value,
    double height = 24.0,
    double? width,
    Color? color,
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
  }) {
    final preset = Material4ProgressPresets.liquid(
      color: color ?? const Color(0xFF00B0FF),
      height: height,
    );
    return Material4ProgressBar(
      key: key,
      value: value,
      style: preset.style,
      shape: preset.shape,
      track: preset.track,
      fill: preset.fill,
      label: label,
      effects: preset.effects,
      animation: preset.animation,
      controller: controller,
      width: width,
      height: height,
    );
  }

  /// Factory for a discretized segmented progress bar.
  factory Material4ProgressBar.segmented({
    Key? key,
    double? value,
    int segments = 8,
    double segmentGap = 4.0,
    double height = 10.0,
    double? width,
    Color? color,
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
  }) {
    final preset = Material4ProgressPresets.segmented(
      color: color ?? const Color(0xFF10B981),
      segments: segments,
      segmentGap: segmentGap,
      height: height,
    );
    return Material4ProgressBar(
      key: key,
      value: value,
      style: preset.style,
      shape: preset.shape,
      track: preset.track,
      fill: preset.fill,
      label: label,
      effects: preset.effects,
      animation: preset.animation,
      controller: controller,
      width: width,
      height: height,
    );
  }

  /// Factory for a high-voltage neon laser tube progress indicator.
  factory Material4ProgressBar.neon({
    Key? key,
    double? value,
    double height = 10.0,
    double? width,
    Color color = const Color(0xFF00E5FF),
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
  }) {
    final preset = Material4ProgressPresets.neon(color: color, height: height);
    return Material4ProgressBar(
      key: key,
      value: value,
      style: preset.style,
      shape: preset.shape,
      track: preset.track,
      fill: preset.fill,
      label: label,
      effects: preset.effects,
      animation: preset.animation,
      controller: controller,
      width: width,
      height: height,
    );
  }

  /// Factory for a frosted glassmorphism progress indicator.
  factory Material4ProgressBar.glass({
    Key? key,
    double? value,
    double height = 14.0,
    double? width,
    Color color = const Color(0xFF6366F1),
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
  }) {
    final preset = Material4ProgressPresets.glass(fillColor: color, height: height);
    return Material4ProgressBar(
      key: key,
      value: value,
      style: preset.style,
      shape: preset.shape,
      track: preset.track,
      fill: preset.fill,
      label: label,
      effects: preset.effects,
      animation: preset.animation,
      controller: controller,
      width: width,
      height: height,
    );
  }

  /// Factory for a 3D beveled sculpted container progress indicator.
  factory Material4ProgressBar.sculpted({
    Key? key,
    double? value,
    double height = 16.0,
    double? width,
    Color color = const Color(0xFF3B82F6),
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
  }) {
    final preset = Material4ProgressPresets.sculpted(color: color, height: height);
    return Material4ProgressBar(
      key: key,
      value: value,
      style: preset.style,
      shape: preset.shape,
      track: preset.track,
      fill: preset.fill,
      label: label,
      effects: preset.effects,
      animation: preset.animation,
      controller: controller,
      width: width,
      height: height,
    );
  }

  /// Factory for an organic asymmetrical curved progress indicator.
  factory Material4ProgressBar.organic({
    Key? key,
    double? value,
    double height = 16.0,
    double? width,
    Color color = const Color(0xFF059669),
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
  }) {
    final preset = Material4ProgressPresets.organic(color: color, height: height);
    return Material4ProgressBar(
      key: key,
      value: value,
      style: preset.style,
      shape: preset.shape,
      track: preset.track,
      fill: preset.fill,
      label: label,
      effects: preset.effects,
      animation: preset.animation,
      controller: controller,
      width: width,
      height: height,
    );
  }

  /// Factory for a milestone step pipeline progress indicator.
  factory Material4ProgressBar.step({
    Key? key,
    double? value,
    int steps = 4,
    double height = 24.0,
    double? width,
    Color color = const Color(0xFF2563EB),
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
  }) {
    return Material4ProgressBar(
      key: key,
      value: value,
      style: Material4ProgressStyle.step,
      shape: Material4ProgressShape.capsule(),
      track: Material4ProgressTrack(
        color: color.withValues(alpha: 0.15),
        thickness: height,
      ),
      fill: Material4ProgressFill(
        color: color,
        segments: steps,
      ),
      label: label,
      controller: controller,
      width: width,
      height: height,
    );
  }

  /// Factory for a continuous indeterminate progress indicator.
  factory Material4ProgressBar.indeterminate({
    Key? key,
    Material4ProgressStyle style = Material4ProgressStyle.capsuleLinear,
    Material4ProgressShape? shape,
    Color? trackColor,
    Color? progressColor,
    double height = 6.0,
    double? width,
    String? semanticLabel,
  }) {
    return Material4ProgressBar(
      key: key,
      value: null,
      style: style,
      shape: shape ?? Material4ProgressShape.capsule(),
      track: Material4ProgressTrack(color: trackColor, thickness: height),
      fill: Material4ProgressFill(color: progressColor),
      height: height,
      width: width,
      semanticLabel: semanticLabel ?? 'Loading...',
    );
  }

  /// Factory for an animated Zigzag Wave progress line.
  factory Material4ProgressBar.zigzag({
    Key? key,
    double? value,
    Material4ProgressStyle style = Material4ProgressStyle.smoothZigzagWave,
    Material4WaveLineConfig waveLine = Material4WaveLineConfig.sharpZigzag,
    double height = 28.0,
    double? width,
    Color color = const Color(0xFF6366F1),
    Color? trackColor,
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
    String? semanticLabel,
  }) {
    return Material4ProgressBar(
      key: key,
      value: value,
      style: style,
      waveLine: waveLine.copyWith(
        trackColor: trackColor ?? waveLine.trackColor,
      ),
      track: Material4ProgressTrack(
        color: trackColor ?? color.withValues(alpha: 0.15),
        thickness: height,
      ),
      fill: Material4ProgressFill(color: color),
      label: label,
      height: height,
      width: width,
      controller: controller,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory for an animated Organic Harmonic Wave progress line.
  factory Material4ProgressBar.waveLine({
    Key? key,
    double? value,
    Material4ProgressStyle style = Material4ProgressStyle.smoothSineWave,
    Material4WaveLineConfig waveLine = Material4WaveLineConfig.smoothSine,
    double height = 28.0,
    double? width,
    Color color = const Color(0xFF00B0FF),
    Color? trackColor,
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
    String? semanticLabel,
  }) {
    return Material4ProgressBar(
      key: key,
      value: value,
      style: style,
      waveLine: waveLine.copyWith(
        trackColor: trackColor ?? waveLine.trackColor,
      ),
      track: Material4ProgressTrack(
        color: trackColor ?? color.withValues(alpha: 0.15),
        thickness: height,
      ),
      fill: Material4ProgressFill(color: color),
      label: label,
      height: height,
      width: width,
      controller: controller,
      semanticLabel: semanticLabel,
    );
  }

  /// Factory for a Creative Animated Line progress indicator (snake, ribbon, pulse, neon, DNA, etc.).
  factory Material4ProgressBar.creativeLine({
    Key? key,
    double? value,
    required Material4ProgressStyle style,
    Material4WaveLineConfig waveLine = const Material4WaveLineConfig(),
    double height = 32.0,
    double? width,
    Color color = const Color(0xFF8B5CF6),
    Color? trackColor,
    Material4ProgressLabel? label,
    Material4ProgressController? controller,
    String? semanticLabel,
  }) {
    return Material4ProgressBar(
      key: key,
      value: value,
      style: style,
      waveLine: waveLine.copyWith(
        trackColor: trackColor ?? waveLine.trackColor,
      ),
      track: Material4ProgressTrack(
        color: trackColor ?? color.withValues(alpha: 0.15),
        thickness: height,
      ),
      fill: Material4ProgressFill(color: color),
      label: label,
      height: height,
      width: width,
      controller: controller,
      semanticLabel: semanticLabel,
    );
  }

  @override
  State<Material4ProgressBar> createState() => _Material4ProgressBarState();
}

class _Material4ProgressBarState extends State<Material4ProgressBar>
    with TickerProviderStateMixin
    implements ProgressControllerHost {
  // Value interpolation controller (smooth interruptible value transitions)
  late AnimationController _valueController;
  late Animation<double> _valueAnimation;
  double _currentAnimatedValue = 0.0;

  // Cyclical phase controller (waves, stripes, liquid bubbles, shimmer)
  AnimationController? _phaseController;

  // Indeterminate sweep controller
  AnimationController? _indeterminateController;

  // Shape morphing controller
  AnimationController? _morphController;
  Material4ProgressShape? _morphStartShape;
  Material4ProgressShape? _morphTargetShape;
  late Material4ProgressShape _activeShape;

  // Current logical value if user is actively dragging
  double? _dragValue;
  bool _isDragging = false;

  bool get _needsContinuousPhase =>
      widget.style.isWaveLine ||
      widget.effects.shimmer ||
      widget.effects.breathing ||
      widget.effects.pulse ||
      widget.fill.striped ||
      widget.style.isWaveOrLiquid ||
      widget.style == Material4ProgressStyle.animatedStripedLinear ||
      widget.style == Material4ProgressStyle.equalizer;

  @override
  void initState() {
    super.initState();
    _activeShape = widget.shape;
    final initialVal = widget.value?.clamp(0.0, 1.0) ?? 0.0;
    _currentAnimatedValue = initialVal;

    // 1. Value animation controller
    _valueController = AnimationController(
      vsync: this,
      duration: widget.animation.duration,
    );
    _valueAnimation = Tween<double>(
      begin: initialVal,
      end: initialVal,
    ).animate(
      CurvedAnimation(
        parent: _valueController,
        curve: widget.animation.curve,
      ),
    )..addListener(() {
        setState(() {
          _currentAnimatedValue = _valueAnimation.value;
        });
      });

    // 2. Setup Phase & Indeterminate tickers
    _setupPhaseController();
    _setupIndeterminateController();

    // 3. Attach programmatic controller if provided
    widget.controller?.attach(this);
    if (widget.controller != null && widget.value != null) {
      widget.controller!.updateValueFromHost(widget.value);
    }
  }

  void _setupPhaseController() {
    final isPaused = widget.waveLine?.paused ?? false;
    final duration = widget.waveLine?.duration ?? const Duration(milliseconds: 2000);

    if (_needsContinuousPhase && _phaseController == null) {
      _phaseController = AnimationController(
        vsync: this,
        duration: duration,
      );
      if (!isPaused && widget.animation.autoPlay) {
        if (widget.waveLine?.pingPong == true) {
          _phaseController?.repeat(reverse: true);
        } else {
          _phaseController?.repeat();
        }
      }
    } else if (_needsContinuousPhase && _phaseController != null) {
      if (_phaseController!.duration != duration) {
        _phaseController!.duration = duration;
      }
      if (isPaused && _phaseController!.isAnimating) {
        _phaseController?.stop();
      } else if (!isPaused && !_phaseController!.isAnimating && widget.animation.autoPlay) {
        if (widget.waveLine?.pingPong == true) {
          _phaseController?.repeat(reverse: true);
        } else {
          _phaseController?.repeat();
        }
      }
    } else if (!_needsContinuousPhase && _phaseController != null) {
      _phaseController?.dispose();
      _phaseController = null;
    }
  }

  void _setupIndeterminateController() {
    if (widget.value == null && _indeterminateController == null) {
      _indeterminateController = AnimationController(
        vsync: this,
        duration: widget.animation.indeterminateDuration,
      )..repeat();
    } else if (widget.value != null && _indeterminateController != null) {
      _indeterminateController?.dispose();
      _indeterminateController = null;
    }
  }

  @override
  void didUpdateWidget(covariant Material4ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }

    // Target value transition
    if (widget.value != oldWidget.value) {
      _setupIndeterminateController();
      if (widget.value != null) {
        final target = widget.value!.clamp(0.0, 1.0);
        _animateValueTo(target);
      }
    }

    _setupPhaseController();

    if (oldWidget.shape != widget.shape) {
      _activeShape = widget.shape;
    }
  }

  void _animateValueTo(double target, {Duration? duration, Curve? curve}) {
    final isReducedMotion =
        widget.animation.reducedMotion ||
        (context.mounted && MediaQuery.disableAnimationsOf(context));

    if (isReducedMotion) {
      _valueController.stop();
      setState(() {
        _currentAnimatedValue = target;
      });
      return;
    }

    _valueAnimation = Tween<double>(
      begin: _currentAnimatedValue,
      end: target,
    ).animate(
      CurvedAnimation(
        parent: _valueController,
        curve: curve ?? widget.animation.curve,
      ),
    );

    _valueController.duration = duration ?? widget.animation.duration;
    _valueController.forward(from: 0.0);
  }

  // =========================================================================
  // ProgressControllerHost Implementation
  // =========================================================================

  @override
  void animateTo(double targetValue, {Duration? duration, Curve? curve}) {
    _animateValueTo(targetValue.clamp(0.0, 1.0), duration: duration, curve: curve);
  }

  @override
  void jumpTo(double targetValue) {
    _valueController.stop();
    setState(() {
      _currentAnimatedValue = targetValue.clamp(0.0, 1.0);
    });
  }

  @override
  void setIndeterminate(bool indeterminate) {
    setState(() {
      if (indeterminate) {
        _setupIndeterminateController();
      } else {
        _indeterminateController?.dispose();
        _indeterminateController = null;
      }
    });
  }

  @override
  void play() {
    _phaseController?.repeat();
    _indeterminateController?.repeat();
  }

  @override
  void pause() {
    _phaseController?.stop();
    _indeterminateController?.stop();
  }

  @override
  void stop() {
    _phaseController?.stop();
    _indeterminateController?.stop();
    jumpTo(0.0);
  }

  @override
  void morphTo(
    Material4ProgressShape targetShape, {
    Duration? duration,
    Curve? curve,
  }) {
    _morphStartShape = _activeShape;
    _morphTargetShape = targetShape;

    _morphController?.dispose();
    _morphController = AnimationController(
      vsync: this,
      duration: duration ?? widget.animation.morphDuration,
    );

    final animation = CurvedAnimation(
      parent: _morphController!,
      curve: curve ?? Curves.easeInOutCubic,
    );

    _morphController!.addListener(() {
      setState(() {
        if (_morphStartShape != null && _morphTargetShape != null) {
          _activeShape = Material4ProgressShape.lerp(
            _morphStartShape!,
            _morphTargetShape!,
            animation.value,
          );
        }
      });
    });

    _morphController!.forward().then((_) {
      _activeShape = targetShape;
    });
  }

  @override
  void dispose() {
    widget.controller?.detach(this);
    _valueController.dispose();
    _phaseController?.dispose();
    _indeterminateController?.dispose();
    _morphController?.dispose();
    super.dispose();
  }

  // =========================================================================
  // Gestures & Interaction Handling
  // =========================================================================

  void _handleDragStart(Offset localPos) {
    if (widget.interaction == null || !widget.interaction!.enabled) return;
    _isDragging = true;
    final size = context.size ?? const Size(200, 20);
    _updateInteractiveValue(localPos, size);
    widget.interaction!.onChangeStart?.call(_currentAnimatedValue);
  }

  void _handleDragUpdate(Offset localPos) {
    if (!_isDragging || widget.interaction == null || !widget.interaction!.enabled) {
      return;
    }
    final size = context.size ?? const Size(200, 20);
    _updateInteractiveValue(localPos, size);
  }

  void _handleDragEnd() {
    if (!_isDragging || widget.interaction == null) return;
    _isDragging = false;
    widget.interaction!.onChangeEnd?.call(_currentAnimatedValue);
    setState(() {
      _dragValue = null;
    });
  }

  void _updateInteractiveValue(Offset localPos, Size size) {
    final interaction = widget.interaction!;
    double ratio;

    if (widget.style.isCircular) {
      final center = Offset(size.width / 2.0, size.height / 2.0);
      final angle = math.atan2(localPos.dy - center.dy, localPos.dx - center.dx);
      // Normalized angle starting at top center (-pi / 2)
      var normAngle = angle + math.pi / 2.0;
      if (normAngle < 0) normAngle += 2 * math.pi;
      ratio = normAngle / (2 * math.pi);
    } else {
      ratio = (localPos.dx / size.width).clamp(0.0, 1.0);
    }

    final rawVal = interaction.denormalize(ratio);
    final quantizedVal = interaction.quantize(rawVal);
    final normalizedQuantized = interaction.normalize(quantizedVal);

    if (quantizedVal != _dragValue) {
      interaction.triggerHaptic();
      setState(() {
        _dragValue = quantizedVal;
        _currentAnimatedValue = normalizedQuantized;
      });
      interaction.onChanged?.call(quantizedVal);
      widget.controller?.updateValueFromHost(normalizedQuantized);
    }
  }

  // =========================================================================
  // Build & Layout Pipeline
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePrimary =
        widget.fill.color ?? theme.colorScheme.primary;
    final effectiveTrack = widget.track.color ??
        (theme.brightness == Brightness.dark
            ? const Color(0x33FFFFFF)
            : const Color(0x1A000000));

    // Effective display value
    final effectiveValue = widget.value == null ? null : _currentAnimatedValue;

    // Build the core graphical indicator
    Widget progressBarWidget = AnimatedBuilder(
      animation: Listenable.merge([
        _valueController,
        if (_phaseController != null) _phaseController!,
        if (_indeterminateController != null) _indeterminateController!,
      ]),
      builder: (context, _) {
        final disableAnimations = widget.animation.reducedMotion ||
            (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
        final animProgress =
            disableAnimations ? 0.0 : (_phaseController?.value ?? 0.0);
        final indetProgress =
            disableAnimations ? 0.0 : (_indeterminateController?.value ?? 0.0);

        final painter = Material4ProgressPainter(
          value: effectiveValue,
          secondaryValue: widget.secondaryValue,
          style: widget.style,
          waveLine: widget.waveLine,
          shape: _activeShape,
          track: widget.track,
          fill: widget.fill,
          effects: widget.effects,
          interaction: widget.interaction,
          animationProgress: animProgress,
          indeterminateProgress: indetProgress,
          primaryColor: effectivePrimary,
          trackFallbackColor: effectiveTrack,
        );

        final customPaint = CustomPaint(
          painter: painter,
          size: Size(
            widget.width ??
                (widget.style.isCircular
                    ? 48.0
                    : double.infinity),
            widget.height ??
                (widget.style.isWaveLine
                    ? math.max(28.0, (widget.waveLine?.amplitude ?? 6.0) * 3.5)
                    : widget.style.isCircular
                        ? 48.0
                        : widget.track.thickness ?? 8.0),
          ),
        );

        return RepaintBoundary(child: customPaint);
      },
    );

    if (widget.interaction != null && widget.interaction!.enabled) {
      progressBarWidget = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (details) =>
            _handleDragStart(details.localPosition),
        onHorizontalDragUpdate: (details) =>
            _handleDragUpdate(details.localPosition),
        onHorizontalDragEnd: (_) => _handleDragEnd(),
        onTapDown: (details) {
          _handleDragStart(details.localPosition);
          _handleDragEnd();
        },
        child: progressBarWidget,
      );
    }

    // Apply explicit width/height constraints if provided
    if (widget.width != null || widget.height != null) {
      progressBarWidget = SizedBox(
        width: widget.width,
        height: widget.height,
        child: progressBarWidget,
      );
    }

    // Compose with Labels & Content
    final content = _composeWithLabels(progressBarWidget, effectiveValue);

    // Wrap with Accessibility Semantics
    return _wrapSemantics(content, effectiveValue);
  }

  Widget _composeWithLabels(Widget progressIndicator, double? effectiveValue) {
    final label = widget.label;
    if (label == null) return progressIndicator;

    final val = effectiveValue ?? 0.0;
    final labelText = label.customText ??
        (label.showPercentage ? label.formatPercentage(val) : label.formatValues() ?? '');

    final textStyle = label.style ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        );

    final labelWidget = label.builder?.call(context, val) ??
        Text(labelText, style: textStyle);

    switch (label.position) {
      case ProgressLabelPosition.outsideTrailing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (label.leading != null) ...[
              label.leading!,
              const SizedBox(width: 8),
            ],
            Expanded(child: progressIndicator),
            const SizedBox(width: 10),
            labelWidget,
            if (label.trailing != null) ...[
              const SizedBox(width: 8),
              label.trailing!,
            ],
          ],
        );

      case ProgressLabelPosition.outsideLeading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            labelWidget,
            const SizedBox(width: 10),
            Expanded(child: progressIndicator),
          ],
        );

      case ProgressLabelPosition.aboveStart:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                labelWidget,
                if (label.showPercentage && label.customText != null)
                  Text(label.formatPercentage(val), style: textStyle),
              ],
            ),
            const SizedBox(height: 6),
            progressIndicator,
          ],
        );

      case ProgressLabelPosition.aboveCenter:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            labelWidget,
            const SizedBox(height: 6),
            progressIndicator,
          ],
        );

      case ProgressLabelPosition.aboveEnd:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            labelWidget,
            const SizedBox(height: 6),
            progressIndicator,
          ],
        );

      case ProgressLabelPosition.belowStart:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            progressIndicator,
            const SizedBox(height: 6),
            labelWidget,
          ],
        );

      case ProgressLabelPosition.belowCenter:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            progressIndicator,
            const SizedBox(height: 6),
            labelWidget,
          ],
        );

      case ProgressLabelPosition.belowEnd:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            progressIndicator,
            const SizedBox(height: 6),
            labelWidget,
          ],
        );

      case ProgressLabelPosition.center:
        return Stack(
          alignment: Alignment.center,
          children: [
            progressIndicator,
            if (label.center != null) label.center! else labelWidget,
          ],
        );

      case ProgressLabelPosition.insideCenter:
      case ProgressLabelPosition.insideTrailing:
      case ProgressLabelPosition.followThumb:
        return Stack(
          alignment: label.position == ProgressLabelPosition.insideCenter
              ? Alignment.center
              : Alignment.centerRight,
          children: [
            progressIndicator,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: labelWidget,
            ),
          ],
        );
    }
  }

  Widget _wrapSemantics(Widget child, double? effectiveValue) {
    final pct = ((effectiveValue ?? 0.0) * 100.0).round();
    final semanticValue = widget.semanticValue ??
        (widget.value == null ? 'Indeterminate' : '$pct%');

    return Semantics(
      label: widget.semanticLabel ?? 'Progress Indicator',
      value: semanticValue,
      slider: widget.interaction != null && widget.interaction!.enabled,
      increasedValue: widget.interaction != null && widget.interaction!.enabled
          ? '${math.min(100, pct + 5)}%'
          : null,
      decreasedValue: widget.interaction != null && widget.interaction!.enabled
          ? '${math.max(0, pct - 5)}%'
          : null,
      onIncrease: widget.interaction != null && widget.interaction!.enabled
          ? () {
              final nextVal = math.min(1.0, (effectiveValue ?? 0.0) + 0.05);
              animateTo(nextVal);
              widget.interaction!.onChanged?.call(nextVal);
            }
          : null,
      onDecrease: widget.interaction != null && widget.interaction!.enabled
          ? () {
              final nextVal = math.max(0.0, (effectiveValue ?? 0.0) - 0.05);
              animateTo(nextVal);
              widget.interaction!.onChanged?.call(nextVal);
            }
          : null,
      child: child,
    );
  }
}
