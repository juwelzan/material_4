import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../liquid_glass/constants/glass_defaults.dart';
import '../liquid_glass/src/engine/glass_glow.dart';
import '../liquid_glass/src/engine/liquid_glass_settings.dart';
import '../liquid_glass/src/engine/liquid_shape.dart';
import '../liquid_glass/src/engine/stretch.dart';
import '../liquid_glass/theme/glass_theme.dart';
import '../liquid_glass/theme/glass_theme_helpers.dart';
import '../liquid_glass/types/glass_quality.dart';
import '../liquid_glass/widgets/effects/glass_materialize.dart';
import '../liquid_glass/widgets/overlays/glass_context_menu.dart';
import '../liquid_glass/widgets/shared/adaptive_glass.dart';
import '../liquid_glass/widgets/shared/adaptive_liquid_glass_layer.dart';
import '../liquid_glass/widgets/shared/glass_content_aware_scope.dart';
import '../material_4_config.dart';
import 'container_glass_light.dart';
import '../material_4_path_builder.dart';

// ===========================================================================
// Variants & materials
// ===========================================================================

/// The Liquid Glass variants, mirroring SwiftUI's `Glass`.
enum Material4GlassVariant {
  /// `Glass.regular` — the default. Blurs and adjusts the luminosity of the
  /// content behind it so text and glyphs stay legible over anything, and
  /// adapts its appearance to that content. Use it for most controls and for
  /// components with a lot of text (alerts, sidebars, popovers).
  regular,

  /// `Glass.clear` — permanently more translucent and without adaptive
  /// behaviour, so rich media behind it stays prominent. Use it only over
  /// photos/video with bold, bright content on top; over bright content add a
  /// dimming layer ([Material4LiquidGlass.dimming], Apple suggests ~35 %).
  clear,

  /// `Glass.identity` — no glass at all; the content renders unaffected.
  /// Handy for toggling the effect without restructuring the tree.
  identity,
}

/// Apple-calibrated Liquid Glass materials and the adaptations Apple applies
/// to them.
/// How glass responds to a hovering pointer (mouse, trackpad, Pencil hover),
/// mirroring iPadOS / macOS pointer effects (`UIPointerEffect`).
enum Material4GlassHoverEffect {
  /// `lift` for small interactive glass, `highlight` for large interactive
  /// glass (or glass with a context menu), `none` for static panels.
  automatic,

  /// `UIPointerEffect.lift` — the glass rises toward the pointer: it grows a
  /// few points, drifts with the pointer (parallax), casts a soft shadow and
  /// a specular spotlight follows the cursor.
  lift,

  /// `UIPointerEffect.highlight` — no movement; the glass brightens, the
  /// specular light turns toward the pointer and a spotlight follows it.
  highlight,

  /// No hover response.
  none,
}

abstract final class Material4GlassMaterials {
  /// `glassEffect(.regular)`, light appearance.
  static const LiquidGlassSettings regularLight =
      LiquidGlassSettings.ios27Light;

  /// `glassEffect(.regular)`, dark appearance.
  static const LiquidGlassSettings regularDark = LiquidGlassSettings.ios27Dark;

  /// `glassEffect(.clear)`, light appearance: the regular optics (lens band,
  /// rim light) without the frost, tint or luminosity adjustment.
  static final LiquidGlassSettings clearLight =
      LiquidGlassSettings.ios27Light.copyWith(
    glassColor: const Color(0x0DFFFFFF),
    frost: 0,
    frostOpacity: 0,
    blur: 0,
    saturation: 1.15,
    rimShade: 0.5,
    bodyShade: 0,
  );

  /// `glassEffect(.clear)`, dark appearance.
  static final LiquidGlassSettings clearDark =
      LiquidGlassSettings.ios27Dark.copyWith(
    glassColor: const Color(0x0AFFFFFF),
    frost: 0,
    frostOpacity: 0,
    blur: 0,
    saturation: 1.1,
    rimShade: 0.5,
    bodyShade: 0,
  );

  /// The base material for [variant] in [brightness].
  static LiquidGlassSettings of(
    Material4GlassVariant variant,
    Brightness brightness,
  ) {
    final dark = brightness == Brightness.dark;
    return switch (variant) {
      Material4GlassVariant.clear => dark ? clearDark : clearLight,
      _ => dark ? regularDark : regularLight,
    };
  }

  /// Apple: "When glass flexes and morphs to larger sizes … its material
  /// characteristics change to simulate a thicker, more substantial material.
  /// It casts deeper, richer shadows, has more pronounced lensing and
  /// refraction effects, and a softer scattering of light", and it "appears
  /// more opaque in larger elements like sidebars".
  ///
  /// Scales from control size (≈56 pt) up to sheet/sidebar size (≈320 pt).
  static LiquidGlassSettings adaptToSize(LiquidGlassSettings s, Size size) {
    final t = ((size.shortestSide - 56) / 264).clamp(0.0, 1.0);
    if (t == 0) return s;
    return s.copyWith(
      thickness: s.thickness * (1 + 0.6 * t),
      refractiveIndex: s.refractiveIndex + 0.04 * t,
      frost: s.frost * (1 + 0.5 * t),
      frostOpacity: s.frostOpacity + (1 - s.frostOpacity) * 0.35 * t,
      shadow: [
        for (final b in s.effectiveShadow)
          BoxShadow(
            color: b.color.withValues(
              alpha: (b.color.a * (1 + 1.5 * t)).clamp(0.0, 1.0),
            ),
            blurRadius: b.blurRadius * (1 + 1.5 * t),
            spreadRadius: b.spreadRadius,
            offset: b.offset * (1 + t),
          ),
      ],
    );
  }

  /// Apple's tint: coloured glass that keeps the material's translucency
  /// rather than a solid fill. An opaque [tint] is applied at the strength of
  /// stained glass; a translucent one is used as given.
  static LiquidGlassSettings applyTint(LiquidGlassSettings s, Color tint) {
    final alpha = tint.a >= 1 ? 0.30 : tint.a;
    return s.copyWith(
      glassColor: tint.withValues(alpha: alpha),
      saturation: math.min(s.saturation, 1.6),
    );
  }
}

// ===========================================================================
// Configuration
// ===========================================================================

/// Liquid Glass for [Material4Container], following Apple's Liquid Glass
/// (SwiftUI `glassEffect`, the HIG and WWDC25 "Meet Liquid Glass").
///
/// * **Material** — [variant] `regular` / `clear` / `identity`, optional
///   [tint]. Without [settings] the material is Apple's calibrated one.
/// * **Adaptivity** — small glass flips between light and dark with the
///   content behind it (inside a `GlassContentAwareScope`), and labels/icons
///   on it flip with it; larger glass gets thicker, more opaque, deeper
///   shadowed and more strongly lensed ([adaptiveAppearance],
///   [adaptiveSize]).
/// * **Interaction** — with [interactive] (`.interactive()`), the glass
///   flexes toward the finger, inflates while pressed and lights up from
///   under the fingertip.
/// * **Pointer** — on iPad / Mac / desktop / web a hovering pointer lifts
///   the glass, turns its specular light toward the cursor and a spotlight
///   follows it ([hoverEffect]); right-click (or long-press) opens an iOS 26
///   glass context menu ([contextMenu]).
/// * **Light** — inside a [Material4GlassLight] every glass is lit by one
///   shared source (device motion, an animation, or the pointer).
/// * **Keyboard** — focusable glass lifts and shows a focus ring
///   ([focusable]); Enter / Space activate it. [tooltip] adds a help tag.
/// * **Materialize** — toggling [visible] materializes the glass in/out by
///   ramping its lensing, not by fading opacity.
/// * **Grouping** — inside a [Material4GlassGroup] (`GlassEffectContainer`)
///   nearby glass blends and merges like liquid.
/// * **Accessibility** — Reduce Motion removes the elastic stretch; Reduce
///   Transparency gives a frostier panel; Increase Contrast adds a
///   contrasting border.
///
/// Renderer per platform: premium refraction on iOS / macOS / Android
/// (Impeller); a lightweight glass shader on web, Windows and Linux; a
/// blur fallback on slow devices. Shapes: rounded rect, squircle and capsule
/// render natively (as Apple supports); other shapes are clipped glass with a
/// painted rim.
@immutable
class Material4LiquidGlass {
  /// Which Liquid Glass variant to use.
  final Material4GlassVariant variant;

  /// Full control over the material. When null the Apple-calibrated material
  /// for [variant] is used (see [Material4GlassMaterials]); start from those
  /// with `copyWith` to tweak.
  final LiquidGlassSettings? settings;

  /// Take the material from the ambient glass theme / enclosing layer instead
  /// of the Apple-calibrated one. Ignored when [settings] is set.
  final bool followTheme;

  /// `Glass.tint` — colours the glass like stained glass to suggest
  /// prominence (use sparingly: primary actions, status).
  final Color? tint;

  /// Opacity of a black dimming layer placed behind [Material4GlassVariant.clear]
  /// glass. Apple suggests about 0.35 over bright content; 0 for none.
  final double dimming;

  /// Light/dark flip with the content behind small glass, plus monochrome
  /// labels and icons that flip with it.
  final bool adaptiveAppearance;

  /// Thicker, more opaque, deeper-shadowed material on larger glass.
  final bool adaptiveSize;

  /// Whether the glass is shown. Changing it materializes the glass in or out.
  final bool visible;

  /// Rendering tier. When null premium is requested and lowered automatically
  /// where it cannot run.
  final GlassQuality? quality;

  /// Force a specific shader shape instead of the automatic mapping.
  final LiquidShape? glassShape;

  /// `.interactive()` touch response. `null` enables it exactly when the
  /// container has `onTap`, `onLongPress` or `onDoubleTap`.
  final bool? interactive;

  /// Scale reached while pressed. `null` uses the native press growth.
  final double? interactionScale;

  /// How far the surface follows a drag (0 disables the stretch).
  final double stretch;

  /// Drag resistance; higher values stretch less.
  final double resistance;

  /// Colour of the touch illumination. `null` uses the native sheen.
  final Color? glowColor;

  /// Touch illumination radius relative to the surface; `0` disables it.
  final double? glowRadius;

  /// Paint a specular rim along non-native shapes.
  final bool specularRim;

  /// Rim stroke width in logical pixels.
  final double rimWidth;

  /// Render in a dedicated layer even when inside a [Material4GlassGroup].
  final bool useOwnLayer;

  /// Whether nested glass may lift over an ancestor's blur.
  final bool allowElevation;

  /// Use the live backdrop path, needed over platform views (maps, video).
  final bool platformViewBackdrop;

  /// Pointer hover response (mouse / trackpad / Pencil hover). Touch input
  /// never triggers it.
  final Material4GlassHoverEffect hoverEffect;

  /// Scale reached by [Material4GlassHoverEffect.lift]. `null` grows the
  /// glass by a few points like iPadOS (more on small controls).
  final double? hoverScale;

  /// Whether the specular light (and rim) turns toward the hovering pointer.
  final bool hoverLightTracking;

  /// Mouse cursor over the glass. `null` uses the click cursor on
  /// interactive glass.
  final MouseCursor? cursor;

  /// Called with `true` when a pointer starts hovering, `false` when it
  /// leaves.
  final ValueChanged<bool>? onHover;

  /// Context menu actions (usually [GlassContextMenuAction] and
  /// [GlassMenuDivider]). When set, right-click and long-press lift the
  /// glass out of the page and open an iOS 26 glass menu beside it, with
  /// drag-to-select (glide) on touch.
  final List<Widget>? contextMenu;

  /// Width of the [contextMenu] platter.
  final double contextMenuWidth;

  /// Right-click / secondary tap, with the global pointer position. Ignored
  /// when [contextMenu] is set.
  final ValueChanged<Offset>? onSecondaryTap;

  /// Custom preview lifted out of the page while the [contextMenu] is open
  /// (like SwiftUI's `contextMenu(menuItems:preview:)`). `null` lifts the
  /// glass itself.
  final WidgetBuilder? contextMenuPreview;

  /// Called when the [contextMenu] opens.
  final VoidCallback? onContextMenuOpened;

  /// Called when the [contextMenu] closes.
  final VoidCallback? onContextMenuDismissed;

  /// How strongly lifted glass drifts with the pointer (parallax), 0–3.
  /// 0 keeps it still; 1 is iPadOS.
  final double hoverMagnetism;

  /// A macOS-style help tag: a small glass capsule shown after the pointer
  /// rests on the glass for [tooltipDelay]. Also exposed to screen readers.
  final String? tooltip;

  /// How long the pointer must rest before [tooltip] appears.
  final Duration tooltipDelay;

  /// Keyboard focus (Tab / arrow keys, iPadOS & tvOS style): focused glass
  /// lifts like on hover and shows a focus ring; Enter / Space activate it.
  /// `null` makes interactive glass focusable.
  final bool? focusable;

  /// Focus ring colour. `null` uses the iOS accent blue.
  final Color? focusColor;

  /// Optional focus node for [focusable] glass.
  final FocusNode? focusNode;

  /// Request focus when first built.
  final bool autofocus;

  /// A light haptic tick when interactive glass is pressed.
  final bool haptics;

  const Material4LiquidGlass({
    this.variant = Material4GlassVariant.regular,
    this.settings,
    this.followTheme = false,
    this.tint,
    this.dimming = 0.0,
    this.adaptiveAppearance = true,
    this.adaptiveSize = true,
    this.visible = true,
    this.quality,
    this.glassShape,
    this.interactive,
    this.interactionScale,
    this.stretch = 0.5,
    this.resistance = 0.01,
    this.glowColor,
    this.glowRadius,
    this.specularRim = true,
    this.rimWidth = 1.2,
    this.useOwnLayer = false,
    this.allowElevation = true,
    this.platformViewBackdrop = false,
    this.hoverEffect = Material4GlassHoverEffect.automatic,
    this.hoverScale,
    this.hoverLightTracking = true,
    this.cursor,
    this.onHover,
    this.contextMenu,
    this.contextMenuWidth = 250.0,
    this.onSecondaryTap,
    this.contextMenuPreview,
    this.onContextMenuOpened,
    this.onContextMenuDismissed,
    this.hoverMagnetism = 1.0,
    this.tooltip,
    this.tooltipDelay = const Duration(milliseconds: 700),
    this.focusable,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.haptics = false,
  });

  /// `glassEffect(.regular)`.
  const Material4LiquidGlass.regular({
    Color? tint,
    bool? interactive,
    bool visible = true,
    List<Widget>? contextMenu,
  }) : this(
          tint: tint,
          interactive: interactive,
          visible: visible,
          contextMenu: contextMenu,
        );

  /// `glassEffect(.clear)`, optionally over a dimming layer.
  const Material4LiquidGlass.clear({
    double dimming = 0.0,
    bool? interactive,
    bool visible = true,
  }) : this(
          variant: Material4GlassVariant.clear,
          dimming: dimming,
          interactive: interactive,
          visible: visible,
        );

  /// `Glass.identity` — no effect.
  const Material4LiquidGlass.identity()
      : this(variant: Material4GlassVariant.identity);

  /// A static glass panel.
  const Material4LiquidGlass.panel({
    LiquidGlassSettings? settings,
    GlassQuality? quality,
    bool specularRim = true,
  }) : this(
          settings: settings,
          quality: quality,
          specularRim: specularRim,
          interactive: false,
        );

  /// An interactive glass control (`.regular.interactive()`).
  const Material4LiquidGlass.control({
    LiquidGlassSettings? settings,
    GlassQuality? quality,
    Color? tint,
    double? interactionScale,
    double stretch = 0.5,
    Color? glowColor,
    List<Widget>? contextMenu,
    Material4GlassHoverEffect hoverEffect = Material4GlassHoverEffect.automatic,
    String? tooltip,
    bool haptics = false,
  }) : this(
          contextMenu: contextMenu,
          hoverEffect: hoverEffect,
          tooltip: tooltip,
          haptics: haptics,
          settings: settings,
          quality: quality,
          tint: tint,
          interactionScale: interactionScale,
          stretch: stretch,
          glowColor: glowColor,
          interactive: true,
        );

  /// The shader shape that reproduces [config] exactly, or null when the
  /// geometry has no native equivalent and must be clipped. The shader clamps
  /// every radius to half the shortest side, so no size is needed.
  LiquidShape? nativeShapeFor(Material4Config config) {
    if (glassShape != null) return glassShape;
    if (config.customShape != null ||
        config.notches != null ||
        config.edges != null ||
        config.corners != null ||
        config.transform != null) {
      return null;
    }
    switch (config.type) {
      case Material4Type.smoothRounded:
      case Material4Type.squircle:
      case Material4Type.continuousSquircle:
        return LiquidRoundedSuperellipse(borderRadius: config.cornerRadius);
      case Material4Type.capsule:
        return const LiquidRoundedSuperellipse(
          borderRadius: GlassDefaults.maxSafeRadius,
        );
      default:
        return null;
    }
  }

  Material4LiquidGlass copyWith({
    Material4GlassVariant? variant,
    LiquidGlassSettings? settings,
    bool? followTheme,
    Color? tint,
    double? dimming,
    bool? adaptiveAppearance,
    bool? adaptiveSize,
    bool? visible,
    GlassQuality? quality,
    LiquidShape? glassShape,
    bool? interactive,
    double? interactionScale,
    double? stretch,
    double? resistance,
    Color? glowColor,
    double? glowRadius,
    bool? specularRim,
    double? rimWidth,
    bool? useOwnLayer,
    bool? allowElevation,
    bool? platformViewBackdrop,
    Material4GlassHoverEffect? hoverEffect,
    double? hoverScale,
    bool? hoverLightTracking,
    MouseCursor? cursor,
    ValueChanged<bool>? onHover,
    List<Widget>? contextMenu,
    double? contextMenuWidth,
    ValueChanged<Offset>? onSecondaryTap,
    WidgetBuilder? contextMenuPreview,
    VoidCallback? onContextMenuOpened,
    VoidCallback? onContextMenuDismissed,
    double? hoverMagnetism,
    String? tooltip,
    Duration? tooltipDelay,
    bool? focusable,
    Color? focusColor,
    FocusNode? focusNode,
    bool? autofocus,
    bool? haptics,
  }) {
    return Material4LiquidGlass(
      variant: variant ?? this.variant,
      settings: settings ?? this.settings,
      followTheme: followTheme ?? this.followTheme,
      tint: tint ?? this.tint,
      dimming: dimming ?? this.dimming,
      adaptiveAppearance: adaptiveAppearance ?? this.adaptiveAppearance,
      adaptiveSize: adaptiveSize ?? this.adaptiveSize,
      visible: visible ?? this.visible,
      quality: quality ?? this.quality,
      glassShape: glassShape ?? this.glassShape,
      interactive: interactive ?? this.interactive,
      interactionScale: interactionScale ?? this.interactionScale,
      stretch: stretch ?? this.stretch,
      resistance: resistance ?? this.resistance,
      glowColor: glowColor ?? this.glowColor,
      glowRadius: glowRadius ?? this.glowRadius,
      specularRim: specularRim ?? this.specularRim,
      rimWidth: rimWidth ?? this.rimWidth,
      useOwnLayer: useOwnLayer ?? this.useOwnLayer,
      allowElevation: allowElevation ?? this.allowElevation,
      platformViewBackdrop: platformViewBackdrop ?? this.platformViewBackdrop,
      hoverEffect: hoverEffect ?? this.hoverEffect,
      hoverScale: hoverScale ?? this.hoverScale,
      hoverLightTracking: hoverLightTracking ?? this.hoverLightTracking,
      cursor: cursor ?? this.cursor,
      onHover: onHover ?? this.onHover,
      contextMenu: contextMenu ?? this.contextMenu,
      contextMenuWidth: contextMenuWidth ?? this.contextMenuWidth,
      onSecondaryTap: onSecondaryTap ?? this.onSecondaryTap,
      contextMenuPreview: contextMenuPreview ?? this.contextMenuPreview,
      onContextMenuOpened: onContextMenuOpened ?? this.onContextMenuOpened,
      onContextMenuDismissed:
          onContextMenuDismissed ?? this.onContextMenuDismissed,
      hoverMagnetism: hoverMagnetism ?? this.hoverMagnetism,
      tooltip: tooltip ?? this.tooltip,
      tooltipDelay: tooltipDelay ?? this.tooltipDelay,
      focusable: focusable ?? this.focusable,
      focusColor: focusColor ?? this.focusColor,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      haptics: haptics ?? this.haptics,
    );
  }

  List<Object?> get _props => [
        variant,
        settings,
        followTheme,
        tint,
        dimming,
        adaptiveAppearance,
        adaptiveSize,
        visible,
        quality,
        glassShape,
        interactive,
        interactionScale,
        stretch,
        resistance,
        glowColor,
        glowRadius,
        specularRim,
        rimWidth,
        useOwnLayer,
        allowElevation,
        platformViewBackdrop,
        hoverEffect,
        hoverScale,
        hoverLightTracking,
        cursor,
        onHover,
        contextMenu,
        contextMenuWidth,
        onSecondaryTap,
        contextMenuPreview,
        onContextMenuOpened,
        onContextMenuDismissed,
        hoverMagnetism,
        tooltip,
        tooltipDelay,
        focusable,
        focusColor,
        focusNode,
        autofocus,
        haptics,
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Material4LiquidGlass) return false;
    final a = _props, b = other._props;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_props);
}

// ===========================================================================
// Grouping — GlassEffectContainer
// ===========================================================================

/// SwiftUI's `GlassEffectContainer`: renders the glass of every
/// [Material4Container] inside it together, so shapes blend into one another
/// as they approach and merge when closer than [spacing] — the liquid
/// "melting" of iOS toolbars and button clusters (Impeller platforms; other
/// renderers draw the shapes separately).
///
/// Glass inside a group shares the group's material; a container that sets
/// its own `settings` or `tint` renders on its own layer and does not merge.
class Material4GlassGroup extends StatelessWidget {
  /// Distance at which glass shapes start to blend, like
  /// `GlassEffectContainer(spacing:)`.
  final double spacing;

  /// Variant of the shared material.
  final Material4GlassVariant variant;

  /// Explicit shared material; defaults to the Apple-calibrated one.
  final LiquidGlassSettings? settings;

  /// Rendering tier; premium (needed for blending) when null.
  final GlassQuality? quality;

  final Widget child;

  const Material4GlassGroup({
    super.key,
    required this.child,
    this.spacing = 20.0,
    this.variant = Material4GlassVariant.regular,
    this.settings,
    this.quality,
  });

  /// Whether [context] is inside a group.
  static bool isGrouped(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_Material4GlassGroupScope>() !=
      null;

  @override
  Widget build(BuildContext context) {
    final brightness = GlassTheme.brightnessOf(context);
    return _Material4GlassGroupScope(
      child: AdaptiveLiquidGlassLayer(
        settings: settings ?? Material4GlassMaterials.of(variant, brightness),
        quality: quality ?? GlassQuality.premium,
        blendAmount: spacing,
        child: child,
      ),
    );
  }
}

class _Material4GlassGroupScope extends InheritedWidget {
  const _Material4GlassGroupScope({required super.child});

  @override
  bool updateShouldNotify(_Material4GlassGroupScope oldWidget) => false;
}

// ===========================================================================
// Surface
// ===========================================================================

/// Renders [child] on a [Material4LiquidGlass] surface shaped by [config].
///
/// Composition mirrors the iOS glass controls
/// (`LiquidStretch` → `AdaptiveGlass` → `GlassGlow`).
class Material4LiquidGlassSurface extends StatefulWidget {
  final Material4LiquidGlass glass;
  final Material4Config config;
  final bool hasTapHandler;
  final Widget child;

  const Material4LiquidGlassSurface({
    super.key,
    required this.glass,
    required this.config,
    required this.child,
    this.hasTapHandler = false,
  });

  /// Below this shortest side glass counts as a "small element" that flips
  /// between light and dark with the content (tab bars, buttons); larger
  /// glass keeps its appearance, as on iOS.
  static const double smallElementExtent = 120.0;

  @override
  State<Material4LiquidGlassSurface> createState() =>
      _Material4LiquidGlassSurfaceState();
}

class _Material4LiquidGlassSurfaceState
    extends State<Material4LiquidGlassSurface> with TickerProviderStateMixin {
  // Illumination on press: up over ~150 ms, gone ~60 ms after lift-off.
  late final AnimationController _press = AnimationController(
    duration: GlassDefaults.ambientLiftDuration,
    reverseDuration: GlassDefaults.ambientLiftReverseDuration,
    vsync: this,
  );
  late final Animation<double> _pressCurve =
      CurvedAnimation(parent: _press, curve: Curves.easeOut);

  // Pointer hover: a quick, slightly springy rise and a softer settle, like
  // the iPadOS pointer lift.
  late final AnimationController _hover = AnimationController(
    duration: const Duration(milliseconds: 260),
    reverseDuration: const Duration(milliseconds: 340),
    vsync: this,
  );
  late final Animation<double> _hoverCurve = CurvedAnimation(
    parent: _hover,
    curve: const Cubic(0.2, 1.3, 0.4, 1.0),
    reverseCurve: Curves.easeInOutCubic,
  );

  /// Hovering pointer in local (untransformed) coordinates. Kept after exit
  /// so effects fade out where the pointer left.
  final ValueNotifier<Offset?> _pointer = ValueNotifier<Offset?>(null);

  Size? _size;

  @override
  void dispose() {
    _press.dispose();
    _hover.dispose();
    _pointer.dispose();
    super.dispose();
  }

  void _hoverEnter(PointerEvent e) {
    _pointer.value = e.localPosition;
    _hover.forward();
    widget.glass.onHover?.call(true);
  }

  void _hoverExit(PointerEvent e) {
    _hover.reverse();
    widget.glass.onHover?.call(false);
  }

  Material4GlassHoverEffect _resolveHover(bool interactive) {
    final effect = widget.glass.hoverEffect;
    if (effect != Material4GlassHoverEffect.automatic) return effect;
    if (!interactive && widget.glass.contextMenu == null) {
      return Material4GlassHoverEffect.none;
    }
    final small = _size == null ||
        _size!.shortestSide < Material4LiquidGlassSurface.smallElementExtent;
    return small
        ? Material4GlassHoverEffect.lift
        : Material4GlassHoverEffect.highlight;
  }

  /// iPadOS grows a lifted element by a few points, so small controls scale
  /// more than wide ones.
  double get _liftScale {
    final explicit = widget.glass.hoverScale;
    if (explicit != null) return explicit;
    final longest = _size?.longestSide ?? 64.0;
    return 1.0 + (6.0 / longest).clamp(0.015, 0.08);
  }

  /// The material's light turned toward the hovering pointer by [t].
  LiquidGlassSettings _trackLight(LiquidGlassSettings s, double t) {
    final p = _pointer.value;
    final size = _size;
    if (t <= 0 || p == null || size == null) return s;
    final d = p - size.center(Offset.zero);
    if (d.distance < 1) return s;
    final target = math.atan2(-d.dy, d.dx);
    var delta = target - s.lightAngle;
    while (delta > math.pi) {
      delta -= 2 * math.pi;
    }
    while (delta < -math.pi) {
      delta += 2 * math.pi;
    }
    return s.copyWith(lightAngle: s.lightAngle + delta * t);
  }

  void _onSize(Size size) {
    if (!mounted) return;
    // Quantised so sub-pixel jitter never rebuilds.
    int bucket(Size s) => s.shortestSide ~/ 8;
    if (_size == null || bucket(_size!) != bucket(size)) {
      setState(() => _size = size);
    } else {
      _size = size;
    }
  }

  bool get _interactive => widget.glass.interactive ?? widget.hasTapHandler;

  bool get _usesAppleMaterial =>
      widget.glass.settings == null && !widget.glass.followTheme;

  @override
  Widget build(BuildContext context) {
    final glass = widget.glass;
    if (glass.variant == Material4GlassVariant.identity) return widget.child;

    final grouped = Material4GlassGroup.isGrouped(context);
    final small = _size == null ||
        _size!.shortestSide < Material4LiquidGlassSurface.smallElementExtent;

    Widget body;
    if (glass.adaptiveAppearance &&
        glass.variant == Material4GlassVariant.regular &&
        small &&
        _usesAppleMaterial &&
        !grouped) {
      // Small regular glass follows the content behind it (when a
      // GlassContentAwareScope is present; otherwise the ambient brightness).
      body = GlassContentAwareBrightness(
        builder: (context, brightness, _) =>
            _buildGlass(context, brightness, grouped),
      );
    } else {
      body = _buildGlass(context, GlassTheme.brightnessOf(context), grouped);
    }

    Widget result = _SizeReporter(
      onSize: _onSize,
      child: GlassMaterialize(visible: glass.visible, child: body),
    );

    final menu = glass.contextMenu;
    if (menu != null && menu.isNotEmpty) {
      // Right-click / long-press: the glass lifts out of the page and an
      // iOS 26 glass menu opens beside it.
      result = GlassContextMenu(
        actions: menu,
        menuWidth: glass.contextMenuWidth,
        previewBorderRadius: widget.config.cornerRadius,
        quality: glass.quality,
        onOpened: () => _hover.value = 0,
        child: result,
      );
    } else if (glass.onSecondaryTap != null) {
      result = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapUp: (d) {
          HapticFeedback.selectionClick();
          glass.onSecondaryTap!(d.globalPosition);
        },
        child: result,
      );
    }
    return result;
  }

  Widget _buildGlass(
    BuildContext context,
    Brightness brightness,
    bool grouped,
  ) {
    final glass = widget.glass;
    final config = widget.config;
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final highContrast = MediaQuery.maybeHighContrastOf(context) ?? false;
    final interactive = _interactive;
    final isDark = brightness == Brightness.dark;
    final hover = _resolveHover(interactive);
    final hovers = hover != Material4GlassHoverEffect.none;
    final lift = hover == Material4GlassHoverEffect.lift && !reduceMotion;

    final quality = GlassThemeHelpers.resolveQuality(
      context,
      widgetQuality: glass.quality,
      fallback: GlassQuality.premium,
    );

    // Material: explicit > Apple-calibrated (adapted to size, tinted).
    // Inside a group the shared material applies unless this glass overrides.
    LiquidGlassSettings? explicit = glass.settings;
    if (explicit == null &&
        !glass.followTheme &&
        (!grouped || glass.tint != null)) {
      explicit = Material4GlassMaterials.of(glass.variant, brightness);
      if (glass.adaptiveSize &&
          glass.variant == Material4GlassVariant.regular &&
          _size != null) {
        explicit = Material4GlassMaterials.adaptToSize(explicit, _size!);
      }
    }
    if (explicit != null && glass.tint != null) {
      explicit = Material4GlassMaterials.applyTint(explicit, glass.tint!);
    }
    final settings =
        GlassThemeHelpers.resolveSettings(context, explicit: explicit);

    // Explicit materials need their own layer (a shared layer would override
    // them); grouped glass shares the group's layer so it can merge.
    final ownLayer =
        glass.useOwnLayer || explicit != null || (interactive && !grouped);
    // On the minimal tier the engine drops the blur from interactive glass
    // (a springing BackdropFilter can flicker); keep the blur, drop the
    // stretch instead so the glass never turns into a flat tint.
    final minimalTier = quality == GlassQuality.minimal;

    final native = glass.nativeShapeFor(config);
    final clipper = native == null ? _Material4PathClipper(config) : null;
    final shaderShape =
        native ?? LiquidRoundedRectangle(borderRadius: config.cornerRadius);

    // Labels and glyphs on glass are monochrome and flip with the glass:
    // dark on light glass, light on dark glass; bright on clear glass.
    final foreground = glass.variant == Material4GlassVariant.clear || isDark
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);

    Widget content = widget.child;
    if (glass.adaptiveAppearance) {
      content = DefaultTextStyle.merge(
        style: TextStyle(color: foreground),
        child: IconTheme.merge(
          data: IconThemeData(color: foreground),
          child: content,
        ),
      );
    }

    if (native == null && glass.specularRim) {
      content = CustomPaint(
        foregroundPainter: _SpecularRimPainter(
          config: config,
          lightAngle: settings.lightAngle,
          // The calibrated material lights its rim via rimLight.
          intensity: math
              .max(settings.effectiveLightIntensity, settings.rimLight * 0.6)
              .clamp(0.0, 1.0),
          width: glass.rimWidth,
        ),
        child: content,
      );
    }

    if (highContrast) {
      // Increase Contrast: a contrasting border defines the element.
      content = CustomPaint(
        foregroundPainter: _ContrastBorderPainter(
          config: config,
          color: foreground,
        ),
        child: content,
      );
    }

    final shapeClipper = clipper ?? ShapeBorderClipper(shape: shaderShape);

    if (hovers) {
      // A soft specular spotlight under the cursor, and the rim catching the
      // light nearest to it.
      content = CustomPaint(
        foregroundPainter: _HoverSpotlightPainter(
          hover: _hoverCurve,
          pointer: _pointer,
          clipper: shapeClipper,
          strength:
              (hover == Material4GlassHoverEffect.highlight ? 1.25 : 1.0) *
                  (isDark ? 0.75 : 1.0),
        ),
        child: content,
      );
    }

    if (interactive && glass.glowRadius != 0) {
      // The glass illuminates from within, starting under the fingertip.
      content = GlassGlow(
        clipper: shapeClipper,
        glowColor: glass.glowColor ??
            (isDark ? const Color(0x12FFFFFF) : const Color(0x1AFFFFFF)),
        glowRadius: glass.glowRadius ?? 1.6,
        glowBlurRadius: 16.0,
        hitTestBehavior: HitTestBehavior.translucent,
        child: content,
      );
    }

    final double headroom = ownLayer && interactive
        ? (LiquidStretch.nativePressGrowth / 2 + 8).ceilToDouble()
        : 0.0;

    final tracksLight = hovers && glass.hoverLightTracking;
    Widget surface = interactive || hovers
        ? AnimatedBuilder(
            animation: Listenable.merge([
              _pressCurve,
              _hoverCurve,
              if (tracksLight) _pointer,
            ]),
            child: content,
            builder: (context, child) {
              final h = hovers ? _hoverCurve.value.clamp(0.0, 1.0) : 0.0;
              return _glass(
                shaderShape,
                tracksLight ? _trackLight(settings, h) : settings,
                quality,
                ownLayer,
                headroom,
                // Hover brightens the glass a little; a press fully.
                math.max(_pressCurve.value, h * 0.3),
                interactive && !minimalTier,
                child!,
              );
            },
          )
        : _glass(shaderShape, settings, quality, ownLayer, headroom, 0.0, false,
            content);

    if (clipper != null) {
      surface = ClipPath(
        clipper: clipper,
        clipBehavior: Clip.antiAlias,
        child: surface,
      );
    }

    // Clear glass over bright content: a dimming layer *behind* the glass,
    // so the glass refracts the dimmed content.
    if (glass.variant == Material4GlassVariant.clear && glass.dimming > 0) {
      surface = Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: clipper ?? ShapeBorderClipper(shape: shaderShape),
              child: ColoredBox(
                color: const Color(0xFF000000)
                    .withValues(alpha: glass.dimming.clamp(0.0, 1.0)),
              ),
            ),
          ),
          surface,
        ],
      );
    }

    if (lift) {
      // Lifted glass casts a soft shadow around (never through) itself.
      surface = CustomPaint(
        painter: _LiftShadowPainter(hover: _hoverCurve, clipper: shapeClipper),
        child: surface,
      );
    }

    if (interactive) {
      surface = _interactiveSurface(
        context,
        surface,
        glass,
        reduceMotion: reduceMotion,
        minimalTier: minimalTier,
        quality: quality,
        grouped: grouped,
      );
    }

    if (lift) {
      // Rise toward the pointer and drift with it (parallax); a press
      // settles the lift back down, as on iPadOS.
      surface = AnimatedBuilder(
        animation: Listenable.merge([_hoverCurve, _pointer, _pressCurve]),
        child: surface,
        builder: (context, child) {
          final t = _hoverCurve.value;
          final size = _size;
          final p = _pointer.value;
          var dx = 0.0, dy = 0.0;
          if (size != null && p != null && !size.isEmpty) {
            final shift = (size.shortestSide * 0.06).clamp(1.5, 4.0);
            dx = ((p.dx / size.width) * 2 - 1).clamp(-1.0, 1.0) * shift * t;
            dy = ((p.dy / size.height) * 2 - 1).clamp(-1.0, 1.0) * shift * t;
          }
          final scale =
              1.0 + (_liftScale - 1.0) * t * (1.0 - 0.6 * _pressCurve.value);
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.translationValues(dx, dy, 0)
              ..multiply(Matrix4.diagonal3Values(scale, scale, 1)),
            child: child,
          );
        },
      );
    }

    if (hovers || interactive || glass.cursor != null) {
      surface = MouseRegion(
        opaque: false,
        cursor: glass.cursor ??
            (interactive ? SystemMouseCursors.click : MouseCursor.defer),
        onEnter: hovers ? _hoverEnter : null,
        onHover: hovers ? (e) => _pointer.value = e.localPosition : null,
        onExit: hovers ? _hoverExit : null,
        child: surface,
      );
    }
    return surface;
  }

  Widget _interactiveSurface(
    BuildContext context,
    Widget surface,
    Material4LiquidGlass glass, {
    required bool reduceMotion,
    required bool minimalTier,
    required GlassQuality quality,
    required bool grouped,
  }) {
    // Gel-like flex toward the finger; Reduce Motion disables the elastic
    // properties (Apple), and so does the minimal tier.
    final stretchy = !reduceMotion && !minimalTier && glass.stretch > 0;
    if (stretchy) {
      surface = LiquidStretch(
        interactionScale: glass.interactionScale ?? 1.0,
        pressGrowth: glass.interactionScale == null
            ? LiquidStretch.nativePressGrowth
            : null,
        stretch: glass.stretch,
        resistance: glass.resistance,
        hitTestBehavior: HitTestBehavior.translucent,
        anchorStretchSettings: AnchorStretchSettings.nativeTremor,
        child: surface,
      );
    }
    // A stretching premium layer must not be cached in a RepaintBoundary
    // (scaling the baked texture blurs its edges).
    final skipBoundary =
        minimalTier || (quality == GlassQuality.premium && stretchy) || grouped;
    if (!skipBoundary) surface = RepaintBoundary(child: surface);

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _press.forward(),
      onPointerUp: (_) => _press.reverse(),
      onPointerCancel: (_) => _press.reverse(),
      child: surface,
    );
  }

  Widget _glass(
    LiquidShape shape,
    LiquidGlassSettings settings,
    GlassQuality quality,
    bool ownLayer,
    double headroom,
    double glow,
    bool interactive,
    Widget child,
  ) {
    return AdaptiveGlass(
      shape: shape,
      settings: settings,
      quality: quality,
      useOwnLayer: ownLayer,
      allowElevation: widget.glass.allowElevation,
      glowIntensity: glow,
      isInteractive: interactive,
      platformViewBackdrop: widget.glass.platformViewBackdrop,
      clipExpansion: EdgeInsets.all(headroom),
      child: child,
    );
  }
}

// ===========================================================================
// Helpers
// ===========================================================================

/// Reports its laid-out size after the frame (drives size adaptation).
class _SizeReporter extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onSize;
  const _SizeReporter({required this.onSize, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSizeReporter(onSize);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSizeReporter renderObject,
  ) {
    renderObject.onSize = onSize;
  }
}

class _RenderSizeReporter extends RenderProxyBox {
  _RenderSizeReporter(this.onSize);
  ValueChanged<Size> onSize;
  Size? _reported;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _reported) {
      _reported = size;
      final s = size;
      SchedulerBinding.instance.addPostFrameCallback((_) => onSize(s));
    }
  }
}

class _Material4PathClipper extends CustomClipper<Path> {
  final Material4Config config;
  const _Material4PathClipper(this.config);

  @override
  Path getClip(Size size) => Material4PathBuilder.buildPath(size, config);

  @override
  bool shouldReclip(_Material4PathClipper oldClipper) =>
      oldClipper.config != config;
}

/// Specular rim along an arbitrary path, lit from the shader's light
/// direction `(cos a, -sin a)`: bright on the lit edge, a dimmer counter-light
/// opposite.
class _SpecularRimPainter extends CustomPainter {
  final Material4Config config;
  final double lightAngle;
  final double intensity;
  final double width;

  const _SpecularRimPainter({
    required this.config,
    required this.lightAngle,
    required this.intensity,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || width <= 0 || intensity <= 0) return;
    final path = Material4PathBuilder.buildPath(size, config);
    final dir = Alignment(math.cos(lightAngle), -math.sin(lightAngle));
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 2
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..shader = LinearGradient(
        begin: dir,
        end: -dir,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: 0.75 * intensity),
          const Color(0x00FFFFFF),
          const Color(0x00FFFFFF),
          const Color(0xFFFFFFFF).withValues(alpha: 0.35 * intensity),
        ],
        stops: const [0.0, 0.35, 0.7, 1.0],
      ).createShader(Offset.zero & size);
    canvas.save();
    canvas.clipPath(path);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SpecularRimPainter old) =>
      old.config != config ||
      old.lightAngle != lightAngle ||
      old.intensity != intensity ||
      old.width != width;
}

/// Increase Contrast border along the container's path.
class _ContrastBorderPainter extends CustomPainter {
  final Material4Config config;
  final Color color;
  const _ContrastBorderPainter({required this.config, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final path = Material4PathBuilder.buildPath(size, config);
    canvas.save();
    canvas.clipPath(path);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0 // inside half of a 1.5 pt border
        ..color = color.withValues(alpha: 0.85)
        ..isAntiAlias = true,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ContrastBorderPainter old) =>
      old.config != config || old.color != color;
}

/// Specular spotlight that follows a hovering pointer, plus the rim catching
/// the light nearest to it. Repaints from its listenables, never rebuilds.
class _HoverSpotlightPainter extends CustomPainter {
  final Animation<double> hover;
  final ValueListenable<Offset?> pointer;
  final CustomClipper<Path> clipper;
  final double strength;

  _HoverSpotlightPainter({
    required this.hover,
    required this.pointer,
    required this.clipper,
    required this.strength,
  }) : super(repaint: Listenable.merge([hover, pointer]));

  @override
  void paint(Canvas canvas, Size size) {
    final t = hover.value.clamp(0.0, 1.0);
    final p = pointer.value;
    if (t <= 0 || p == null || size.isEmpty) return;
    final path = clipper.getClip(size);
    final radius = (size.shortestSide * 1.1).clamp(36.0, 260.0);
    const white = Color(0xFFFFFFFF);
    final a = 0.16 * strength * t;

    canvas.save();
    canvas.clipPath(path);
    canvas.drawCircle(
      p,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            white.withValues(alpha: a),
            white.withValues(alpha: a * 0.35),
            white.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(Rect.fromCircle(center: p, radius: radius)),
    );
    // Rim light: a thin edge glint brightest where the pointer is closest.
    final rimRadius = radius * 1.2;
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true
        ..shader = RadialGradient(
          colors: [
            white.withValues(alpha: (0.55 * strength * t).clamp(0.0, 1.0)),
            white.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: p, radius: rimRadius)),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_HoverSpotlightPainter old) =>
      old.hover != hover ||
      old.pointer != pointer ||
      old.clipper != clipper ||
      old.strength != strength;
}

/// Soft shadow of lifted glass, painted only outside the shape so the glass
/// never refracts it.
class _LiftShadowPainter extends CustomPainter {
  final Animation<double> hover;
  final CustomClipper<Path> clipper;

  _LiftShadowPainter({required this.hover, required this.clipper})
      : super(repaint: hover);

  @override
  void paint(Canvas canvas, Size size) {
    final t = hover.value.clamp(0.0, 1.0);
    if (t <= 0 || size.isEmpty) return;
    final path = clipper.getClip(size);
    final blur = 6.0 + 10.0 * t;
    final outside = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect((Offset.zero & size).inflate(blur * 4))
      ..addPath(path, Offset.zero);
    canvas.save();
    canvas.clipPath(outside);
    canvas.drawPath(
      path.shift(Offset(0, 6.0 * t)),
      Paint()
        ..color = const Color(0xFF000000).withValues(alpha: 0.18 * t)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LiftShadowPainter old) =>
      old.hover != hover || old.clipper != clipper;
}
