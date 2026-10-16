import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../screens/activity/activity_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/modules/modules_screen.dart';
import '../screens/money/money_manager_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/profile/profile_screen.dart';

/// Enterprise application shell providing persistent bottom navigation across 5 core views:
/// - Home (Dashboard)
/// - Modules (10-micro-app suite)
/// - Activity (Daily tasks & habits)
/// - Notifications (Alerts & reminders)
/// - Profile (Account details, security & auth)
///
/// Implements IndexedStack for zero-latency tab switching and preserves state.
class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({
    super.key,
    this.initialIndex = 0,
  });

  /// Static helper to trigger programmatic tab transitions from any descendant widget
  static void switchTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationShellState>();
    state?.setTab(index);
  }

  /// Static helper to open full Money Manager micro-app with back navigation
  static void openMoneyManager(BuildContext context, {int initialTabIndex = 0}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MoneyManagerScreen(initialTabIndex: initialTabIndex),
      ),
    );
  }

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ModulesScreen(),
    ActivityScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _screens.length - 1);
  }

  void setTab(int index) {
    if (index >= 0 && index < _screens.length && _currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(
            top: BorderSide(color: borderColor, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      label: 'Home',
                      activeIcon: Icons.dashboard_rounded,
                      inactiveIcon: Icons.dashboard_outlined,
                    ),
                    _buildNavItem(
                      index: 1,
                      label: 'Modules',
                      activeIcon: Icons.grid_view_rounded,
                      inactiveIcon: Icons.grid_view_outlined,
                    ),
                    _buildNavItem(
                      index: 2,
                      label: 'Activity',
                      activeIcon: Icons.check_circle_rounded,
                      inactiveIcon: Icons.check_circle_outline_rounded,
                    ),
                    _buildNavItem(
                      index: 3,
                      label: 'Alerts',
                      activeIcon: Icons.notifications_rounded,
                      inactiveIcon: Icons.notifications_none_rounded,
                      showDot: true,
                    ),
                    _buildNavItem(
                      index: 4,
                      label: 'Profile',
                      activeIcon: Icons.person_rounded,
                      inactiveIcon: Icons.person_outline_rounded,
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

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
    bool showDot = false,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.textTertiaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () => setTab(index),
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? activeIcon : inactiveIcon,
                    size: 21,
                    color: color,
                  ),
                  if (showDot && !isSelected)
                    Positioned(
                      top: 0,
                      right: -3,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
