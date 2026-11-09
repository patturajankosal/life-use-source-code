import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
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
  String _selectedCategory = 'ALL'; // ALL, Finance, Productivity, Lifestyle, Security, Education, Planning

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
        return LucideIcons.wallet;
      case 'Productivity':
        return LucideIcons.checkSquare;
      case 'Lifestyle':
        return LucideIcons.heartPulse;
      case 'Education':
        return LucideIcons.graduationCap;
      case 'Security':
        return LucideIcons.shieldCheck;
      case 'Planning':
        return LucideIcons.compass;
      default:
        return LucideIcons.layoutGrid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allModules = HardcodedModuleItem.hardcodedModules;

    final filteredModules = allModules.where((m) {
      if (_selectedCategory != 'ALL' && m.category != _selectedCategory) return false;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Life Management Suite',
          style: GoogleFonts.plusJakartaSans(
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
              color: AppColors.primary.withValues(alpha: isDark ? 0.16 : 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Center(
              child: Text(
                '10 MODULES',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore All Modules',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap any module below to launch its dedicated micro-application.',
                    style: GoogleFonts.inter(
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
                              size: 14,
                              color: isSelected ? Colors.white : textSecondary,
                            ),
                            selected: isSelected,
                            label: Text(cat),
                            labelStyle: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
                      final childAspectRatio = isTablet ? 1.3 : 1.15;

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
