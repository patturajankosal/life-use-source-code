import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic Badge Variant for LifeUse platform:
/// active, pending, invited, suspended, terminated, cyan, defaultVariant
enum LifeUseBadgeVariant {
  active,
  pending,
  invited,
  suspended,
  terminated,
  cyan,
  defaultVariant,
}

/// Reusable Badge component for LifeUse application:
/// - 12px border radius
/// - 1px solid stroke with 10% opacity fills
/// - Inter typography: 11-12px, FontWeight.w600
/// File: lib/core/widgets/lifeuse_badge.dart
class LifeUseBadge extends StatelessWidget {
  final String text;
  final LifeUseBadgeVariant variant;
  final Widget? icon;

  const LifeUseBadge({
    super.key,
    required this.text,
    this.variant = LifeUseBadgeVariant.active,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final config = _getStyleConfig(variant, isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.borderColor, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: config.textColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  static _BadgeConfig _getStyleConfig(LifeUseBadgeVariant variant, bool isDark) {
    switch (variant) {
      case LifeUseBadgeVariant.active:
        return _BadgeConfig(
          backgroundColor: const Color(0xFF84CC16).withValues(alpha: isDark ? 0.12 : 0.08),
          borderColor: const Color(0xFF84CC16).withValues(alpha: 0.35),
          textColor: isDark ? const Color(0xFFA3E635) : const Color(0xFF65A30D),
        );
      case LifeUseBadgeVariant.pending:
        return _BadgeConfig(
          backgroundColor: const Color(0xFFCA8A04).withValues(alpha: isDark ? 0.14 : 0.09),
          borderColor: const Color(0xFFCA8A04).withValues(alpha: 0.35),
          textColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
        );
      case LifeUseBadgeVariant.invited:
        return _BadgeConfig(
          backgroundColor: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.14 : 0.09),
          borderColor: const Color(0xFF3B82F6).withValues(alpha: 0.35),
          textColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
        );
      case LifeUseBadgeVariant.suspended:
        return _BadgeConfig(
          backgroundColor: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.14 : 0.09),
          borderColor: const Color(0xFF6366F1).withValues(alpha: 0.35),
          textColor: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
        );
      case LifeUseBadgeVariant.terminated:
        return _BadgeConfig(
          backgroundColor: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.14 : 0.09),
          borderColor: const Color(0xFFEF4444).withValues(alpha: 0.35),
          textColor: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
        );
      case LifeUseBadgeVariant.cyan:
        return _BadgeConfig(
          backgroundColor: const Color(0xFF0891B2).withValues(alpha: isDark ? 0.14 : 0.09),
          borderColor: const Color(0xFF0891B2).withValues(alpha: 0.35),
          textColor: isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2),
        );
      case LifeUseBadgeVariant.defaultVariant:
        return _BadgeConfig(
          backgroundColor: isDark ? const Color(0xFF262626) : const Color(0xFFF4F5F5),
          borderColor: isDark ? const Color(0xFF333333) : const Color(0xFFE6E6E6),
          textColor: isDark ? const Color(0xFFCCCCCC) : const Color(0xFF4D4D4D),
        );
    }
  }
}

class _BadgeConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _BadgeConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}
