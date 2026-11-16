import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'icons/lifeuse_icon.dart';

/// Data descriptor for each item in the LifeUse Floating Capsule Navigation.
class LifeUseNavigationItemData {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final bool showDot;

  const LifeUseNavigationItemData({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.showDot = false,
  });
}

/// Custom Floating Pill Bottom Navigation Bar for LifeUse.
/// Inspired by premium floating navigation concepts:
/// - Floating capsule container with rounded corners and elevated soft shadow.
/// - Distinct rounded pill indicator behind the selected item.
/// - Clear distinction between Home (house) and Dashboard overview (metric grid).
/// - Dynamic unread notification dot on Alerts.
/// - Fixed height constraint preventing any viewport or body height collapse.
class LifeUseFloatingNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final List<LifeUseNavigationItemData> items;
  final double maxWidth;
  final double capsuleHeight;

  const LifeUseFloatingNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.items,
    this.maxWidth = 540,
    this.capsuleHeight = 66,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final capsuleBottomMargin = bottomPadding > 0 ? bottomPadding + 4 : 14.0;
    final totalWidgetHeight = capsuleHeight + capsuleBottomMargin + 8.0;

    // Capsule background & border (Amethyst Purple & OLED True Black)
    final capsuleBgColor = isDark ? const Color(0xFF0A0710) : Colors.white;
    final capsuleBorderColor =
        isDark ? const Color(0xFF2A2233) : const Color(0xFFEBE3F0);

    return SizedBox(
      height: totalWidgetHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            bottom: capsuleBottomMargin,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              height: capsuleHeight,
              decoration: BoxDecoration(
                color: capsuleBgColor,
                borderRadius: BorderRadius.circular(capsuleHeight / 2),
                border: Border.all(color: capsuleBorderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = currentIndex == index;

                  return Expanded(
                    child: LifeUseNavigationItem(
                      index: index,
                      item: item,
                      isSelected: isSelected,
                      onTap: () => onItemSelected(index),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An individual navigation item inside the floating capsule.
class LifeUseNavigationItem extends StatelessWidget {
  final int index;
  final LifeUseNavigationItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  const LifeUseNavigationItem({
    super.key,
    required this.index,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? const Color(0xFFC79BEF) : AppColors.primary;
    final inactiveColor =
        isDark ? const Color(0xFF8E8299) : const Color(0xFF756B82);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      splashColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: Colors.transparent,
      child: Center(
        child: LifeUseSelectedIndicator(
          isSelected: isSelected,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 36,
                child: Center(
                  child: LifeUseFloatingNavIcon(
                    icon: item.icon,
                    activeIcon: item.activeIcon,
                    isSelected: isSelected,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    showDot: item.showDot,
                    size: 19,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                  letterSpacing: isSelected ? 0.2 : 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The animated indicator wrapping the selected item inside the capsule.
class LifeUseSelectedIndicator extends StatelessWidget {
  final bool isSelected;
  final Widget child;

  const LifeUseSelectedIndicator({
    super.key,
    required this.isSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

/// Floating navigation icon with Soft 3D active pod and smooth scale transitions.
class LifeUseFloatingNavIcon extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final bool showDot;
  final double size;

  const LifeUseFloatingNavIcon({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    this.activeIcon,
    this.showDot = false,
    this.size = 19,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: LifeUseIcon.nav(
        icon,
        activeIcon: activeIcon,
        isSelected: isSelected,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        size: size,
        containerSize: 36,
        radius: 12,
        showDot: showDot,
      ),
    );
  }
}
