import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// The window size classes (Material 3 naming), from narrowest to widest.
enum Material4SizeClass {
  /// Phones in portrait (default: narrower than 600).
  compact,

  /// Large phones in landscape, small tablets, foldables (600 – 840).
  medium,

  /// Tablets in landscape, small laptops (840 – 1200).
  expanded,

  /// Desktops and laptops (1200 – 1600).
  large,

  /// Wide desktop monitors and TVs (1600 and wider).
  extraLarge,
}

/// The kind of device, independent of its current width: a phone turned
/// sideways is still a phone, a narrow desktop window is still a desktop.
enum Material4DeviceType {
  /// Shortest side under 600 on a touch platform.
  phone,

  /// Shortest side of 600 or more on a touch platform.
  tablet,

  /// macOS, Windows, Linux (and web on those).
  desktop,
}

/// Where one size class ends and the next begins, in logical pixels.
@immutable
class Material4Breakpoints {
  /// Material 3 window size classes by default.
  const Material4Breakpoints({
    this.medium = 600,
    this.expanded = 840,
    this.large = 1200,
    this.extraLarge = 1600,
  }) : assert(medium < expanded && expanded < large && large < extraLarge);

  /// Smallest width counted as [Material4SizeClass.medium].
  final double medium;

  /// Smallest width counted as [Material4SizeClass.expanded].
  final double expanded;

  /// Smallest width counted as [Material4SizeClass.large].
  final double large;

  /// Smallest width counted as [Material4SizeClass.extraLarge].
  final double extraLarge;

  /// The size class for a screen [width].
  Material4SizeClass classify(double width) {
    if (width >= extraLarge) return Material4SizeClass.extraLarge;
    if (width >= large) return Material4SizeClass.large;
    if (width >= expanded) return Material4SizeClass.expanded;
    if (width >= medium) return Material4SizeClass.medium;
    return Material4SizeClass.compact;
  }

  @override
  bool operator ==(Object other) =>
      other is Material4Breakpoints &&
      other.medium == medium &&
      other.expanded == expanded &&
      other.large == large &&
      other.extraLarge == extraLarge;

  @override
  int get hashCode => Object.hash(medium, expanded, large, extraLarge);
}

/// How the content is scaled to the screen.
///
/// Each size class has the width its UI was designed at. On a screen of
/// width `w` the whole subtree is drawn at `w / designWidth` (clamped to
/// [min] … [max]), so a layout made for a 390 pt phone looks the same on a
/// 360 pt and a 430 pt phone. Between size classes the layout reflows
/// instead of growing: a tablet gets its own design width, not a giant
/// phone UI.
@immutable
class Material4ResponsiveScale {
  /// A design width per size class.
  const Material4ResponsiveScale({
    this.compact = 390,
    this.medium = 720,
    this.expanded = 1024,
    this.large = 1440,
    this.extraLarge = 1920,
    this.min = 0.8,
    this.max = 1.2,
  })  : _enabled = true,
        assert(min > 0 && min <= max);

  /// One design width for every screen (the UI scales everywhere).
  const Material4ResponsiveScale.fixed(
    double designWidth, {
    this.min = 0.5,
    this.max = 3.0,
  })  : compact = designWidth,
        medium = designWidth,
        expanded = designWidth,
        large = designWidth,
        extraLarge = designWidth,
        _enabled = true,
        assert(min > 0 && min <= max);

  const Material4ResponsiveScale._none()
      : compact = 1,
        medium = 1,
        expanded = 1,
        large = 1,
        extraLarge = 1,
        min = 1,
        max = 1,
        _enabled = false;

  /// No scaling: only size classes and responsive values.
  static const Material4ResponsiveScale none = Material4ResponsiveScale._none();

  /// Design width of the [Material4SizeClass.compact] layout.
  final double compact;

  /// Design width of the [Material4SizeClass.medium] layout.
  final double medium;

  /// Design width of the [Material4SizeClass.expanded] layout.
  final double expanded;

  /// Design width of the [Material4SizeClass.large] layout.
  final double large;

  /// Design width of the [Material4SizeClass.extraLarge] layout.
  final double extraLarge;

  /// Smallest scale ever applied.
  final double min;

  /// Largest scale ever applied.
  final double max;

  final bool _enabled;

  /// The scale for a screen [width] in [sizeClass].
  double factorFor(double width, Material4SizeClass sizeClass) {
    if (!_enabled || !width.isFinite || width <= 0) return 1.0;
    final design = switch (sizeClass) {
      Material4SizeClass.compact => compact,
      Material4SizeClass.medium => medium,
      Material4SizeClass.expanded => expanded,
      Material4SizeClass.large => large,
      Material4SizeClass.extraLarge => extraLarge,
    };
    return (width / design).clamp(min, max).toDouble();
  }

  @override
  bool operator ==(Object other) =>
      other is Material4ResponsiveScale &&
      other.compact == compact &&
      other.medium == medium &&
      other.expanded == expanded &&
      other.large == large &&
      other.extraLarge == extraLarge &&
      other.min == min &&
      other.max == max &&
      other._enabled == _enabled;

  @override
  int get hashCode => Object.hash(
      compact, medium, expanded, large, extraLarge, min, max, _enabled);
}

/// What the responsive layer knows about the current screen, read with
/// `context.responsive` (or [Material4Responsive.of]).
@immutable
class Material4Screen {
  /// Creates screen information.
  const Material4Screen({
    required this.sizeClass,
    required this.scale,
    required this.size,
    this.device = Material4DeviceType.phone,
  });

  /// The kind of device (does not change with rotation or window size).
  final Material4DeviceType device;

  /// Whether the area is taller than it is wide.
  bool get isPortrait => size.height >= size.width;

  /// Whether the area is wider than it is tall.
  bool get isLandscape => !isPortrait;

  /// Running on a phone.
  bool get isPhone => device == Material4DeviceType.phone;

  /// Running on a tablet.
  bool get isTablet => device == Material4DeviceType.tablet;

  /// Running on a desktop.
  bool get isDesktop => device == Material4DeviceType.desktop;

  /// Picks a value for the device type; missing values fall back to the
  /// next smaller device (desktop → tablet → phone).
  T byDevice<T>({required T phone, T? tablet, T? desktop}) => switch (device) {
        Material4DeviceType.phone => phone,
        Material4DeviceType.tablet => tablet ?? phone,
        Material4DeviceType.desktop => desktop ?? tablet ?? phone,
      };

  /// The size class of the screen (or of the enclosing area).
  final Material4SizeClass sizeClass;

  /// The scale applied to the content (1.0 when not scaled).
  final double scale;

  /// The size the content lays out in, in its own (scaled) pixels.
  final Size size;

  /// Narrower than the medium breakpoint (phones).
  bool get isCompact => sizeClass == Material4SizeClass.compact;

  /// Medium size class (small tablets, foldables).
  bool get isMedium => sizeClass == Material4SizeClass.medium;

  /// Expanded size class (tablets in landscape).
  bool get isExpanded => sizeClass == Material4SizeClass.expanded;

  /// Large size class (desktop).
  bool get isLarge => sizeClass == Material4SizeClass.large;

  /// Extra-large size class (wide monitors).
  bool get isExtraLarge => sizeClass == Material4SizeClass.extraLarge;

  /// Whether the screen is narrower than [sizeClass].
  bool isBelow(Material4SizeClass sizeClass) =>
      this.sizeClass.index < sizeClass.index;

  /// Whether the screen is at least as wide as [sizeClass].
  bool isAtLeast(Material4SizeClass sizeClass) =>
      this.sizeClass.index >= sizeClass.index;

  /// Picks a value for the current size class. Missing values fall back to
  /// the nearest smaller class, so only the ones that differ are needed:
  ///
  /// ```dart
  /// columns: context.responsive.value(compact: 1, medium: 2, large: 4)
  /// ```
  T value<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    final m = medium ?? compact;
    final e = expanded ?? m;
    final l = large ?? e;
    final xl = extraLarge ?? l;
    return switch (sizeClass) {
      Material4SizeClass.compact => compact,
      Material4SizeClass.medium => m,
      Material4SizeClass.expanded => e,
      Material4SizeClass.large => l,
      Material4SizeClass.extraLarge => xl,
    };
  }

  /// Layout grid columns for the size class (4 / 8 / 12 / 12).
  int get columns => value(compact: 4, medium: 8, expanded: 12);

  /// Recommended outer page margin for the size class.
  double get margin =>
      value(compact: 16.0, medium: 24.0, large: 32.0, extraLarge: 48.0);

  /// Comfortable maximum width for reading content; wider screens should
  /// centre it or add panes (null: no limit needed).
  double? get readableWidth => value<double?>(
        compact: null,
        expanded: 840,
        large: 1040,
        extraLarge: 1240,
      );

  @override
  bool operator ==(Object other) =>
      other is Material4Screen &&
      other.sizeClass == sizeClass &&
      other.scale == scale &&
      other.size == size &&
      other.device == device;

  @override
  int get hashCode => Object.hash(sizeClass, scale, size, device);
}

/// Makes everything below it responsive, without changing that code.
///
/// * **Scales** the subtree to the screen: a UI built with fixed sizes for
///   a 390 pt phone keeps its proportions on every phone, and on every
///   tablet and desktop relative to their own design width (see
///   [Material4ResponsiveScale]). Text, icons, paddings and images scale
///   together; touch input, `MediaQuery` sizes and safe-area insets are
///   translated, so the content never notices.
/// * **Classifies** the screen into a [Material4SizeClass] so layouts can
///   switch where they need to: `context.responsive.value(compact: …,
///   expanded: …)`.
///
/// Place it inside the app so it sits below the app's `MediaQuery`:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => Material4Responsive(child: child!),
///   home: const HomePage(),
/// )
/// ```
///
/// It can also wrap any part of a page; the size class then follows the
/// width of that part (like a container query).
class Material4Responsive extends StatelessWidget {
  /// Creates a responsive area.
  const Material4Responsive({
    super.key,
    this.scale = const Material4ResponsiveScale(),
    this.breakpoints = const Material4Breakpoints(),
    required this.child,
  });

  /// Only classify the screen; never scale.
  const Material4Responsive.noScale({
    super.key,
    this.breakpoints = const Material4Breakpoints(),
    required this.child,
  }) : scale = Material4ResponsiveScale.none;

  /// How the content is scaled.
  final Material4ResponsiveScale scale;

  /// Size class breakpoints.
  final Material4Breakpoints breakpoints;

  /// The content.
  final Widget child;

  /// The device type for a screen of [screenSize] on [platform].
  static Material4DeviceType deviceFor(
    Size screenSize, {
    TargetPlatform? platform,
  }) {
    final p = platform ?? defaultTargetPlatform;
    final desktopPlatform = p == TargetPlatform.macOS ||
        p == TargetPlatform.windows ||
        p == TargetPlatform.linux;
    if (desktopPlatform) return Material4DeviceType.desktop;
    return screenSize.shortestSide >= 600
        ? Material4DeviceType.tablet
        : Material4DeviceType.phone;
  }

  /// The nearest responsive area's screen information. Without one, the
  /// screen is classified from `MediaQuery` with default breakpoints.
  static Material4Screen of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_Material4ResponsiveScope>();
    if (scope != null) return scope.screen;
    final size = MediaQuery.maybeSizeOf(context) ?? Size.zero;
    return Material4Screen(
      sizeClass: const Material4Breakpoints().classify(size.width),
      scale: 1.0,
      size: size,
      device: deviceFor(size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final media = MediaQuery.maybeOf(context);
        final width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : (media?.size.width ?? 0);
        final sizeClass = breakpoints.classify(width);
        final factor = scale.factorFor(width, sizeClass);

        final height = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : (media?.size.height ?? 0);
        final screen = Material4Screen(
          sizeClass: sizeClass,
          scale: factor,
          size: Size(width / factor, height / factor),
          // The device follows the whole screen, not this area.
          device: deviceFor(media?.size ?? Size(width, height)),
        );

        Widget content = child;
        if (media != null) {
          // The content lives in scaled pixels: report sizes and insets in
          // those, and raise the pixel ratio so images stay sharp.
          EdgeInsets s(EdgeInsets e) => e / factor;
          content = MediaQuery(
            data: media.copyWith(
              size: media.size / factor,
              padding: s(media.padding),
              viewPadding: s(media.viewPadding),
              viewInsets: s(media.viewInsets),
              systemGestureInsets: s(media.systemGestureInsets),
              devicePixelRatio: media.devicePixelRatio * factor,
            ),
            child: content,
          );
        }

        return _Material4ResponsiveScope(
          screen: screen,
          child: _ScaledBox(factor: factor, child: content),
        );
      },
    );
  }
}

/// `context.responsive` — the current [Material4Screen].
extension Material4ResponsiveContext on BuildContext {
  /// The nearest responsive area's screen information.
  Material4Screen get responsive => Material4Responsive.of(this);
}

class _Material4ResponsiveScope extends InheritedWidget {
  const _Material4ResponsiveScope({
    required this.screen,
    required super.child,
  });

  final Material4Screen screen;

  @override
  bool updateShouldNotify(_Material4ResponsiveScope old) =>
      old.screen != screen;
}

/// Lays its child out in `constraints / factor` and paints it scaled by
/// `factor`, with hit testing and coordinate conversion going through the
/// same transform. The widget type never changes with the factor, so the
/// subtree keeps its state when the window resizes.
class _ScaledBox extends SingleChildRenderObjectWidget {
  const _ScaledBox({required this.factor, required super.child});

  final double factor;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderScaledBox(factor);

  @override
  void updateRenderObject(BuildContext context, _RenderScaledBox renderObject) {
    renderObject.factor = factor;
  }
}

class _RenderScaledBox extends RenderProxyBox {
  _RenderScaledBox(this._factor);

  double _factor;
  double get factor => _factor;
  set factor(double value) {
    if (value == _factor) return;
    _factor = value;
    markNeedsLayout();
  }

  Matrix4 get _transform => Matrix4.diagonal3Values(_factor, _factor, 1);

  @override
  void performLayout() {
    final c = constraints;
    double d(double v) => v.isFinite ? v / _factor : v;
    final child = this.child;
    if (child == null) {
      size = c.smallest;
      return;
    }
    child.layout(
      BoxConstraints(
        minWidth: d(c.minWidth),
        maxWidth: d(c.maxWidth),
        minHeight: d(c.minHeight),
        maxHeight: d(c.maxHeight),
      ),
      parentUsesSize: true,
    );
    size = c.constrain(child.size * _factor);
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      (super.computeMinIntrinsicWidth(_div(height))) * _factor;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      (super.computeMaxIntrinsicWidth(_div(height))) * _factor;

  @override
  double computeMinIntrinsicHeight(double width) =>
      (super.computeMinIntrinsicHeight(_div(width))) * _factor;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      (super.computeMaxIntrinsicHeight(_div(width))) * _factor;

  double _div(double v) => v.isFinite ? v / _factor : v;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) return constraints.smallest;
    double d(double v) => v.isFinite ? v / _factor : v;
    final childSize = child.getDryLayout(BoxConstraints(
      minWidth: d(constraints.minWidth),
      maxWidth: d(constraints.maxWidth),
      minHeight: d(constraints.minHeight),
      maxHeight: d(constraints.maxHeight),
    ));
    return constraints.constrain(childSize * _factor);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;
    if (_factor == 1.0) {
      layer = null;
      context.paintChild(child, offset);
      return;
    }
    layer = context.pushTransform(
      needsCompositing,
      offset,
      _transform,
      (context, offset) => context.paintChild(child, offset),
      oldLayer: layer is TransformLayer ? layer as TransformLayer? : null,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = this.child;
    if (child == null) return false;
    return result.addWithPaintTransform(
      transform: _transform,
      position: position,
      hitTest: (result, position) => child.hitTest(result, position: position),
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_transform);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('factor', _factor));
  }
}
