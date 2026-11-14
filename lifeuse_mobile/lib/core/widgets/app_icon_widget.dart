import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Production Reusable Icon Component for LifeUse.
/// File: lib/core/widgets/app_icon_widget.dart
///
/// Features:
/// - Clean vector icon rendering with adaptive sizing and theming
/// - Optional Figma-style active pill / tile container background (e.g. active Dashboard pill)
/// - Optional notification / counter badge overlay (e.g. badge count: "86", "2")
/// - Interactive tap feedback support
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final VoidCallback? onTap;
  final String? tooltip;

  // Figma Pill / Tile styling options
  final bool isPill;
  final Color? pillBackgroundColor;
  final Color? pillBorderColor;
  final double? pillRadius;
  final EdgeInsetsGeometry? pillPadding;

  // Counter Badge options
  final int? badgeCount;
  final Color? badgeColor;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = 20,
    this.color,
    this.onTap,
    this.tooltip,
    this.isPill = false,
    this.pillBackgroundColor,
    this.pillBorderColor,
    this.pillRadius,
    this.pillPadding,
    this.badgeCount,
    this.badgeColor,
  });

  /// Factory constructor for active sidebar navigation pill (from Figma screenshot)
  factory AppIcon.sidebarActive(
    IconData icon, {
    Key? key,
    double size = 20,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: size,
      color: AppColors.primary,
      isPill: true,
      pillBackgroundColor: AppColors.primary.withValues(alpha: 0.12),
      pillBorderColor: AppColors.primary.withValues(alpha: 0.25),
      pillRadius: 10,
      pillPadding: const EdgeInsets.all(8),
      onTap: onTap,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for alert warning icon with badge
  factory AppIcon.alertBadge(
    IconData icon, {
    Key? key,
    double size = 18,
    required int badgeCount,
    Color color = AppColors.warning,
    Color badgeColor = AppColors.error,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: size,
      color: color,
      badgeCount: badgeCount,
      badgeColor: badgeColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(
      icon,
      size: size,
      color: color ?? AppColors.textPrimaryOf(context),
    );

    if (isPill) {
      iconWidget = Container(
        padding: pillPadding ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: pillBackgroundColor ??
              AppColors.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(pillRadius ?? 10),
          border: pillBorderColor != null
              ? Border.all(color: pillBorderColor!, width: 1)
              : null,
        ),
        child: iconWidget,
      );
    }

    if (badgeCount != null && badgeCount! > 0) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -4,
            right: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Center(
                child: Text(
                  badgeCount! > 99 ? '99+' : badgeCount.toString(),
                  style: AppTypography.counterBadge(color: Colors.white)
                      .copyWith(fontSize: 9),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      iconWidget = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(pillRadius ?? 8),
        child: iconWidget,
      );
    }

    if (tooltip != null) {
      iconWidget = Tooltip(
        message: tooltip!,
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}
