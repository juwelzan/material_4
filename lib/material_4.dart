/// Material 4 — Universal Shape Container for Flutter.
///
/// A single, parameter-driven container widget that renders any shape
/// (built-in presets or fully custom developer geometry), unified multi-layer
/// backgrounds, procedural patterns and textures, and an advanced
/// shape-following animated border engine — all without hand-authoring
/// `CustomPainter` or `CustomClipper`.
library;

// --- Core configuration & geometry ---
export 'src/config/config.dart';
export 'src/material_4_config.dart';
export 'src/material_4_path_builder.dart';

// --- The universal container ---
export 'src/material_4_container.dart';
export 'src/container/container.dart';
export 'src/material_4_stack.dart';

// --- Patterns, backgrounds & borders ---
export 'src/shape_pattern.dart';
export 'src/shape_background_renderer.dart';
export 'src/shape_border_painter.dart';

// --- Animation & morphing ---
export 'src/animated_material_4.dart';
export 'src/animation/shape_animation_config.dart';
export 'src/animation/shape_animation_controller.dart';
export 'src/animation/shape_animation_curves.dart';
export 'src/animation/shape_animation_sequence.dart';
export 'src/animation/shape_morph_engine.dart';
export 'src/animation/shape_physics_simulation.dart';

// --- Rendering & layout (render widgets, render objects, interaction) ---
export 'src/rendering/material_4_render_widget.dart';
export 'src/rendering/material_4_render_object.dart';
export 'src/rendering/material_4_multi_child_render_widget.dart';
export 'src/rendering/material_4_multi_child_render_object.dart';
export 'src/rendering/material_4_interaction.dart';
export 'src/rendering/material_4_hit_test.dart';
export 'src/rendering/material_4_painter.dart';
export 'src/rendering/material_4_clip_manager.dart';
export 'src/layout/shape_content_protection.dart';
export 'src/layout/shape_collision_detector.dart';
export 'src/layout/shape_safe_region.dart';

// --- Creative border & paper surface engine (used by the container) ---
export 'src/creative/borders/creative_border_config.dart';
export 'src/creative/borders/creative_border_painter.dart';
export 'src/creative/borders/creative_border_cache.dart';
export 'src/creative/borders/torn_paper_border.dart';
export 'src/creative/paper/paper_background_config.dart';
export 'src/creative/paper/paper_texture_renderer.dart';
export 'src/creative/paper/stationery_patterns.dart';
export 'src/creative/paper/repeating_patterns.dart';

// --- Layout helpers ---
export 'src/layout/shape_anchor_placer.dart';
export 'src/rendering/material_4_parent_data.dart';

// --- Liquid Glass (ported from liquid_glass_widgets 1.16.1, MIT) ---
export 'src/liquid_glass/liquid_glass_widgets.dart';

// --- Caching ---
export 'src/shape_path_cache.dart';
