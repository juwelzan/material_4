import 'package:flutter/material.dart';

import '../../dynamic_shape_config.dart';
import '../../dynamic_shape_container.dart';
import 'card_interaction_config.dart';
import 'material_dynamic_card.dart';

// =============================================================================
// 1. ProfileCard
// =============================================================================

/// Sculpted profile card with avatar plate, status chip, role metadata, and actions.
class ProfileCard extends StatelessWidget {
  final Widget? avatar;
  final String name;
  final String? role;
  final String? status;
  final bool isOnline;
  final List<Widget>? stats;
  final Widget? action;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.name,
    this.avatar,
    this.role,
    this.status,
    this.isOnline = false,
    this.stats,
    this.action,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x14000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x12000000),
          offset: Offset(0, 6),
          blurRadius: 18,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64.0,
                height: 64.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF1F5F9),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: avatar ??
                    Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
              ),
              if (isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          if (role != null) ...[
            const SizedBox(height: 4.0),
            Text(
              role!,
              style: const TextStyle(
                fontSize: 13.0,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (status != null) ...[
            const SizedBox(height: 8.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                status!,
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                ),
              ),
            ),
          ],
          if (stats != null && stats!.isNotEmpty) ...[
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stats!,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: 16.0),
            action!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 2. FeatureCard
// =============================================================================

/// Feature showcase card with prominent tactile icon plate, headline, and learn-more trigger.
class FeatureCard extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String description;
  final String? badge;
  final Widget? action;
  final VoidCallback? onLearnMore;
  final Color backgroundColor;
  final Color? iconColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.badge,
    this.action,
    this.onLearnMore,
    this.backgroundColor = Colors.white,
    this.iconColor,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialDynamicCard(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      icon: icon,
      iconColor: iconColor,
      iconPosition: CardIconPosition.top,
      iconSurface: CardSurfaceType.raised,
      title: title,
      description: description,
      badge: badge,
      action: action ??
          (onLearnMore != null
              ? TextButton(
                  onPressed: onLearnMore,
                  child: const Text('Learn More →'),
                )
              : null),
      onTap: onLearnMore,
    );
  }
}

// =============================================================================
// 3. ActionCard
// =============================================================================

/// High-tactility call-to-action button or interactive prompt container.
class ActionCard extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String? subtitle;
  final String actionLabel;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color actionColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const ActionCard({
    super.key,
    required this.title,
    required this.actionLabel,
    this.icon,
    this.subtitle,
    this.onPressed,
    this.backgroundColor = const Color(0xFFF8FAFC),
    this.actionColor = const Color(0xFF4F46E5),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialDynamicCard(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      icon: icon,
      iconPosition: CardIconPosition.leading,
      iconSurface: CardSurfaceType.raised,
      title: title,
      subtitle: subtitle,
      action: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: actionColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(actionLabel),
      ),
      onTap: onPressed,
    );
  }
}

// =============================================================================
// 4. StatisticsCard
// =============================================================================

/// Metric tile displaying numeric value, percentage delta, and descriptive label.
class StatisticsCard extends StatelessWidget {
  final String value;
  final String label;
  final String? delta;
  final bool isPositiveDelta;
  final dynamic icon;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const StatisticsCard({
    super.key,
    required this.value,
    required this.label,
    this.delta,
    this.isPositiveDelta = true,
    this.icon,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x12000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 4),
          blurRadius: 12,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null)
                icon is IconData
                    ? Icon(icon as IconData,
                        size: 20.0, color: const Color(0xFF94A3B8))
                    : (icon as Widget),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: Color(0xFF0F172A),
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: 8.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositiveDelta ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14.0,
                  color: isPositiveDelta
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 4.0),
                Text(
                  delta!,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: isPositiveDelta
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 5. NotificationCard
// =============================================================================

/// Status notification card with alert level accent ribbon and dismiss affordance.
class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String? timestamp;
  final dynamic icon;
  final Color accentColor;
  final VoidCallback? onDismiss;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    this.timestamp,
    this.icon,
    this.accentColor = const Color(0xFF3B82F6),
    this.onDismiss,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: Colors.white,
      borderColor: const Color(0x14000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x12000000),
          offset: Offset(0, 4),
          blurRadius: 12,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 14.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(width: 12.0),
          if (icon != null) ...[
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: icon is IconData
                  ? Icon(icon as IconData, size: 18.0, color: accentColor)
                  : (icon as Widget),
            ),
            const SizedBox(width: 12.0),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    if (timestamp != null)
                      Text(
                        timestamp!,
                        style: const TextStyle(
                          fontSize: 11.0,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFF475569),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close, size: 16.0),
              color: const Color(0xFF94A3B8),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 6. InformationCard
// =============================================================================

/// Information card with icon badge, structured bullet points, and note footer.
class InformationCard extends StatelessWidget {
  final String title;
  final List<String> bulletPoints;
  final String? footerNote;
  final dynamic icon;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const InformationCard({
    super.key,
    required this.title,
    required this.bulletPoints,
    this.footerNote,
    this.icon,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x14000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                icon is IconData
                    ? Icon(icon as IconData,
                        size: 22.0, color: const Color(0xFF4F46E5))
                    : (icon as Widget),
                const SizedBox(width: 10.0),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          ...bulletPoints.map((point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                            fontSize: 13.0, color: Color(0xFF334155)),
                      ),
                    ),
                  ],
                ),
              )),
          if (footerNote != null) ...[
            const Divider(height: 20.0),
            Text(
              footerNote!,
              style: const TextStyle(fontSize: 11.0, color: Color(0xFF94A3B8)),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// 7. MenuCard
// =============================================================================

/// List menu container with sculpted item separators and chevron affordances.
class MenuCard extends StatelessWidget {
  final List<Widget> items;
  final String? title;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const MenuCard({
    super.key,
    required this.items,
    this.title,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x14000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 18.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 6.0),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Divider(height: 12.0),
          ],
          ...items,
        ],
      ),
    );
  }
}

// =============================================================================
// 8. CategoryCard
// =============================================================================

/// Topic container with decorative shape geometry and tactile icon dock.
class CategoryCard extends StatelessWidget {
  final String title;
  final dynamic icon;
  final int? itemCount;
  final Color accentColor;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    this.itemCount,
    this.accentColor = const Color(0xFF6366F1),
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x12000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x10000000),
          offset: Offset(0, 4),
          blurRadius: 12,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 18.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: Alignment.center,
            child: icon is IconData
                ? Icon(icon as IconData, size: 22.0, color: accentColor)
                : (icon as Widget),
          ),
          const SizedBox(height: 14.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          if (itemCount != null) ...[
            const SizedBox(height: 4.0),
            Text(
              '$itemCount items',
              style: const TextStyle(
                fontSize: 12.0,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 9. ProductCard
// =============================================================================

/// E-commerce product card with floating image display, price tag, and buy action.
class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final Widget? image;
  final double? rating;
  final VoidCallback? onBuy;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    this.image,
    this.rating,
    this.onBuy,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x14000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x12000000),
          offset: Offset(0, 6),
          blurRadius: 16,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 18.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null) ...[
            Center(child: image!),
            const SizedBox(height: 12.0),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (rating != null) ...[
            const SizedBox(height: 4.0),
            Row(
              children: [
                const Icon(Icons.star, size: 14.0, color: Color(0xFFF59E0B)),
                const SizedBox(width: 4.0),
                Text(
                  rating!.toStringAsFixed(1),
                  style: const TextStyle(
                      fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              if (onBuy != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 8.0),
                  ),
                  onPressed: onBuy,
                  child: const Text('Buy'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 10. DashboardCard
// =============================================================================

/// Compact KPI tile with secondary metric and status indicator dot.
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Color statusColor;
  final Widget? trendWidget;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.statusColor = const Color(0xFF10B981),
    this.trendWidget,
    this.backgroundColor = Colors.white,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = DynamicShapeContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: backgroundColor,
      borderColor: const Color(0x14000000),
      borderWidth: 1.0,
      shadows: const [
        BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      config: const DynamicShapeConfig(
        type: DynamicShapeType.smoothRounded,
        cornerRadius: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          if (subtitle != null || trendWidget != null) ...[
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                        fontSize: 12.0, color: Color(0xFF94A3B8)),
                  ),
                if (trendWidget != null) trendWidget!,
              ],
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// =============================================================================
// 11. ExpandableCard
// =============================================================================

/// Smooth accordion expansion card with header toggle and animated body disclosure.
class ExpandableCard extends StatefulWidget {
  final dynamic title;
  final dynamic subtitle;
  final dynamic icon;
  final Widget expandedChild;
  final bool initialExpanded;
  final ValueChanged<bool>? onExpandedChanged;
  final Color backgroundColor;
  final double? width;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const ExpandableCard({
    super.key,
    required this.title,
    required this.expandedChild,
    this.subtitle,
    this.icon,
    this.initialExpanded = false,
    this.onExpandedChanged,
    this.backgroundColor = Colors.white,
    this.width,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initialExpanded;
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    widget.onExpandedChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialDynamicCard(
      width: widget.width,
      padding: widget.padding,
      margin: widget.margin,
      backgroundColor: widget.backgroundColor,
      icon: widget.icon,
      iconPosition: CardIconPosition.leading,
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: Icon(
        _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: const Color(0xFF64748B),
      ),
      expanded: _expanded,
      expandableChild: widget.expandedChild,
      onTap: _toggle,
    );
  }
}

// =============================================================================
// 12. SelectableCard
// =============================================================================

/// Tactile selectable radio/checkbox container with prominent selection badge dock.
class SelectableCard extends StatelessWidget {
  final dynamic title;
  final dynamic subtitle;
  final dynamic icon;
  final Widget? child;
  final bool selected;
  final ValueChanged<bool>? onSelectedChanged;
  final Color backgroundColor;
  final Color selectedColor;
  final Color selectedBorderColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const SelectableCard({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.child,
    this.selected = false,
    this.onSelectedChanged,
    this.backgroundColor = Colors.white,
    this.selectedColor = const Color(0xFFEEF2FF),
    this.selectedBorderColor = const Color(0xFF4F46E5),
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialDynamicCard(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      icon: icon,
      title: title,
      subtitle: subtitle,
      selected: selected,
      trailing: Container(
        width: 22.0,
        height: 22.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? selectedBorderColor : Colors.transparent,
          border: Border.all(
            color: selected ? selectedBorderColor : const Color(0xFFCBD5E1),
            width: 2.0,
          ),
        ),
        alignment: Alignment.center,
        child: selected
            ? const Icon(Icons.check, size: 14.0, color: Colors.white)
            : null,
      ),
      interaction: CardInteractionConfig(
        selectedColor: selectedColor,
        selectedBorderColor: selectedBorderColor,
      ),
      onTap: onSelectedChanged != null
          ? () => onSelectedChanged!(!selected)
          : null,
      child: child,
    );
  }
}
