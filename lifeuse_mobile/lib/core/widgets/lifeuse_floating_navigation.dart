import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'icons/lifeuse_icon.dart';

/// Data descriptor for each item in the LifeUse floating navigation.
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

/// Floating capsule navigation featuring an animated expanded active pill.
///
/// Follows the reference design:
/// - Active tab: expands horizontally into a rounded pill showing [Icon + 8px + Label]
/// - Inactive tabs: compact icon-only presentation
/// - Light Mode: White capsule background (#FFFFFF), dark neutral active pill (#18181B)
///   with crisp white icon and label; dark neutral inactive icons (#71717A).
/// - Dark Mode: Dark neutral capsule (#1E1E1E), light neutral active pill (#F4F4F5)
///   with dark icon and label (#18181B); light neutral inactive icons (#A1A1AA).
/// - Zero purple-filled active navigation background.
/// - Safe-area aware floating capsule.
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
    this.maxWidth = 520,
    this.capsuleHeight = 68,
  });

  /// Total vertical space the navigation occupies for the given context.
  static double heightFor(BuildContext context, {double capsuleHeight = 68}) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final margin = bottomPadding > 0 ? bottomPadding + 6 : 16.0;
    return capsuleHeight + margin + 10.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final capsuleBottomMargin = bottomPadding > 0 ? bottomPadding + 6 : 16.0;
    final totalHeight = capsuleHeight + capsuleBottomMargin + 10.0;

    final capsuleBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final capsuleBorder =
        isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5);

    return SizedBox(
      height: totalHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: 14,
            bottom: capsuleBottomMargin,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              height: capsuleHeight,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: capsuleBg,
                borderRadius: BorderRadius.circular(capsuleHeight / 2),
                border: Border.all(color: capsuleBorder, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  return _NavigationTabItem(
                    item: items[index],
                    isSelected: currentIndex == index,
                    isDark: isDark,
                    onTap: () {
                      if (currentIndex != index) {
                        HapticFeedback.selectionClick();
                      }
                      onItemSelected(index);
                    },
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

class _NavigationTabItem extends StatelessWidget {
  final LifeUseNavigationItemData item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavigationTabItem({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colors matching established LifeUse rules:
    // Light Mode: Dark neutral active pill (#18181B) with white text & icon
    // Dark Mode: Light neutral active pill (#F4F4F5) with dark text & icon (#18181B)
    final activePillColor =
        isDark ? const Color(0xFFF4F4F5) : const Color(0xFF18181B);
    final activeTextColor = isDark ? const Color(0xFF18181B) : Colors.white;
    final inactiveIconColor =
        isDark ? const Color(0xFFA1A1AA) : const Color(0xFF71717A);

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 18 : 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? activePillColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.25 : 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LifeUseIcon.nav(
                item.icon,
                isSelected: isSelected,
                activeIcon: item.activeIcon,
                activeColor: activeTextColor,
                inactiveColor: inactiveIconColor,
                size: 25,
                containerSize: 26,
                showDot: item.showDot && !isSelected,
              ),
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  child: isSelected
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: activeTextColor,
                              letterSpacing: -0.2,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                          child: OverflowBox(
                            minWidth: 0,
                            maxWidth: 80,
                            minHeight: 0,
                            maxHeight: 20,
                            child: Opacity(
                              opacity: 0,
                              child: Text(
                                item.label,
                                style: AppFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: activeTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
