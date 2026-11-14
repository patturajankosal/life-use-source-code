import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

/// Clean coming soon placeholder screen for roadmap modules.
/// File: lib/core/widgets/coming_soon_screen.dart
class ComingSoonScreen extends StatelessWidget {
  final String moduleTitle;
  final String moduleDescription;
  final IconData icon;
  final Color accentColor;

  const ComingSoonScreen({
    super.key,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          moduleTitle,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor.withValues(alpha: isDark ? 0.20 : 0.10),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.35),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(icon, size: 38, color: accentColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'COMING SOON',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      moduleTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      moduleDescription,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppButton(
                      title: 'Back to Dashboard',
                      icon: LucideIcons.arrowLeft,
                      onPressed: () => Navigator.of(context).pop(),
                      height: 46,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
