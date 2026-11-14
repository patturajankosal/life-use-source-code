import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/auth_guard_dialog.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../data/models/user_model.dart';
import '../../navigation/main_navigation_shell.dart';
import '../../state/auth_provider.dart';
import '../../state/money_provider.dart';
import '../../state/notification_provider.dart';
import '../modules/bills_payments_screen.dart';
import '../money/dialogs/add_transaction_dialog.dart';
import 'models/dashboard_module_item.dart';
import 'widgets/module_card.dart';

/// Premium White & Purple Mobile Application Home Dashboard for LifeUse.
/// Follows strict Google Pay, PhonePe, and Google Gemini design principles:
/// - 80-90% White & soft neutral surfaces with primary purple (#7041C5) accents.
/// - Glanceable hero financial & productivity status with privacy peek mode.
/// - Tactile Google Pay inspired quick action hubs in consistent purple treatment.
/// - Contextual PhonePe category filtering and icon-first modules grid.
/// - Proactive Google Gemini intelligence capsule in soft lavender.
/// - Distinctive iconography with strict separation between Home and Dashboard.
/// - Seamless Guest Mode and Authenticated Cloud Sync.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'ALL'; // ALL, FINANCE, PRODUCTIVITY, LIFESTYLE
  bool _hideBalances = false; // Privacy mode toggle for public viewing

  // Interactive daily rhythm checklist items (Clean White & Purple)
  final List<Map<String, dynamic>> _quickTasks = [
    {
      'title': 'Drink 500ml morning water',
      'category': 'Health',
      'isDone': true,
    },
    {
      'title': 'Review monthly grocery budget',
      'category': 'Finance',
      'isDone': false,
    },
    {
      'title': 'Pay broadband Internet bill',
      'category': 'Bills',
      'isDone': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final money = context.read<MoneyProvider>();
    await money.loadDashboardData(silent: true);
  }

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
    final money = context.watch<MoneyProvider>();

    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d').format(now);

    final allModules = HardcodedModuleItem.hardcodedModules;

    // Filter modules based on category chip and search query
    final filteredModules = allModules.where((mod) {
      if (_selectedCategory == 'FINANCE' && mod.category != 'Finance') {
        return false;
      }
      if (_selectedCategory == 'PRODUCTIVITY' &&
          mod.category != 'Productivity' &&
          mod.category != 'Education') {
        return false;
      }
      if (_selectedCategory == 'LIFESTYLE' &&
          mod.category != 'Lifestyle' &&
          mod.category != 'Security') {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = mod.title.toLowerCase().contains(q);
        final matchesSubtitle = mod.subtitle.toLowerCase().contains(q);
        final matchesCategory = mod.category.toLowerCase().contains(q);
        return matchesTitle || matchesSubtitle || matchesCategory;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppColors.primary,
          backgroundColor: surfaceColor,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. Ambient White & Purple Header ---
                    _buildHeader(
                      context: context,
                      user: user,
                      dateStr: dateStr,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 16),

                    // --- 2. Google-Inspired Quick Search Bar ---
                    _buildSearchBar(
                      context: context,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 18),

                    // --- 3. The "Life Horizon" Hero Financial Card (White + Purple) ---
                    _buildHeroOverviewCard(
                      context: context,
                      auth: auth,
                      money: money,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 22),

                    // --- 4. Google Pay Signature Action Carousel (Consistent Purple) ---
                    _buildQuickActionRow(context),

                    const SizedBox(height: 22),

                    // --- 5. Google Gemini Ambient Life Intelligence Capsule ---
                    _buildSmartInsightsCard(
                      context: context,
                      money: money,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 24),

                    // --- 6. Contextual Life Modules Hub (PhonePe Categorization) ---
                    _buildModulesHubSection(
                      context: context,
                      allModules: allModules,
                      filteredModules: filteredModules,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 24),

                    // --- 7. Live Recent Activity (Real Transactions) ---
                    _buildRecentActivitySection(
                      context: context,
                      money: money,
                      isAuthenticated: auth.isAuthenticated,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 24),

                    // --- 8. Today's Rhythm & Priorities Checklist ---
                    _buildTasksPreview(
                      context: context,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      isDark: isDark,
                    ),

                    // Bottom spacing allowing comfortable scrolling above floating navigation bar
                    const SizedBox(height: 100),
                  ],
                ),
              ).animate().fadeIn(duration: 250.ms),
            ),
          ),
        ),
      ),
    );
  }

  // --- 1. Ambient White & Purple Header Widget ---
  Widget _buildHeader({
    required BuildContext context,
    required UserModel? user,
    required String dateStr,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    final theme = context.watch<ThemeProvider>();
    final isAuthenticated = user != null;
    final displayName = isAuthenticated
        ? (user.fullName.isNotEmpty ? user.fullName : '@${user.username}')
        : 'Guest Explorer';

    final hour = DateTime.now().hour;
    final timeGreeting = hour < 12
        ? 'Good morning'
        : (hour < 17 ? 'Good afternoon' : 'Good evening');

    return Row(
      children: [
        // Persona Emblem with Dynamic Status Ring
        LifeUsePersonaEmblem(
          name: displayName,
          isAuthenticated: isAuthenticated,
          size: 46,
          onTap: () => MainNavigationShell.switchTab(context, 4),
        ),

        const SizedBox(width: 14),

        // Greeting and Name
        Expanded(
          child: InkWell(
            onTap: () => MainNavigationShell.switchTab(context, 4),
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '$timeGreeting, $displayName',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                    if (!isAuthenticated) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.badgeBgOf(context),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF3D2550)
                                : const Color(0xFFEBE3F0),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          'GUEST MODE',
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.badgeTextOf(context),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),

        // Privacy Peek Toggle Button
        IconButton(
          icon: Icon(
            _hideBalances ? LucideIcons.eyeOff : LucideIcons.eye,
            color: textSecondary,
            size: 20,
          ),
          tooltip: _hideBalances ? 'Show Balances' : 'Hide Balances',
          onPressed: () => setState(() => _hideBalances = !_hideBalances),
        ),

        // Dark / Light Mode Toggle Button
        IconButton(
          icon: Icon(
            theme.isDarkMode ? LucideIcons.sun : LucideIcons.moon,
            color: textSecondary,
            size: 20,
          ),
          tooltip: 'Toggle Theme',
          onPressed: () => theme.toggleTheme(),
        ),

        // Notification Bell Icon with Badge (switches to Alerts tab)
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(LucideIcons.bell, color: textPrimary, size: 20),
              if (context.watch<NotificationProvider>().hasUnread)
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
          onPressed: () => MainNavigationShell.switchTab(context, 3),
        ),
      ],
    );
  }

  // --- 2. Google-Inspired Quick Search Bar ---
  Widget _buildSearchBar({
    required BuildContext context,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2233) : borderColor,
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val.trim();
          });
        },
        style: GoogleFonts.inter(fontSize: 13.5, color: textPrimary),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search 10 life modules, tasks, finances...',
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: textSecondary.withValues(alpha: 0.75),
          ),
          prefixIcon: const Icon(
            LucideIcons.search,
            size: 18,
            color: AppColors.primary,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  // --- 3. The "Life Horizon" Hero Financial Card (White + Purple) ---
  Widget _buildHeroOverviewCard({
    required BuildContext context,
    required AuthProvider auth,
    required MoneyProvider money,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final isAuthenticated = auth.isAuthenticated;

    final double totalExpenses = money.summary.totalExpenses;
    final double totalIncome = money.summary.totalIncome;
    final double netSavings = money.summary.netCashFlow;
    final dailyLimit = money.dailyLimit;

    // Display strings honoring privacy mode
    final displayExpense = _hideBalances ? '₹••••••' : currencyFormat.format(totalExpenses);
    final displayIncome = _hideBalances ? '₹••••' : currencyFormat.format(totalIncome);
    final displaySavings = _hideBalances ? '₹••••' : currencyFormat.format(netSavings);

    return InkWell(
      onTap: () => MainNavigationShell.openMoneyManager(context),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark ? const Color(0xFF2A2233) : borderColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.03),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Indicator Row: Distinctive Dashboard Grid Symbol + Status Label
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Distinctive dashboard grid icon in Soft Lavender container
                    const LifeUseDashboardIcon(
                      icon: LucideIcons.layoutDashboard,
                      accentColor: AppColors.primary,
                      size: 18,
                      containerSize: 34,
                      radius: 10,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'FINANCIAL & LIFE OVERVIEW',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Money Manager',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      LucideIcons.chevronRight,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Big Metric Display
            if (isAuthenticated) ...[
              Text(
                'Monthly Expenses Outflow',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    displayExpense,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '(${money.summary.transactionCount} transactions)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Inflow vs Net Savings Row (White & Purple styling)
              Row(
                children: [
                  // Income Inflow
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2A1838)
                            : AppColors.softLavender,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF3D2550)
                              : const Color(0xFFEBE3F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.arrowDownLeft, size: 13, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                'Total Inflow',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displayIncome,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Net Savings
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2A1838)
                            : AppColors.softLavender,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF3D2550)
                              : const Color(0xFFEBE3F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.trendingUp, size: 13, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                'Net Cash Flow',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            displaySavings,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (dailyLimit != null && dailyLimit.recommendedDailyLimit > 0) ...[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (dailyLimit.spentToday / dailyLimit.recommendedDailyLimit).clamp(0.0, 1.0),
                    backgroundColor: isDark ? const Color(0xFF2A1838) : const Color(0xFFEBE3F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      (dailyLimit.spentToday > dailyLimit.recommendedDailyLimit)
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                    minHeight: 5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _hideBalances
                          ? 'Daily Pace: Allowance protected'
                          : 'Daily Pace: ${currencyFormat.format(dailyLimit.remainingTodayAllowance)} left today',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: textSecondary,
                      ),
                    ),
                    Text(
                      (dailyLimit.spentToday > dailyLimit.recommendedDailyLimit)
                          ? 'Over Pace'
                          : 'Spending Safe',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: (dailyLimit.spentToday > dailyLimit.recommendedDailyLimit)
                            ? AppColors.error
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ] else ...[
              // Guest Mode Preview
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '₹0.00',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '• Offline Guest Access',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Live Spring Boot backend active. Sign in to synchronize financial profiles, bank transactions, and active budget plans across all devices.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {
                  AuthGuardDialog.protect(
                    context,
                    title: 'Sign In to Sync Finances',
                    message:
                        'Access all financial tools, live budgets, and cloud records on your personal account.',
                    onAuthenticated: () {},
                  );
                },
                icon: const Icon(LucideIcons.logIn, size: 16),
                label: const Text('Sign In to Unlock Cloud Sync'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- 4. Google Pay Signature Action Carousel (Consistent Purple Treatment) ---
  Widget _buildQuickActionRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // 1. Record Expense (Guarded by AuthGuard)
          _buildActionPill(
            context: context,
            label: 'Record',
            icon: LucideIcons.plusCircle,
            onTap: () {
              AuthGuardDialog.protect(
                context,
                title: 'Sign In to Record Expenses',
                message:
                    'Keep your personal transactions, budgets, and accounts synced securely to your LifeUse account.',
                onAuthenticated: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddTransactionDialog(),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 14),

          // 2. Open Money Manager Micro-App
          _buildActionPill(
            context: context,
            label: 'Money Manager',
            icon: LucideIcons.wallet,
            onTap: () => MainNavigationShell.openMoneyManager(context),
          ),
          const SizedBox(width: 14),

          // 3. Add Task (Switches to Activity Tab)
          _buildActionPill(
            context: context,
            label: 'Add Task',
            icon: LucideIcons.checkSquare,
            onTap: () => MainNavigationShell.switchTab(context, 2),
          ),
          const SizedBox(width: 14),

          // 4. Set Alert / Reminder (Switches to Alerts Tab)
          _buildActionPill(
            context: context,
            label: 'Set Alert',
            icon: LucideIcons.bellPlus,
            onTap: () => MainNavigationShell.switchTab(context, 3),
          ),
          const SizedBox(width: 14),

          // 5. Pay Bills (Navigates to Bills & Payments Screen)
          _buildActionPill(
            context: context,
            label: 'Pay Bills',
            icon: LucideIcons.receipt,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BillsPaymentsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionPill({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerBg = isDark ? const Color(0xFF2A1838) : AppColors.softLavender;
    final containerBorder = isDark ? const Color(0xFF3D2550) : const Color(0xFFEBE3F0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: containerBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: containerBorder,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, size: 22, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryOf(context),
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 5. Google Gemini Ambient Life Intelligence Capsule (Soft Lavender & Purple) ---
  Widget _buildSmartInsightsCard({
    required BuildContext context,
    required MoneyProvider money,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    final notifProvider = context.watch<NotificationProvider>();
    final hasUnreadNotifs = notifProvider.hasUnread;
    final hasHighPressure = money.budgetPressure?.isHigh ?? false;

    final IconData insightIcon;
    final String insightTitle;
    final String insightMessage;
    final String actionText;
    final VoidCallback onAction;

    if (hasUnreadNotifs) {
      insightIcon = LucideIcons.bellRing;
      insightTitle = 'Pending Alerts & Reminders';
      insightMessage =
          'You have unread reminders and utility alerts. Tap to review deadlines.';
      actionText = 'View Alerts';
      onAction = () => MainNavigationShell.switchTab(context, 3);
    } else if (hasHighPressure) {
      insightIcon = LucideIcons.triangleAlert;
      insightTitle = 'Budget Pressure Alert';
      insightMessage =
          'Spending in certain categories is exceeding safe threshold pacing.';
      actionText = 'Review Plan';
      onAction = () => MainNavigationShell.openMoneyManager(context, initialTabIndex: 2);
    } else {
      insightIcon = LucideIcons.sparkles;
      insightTitle = 'Pace & Wellness On Track';
      insightMessage =
          'Daily expenses and routine priorities are pacing within healthy targets.';
      actionText = 'Explore';
      onAction = () => MainNavigationShell.switchTab(context, 1);
    }

    final cardBg = isDark ? const Color(0xFF2A1838) : AppColors.softLavender;
    final cardBorder = isDark ? const Color(0xFF3D2550) : const Color(0xFFEBE3F0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cardBorder,
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF181220) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? const Color(0xFF3D2550) : const Color(0xFFEBE3F0),
                width: 1,
              ),
            ),
            child: Icon(insightIcon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insightTitle,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  insightMessage,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionText,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. Contextual Life Modules Hub (PhonePe Categorization Principle) ---
  Widget _buildModulesHubSection({
    required BuildContext context,
    required List<HardcodedModuleItem> allModules,
    required List<HardcodedModuleItem> filteredModules,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Life Modules',
                  style: GoogleFonts.plusJakartaSans(
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
                color: AppColors.badgeBgOf(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF3D2550) : const Color(0xFFEBE3F0),
                ),
              ),
              child: Text(
                '${filteredModules.length} Apps',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.badgeTextOf(context),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Contextual Category Filter Chips (PhonePe Category Organization)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildCategoryChip('ALL', 'All (10)'),
              const SizedBox(width: 8),
              _buildCategoryChip('FINANCE', 'Finance (2)'),
              const SizedBox(width: 8),
              _buildCategoryChip('PRODUCTIVITY', 'Productivity (4)'),
              const SizedBox(width: 8),
              _buildCategoryChip('LIFESTYLE', 'Lifestyle (4)'),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Responsive Asymmetric Grid
        LayoutBuilder(
          builder: (ctx, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final crossAxisCount = isTablet ? 3 : 2;
            final childAspectRatio = isTablet ? 1.3 : 1.15;

            if (filteredModules.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  'No modules match "$_searchQuery"',
                  style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredModules.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (ctx, index) {
                final mod = filteredModules[index];
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
      ],
    );
  }

  Widget _buildCategoryChip(String categoryKey, String label) {
    final isSelected = _selectedCategory == categoryKey;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => _selectedCategory = categoryKey),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? const Color(0xFF2A1838) : AppColors.secondarySurface),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? const Color(0xFF2A2233) : const Color(0xFFEBE3F0)),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondaryOf(context),
          ),
        ),
      ),
    );
  }

  // --- 7. Live Recent Activity Section (Real Transactions) ---
  Widget _buildRecentActivitySection({
    required BuildContext context,
    required MoneyProvider money,
    required bool isAuthenticated,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    final transactions = money.transactions.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2233) : borderColor,
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
            blurRadius: 10,
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
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A1838) : AppColors.softLavender,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.receipt,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Recent Activity',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => MainNavigationShell.openMoneyManager(context, initialTabIndex: 1),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
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

          const SizedBox(height: 12),

          if (isAuthenticated && transactions.isNotEmpty) ...[
            ...transactions.map((tx) {
              final isIncome = tx.isIncome;
              final description = (tx.notes != null && tx.notes!.isNotEmpty)
                  ? tx.notes!
                  : tx.categoryName;
              final displayAmount = _hideBalances
                  ? '₹••••'
                  : '${isIncome ? '+' : '-'}${currencyFormat.format(tx.amount)}';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: InkWell(
                  onTap: () => MainNavigationShell.openMoneyManager(context, initialTabIndex: 1),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2A1838) : AppColors.softLavender,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF3D2550) : const Color(0xFFEBE3F0),
                            width: 0.8,
                          ),
                        ),
                        child: Icon(
                          isIncome ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              description,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${tx.categoryName} • ${tx.paymentMethod}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        displayAmount,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isIncome ? AppColors.financialPositive : textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ] else ...[
            // Empty / Guest State
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.inbox,
                    size: 20,
                    color: textSecondary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isAuthenticated
                          ? 'No transactions recorded yet. Tap Record to add an entry.'
                          : 'Sign in to record and view real-time transactions.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- 8. Today's Rhythm & Priorities Checklist ---
  Widget _buildTasksPreview({
    required BuildContext context,
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    final completedCount = _quickTasks.where((t) => t['isDone'] == true).length;
    final totalCount = _quickTasks.length;
    final progressFraction = totalCount > 0 ? (completedCount / totalCount) : 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2233) : borderColor,
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
            blurRadius: 10,
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
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A1838) : AppColors.softLavender,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.checkSquare,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Today's Priorities",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => MainNavigationShell.switchTab(context, 2),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
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

          const SizedBox(height: 10),

          // Completion Progress Bar in Primary Purple
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressFraction,
                    backgroundColor: isDark ? const Color(0xFF2A1838) : const Color(0xFFEBE3F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$completedCount of $totalCount completed',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ..._quickTasks.map((task) {
            final isDone = task['isDone'] as bool;
            final category = task['category'] as String;

            return InkWell(
              onTap: () {
                setState(() {
                  task['isDone'] = !isDone;
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      isDone ? LucideIcons.checkCircle2 : LucideIcons.circle,
                      size: 18,
                      color: isDone ? AppColors.primary : textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        task['title'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDone ? textSecondary : textPrimary,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: AppColors.badgeBgOf(context),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? const Color(0xFF3D2550) : const Color(0xFFEBE3F0),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.badgeTextOf(context),
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
}
