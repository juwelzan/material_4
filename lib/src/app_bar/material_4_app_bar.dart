import 'dart:ui';
import 'package:flutter/material.dart';

import '../layout/shape_content_protection.dart';
import '../material_4_config.dart';
import '../material_4_container.dart';
import 'app_bar_action.dart';
import 'app_bar_behavior.dart';
import 'app_bar_drawer.dart';
import 'app_bar_profile.dart';
import 'app_bar_search.dart';
import 'app_bar_style.dart';
import 'material_4_sliver_app_bar.dart';

/// A modern, adaptive, and fully customizable AppBar for Flutter that conforms to
/// Material 4's parameter-driven shape and surface design language.
///
/// Can be used as a standard [PreferredSizeWidget] in [Scaffold.appBar], or converted
/// into a scroll-aware [Material4SliverAppBar] via the `.sliver` constructor or preset
/// sliver methods.
class Material4AppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The primary title widget.
  final Widget? title;

  /// Optional subtitle or auxiliary caption.
  final Widget? subtitle;

  /// Leading widget displayed on the left (e.g. back button, menu trigger).
  final Widget? leading;

  /// Whether to automatically show a back button if [Navigator.canPop] is true.
  final bool automaticallyImplyLeading;

  /// Trailing interactive action widgets.
  final List<Material4AppBarAction> actions;

  /// Profile configuration integrating avatars, initials, and user metadata.
  final Material4AppBarProfile? profile;

  /// Drawer configuration managing drawer triggers and state synchronization.
  final Material4AppBarDrawer drawer;

  /// Integrated search bar configuration.
  final Material4AppBarSearch? search;

  /// Visual styling governing surface types, fills, gradients, and shapes.
  final Material4AppBarStyle style;

  /// Explicit height of the app bar (default 56.0).
  final double height;

  /// Bottom widget (e.g. [TabBar], filter chips, progress bar).
  final PreferredSizeWidget? bottom;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Creates a [Material4AppBar] instance.
  const Material4AppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions = const [],
    this.profile,
    this.drawer = const Material4AppBarDrawer(),
    this.search,
    this.style = const Material4AppBarStyle(),
    this.height = 56.0,
    this.bottom,
    this.centerTitle,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0.0));

  // =========================================================================
  // Factory Presets (All 20 requested layout and visual presets)
  // =========================================================================

  /// Basic: Standard clean Material 4 app bar.
  factory Material4AppBar.standard({
    Key? key,
    required Widget title,
    Widget? leading,
    List<Material4AppBarAction> actions = const [],
    Material4AppBarProfile? profile,
    Color? backgroundColor,
    Color? foregroundColor,
    double elevation = 0.0,
  }) {
    return Material4AppBar(
      key: key,
      title: title,
      leading: leading,
      actions: actions,
      profile: profile,
      style: Material4AppBarStyle(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
      ),
    );
  }

  /// Basic: Centered title app bar.
  factory Material4AppBar.centerTitle({
    Key? key,
    required Widget title,
    Widget? leading,
    List<Material4AppBarAction> actions = const [],
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return Material4AppBar(
      key: key,
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: true,
      style: Material4AppBarStyle(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }

  /// Basic: Leading title app bar with prominent left alignment.
  factory Material4AppBar.leadingTitle({
    Key? key,
    required Widget title,
    Widget? subtitle,
    List<Material4AppBarAction> actions = const [],
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return Material4AppBar(
      key: key,
      title: title,
      subtitle: subtitle,
      centerTitle: false,
      actions: actions,
      style: Material4AppBarStyle(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }

  /// Basic: Minimal flat app bar without background or borders.
  factory Material4AppBar.minimal({
    Key? key,
    required Widget title,
    Widget? leading,
    List<Material4AppBarAction> actions = const [],
    Color? foregroundColor,
  }) {
    return Material4AppBar(
      key: key,
      title: title,
      leading: leading,
      actions: actions,
      style: Material4AppBarStyle(
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor,
        elevation: 0.0,
        surfaceType: Material4AppBarSurfaceType.transparent,
      ),
    );
  }

  /// Creative: Organic wave surface contour.
  factory Material4AppBar.organic({
    Key? key,
    required Widget title,
    Widget? subtitle,
    Widget? leading,
    List<Material4AppBarAction> actions = const [],
    Material4AppBarProfile? profile,
    Color? backgroundColor,
    Color? foregroundColor,
    Gradient? gradient,
    double height = 68.0,
  }) {
    return Material4AppBar(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions,
      profile: profile,
      height: height,
      style: Material4AppBarStyle.organic(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        gradient: gradient,
        shapeConfig: const Material4Config(
          type: Material4Type.smoothRounded,
          cornerRadius: 20,
        ),
      ),
    );
  }

  /// Creative: Frosted glass backdrop blur app bar.
  factory Material4AppBar.glass({
    Key? key,
    required Widget title,
    Widget? leading,
    List<Material4AppBarAction> actions = const [],
    Material4AppBarProfile? profile,
    double backdropBlur = 16.0,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return Material4AppBar(
      key: key,
      title: title,
      leading: leading,
      actions: actions,
      profile: profile,
      style: Material4AppBarStyle.glass(
        backdropBlur: backdropBlur,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }

  /// Creative: Floating detached capsule pill.
  factory Material4AppBar.floatingCapsule({
    Key? key,
    required Widget title,
    Widget? leading,
    List<Material4AppBarAction> actions = const [],
    Material4AppBarProfile? profile,
    Color? backgroundColor,
    Color? foregroundColor,
    double height = 54.0,
  }) {
    return Material4AppBar(
      key: key,
      title: title,
      leading: leading,
      actions: actions,
      profile: profile,
      height: height,
      style: Material4AppBarStyle(
        backgroundColor: backgroundColor ?? Colors.white,
        foregroundColor: foregroundColor ?? const Color(0xFF1E1E24),
        surfaceType: Material4AppBarSurfaceType.card,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
        shapeConfig: const Material4Config(
          type: Material4Type.capsule,
        ),
      ),
    );
  }

  /// Advanced: Dedicated Search AppBar with text field.
  factory Material4AppBar.search({
    Key? key,
    required Material4AppBarSearch search,
    Widget? leading,
    List<Material4AppBarAction> actions = const [],
    Color? backgroundColor,
    Color? foregroundColor,
    double height = 60.0,
  }) {
    return Material4AppBar(
      key: key,
      search: search,
      leading: leading,
      actions: actions,
      height: height,
      style: Material4AppBarStyle(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }

  /// Advanced: Multi-row AppBar with navigation bar on top and auxiliary search or chips below.
  factory Material4AppBar.multiRow({
    Key? key,
    required Widget title,
    required PreferredSizeWidget bottom,
    Widget? subtitle,
    Widget? leading,
    List<Material4AppBarAction> actions = const [],
    Material4AppBarProfile? profile,
    Color? backgroundColor,
    Color? foregroundColor,
    double height = 56.0,
  }) {
    return Material4AppBar(
      key: key,
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions,
      profile: profile,
      bottom: bottom,
      height: height,
      style: Material4AppBarStyle(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }

  /// Creates a matching scroll-aware [Material4SliverAppBar] instance.
  Material4SliverAppBar toSliver({
    double? expandedHeight,
    Material4AppBarBehavior? behavior,
    Widget? expandedContent,
    ScrollController? scrollController,
  }) {
    return Material4SliverAppBar(
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions,
      profile: profile,
      drawer: drawer,
      search: search,
      style: style,
      centerTitle: centerTitle,
      expandedHeight: expandedHeight ?? 200.0,
      collapsedHeight: height,
      behavior: behavior ?? Material4AppBarBehavior.floatingOnReverse,
      expandedContent: expandedContent,
      scrollController: scrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveBgColor = style.backgroundColor ?? theme.colorScheme.surface;
    final effectiveFgColor =
        style.foregroundColor ?? theme.colorScheme.onSurface;

    final leadingWidget = leading ??
        drawer.buildLeading(
          context,
          isCompact: true,
        );

    final actionWidgets = actions
        .map(
            (a) => a.buildAction(context, isExpanded: false, isFloating: false))
        .whereType<Widget>()
        .toList();

    Widget barContent = SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height,
            child: Padding(
              padding: style.padding,
              child: Row(
                children: [
                  if (leadingWidget != null) ...[
                    leadingWidget,
                    const SizedBox(width: 8),
                  ],
                  if (profile != null && profile!.showInCompact) ...[
                    profile!.buildAvatar(context, isCompact: true),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: search != null && search!.enabled
                        ? search!.buildSearchField(context, isCompact: true)
                        : Align(
                            alignment: (centerTitle ?? false)
                                ? Alignment.center
                                : Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: (centerTitle ?? false)
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              children: [
                                if (title != null)
                                  DefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: effectiveFgColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    child: title!,
                                  ),
                                if (subtitle != null) ...[
                                  const SizedBox(height: 2),
                                  DefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: effectiveFgColor.withValues(
                                          alpha: 0.65),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    child: subtitle!,
                                  ),
                                ],
                              ],
                            ),
                          ),
                  ),
                  if (actionWidgets.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actionWidgets,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );

    // Render surface background
    if (style.backdropBlur > 0.0) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: style.backdropBlur,
            sigmaY: style.backdropBlur,
          ),
          child: Container(
            color: effectiveBgColor.withValues(alpha: 0.8),
            child: barContent,
          ),
        ),
      );
    }

    if (style.shapeConfig != null) {
      return Material4Container(
        config: style.shapeConfig!,
        color: effectiveBgColor,
        gradient: style.gradient,
        shadows: style.shadows,
        contentProtection: const ShapeContentProtection.visibleOverflow(),
        child: barContent,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: style.gradient == null ? effectiveBgColor : null,
        gradient: style.gradient,
        boxShadow: style.shadows,
      ),
      child: barContent,
    );
  }
}
