import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

/// Clean reusable Error State with retry action for LifeUse.
/// File: lib/core/widgets/app_error_state.dart
class AppErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryText;

  const AppErrorState({
    super.key,
    this.title = 'Unable to Load Data',
    required this.message,
    this.onRetry,
    this.retryText = 'Try Again',
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withValues(alpha: isDark ? 0.18 : 0.08),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.alertCircle,
                  size: 26,
                  color: AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: textSecondary,
                height: 1.4,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: AppButton(
                  title: retryText,
                  icon: LucideIcons.refreshCw,
                  onPressed: onRetry,
                  height: 40,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
