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
import 'package:lifeuse_mobile/presentation/state/auth_provider.dart';
import 'package:lifeuse_mobile/presentation/state/money_provider.dart';
import 'package:lifeuse_mobile/presentation/state/notification_provider.dart';

void main() {
  testWidgets('LifeUse app smoke test - opens directly to hardcoded Dashboard in Guest Mode', (WidgetTester tester) async {
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
          ChangeNotifierProvider<NotificationProvider>.value(value: notificationProvider),
        ],
        child: const LifeUseApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify application starts directly on Dashboard with hardcoded modules in Guest Mode
    expect(find.text('Life Modules'), findsOneWidget);
    expect(find.text('Money Manager'), findsWidgets);
    expect(find.text('Home Management'), findsOneWidget);
    expect(find.text('GUEST MODE'), findsOneWidget);
  });

  testWidgets('Reusable UI Components render smoothly across variants', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppButton(title: 'Primary Action', onPressed: () {}),
                AppButton.secondary(title: 'Secondary Action', onPressed: () {}),
                AppButton.outlined(title: 'Outlined Action', onPressed: () {}),
                AppButton.destructive(title: 'Destructive Action', onPressed: () {}),
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
    expect(ids, containsAll([
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

  testWidgets('MainNavigationShell renders 5 items and reactively updates Alerts notification dot', (WidgetTester tester) async {
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
          ChangeNotifierProvider<NotificationProvider>.value(value: notificationProvider),
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

  testWidgets('Intelligent Dashboard renders Google Pay inspired quick actions and contextual category filters', (WidgetTester tester) async {
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
          ChangeNotifierProvider<NotificationProvider>.value(value: notificationProvider),
        ],
        child: const LifeUseApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Google Pay inspired quick actions exist
    expect(find.text('Record'), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);
    expect(find.text('Set Alert'), findsOneWidget);
    expect(find.text('Pay Bills'), findsOneWidget);

    // Verify Financial & Life Overview hero card
    expect(find.text('FINANCIAL & LIFE OVERVIEW'), findsOneWidget);

    // Verify PhonePe contextual category filter chips exist
    expect(find.text('All (10)'), findsOneWidget);
    expect(find.text('Finance (2)'), findsOneWidget);
    expect(find.text('Productivity (4)'), findsOneWidget);
    expect(find.text('Lifestyle (4)'), findsOneWidget);

    // Initial state displays all 10 modules
    expect(find.text('10 Apps'), findsOneWidget);

    // Test Search input filtering by typing 'bills'
    await tester.enterText(find.byType(TextField), 'bills');
    await tester.pumpAndSettle();
    expect(find.text('1 Apps'), findsOneWidget);

    // Clear search and verify it returns to 10 apps
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('10 Apps'), findsOneWidget);
  });

  testWidgets('LifeUseFloatingNavigation renders floating capsule and handles item selection', (WidgetTester tester) async {
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
                  LifeUseNavigationItemData(label: 'Home', icon: LucideIcons.home),
                  LifeUseNavigationItemData(label: 'Modules', icon: LucideIcons.layoutGrid),
                  LifeUseNavigationItemData(label: 'Activity', icon: LucideIcons.activity),
                  LifeUseNavigationItemData(label: 'Alerts', icon: LucideIcons.bell, showDot: true),
                  LifeUseNavigationItemData(label: 'Profile', icon: LucideIcons.user),
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
}
