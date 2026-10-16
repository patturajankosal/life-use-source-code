import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Reusable segmented tab pill switcher for LifeUse:
/// - Inactive: Inter 12px w700, color #808080 (Dark: #B3B3B3)
/// - Active Pill: Purple #C084FC / #A855F7, White text, 0 1px 2px shadow
/// File: lib/core/widgets/lifeuse_filter_tabs.dart
class LifeUseFilterTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const LifeUseFilterTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final containerBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final containerBorder = isDark ? const Color(0xFF333333) : const Color(0xFFE7E8EC);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: containerBorder, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: isSelected
                    ? Border.all(color: AppColors.purple400, width: 1.0)
                    : null,
                boxShadow: isSelected
                    ? const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                tabs[index],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 20 / 12,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? const Color(0xFFB3B3B3) : const Color(0xFF808080)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
