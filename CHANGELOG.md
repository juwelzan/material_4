# Changelog

All notable changes to the `material_4` package will be documented in this file.

## 1.0.0

- **Package Rename & Stabilization**:
  - Renamed package to `material_4` (formerly `dynamic_shape`).
  - Added full backward-compatibility `@Deprecated` aliases for `DynamicShapeConfig`, `DynamicShapeType`, `DynamicShapeContainer`, `DynamicShapeStack`, `DynamicShapePathBuilder`, `AnimatedDynamicShapeContainer`, `AnimatedDynamicShape`, `RenderDynamicShape`, and `RenderDynamicShapeMultiChild`.
  - Added complete [Migration Guide](doc/MIGRATION_GUIDE.md).

- **RenderBox Architecture**:
  - Full custom RenderBox pipeline (`RenderMaterial4` and `RenderMultiChildMaterial4`).
  - Strict separation of paint invalidation (`markNeedsPaint`) from layout invalidation (`markNeedsLayout`).
  - Full dry layout support via `computeDryLayout(constraints)`.
  - Intrinsic dimension calculations respecting padding and content protection.
  - Sub-pixel precise point-in-path hit testing (`ShapeHitTestBehavior.shapeContour` vs `ShapeHitTestBehavior.boundingBox`).

- **29 Parameterized Geometries**:
  - `smoothRounded` (squircle), `folderTab`, `capsule`, `arch`, `hexagonSoft`, `diamond`, `octagon`, `shield`, `ticketScallop`, `postageStamp`, `zigzagCut`, `chamferDiagonal`, `organicBlob`, `scallopedPetal`, `asymmetricCard`, `waveEdge`, `cloud`, `speechBubble`, `waveCut`, `concaveRounded`, `convexRounded`, `parallelogram`, `ribbon`, `bookmark`, `notchedBadge`, `sideTab`, `steppedCorner`, `squircle`, and `customBezier`.

- **Creative Border Engine**:
  - 38 creative border styles including realistic torn paper with drop shadows and cellulose fibers, charred burnt edge scorch, postage stamp perforations, artisanal stitching, double line strokes, and neon bloom tubes.
  - Hardware-accelerated drawing with bounded LRU border caching (`CreativeBorderCache`).

- **Physical Paper Backgrounds & Stationery**:
  - 20 authentic physical paper textures including vintage parchment, brown kraft paper, cold-press watercolor, handmade cotton, old newspaper, blueprint, sticky notes, and canvas.
  - Procedural stationery patterns: college ruled lines, red margins, dot grids, engineering quad graphs, music manuscripts, plus 21 repeating geometric patterns.
  - Bounded memory LRU texture caching (`PaperPatternCache`).

- **SculptedIconCard Component**:
  - Physically elevated/embossed/neumorphic 3D icon plate seated over a pristine, flat readable surface.
  - 13 distinct icon positions (corners, edges, center, floating badges).
  - 15 icon plate surface styles (embossed, debossed, glass, neon, metallic, clay, paper).
  - Full internationalization support with RTL auto-mirroring and Bengali typography validation.

- **MaterialDynamicCard Suite**:
  - 12 DynamicMaterial finishes (frosted glass, metallic, ceramic, brushed aluminum, leather, carbon fiber, neon, clay, obsidian, silk, wood, copper).
  - 4 CardSurfaceType finishes (flat, convex, concave, floating).
  - Expandable accordion containers and interactive selection states.

- **Performance & Cache Engine**:
  - Precomputed hash code and single-lookup LRU caching in `ShapePathCache` (64 entries).
  - Bounded LRU cache limits across all engines to protect low-RAM Android devices (500MB–1GB RAM).

- **10-Section Example Showcase Application**:
  - Complete live interactive gallery showcasing basic shapes, advanced shapes, creative borders, paper backgrounds, advanced effects, sculpted icon cards, material cards, shape morphing, interactive components, and custom configuration studio.
