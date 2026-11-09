import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/lifeuse_floating_navigation.dart';
import '../screens/activity/activity_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/modules/modules_screen.dart';
import '../screens/money/money_manager_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../state/notification_provider.dart';

/// Enterprise application shell providing persistent bottom navigation across 5 core views:
/// - Home (Dashboard)
/// - Modules (10-micro-app suite)
/// - Activity (Daily tasks & habits)
/// - Notifications (Alerts & reminders)
/// - Profile (Account details, security & auth)
///
/// Implements IndexedStack for zero-latency tab switching and preserves state.
/// Supports smooth Android back-button interception (returns to Dashboard before app exit).
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
    final hasUnreadAlerts = context.watch<NotificationProvider>().hasUnread;

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        extendBody: true,
        body: SizedBox.expand(
          child: IndexedStack(
            index: _currentIndex,
            sizing: StackFit.expand,
            children: _screens,
          ),
        ),
        bottomNavigationBar: LifeUseFloatingNavigation(
          currentIndex: _currentIndex,
          onItemSelected: setTab,
          items: [
            const LifeUseNavigationItemData(
              label: 'Home',
              icon: LucideIcons.home,
            ),
            const LifeUseNavigationItemData(
              label: 'Modules',
              icon: LucideIcons.layoutGrid,
            ),
            const LifeUseNavigationItemData(
              label: 'Activity',
              icon: LucideIcons.activity,
            ),
            LifeUseNavigationItemData(
              label: 'Alerts',
              icon: LucideIcons.bell,
              showDot: hasUnreadAlerts,
            ),
            const LifeUseNavigationItemData(
              label: 'Profile',
              icon: LucideIcons.user,
            ),
          ],
        ),
      ),
    );
  }
}
