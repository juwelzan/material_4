import 'package:flutter/material.dart';

import '../avatar/avatar_badge.dart';
import '../avatar/avatar_border.dart';
import '../avatar/avatar_shape.dart';
import '../avatar/avatar_status.dart';
import '../avatar/material_4_avatar.dart';

/// Profile configuration for [Material4AppBar] and [Material4SliverAppBar].
///
/// Seamlessly integrates user profile images, avatars, display names, and
/// online/badge statuses. Reuses Material 4's high-performance [Material4Avatar]
/// engine and smoothly adapts between expanded and compact header representations.
@immutable
class Material4AppBarProfile {
  /// Custom avatar widget. If provided, overrides [image], [initials], and [icon].
  final Widget? avatar;

  /// Profile image provider (e.g. [NetworkImage], [AssetImage]).
  final ImageProvider? image;

  /// User initials fallback (e.g. "MD", "JR").
  final String? initials;

  /// Fallback icon if neither [image] nor [initials] are specified.
  final IconData? icon;

  /// User display name (e.g. "Dr. Sarah Mitchell").
  final String? name;

  /// User subtitle, role, or greeting (e.g. "Senior Professor", "Welcome back!").
  final String? subtitle;

  /// Shape geometry defining the avatar silhouette.
  final Material4AvatarShape? shape;

  /// Outer border configuration for the profile avatar.
  final Material4AvatarBorder border;

  /// Diameter/size of the profile avatar in the expanded header (default 56.0).
  final double expandedSize;

  /// Diameter/size of the profile avatar in the compact/floating header (default 36.0).
  final double compactSize;

  /// Optional presence or status indicator (e.g. online, busy, offline).
  final Material4AvatarStatus? status;

  /// Optional notification or verification badge.
  final Material4AvatarBadge? badge;

  /// Background color of the avatar interior.
  final Color? backgroundColor;

  /// Foreground icon or initials color.
  final Color? foregroundColor;

  /// Callback executed when the profile avatar is tapped.
  final VoidCallback? onTap;

  /// Optional Hero tag for fluid page-to-page profile transitions.
  final String? heroTag;

  /// Whether to render the profile in the expanded header.
  final bool showInExpanded;

  /// Whether to render the profile in the compact/floating header.
  final bool showInCompact;

  /// Alignment of the profile block within the expanded header.
  final Alignment expandedAlignment;

  /// Creates a [Material4AppBarProfile] configuration.
  const Material4AppBarProfile({
    this.avatar,
    this.image,
    this.initials,
    this.icon,
    this.name,
    this.subtitle,
    this.shape,
    this.border = const Material4AvatarBorder.none(),
    this.expandedSize = 56.0,
    this.compactSize = 36.0,
    this.status,
    this.badge,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.heroTag,
    this.showInExpanded = true,
    this.showInCompact = true,
    this.expandedAlignment = Alignment.centerLeft,
  });

  /// Factory for a simple network image profile.
  factory Material4AppBarProfile.network({
    required String imageUrl,
    String? name,
    String? subtitle,
    String? initials,
    Material4AvatarShape? shape,
    double expandedSize = 56.0,
    double compactSize = 36.0,
    Material4AvatarStatus? status,
    Material4AvatarBadge? badge,
    VoidCallback? onTap,
    String? heroTag,
  }) {
    return Material4AppBarProfile(
      image: NetworkImage(imageUrl),
      name: name,
      subtitle: subtitle,
      initials: initials,
      shape: shape,
      expandedSize: expandedSize,
      compactSize: compactSize,
      status: status,
      badge: badge,
      onTap: onTap,
      heroTag: heroTag,
    );
  }

  /// Builds the concrete avatar widget for the specified layout mode.
  Widget buildAvatar(BuildContext context, {required bool isCompact}) {
    if (avatar != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: avatar!,
      );
    }

    final targetSize = isCompact ? compactSize : expandedSize;

    Widget avatarWidget = Material4Avatar(
      size: targetSize,
      image: image,
      initials: initials,
      icon: icon ?? Icons.person_rounded,
      shape: shape ?? Material4AvatarShape.squircle(smoothness: 0.8),
      border: border,
      status: status,
      badge: isCompact ? null : badge,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      onTap: onTap,
    );

    if (heroTag != null && heroTag!.isNotEmpty) {
      avatarWidget = Hero(
        tag: heroTag!,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }
}
