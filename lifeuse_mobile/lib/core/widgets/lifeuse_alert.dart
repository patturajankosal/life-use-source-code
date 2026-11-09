import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Visual variants for LifeUse alerts matching shadcn alertVariants:
enum LifeUseAlertVariant {
  defaultVariant,
  destructive,
  success,
  warning,
  info,
}

/// Reusable Alert component for LifeUse application:
/// - Replicates React shadcn Alert, AlertTitle, AlertDescription
/// - Supports icons, title, description, dismiss button, and custom action
/// - Clean 12px border radius, subtle border and background tint
/// File: lib/core/widgets/lifeuse_alert.dart
class LifeUseAlert extends StatelessWidget {
  final String? title;
  final String description;
  final Widget? icon;
  final LifeUseAlertVariant variant;
  final VoidCallback? onDismiss;
  final Widget? action;

  const LifeUseAlert({
    super.key,
    this.title,
    required this.description,
    this.icon,
    this.variant = LifeUseAlertVariant.defaultVariant,
    this.onDismiss,
    this.action,
  });

  const LifeUseAlert.destructive({
    super.key,
    this.title,
    required this.description,
    this.icon,
    this.onDismiss,
    this.action,
  }) : variant = LifeUseAlertVariant.destructive;

  const LifeUseAlert.success({
    super.key,
    this.title,
    required this.description,
    this.icon,
    this.onDismiss,
    this.action,
  }) : variant = LifeUseAlertVariant.success;

  const LifeUseAlert.warning({
    super.key,
    this.title,
    required this.description,
    this.icon,
    this.onDismiss,
    this.action,
  }) : variant = LifeUseAlertVariant.warning;

  const LifeUseAlert.info({
    super.key,
    this.title,
    required this.description,
    this.icon,
    this.onDismiss,
    this.action,
  }) : variant = LifeUseAlertVariant.info;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final config = _getStyleConfig(variant, isDark);
    final defaultIcon = _getDefaultIcon(variant);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.borderColor, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: icon ??
                Icon(
                  defaultIcon,
                  size: 18,
                  color: config.iconColor,
                ),
          ),
          const SizedBox(width: 12),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null && title!.isNotEmpty) ...[
                  Text(
                    title!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: config.titleColor,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: config.descColor,
                    height: 1.4,
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(height: 10),
                  action!,
                ],
              ],
            ),
          ),

          // Dismiss Button
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: config.descColor.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static _AlertConfig _getStyleConfig(LifeUseAlertVariant variant, bool isDark) {
    switch (variant) {
      case LifeUseAlertVariant.defaultVariant:
        return _AlertConfig(
          backgroundColor: isDark ? AppColors.darkBase50 : AppColors.base50,
          borderColor: isDark ? AppColors.darkBase100 : AppColors.base100,
          iconColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          titleColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          descColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        );
      case LifeUseAlertVariant.destructive:
        return _AlertConfig(
          backgroundColor: isDark
              ? const Color(0xFF2A0A0A)
              : const Color(0xFFFEF2F2),
          borderColor: isDark
              ? const Color(0xFF7F1D1D)
              : const Color(0xFFFECACA),
          iconColor: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
          titleColor: isDark ? const Color(0xFFF87171) : const Color(0xFF991B1B),
          descColor: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C),
        );
      case LifeUseAlertVariant.success:
        return _AlertConfig(
          backgroundColor: isDark
              ? const Color(0xFF04170E)
              : const Color(0xFFF0FDF4),
          borderColor: isDark
              ? const Color(0xFF115E39)
              : const Color(0xFFBBF7D0),
          iconColor: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
          titleColor: isDark ? const Color(0xFF86EFAC) : const Color(0xFF166534),
          descColor: isDark ? const Color(0xFFBBF7D0) : const Color(0xFF15803D),
        );
      case LifeUseAlertVariant.warning:
        return _AlertConfig(
          backgroundColor: isDark
              ? const Color(0xFF201305)
              : const Color(0xFFFFFBEB),
          borderColor: isDark
              ? const Color(0xFF78350F)
              : const Color(0xFFFDE68A),
          iconColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          titleColor: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
          descColor: isDark ? const Color(0xFFFEF3C7) : const Color(0xFFB45309),
        );
      case LifeUseAlertVariant.info:
        return _AlertConfig(
          backgroundColor: isDark
              ? const Color(0xFF08172D)
              : const Color(0xFFEFF6FF),
          borderColor: isDark
              ? const Color(0xFF1E40AF)
              : const Color(0xFFBFDBFE),
          iconColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
          titleColor: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF),
          descColor: isDark ? const Color(0xFFDBEAFE) : const Color(0xFF1D4ED8),
        );
    }
  }

  static IconData _getDefaultIcon(LifeUseAlertVariant variant) {
    switch (variant) {
      case LifeUseAlertVariant.defaultVariant:
        return Icons.info_outline_rounded;
      case LifeUseAlertVariant.destructive:
        return Icons.error_outline_rounded;
      case LifeUseAlertVariant.success:
        return Icons.check_circle_outline_rounded;
      case LifeUseAlertVariant.warning:
        return Icons.warning_amber_rounded;
      case LifeUseAlertVariant.info:
        return Icons.info_outline_rounded;
    }
  }
}

class _AlertConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color titleColor;
  final Color descColor;

  const _AlertConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.titleColor,
    required this.descColor,
  });
}
