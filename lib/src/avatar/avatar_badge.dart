import 'package:flutter/material.dart';

/// Available badge styles for [Material4AvatarBadge].
enum AvatarBadgeType {
  /// Numerical unread counter / notification pill.
  count,

  /// Verified checkmark emblem.
  verified,

  /// Premium membership golden star / crown.
  premium,

  /// Administrator / moderator badge.
  admin,

  /// Custom icon emblem.
  icon,

  /// Custom arbitrary widget.
  custom,
}

/// Overlay badge component for [Material4Avatar].
///
/// Supports notification counts, verification checkmarks, premium stars, admin badges, and custom icons.
@immutable
class Material4AvatarBadge {
  /// Badge category.
  final AvatarBadgeType type;

  /// Alignment anchor on the avatar (e.g. [Alignment.topRight] or [Alignment.bottomRight]).
  final Alignment alignment;

  /// Pixel offset translation for fine positioning.
  final Offset offset;

  /// Background fill color of the badge container.
  final Color backgroundColor;

  /// Foreground icon/text color.
  final Color foregroundColor;

  /// Outline border color separating badge from avatar.
  final Color borderColor;

  /// Outline stroke width.
  final double borderWidth;

  /// Numerical notification count for [AvatarBadgeType.count].
  final int count;

  /// Max count displayed before truncating with "+" (default 99).
  final int maxCount;

  /// Custom icon for [AvatarBadgeType.icon].
  final IconData? icon;

  /// Custom badge widget for [AvatarBadgeType.custom].
  final Widget? customWidget;

  /// Explicit diameter / size of the badge.
  final double? size;

  const Material4AvatarBadge({
    required this.type,
    this.alignment = Alignment.topRight,
    this.offset = Offset.zero,
    this.backgroundColor = const Color(0xFFEF4444),
    this.foregroundColor = Colors.white,
    this.borderColor = Colors.white,
    this.borderWidth = 1.5,
    this.count = 0,
    this.maxCount = 99,
    this.icon,
    this.customWidget,
    this.size,
  });

  /// Numerical unread notification badge (e.g. "3", "99+").
  const Material4AvatarBadge.count(
    int count, {
    Alignment alignment = Alignment.topRight,
    Offset offset = Offset.zero,
    Color backgroundColor = const Color(0xFFEF4444),
    Color textColor = Colors.white,
    Color borderColor = Colors.white,
    double borderWidth = 1.5,
    int maxCount = 99,
    double? size,
  }) : this(
          type: AvatarBadgeType.count,
          count: count,
          alignment: alignment,
          offset: offset,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          maxCount: maxCount,
          size: size,
        );

  /// Verified identity checkmark badge (blue verification seal).
  const Material4AvatarBadge.verified({
    Alignment alignment = Alignment.bottomRight,
    Offset offset = Offset.zero,
    Color color = const Color(0xFF2563EB),
    Color checkColor = Colors.white,
    Color borderColor = Colors.white,
    double borderWidth = 1.5,
    double size = 18.0,
  }) : this(
          type: AvatarBadgeType.verified,
          alignment: alignment,
          offset: offset,
          backgroundColor: color,
          foregroundColor: checkColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
        );

  /// Premium VIP member crown / star badge.
  const Material4AvatarBadge.premium({
    Alignment alignment = Alignment.bottomRight,
    Offset offset = Offset.zero,
    Color color = const Color(0xFFF59E0B),
    Color iconColor = Colors.white,
    Color borderColor = Colors.white,
    double borderWidth = 1.5,
    double size = 18.0,
  }) : this(
          type: AvatarBadgeType.premium,
          alignment: alignment,
          offset: offset,
          backgroundColor: color,
          foregroundColor: iconColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
        );

  /// Administrator / moderator shield badge.
  const Material4AvatarBadge.admin({
    Alignment alignment = Alignment.bottomRight,
    Offset offset = Offset.zero,
    Color color = const Color(0xFF7C3AED),
    Color iconColor = Colors.white,
    Color borderColor = Colors.white,
    double borderWidth = 1.5,
    double size = 18.0,
  }) : this(
          type: AvatarBadgeType.admin,
          alignment: alignment,
          offset: offset,
          backgroundColor: color,
          foregroundColor: iconColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
        );

  /// Custom icon emblem badge.
  const Material4AvatarBadge.icon(
    IconData icon, {
    Alignment alignment = Alignment.bottomRight,
    Offset offset = Offset.zero,
    Color backgroundColor = const Color(0xFF1E293B),
    Color iconColor = Colors.white,
    Color borderColor = Colors.white,
    double borderWidth = 1.5,
    double size = 18.0,
  }) : this(
          type: AvatarBadgeType.icon,
          icon: icon,
          alignment: alignment,
          offset: offset,
          backgroundColor: backgroundColor,
          foregroundColor: iconColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          size: size,
        );

  /// Completely custom badge widget.
  const Material4AvatarBadge.custom({
    required Widget child,
    Alignment alignment = Alignment.topRight,
    Offset offset = Offset.zero,
  }) : this(
          type: AvatarBadgeType.custom,
          customWidget: child,
          alignment: alignment,
          offset: offset,
        );

  /// Builds the badge visual widget scaled relative to [avatarSize].
  Widget buildWidget(BuildContext context, double avatarSize) {
    if (type == AvatarBadgeType.custom) {
      return customWidget ?? const SizedBox.shrink();
    }

    final double badgeSize = (size ?? (avatarSize * 0.28)).clamp(14.0, 36.0);

    Widget content;
    switch (type) {
      case AvatarBadgeType.count:
        final text = count > maxCount ? '$maxCount+' : '$count';
        content = Text(
          text,
          style: TextStyle(
            color: foregroundColor,
            fontSize: (badgeSize * 0.58).clamp(9.0, 14.0),
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        );
        break;

      case AvatarBadgeType.verified:
        content = Icon(
          Icons.check_rounded,
          size: badgeSize * 0.65,
          color: foregroundColor,
        );
        break;

      case AvatarBadgeType.premium:
        content = Icon(
          Icons.star_rounded,
          size: badgeSize * 0.70,
          color: foregroundColor,
        );
        break;

      case AvatarBadgeType.admin:
        content = Icon(
          Icons.shield_rounded,
          size: badgeSize * 0.65,
          color: foregroundColor,
        );
        break;

      case AvatarBadgeType.icon:
        content = Icon(
          icon ?? Icons.circle,
          size: badgeSize * 0.65,
          color: foregroundColor,
        );
        break;

      case AvatarBadgeType.custom:
        content = customWidget ?? const SizedBox.shrink();
        break;
    }

    final isCounter = type == AvatarBadgeType.count;
    final padding = isCounter && count > 9
        ? EdgeInsets.symmetric(horizontal: badgeSize * 0.25, vertical: 2.0)
        : EdgeInsets.zero;

    return Container(
      constraints: BoxConstraints(
        minWidth: badgeSize,
        minHeight: badgeSize,
      ),
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(badgeSize / 2),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: content,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material4AvatarBadge &&
        other.type == type &&
        other.alignment == alignment &&
        other.offset == offset &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.count == count &&
        other.maxCount == maxCount &&
        other.icon == icon &&
        other.size == size;
  }

  @override
  int get hashCode => Object.hash(
        type,
        alignment,
        offset,
        backgroundColor,
        foregroundColor,
        borderColor,
        borderWidth,
        count,
        maxCount,
        icon,
        size,
      );
}

