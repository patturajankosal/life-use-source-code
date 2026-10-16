import 'package:flutter/material.dart';

enum ModuleStatus {
  active,
  beta,
  comingSoon,
}

/// Descriptor configuration for a dashboard feature module.
/// Enables adding or reordering modules cleanly without modifying dashboard layout code.
class DashboardModuleItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color accentColor;
  final ModuleStatus status;
  final List<String> highlights;
  final String category;
  final bool isEnabled;
  final bool isPinned;
  final Widget Function(BuildContext)? routeBuilder;
  final Widget Function(BuildContext)? previewBuilder;

  const DashboardModuleItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.status,
    required this.highlights,
    this.category = 'General',
    this.isEnabled = true,
    this.isPinned = false,
    this.routeBuilder,
    this.previewBuilder,
  });

  DashboardModuleItem copyWith({
    bool? isEnabled,
    bool? isPinned,
    ModuleStatus? status,
    Widget Function(BuildContext)? routeBuilder,
    Widget Function(BuildContext)? previewBuilder,
  }) {
    return DashboardModuleItem(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      icon: icon,
      accentColor: accentColor,
      status: status ?? this.status,
      highlights: highlights,
      category: category,
      isEnabled: isEnabled ?? this.isEnabled,
      isPinned: isPinned ?? this.isPinned,
      routeBuilder: routeBuilder ?? this.routeBuilder,
      previewBuilder: previewBuilder ?? this.previewBuilder,
    );
  }

  bool get isActive => status == ModuleStatus.active;
  bool get isBeta => status == ModuleStatus.beta;
  bool get isComingSoon => status == ModuleStatus.comingSoon;

  String get statusLabel {
    switch (status) {
      case ModuleStatus.active:
        return 'ACTIVE';
      case ModuleStatus.beta:
        return 'BETA';
      case ModuleStatus.comingSoon:
        return 'COMING SOON';
    }
  }

  /// Official registry of all 10 Life Management Modules in LifeUse
  static List<DashboardModuleItem> getRegistry({
    Widget Function(BuildContext)? moneyPreviewBuilder,
  }) {
    return [
      // 1. Money Manager (Live Connected Micro-App)
      DashboardModuleItem(
        id: 'money_manager',
        title: 'Money Manager',
        subtitle: 'Intelligent Cash Flow & Budgets',
        description:
            'Real-time spending limit, live transactions, multi-horizon budget plans, and recurring schedules.',
        icon: Icons.account_balance_wallet_rounded,
        accentColor: const Color(0xFF2563EB), // LifeUse primary blue
        status: ModuleStatus.active,
        category: 'Finance',
        highlights: const [
          'Daily Limit',
          'Budget Pressure',
          'Live API',
          'Recurring'
        ],
        previewBuilder: moneyPreviewBuilder,
      ),

      // 2. Home Management
      const DashboardModuleItem(
        id: 'home_management',
        title: 'Home Management',
        subtitle: 'Smart Home, Inventory & Repairs',
        description:
            'Track household inventory, smart appliance warranties, scheduled repairs, and ambient home automations.',
        icon: Icons.home_work_rounded,
        accentColor: Color(0xFF0284C7),
        status: ModuleStatus.comingSoon,
        category: 'Lifestyle',
        highlights: ['Smart Devices', 'Inventory', 'Maintenance', 'Repairs'],
      ),

      // 3. Daily Tasks
      const DashboardModuleItem(
        id: 'daily_tasks',
        title: 'Daily Tasks',
        subtitle: 'Routines, Habits & Priorities',
        description:
            'Smart productivity planner with daily recurring checklists, habit streaks, and milestone rewards.',
        icon: Icons.check_circle_outline_rounded,
        accentColor: Color(0xFF10B981),
        status: ModuleStatus.comingSoon,
        category: 'Productivity',
        highlights: [
          'Daily Checklist',
          'Habit Streaks',
          'Pomodoro',
          'Milestones'
        ],
      ),

      // 4. Health & Wellness
      const DashboardModuleItem(
        id: 'health_wellness',
        title: 'Health & Wellness',
        subtitle: 'Vitals, Workouts & Hydration',
        description:
            'Monitor daily water intake, active calorie burn, workout exercise logs, and restful sleep patterns.',
        icon: Icons.favorite_rounded,
        accentColor: Color(0xFFF43F5E),
        status: ModuleStatus.comingSoon,
        category: 'Lifestyle',
        highlights: ['Water Intake', 'Workout Logs', 'Sleep Tracker', 'Vitals'],
      ),

      // 5. Bills & Payments
      const DashboardModuleItem(
        id: 'bills_payments',
        title: 'Bills & Payments',
        subtitle: 'Subscriptions & Due Invoices',
        description:
            'Automated bill tracking, due date notifications, subscription cost audits, and payment receipts.',
        icon: Icons.receipt_long_rounded,
        accentColor: Color(0xFFF59E0B),
        status: ModuleStatus.comingSoon,
        category: 'Finance',
        highlights: [
          'Utility Bills',
          'Subscriptions',
          'Due Reminders',
          'Auto-Pay'
        ],
      ),

      // 6. Reminders & Notifications
      const DashboardModuleItem(
        id: 'reminders_notifications',
        title: 'Reminders & Notifications',
        subtitle: 'Time & Geofenced Alerts',
        description:
            'Context-aware notifications, follow-up alarms, birthdays, and calendar synchronized alerts.',
        icon: Icons.notifications_active_rounded,
        accentColor: Color(0xFF8B5CF6),
        status: ModuleStatus.comingSoon,
        category: 'Productivity',
        highlights: [
          'Smart Alarms',
          'Recurring Alerts',
          'Location Ping',
          'Follow-ups'
        ],
      ),

      // 7. Tickets & Travel
      const DashboardModuleItem(
        id: 'tickets_travel',
        title: 'Tickets & Travel',
        subtitle: 'Trips, Itineraries & Passes',
        description:
            'Centralized travel wallet for flight tickets, train reservations, hotel check-ins, and packing lists.',
        icon: Icons.flight_takeoff_rounded,
        accentColor: Color(0xFF06B6D4),
        status: ModuleStatus.comingSoon,
        category: 'Lifestyle',
        highlights: [
          'Flight Tickets',
          'Itinerary Plan',
          'Boarding Passes',
          'Packing'
        ],
      ),

      // 8. Exams & Learning
      const DashboardModuleItem(
        id: 'exams_learning',
        title: 'Exams & Learning',
        subtitle: 'Study Plans & Certification',
        description:
            'Structured study timetables, spaced repetition flashcards, revision trackers, and exam countdowns.',
        icon: Icons.school_rounded,
        accentColor: Color(0xFFEC4899),
        status: ModuleStatus.comingSoon,
        category: 'Productivity',
        highlights: [
          'Exam Countdown',
          'Flashcards',
          'Study Timer',
          'Syllabus'
        ],
      ),

      // 9. Documents
      const DashboardModuleItem(
        id: 'documents_vault',
        title: 'Documents',
        subtitle: 'Encrypted Document Vault',
        description:
            'Ultra-secure encrypted vault for national IDs, insurance policies, medical records, and warranties.',
        icon: Icons.folder_shared_rounded,
        accentColor: Color(0xFF6366F1),
        status: ModuleStatus.comingSoon,
        category: 'Personal Admin',
        highlights: [
          'AES-256 Vault',
          'Insurance Cards',
          'Govt IDs',
          'Warranties'
        ],
      ),

      // 10. Personal Planning
      const DashboardModuleItem(
        id: 'personal_planning',
        title: 'Personal Planning',
        subtitle: 'Life Goals & Milestones',
        description:
            'Quarterly vision boards, annual life milestones, bucket list ambitions, and self-review journals.',
        icon: Icons.explore_rounded,
        accentColor: Color(0xFF14B8A6),
        status: ModuleStatus.comingSoon,
        category: 'Personal Admin',
        highlights: [
          'Yearly Vision',
          'Bucket List',
          'Milestones',
          'Self Review'
        ],
      ),
    ];
  }
}
