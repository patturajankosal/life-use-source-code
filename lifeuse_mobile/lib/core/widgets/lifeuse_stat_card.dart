import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Stat Card Variant for LifeUse:
/// purple, blue, green, teal
enum LifeUseStatVariant { purple, blue, green, teal }

/// Reusable Stat Card component for LifeUse application:
/// - 18px border radius
/// - 1px solid theme-matched stroke
/// - Pixel-perfect 135deg linear gradients for Light & Dark modes
/// - Inter typography: 14px w600 label, 28px w700 value
/// File: lib/core/widgets/lifeuse_stat_card.dart
class LifeUseStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final LifeUseStatVariant variant;
  final VoidCallback? onTap;

  const LifeUseStatCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.variant = LifeUseStatVariant.purple,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = _getGradientColors(variant, isDark);
    final borderColor = _getBorderColor(variant, isDark);
    final labelColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1F2430);
    final valueColor = isDark ? Colors.white : const Color(0xFF111827);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        constraints: const BoxConstraints(minHeight: 118),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
            stops: const [0.0, 0.35, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: isDark ? 0.2 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // --- Row: Label + Icon ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  icon!,
                ],
              ],
            ),
            const SizedBox(height: 12),

            // --- Value Metric ---
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
                color: valueColor,
              ),
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static List<Color> _getGradientColors(LifeUseStatVariant variant, bool isDark) {
    if (isDark) {
      switch (variant) {
        case LifeUseStatVariant.purple:
          return const [Color(0xFF1E1B4B), Color(0xFF231454), Color(0xFF2E1065)];
        case LifeUseStatVariant.blue:
          return const [Color(0xFF172554), Color(0xFF1A2E6B), Color(0xFF1E3A8A)];
        case LifeUseStatVariant.green:
          return const [Color(0xFF052E16), Color(0xFF0C3E20), Color(0xFF14532D)];
        case LifeUseStatVariant.teal:
          return const [Color(0xFF042F2E), Color(0xFF0A3E3D), Color(0xFF134E4A)];
      }
    } else {
      switch (variant) {
        case LifeUseStatVariant.purple:
          return const [Color(0xFFFFFFFF), Color(0xFFFBFAFF), Color(0xFFE7E2FA)];
        case LifeUseStatVariant.blue:
          return const [Color(0xFFFFFFFF), Color(0xFFFAFDFF), Color(0xFFDCECFB)];
        case LifeUseStatVariant.green:
          return const [Color(0xFFFFFFFF), Color(0xFFFAFFFC), Color(0xFFD9F1E2)];
        case LifeUseStatVariant.teal:
          return const [Color(0xFFFFFFFF), Color(0xFFF9FFFC), Color(0xFFD6F3E7)];
      }
    }
  }

  static Color _getBorderColor(LifeUseStatVariant variant, bool isDark) {
    if (isDark) {
      switch (variant) {
        case LifeUseStatVariant.purple:
          return const Color(0xFF4C1D95);
        case LifeUseStatVariant.blue:
          return const Color(0xFF1E3A8A);
        case LifeUseStatVariant.green:
          return const Color(0xFF14532D);
        case LifeUseStatVariant.teal:
          return const Color(0xFF134E4A);
      }
    } else {
      switch (variant) {
        case LifeUseStatVariant.purple:
          return const Color(0xFFDDD6F7);
        case LifeUseStatVariant.blue:
          return const Color(0xFFCFE4F9);
        case LifeUseStatVariant.green:
          return const Color(0xFFCFE9D9);
        case LifeUseStatVariant.teal:
          return const Color(0xFFCCEEE0);
      }
    }
  }
}
