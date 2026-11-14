import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

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
              LifeUseFloatingNavIcon(
                icon: (isSelected && item.activeIcon != null)
                    ? item.activeIcon!
                    : item.icon,
                isSelected: isSelected,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                showDot: item.showDot,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
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

/// The animated pill indicator wrapping the selected item inside the capsule.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Active pill background: Tonal purple from Amethyst Light & OLED True Black tokens
    final activeBg = isDark
        ? const Color(0xFF2A1838)
        : const Color(0xFFF5ECFA);
    final activeBorder = isDark
        ? const Color(0xFF3D2550)
        : const Color(0xFFEBE3F0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? activeBorder : Colors.transparent,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

/// Floating navigation icon with smooth scale transitions and reactive notification badge.
class LifeUseFloatingNavIcon extends StatelessWidget {
  final IconData icon;
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
    this.showDot = false,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? activeColor : inactiveColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScale(
      scale: isSelected ? 1.06 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            size: size,
            color: color,
          ),
          if (showDot)
            Positioned(
              top: -1,
              right: -3,
              child: Container(
                width: 7.5,
                height: 7.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF111827) : Colors.white,
                    width: 1.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
