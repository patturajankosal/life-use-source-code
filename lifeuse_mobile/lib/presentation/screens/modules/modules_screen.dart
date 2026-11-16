import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../dashboard/models/dashboard_module_item.dart';
import '../dashboard/widgets/module_card.dart';

/// Clean modules catalog screen displaying all 10 hardcoded Life Management modules.
/// Uses Premium Minimal tokens, Lucide filter badges, and smooth micro-interactions.
class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  String _selectedCategory =
      'ALL'; // ALL, Finance, Productivity, Lifestyle, Security, Education, Planning

  final List<String> _categories = [
    'ALL',
    'Finance',
    'Productivity',
    'Lifestyle',
    'Education',
    'Security',
    'Planning',
  ];

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Finance':
        return AppIcons.moneyManager;
      case 'Productivity':
        return AppIcons.dailyTasks;
      case 'Lifestyle':
        return AppIcons.healthWellness;
      case 'Education':
        return AppIcons.examsLearning;
      case 'Security':
        return AppIcons.documentsVault;
      case 'Planning':
        return AppIcons.personalPlanning;
      default:
        return AppIcons.modulesOutline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    final allModules = HardcodedModuleItem.hardcodedModules;

    final filteredModules = allModules.where((m) {
      if (_selectedCategory != 'ALL' && m.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Life Management Suite',
          style: AppFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.badgeBgOf(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderOf(context),
              ),
            ),
            child: Center(
              child: Text(
                '10 MODULES',
                style: AppFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.badgeTextOf(context),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore All Modules',
                    style: AppFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap any module below to launch its dedicated micro-application.',
                    style: AppFonts.inter(
                      fontSize: 12.5,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            avatar: Icon(
                              _categoryIcon(cat),
                              size: 16,
                              color: isSelected ? Colors.white : textSecondary,
                            ),
                            selected: isSelected,
                            label: Text(cat),
                            labelStyle: AppFonts.inter(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected ? Colors.white : textSecondary,
                            ),
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surfaceOf(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.borderOf(context),
                              ),
                            ),
                            onSelected: (_) {
                              setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Responsive 2 or 3-column Grid of Hardcoded Modules
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      final isTablet = constraints.maxWidth >= 600;
                      final crossAxisCount = isTablet ? 3 : 2;
                      final childAspectRatio = isTablet ? 1.25 : 1.06;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredModules.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (ctx, index) {
                          final mod = filteredModules[index];
                          return ModuleCard(
                            module: mod,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: mod.screenBuilder),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  // Extra bottom padding for floating navigation bar clearance
                  const SizedBox(height: 100),
                ],
              ),
            ).animate().fadeIn(duration: 250.ms),
          ),
        ),
      ),
    );
  }
}
