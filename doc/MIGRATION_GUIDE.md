# Migration Guide: dynamic_shape to Material 4

This document guides developers through upgrading existing codebases from `dynamic_shape` to **Material 4** (`material_4`).

---

## Overview

`material_4` is the unified, production-grade evolution of `dynamic_shape`. It introduces:
- A custom **RenderBox rendering pipeline** (`RenderMaterial4` and `RenderMultiChildMaterial4`) that separates paint-only updates from layout passes for consistent 60–120 FPS performance.
- Full hardware-accelerated vector path caching with memory-bounded LRU caches.
- 10 comprehensive design system showcase categories (28+ shapes, 38 creative borders, 20 physical papers, sculpted icon cards, and interactive components).
- Backward-compatibility aliases for seamless zero-downtime migration.

---

## 1. Update `pubspec.yaml`

Replace `dynamic_shape` with `material_4` in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Replace dynamic_shape:
  # dynamic_shape: ^0.x.x
  material_4: ^1.0.0
```

Run:
```bash
flutter pub get
```

---

## 2. Update Import Statements

Change your library imports across your project:

### Before:
```dart
import 'package:dynamic_shape/dynamic_shape.dart';
```

### After:
```dart
import 'package:material_4/material_4.dart';
```

---

## 3. Class and Type Renaming Map

Material 4 provides `@Deprecated` type aliases for all legacy classes in `1.0.0`, allowing existing code to compile and run immediately without immediate breaking changes. We recommend updating to the new class names:

| Legacy Class / Type (`dynamic_shape`) | New Class / Type (`material_4`) | Notes |
|:---|:---|:---|
| `DynamicShapeConfig` | `Material4Config` | Full feature configuration |
| `DynamicShapeType` | `Material4Type` | Shape geometry enum (28+ shapes) |
| `DynamicShapeContainer` | `Material4Container` | Primary RenderBox container |
| `DynamicShapeStack` | `Material4Stack` | Multi-child layered shape stack |
| `DynamicShapePathBuilder` | `Material4PathBuilder` | Low-level vector path generator |
| `AnimatedDynamicShapeContainer` | `AnimatedMaterial4Container` | Implicitly animated shape container |
| `AnimatedDynamicShape` | `AnimatedMaterial4` | Animation controller wrapper |
| `RenderDynamicShape` | `RenderMaterial4` | Custom RenderBox implementation |
| `RenderDynamicShapeMultiChild` | `RenderMultiChildMaterial4` | Multi-child RenderBox |
| `DynamicShapeClipper` | `Material4Clipper` | Custom shape clipper |
| `DynamicShapeCustomPainter` | `Material4CustomPainter` | Custom shape painter |

---

## 4. Code Examples: Before & After

### Basic Shape Container

#### Before:
```dart
DynamicShapeContainer(
  width: 200,
  height: 100,
  config: const DynamicShapeConfig(
    type: DynamicShapeType.squircle,
    cornerRadius: 20,
  ),
  color: Colors.blue,
  child: const Center(child: Text('Hello')),
)
```

#### After:
```dart
Material4Container(
  width: 200,
  height: 100,
  config: const Material4Config(
    type: Material4Type.squircle,
    cornerRadius: 20,
  ),
  color: Colors.blue,
  child: const Center(child: Text('Hello')),
)
```

### Factory Constructors

Material 4 retains and expands all 38 convenience factory constructors:

```dart
// Smooth Squircle
Material4Container.squircle(
  width: 150,
  height: 80,
  cornerRadius: 24,
  color: Colors.white,
  child: const Center(child: Text('Squircle')),
);

// Folder Tab
Material4Container.folderTab(
  width: 200,
  height: 100,
  tabWidth: 80,
  tabHeight: 20,
  child: const Padding(
    padding: EdgeInsets.all(16),
    child: Text('Folder Content'),
  ),
);

// Glassmorphism (Frosted Glass)
Material4Container.glass(
  width: 180,
  height: 90,
  blur: 15.0,
  child: const Center(child: Text('Frosted Glass')),
);
```

---

## 5. Rendering Pipeline & Invalidation Separation

If your project directly extended or interacted with `RenderDynamicShape`:
- Switch to `RenderMaterial4`.
- Paint-only mutations (`color`, `borderColor`, `shadows`, `clipBehavior`) call `markNeedsPaint()` without re-triggering layout.
- Layout-affecting mutations (`config`, `padding`, `borderWidth`, `contentProtection`, `width`, `height`) call `markNeedsLayout()`.
- Dry layout is fully supported via `computeDryLayout(constraints)`.

---

## 6. Deprecation Timeline

1. **v1.0.0**: Deprecated aliases (`DynamicShapeConfig`, `DynamicShapeContainer`, etc.) are included and fully functional.
2. **v1.1.0**: Deprecation warnings remain active with compiler hints.
3. **v2.0.0**: Legacy `DynamicShape*` aliases will be removed.

