import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../activity/activity_screen.dart';
import '../../modules/bills_payments_screen.dart';
import '../../modules/documents_vault_screen.dart';
import '../../modules/exams_learning_screen.dart';
import '../../modules/health_wellness_screen.dart';
import '../../modules/home_management_screen.dart';
import '../../modules/personal_planning_screen.dart';
import '../../modules/tickets_travel_screen.dart';
import '../../money/money_manager_screen.dart';
import '../../notifications/notifications_screen.dart';

enum ModuleStatus {
  active,
  beta,
  comingSoon,
}

/// Clean, hardcoded module definition for normal mobile application dashboard.
class HardcodedModuleItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon; // Dashboard Hero Icon (Layered Duotone)
  final IconData? navIcon; // Compact Navigation Icon (Minimal Outline)
  final Color accentColor;
  final String category;
  final String badgeText;
  final ModuleStatus status;
  final List<String> highlights;
  final Widget Function(BuildContext) screenBuilder;

  const HardcodedModuleItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.description = '',
    required this.icon,
    this.navIcon,
    required this.accentColor,
    this.category = 'General',
    this.badgeText = 'Active',
    this.status = ModuleStatus.active,
    this.highlights = const [],
    this.screenBuilder = _defaultScreenBuilder,
  });

  IconData get effectiveNavIcon => navIcon ?? icon;

  static Widget _defaultScreenBuilder(BuildContext context) => const Scaffold();

  bool get isActive => status == ModuleStatus.active;
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

  /// The 10 hardcoded Life Management modules of LifeUse
  static List<HardcodedModuleItem> get hardcodedModules => [
        HardcodedModuleItem(
          id: 'money_manager',
          title: 'Money Manager',
          subtitle: 'Budgets, income & expenses',
          description: 'Manage personal finances, budgets, transactions, and cash flow.',
          icon: LucideIcons.wallet,
          navIcon: LucideIcons.wallet,
          accentColor: const Color(0xFF10B981), // Emerald
          category: 'Finance',
          badgeText: 'Live API',
          status: ModuleStatus.active,
          highlights: const ['Daily Limit', 'Budget Plan', 'Live API'],
          screenBuilder: (_) => const MoneyManagerScreen(),
        ),
        HardcodedModuleItem(
          id: 'home_management',
          title: 'Home Management',
          subtitle: 'Appliances, inventory & utilities',
          description: 'Control smart devices, track home supplies, and equipment warranties.',
          icon: LucideIcons.home,
          navIcon: LucideIcons.home,
          accentColor: const Color(0xFFF59E0B), // Amber
          category: 'Lifestyle',
          badgeText: 'Active',
          status: ModuleStatus.active,
          highlights: const ['Smart Home', 'Inventory', 'Warranties'],
          screenBuilder: (_) => const HomeManagementScreen(),
        ),
        HardcodedModuleItem(
          id: 'daily_tasks',
          title: 'Daily Tasks',
          subtitle: 'To-dos, routines & checklists',
          description: 'Organize tasks, recurring habits, and daily priorities.',
          icon: LucideIcons.checkSquare,
          navIcon: LucideIcons.checkSquare,
          accentColor: const Color(0xFF0EA5E9), // Sky Blue
          category: 'Productivity',
          badgeText: 'Active',
          status: ModuleStatus.active,
          highlights: const ['To-dos', 'Routines', 'Priority'],
          screenBuilder: (_) => const ActivityScreen(),
        ),
        HardcodedModuleItem(
          id: 'health_wellness',
          title: 'Health & Wellness',
          subtitle: 'Vitals, water intake & workouts',
          description: 'Track daily water intake, vitals, workouts, and sleep.',
          icon: LucideIcons.heartPulse,
          navIcon: LucideIcons.activity,
          accentColor: const Color(0xFFEC4899), // Pink
          category: 'Lifestyle',
          badgeText: 'Active',
          status: ModuleStatus.active,
          highlights: const ['Water Intake', 'Workouts', 'Vitals'],
          screenBuilder: (_) => const HealthWellnessScreen(),
        ),
        HardcodedModuleItem(
          id: 'bills_payments',
          title: 'Bills & Payments',
          subtitle: 'Upcoming dues & subscriptions',
          description: 'Monitor recurring bills, due dates, and auto-pay services.',
          icon: LucideIcons.receipt,
          navIcon: LucideIcons.receipt,
          accentColor: const Color(0xFFF97316), // Orange
          category: 'Finance',
          badgeText: 'Active',
          status: ModuleStatus.active,
          highlights: const ['Due Dates', 'Subscriptions', 'Auto-pay'],
          screenBuilder: (_) => const BillsPaymentsScreen(),
        ),
        HardcodedModuleItem(
          id: 'notifications',
          title: 'Reminders & Alerts',
          subtitle: 'Timely alerts & deadlines',
          description: 'Stay on top of critical reminders, notifications, and alarms.',
          icon: LucideIcons.bellRing,
          navIcon: LucideIcons.bell,
          accentColor: const Color(0xFF8B5CF6), // Purple
          category: 'Productivity',
          badgeText: 'Active',
          status: ModuleStatus.active,
          highlights: const ['Alerts', 'Deadlines', 'Schedules'],
          screenBuilder: (_) => const NotificationsScreen(),
        ),
        HardcodedModuleItem(
          id: 'tickets_travel',
          title: 'Tickets & Travel',
          subtitle: 'Passes, itineraries & packing',
          icon: LucideIcons.plane,
          navIcon: LucideIcons.plane,
          accentColor: const Color(0xFF06B6D4), // Cyan
          category: 'Lifestyle',
          badgeText: 'Active',
          status: ModuleStatus.active,
          highlights: const ['Flights', 'Hotels', 'Packing List'],
          screenBuilder: (_) => const TicketsTravelScreen(),
        ),
        HardcodedModuleItem(
          id: 'exams_learning',
          title: 'Exams & Learning',
          subtitle: 'Courses, tests & flashcards',
          icon: LucideIcons.graduationCap,
          navIcon: LucideIcons.bookOpen,
          accentColor: const Color(0xFF6366F1), // Indigo
          category: 'Education',
          badgeText: 'Active',
          status: ModuleStatus.active,
          highlights: const ['Courses', 'Exams', 'Flashcards'],
          screenBuilder: (_) => const ExamsLearningScreen(),
        ),
        HardcodedModuleItem(
          id: 'documents_vault',
          title: 'Documents Vault',
          subtitle: 'Encrypted IDs & policies',
          description: 'Secure hardware-encrypted document storage for important IDs and certificates.',
          icon: LucideIcons.shieldCheck,
          navIcon: LucideIcons.shield,
          accentColor: const Color(0xFF14B8A6), // Teal
          category: 'Security',
          badgeText: 'Encrypted',
          status: ModuleStatus.active,
          highlights: const ['AES-256', 'IDs', 'Insurance'],
          screenBuilder: (_) => const DocumentsVaultScreen(),
        ),
        HardcodedModuleItem(
          id: 'personal_planning',
          title: 'Personal Planning',
          subtitle: 'Milestones, vision & goals',
          description: 'Life roadmap, yearly milestones, and personal bucket list.',
          icon: LucideIcons.compass,
          navIcon: LucideIcons.target,
          accentColor: const Color(0xFFEAB308), // Yellow Gold
          category: 'Planning',
          badgeText: 'Active',
          status: ModuleStatus.active,
          highlights: const ['Milestones', 'Vision Board', 'Goals'],
          screenBuilder: (_) => const PersonalPlanningScreen(),
        ),
      ];
}

// Backward-compatibility alias
typedef DashboardModuleItem = HardcodedModuleItem;
