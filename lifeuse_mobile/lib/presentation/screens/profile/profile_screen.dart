import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/config/api_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../core/widgets/lifeuse_badge.dart';
import '../../../core/widgets/lifeuse_stat_card.dart';
import '../../navigation/main_navigation_shell.dart';
import '../../state/auth_provider.dart';
import '../login_screen.dart';
import '../register_screen.dart';

/// Clean minimalist profile & enterprise settings tab.
/// Supports both Authenticated user mode and Guest Explorer mode without blocking the app.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final textPrimary = AppColors.textPrimaryOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const AppIcon(AppIcons.arrowLeft, size: 22),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          user != null ? 'Account Profile' : 'Guest Account',
          style: AppFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: [
          if (user != null)
            IconButton(
              icon: const AppIcon(AppIcons.logOut, size: 22),
              tooltip: 'Sign Out',
              onPressed: () => _confirmLogout(context),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: user != null
                  ? _buildAuthenticatedContent(context, user)
                  : _buildGuestContent(context),
            ),
          ),
        ).animate().fadeIn(duration: 250.ms),
      ),
    );
  }

  /// View when user is logged in
  Widget _buildAuthenticatedContent(
    BuildContext context,
    dynamic user,
  ) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. User Profile Header Card
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: user.roleColor.withValues(alpha: 0.15),
                  border: Border.all(color: user.roleColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : 'U',
                    style: AppFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: user.roleColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.fullName,
                style: AppFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@${user.username}',
                style: AppFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              LifeUseBadge(
                text: 'ROLE: ${user.roleDisplay.toUpperCase()}',
                variant: LifeUseBadgeVariant.active,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 2. Stat Cards Grid
        const Row(
          children: [
            Expanded(
              child: LifeUseStatCard(
                label: 'Security Level',
                value: 'Enterprise',
                subtitle: 'AES-256 / JWT',
                variant: LifeUseStatVariant.purple,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: LifeUseStatCard(
                label: 'Account Status',
                value: 'Active',
                subtitle: 'Workspace connected',
                variant: LifeUseStatVariant.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 3. Account Information Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(
            'Account Information',
            style: AppFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textSecondary,
              letterSpacing: 0.1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                context: context,
                icon: AppIcons.userCheck,
                label: 'User ID',
                value: '#${user.id}',
              ),
              Divider(height: 1, color: borderColor),
              _buildDetailRow(
                context: context,
                icon: AppIcons.mail,
                label: 'Email address',
                value: user.email,
                trailing: _buildVerificationBadge(user.emailVerified),
              ),
              Divider(height: 1, color: borderColor),
              _buildDetailRow(
                context: context,
                icon: AppIcons.phone,
                label: 'Phone number',
                value: user.phoneNumber,
                trailing: _buildVerificationBadge(user.phoneVerified),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 4. Backend Connection Card
        _buildBackendConnectionCard(context),
        const SizedBox(height: 28),

        // 5. Sign Out Button
        AppButton(
          title: 'Sign Out',
          isOutlined: true,
          icon: AppIcons.logOut,
          onPressed: () => _confirmLogout(context),
        ),
        // Extra clearance for floating navigation capsule
        const SizedBox(height: 100),
      ],
    );
  }

  /// View when user is in guest mode (unauthenticated)
  Widget _buildGuestContent(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Guest Avatar & CTA Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.iconBackgroundOf(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.iconBorderOf(context),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: AppIcon(
                    AppIcons.profileOutline,
                    size: 32,
                    color: AppColors.brandIconOf(context),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Guest Explorer Mode',
                style: AppFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign in or create an account to access persistent cloud sync, personal finance records, and daily habits.',
                textAlign: TextAlign.center,
                style: AppFonts.inter(
                  fontSize: 13,
                  height: 1.45,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              const LifeUseBadge(
                text: 'STATUS: PREVIEW MODE',
                variant: LifeUseBadgeVariant.pending,
              ),
              const SizedBox(height: 22),

              // Action buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const AppIcon(AppIcons.logIn,
                      size: 20, color: Colors.white),
                  label: Text(
                    'Sign In to LifeUse',
                    style: AppFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon:
                      AppIcon(AppIcons.userPlus, size: 20, color: textPrimary),
                  label: Text(
                    'Create New Account',
                    style: AppFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textPrimary,
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2. Feature highlights
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enterprise Features with Account',
                style: AppFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildFeatureRow(
                context,
                AppIcons.moneyManager,
                'Money Manager Sync',
                'Live PostgreSQL backend integration for expense budgets',
              ),
              const SizedBox(height: 10),
              _buildFeatureRow(
                context,
                AppIcons.documentsVault,
                'Zero-Knowledge Security',
                'Encrypted JWT sessions and BCrypt credential hashing',
              ),
              const SizedBox(height: 10),
              _buildFeatureRow(
                context,
                AppIcons.category,
                'Cross-Device Synchronization',
                'Pick up where you left off on web, tablet, or phone',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3. Backend status
        _buildBackendConnectionCard(context),
        // Extra clearance for floating navigation capsule
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildFeatureRow(
    BuildContext context,
    IconData icon,
    String title,
    String desc,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF262626) : const Color(0xFFF4F4F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.borderOf(context),
              width: 0.8,
            ),
          ),
          child: Center(
            child: AppIcon(icon, size: 20, color: AppColors.iconOf(context)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: AppFonts.inter(
                  fontSize: 11.5,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackendConnectionCard(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Spring Boot API Connection',
                style: AppFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Active Base URL: ${ApiConfig.baseUrl}',
            style: AppFonts.inter(
              fontSize: 12,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          AppIcon(icon, size: 20, color: AppColors.textSecondaryOf(context)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppFonts.inter(
                    fontSize: 12,
                    color: AppColors.textTertiaryOf(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildVerificationBadge(bool isVerified) {
    return LifeUseBadge(
      text: isVerified ? 'Verified' : 'Pending',
      variant:
          isVerified ? LifeUseBadgeVariant.active : LifeUseBadgeVariant.pending,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(context),
        title: Text(
          'Sign Out',
          style: AppFonts.inter(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        content: Text(
          'Are you sure you want to sign out of LifeUse?',
          style: AppFonts.inter(
            color: AppColors.textSecondaryOf(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(80, 40),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                MainNavigationShell.switchTab(context, 0);
              }
            },
            child: Text(
              'Sign Out',
              style: AppFonts.inter(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
