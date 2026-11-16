import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';

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

    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5);
    final labelColor =
        isDark ? const Color(0xFFA1A1AA) : const Color(0xFF666666);
    final valueColor = isDark ? Colors.white : const Color(0xFF111111);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        constraints: const BoxConstraints(minHeight: 108),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
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
                    style: AppFonts.inter(
                      fontSize: 13,
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
            const SizedBox(height: 10),

            // --- Value Metric ---
            Text(
              value,
              style: AppFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
                color: valueColor,
              ),
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: AppFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF71717A)
                      : const Color(0xFF8E8E93),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
