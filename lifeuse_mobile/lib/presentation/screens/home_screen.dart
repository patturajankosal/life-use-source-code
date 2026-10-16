import 'package:flutter/material.dart';
import '../navigation/main_navigation_shell.dart';

/// Central Home Screen for LifeUse.
/// Directly renders the enterprise MainNavigationShell containing:
/// - Tab 0: Dashboard (Integrated with Money Manager)
/// - Tab 1: Money Manager (Full 4-tab financial suite)
/// - Tab 2: Modules (Enterprise modules catalog)
/// - Tab 3: Account Profile (User identity, security, API health)
class HomeScreen extends StatelessWidget {
  final int initialIndex;

  const HomeScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return MainNavigationShell(initialIndex: initialIndex);
  }
}
