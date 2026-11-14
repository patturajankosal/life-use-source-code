import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../theme/app_colors.dart';

/// Reusable Icon-First Component Suite for LifeUse Mobile.
/// Implements the approved dual-tier iconography system:
/// - Hero Layered Duotone Containers for Dashboard
/// - Minimal Outline Glyphs for Compact Navigation
/// - Directional Financial Flow Indicators
/// - Icon-First Action Pills and Persona Emblems
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final containerBg = isDark
        ? const Color(0xFF2A1838)
        : AppColors.softLavender;
    final containerBorder = isDark
        ? const Color(0xFF3D2550)
        : const Color(0xFFEBE3F0);

    Widget iconWidget = Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: containerBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: size,
          color: accentColor,
        ),
      ),
    );

    if (badge != null) {
      iconWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            top: -3,
            right: -3,
            child: badge!,
          ),
        ],
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}

/// Compact frameless navigation icon with smooth scale and color transitions
class LifeUseNavigationIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showDot;
  final double size;

  const LifeUseNavigationIcon({
    super.key,
    required this.icon,
    required this.isSelected,
    this.activeColor,
    this.inactiveColor,
    this.showDot = false,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActive = activeColor ?? AppColors.primary;
    final effectiveInactive =
        inactiveColor ?? AppColors.textTertiaryOf(context);
    final color = isSelected ? effectiveActive : effectiveInactive;

    return AnimatedScale(
      scale: isSelected ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            size: size,
            color: color,
          ),
          if (showDot)
            Positioned(
              top: -1,
              right: -3,
              child: Container(
                width: 7.5,
                height: 7.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF0B0F19)
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
    final btnBorder = isDark ? const Color(0xFF3D2550) : const Color(0xFFEBE3F0);

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
              style: GoogleFonts.plusJakartaSans(
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
    final color = isIncome ? AppColors.financialPositive : AppColors.financialNegative;
    final icon = isIncome ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight;

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
            style: GoogleFonts.inter(
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
    final ringColor = isAuthenticated ? AppColors.primary : const Color(0xFF64748B);

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
