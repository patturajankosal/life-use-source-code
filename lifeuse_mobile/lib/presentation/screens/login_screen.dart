import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/corner_ambient_glow.dart';
import '../../core/widgets/feedback_banner.dart';
import '../../core/widgets/lifeuse_animated_icons.dart';
import '../../core/widgets/lifeuse_wordmark.dart';
import '../navigation/main_navigation_shell.dart';
import '../state/auth_provider.dart';
import 'register_screen.dart';

/// Production-ready, card-based Login Screen for LifeUse.
/// Features animated brand icon, Dark/Light theme toggle, Top-Left Back-to-Dashboard,
/// forgot password assistance, and top-right ambient glow.
/// File: lib/presentation/screens/login_screen.dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  // Selected icon animation mode: 0 = PulseGlow, 1 = OrbitalMotion, 2 = MorphShimmer
  int _iconAnimMode = 1;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      _identifierController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigationShell()),
        );
      }
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController(
      text: _identifierController.text.contains('@')
          ? _identifierController.text.trim()
          : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        final textPrimary = AppColors.textPrimaryOf(ctx);
        final textSecondary = AppColors.textSecondaryOf(ctx);
        final surfaceColor = AppColors.surfaceOf(ctx);
        final borderColor = AppColors.borderOf(ctx);

        return AlertDialog(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: borderColor),
          ),
          title: Text(
            'Reset Password',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the email address associated with your LifeUse account to receive password reset instructions.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Email Address',
                hint: 'name@example.com',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: LucideIcons.mail,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty || !email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid email address')),
                  );
                  return;
                }
                Navigator.pop(ctx);
                final auth = context.read<AuthProvider>();
                final ok = await auth.forgotPassword(email);
                if (mounted) {
                  FeedbackBanner.showSnackBar(
                    context,
                    ok
                        ? 'Password reset instructions sent to $email'
                        : (auth.errorMessage ?? 'Failed to send reset email'),
                    isError: !ok,
                  );
                }
              },
              child: Text(
                'Send Instructions',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final isDark = theme.isDarkMode;

    final bgColor = AppColors.backgroundOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // --- 1. Top-Right Ambient Corner Animation ---
          const CornerAmbientGlow(size: 240, isTopRight: true),

          // --- 2. Top Bar: Back to Dashboard & Dark/Light Mode Toggle ---
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button / Exit to Dashboard
                  InkWell(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const MainNavigationShell(),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.arrowLeft,
                            size: 16,
                            color: textPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Dashboard',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Theme Toggle
                  Tooltip(
                    message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                    child: InkWell(
                      onTap: () => theme.toggleTheme(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isDark ? AppIcons.lightMode : AppIcons.darkMode,
                              size: 16,
                              color: isDark ? AppColors.amberGold : AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isDark ? 'Light' : 'Dark',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- 3. Main Card-Based Content ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(28, 36, 28, 16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: borderColor,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                              blurRadius: 36,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // --- Animated 3D LifeUse Icon ---
                              Center(
                                child: _buildAnimatedIcon(),
                              ),
                              const SizedBox(height: 14),

                              // --- Official Brand Wordmark ---
                              Center(
                                child: LifeUseWordmark(
                                  height: 22,
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // --- Welcome Back Heading ---
                              Center(
                                child: Text(
                                  'Welcome Back',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: AppTypography.adaptiveSize(context, 20),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Center(
                                child: Text(
                                  'Enter your credentials to access your LifeUse account',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // --- Alerts ---
                              if (auth.errorMessage != null)
                                FeedbackBanner(
                                  message: auth.errorMessage!,
                                  isError: true,
                                  onDismiss: () => auth.clearMessages(),
                                ),
                              if (auth.successMessage != null)
                                FeedbackBanner(
                                  message: auth.successMessage!,
                                  isError: false,
                                  onDismiss: () => auth.clearMessages(),
                                ),

                              // --- Form Inputs ---
                              AppTextField(
                                label: 'Phone number, email or username',
                                hint: 'Enter your phone, email, or username',
                                controller: _identifierController,
                                prefixIcon: AppIcons.userProfile,
                                validator: Validators.validateIdentifier,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),

                              AppTextField(
                                label: 'Password',
                                hint: 'Enter your password',
                                controller: _passwordController,
                                prefixIcon: AppIcons.password,
                                isPassword: true,
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Password is required'
                                    : null,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submitLogin(),
                              ),
                              const SizedBox(height: 8),

                              // --- Forgot Password ---
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: _showForgotPasswordDialog,
                                  borderRadius: BorderRadius.circular(4),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      'Forgot password?',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // --- Sign In Button ---
                              AppButton(
                                title: 'Sign In',
                                onPressed: _submitLogin,
                                isLoading: auth.isLoading,
                              ),
                              const SizedBox(height: 18),

                              // --- Switch to Register ---
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: GoogleFonts.inter(
                                      color: textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      auth.clearMessages();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Create account',
                                      style: GoogleFonts.inter(
                                        color: AppColors.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // --- Footer Branding ---
                              Center(
                                child: Text(
                                  '© 2026 LIFEUSE. All rights reserved.',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.04, end: 0, duration: 250.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    switch (_iconAnimMode) {
      case 0:
        return LifeUse3DIcon(
          size: 78,
          mode: LifeUseIconAnimMode.hyperVortex,
          onTap: () => setState(() => _iconAnimMode = 1),
        );
      case 1:
      default:
        return LifeUse3DIcon(
          size: 78,
          mode: LifeUseIconAnimMode.orbital3D,
          onTap: () => setState(() => _iconAnimMode = 0),
        );
    }
  }
}
