import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// SweetAlert icon & visual style variants
enum SweetAlertType {
  success,
  error,
  warning,
  info,
  confirm,
}

/// A modern, responsive, SweetAlert2-inspired popup dialog for LifeUse.
/// Provides beautiful animated entry, distinctive icon badges, clear typography,
/// and versatile confirmation/action callbacks.
///
/// File: lib/core/widgets/sweet_alert.dart
class SweetAlert extends StatelessWidget {
  final SweetAlertType type;
  final String title;
  final String? message;
  final Widget? customContent;
  final String confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const SweetAlert({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.customContent,
    this.confirmText = 'OK',
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  // ---------------------------------------------------------------------------
  // Static Helper Methods for Easy Invocations
  // ---------------------------------------------------------------------------

  /// Show Success Alert
  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    String? message,
    String buttonText = 'Done',
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => SweetAlert(
        type: SweetAlertType.success,
        title: title,
        message: message,
        confirmText: buttonText,
        onConfirm: () {
          Navigator.of(ctx).pop();
          if (onConfirm != null) onConfirm();
        },
      ),
    );
  }

  /// Show Error Alert
  static Future<void> showError(
    BuildContext context, {
    required String title,
    String? message,
    String buttonText = 'Close',
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => SweetAlert(
        type: SweetAlertType.error,
        title: title,
        message: message,
        confirmText: buttonText,
        isDestructive: true,
        onConfirm: () {
          Navigator.of(ctx).pop();
          if (onConfirm != null) onConfirm();
        },
      ),
    );
  }

  /// Show Warning Alert
  static Future<void> showWarning(
    BuildContext context, {
    required String title,
    String? message,
    String buttonText = 'Understood',
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => SweetAlert(
        type: SweetAlertType.warning,
        title: title,
        message: message,
        confirmText: buttonText,
        onConfirm: () {
          Navigator.of(ctx).pop();
          if (onConfirm != null) onConfirm();
        },
      ),
    );
  }

  /// Show Info Alert
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    String? message,
    String buttonText = 'Got It',
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => SweetAlert(
        type: SweetAlertType.info,
        title: title,
        message: message,
        confirmText: buttonText,
        onConfirm: () {
          Navigator.of(ctx).pop();
          if (onConfirm != null) onConfirm();
        },
      ),
    );
  }

  /// Show Confirmation Dialog with Cancel and Confirm buttons
  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    Widget? customContent,
    FutureOr<void> Function()? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => SweetAlert(
        type: SweetAlertType.confirm,
        title: title,
        message: message,
        customContent: customContent,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () async {
          if (onConfirm != null) {
            await onConfirm();
          }
          if (ctx.mounted) {
            Navigator.of(ctx).pop(true);
          }
        },
        onCancel: () {
          Navigator.of(ctx).pop(false);
          if (onCancel != null) onCancel();
        },
      ),
    );
    return result ?? false;
  }

  // ---------------------------------------------------------------------------
  // Build Methods
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    final styleConfig = _getStyleConfig();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.88, end: 1.0),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.55)
                    : Colors.black.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Animated Icon Circle
              _buildIconCircle(styleConfig),
              const SizedBox(height: 20),

              // 2. Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  letterSpacing: -0.3,
                ),
              ),

              // 3. Optional Message
              if (message != null && message!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textSecondary,
                    height: 1.45,
                  ),
                ),
              ],

              // 4. Custom Content if provided
              if (customContent != null) ...[
                const SizedBox(height: 14),
                customContent!,
              ],

              const SizedBox(height: 24),

              // 5. Action Buttons (Cancel / Confirm)
              Row(
                children: [
                  if (cancelText != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: borderColor),
                        ),
                        onPressed: onCancel ?? () => Navigator.of(context).pop(false),
                        child: Text(
                          cancelText!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDestructive
                            ? AppColors.error
                            : styleConfig.accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
                      child: Text(
                        confirmText,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconCircle(_StyleConfig config) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: config.accentColor.withValues(alpha: 0.12),
        border: Border.all(
          color: config.accentColor.withValues(alpha: 0.35),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          config.icon,
          size: 36,
          color: config.accentColor,
        ),
      ),
    );
  }

  _StyleConfig _getStyleConfig() {
    switch (type) {
      case SweetAlertType.success:
        return const _StyleConfig(
          icon: Icons.check_circle_outline_rounded,
          accentColor: AppColors.success,
        );
      case SweetAlertType.error:
        return const _StyleConfig(
          icon: Icons.highlight_off_rounded,
          accentColor: AppColors.error,
        );
      case SweetAlertType.warning:
        return const _StyleConfig(
          icon: Icons.warning_amber_rounded,
          accentColor: AppColors.amberGold,
        );
      case SweetAlertType.info:
        return const _StyleConfig(
          icon: Icons.info_outline_rounded,
          accentColor: AppColors.primary,
        );
      case SweetAlertType.confirm:
        return _StyleConfig(
          icon: isDestructive
              ? Icons.delete_forever_outlined
              : Icons.help_outline_rounded,
          accentColor: isDestructive ? AppColors.error : AppColors.primary,
        );
    }
  }
}

class _StyleConfig {
  final IconData icon;
  final Color accentColor;

  const _StyleConfig({
    required this.icon,
    required this.accentColor,
  });
}
