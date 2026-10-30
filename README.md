# dynamic_shape

[![pub package](https://img.shields.io/badge/pub-v1.0.0-blue.svg)](https://pub.dev)
[![license](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10.0-02569B?logo=flutter)](https://flutter.dev)

A next-generation, high-performance universal dynamic shape and contour engine for Flutter. Eliminate tedious `CustomPainter` and `CustomClipper` authoring with 28+ hardware-accelerated shapes, 20 advanced borders, physics-driven animations, procedural backgrounds, tactile haptics, and geometry-aware collision-free layouts.

---

## ✨ Features

- **28+ Parameter-Driven Geometries**: Full catalog of mathematically smooth vector paths including folder tabs, ticket scallops, postage stamps, asymmetric cards, hexagonal seals, and custom Bézier contours.
- **38 Creative Borders**: Realistic torn paper with cellulose fibers and drop shadow, deckled edges, perforated coupons, charred burnt boundaries, stamps, stitches, neon tubes, art deco, ropes, chains, and double/triple lines.
- **20 Physical Paper Backgrounds**: Authentic tactile materials including vintage parchment, brown kraft paper, cold-press watercolor, handmade cotton, old newspaper, blueprint, sticky notes, and canvas.
- **Notebook & Repeating Patterns**: College ruled lines, red margins, dot grids, engineering quad graphs, music manuscripts, penmanship guidelines, plus 21 repeating geometric patterns.
- **SculptedIconCard Component**: Signature card with a physically elevated/embossed/neumorphic 3D icon plate seated over a pristine, flat, readable text surface. Supports 13 positions, 15 surface styles, and Bengali/RTL text.
- **17 Reusable Card Presets**: `TornPaperCard`, `NotebookCard`, `StickyNoteCard`, `VintagePaperCard`, `CouponCard`, `TicketCard`, `EmbossedCard`, `DebossedCard`, `NeumorphicCard`, `ClayCard`, `GlassIconCard`, etc.
- **Adaptive Insets & Smart Layout**: Shape-aware padding ensures text, icons, and buttons are never clipped or overlapped. Includes RTL automatic mirroring and WCAG touch target validation (min 48×48 dp).
- **Physics & Motion Engine**: Spring rebounds, hover magnets, swipe-to-morph interactions, holographic shimmer sweeps, and accessibility reduced-motion compliance.
- **Ready-to-Use Widget Suite**: High-level components including `AnimatedShapeCard`, `ShapeProgress`, `ShapeAppBar`, `ShapeNavigationBar`, `ShapeBottomSheet`, `ShapeDialog`, and `ShapeTooltip`.
- **Interactive Developer Studio**: Built-in `ShapePlayground` and dedicated `CreativeShowcaseScreen` gallery.
- **Zero Jitter & Low-End Optimized**: Hardware-accelerated with bounded LRU path caching designed to run at 60–120 FPS even on low-RAM devices (500MB–1GB RAM).

---

## 🚀 Getting Started

Add `dynamic_shape` to your `pubspec.yaml`:

```yaml
dependencies:
  dynamic_shape: ^1.0.0
```

Or run:

```bash
flutter pub add dynamic_shape
```

Then import the package in your Dart code:

```dart
import 'package:dynamic_shape/dynamic_shape.dart';
```

---

## 📖 Quick Examples

### 1. Simple Dynamic Shape Container

```dart
DynamicShapeContainer.folderTab(
  tabWidth: 90,
  tabHeight: 22,
  cornerRadius: 18,
  color: Colors.white,
  borderColor: const Color(0xFF5E43EE),
  borderWidth: 1.5,
  shadows: [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ],
  child: const Padding(
    padding: EdgeInsets.all(20),
    child: Text('Folder Tab Card Content'),
  ),
)
```

### 2. Convenience Border Styles

```dart
// Neon pulse border
DynamicShapeContainer.neon(
  width: 140,
  height: 60,
  borderColor: Colors.cyanAccent,
  child: const Center(child: Text('Neon Glow')),
);

// Metallic Gold finish
DynamicShapeContainer.metallic(
  width: 160,
  height: 60,
  metallicType: MetallicType.gold,
  child: const Center(child: Text('Gold VIP Pass')),
);
```

### 3. Sculpted Icon Card (Signature Feature)

A physically elevated 3D sculpted icon plate over a flat, legible text surface with full RTL & Bengali language support:

```dart
SculptedIconCard.embossed(
  icon: Icons.school_rounded,
  title: 'Academic Portal',
  subtitle: 'Grade 11 Honors Physics',
  description: 'Access lecture recordings, problem sets, and syllabus guidelines.',
  badge: 'Active Term',
  iconPosition: SculptedIconPosition.topLeft,
  onTap: () => print('Card tapped!'),
)
```

### 4. Realistic Torn Paper Card

Procedural ripped paper edges with stochastic microscopic cellulose fibers and depth shadow:

```dart
TornPaperCard(
  tearIntensity: 0.7,
  edges: BorderEdges.all,
  child: const Text('Ripped paper document content'),
)
```

### 5. Notebook Ruling & Margins

Authentic college-ruled notebook paper with a vertical red margin rule:

```dart
NotebookCard(
  child: const Padding(
    padding: EdgeInsets.only(left: 48, top: 12),
    child: Text('Lecture notes with clean margin separation'),
  ),
)
```

### 6. Collision-Free Adaptive Shape Card

`AdaptiveShapeCard` automatically calculates safe inner margins so text and icons are never clipped by notches, tabs, or scallops:

```dart
AdaptiveShapeCard(
  title: 'Physics & Astronomy',
  subtitle: 'Room 304 • Prof. Sarah Connor',
  icon: Icons.auto_awesome,
  shapeType: DynamicShapeType.ticketScallop,
  color: const Color(0xFFF6F4FF),
  borderColor: const Color(0xFF5E43EE),
  borderWidth: 1.5,
  enableScaleAnimation: true,
  onTap: () => print('Card tapped!'),
)
```

### 7. Production-Ready School Presets

```dart
SchoolShapePresets.attendanceCard(
  title: 'Physics Grade 11',
  status: 'Active',
  time: '09:00 AM',
)
```

### 8. Interactive Dev Studio Playground

Embed the playground in your debug build or storybook:

```dart
const Scaffold(
  body: ShapePlayground(),
)
```

---

## 🎨 Geometry Matrix (28 Shapes + Custom Bézier)

| Shape Type | Mathematics & Appearance | Common Use Cases |
| :--- | :--- | :--- |
| `folderTab` | Raised tab with fillet arcs | Academic records, subject cards, file tabs |
| `notchedBadge` | Cavity carved along edges | Countdown cards, timetable progress docking |
| `sideTab` | Lateral protrusion on side | Notice board alerts, pull-out drawers |
| `steppedCorner` | Corner step cut with fillets | Quick actions, register buttons |
| `ticketScallop` | Circular bites on opposite sides | Exam vouchers, admission tickets, coupons |
| `postageStamp` | Perforated sinusoidal arcs | Merit credentials, digital certificates |
| `zigzagCut` | Triangular sawtooth series | Receipts, invoice stubs, pass slips |
| `arch` | Cathedral semicircular dome | Spotlight cards, ranking boards |
| `hexagonSoft` | 6-vertex polygon with rounded vertices | Achievement seals, mastery tokens |
| `chamferDiagonal` | 45-degree corner chamfer with fillets | Urgent bulletins, examination schedules |
| `organicBlob` | Multi-quadrant Bézier fluid pebble | Creative arts cards, kindergarten items |
| `scallopedPetal` | Rosette with 10–12 smooth petal arcs | Profile avatars, graduation laurels |
| `smoothRounded` | Lamé curve super-ellipse squircle | Neutral modern cards, clean base panels |
| `asymmetricCard`| 4 independent corner radii | Modern asymmetrical stat cards |
| `capsule` | Full semicircular pill caps | Status pills, timetable slots, chips |
| `waveEdge` | Sinusoidal fluid wave crest | Bottom navigation bars, hero headers |
| `cloud` | Multi-lobed puffy organic contour | Thought bubbles, playful alerts |
| `speechBubble` | Directed pointer tail | Tooltips, mentor feedback, chat |
| `shield` | Tapered bottom heraldic crest | Security badges, varsity shields |
| `diamond` | Rhombus with rounded vertices | Rare milestones, gems |
| `octagon` | Symmetrical 8-sided polygon | High-priority notices, badges |
| `waveCut` | Lateral fluid crest on right/left | Dynamic media cards, progress tracks |
| `concaveRounded`| Inward circular cut corners | Architectural cards, technical badges |
| `convexRounded` | Protruding outward pill arches | Elevated status buttons |
| `squircle` | True continuous G2 curvature | iOS-style modern icons and tiles |
| `parallelogram`| 14-degree slanted parallelogram | Sports scorecards, fast-action cards |
| `ribbon` | Folded end banner ribbon | Winner ribbons, announcement banners |
| `bookmark` | Inverted triangular hanging notch | Saved bookmarks, reading lists |
| `customBezier` | User-defined custom path callback | Brand logos, irregular vectors |

---

## 🧪 Testing

The package includes a comprehensive test suite covering geometry, borders, backgrounds, caching, animations, dev tools, and presets:

```bash
flutter test
```

---

## 📂 Example App

A full demonstration app is provided in the [`example`](example) directory:

```bash
cd example
flutter run
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
