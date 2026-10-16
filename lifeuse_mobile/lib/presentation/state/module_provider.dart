import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/activity/activity_screen.dart';
import '../screens/dashboard/models/dashboard_module_item.dart';
import '../screens/modules/bills_payments_screen.dart';
import '../screens/modules/documents_vault_screen.dart';
import '../screens/modules/exams_learning_screen.dart';
import '../screens/modules/health_wellness_screen.dart';
import '../screens/modules/home_management_screen.dart';
import '../screens/modules/personal_planning_screen.dart';
import '../screens/modules/tickets_travel_screen.dart';
import '../screens/money/money_manager_screen.dart';
import '../screens/notifications/notifications_screen.dart';

/// Dynamic Module Provider for LifeUse.
/// Manages the activation, customization, reordering, and route launching
/// of all 10 life management modules with local persistent state.
class ModuleProvider extends ChangeNotifier {
  static const String _prefKeyEnabled = 'lifeuse_enabled_module_ids';
  static const String _prefKeyPinned = 'lifeuse_pinned_module_ids';

  List<DashboardModuleItem> _modules = [];
  bool _isInitialized = false;

  ModuleProvider() {
    _initializeModules();
  }

  bool get isInitialized => _isInitialized;

  /// All modules available in LifeUse
  List<DashboardModuleItem> get allModules => List.unmodifiable(_modules);

  /// Only modules currently enabled by the user for the Dashboard
  List<DashboardModuleItem> get enabledModules {
    final list = _modules.where((m) => m.isEnabled).toList();
    // Pinned modules appear at the top
    list.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });
    return list;
  }

  int get enabledCount => _modules.where((m) => m.isEnabled).length;
  int get pinnedCount => _modules.where((m) => m.isPinned).length;

  void _initializeModules() {
    _modules = [
      DashboardModuleItem(
        id: 'money_manager',
        title: 'Money Manager',
        subtitle: 'Intelligent Cash Flow & Budgets',
        description:
            'Real-time spending limit, live transactions, multi-horizon budget plans, and recurring schedules.',
        icon: Icons.account_balance_wallet_rounded,
        accentColor: const Color(0xFF2563EB),
        status: ModuleStatus.active,
        category: 'Finance',
        highlights: const ['Daily Limit', 'Budget Pressure', 'Live API', 'Recurring'],
        isEnabled: true,
        isPinned: true,
        routeBuilder: (_) => const MoneyManagerScreen(),
      ),
      DashboardModuleItem(
        id: 'home_management',
        title: 'Home Management',
        subtitle: 'Smart Home, Inventory & Repairs',
        description:
            'Track household inventory, smart appliance controls, scheduled repairs, and equipment warranties.',
        icon: Icons.home_work_rounded,
        accentColor: const Color(0xFF0284C7),
        status: ModuleStatus.active,
        category: 'Lifestyle',
        highlights: const ['Smart Devices', 'Inventory', 'Maintenance', 'Warranties'],
        isEnabled: true,
        isPinned: false,
        routeBuilder: (_) => const HomeManagementScreen(),
      ),
      DashboardModuleItem(
        id: 'daily_tasks',
        title: 'Daily Tasks',
        subtitle: 'Routines, Habits & Priorities',
        description:
            'Smart productivity planner with daily recurring checklists, habit streaks, and milestone rewards.',
        icon: Icons.check_circle_outline_rounded,
        accentColor: const Color(0xFF10B981),
        status: ModuleStatus.active,
        category: 'Productivity',
        highlights: const ['Checklist', 'Priorities', 'Habits', 'Streaks'],
        isEnabled: true,
        isPinned: false,
        routeBuilder: (_) => const ActivityScreen(),
      ),
      DashboardModuleItem(
        id: 'health_wellness',
        title: 'Health & Wellness',
        subtitle: 'Vitals, Workouts & Hydration',
        description:
            'Monitor daily water intake, active calorie burn, workout exercise logs, and restful sleep patterns.',
        icon: Icons.favorite_rounded,
        accentColor: const Color(0xFFF43F5E),
        status: ModuleStatus.active,
        category: 'Lifestyle',
        highlights: const ['Water Intake', 'Workout Logs', 'Sleep Tracker', 'Vitals'],
        isEnabled: true,
        isPinned: false,
        routeBuilder: (_) => const HealthWellnessScreen(),
      ),
      DashboardModuleItem(
        id: 'bills_payments',
        title: 'Bills & Payments',
        subtitle: 'Subscriptions & Due Invoices',
        description:
            'Automated bill tracking, due date notifications, subscription cost audits, and payment receipts.',
        icon: Icons.receipt_long_rounded,
        accentColor: const Color(0xFFF59E0B),
        status: ModuleStatus.active,
        category: 'Finance',
        highlights: const ['Utility Bills', 'Subscriptions', 'Due Reminders', 'Auto-Pay'],
        isEnabled: true,
        isPinned: false,
        routeBuilder: (_) => const BillsPaymentsScreen(),
      ),
      DashboardModuleItem(
        id: 'reminders_notifications',
        title: 'Reminders & Notifications',
        subtitle: 'Time & Geofenced Alerts',
        description:
            'Context-aware notifications, follow-up alarms, birthdays, and calendar synchronized alerts.',
        icon: Icons.notifications_active_rounded,
        accentColor: const Color(0xFF8B5CF6),
        status: ModuleStatus.active,
        category: 'Productivity',
        highlights: const ['Smart Alarms', 'Recurring Alerts', 'Location Ping', 'Follow-ups'],
        isEnabled: true,
        isPinned: false,
        routeBuilder: (_) => const NotificationsScreen(),
      ),
      DashboardModuleItem(
        id: 'tickets_travel',
        title: 'Tickets & Travel',
        subtitle: 'Trips, Itineraries & Passes',
        description:
            'Centralized travel wallet for flight tickets, train reservations, hotel check-ins, and packing lists.',
        icon: Icons.flight_takeoff_rounded,
        accentColor: const Color(0xFF06B6D4),
        status: ModuleStatus.active,
        category: 'Lifestyle',
        highlights: const ['Flight Tickets', 'Itinerary Plan', 'Boarding Passes', 'Packing'],
        isEnabled: true,
        isPinned: false,
        routeBuilder: (_) => const TicketsTravelScreen(),
      ),
      DashboardModuleItem(
        id: 'exams_learning',
        title: 'Exams & Learning',
        subtitle: 'Study Plans & Certification',
        description:
            'Structured study timetables, spaced repetition flashcards, revision trackers, and exam countdowns.',
        icon: Icons.school_rounded,
        accentColor: const Color(0xFFEC4899),
        status: ModuleStatus.active,
        category: 'Productivity',
        highlights: const ['Exam Countdown', 'Flashcards', 'Study Timer', 'Syllabus'],
        isEnabled: true,
        isPinned: false,
        routeBuilder: (_) => const ExamsLearningScreen(),
      ),
      DashboardModuleItem(
        id: 'documents_vault',
        title: 'Documents Vault',
        subtitle: 'Encrypted Document Vault',
        description:
            'Ultra-secure encrypted vault for national IDs, insurance policies, medical records, and warranties.',
        icon: Icons.folder_shared_rounded,
        accentColor: const Color(0xFF6366F1),
        status: ModuleStatus.active,
        category: 'Personal Admin',
        highlights: const ['AES-256 Vault', 'Insurance Cards', 'Govt IDs', 'Warranties'],
        isEnabled: true,
        isPinned: false,
        routeBuilder: (_) => const DocumentsVaultScreen(),
      ),
      DashboardModuleItem(
        id: 'personal_planning',
        title: 'Personal Planning',
        subtitle: 'Life Goals & Milestones',
        description:
            'Quarterly vision boards, annual life milestones, bucket list ambitions, and self-review journals.',
        icon: Icons.explore_rounded,
        accentColor: const Color(0xFF14B8A6),
        status: ModuleStatus.active,
        category: 'Personal Admin',
        highlights: const ['Yearly Vision', 'Bucket List', 'Milestones', 'Self Review'],
        isEnabled: true,
        isPinned: false,
        routeBuilder: (_) => const PersonalPlanningScreen(),
      ),
    ];

    _restorePreferences();
  }

  Future<void> _restorePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabledJson = prefs.getString(_prefKeyEnabled);
      final pinnedJson = prefs.getString(_prefKeyPinned);

      if (enabledJson != null) {
        final List<dynamic> enabledIds = jsonDecode(enabledJson);
        for (int i = 0; i < _modules.length; i++) {
          final m = _modules[i];
          _modules[i] = m.copyWith(isEnabled: enabledIds.contains(m.id));
        }
      }

      if (pinnedJson != null) {
        final List<dynamic> pinnedIds = jsonDecode(pinnedJson);
        for (int i = 0; i < _modules.length; i++) {
          final m = _modules[i];
          _modules[i] = m.copyWith(isPinned: pinnedIds.contains(m.id));
        }
      }
    } catch (_) {
      // Fallback to default in memory if prefs fail
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabledIds = _modules.where((m) => m.isEnabled).map((m) => m.id).toList();
      final pinnedIds = _modules.where((m) => m.isPinned).map((m) => m.id).toList();

      await prefs.setString(_prefKeyEnabled, jsonEncode(enabledIds));
      await prefs.setString(_prefKeyPinned, jsonEncode(pinnedIds));
    } catch (_) {}
  }

  /// Toggle module active/inactive state
  void toggleModule(String id) {
    final idx = _modules.indexWhere((m) => m.id == id);
    if (idx != -1) {
      final current = _modules[idx];
      _modules[idx] = current.copyWith(isEnabled: !current.isEnabled);
      notifyListeners();
      _savePreferences();
    }
  }

  /// Toggle pin/unpin for quick access at the top
  void togglePin(String id) {
    final idx = _modules.indexWhere((m) => m.id == id);
    if (idx != -1) {
      final current = _modules[idx];
      _modules[idx] = current.copyWith(isPinned: !current.isPinned);
      notifyListeners();
      _savePreferences();
    }
  }

  /// Reorder modules in custom arrangement
  void reorderModules(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _modules.removeAt(oldIndex);
    _modules.insert(newIndex, item);
    notifyListeners();
    _savePreferences();
  }

  /// Reset all modules to default enabled state
  void resetToDefault() {
    for (int i = 0; i < _modules.length; i++) {
      _modules[i] = _modules[i].copyWith(
        isEnabled: true,
        isPinned: _modules[i].id == 'money_manager',
      );
    }
    notifyListeners();
    _savePreferences();
  }

  /// Launch module screen dynamically
  void launchModule(BuildContext context, DashboardModuleItem module) {
    if (module.routeBuilder != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: module.routeBuilder!),
      );
    }
  }
}
