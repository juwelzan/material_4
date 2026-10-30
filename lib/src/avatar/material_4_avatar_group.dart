import 'package:flutter/material.dart';

import 'avatar_border.dart';
import 'avatar_shape.dart';
import 'material_4_avatar.dart';

/// Stacking order for overlapping avatars in [Material4AvatarGroup].
enum AvatarStackOrder {
  /// The first avatar is at the bottom, and subsequent avatars overlap on top.
  lastOnTop,

  /// The first avatar is on top, and subsequent avatars render underneath.
  firstOnTop,
}

/// A responsive, overlapping group avatar component.
///
/// Easily displays a sequence of users or contributors with configurable [maxVisible] limits,
/// negative overlap [spacing], directional stacking, and a customizable overflow indicator.
class Material4AvatarGroup extends StatelessWidget {
  /// List of individual avatar widgets to render.
  final List<Material4Avatar> avatars;

  /// Maximum number of avatars displayed before collapsing remaining items into an overflow badge.
  final int maxVisible;

  /// Diameter of avatars if not explicitly sized (default 44.0).
  final double size;

  /// Overlap spacing in logical pixels. Negative values create a tight overlapping sequence (default -12.0).
  final double spacing;

  /// Layout orientation: horizontal row or vertical column.
  final Axis direction;

  /// Visual stacking order of overlapping items.
  final AvatarStackOrder stackOrder;

  /// Default separating border applied to overlapping avatars if they don't define their own.
  final Material4AvatarBorder defaultBorder;

  /// Default shape applied if individual avatars do not specify a custom shape.
  final Material4AvatarShape? defaultShape;

  /// Custom builder for the overflow badge (e.g. "+5").
  final Widget Function(BuildContext context, int remainingCount)?
      overflowBuilder;

  /// Callback triggered when the overflow badge is tapped.
  final VoidCallback? onOverflowTap;

  const Material4AvatarGroup({
    super.key,
    required this.avatars,
    this.maxVisible = 4,
    this.size = 44.0,
    this.spacing = -12.0,
    this.direction = Axis.horizontal,
    this.stackOrder = AvatarStackOrder.lastOnTop,
    this.defaultBorder = const Material4AvatarBorder.solid(
      color: Colors.white,
      width: 2.0,
    ),
    this.defaultShape,
    this.overflowBuilder,
    this.onOverflowTap,
  });

  /// Generator constructor for lazily building avatars from data models.
  factory Material4AvatarGroup.builder({
    Key? key,
    required int itemCount,
    required Material4Avatar Function(BuildContext context, int index)
        avatarBuilder,
    int maxVisible = 4,
    double size = 44.0,
    double spacing = -12.0,
    Axis direction = Axis.horizontal,
    AvatarStackOrder stackOrder = AvatarStackOrder.lastOnTop,
    Material4AvatarBorder defaultBorder = const Material4AvatarBorder.solid(
      color: Colors.white,
      width: 2.0,
    ),
    Material4AvatarShape? defaultShape,
    Widget Function(BuildContext context, int remainingCount)? overflowBuilder,
    VoidCallback? onOverflowTap,
  }) {
    final effectiveCount =
        itemCount > maxVisible ? (maxVisible + 1) : itemCount;
    return Material4AvatarGroup(
      key: key,
      avatars: List.generate(
        effectiveCount,
        (index) => avatarBuilder(null as dynamic, index),
      ),
      maxVisible: maxVisible,
      size: size,
      spacing: spacing,
      direction: direction,
      stackOrder: stackOrder,
      defaultBorder: defaultBorder,
      defaultShape: defaultShape,
      overflowBuilder: overflowBuilder,
      onOverflowTap: onOverflowTap,
    );
  }

  Widget _buildOverflowBadge(BuildContext context, int remainingCount) {
    if (overflowBuilder != null) {
      return overflowBuilder!(context, remainingCount);
    }

    return Material4Avatar.initials(
      initials: '+$remainingCount',
      size: size,
      shape: defaultShape ?? Material4AvatarShape.circle(),
      border: defaultBorder,
      backgroundColor: const Color(0xFF334155), // Slate-700
      textColor: Colors.white,
      textStyle: TextStyle(
        fontSize: size * 0.34,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      onTap: onOverflowTap,
      semanticLabel: '$remainingCount more members',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (avatars.isEmpty) return const SizedBox.shrink();

    final visibleCount =
        avatars.length > maxVisible ? maxVisible : avatars.length;
    final remainingCount = avatars.length - visibleCount;
    final showOverflow = remainingCount > 0;

    final children = <Widget>[];

    for (int i = 0; i < visibleCount; i++) {
      final avatar = avatars[i];
      // Apply default border and size if needed
      final configuredAvatar = Material4Avatar(
        key: avatar.key,
        size: avatar.size == 56.0 ? size : avatar.size,
        image: avatar.image,
        initials: avatar.initials,
        icon: avatar.icon,
        shape: defaultShape != null && avatar.shape.id == 'circle'
            ? defaultShape!
            : avatar.shape,
        border: avatar.border.style == AvatarBorderStyle.none
            ? defaultBorder
            : avatar.border,
        status: avatar.status,
        badge: avatar.badge,
        backgroundColor: avatar.backgroundColor,
        foregroundColor: avatar.foregroundColor,
        fit: avatar.fit,
        onTap: avatar.onTap,
        onLongPress: avatar.onLongPress,
        semanticLabel: avatar.semanticLabel,
        child: avatar.child,
      );

      children.add(configuredAvatar);
    }

    if (showOverflow) {
      children.add(_buildOverflowBadge(context, remainingCount));
    }

    // Reorder children based on stackOrder
    final orderedWidgets = List<Widget>.from(children);
    if (stackOrder == AvatarStackOrder.firstOnTop) {
      // Reverse children so first child paints last (on top) in Flutter Stack
      // But in a Row/Column with negative margins, we can use a custom indexed Stack layout!
    }

    // Calculate dimensions for Stack-based overlap layout
    final itemExtent = size;
    final step = itemExtent + spacing;

    if (direction == Axis.horizontal) {
      final totalWidth = itemExtent + (orderedWidgets.length - 1) * step;
      return SizedBox(
        width: totalWidth,
        height: itemExtent + (defaultBorder.width * 2),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: List.generate(orderedWidgets.length, (index) {
            final effectiveIndex = stackOrder == AvatarStackOrder.firstOnTop
                ? (orderedWidgets.length - 1 - index)
                : index;

            return Positioned(
              left: effectiveIndex * step,
              child: orderedWidgets[effectiveIndex],
            );
          }),
        ),
      );
    } else {
      final totalHeight = itemExtent + (orderedWidgets.length - 1) * step;
      return SizedBox(
        width: itemExtent + (defaultBorder.width * 2),
        height: totalHeight,
        child: Stack(
          alignment: Alignment.topCenter,
          children: List.generate(orderedWidgets.length, (index) {
            final effectiveIndex = stackOrder == AvatarStackOrder.firstOnTop
                ? (orderedWidgets.length - 1 - index)
                : index;

            return Positioned(
              top: effectiveIndex * step,
              child: orderedWidgets[effectiveIndex],
            );
          }),
        ),
      );
    }
  }
}
