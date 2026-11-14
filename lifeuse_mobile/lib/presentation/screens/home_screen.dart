import 'package:flutter/material.dart';
import '../navigation/main_navigation_shell.dart';

/// Legacy HomeScreen wrapper redirected to MainNavigationShell.
/// Preserves backward compatibility while ensuring users access the full application dashboard.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainNavigationShell();
  }
}
