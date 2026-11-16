import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lifeuse_mobile/main.dart';
import 'package:lifeuse_mobile/core/theme/theme_provider.dart';
import 'package:lifeuse_mobile/core/widgets/app_button.dart';
import 'package:lifeuse_mobile/core/widgets/app_empty_state.dart';
import 'package:lifeuse_mobile/core/widgets/app_error_state.dart';
import 'package:lifeuse_mobile/core/widgets/app_loading.dart';
import 'package:lifeuse_mobile/core/widgets/app_section_title.dart';
import 'package:lifeuse_mobile/core/widgets/lifeuse_floating_navigation.dart';
import 'package:lifeuse_mobile/data/models/api_response.dart';
import 'package:lifeuse_mobile/data/models/login_response.dart';
import 'package:lifeuse_mobile/data/services/api_client.dart';
import 'package:lifeuse_mobile/data/services/auth_service.dart';
import 'package:lifeuse_mobile/data/services/money_service.dart';
import 'package:lifeuse_mobile/presentation/screens/dashboard/models/dashboard_module_item.dart';
import 'package:lifeuse_mobile/presentation/screens/dashboard/widgets/animated_hero_banner.dart';
import 'package:lifeuse_mobile/presentation/screens/dashboard/widgets/bento_life_overview.dart';
import 'package:lifeuse_mobile/presentation/state/auth_provider.dart';
import 'package:lifeuse_mobile/presentation/state/money_provider.dart';
import 'package:lifeuse_mobile/presentation/state/notification_provider.dart';

void main() {
  testWidgets(
      'LifeUse app smoke test - opens directly to hardcoded Dashboard in Guest Mode',
      (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authService = AuthService(apiClient);
    final authProvider = AuthProvider(authService);
    final moneyService = MoneyService(apiClient);
    final moneyProvider = MoneyProvider(moneyService);
    final themeProvider = ThemeProvider();
    final notificationProvider = NotificationProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: apiClient),
          Provider<AuthService>.value(value: authService),
          Provider<MoneyService>.value(value: moneyService),
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<MoneyProvider>.value(value: moneyProvider),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<NotificationProvider>.value(
              value: notificationProvider),
        ],
        child: const LifeUseApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify application starts directly on Dashboard with hardcoded modules in Guest Mode
    expect(find.textContaining('Guest Explorer'), findsOneWidget);
    expect(find.text('Money Manager'), findsWidgets);
    expect(find.text('Explore modules'), findsOneWidget);
  });

  testWidgets('Reusable UI Components render smoothly across variants',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppButton(title: 'Primary Action', onPressed: () {}),
                AppButton.secondary(
                    title: 'Secondary Action', onPressed: () {}),
                AppButton.outlined(title: 'Outlined Action', onPressed: () {}),
                AppButton.destructive(
                    title: 'Destructive Action', onPressed: () {}),
                const AppLoading(message: 'Loading financial profile...'),
                const AppEmptyState(
                  icon: LucideIcons.receipt,
                  title: 'No Transactions',
                  description: 'Record your first transaction to get started.',
                ),
                const AppErrorState(
                  title: 'Network Issue',
                  message: 'Could not connect to backend server.',
                ),
                const AppSectionTitle(
                  title: 'Recent Activity',
                  subtitle: 'Latest transactions and logs',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Primary Action'), findsOneWidget);
    expect(find.text('Secondary Action'), findsOneWidget);
    expect(find.text('Outlined Action'), findsOneWidget);
    expect(find.text('Destructive Action'), findsOneWidget);
    expect(find.text('Loading financial profile...'), findsOneWidget);
    expect(find.text('No Transactions'), findsOneWidget);
    expect(find.text('Network Issue'), findsOneWidget);
    expect(find.text('Recent Activity'), findsOneWidget);
  });

  test('HardcodedModuleItem contains all 10 standard life modules', () {
    final modules = HardcodedModuleItem.hardcodedModules;
    expect(modules.length, equals(10));

    final ids = modules.map((m) => m.id).toList();
    expect(
        ids,
        containsAll([
          'money_manager',
          'home_management',
          'daily_tasks',
          'health_wellness',
          'bills_payments',
          'notifications',
          'tickets_travel',
          'exams_learning',
          'documents_vault',
          'personal_planning',
        ]));
  });

  test('ApiResponse parses double timestamp without TypeError', () {
    final json = {
      'success': true,
      'message': 'Login successful',
      'data': {
        'accessToken': 'jwt.token.here',
        'refreshToken': 'jwt.refresh.here',
        'tokenType': 'Bearer',
        'expiresIn': 900000,
        'userId': 1,
        'username': 'testuser',
        'email': 'test@lifeuse.com',
        'role': 'ROLE_USER',
      },
      'timestamp': 1791800077.4560094,
    };

    final response = ApiResponse.fromJson(
      json,
      (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
    );

    expect(response.success, isTrue);
    expect(response.message, equals('Login successful'));
    expect(response.timestamp, equals('1791800077.4560094'));
    expect(response.data?.accessToken, equals('jwt.token.here'));
    expect(response.data?.user.username, equals('testuser'));
    expect(response.data?.user.id, equals(1));
  });

  testWidgets(
      'MainNavigationShell renders 5 items and reactively updates Alerts notification dot',
      (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authService = AuthService(apiClient);
    final authProvider = AuthProvider(authService);
    final moneyService = MoneyService(apiClient);
    final moneyProvider = MoneyProvider(moneyService);
    final themeProvider = ThemeProvider();
    final notificationProvider = NotificationProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: apiClient),
          Provider<AuthService>.value(value: authService),
          Provider<MoneyService>.value(value: moneyService),
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<MoneyProvider>.value(value: moneyProvider),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<NotificationProvider>.value(
              value: notificationProvider),
        ],
        child: const LifeUseApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify all 5 navigation items exist in the shell
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Modules'), findsWidgets);
    expect(find.text('Activity'), findsWidgets);
    expect(find.text('Alerts'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);

    // Initial state has unread notifications
    expect(notificationProvider.hasUnread, isTrue);

    // Tap on Alerts tab
    await tester.tap(find.text('Alerts'));
    await tester.pumpAndSettle();

    // Verify NotificationsScreen is now active
    expect(find.text('Notifications & Alerts'), findsOneWidget);
    expect(find.text('Mark All Read'), findsOneWidget);

    // Tap Mark All Read via provider
    notificationProvider.markAllAsRead();
    await tester.pumpAndSettle();

    // Verify notification state is cleared dynamically
    expect(notificationProvider.hasUnread, isFalse);
    expect(find.text('Mark All Read'), findsNothing);
  });

  testWidgets(
      'Intelligent Dashboard renders Direct Controls and handles Search filtering',
      (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authService = AuthService(apiClient);
    final authProvider = AuthProvider(authService);
    final moneyService = MoneyService(apiClient);
    final moneyProvider = MoneyProvider(moneyService);
    final themeProvider = ThemeProvider();
    final notificationProvider = NotificationProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: apiClient),
          Provider<AuthService>.value(value: authService),
          Provider<MoneyService>.value(value: moneyService),
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<MoneyProvider>.value(value: moneyProvider),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<NotificationProvider>.value(
              value: notificationProvider),
        ],
        child: const LifeUseApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Direct Controls quick actions exist
    expect(find.text('Record'), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);
    expect(find.text('Set Alert'), findsOneWidget);
    expect(find.text('Pay Bills'), findsOneWidget);

    // Verify Hero Zone greeting and banner
    expect(find.textContaining('Guest Explorer'), findsOneWidget);
    expect(find.text('Explore modules'), findsOneWidget);

    // Test Search input filtering by typing 'bills'
    await tester.enterText(find.byType(TextField), 'bills');
    await tester.pumpAndSettle();
    expect(find.text('Bills & Payments'), findsWidgets);

    // Clear search and verify it returns to main view
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('Record'), findsOneWidget);
  });

  testWidgets(
      'LifeUseFloatingNavigation renders floating capsule and handles item selection',
      (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const Center(child: Text('Body Screen')),
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return LifeUseFloatingNavigation(
                currentIndex: selectedIndex,
                onItemSelected: (idx) {
                  setState(() => selectedIndex = idx);
                },
                items: const [
                  LifeUseNavigationItemData(
                      label: 'Home', icon: LucideIcons.home),
                  LifeUseNavigationItemData(
                      label: 'Modules', icon: LucideIcons.layoutGrid),
                  LifeUseNavigationItemData(
                      label: 'Activity', icon: LucideIcons.activity),
                  LifeUseNavigationItemData(
                      label: 'Alerts', icon: LucideIcons.bell, showDot: true),
                  LifeUseNavigationItemData(
                      label: 'Profile', icon: LucideIcons.user),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify all 5 navigation items and the body are simultaneously rendered
    expect(find.text('Body Screen'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Modules'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify floating capsule widget is present
    expect(find.byType(LifeUseFloatingNavigation), findsOneWidget);

    // Tap on 'Modules'
    await tester.tap(find.text('Modules'));
    await tester.pumpAndSettle();

    expect(selectedIndex, equals(1));
  });

  testWidgets('BentoLifeOverview renders 4-pillar asymmetric life matrix',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: BentoLifeOverview(
              isDark: false,
              surfaceColor: Colors.white,
              borderColor: Color(0xFFE2E8F0),
              textPrimary: Color(0xFF0F172A),
              textSecondary: Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Daily Life Overview'), findsOneWidget);
    expect(find.text('Health & Body'), findsOneWidget);
    expect(find.text('Upcoming Bills'), findsOneWidget);
    expect(find.text('Home Sanctuary'), findsOneWidget);
    expect(find.text('Tasks & Routine'), findsOneWidget);
  });

  testWidgets(
      'AnimatedHeroBanner renders 5 unique slides and handles navigation triggers',
      (WidgetTester tester) async {
    bool moneyTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AnimatedHeroBanner(
              isDark: false,
              autoPlay: false,
              onMoneyManagerTap: () => moneyTapped = true,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Slide 0: Smart Financial Autopilot is default
    expect(find.text('FINANCIAL & LIFE OVERVIEW'), findsOneWidget);
    expect(find.text('Open Money Manager'), findsOneWidget);
    expect(find.text('₹1,200/day safe'), findsOneWidget);

    // Tap Open Money Manager
    await tester.tap(find.text('Open Money Manager'));
    await tester.pumpAndSettle();
    expect(moneyTapped, isTrue);

    // Swipe to Slide 1: Master Brand OS
    await tester.drag(find.byType(PageView), const Offset(-450, 0));
    await tester.pumpAndSettle();
    expect(find.text('LIFE INTELLIGENCE OS • 2026'), findsOneWidget);
    expect(find.text('Explore All 10 Modules'), findsOneWidget);

    // Swipe to Slide 2: 7-Day Habit Streak
    await tester.drag(find.byType(PageView), const Offset(-450, 0));
    await tester.pumpAndSettle();
    expect(find.text('DAILY HABITS • 7D STREAK'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('Days 🔥'), findsOneWidget);

    // Swipe to Slide 3: Smart Sanctuary & IoT Hub
    await tester.drag(find.byType(PageView), const Offset(-450, 0));
    await tester.pumpAndSettle();
    expect(find.text('SMART SANCTUARY'), findsOneWidget);
    expect(find.text('Manage Sanctuary'), findsOneWidget);

    // Swipe to Slide 4: Zero Penalty Utility Due Dates Radar
    await tester.drag(find.byType(PageView), const Offset(-450, 0));
    await tester.pumpAndSettle();
    expect(find.text('ZERO PENALTY RADAR'), findsOneWidget);
    expect(find.text('Pay & Schedule'), findsOneWidget);
  });
}
