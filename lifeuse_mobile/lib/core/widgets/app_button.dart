import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Button visual variants matching modern Figma / shadcn tokens
enum AppButtonVariant {
  primary,
  secondary,
  outlined,
  ghost,
  tonal,
  destructive,
}

/// Reusable action button matching LifeUse design system:
/// Inter font, Bold (700), clean pill/curved geometry, elevation awareness.
/// File: lib/core/widgets/app_button.dart
class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final AppButtonVariant variant;
  final IconData? icon;
  final double height;
  final double? width;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.height = 50,
    this.width,
  });

  const AppButton.outlined({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 50,
    this.width,
  })  : isOutlined = true,
        variant = AppButtonVariant.outlined;

  const AppButton.secondary({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 50,
    this.width,
  })  : isOutlined = false,
        variant = AppButtonVariant.secondary;

  const AppButton.destructive({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 50,
    this.width,
  })  : isOutlined = false,
        variant = AppButtonVariant.destructive;

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveVariant = isOutlined ? AppButtonVariant.outlined : variant;

    switch (effectiveVariant) {
      case AppButtonVariant.outlined:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(width ?? 0, height),
              side: BorderSide(color: borderColor, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              foregroundColor: textPrimary,
            ),
            child: _buildChild(textColor: textPrimary),
          ),
        );

      case AppButtonVariant.secondary:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(width ?? 0, height),
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              foregroundColor: textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: _buildChild(textColor: textPrimary),
          ),
        );

      case AppButtonVariant.destructive:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(width ?? 0, height),
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _buildChild(textColor: Colors.white),
          ),
        );

      case AppButtonVariant.ghost:
        return SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              minimumSize: Size(width ?? 0, height),
              foregroundColor: textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _buildChild(textColor: textPrimary),
          ),
        );

      case AppButtonVariant.tonal:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(width ?? 0, height),
              backgroundColor: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
              foregroundColor: AppColors.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _buildChild(textColor: AppColors.primary),
          ),
        );

      case AppButtonVariant.primary:
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: onPressed == null || isLoading
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(width ?? 0, height),
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _buildChild(textColor: Colors.white),
          ),
        );
    }
  }

  Widget _buildChild({required Color textColor}) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      );
    }

    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 0.1,
      ),
    );
  }
}
