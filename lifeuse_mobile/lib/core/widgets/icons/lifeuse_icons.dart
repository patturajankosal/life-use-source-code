import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_colors.dart';
import 'lifeuse_icon.dart';

export '../../theme/app_icons.dart';
export 'lifeuse_icon.dart';

// =============================================================================
// 1. MODULE ICON (AIRIX Squircle Card Component)
// =============================================================================

/// AIRIX-inspired dedicated Module Squircle Icon.
/// Renders an ergonomic 44×44dp or custom-sized rounded squircle with:
/// - 1.2px subtle colored stroke
/// - Tonal pastel accent background
/// - Adaptive light/dark elevation
/// - Optional category or status badge
/// - Smooth haptic touch feedback
class ModuleIcon extends StatefulWidget {
  final IconData icon;
  final IconData? activeIcon;
  final Color accentColor;
  final double size;
  final double containerSize;
  final double radius;
  final bool isSelected;
  final String? badgeText;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const ModuleIcon({
    super.key,
    required this.icon,
    this.activeIcon,
    this.accentColor = AppColors.primary,
    this.size = 26,
    this.containerSize = 50,
    this.radius = 16,
    this.isSelected = false,
    this.badgeText,
    this.onTap,
    this.semanticLabel,
  });

  @override
  State<ModuleIcon> createState() => _ModuleIconState();
}

class _ModuleIconState extends State<ModuleIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final effectiveColor = (widget.accentColor == AppColors.primary ||
            widget.accentColor == const Color(0xFF7F35AD))
        ? AppColors.brandIconOf(context)
        : (isDark ? Colors.white : widget.accentColor);

    final bgTint = AppColors.iconBackgroundOf(context);
    final borderTint = AppColors.iconBorderOf(context);

    final iconData = (widget.isSelected && widget.activeIcon != null)
        ? widget.activeIcon!
        : widget.icon;

    Widget core = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: widget.containerSize,
      height: widget.containerSize,
      decoration: BoxDecoration(
        color: bgTint,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: borderTint, width: 1.2),
        boxShadow: widget.isSelected
            ? [
                BoxShadow(
                  color:
                      AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.20),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          iconData,
          size: widget.size,
          color: effectiveColor,
          shadows: [
            Shadow(
              color: effectiveColor.withValues(alpha: 0.35),
              blurRadius: 0.6,
            ),
          ],
        ),
      ),
    );

    if (widget.badgeText != null && widget.badgeText!.isNotEmpty) {
      core = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          core,
          Positioned(
            top: -4,
            right: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: widget.accentColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDark ? const Color(0xFF0F0A17) : Colors.white,
                  width: 1.2,
                ),
              ),
              child: Text(
                widget.badgeText!,
                style: AppFonts.inter(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (widget.onTap != null) {
      core = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap!();
        },
        child: AnimatedScale(
          scale: _isPressed && !reduceMotion ? 0.93 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: core,
        ),
      );
    }

    if (widget.semanticLabel != null) {
      core = Semantics(
        label: widget.semanticLabel,
        button: widget.onTap != null,
        child: core,
      );
    }

    return core;
  }
}

/// Backward-compatible alias for ModuleIcon.
typedef LifeUseModuleIcon = ModuleIcon;

// =============================================================================
// 2. NAVIGATION ICON (Gliding Capsule Destination Item)
// =============================================================================

/// Dynamic navigation destination icon with outline/filled state transition.
class NavigationIcon extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final bool isSelected;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showDot;
  final double size;

  const NavigationIcon({
    super.key,
    required this.icon,
    this.activeIcon,
    required this.isSelected,
    this.activeColor,
    this.inactiveColor,
    this.showDot = false,
    this.size = 25,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActive = activeColor ?? Colors.white;
    final effectiveInactive =
        inactiveColor ?? AppColors.textTertiaryOf(context);
    final color = isSelected ? effectiveActive : effectiveInactive;
    final targetIcon = (isSelected && activeIcon != null) ? activeIcon! : icon;

    return AnimatedScale(
      scale: isSelected ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Icon(
            targetIcon,
            size: size,
            color: color,
            shadows: [
              Shadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 0.6,
              ),
            ],
          ),
          if (showDot)
            Positioned(
              top: -2,
              right: -4,
              child: Container(
                width: 7.5,
                height: 7.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF0F0A17)
                        : Colors.white,
                    width: 1.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Backward-compatible alias for NavigationIcon.
typedef LifeUseNavigationIcon = NavigationIcon;

// =============================================================================
// 3. APP ICON (Universal Action & Setting Icon Widget)
// =============================================================================

enum AppIconSizePreset {
  xs, // 14px
  sm, // 18px
  md, // 22px
  lg, // 26px
  xl, // 32px
}

/// Universal modern icon widget with adaptive theming, sizing, and container options.
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool isPill;
  final Color? pillBackgroundColor;
  final Color? pillBorderColor;
  final double? pillRadius;
  final EdgeInsetsGeometry? pillPadding;
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

  /// Factory with standardized optical size tokens
  factory AppIcon.preset(
    IconData icon, {
    Key? key,
    AppIconSizePreset preset = AppIconSizePreset.md,
    Color? color,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    double s;
    switch (preset) {
      case AppIconSizePreset.xs:
        s = 16;
        break;
      case AppIconSizePreset.sm:
        s = 20;
        break;
      case AppIconSizePreset.md:
        s = 24;
        break;
      case AppIconSizePreset.lg:
        s = 28;
        break;
      case AppIconSizePreset.xl:
        s = 34;
        break;
    }
    return AppIcon(
      icon,
      key: key,
      size: s,
      color: color,
      onTap: onTap,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for active pill container (from AIRIX inspection)
  factory AppIcon.pill(
    IconData icon, {
    Key? key,
    double size = 20,
    Color? color,
    Color? backgroundColor,
    Color? borderColor,
    double radius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return AppIcon(
      icon,
      key: key,
      size: size,
      color: color ?? AppColors.primary,
      isPill: true,
      pillBackgroundColor: backgroundColor,
      pillBorderColor: borderColor,
      pillRadius: radius,
      pillPadding: padding,
      onTap: onTap,
      tooltip: tooltip,
    );
  }

  /// Factory constructor for sidebar active pill
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

  /// Factory constructor for alert warning badge
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
    final effectiveColor = color ?? AppColors.textPrimaryOf(context);
    Widget iconWidget = Icon(
      icon,
      size: size,
      color: effectiveColor,
      shadows: [
        Shadow(
          color: effectiveColor.withValues(alpha: 0.35),
          blurRadius: 0.6,
        ),
      ],
    );

    if (isPill) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      iconWidget = Container(
        padding: pillPadding ?? const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: pillBackgroundColor ??
              (isDark
                  ? AppColors.primary.withValues(alpha: 0.18)
                  : AppColors.primary.withValues(alpha: 0.10)),
          borderRadius: BorderRadius.circular(pillRadius ?? 12),
          border: Border.all(
            color: pillBorderColor ??
                (isDark
                    ? AppColors.primary.withValues(alpha: 0.30)
                    : AppColors.primary.withValues(alpha: 0.20)),
            width: 1,
          ),
        ),
        child: iconWidget,
      );
    }

    if (badgeCount != null && badgeCount! > 0) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
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
                  style: AppFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
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

/// Backward-compatible alias for AppIcon.
typedef LifeUseAppIcon = AppIcon;

// =============================================================================
// 4. DASHBOARD HERO & QUICK ACTION HELPERS
// =============================================================================

/// Reusable Dashboard Hero Icon with layered duotone container.
class LifeUseDashboardIcon extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final double size;
  final double containerSize;
  final double radius;
  final Widget? badge;
  final VoidCallback? onTap;

  const LifeUseDashboardIcon({
    super.key,
    required this.icon,
    required this.accentColor,
    this.size = 22,
    this.containerSize = 44,
    this.radius = 14,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LifeUseIcon.duotone(
      icon,
      accentColor: accentColor,
      customSize: size,
      customContainerSize: containerSize,
      customRadius: radius,
      badge: badge,
      onTap: onTap,
    );
  }
}

/// Modern icon-first action pill (e.g., [ + ] Record, [ Filter ] Done)
class LifeUseActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isCompact;

  const LifeUseActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBg = isDark ? const Color(0xFF2A1838) : AppColors.softLavender;
    final btnBorder =
        isDark ? const Color(0xFF3D2550) : const Color(0xFFEBE3F0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 10 : 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: btnBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: btnBorder,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: color,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Directional Financial Flow Indicator (+ Inflow / - Outflow)
class LifeUseFlowIndicator extends StatelessWidget {
  final bool isIncome;
  final double? amount;
  final String? formattedAmount;
  final double iconSize;

  const LifeUseFlowIndicator({
    super.key,
    required this.isIncome,
    this.amount,
    this.formattedAmount,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color =
        isIncome ? AppColors.financialPositive : AppColors.financialNegative;
    final icon =
        isIncome ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize + 8,
          height: iconSize + 8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.18 : 0.10),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: color,
            ),
          ),
        ),
        if (formattedAmount != null) ...[
          const SizedBox(width: 6),
          Text(
            '${isIncome ? '+' : '-'}$formattedAmount',
            style: AppFonts.inter(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.2,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ],
    );
  }
}

/// Illustrated Persona Emblem with Dynamic Status Ring
class LifeUsePersonaEmblem extends StatelessWidget {
  final String name;
  final bool isAuthenticated;
  final double size;
  final VoidCallback? onTap;

  const LifeUsePersonaEmblem({
    super.key,
    required this.name,
    required this.isAuthenticated,
    this.size = 46,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ringColor =
        isAuthenticated ? AppColors.primary : const Color(0xFF64748B);

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isAuthenticated
              ? [const Color(0xFF10B981), const Color(0xFF047857)]
              : [const Color(0xFF475569), const Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: ringColor.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: ringColor.withValues(alpha: isDark ? 0.35 : 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isAuthenticated ? LucideIcons.shieldCheck : LucideIcons.user,
          size: size * 0.46,
          color: Colors.white,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: avatar,
      );
    }

    return avatar;
  }
}
