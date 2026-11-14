import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/register_screen.dart';
import '../../presentation/state/auth_provider.dart';
import 'app_button.dart';

/// Reusable Authentication Guard and Dialog for LifeUse.
/// Enforces seamless guest browsing while protecting authenticated actions.
class AuthGuardDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onAuthenticated;

  const AuthGuardDialog({
    super.key,
    this.title = 'Authentication Required',
    this.message =
        'Please sign in or create an account to access this feature and keep your personal life data synchronized.',
    this.onAuthenticated,
  });

  /// Static helper to protect actions:
  /// - If user is logged in, immediately executes [onAuthenticated] and returns true.
  /// - If user is a guest, displays the AuthGuardDialog.
  /// - If user subsequently logs in, executes [onAuthenticated] and returns true.
  static Future<bool> protect(
    BuildContext context, {
    required VoidCallback onAuthenticated,
    String? title,
    String? message,
  }) async {
    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      onAuthenticated();
      return true;
    }

    final loggedIn = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AuthGuardDialog(
        title: title ?? 'Authentication Required',
        message: message ??
            'Please sign in or create an account to access this feature and keep your personal life data synchronized.',
        onAuthenticated: onAuthenticated,
      ),
    );

    if (loggedIn == true && context.mounted) {
      if (context.read<AuthProvider>().isAuthenticated) {
        onAuthenticated();
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.12),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Icon Badge
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.lock,
                        size: 26,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),

                // Action 1: Sign In Button
                AppButton(
                  title: 'Sign In',
                  icon: LucideIcons.logIn,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final loggedIn = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                    if (loggedIn == true && onAuthenticated != null) {
                      onAuthenticated!();
                    }
                  },
                ),
                const SizedBox(height: 10),

                // Action 2: Create Account Button
                AppButton(
                  title: 'Create Account',
                  isOutlined: true,
                  icon: LucideIcons.userPlus,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                ),
                const SizedBox(height: 8),

                // Action 3: Maybe Later / Cancel
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      foregroundColor: textSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'Continue as Guest',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
