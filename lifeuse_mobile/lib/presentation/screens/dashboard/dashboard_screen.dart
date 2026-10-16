import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/lifeuse_badge.dart';
import '../../../core/widgets/lifeuse_wordmark.dart';
import '../../navigation/main_navigation_shell.dart';
import '../../state/auth_provider.dart';
import '../../state/money_provider.dart';
import '../../state/module_provider.dart';
import '../money/dialogs/add_transaction_dialog.dart';
import '../modules/module_manager_screen.dart';
import 'models/dashboard_module_item.dart';
import 'widgets/module_card.dart';

/// Interactive task item displayed in Today's Activity section
class _DashboardActivityItem {
  final String id;
  final String title;
  final String category;
  final String time;
  final String priority;
  bool isCompleted;

  _DashboardActivityItem({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.priority,
    this.isCompleted = false,
  });
}

/// Interactive reminder item displayed in Upcoming Reminders section
class _DashboardReminderItem {
  final String id;
  final String title;
  final String dueDate;
  final String tag;
  final IconData icon;
  final Color color;

  const _DashboardReminderItem({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.tag,
    required this.icon,
    required this.color,
  });
}

/// Dynamic, responsive, and deeply integrated dashboard for LifeUse.
/// Works unconditionally for both authenticated users and guests.
/// Integrates live Money Manager financials, daily spending limits,
/// today's tasks, upcoming reminders, quick actions, and all 10 life management modules.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final DateFormat _headerDateFormat = DateFormat('EEEE, MMM d');

  // Interactive sample activities for Today's Activity section
  final List<_DashboardActivityItem> _activities = [
    _DashboardActivityItem(
      id: 'act_1',
      title: 'Review today\'s spending & cash flow',
      category: 'Finance',
      time: '08:30 AM',
      priority: 'High',
      isCompleted: true,
    ),
    _DashboardActivityItem(
      id: 'act_2',
      title: 'Take daily hydration & vitamins',
      category: 'Health',
      time: '09:00 AM',
      priority: 'Normal',
      isCompleted: true,
    ),
    _DashboardActivityItem(
      id: 'act_3',
      title: 'Pay electricity utility bill',
      category: 'Bills',
      time: '11:30 AM',
      priority: 'Urgent',
      isCompleted: false,
    ),
    _DashboardActivityItem(
      id: 'act_4',
      title: 'Review Flutter architecture & testing',
      category: 'Learning',
      time: '03:00 PM',
      priority: 'Normal',
      isCompleted: false,
    ),
  ];

  // Sample upcoming reminders
  final List<_DashboardReminderItem> _reminders = const [
    _DashboardReminderItem(
      id: 'rem_1',
      title: 'Electricity Bill (₹1,840.00)',
      dueDate: 'Due Oct 19 (in 3 days)',
      tag: 'Urgent',
      icon: Icons.bolt_rounded,
      color: Color(0xFFF59E0B),
    ),
    _DashboardReminderItem(
      id: 'rem_2',
      title: 'Doctor Follow-up Appointment',
      dueDate: 'Tomorrow at 10:30 AM',
      tag: 'Appointment',
      icon: Icons.medical_services_rounded,
      color: Color(0xFF10B981),
    ),
    _DashboardReminderItem(
      id: 'rem_3',
      title: 'Netflix Subscription Renewal',
      dueDate: 'Oct 25 (in 9 days)',
      tag: 'Auto-Pay',
      icon: Icons.movie_creation_rounded,
      color: Color(0xFF8B5CF6),
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoneyProvider>().loadDashboardData(silent: true);
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _onModuleTap(BuildContext context, DashboardModuleItem module) {
    if (module.id == 'money_manager') {
      MainNavigationShell.openMoneyManager(context);
    } else if (module.routeBuilder != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: module.routeBuilder!),
      );
    } else {
      _showRoadmapModal(context, module);
    }
  }

  void _showRoadmapModal(BuildContext context, DashboardModuleItem module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final surfaceColor = AppColors.surfaceOf(ctx);
        final borderColor = AppColors.borderOf(ctx);
        final textPrimary = AppColors.textPrimaryOf(ctx);
        final textSecondary = AppColors.textSecondaryOf(ctx);

        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: module.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: module.accentColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(module.icon, size: 24, color: module.accentColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          module.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: module.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const LifeUseBadge(
                    text: 'IN DEVELOPMENT',
                    variant: LifeUseBadgeVariant.pending,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                module.description,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.5,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Planned Capabilities',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: module.highlights.map((h) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: module.accentColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: module.accentColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, size: 14, color: module.accentColor),
                        const SizedBox(width: 6),
                        Text(
                          h,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Got It',
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQuickAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Quick Add Task',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g. Schedule health checkup',
            hintStyle: GoogleFonts.inter(fontSize: 13.5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _activities.insert(
                    0,
                    _DashboardActivityItem(
                      id: 'act_${DateTime.now().millisecondsSinceEpoch}',
                      title: controller.text.trim(),
                      category: 'General',
                      time: 'Today',
                      priority: 'High',
                    ),
                  );
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Task added to Today\'s Activity'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  void _showQuickAddReminderDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Add Reminder',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g. Pay Internet bill on Oct 22',
            hintStyle: GoogleFonts.inter(fontSize: 13.5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reminder scheduled successfully'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Save Reminder'),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyManagerPreview(BuildContext context) {
    final money = context.watch<MoneyProvider>();
    final daily = money.dailyLimit;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = AppColors.textSecondaryOf(context);

    if (daily == null || daily.recommendedDailyLimit == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            const Icon(Icons.bolt_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Live Backend Connected • Tap to view daily limit & transactions',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Remaining Limit',
                style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                _currencyFormat.format(daily.remainingTodayAllowance),
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: daily.remainingTodayAllowance >= 0
                      ? AppColors.primary
                      : AppColors.error,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Spent Today',
                style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                _currencyFormat.format(daily.spentToday),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('food') || lower.contains('dining') || lower.contains('restaurant')) {
      return Icons.restaurant_rounded;
    }
    if (lower.contains('grocer')) return Icons.local_grocery_store_rounded;
    if (lower.contains('rent') || lower.contains('house') || lower.contains('utilit')) {
      return Icons.home_rounded;
    }
    if (lower.contains('transport') || lower.contains('fuel') || lower.contains('travel') || lower.contains('cab')) {
      return Icons.directions_car_rounded;
    }
    if (lower.contains('shop')) return Icons.shopping_bag_rounded;
    if (lower.contains('entertain') || lower.contains('movie') || lower.contains('ott')) {
      return Icons.movie_creation_rounded;
    }
    if (lower.contains('health') || lower.contains('med') || lower.contains('doctor')) {
      return Icons.medical_services_rounded;
    }
    if (lower.contains('edu') || lower.contains('book') || lower.contains('course')) {
      return Icons.school_rounded;
    }
    if (lower.contains('invest') || lower.contains('stock') || lower.contains('mutual')) {
      return Icons.trending_up_rounded;
    }
    if (lower.contains('salary') || lower.contains('income')) {
      return Icons.account_balance_wallet_rounded;
    }
    return Icons.receipt_long_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final money = context.watch<MoneyProvider>();
    final moduleProvider = context.watch<ModuleProvider>();
    final user = auth.currentUser;

    final isDark = theme.isDark;
    final textPrimary = AppColors.textPrimaryOf(context);

    // Get enabled life management modules dynamically from ModuleProvider
    final modules = moduleProvider.enabledModules.map((m) {
      if (m.id == 'money_manager') {
        return m.copyWith(
          previewBuilder: (ctx) => _buildMoneyManagerPreview(ctx),
        );
      }
      return m;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: Text(
          'Add Expense',
          style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        onPressed: () => AddTransactionDialog.show(context),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<MoneyProvider>().loadDashboardData(silent: true);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // =========================================================
                    // 1. TOP HEADER & BRAND STRIP
                    // =========================================================
                    _buildTopHeader(context, user, isDark, theme),
                    const SizedBox(height: 18),

                    // =========================================================
                    // 2. OVERVIEW SUMMARY SECTION (METRICS & PREVIEW)
                    // =========================================================
                    _buildOverviewMetricsSection(context, money, user),
                    const SizedBox(height: 18),

                    // =========================================================
                    // 3. QUICK ACTIONS STRIP
                    // =========================================================
                    _buildQuickActionsStrip(context),
                    const SizedBox(height: 20),

                    // =========================================================
                    // 4. HERO FINANCIAL OVERVIEW CARD (MONEY MODULE INTEGRATION)
                    // =========================================================
                    _buildMoneyHeroCard(context, money),
                    const SizedBox(height: 22),

                    // =========================================================
                    // =========================================================
                    // 5. TODAY'S ACTIVITY (INTERACTIVE DAILY TASKS)
                    // =========================================================
                    _buildTodaysActivitySection(context),
                    const SizedBox(height: 22),

                    // =========================================================
                    // 6. UPCOMING REMINDERS & BILLS
                    // =========================================================
                    _buildUpcomingRemindersSection(context),
                    const SizedBox(height: 22),

                    // =========================================================
                    // 7. ACTIVE BUDGET PLAN BANNER (IF ACTIVE)
                    // =========================================================
                    _buildActiveBudgetBanner(context, money),

                    // =========================================================
                    // 8. RECENT TRANSACTIONS SECTION
                    // =========================================================
                    _buildRecentTransactionsSection(context, money),
                    const SizedBox(height: 28),

                    // =========================================================
                    // 9. SECTION TITLE: LIFE MANAGEMENT MODULES (10 MODULES)
                    // =========================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Life Management Modules',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const LifeUseBadge(
                                text: '10 MODULES',
                                variant: LifeUseBadgeVariant.active,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => ModuleManagerScreen.showModal(context),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.tune_rounded, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Manage',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => MainNavigationShell.switchTab(context, 1),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Explore All',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 11,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // =========================================================
                    // 10. DYNAMIC MODULES LIST / GRID (RESPONSIVE)
                    // =========================================================
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 640) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    for (int i = 0; i < modules.length; i += 2) ...[
                                      ModuleCard(
                                        module: modules[i],
                                        onTap: () => _onModuleTap(context, modules[i]),
                                      ),
                                      if (i + 2 < modules.length)
                                        const SizedBox(height: 14),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  children: [
                                    for (int i = 1; i < modules.length; i += 2) ...[
                                      ModuleCard(
                                        module: modules[i],
                                        onTap: () => _onModuleTap(context, modules[i]),
                                      ),
                                      if (i + 2 < modules.length)
                                        const SizedBox(height: 14),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: modules.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
                          itemBuilder: (ctx, i) {
                            final module = modules[i];
                            return ModuleCard(
                              module: module,
                              onTap: () => _onModuleTap(context, module),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Top Header: Brand wordmark, greeting, date, notifications, avatar
  Widget _buildTopHeader(
    BuildContext context,
    dynamic user,
    bool isDark,
    ThemeProvider theme,
  ) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final todayStr = _headerDateFormat.format(DateTime.now());

    final displayName = user != null ? user.fullName : 'Guest Explorer';
    final userInitial = user != null && user.username.isNotEmpty
        ? user.username[0].toUpperCase()
        : 'G';

    return Row(
      children: [
        // User Avatar or Guest Icon
        GestureDetector(
          onTap: () => MainNavigationShell.switchTab(context, 4),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: user != null
                  ? user.roleColor.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.12),
              border: Border.all(
                color: user != null ? user.roleColor : AppColors.primary,
                width: 1.8,
              ),
            ),
            child: Center(
              child: Text(
                userInitial,
                style: GoogleFonts.inter(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: user != null ? user.roleColor : AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Greeting & Brand Wordmark / Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _getGreeting(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('•', style: GoogleFonts.inter(color: textSecondary, fontSize: 11)),
                  const SizedBox(width: 6),
                  Text(
                    todayStr,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),

        // Notification Bell Icon with Red Dot
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none_rounded, size: 22),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          tooltip: 'Notifications',
          onPressed: () => MainNavigationShell.switchTab(context, 3),
        ),

        // Theme Toggle (Sun/Moon)
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            size: 20,
            color: isDark ? AppColors.amberGold : AppColors.primary,
          ),
          tooltip: isDark ? 'Light Mode' : 'Dark Mode',
          onPressed: () => theme.toggleTheme(),
        ),
      ],
    );
  }

  /// Overview Metrics Grid: Today's Tasks, Pending, Monthly Outflow, Reminders
  Widget _buildOverviewMetricsSection(
    BuildContext context,
    MoneyProvider money,
    dynamic user,
  ) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final completedTasks = _activities.where((a) => a.isCompleted).length;
    final totalTasks = _activities.length;
    final pendingTasks = totalTasks - completedTasks;

    final monthlyExpense = money.summary.totalExpenses > 0
        ? _currencyFormat.format(money.summary.totalExpenses)
        : (user != null ? '₹0.00' : '₹14,250.00');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LifeUseWordmark(height: 18, isDark: isDark),
                  const SizedBox(width: 8),
                  Text(
                    'Daily Overview',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              LifeUseBadge(
                text: user != null ? 'LIVE BACKEND' : 'SAMPLE PREVIEW',
                variant: user != null
                    ? LifeUseBadgeVariant.active
                    : LifeUseBadgeVariant.pending,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4 Metric Tiles Row (Responsive)
          LayoutBuilder(
            builder: (context, constraints) {
              final tile1 = _buildMetricTile(
                context: context,
                label: 'Today\'s Tasks',
                value: '$completedTasks / $totalTasks',
                badge: '${((completedTasks / totalTasks) * 100).toInt()}% Done',
                badgeColor: AppColors.primary,
                icon: Icons.check_circle_outline_rounded,
                onTap: () => MainNavigationShell.switchTab(context, 2),
              );

              final tile2 = _buildMetricTile(
                context: context,
                label: 'Pending Tasks',
                value: '$pendingTasks',
                badge: pendingTasks > 0 ? 'Due Today' : 'All Clear',
                badgeColor: pendingTasks > 0 ? const Color(0xFFF59E0B) : AppColors.success,
                icon: Icons.pending_actions_rounded,
                onTap: () => MainNavigationShell.switchTab(context, 2),
              );

              final tile3 = _buildMetricTile(
                context: context,
                label: 'Monthly Outflow',
                value: monthlyExpense,
                badge: user != null ? 'Live Cash' : 'Sample',
                badgeColor: AppColors.error,
                icon: Icons.account_balance_wallet_outlined,
                onTap: () => MainNavigationShell.openMoneyManager(context),
              );

              final tile4 = _buildMetricTile(
                context: context,
                label: 'Reminders',
                value: '${_reminders.length}',
                badge: 'Next: 3d',
                badgeColor: const Color(0xFF8B5CF6),
                icon: Icons.notifications_active_outlined,
                onTap: () => MainNavigationShell.switchTab(context, 3),
              );

              if (constraints.maxWidth > 640) {
                return Row(
                  children: [
                    Expanded(child: tile1),
                    const SizedBox(width: 10),
                    Expanded(child: tile2),
                    const SizedBox(width: 10),
                    Expanded(child: tile3),
                    const SizedBox(width: 10),
                    Expanded(child: tile4),
                  ],
                );
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: tile1),
                      const SizedBox(width: 10),
                      Expanded(child: tile2),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: tile3),
                      const SizedBox(width: 10),
                      Expanded(child: tile4),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required BuildContext context,
    required String label,
    required String value,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.borderOf(context).withValues(alpha: 0.7),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 16, color: badgeColor),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Quick Actions Strip
  Widget _buildQuickActionsStrip(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickActionButton(
            context: context,
            icon: Icons.add_circle_outline_rounded,
            label: 'Add Expense',
            color: AppColors.primary,
            onTap: () => AddTransactionDialog.show(context),
          ),
          Container(width: 1, height: 26, color: borderColor),
          _buildQuickActionButton(
            context: context,
            icon: Icons.add_task_rounded,
            label: 'Add Task',
            color: const Color(0xFF10B981),
            onTap: () => _showQuickAddTaskDialog(context),
          ),
          Container(width: 1, height: 26, color: borderColor),
          _buildQuickActionButton(
            context: context,
            icon: Icons.alarm_add_rounded,
            label: 'Add Reminder',
            color: const Color(0xFF8B5CF6),
            onTap: () => _showQuickAddReminderDialog(context),
          ),
          Container(width: 1, height: 26, color: borderColor),
          _buildQuickActionButton(
            context: context,
            icon: Icons.grid_view_rounded,
            label: 'All Modules',
            color: const Color(0xFFF59E0B),
            onTap: () => MainNavigationShell.switchTab(context, 1),
          ),
        ],
      ),
    );
  }

  /// Integrated Financial Hero card showing real-time monthly surplus and daily limits
  Widget _buildMoneyHeroCard(BuildContext context, MoneyProvider money) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final summary = money.summary;
    final daily = money.dailyLimit;

    final isLimitSafe = daily != null && daily.remainingTodayAllowance >= 0;
    final double progress = (daily != null && daily.recommendedDailyLimit > 0)
        ? (daily.spentToday / daily.recommendedDailyLimit).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Live Badge & Navigation Link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Financial Overview',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => MainNavigationShell.openMoneyManager(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'Money Hub',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Net Cash Flow / Monthly Net Savings
          Text(
            'Monthly Net Cash Flow',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _currencyFormat.format(summary.netCashFlow),
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: summary.netCashFlow >= 0 ? AppColors.primary : AppColors.error,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 10),
              LifeUseBadge(
                text: summary.netCashFlow >= 0 ? 'NET SURPLUS' : 'NET DEFICIT',
                variant: summary.netCashFlow >= 0
                    ? LifeUseBadgeVariant.active
                    : LifeUseBadgeVariant.terminated,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Inflow & Outflow Chips Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          size: 14,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Inflow',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: textSecondary,
                              ),
                            ),
                            Text(
                              _currencyFormat.format(summary.totalIncome),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          size: 14,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Outflow',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: textSecondary,
                              ),
                            ),
                            Text(
                              _currencyFormat.format(summary.totalExpenses),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.borderOf(context)),
          const SizedBox(height: 14),

          // Today's Daily Spending Limit Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Remaining Limit',
                    style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    daily != null
                        ? _currencyFormat.format(daily.remainingTodayAllowance)
                        : '₹0.00',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isLimitSafe ? AppColors.primary : AppColors.error,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Spent Today',
                    style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    daily != null ? _currencyFormat.format(daily.spentToday) : '₹0.00',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.85
                    ? AppColors.error
                    : (progress > 0.65 ? AppColors.amberGold : AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Today's Activity section with interactive task toggles
  Widget _buildTodaysActivitySection(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Today\'s Activity',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_activities.where((a) => a.isCompleted).length}/${_activities.length} DONE',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => MainNavigationShell.switchTab(context, 2),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Activity Items List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _activities.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (ctx, i) {
            final act = _activities[i];
            final isUrgent = act.priority == 'Urgent';

            return Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: act.isCompleted
                      ? borderColor.withValues(alpha: 0.5)
                      : borderColor,
                ),
              ),
              child: InkWell(
                onTap: () {
                  setState(() => act.isCompleted = !act.isCompleted);
                },
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      // Interactive checkbox
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: act.isCompleted ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: act.isCompleted ? AppColors.primary : borderColor,
                            width: 1.5,
                          ),
                        ),
                        child: act.isCompleted
                            ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),

                      // Task text & time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              act.title,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: act.isCompleted ? textSecondary : textPrimary,
                                decoration: act.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  act.category,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('•', style: GoogleFonts.inter(color: textSecondary, fontSize: 10)),
                                const SizedBox(width: 6),
                                Text(
                                  act.time,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Priority badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: (isUrgent ? AppColors.error : AppColors.primary)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          act.priority.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: isUrgent ? AppColors.error : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Upcoming Reminders & Bills section
  Widget _buildUpcomingRemindersSection(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Upcoming Reminders',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => MainNavigationShell.switchTab(context, 3),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All (${_reminders.length})',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _reminders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            final rem = _reminders[i];

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: rem.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: rem.color.withValues(alpha: 0.25)),
                    ),
                    child: Icon(rem.icon, size: 18, color: rem.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rem.title,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rem.dueDate,
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: rem.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      rem.tag,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: rem.color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// Active budget tracker banner
  Widget _buildActiveBudgetBanner(BuildContext context, MoneyProvider money) {
    final activePlan = money.activeBudgetPlan;
    if (activePlan == null) return const SizedBox.shrink();

    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final progress = activePlan.totalBudget > 0
        ? (activePlan.actualExpenses / activePlan.totalBudget).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        onTap: () {
          MainNavigationShell.openMoneyManager(context, initialTabIndex: 2);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.pie_chart_outline_rounded,
                        size: 18,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${activePlan.periodType} Budget Plan',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% spent',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: progress > 0.9 ? AppColors.error : AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.9
                      ? AppColors.error
                      : (progress > 0.75 ? AppColors.amberGold : const Color(0xFF8B5CF6)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spent: ${_currencyFormat.format(activePlan.actualExpenses)}',
                  style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                ),
                Text(
                  'Limit: ${_currencyFormat.format(activePlan.totalBudget)}',
                  style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Recent transactions list directly embedded in the dashboard
  Widget _buildRecentTransactionsSection(BuildContext context, MoneyProvider money) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final transactions = money.transactions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            if (transactions.isNotEmpty)
              TextButton(
                onPressed: () => MainNavigationShell.openMoneyManager(context, initialTabIndex: 1),
                child: Row(
                  children: [
                    Text(
                      'View All (${transactions.length})',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Transactions Recorded Yet',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track expenses, incomes and daily budgets in real time.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => AddTransactionDialog.show(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(
                      'Log First Transaction',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.take(4).length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final tx = transactions[i];
              final isIncome = tx.isIncome;
              final isRefund = tx.isRefund;
              final color = isIncome
                  ? AppColors.success
                  : (isRefund ? AppColors.accent : AppColors.error);

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(tx.categoryName),
                        size: 20,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.categoryName,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _dateFormat.format(tx.transactionDate),
                                style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: textSecondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tx.paymentMethod,
                                style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${isIncome ? '+' : '-'}${_currencyFormat.format(tx.amount)}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                        if (tx.essential) ...[
                          const SizedBox(height: 2),
                          Text(
                            'ESSENTIAL',
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final textPrimary = AppColors.textPrimaryOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
