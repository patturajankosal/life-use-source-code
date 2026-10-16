import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lifeuse_mobile/main.dart';
import 'package:lifeuse_mobile/core/theme/theme_provider.dart';
import 'package:lifeuse_mobile/data/models/api_response.dart';
import 'package:lifeuse_mobile/data/models/login_response.dart';
import 'package:lifeuse_mobile/data/services/api_client.dart';
import 'package:lifeuse_mobile/data/services/auth_service.dart';
import 'package:lifeuse_mobile/data/services/money_service.dart';
import 'package:lifeuse_mobile/presentation/state/auth_provider.dart';
import 'package:lifeuse_mobile/presentation/state/money_provider.dart';

void main() {
  testWidgets('LifeUse app smoke test - opens directly to Dashboard', (WidgetTester tester) async {
    final apiClient = ApiClient();
    final authService = AuthService(apiClient);
    final authProvider = AuthProvider(authService);
    final moneyService = MoneyService(apiClient);
    final moneyProvider = MoneyProvider(moneyService);
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
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

    await tester.pump();

    // Verify application starts directly on Dashboard without gating
    expect(find.text('Life Management Modules'), findsOneWidget);
    expect(find.text('Daily Overview'), findsOneWidget);
    expect(find.text('Guest Explorer'), findsOneWidget);
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
      'timestamp': 1791800077.4560094, // The exact double timestamp from Spring Boot
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
}
