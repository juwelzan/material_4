# Material 4

**One container. Every UI surface.**

> [!NOTE]
> This is a custom Flutter design system, not Google's official Material Design.
>
> **Upgrading from `dynamic_shape`?** See the [Migration Guide](doc/MIGRATION_GUIDE.md).

[![pub package](https://img.shields.io/badge/pub-v1.0.0-blue.svg)](https://pub.dev)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.41.0-02569B?logo=flutter)](https://flutter.dev)

Material 4 is a UI library built around a **single widget: `Material4Container`**.
There are no separate buttons, cards, sheets or bars. Shape, surface, border,
motion, interaction and liquid glass are all parameters of the one container,
so any UI element is built by configuring it.

---

## ✨ What the container can do

| Capability | Parameter(s) |
| --- | --- |
| **54 built-in shapes**: folder tab, ticket, squircle, speech bubble, shield, ribbon, blob, circle, triangle, heart, star, arrow, tag, gear, … | `shape`, `config` |
| **Custom geometry** from your own `Path` | `customShape` |
| **Backgrounds**: color, gradient, frosted glass, patterns, textures, 20 paper styles, stationery and repeating patterns | `background` |
| **40 border styles + 38 creative borders**: neon, animated gradient, moving dash, torn paper, stitch, rope, … | `border` |
| **Animation**: shape morphing, morph sequences, animated borders/textures/patterns | `containerAnimation`, `morphController`, `animation` |
| **Interaction**: tap, long-press, double-tap, shape-accurate hit testing, press/hover effects | `onTap`, `onLongPress`, `onDoubleTap`, `interaction`, `hitTestBehavior` |
| **Layout**: single child or many children with collision-free placement and content protection | `child`, `children`, `layoutStrategy`, `collisionPolicy`, `contentProtection` |
| **Badges** docked to the shape edge | `dockedBadge`, `badgeAlignment` |
| **Liquid glass**: real refraction shaders, adaptive appearance, hover lighting, tooltips, context menus, haptics, focus | `liquidGlass` |
| **Accessibility**: semantics label/hint | `semanticLabel`, `semanticHint` |

Everything else the package exports is a **configuration type** for this container.

---

## 🚀 Getting Started

```yaml
dependencies:
  material_4: ^1.0.0
```

```dart
import 'package:material_4/material_4.dart';
```

If you use liquid glass, warm up the shaders once at startup:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  runApp(const MyApp());
}
```

---

## 📖 Examples

### A card

```dart
Material4Container(
  shape: Material4Type.folderTab,
  padding: const EdgeInsets.all(20),
  background: const Material4Background.color(Colors.white),
  border: const Material4Border.solid(width: 1.5, color: Color(0xFF5E43EE)),
  child: const Text('Folder tab card'),
)
```

### A button

```dart
Material4Container(
  shape: Material4Type.capsule,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  background: const Material4Background.gradient(
    LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFEC4899)]),
  ),
  onTap: () => debugPrint('pressed'),
  semanticLabel: 'Continue',
  child: const Text('Continue', style: TextStyle(color: Colors.white)),
)
```

### Patterned / textured surface

```dart
Material4Container(
  shape: Material4Type.ticketScallop,
  height: 120,
  background: const Material4Background.texture(Material4Texture.paper()),
  border: const Material4Border.movingDash(),
  child: const Center(child: Text('Admit one')),
)
```

### Animated border and shape morph

```dart
Material4Container(
  shape: Material4Type.squircle,
  width: 120,
  height: 120,
  border: const Material4Border.animatedGradient(width: 3),
  containerAnimation: const Material4ContainerAnimation.morph(
    target: Material4Type.organicBlob,
  ),
)
```

### Liquid glass with a context menu

```dart
Material4Container(
  shape: Material4Type.smoothRounded,
  padding: const EdgeInsets.all(16),
  liquidGlass: Material4LiquidGlass(
    tooltip: 'Photo',
    contextMenu: [
      GlassContextMenuAction(
        icon: const Icon(Icons.ios_share),
        onPressed: () {},
        child: const Text('Share'),
      ),
      const GlassMenuDivider(),
      GlassContextMenuAction(
        icon: const Icon(Icons.delete),
        isDestructive: true,
        onPressed: () {},
        child: const Text('Delete'),
      ),
    ],
  ),
  child: const Icon(Icons.photo),
)
```

Nearby glass containers can blend into one another when wrapped in a
`Material4GlassGroup`, and a `Material4GlassLight` drives one shared light
direction for every glass surface below it. See the
[Liquid Glass API Reference](doc/LIQUID_GLASS_API.md) and
[Shapes documentation](SHAPES_DOCUMENTATION.md) for every option.

---

## 🧪 Testing

```bash
flutter test
```

## 📂 Example App

```bash
cd example
flutter run
```

## 📄 License

MIT. See [LICENSE](LICENSE). The liquid glass engine is adapted from
`liquid_glass_widgets` (MIT); see [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES).
