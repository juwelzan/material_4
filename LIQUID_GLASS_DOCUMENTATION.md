# Material 4 — Liquid Glass Engine & API Reference

> **Specification**: Apple-Calibrated Optics • SwiftUI `glassEffect` Parity • WWDC25 "Meet Liquid Glass"  
> **Status**: Production-Ready • Hardware-Accelerated (Impeller / Shader & Fallback Tiers)  
> **Target Platforms**: iOS, iPadOS, macOS, Android, Web, Windows, Linux  
> **Primary Integration**: `Material4Container(liquidGlass: Material4LiquidGlass(...))`

---

## 1. Executive Summary & Design Philosophy

The **Material 4 Liquid Glass Engine** brings authentic Apple-grade optical glass physics to Flutter. Unlike static glassmorphism (which merely stacks a gaussian `BackdropFilter` and a white border), Liquid Glass simulates a physical dielectric fluid lens:

1. **Physical Refraction & Chromatic Lensing**: Real-time paraxial lens shader bending background pixels around the shape perimeter.
2. **Dynamic Thickness & Scale Adaptation**: Large glass panels automatically become thicker, more opaque, more deeply shadowed, and more strongly refracted than small controls.
3. **Adaptive Contrast Sampling**: Small glass elements dynamically invert their illumination and typography (light ↔ dark) according to the luminosity of content scrolling beneath them.
4. **Touch & Fluid Elasticity**: Interactive controls stretch toward dragging fingers, inflate when pressed, and illuminate with a localized subsurface light pool.
5. **Pointer Physics (macOS / iPadOS)**: Desktop mouse and trackpad pointers lift the glass out of the screen, cast dynamic ambient shadows, and steer specular highlights toward the cursor.
6. **Fluid Coalescence (`Material4GlassGroup`)**: Adjacent glass buttons smoothly merge and melt together into a single continuous liquid contour.
7. **Unified Architecture**: Directly pluggable into any `Material4Container`, automatically mapping native squircle and capsule geometries or clipping complex vector shapes with procedural specular rims.

---

## 2. Architecture & Layer Stack

Liquid Glass is rendered through an orchestrated 6-layer pipeline:

```
┌────────────────────────────────────────────────────────┐
│ 6. Content & Overlay (Text, Icons, Tooltips, Menu)     │
├────────────────────────────────────────────────────────┤
│ 5. Specular Rim, Focus Ring & Hover Spotlight          │
├────────────────────────────────────────────────────────┤
│ 4. Fluid Elastic Stretch & Touch Illumination (Glow)   │
├────────────────────────────────────────────────────────┤
│ 3. Physical Glass Shader / Adaptive Backdrop Filter    │
├────────────────────────────────────────────────────────┤
│ 2. Background Contrast Sampler (Content-Aware Scope)   │
├────────────────────────────────────────────────────────┤
│ 1. Underlying Scene (Images, Lists, Gradients, Video)  │
└────────────────────────────────────────────────────────┘
```

### 2.1 Hardware Acceleration & Platform Tiers

The engine automatically selects the highest supported fidelity without crashing or dropping frames:

| Platform / Driver | Engine Tier | Optical Features Enabled |
| :--- | :--- | :--- |
| **iOS / macOS (Impeller)** | `GlassQuality.premium` | Full fragment shader lens refraction, multi-pass chromatic aberration, real-time specular rim, fluid merging, and subsurface glow. |
| **Android (Impeller / Vulkan)** | `GlassQuality.premium` | Hardware shader refraction, interactive stretch, and dynamic lighting. |
| **Web / Windows / Linux (Skia)** | `GlassQuality.standard` | Lightweight procedural glass shader with optimized backdrop sampling and specular tracking. |
| **Low-End Devices / Headless** | `GlassQuality.minimal` | Hardware-safe `BackdropFilter` frosted glass with responsive touch glow and high-contrast borders. |

---

## 3. Quick Start

### 3.1 Basic Frosted Card

```dart
import 'package:flutter/material.dart';
import 'package:material_4/material_4.dart';

Material4Container(
  shape: Material4Type.squircle,
  width: 280,
  height: 160,
  liquidGlass: const Material4LiquidGlass(),
  padding: const EdgeInsets.all(20),
  child: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Ambient Glass', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('Adapts thickness and refraction automatically.'),
    ],
  ),
)
```

### 3.2 Interactive Capsule Button with Haptics & Tooltip

```dart
Material4Container(
  shape: Material4Type.capsule,
  width: 200,
  height: 52,
  liquidGlass: const Material4LiquidGlass.control(
    tint: Color(0xFF007AFF), // Apple iOS Blue Accent
    tooltip: 'Submit Order',
    haptics: true,
  ),
  onTap: () => print('Submitted'),
  child: const Center(
    child: Text(
      'Continue',
      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
    ),
  ),
)
```

---

## 4. API Reference: `Material4LiquidGlass`

`Material4LiquidGlass` is the immutable configuration model passed to `Material4Container.liquidGlass`.

### 4.1 Constructors

#### Default Constructor
```dart
const Material4LiquidGlass({
  Material4GlassVariant variant = Material4GlassVariant.regular,
  LiquidGlassSettings? settings,
  bool followTheme = false,
  Color? tint,
  double dimming = 0.0,
  bool adaptiveAppearance = true,
  bool adaptiveSize = true,
  bool visible = true,
  GlassQuality? quality,
  LiquidShape? glassShape,
  bool? interactive,
  double? interactionScale,
  double stretch = 0.5,
  double resistance = 0.01,
  Color? glowColor,
  double? glowRadius,
  bool specularRim = true,
  double rimWidth = 1.2,
  bool useOwnLayer = false,
  bool allowElevation = true,
  bool platformViewBackdrop = false,
  Material4GlassHoverEffect hoverEffect = Material4GlassHoverEffect.automatic,
  double? hoverScale,
  bool hoverLightTracking = true,
  MouseCursor? cursor,
  ValueChanged<bool>? onHover,
  List<Widget>? contextMenu,
  double contextMenuWidth = 250.0,
  ValueChanged<Offset>? onSecondaryTap,
  WidgetBuilder? contextMenuPreview,
  VoidCallback? onContextMenuOpened,
  VoidCallback? onContextMenuDismissed,
  double hoverMagnetism = 1.0,
  String? tooltip,
  Duration tooltipDelay = const Duration(milliseconds: 700),
  bool? focusable,
  Color? focusColor,
  FocusNode? focusNode,
  bool autofocus = false,
  bool haptics = false,
})
```

#### Named Factory Constructors

| Constructor | Usage & Apple Guideline Parity |
| :--- | :--- |
| `Material4LiquidGlass.regular(...)` | Standard Apple `glassEffect(.regular)` material. Calibrated for primary panels, navigation bars, and cards. |
| `Material4LiquidGlass.clear(...)` | High-translucency `glassEffect(.clear)` without frost or tint. Ideal over photography or video; supports `dimming` (Apple recommends ~35%). |
| `Material4LiquidGlass.identity()` | Renders content unaffected without any glass styling. Allows instant toggling of glass effects without tree restructuring. |
| `Material4LiquidGlass.panel(...)` | Non-interactive structural glass panel (sidebars, sheets, cards) with disabled touch stretch and fixed specular rim. |
| `Material4LiquidGlass.control(...)` | Interactive button or control (`.interactive()`). Pre-configured with touch stretch, pressed deflation/growth, hover lifting, and haptics. |

---

### 4.2 Comprehensive Parameter Reference

#### Visual & Optics Configuration
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `variant` | `Material4GlassVariant` | `.regular` | Glass material category: `.regular`, `.clear`, or `.identity`. |
| `tint` | `Color?` | `null` | Stained glass tint. Applies a translucent color wash without compromising refraction or legibility. |
| `dimming` | `double` | `0.0` | Black backdrop dimming level (0.0 to 1.0) placed behind `.clear` glass to preserve foreground legibility over vivid media. |
| `adaptiveAppearance` | `bool` | `true` | When inside a `GlassContentAwareScope`, automatically inverts small glass between light and dark based on underlying pixels. |
| `adaptiveSize` | `bool` | `true` | Automatically scales material thickness, blur radius, refraction index, and drop shadows as container dimensions increase ($56\text{ dp} \to 320\text{ dp}$). |
| `visible` | `bool` | `true` | Controls glass materialization. Toggling smoothly animates the refraction lens in or out rather than a flat opacity fade. |
| `quality` | `GlassQuality?` | `null` | Overrides the automatic hardware tier (`.premium`, `.standard`, `.minimal`). |
| `specularRim` | `bool` | `true` | Draws a crisp, light-catching specular rim around complex or custom-clipped shapes. |
| `rimWidth` | `double` | `1.2` | Stroke width (in logical pixels) of the specular rim. |

#### Touch & Interaction Physics
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `interactive` | `bool?` | `null` | Enables elastic touch physics. When `null`, automatically enables if the parent container has `onTap`, `onLongPress`, or `onDoubleTap`. |
| `interactionScale` | `double?` | `null` | Scale multiplier reached when pressed. Defaults to Apple native tactile deflation/growth. |
| `stretch` | `double` | `0.5` | Elastic drag distance factor. Set to `0.0` to disable drag distortion. |
| `resistance` | `double` | `0.01` | Spring drag resistance. Higher values produce a stiffer, less deformable surface. |
| `glowColor` | `Color?` | `null` | Color of the touch illumination pool under the user's finger. |
| `glowRadius` | `double?` | `null` | Radius of the touch glow relative to container size. |
| `haptics` | `bool` | `false` | When `true`, triggers a subtle tactile haptic tick (`HapticFeedback.lightImpact()`) on press. |

#### Desktop, Pointer & Hover Features
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `hoverEffect` | `Material4GlassHoverEffect` | `.automatic` | Pointer hover reaction: `.lift` (grows + parallax shadow), `.highlight` (brightens + spotlight), `.none`, or `.automatic`. |
| `hoverScale` | `double?` | `null` | Custom scale multiplier during hover lift. Defaults to Apple iPadOS control scale metrics. |
| `hoverLightTracking` | `bool` | `true` | When `true`, specular highlights and rim gradients dynamically rotate toward the cursor. |
| `hoverMagnetism` | `double` | `1.0` | Parallax drift strength (0 to 3). `1.0` matches Apple iPadOS cursor magnetism. |
| `cursor` | `MouseCursor?` | `null` | Mouse cursor on hover. Defaults to `SystemMouseCursors.click` for interactive glass. |
| `onHover` | `ValueChanged<bool>?` | `null` | Callback invoked when a pointer enters or exits the glass bounds. |

#### Context Menu & Tooltips
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `contextMenu` | `List<Widget>?` | `null` | List of actions (typically `GlassContextMenuAction` and `GlassMenuDivider`). Right-click or long-press opens an iOS 26 style glass platter. |
| `contextMenuWidth` | `double` | `250.0` | Layout width of the context menu popover platter. |
| `contextMenuPreview` | `WidgetBuilder?` | `null` | Custom preview widget lifted into the foreground while the context menu is open (SwiftUI `contextMenu(menuItems:preview:)`). |
| `tooltip` | `String?` | `null` | Native macOS/iOS style glass help capsule displayed after hovering for `tooltipDelay`. |
| `tooltipDelay` | `Duration` | `700ms` | Hover duration required before the tooltip appears. |

#### Keyboard Focus & Accessibility
| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `focusable` | `bool?` | `null` | Enables hardware keyboard focus (Tab navigation). Defaults to `true` for interactive glass. |
| `focusColor` | `Color?` | `null` | Focus ring outline color. Defaults to Apple System Blue (`Color(0xFF007AFF)`). |
| `focusNode` | `FocusNode?` | `null` | Optional explicit `FocusNode` for programmatic focus control. |
| `autofocus` | `bool` | `false` | Automatically claims keyboard focus on initial mount. |

---

## 5. Supporting Systems & Widgets

### 5.1 Shared Lighting (`Material4GlassLight`)

In iOS 26, specular highlights across all on-screen glass elements move together in unison. `Material4GlassLight` establishes a single shared illumination source for all descendant glass containers.

```dart
Material4GlassLight(
  followPointer: true, // Light sits at the mouse cursor
  strength: 1.0,
  child: Scaffold(...),
)
```

#### Driving Modes:
1. **Pointer Light (`followPointer: true`)**: The specular highlight on every glass container points directly at the user's cursor.
2. **Orbital / Animated Light (`angle: Animation<double>`)**: Creates a continuous sweeping highlight across all cards and toolbars.
3. **Hardware Gyroscope (`angleStream: Stream<double>`)**: Connects to `sensors_plus` so glass highlights tilt with physical device rotation:
   ```dart
   Material4GlassLight(
     angleStream: gyroscopeEventStream().map((e) => math.pi / 2 + e.y * 0.6),
     child: MyAppContent(),
   )
   ```

---

### 5.2 Fluid Coalescence (`Material4GlassGroup`)

When multiple liquid glass elements are placed inside a `Material4GlassGroup`, they share an underlying render layer. When moved close together, their fluid boundaries melt and fuse into one seamless shape:

```dart
Material4GlassGroup(
  spacing: 24,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Material4Container(
        shape: Material4Type.capsule,
        width: 56,
        height: 56,
        liquidGlass: const Material4LiquidGlass(),
        child: const Icon(Icons.edit),
      ),
      Material4Container(
        shape: Material4Type.capsule,
        width: 56,
        height: 56,
        liquidGlass: const Material4LiquidGlass(),
        child: const Icon(Icons.share),
      ),
    ],
  ),
)
```

> [!TIP]
> If an individual button within a `Material4GlassGroup` has a distinct `tint`, it will automatically render on its own dedicated layer (`useOwnLayer: true`) to preserve color fidelity while allowing non-tinted neighbors to coalesce.

---

### 5.3 Content-Aware Adaptivity (`GlassContentAwareScope`)

To prevent text or icons from becoming illegible as content scrolls beneath floating glass, wrap your screen in a `GlassContentAwareScope`:

```dart
GlassContentAwareScope(
  backgroundColor: Colors.black, // Fallback backdrop
  child: Stack(
    children: [
      // Content layer being sampled
      GlassContentAwareContent(
        child: ListView(children: [...]),
      ),
      // Floating glass header that adapts its luminance
      Positioned(
        top: 20,
        child: Material4Container(
          shape: Material4Type.capsule,
          width: 160,
          height: 44,
          liquidGlass: const Material4LiquidGlass(),
          child: const Center(child: Text('Adaptive Header')),
        ),
      ),
    ],
  ),
)
```

---

## 6. Accessibility & WCAG Compliance

The Liquid Glass engine adheres strictly to accessibility guidelines:

- **High Contrast (`MediaQuery.highContrast`)**: Automatically activates `_ContrastBorderPainter`, rendering a crisp, opaque border that guarantees WCAG AA/AAA contrast ratios against any background.
- **Reduce Motion (`MediaQuery.disableAnimations`)**: Automatically disables spring stretch physics, parallax drift, and interaction scaling, substituting instant, flicker-free state changes.
- **Reduce Transparency**: When the user requests reduced transparency in OS system settings, the engine increases `frostOpacity` and clamps blur radii to produce a solid, legible plate.
- **Keyboard Traversal**: Full support for Tab focus, hardware Enter / Space activation, and visual focus rings.
- **Minimum Target Size**: Enforces $48 \times 48\text{ dp}$ hit-testing bounds on all interactive glass elements.

---

## 7. Advanced Examples & Recipes

### 7.1 Media Player Controls with Clear Glass & Dimming

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    for (final icon in [Icons.skip_previous, Icons.play_arrow, Icons.skip_next])
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Material4Container(
          shape: Material4Type.capsule,
          width: 60,
          height: 60,
          liquidGlass: const Material4LiquidGlass.clear(
            dimming: 0.35, // 35% black dimming layer behind glass
            interactive: true,
          ),
          onTap: () {},
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
  ],
)
```

### 7.2 Right-Click Context Menu with Custom Preview

```dart
Material4Container(
  shape: Material4Type.squircle,
  width: 220,
  height: 120,
  liquidGlass: Material4LiquidGlass(
    tooltip: 'Right click or long press for options',
    contextMenuPreview: (context) => Container(
      width: 260,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF22D3EE)],
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Document Preview',
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
    contextMenu: [
      GlassContextMenuAction(
        icon: const Icon(Icons.copy_rounded),
        onPressed: () => print('Copied'),
        child: const Text('Copy Link'),
      ),
      GlassContextMenuAction(
        icon: const Icon(Icons.ios_share_rounded),
        onPressed: () => print('Shared'),
        child: const Text('Share File'),
      ),
      const GlassMenuDivider(),
      GlassContextMenuAction(
        icon: const Icon(Icons.delete_outline_rounded),
        isDestructive: true,
        onPressed: () => print('Deleted'),
        child: const Text('Delete'),
      ),
    ],
  ),
  child: const Center(
    child: Text('Inspect Asset', style: TextStyle(fontWeight: FontWeight.w600)),
  ),
)
```

### 7.3 Custom Vector Shape with Procedural Specular Rim

Liquid Glass natively renders standard squircle and capsule geometries. When paired with any of the 41 `Material4Type` presets or a `Material4CustomShape`, the engine automatically clips the refraction surface and renders an anti-aliased specular rim along the custom contour:

```dart
Material4Container(
  customShape: Material4CustomShape.star(
    points: 6,
    innerRadiusRatio: 0.62,
    cornerRadius: 12,
  ),
  width: 140,
  height: 140,
  liquidGlass: const Material4LiquidGlass(
    specularRim: true,
    rimWidth: 1.5,
  ),
  child: const Center(
    child: Text('Star Glass', style: TextStyle(fontWeight: FontWeight.bold)),
  ),
)
```

---

## 8. Summary Table: Native Shapes vs. Clipped Geometry

| Geometry | Shading Pipeline | Hardware Implementation |
| :--- | :--- | :--- |
| `Material4Type.squircle` | Native Analytical Shader | `LiquidRoundedSuperellipse` fragment shader with zero clipping overhead. |
| `Material4Type.capsule` | Native Analytical Shader | Analytical distance-field capsule with dynamic curvature radius. |
| `Material4Type.smoothRounded` | Native Analytical Shader | Lamé curve squircle evaluated in GPU registers. |
| **Custom Shapes** (Star, Arch, Wave, Polygon, Béziers) | Hardware Path Clip + Specular Rim | Vector path clipping backed by `_SpecularRimPainter` directional lighting. |

