import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/corner_ambient_glow.dart';
import '../../core/widgets/feedback_banner.dart';
import '../../core/widgets/lifeuse_animated_icons.dart';
import '../../core/widgets/lifeuse_wordmark.dart';
import '../../data/models/register_request.dart';
import '../state/auth_provider.dart';

/// Production-ready, card-based Register Screen for LifeUse.
/// Features top-right ambient glow, LifeUse styling, animated brand icon,
/// centered heading, and Dark/Light theme adaptation.
/// File: lib/presentation/screens/register_screen.dart
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Priority Fields: Email, Phone, Username
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();

  // Security Fields: Password, Confirm Password
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Selected icon animation mode: 0 = PulseGlow, 1 = OrbitalMotion, 2 = MorphShimmer
  int _iconAnimMode = 2;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final auth = context.read<AuthProvider>();

    final request = RegisterRequest(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      firstName: '',
      lastName: '',
    );

    final response = await auth.register(request);

    if (response != null && mounted) {
      FeedbackBanner.showSnackBar(
        context,
        'Account created successfully for @${response.username}! Please sign in.',
        isError: false,
      );
      Navigator.of(context).pop();
    }
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

          // --- 2. Top Bar: Back Button & Dark/Light Mode Toggle ---
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: IconButton(
                icon: Icon(AppIcons.arrowBack, size: 20, color: textPrimary),
                tooltip: 'Back to Sign In',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: Tooltip(
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
            ),
          ),

          // --- 3. Main Card-Based Content ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(28, 34, 28, 12),
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
                          // --- 1. LifeUse Animated App Icon ---
                          Center(
                            child: _buildAnimatedIcon(),
                          ),
                          const SizedBox(height: 14),

                          // --- Official Brand Wordmark (Unique Custom Stencil Typography) ---
                          Center(
                            child: LifeUseWordmark(
                              height: 22,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // --- Subtitle ---
                          Center(
                            child: Text(
                              'Create your account to unlock smart and seamless access',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                color: textSecondary,
                                height: 1.35,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // --- Alerts ---
                          if (auth.errorMessage != null)
                            FeedbackBanner(
                              message: auth.errorMessage!,
                              isError: true,
                              onDismiss: () => auth.clearMessages(),
                            ),

                          // --- Priority Field 1: Email Address ---
                          AppTextField(
                            label: 'Email address',
                            hint: 'Enter your email address',
                            controller: _emailController,
                            prefixIcon: AppIcons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          // --- Priority Field 2: Phone Number (Matches User Image Spec) ---
                          AppTextField(
                            label: 'Phone number',
                            hint: 'Enter your phone number',
                            controller: _phoneController,
                            prefixIcon: AppIcons.phone,
                            keyboardType: TextInputType.phone,
                            validator: Validators.validatePhoneNumber,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          // --- Priority Field 3: Username ---
                          AppTextField(
                            label: 'Username',
                            hint: 'Enter unique username',
                            controller: _usernameController,
                            prefixIcon: AppIcons.username,
                            validator: Validators.validateUsername,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          // --- Field 4: Password with Touch-to-Peek ---
                          AppTextField(
                            label: 'Password',
                            hint: 'Create a secure password',
                            controller: _passwordController,
                            prefixIcon: AppIcons.password,
                            isPassword: true,
                            validator: Validators.validatePassword,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),

                          // --- Field 5: Confirm Password with Touch-to-Peek ---
                          AppTextField(
                            label: 'Confirm password',
                            hint: 'Re-enter your password',
                            controller: _confirmPasswordController,
                            prefixIcon: AppIcons.password,
                            isPassword: true,
                            validator: (val) => Validators.validateConfirmPassword(
                              val,
                              _passwordController.text,
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submitRegister(),
                          ),
                          const SizedBox(height: 26),

                          // --- Submit Button ---
                          AppButton(
                            title: 'Create Account',
                            onPressed: _submitRegister,
                            isLoading: auth.isLoading,
                          ),
                          const SizedBox(height: 20),

                          // --- Switch to Sign In ---
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: GoogleFonts.inter(
                                  color: textSecondary,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Text(
                                  'Sign in',
                                  style: GoogleFonts.inter(
                                    color: AppColors.primary,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // --- Footer Branding (Inside Card, Bottom Aligned & High Contrast) ---
                          Center(
                            child: Text(
                              '© 2026 LIFEUSE. All rights reserved.',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
          size: 82,
          mode: LifeUseIconAnimMode.hyperVortex, // Mode 0: Swirling Cosmic Spiral Flow with Flowing Star Sparks
          onTap: () => setState(() => _iconAnimMode = 1),
        );
      case 1:
      default:
        return LifeUse3DIcon(
          size: 82,
          mode: LifeUseIconAnimMode.orbital3D, // Mode 1: 3D Keplerian Celestial Orbit with Radiant Comet Star Tails
          onTap: () => setState(() => _iconAnimMode = 0),
        );
    }
  }
}
