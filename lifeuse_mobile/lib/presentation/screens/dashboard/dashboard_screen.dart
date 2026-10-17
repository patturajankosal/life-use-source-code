import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../state/auth_provider.dart';
import '../../state/money_provider.dart';
import '../activity/activity_screen.dart';
import '../modules/bills_payments_screen.dart';
import '../modules/documents_vault_screen.dart';
import '../modules/health_wellness_screen.dart';
import '../modules/tickets_travel_screen.dart';
import '../money/dialogs/add_transaction_dialog.dart';
import '../money/money_manager_screen.dart';
import '../notifications/notifications_screen.dart';
import 'models/dashboard_module_item.dart';
import 'widgets/module_card.dart';

/// Clean, responsive, normal mobile application Dashboard for LifeUse.
/// Uses hardcoded modules, normal mobile application layout, responsive grid,
/// live money summary, interactive task checklist, and quick action shortcuts.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Hardcoded sample tasks for the dashboard checklist
  final List<Map<String, dynamic>> _quickTasks = [
    {
      'title': 'Drink 500ml morning water',
      'category': 'Health',
      'color': const Color(0xFFEC4899),
      'isDone': true,
    },
    {
      'title': 'Review monthly grocery budget',
      'category': 'Finance',
      'color': const Color(0xFF10B981),
      'isDone': false,
    },
    {
      'title': 'Pay broadband Internet bill',
      'category': 'Bills',
      'color': const Color(0xFFF97316),
      'isDone': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bgColor = AppColors.backgroundOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final userName = user?.fullName.isNotEmpty == true
        ? user!.fullName
        : (user?.username ?? 'Patturajan');

    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d').format(now);

    final modules = HardcodedModuleItem.hardcodedModules;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. App Header ---
                  _buildHeader(
                    context: context,
                    userName: userName,
                    dateStr: dateStr,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 22),

                  // --- 2. Overview Summary Cards (2x2 Grid) ---
                  _buildOverviewSection(
                    context: context,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 22),

                  // --- 3. Quick Action Shortcuts ---
                  _buildQuickActions(context),

                  const SizedBox(height: 26),

                  // --- 4. Hardcoded Life Modules Section ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Life Modules',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'All 10 modules ready to use',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          '${modules.length} Apps',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Responsive 2-column or 3-column Grid
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      final isTablet = constraints.maxWidth >= 600;
                      final crossAxisCount = isTablet ? 3 : 2;
                      final childAspectRatio = isTablet ? 1.3 : 1.15;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: modules.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (ctx, index) {
                          final mod = modules[index];
                          return ModuleCard(
                            module: mod,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: mod.screenBuilder),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 26),

                  // --- 5. Today's Tasks Checklist ---
                  _buildTasksPreview(
                    context: context,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 22),

                  // --- 6. Upcoming Reminders Preview ---
                  _buildRemindersPreview(
                    context: context,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Header Widget ---
  Widget _buildHeader({
    required BuildContext context,
    required String userName,
    required String dateStr,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    final theme = context.watch<ThemeProvider>();

    return Row(
      children: [
        // Avatar Circle
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF6366F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withValues(alpha: 0.28),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'L',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Greeting and Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $userName 👋',
                style: GoogleFonts.inter(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                dateStr,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Dark / Light Mode Toggle Button
        IconButton(
          icon: Icon(
            theme.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            color: textSecondary,
            size: 20,
          ),
          tooltip: 'Toggle Theme',
          onPressed: () => theme.toggleTheme(),
        ),

        // Notification Bell Icon with Badge
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_outlined, color: textPrimary, size: 22),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          tooltip: 'Notifications',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            );
          },
        ),
      ],
    );
  }

  // --- Overview Cards Section (2x2 Grid) ---
  Widget _buildOverviewSection({
    required BuildContext context,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    final money = context.watch<MoneyProvider>();
    final monthlySpend = money.summary.totalExpenses > 0
        ? money.summary.totalExpenses
        : 18450.0;
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // 1. Money Card
            _buildStatCard(
              width: cardWidth,
              title: 'Monthly Spend',
              value: currencyFormat.format(monthlySpend),
              subtitle: 'Budget on track • 62%',
              icon: Icons.account_balance_wallet_rounded,
              color: const Color(0xFF10B981),
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MoneyManagerScreen()),
                );
              },
            ),

            // 2. Daily Tasks Card
            _buildStatCard(
              width: cardWidth,
              title: 'Today Tasks',
              value: '4 Tasks',
              subtitle: '2 completed • 2 pending',
              icon: Icons.task_alt_rounded,
              color: const Color(0xFF0EA5E9),
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ActivityScreen()),
                );
              },
            ),

            // 3. Upcoming Bills Card
            _buildStatCard(
              width: cardWidth,
              title: 'Upcoming Bills',
              value: '2 Due',
              subtitle: '₹3,200 due in 5 days',
              icon: Icons.receipt_long_rounded,
              color: const Color(0xFFF97316),
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BillsPaymentsScreen()),
                );
              },
            ),

            // 4. Health & Water Card
            _buildStatCard(
              width: cardWidth,
              title: 'Hydration',
              value: '1,750 ml',
              subtitle: 'Goal: 2,500 ml • 70%',
              icon: Icons.water_drop_rounded,
              color: const Color(0xFFEC4899),
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HealthWellnessScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required double width,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.16 : 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                color: textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // --- Quick Actions Bar ---
  Widget _buildQuickActions(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildActionChip(
            context: context,
            label: '+ Add Expense',
            icon: Icons.add_card_rounded,
            color: const Color(0xFF10B981),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const AddTransactionDialog(),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            context: context,
            label: '+ New Task',
            icon: Icons.add_task_rounded,
            color: const Color(0xFF0EA5E9),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ActivityScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            context: context,
            label: 'Scan Document',
            icon: Icons.document_scanner_rounded,
            color: const Color(0xFF14B8A6),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DocumentsVaultScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildActionChip(
            context: context,
            label: 'Trip Booking',
            icon: Icons.airplane_ticket_rounded,
            color: const Color(0xFF06B6D4),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TicketsTravelScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryOf(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Today's Tasks Preview ---
  Widget _buildTasksPreview({
    required BuildContext context,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Tasks",
                style: GoogleFonts.inter(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ActivityScreen()),
                  );
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ..._quickTasks.map((t) {
            final isDone = t['isDone'] as bool;
            final catColor = t['color'] as Color;

            return InkWell(
              onTap: () {
                setState(() => t['isDone'] = !isDone);
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      isDone
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: isDone ? const Color(0xFF10B981) : textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t['title'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDone ? textSecondary : textPrimary,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: isDark ? 0.16 : 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        t['category'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: catColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- Upcoming Reminders Preview ---
  Widget _buildRemindersPreview({
    required BuildContext context,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Reminders',
                style: GoogleFonts.inter(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                  );
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _buildReminderRow(
            icon: Icons.receipt_long_rounded,
            color: const Color(0xFFF97316),
            title: 'Broadband Internet Bill Due',
            due: 'Due in 3 days • ₹999',
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            isDark: isDark,
          ),
          const Divider(height: 18),
          _buildReminderRow(
            icon: Icons.school_rounded,
            color: const Color(0xFF6366F1),
            title: 'Cloud Computing Semester Exam',
            due: 'Oct 24 • 10:00 AM',
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderRow({
    required IconData icon,
    required Color color,
    required String title,
    required String due,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.16 : 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                due,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
