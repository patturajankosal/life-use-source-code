import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/lifeuse_badge.dart';
import '../models/dashboard_module_item.dart';

/// Highly customizable and reusable card for dashboard feature modules.
/// Displays module branding, status badge, feature tags, live preview, and tap interaction.
class ModuleCard extends StatelessWidget {
  final DashboardModuleItem module;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.module,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    LifeUseBadgeVariant badgeVariant;
    switch (module.status) {
      case ModuleStatus.active:
        badgeVariant = LifeUseBadgeVariant.active;
        break;
      case ModuleStatus.beta:
        badgeVariant = LifeUseBadgeVariant.pending;
        break;
      case ModuleStatus.comingSoon:
        badgeVariant = LifeUseBadgeVariant.defaultVariant;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: module.isActive
              ? module.accentColor.withValues(alpha: 0.3)
              : borderColor,
          width: module.isActive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: module.isActive
                ? module.accentColor.withValues(alpha: isDark ? 0.12 : 0.06)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: module.accentColor.withValues(alpha: 0.1),
          highlightColor: module.accentColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Module Icon + Title + Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container with ambient accent color
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: module.accentColor.withValues(alpha: isDark ? 0.15 : 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: module.accentColor.withValues(alpha: 0.3),
                          width: 1.2,
                        ),
                      ),
                      child: Icon(
                        module.icon,
                        size: 24,
                        color: module.accentColor,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Title & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  module.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              LifeUseBadge(
                                text: module.statusLabel,
                                variant: badgeVariant,
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            module.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: module.accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  module.description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.45,
                    color: textSecondary,
                  ),
                ),

                // Optional live stats preview builder (e.g. today's spending limit)
                if (module.previewBuilder != null) ...[
                  const SizedBox(height: 14),
                  module.previewBuilder!(context),
                ],

                const SizedBox(height: 14),

                // Highlights pills & action arrow
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: module.highlights.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: borderColor.withValues(alpha: 0.6),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: module.isActive
                            ? module.accentColor.withValues(alpha: 0.12)
                            : borderColor.withValues(alpha: 0.3),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: module.isActive ? module.accentColor : textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
