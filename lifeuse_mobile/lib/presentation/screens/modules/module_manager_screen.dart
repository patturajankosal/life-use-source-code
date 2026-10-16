import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lifeuse_badge.dart';
import '../../state/module_provider.dart';
import '../dashboard/models/dashboard_module_item.dart';

/// Interactive Module Manager.
/// Provides dynamic module enabling, disabling, pinning, and instant launching.
class ModuleManagerScreen extends StatelessWidget {
  const ModuleManagerScreen({super.key});

  static void showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.85,
        child: ModuleManagerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moduleProvider = context.watch<ModuleProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    final allModules = moduleProvider.allModules;
    final enabledCount = moduleProvider.enabledCount;
    final pinnedCount = moduleProvider.pinnedCount;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Module Manager',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Reset'),
            onPressed: () {
              moduleProvider.resetToDefault();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Modules reset to default arrangement'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Module Management Overview Hero Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.tune_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dynamic Module Control',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Customize which modules appear on your home dashboard in real time.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      height: 1.35,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(height: 1, color: borderColor),
                        const SizedBox(height: 14),

                        // Stats counters
                        Row(
                          children: [
                            _buildStatPill(
                              context,
                              'Active on Dashboard',
                              '$enabledCount / ${allModules.length}',
                              AppColors.primary,
                              surfaceColor,
                              borderColor,
                            ),
                            const SizedBox(width: 10),
                            _buildStatPill(
                              context,
                              'Pinned to Top',
                              '$pinnedCount Pinned',
                              const Color(0xFFF59E0B),
                              surfaceColor,
                              borderColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 2. Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Life Management Modules',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const LifeUseBadge(
                        text: '10 MODULES',
                        variant: LifeUseBadgeVariant.active,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 3. Dynamic Module Tiles List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allModules.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final module = allModules[i];
                      return _buildModuleItemTile(
                        context,
                        module,
                        moduleProvider,
                        surfaceColor,
                        borderColor,
                        textPrimary,
                        textSecondary,
                        isDark,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(
    BuildContext context,
    String label,
    String value,
    Color color,
    Color surfaceColor,
    Color borderColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleItemTile(
    BuildContext context,
    DashboardModuleItem module,
    ModuleProvider provider,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: module.isEnabled
            ? surfaceColor
            : (isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.02)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: module.isEnabled
              ? (module.isPinned ? module.accentColor.withValues(alpha: 0.5) : borderColor)
              : borderColor.withValues(alpha: 0.4),
          width: module.isPinned ? 1.4 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Module Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: module.isEnabled
                  ? module.accentColor.withValues(alpha: isDark ? 0.16 : 0.1)
                  : borderColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              module.icon,
              size: 22,
              color: module.isEnabled ? module.accentColor : textSecondary,
            ),
          ),
          const SizedBox(width: 14),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        module.title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: module.isEnabled ? textPrimary : textSecondary,
                        ),
                      ),
                    ),
                    if (module.isPinned) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.push_pin_rounded, size: 14, color: Color(0xFFF59E0B)),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${module.category} • ${module.subtitle}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Pin Button
          IconButton(
            icon: Icon(
              module.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
              size: 19,
              color: module.isPinned ? const Color(0xFFF59E0B) : textSecondary,
            ),
            tooltip: module.isPinned ? 'Unpin from Top' : 'Pin to Top of Dashboard',
            onPressed: () => provider.togglePin(module.id),
          ),

          // Open Micro-App button
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, size: 19),
            tooltip: 'Launch ${module.title}',
            color: module.accentColor,
            onPressed: () => provider.launchModule(context, module),
          ),

          // Enable / Disable Switch
          Switch(
            value: module.isEnabled,
            activeThumbColor: module.accentColor,
            onChanged: (_) => provider.toggleModule(module.id),
          ),
        ],
      ),
    );
  }
}
