import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lifeuse_badge.dart';
import '../../navigation/main_navigation_shell.dart';
import '../../state/money_provider.dart';
import '../dashboard/models/dashboard_module_item.dart';
import '../dashboard/widgets/module_card.dart';

/// Enterprise application modules catalog and launcher screen.
/// Displays all 10 life management modules within LifeUse categorized cleanly.
class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  String _selectedStatusFilter = 'ALL'; // ALL, ACTIVE, ROADMAP
  String _selectedCategory = 'ALL'; // ALL, Finance, Productivity, Lifestyle, Personal Admin

  Widget _buildMoneyManagerPreview(BuildContext context) {
    final money = context.watch<MoneyProvider>();
    final daily = money.dailyLimit;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = AppColors.textSecondaryOf(context);

    if (daily == null || daily.recommendedDailyLimit == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            const Icon(Icons.bolt_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Live Backend Connected • Tap to launch financial hub',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remaining Allowance',
                style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${daily.remainingTodayAllowance.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: daily.remainingTodayAllowance >= 0
                      ? AppColors.primary
                      : AppColors.error,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Spent Today',
                style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${daily.spentToday.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onModuleTap(BuildContext context, DashboardModuleItem module) {
    if (module.isActive) {
      MainNavigationShell.openMoneyManager(context);
    } else {
      _showModuleRoadmapModal(context, module);
    }
  }

  void _showModuleRoadmapModal(BuildContext context, DashboardModuleItem module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final surfaceColor = AppColors.surfaceOf(ctx);
        final borderColor = AppColors.borderOf(ctx);
        final textPrimary = AppColors.textPrimaryOf(ctx);
        final textSecondary = AppColors.textSecondaryOf(ctx);

        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: module.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: module.accentColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(module.icon, size: 24, color: module.accentColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          module.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: module.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const LifeUseBadge(
                    text: 'IN DEVELOPMENT',
                    variant: LifeUseBadgeVariant.pending,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                module.description,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.5,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Planned Capabilities',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: module.highlights.map((h) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: module.accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: module.accentColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, size: 14, color: module.accentColor),
                        const SizedBox(width: 6),
                        Text(
                          h,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Got It',
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    final allModules = DashboardModuleItem.getRegistry(
      moneyPreviewBuilder: (ctx) => _buildMoneyManagerPreview(ctx),
    );

    final filteredModules = allModules.where((m) {
      if (_selectedStatusFilter == 'ACTIVE' && !m.isActive) return false;
      if (_selectedStatusFilter == 'ROADMAP' && m.isActive) return false;
      if (_selectedCategory != 'ALL' && m.category != _selectedCategory) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Life Management Suite',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: LifeUseBadge(
                text: '1 LIVE • 9 ROADMAP',
                variant: LifeUseBadgeVariant.active,
              ),
            ),
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
                  // 1. Enterprise Hub Intro Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.dashboard_customize_rounded,
                            size: 22,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unified Life Modules',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Manage personal finances, daily habits, health routines, and life planning.',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Status Filter Pills
                  Row(
                    children: [
                      _buildFilterChip(
                        isSelected: _selectedStatusFilter == 'ALL',
                        label: 'All (${allModules.length})',
                        onTap: () => setState(() => _selectedStatusFilter = 'ALL'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        isSelected: _selectedStatusFilter == 'ACTIVE',
                        label: 'Live (1)',
                        onTap: () => setState(() => _selectedStatusFilter = 'ACTIVE'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        isSelected: _selectedStatusFilter == 'ROADMAP',
                        label: 'Roadmap (9)',
                        onTap: () => setState(() => _selectedStatusFilter = 'ROADMAP'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 3. Category Horizontal Scroll
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip('ALL', 'All Domains'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Finance', 'Finance'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Productivity', 'Productivity'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Lifestyle', 'Lifestyle'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Personal Admin', 'Personal Admin'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Modules List (Responsive)
                  if (filteredModules.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: Text(
                          'No modules found matching this filter.',
                          style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                        ),
                      ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 640) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    for (int i = 0; i < filteredModules.length; i += 2) ...[
                                      ModuleCard(
                                        module: filteredModules[i],
                                        onTap: () => _onModuleTap(context, filteredModules[i]),
                                      ),
                                      if (i + 2 < filteredModules.length)
                                        const SizedBox(height: 14),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  children: [
                                    for (int i = 1; i < filteredModules.length; i += 2) ...[
                                      ModuleCard(
                                        module: filteredModules[i],
                                        onTap: () => _onModuleTap(context, filteredModules[i]),
                                      ),
                                      if (i + 2 < filteredModules.length)
                                        const SizedBox(height: 14),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredModules.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
                          itemBuilder: (ctx, i) {
                            final module = filteredModules[i];
                            return ModuleCard(
                              module: module,
                              onTap: () => _onModuleTap(context, module),
                            );
                          },
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

  Widget _buildFilterChip({
    required bool isSelected,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderOf(context),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondaryOf(context),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String catKey, String label) {
    final isSelected = _selectedCategory == catKey;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = catKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderOf(context),
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textSecondaryOf(context),
          ),
        ),
      ),
    );
  }
}
