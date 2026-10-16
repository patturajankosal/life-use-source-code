import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'data/services/api_client.dart';
import 'data/services/auth_service.dart';
import 'data/services/money_service.dart';
import 'presentation/navigation/main_navigation_shell.dart';
import 'presentation/state/auth_provider.dart';
import 'presentation/state/money_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final authService = AuthService(apiClient);
  final authProvider = AuthProvider(authService);
  final moneyService = MoneyService(apiClient);
  final moneyProvider = MoneyProvider(moneyService);
  final themeProvider = ThemeProvider();

  // Restore stored session if exists
  await authProvider.checkSession();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        Provider<AuthService>.value(value: authService),
        Provider<MoneyService>.value(value: moneyService),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<MoneyProvider>.value(value: moneyProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
      ],
      child: const LifeUseApp(),
    ),
  );
}

class LifeUseApp extends StatelessWidget {
  const LifeUseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'LifeUse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: theme.themeMode,
      home: const MainNavigationShell(),
    );
  }
}
