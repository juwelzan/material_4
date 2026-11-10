/// Material 4 — one universal container for Flutter UI.
///
/// The whole library is a single widget, [Material4Container]. Every visual
/// capability (built-in and custom shapes, multi-layer backgrounds, patterns,
/// textures, paper surfaces, creative borders, animation and morphing,
/// interaction, liquid glass, context menus, tooltips, hover lighting) is
/// configured through its parameters. Everything exported below is a
/// configuration type for that one container.
library;

// --- The container ---
export 'src/material_4_container.dart'
    show Material4Container, Material4Clipper;

// --- Shape & geometry configuration ---
export 'src/config/config.dart';
export 'src/material_4_config.dart';
export 'src/material_4_path_builder.dart';
export 'src/shape_path_cache.dart';

// --- Container feature configs (background, border, pattern, texture,
//     animation, custom shape, presets, liquid glass, glass light) ---
export 'src/container/container.dart' hide Material4LiquidGlassSurface;

// --- Pattern / paper / border option types ---
export 'src/shape_pattern.dart';
export 'src/creative/borders/creative_border_config.dart';
export 'src/creative/paper/paper_background_config.dart';
export 'src/creative/paper/stationery_patterns.dart';
export 'src/creative/paper/repeating_patterns.dart';

// --- Animation & interaction option types ---
export 'src/animation/shape_animation_config.dart';
export 'src/animation/shape_animation_controller.dart';
export 'src/animation/shape_animation_curves.dart';
export 'src/animation/shape_animation_sequence.dart';
export 'src/rendering/material_4_interaction.dart';
export 'src/rendering/material_4_hit_test.dart';
export 'src/layout/shape_content_protection.dart';
export 'src/layout/shape_collision_detector.dart';
export 'src/material_4_stack.dart' show ShapeLayoutStrategy, ShapeChild;

// --- Liquid glass option types (used by Material4LiquidGlass) ---
export 'src/liquid_glass/liquid_glass_setup.dart';
export 'src/liquid_glass/src/engine/liquid_glass_settings.dart';
export 'src/liquid_glass/src/engine/liquid_shape.dart';
export 'src/liquid_glass/types/glass_quality.dart';
export 'src/liquid_glass/theme/glass_theme.dart';
export 'src/liquid_glass/theme/glass_theme_data.dart';
export 'src/liquid_glass/theme/glass_theme_settings.dart';
export 'src/liquid_glass/widgets/overlays/glass_context_menu.dart'
    show GlassContextMenuAction, GlassContextMenuIconPosition;
export 'src/liquid_glass/widgets/overlays/glass_menu_item.dart'
    show GlassMenuDivider, GlassMenuLabel;
export 'src/liquid_glass/types/glass_specular_sharpness.dart';
export 'src/liquid_glass/widgets/shared/glass_content_aware_scope.dart';
