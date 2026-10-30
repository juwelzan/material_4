import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../material_4_config.dart';
import '../material_4_container.dart';
import 'app_bar_action.dart';
import 'app_bar_animation.dart';
import 'app_bar_behavior.dart';
import 'app_bar_coordinator.dart';
import 'app_bar_drawer.dart';
import 'app_bar_profile.dart';
import 'app_bar_search.dart';
import 'app_bar_style.dart';

/// Timeline interpolation coordinator for [Material4SliverAppBar].
///
/// Converts continuous scroll [collapseRatio] and [floatingProgress] into
/// synchronized, collision-free animation factors for titles, subtitles,
/// avatars, drawer buttons, search bars, and surface shadows.
@immutable
class Material4AppBarTimeline {
  /// Collapse ratio from 0.0 (fully expanded) to 1.0 (fully collapsed).
  final double collapseRatio;

  /// Floating header reveal progress from 0.0 (hidden/off-screen) to 1.0 (fully revealed).
  final double floatingProgress;

  /// Animation tuning and presets configuration.
  final Material4AppBarAnimation animation;

  /// Whether animations are disabled via accessibility / reduced motion settings.
  final bool isReducedMotion;

  /// Creates a [Material4AppBarTimeline] instance.
  const Material4AppBarTimeline({
    required this.collapseRatio,
    required this.floatingProgress,
    required this.animation,
    this.isReducedMotion = false,
  });

  /// Opacity for expanded header content (fades out smoothly between 0.0 and 0.65).
  double get expandedOpacity {
    if (isReducedMotion || !animation.fadeEnabled) {
      return collapseRatio >= 0.5 ? 0.0 : 1.0;
    }
    return (1.0 - (collapseRatio / 0.65)).clamp(0.0, 1.0);
  }

  /// Vertical slide offset for expanded header content.
  double get expandedSlideY {
    if (isReducedMotion || !animation.slideEnabled) return 0.0;
    return -collapseRatio * 24.0;
  }

  /// Subtitle opacity: fades out quickly between 0.0 and 0.38 to eliminate collisions.
  double get subtitleOpacity {
    if (isReducedMotion || !animation.fadeEnabled) {
      return collapseRatio >= 0.35 ? 0.0 : 1.0;
    }
    return (1.0 - (collapseRatio / 0.38)).clamp(0.0, 1.0);
  }

  /// Compact bar overall opacity.
  double get compactBarOpacity {
    if (floatingProgress > 0.0) {
      return floatingProgress.clamp(0.0, 1.0);
    }
    if (isReducedMotion || !animation.fadeEnabled) {
      return collapseRatio >= 0.95 ? 1.0 : 0.0;
    }
    if (collapseRatio <= 0.60) return 0.0;
    return ((collapseRatio - 0.60) / 0.40).clamp(0.0, 1.0);
  }

  /// Horizontal slide offset for the left drawer / leading widget.
  double get drawerSlideX {
    if (isReducedMotion || !animation.slideEnabled) return 0.0;
    if (floatingProgress > 0.0) {
      return (1.0 - floatingProgress) * -18.0;
    }
    return 0.0;
  }

  /// Horizontal slide offset for the compact profile avatar on reverse-scroll reveal.
  double get compactProfileSlideX {
    if (isReducedMotion || !animation.slideEnabled) return 0.0;
    if (floatingProgress > 0.0) {
      return (1.0 - floatingProgress) * 18.0;
    }
    return 0.0;
  }

  /// Scale factor for the compact profile avatar.
  double get compactProfileScale {
    if (isReducedMotion || !animation.scaleEnabled) return 1.0;
    if (floatingProgress > 0.0) {
      return 0.85 + (floatingProgress * 0.15);
    }
    return 1.0;
  }

  /// Surface elevation interpolation.
  double elevation(double base, double collapsed) {
    return lerpDouble(base, collapsed, collapseRatio) ?? base;
  }
}

/// An intelligent, scroll-aware, responsive, and adaptive Sliver AppBar for Material 4.
///
/// Supports smooth scroll-synchronized expansion and collapse, organic/sculpted
/// surfaces, integrated [Material4Avatar] scaling, drawer synchronization,
/// reverse-scroll floating compact headers with left drawer button and right profile,
/// and rich search/action subsystems.
class Material4SliverAppBar extends StatefulWidget {
  /// Expanded height of the app bar (excluding status bar safe area padding).
  final double expandedHeight;

  /// Collapsed / compact height of the app bar (excluding status bar safe area padding).
  final double collapsedHeight;

  /// Primary title widget.
  final Widget? title;

  /// Subtitle or secondary title widget.
  final Widget? subtitle;

  /// Custom widget rendered inside the expanded header body.
  final Widget? expandedContent;

  /// Profile configuration integrating avatars, initials, and user metadata.
  final Material4AppBarProfile? profile;

  /// Drawer configuration managing drawer triggers, back buttons, and fallbacks.
  final Material4AppBarDrawer drawer;

  /// Interactive action items rendered in the trailing header slot.
  final List<Material4AppBarAction> actions;

  /// Optional search bar configuration.
  final Material4AppBarSearch? search;

  /// Behavioral configuration governing collapse, reverse-scroll floating, and pinning.
  final Material4AppBarBehavior behavior;

  /// Visual styling covering background fills, frosted glass blur, and shape contours.
  final Material4AppBarStyle style;

  /// Motion and transition curves tuning configuration.
  final Material4AppBarAnimation animation;

  /// Optional external scroll controller for explicit synchronization.
  final ScrollController? scrollController;

  /// Background widget rendered behind header content (e.g. image, video, parallax).
  final Widget? background;

  /// Optional custom leading widget overriding drawer configuration.
  final Widget? leading;

  /// Whether the title should be centered in the compact header.
  final bool? centerTitle;

  /// Creates a [Material4SliverAppBar] instance.
  const Material4SliverAppBar({
    super.key,
    this.expandedHeight = 220.0,
    this.collapsedHeight = 64.0,
    this.title,
    this.subtitle,
    this.expandedContent,
    this.profile,
    this.drawer = const Material4AppBarDrawer(),
    this.actions = const [],
    this.search,
    this.behavior = Material4AppBarBehavior.floatingOnReverse,
    this.style = const Material4AppBarStyle(),
    this.animation = const Material4AppBarAnimation(),
    this.scrollController,
    this.background,
    this.leading,
    this.centerTitle,
  });

  /// Factory preset for a modern School / Management Dashboard AppBar.
  ///
  /// Renders a rich expanded header with greeting, school badge, and profile,
  /// collapsing smoothly on scroll down. On reverse scroll, a floating compact
  /// bar appears with a smooth Drawer button on the left and Profile avatar on the right.
  factory Material4SliverAppBar.dashboard({
    Key? key,
    required String title,
    String? subtitle,
    required Material4AppBarProfile profile,
    Widget? expandedContent,
    List<Material4AppBarAction> actions = const [],
    Material4AppBarSearch? search,
    Material4AppBarStyle? style,
    Material4AppBarDrawer drawer = const Material4AppBarDrawer(
      enabled: true,
      showWhenExpanded: false,
      showWhenCompact: true,
    ),
    double expandedHeight = 220.0,
    double collapsedHeight = 64.0,
    Material4AppBarBehavior behavior =
        Material4AppBarBehavior.floatingOnReverse,
    Material4AppBarAnimation animation = const Material4AppBarAnimation(),
  }) {
    return Material4SliverAppBar(
      key: key,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: (style?.foregroundColor ?? const Color(0xFF1E1E24))
                    .withValues(alpha: 0.7),
              ),
            )
          : null,
      profile: profile,
      drawer: drawer,
      actions: actions,
      search: search,
      expandedContent: expandedContent,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      behavior: behavior,
      animation: animation,
      style: style ??
          const Material4AppBarStyle(
            backgroundColor: Color(0xFFF7F5F2),
            collapsedBackgroundColor: Colors.white,
            elevation: 0.0,
            collapsedElevation: 2.0,
          ),
    );
  }

  /// Factory preset for a dedicated Profile AppBar with prominent morphing avatar.
  factory Material4SliverAppBar.profile({
    Key? key,
    required Material4AppBarProfile profile,
    Widget? title,
    Widget? subtitle,
    Widget? expandedContent,
    List<Material4AppBarAction> actions = const [],
    Material4AppBarStyle? style,
    double expandedHeight = 240.0,
    double collapsedHeight = 64.0,
    Material4AppBarBehavior behavior = Material4AppBarBehavior.pinnedAlways,
    Material4AppBarAnimation animation = const Material4AppBarAnimation(),
  }) {
    return Material4SliverAppBar(
      key: key,
      title: title ?? (profile.name != null ? Text(profile.name!) : null),
      subtitle: subtitle ??
          (profile.subtitle != null ? Text(profile.subtitle!) : null),
      profile: profile,
      actions: actions,
      expandedContent: expandedContent,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      behavior: behavior,
      animation: animation,
      style: style ?? const Material4AppBarStyle(),
    );
  }

  /// Factory preset for an Organic Wave Surface AppBar with custom contour.
  factory Material4SliverAppBar.organic({
    Key? key,
    Widget? title,
    Widget? subtitle,
    Widget? expandedContent,
    Material4AppBarProfile? profile,
    List<Material4AppBarAction> actions = const [],
    double expandedHeight = 200.0,
    double collapsedHeight = 64.0,
    Color? backgroundColor,
    Color? foregroundColor,
    Gradient? gradient,
    Material4AppBarAnimation animation = const Material4AppBarAnimation(),
  }) {
    return Material4SliverAppBar(
      key: key,
      title: title,
      subtitle: subtitle,
      profile: profile,
      actions: actions,
      expandedContent: expandedContent,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      behavior: Material4AppBarBehavior.floatingOnReverse,
      animation: animation,
      style: Material4AppBarStyle.organic(
        backgroundColor: backgroundColor ?? const Color(0xFF5E43EE),
        foregroundColor: foregroundColor ?? Colors.white,
        gradient: gradient ??
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6B58F8), Color(0xFF4C35D5)],
            ),
        shapeConfig: const Material4Config(
          type: Material4Type.smoothRounded,
          cornerRadius: 24,
        ),
      ),
    );
  }

  /// Factory preset for a Frosted Glass Blur AppBar.
  factory Material4SliverAppBar.glass({
    Key? key,
    Widget? title,
    Widget? subtitle,
    Widget? expandedContent,
    Material4AppBarProfile? profile,
    List<Material4AppBarAction> actions = const [],
    double expandedHeight = 180.0,
    double collapsedHeight = 64.0,
    double backdropBlur = 18.0,
    Color? backgroundColor,
    Color? foregroundColor,
    Material4AppBarAnimation animation = const Material4AppBarAnimation(),
  }) {
    return Material4SliverAppBar(
      key: key,
      title: title,
      subtitle: subtitle,
      profile: profile,
      actions: actions,
      expandedContent: expandedContent,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      behavior: Material4AppBarBehavior.floatingOnReverse,
      animation: animation,
      style: Material4AppBarStyle.glass(
        backdropBlur: backdropBlur,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }

  @override
  State<Material4SliverAppBar> createState() => _Material4SliverAppBarState();
}

class _Material4SliverAppBarState extends State<Material4SliverAppBar>
    with SingleTickerProviderStateMixin {
  late Material4AppBarCoordinator _coordinator;
  late AnimationController _floatingAnimController;
  late Animation<double> _floatingAnim;

  @override
  void initState() {
    super.initState();
    _coordinator = Material4AppBarCoordinator(
      behavior: widget.behavior,
      expandedHeight: widget.expandedHeight,
      collapsedHeight: widget.collapsedHeight,
    );
    _coordinator.addListener(_onCoordinatorUpdate);

    _floatingAnimController = AnimationController(
      vsync: this,
      duration: widget.animation.duration,
    );
    _floatingAnim = CurvedAnimation(
      parent: _floatingAnimController,
      curve: widget.animation.curve,
      reverseCurve: widget.animation.reverseCurve,
    );

    widget.scrollController?.addListener(_onExternalScroll);
  }

  @override
  void didUpdateWidget(covariant Material4SliverAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.behavior != widget.behavior ||
        oldWidget.expandedHeight != widget.expandedHeight ||
        oldWidget.collapsedHeight != widget.collapsedHeight) {
      _coordinator.removeListener(_onCoordinatorUpdate);
      _coordinator = Material4AppBarCoordinator(
        behavior: widget.behavior,
        expandedHeight: widget.expandedHeight,
        collapsedHeight: widget.collapsedHeight,
      );
      _coordinator.addListener(_onCoordinatorUpdate);
    }
    if (oldWidget.animation.duration != widget.animation.duration) {
      _floatingAnimController.duration = widget.animation.duration;
    }
    if (oldWidget.animation.curve != widget.animation.curve ||
        oldWidget.animation.reverseCurve != widget.animation.reverseCurve) {
      _floatingAnim = CurvedAnimation(
        parent: _floatingAnimController,
        curve: widget.animation.curve,
        reverseCurve: widget.animation.reverseCurve,
      );
    }
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_onExternalScroll);
      widget.scrollController?.addListener(_onExternalScroll);
    }
  }

  void _onExternalScroll() {
    if (widget.scrollController != null &&
        widget.scrollController!.hasClients) {
      final pos = widget.scrollController!.position;
      final delta = pos.pixels - _coordinator.currentOffset;
      _coordinator.handleScrollNotification(
        ScrollUpdateNotification(
          metrics: pos,
          context: context,
          scrollDelta: delta,
        ),
      );
    }
  }

  void _onCoordinatorUpdate() {
    final bool isReducedMotion = widget.animation.reducedMotionAware &&
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false);

    if (isReducedMotion || widget.animation.duration == Duration.zero) {
      _floatingAnimController.value =
          _coordinator.isFloatingRevealed ? 1.0 : 0.0;
      if (mounted) setState(() {});
      return;
    }

    if (_coordinator.isFloatingRevealed) {
      if (_floatingAnimController.value < 1.0) {
        _floatingAnimController.animateTo(
          1.0,
          duration: widget.animation.duration,
          curve: widget.animation.curve,
        );
      }
    } else {
      if (_floatingAnimController.value > 0.0) {
        _floatingAnimController.animateTo(
          0.0,
          duration: widget.animation.duration,
          curve: widget.animation.reverseCurve,
        );
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onExternalScroll);
    _coordinator.removeListener(_onCoordinatorUpdate);
    _coordinator.dispose();
    _floatingAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        return _coordinator.handleScrollNotification(notification);
      },
      child: AnimatedBuilder(
        animation: _floatingAnim,
        builder: (context, _) {
          return SliverPersistentHeader(
            pinned: widget.behavior.pinned,
            floating: false,
            delegate: _Material4SliverHeaderDelegate(
              expandedHeight: widget.expandedHeight,
              collapsedHeight: widget.collapsedHeight,
              title: widget.title,
              subtitle: widget.subtitle,
              expandedContent: widget.expandedContent,
              profile: widget.profile,
              drawer: widget.drawer,
              actions: widget.actions,
              search: widget.search,
              behavior: widget.behavior,
              style: widget.style,
              animation: widget.animation,
              coordinator: _coordinator,
              floatingAnimation: _floatingAnim,
              leading: widget.leading,
              centerTitle: widget.centerTitle,
            ),
          );
        },
      ),
    );
  }
}

/// Internal delegate executing pixel-perfect render passes across scroll positions.
class _Material4SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;
  final Widget? title;
  final Widget? subtitle;
  final Widget? expandedContent;
  final Material4AppBarProfile? profile;
  final Material4AppBarDrawer drawer;
  final List<Material4AppBarAction> actions;
  final Material4AppBarSearch? search;
  final Material4AppBarBehavior behavior;
  final Material4AppBarStyle style;
  final Material4AppBarAnimation animation;
  final Material4AppBarCoordinator coordinator;
  final Animation<double> floatingAnimation;
  final Widget? leading;
  final bool? centerTitle;

  _Material4SliverHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.title,
    required this.subtitle,
    required this.expandedContent,
    required this.profile,
    required this.drawer,
    required this.actions,
    required this.search,
    required this.behavior,
    required this.style,
    required this.animation,
    required this.coordinator,
    required this.floatingAnimation,
    required this.leading,
    required this.centerTitle,
  });

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => math.max(expandedHeight, collapsedHeight);

  @override
  bool shouldRebuild(covariant _Material4SliverHeaderDelegate oldDelegate) {
    return oldDelegate.expandedHeight != expandedHeight ||
        oldDelegate.collapsedHeight != collapsedHeight ||
        oldDelegate.title != title ||
        oldDelegate.subtitle != subtitle ||
        oldDelegate.profile != profile ||
        oldDelegate.drawer != drawer ||
        oldDelegate.actions != actions ||
        oldDelegate.style != style ||
        oldDelegate.behavior != behavior ||
        oldDelegate.animation != animation ||
        oldDelegate.floatingAnimation.value != floatingAnimation.value;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final topPadding = MediaQuery.of(context).padding.top;
    final isReducedMotion = animation.reducedMotionAware &&
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    final maxDistance = maxExtent - minExtent;
    final double collapseRatio =
        maxDistance > 0 ? (shrinkOffset / maxDistance).clamp(0.0, 1.0) : 1.0;

    final isFullyCollapsed = collapseRatio >= 1.0;
    final isFloating = coordinator.isFloatingRevealed && isFullyCollapsed;
    final floatingProgress = floatingAnimation.value;

    final timeline = Material4AppBarTimeline(
      collapseRatio: collapseRatio,
      floatingProgress: isFloating ? floatingProgress : 0.0,
      animation: animation,
      isReducedMotion: isReducedMotion,
    );

    final theme = Theme.of(context);
    final effectiveFgColor = isFullyCollapsed
        ? (style.collapsedForegroundColor ??
            style.foregroundColor ??
            theme.colorScheme.onSurface)
        : (style.foregroundColor ?? theme.colorScheme.onSurface);

    return AnnotatedRegion(
      value: theme.brightness == Brightness.dark
          ? (style.surfaceType == Material4AppBarSurfaceType.glass
              ? theme.appBarTheme.systemOverlayStyle ??
                  const SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark)
              : const SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.dark))
          : const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Surface & Shape Background Layer
            _buildBackgroundSurface(
              context: context,
              collapseRatio: collapseRatio,
              timeline: timeline,
              isFullyCollapsed: isFullyCollapsed,
              isFloating: isFloating,
              floatingProgress: floatingProgress,
            ),

            // 2. Expanded Header Content (Fades out smoothly during collapse)
            if (timeline.expandedOpacity > 0.005)
              Positioned(
                top: topPadding,
                left: 0,
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: timeline.expandedOpacity,
                  child: Transform.translate(
                    offset: Offset(0, timeline.expandedSlideY),
                    child: _buildExpandedBody(
                      context,
                      effectiveFgColor,
                      timeline,
                    ),
                  ),
                ),
              ),

            // 3. Compact / Floating Header Layer
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              height: collapsedHeight,
              child: _buildCompactBar(
                context: context,
                timeline: timeline,
                isFullyCollapsed: isFullyCollapsed,
                isFloating: isFloating,
                foregroundColor: effectiveFgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundSurface({
    required BuildContext context,
    required double collapseRatio,
    required Material4AppBarTimeline timeline,
    required bool isFullyCollapsed,
    required bool isFloating,
    required double floatingProgress,
  }) {
    final theme = Theme.of(context);

    // Interpolate background colors
    final baseBgColor = style.backgroundColor ?? theme.colorScheme.surface;
    final collapsedBgColor = style.collapsedBackgroundColor ??
        style.backgroundColor ??
        theme.colorScheme.surface;
    final effectiveBgColor =
        Color.lerp(baseBgColor, collapsedBgColor, collapseRatio) ?? baseBgColor;

    // Gradient resolution
    final effectiveGradient = isFullyCollapsed
        ? (style.collapsedGradient ?? style.gradient)
        : style.gradient;

    // Shadows & Elevation interpolation
    final effectiveElevation = timeline.elevation(
      style.elevation,
      style.collapsedElevation,
    );

    final shadows = isFullyCollapsed
        ? (style.collapsedShadows ??
            (effectiveElevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: effectiveElevation * 4.0,
                      offset: Offset(0, effectiveElevation),
                    )
                  ]
                : null))
        : style.shadows;

    Widget surface = Container(
      decoration: BoxDecoration(
        color: effectiveGradient == null ? effectiveBgColor : null,
        gradient: effectiveGradient,
        boxShadow: shadows,
      ),
    );

    // Organic Shape Background
    if (style.shapeConfig != null) {
      surface = Material4Container(
        config: style.shapeConfig!,
        color: effectiveGradient == null ? effectiveBgColor : null,
        gradient: effectiveGradient,
        shadows: shadows,
      );
    }

    // Frosted Glass Blur Filter (applied when configured)
    if (style.backdropBlur > 0.0) {
      surface = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: style.backdropBlur,
          sigmaY: style.backdropBlur,
        ),
        child: Container(
          color: effectiveBgColor.withValues(alpha: 0.78),
        ),
      );
    }

    return surface;
  }

  Widget _buildExpandedBody(
    BuildContext context,
    Color foregroundColor,
    Material4AppBarTimeline timeline,
  ) {
    if (expandedContent != null) {
      return Padding(
        padding: style.padding,
        child: expandedContent!,
      );
    }

    // Default rich dashboard layout for expanded state
    return Padding(
      padding: style.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (profile != null && profile!.showInExpanded) ...[
                profile!.buildAvatar(context, isCompact: false),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (profile?.name != null) ...[
                      Text(
                        profile!.name!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: foregroundColor,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                    ],
                    if (title != null)
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: profile?.name != null ? 13 : 22,
                          fontWeight: profile?.name != null
                              ? FontWeight.w600
                              : FontWeight.w800,
                          color: profile?.name != null
                              ? foregroundColor.withValues(alpha: 0.8)
                              : foregroundColor,
                          letterSpacing: -0.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: title!,
                      ),
                    if (subtitle != null &&
                        timeline.subtitleOpacity > 0.01) ...[
                      const SizedBox(height: 2),
                      Opacity(
                        opacity: timeline.subtitleOpacity,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: foregroundColor.withValues(alpha: 0.72),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          child: subtitle!,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Action buttons in expanded header
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions
                    .map((action) => action.buildAction(
                          context,
                          isExpanded: true,
                          isFloating: false,
                        ))
                    .whereType<Widget>()
                    .toList(),
              ),
            ],
          ),
          if (search != null && search!.enabled) ...[
            const SizedBox(height: 16),
            search!.buildSearchField(context, isCompact: false),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactBar({
    required BuildContext context,
    required Material4AppBarTimeline timeline,
    required bool isFullyCollapsed,
    required bool isFloating,
    required Color foregroundColor,
  }) {
    final double compactOpacity = timeline.compactBarOpacity;

    if (compactOpacity <= 0.005) {
      return const SizedBox.shrink();
    }

    // Left widget (Drawer button or leading)
    final leadingWidget = leading ??
        drawer.buildLeading(
          context,
          isCompact: true,
        );

    // Right widget (Profile avatar + Action buttons)
    final hasCompactProfile =
        profile != null && profile!.showInCompact && isFullyCollapsed;

    final actionWidgets = actions
        .map((action) => action.buildAction(
              context,
              isExpanded: false,
              isFloating: isFloating,
            ))
        .whereType<Widget>()
        .toList();

    return Opacity(
      opacity: compactOpacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            // Left slot: Drawer Button (Smooth slide in on floating reveal)
            if (leadingWidget != null)
              Transform.translate(
                offset: Offset(timeline.drawerSlideX, 0),
                child: leadingWidget,
              )
            else
              const SizedBox(width: 8),

            const SizedBox(width: 6),

            // Center slot: Title or Search
            Expanded(
              child: search != null && search!.enabled && !search!.isExpandable
                  ? search!.buildSearchField(context, isCompact: true)
                  : Align(
                      alignment: (centerTitle ?? false)
                          ? Alignment.center
                          : Alignment.centerLeft,
                      child: title != null
                          ? DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: foregroundColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: title!,
                            )
                          : const SizedBox.shrink(),
                    ),
            ),

            const SizedBox(width: 8),

            // Right slot: Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actionWidgets,
            ),

            // Right slot: Profile Avatar on reverse-scroll floating compact bar!
            if (hasCompactProfile) ...[
              const SizedBox(width: 6),
              Transform.translate(
                offset: Offset(timeline.compactProfileSlideX, 0),
                child: Transform.scale(
                  scale: timeline.compactProfileScale,
                  child: profile!.buildAvatar(context, isCompact: true),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
