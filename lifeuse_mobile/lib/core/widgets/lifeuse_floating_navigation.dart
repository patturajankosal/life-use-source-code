import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
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

/// Floating capsule navigation with a single gliding amethyst pill.
///
/// - One pill slides between destinations instead of each item toggling
///   its own background, which feels smoother and costs less to animate.
/// - The active glyph + label turn white on the pill; inactive items stay
///   quiet and show an unread dot where needed.
/// - Safe-area aware: the capsule floats above the system gesture bar.
/// - [LifeUseFloatingNavigation.heightFor] exposes the occupied height so
///   screens can reserve exactly that much bottom padding.
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
    this.capsuleHeight = 68,
  });

  /// Total vertical space the navigation occupies for the given context.
  static double heightFor(BuildContext context, {double capsuleHeight = 68}) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final margin = bottomPadding > 0 ? bottomPadding + 4 : 14.0;
    return capsuleHeight + margin + 8.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final capsuleBottomMargin = bottomPadding > 0 ? bottomPadding + 4 : 14.0;
    final totalHeight = capsuleHeight + capsuleBottomMargin + 8.0;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final slide =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 320);

    final capsuleBg = isDark ? const Color(0xFF0F0A17) : Colors.white;
    final capsuleBorder =
        isDark ? const Color(0xFF2A2233) : const Color(0xFFEBE3F0);

    // Pill only needs one count: fixed padding inside the capsule.
    const innerPad = 6.0;
    final count = items.length;

    return SizedBox(
      height: totalHeight,
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
              padding: const EdgeInsets.all(innerPad),
              decoration: BoxDecoration(
                color: capsuleBg,
                borderRadius: BorderRadius.circular(capsuleHeight / 2),
                border: Border.all(color: capsuleBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary
                        .withValues(alpha: isDark ? 0.20 : 0.14),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final slotWidth = constraints.maxWidth / count;
                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: slide,
                        curve: Curves.easeOutBack,
                        left: slotWidth * currentIndex,
                        top: 0,
                        bottom: 0,
                        width: slotWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  (capsuleHeight - innerPad * 2) / 2),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF9B4DCA),
                                  Color(0xFF6A2A92),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.38),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(count, (index) {
                          return Expanded(
                            child: LifeUseNavigationItem(
                              item: items[index],
                              isSelected: currentIndex == index,
                              onTap: () {
                                if (currentIndex != index) {
                                  HapticFeedback.selectionClick();
                                }
                                onItemSelected(index);
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single destination inside the floating capsule.
class LifeUseNavigationItem extends StatelessWidget {
  final LifeUseNavigationItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  const LifeUseNavigationItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor =
        isDark ? const Color(0xFF8E8299) : const Color(0xFF756B82);

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        highlightShape: BoxShape.rectangle,
        splashColor: AppColors.primary.withValues(alpha: 0.10),
        highlightColor: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: LifeUseIcon.nav(
                  item.icon,
                  activeIcon: item.activeIcon,
                  isSelected: isSelected,
                  activeColor: Colors.white,
                  inactiveColor: inactiveColor,
                  size: 20,
                  containerSize: 30,
                  showDot: item.showDot,
                ),
              ),
              // Labels never scale past 1.0 so the capsule height stays fixed.
              MediaQuery.withClampedTextScaling(
                maxScaleFactor: 1.0,
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    height: 1.1,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : inactiveColor,
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
