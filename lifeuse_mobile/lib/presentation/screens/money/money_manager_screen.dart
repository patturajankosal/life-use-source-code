import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/auth_guard_dialog.dart';
import '../../../core/widgets/lifeuse_badge.dart';
import '../../../core/widgets/lifeuse_stat_card.dart';
import '../../../core/widgets/sweet_alert.dart';
import '../../../data/models/money/planned_expense_models.dart';
import '../../../data/models/money/recurring_schedule_models.dart';
import '../../../data/models/money/transaction_models.dart';
import '../../state/auth_provider.dart';
import '../../state/money_provider.dart';
import 'dialogs/add_planned_expense_dialog.dart';
import 'dialogs/add_recurring_schedule_dialog.dart';
import 'dialogs/add_transaction_dialog.dart';
import 'dialogs/create_budget_plan_dialog.dart';

/// Comprehensive Money Manager screen connected to the Spring Boot backend.
/// Contains 4 tabs: Overview, Transactions, Budgets, and Planning & Schedules.
class MoneyManagerScreen extends StatefulWidget {
  final int initialTabIndex;

  const MoneyManagerScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<MoneyManagerScreen> createState() => _MoneyManagerScreenState();
}

class _MoneyManagerScreenState extends State<MoneyManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  int _planningSubTabIndex = 0; // 0: Planned Expenses, 1: Recurring Schedules

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<MoneyProvider>().loadDashboardData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final money = context.watch<MoneyProvider>();
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Money Manager',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 18),
            tooltip: 'Refresh Financial Data',
            onPressed: () {
              final auth = context.read<AuthProvider>();
              if (auth.isAuthenticated) {
                money.loadDashboardData(silent: true);
              } else {
                AuthGuardDialog.protect(
                  context,
                  title: 'Sign In to Sync Finances',
                  message: 'Sign in to access your live bank accounts, monthly limits, and budgets.',
                  onAuthenticated: () => money.loadDashboardData(silent: true),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.plus, size: 20),
            tooltip: 'Record Transaction',
            onPressed: () {
              AuthGuardDialog.protect(
                context,
                title: 'Sign In to Record Transactions',
                message: 'Keep your transactions, accounts, and budgets synced securely to your LifeUse account.',
                onAuthenticated: () => AddTransactionDialog.show(context),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Transactions'),
            Tab(text: 'Budgets'),
            Tab(text: 'Planning'),
          ],
        ),
      ),
      body: money.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, money),
                _buildTransactionsTab(context, money),
                _buildBudgetsTab(context, money),
                _buildPlanningTab(context, money),
              ],
            ).animate().fadeIn(duration: 250.ms),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(LucideIcons.plus, color: Colors.white, size: 18),
        label: Text(
          'Add',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        onPressed: () => _handleFabAction(context),
      ),
    );
  }

  void _handleFabAction(BuildContext context) {
    AuthGuardDialog.protect(
      context,
      title: 'Sign In to Money Manager',
      message: 'Sign in or create an account to record transactions, create budget plans, and sync recurring bills.',
      onAuthenticated: () {
        switch (_tabController.index) {
          case 0:
          case 1:
            AddTransactionDialog.show(context);
            break;
          case 2:
            CreateBudgetPlanDialog.show(context);
            break;
          case 3:
            if (_planningSubTabIndex == 0) {
              AddPlannedExpenseDialog.show(context);
            } else {
              AddRecurringScheduleDialog.show(context);
            }
            break;
        }
      },
    );
  }

  // ===========================================================================
  // TAB 1: OVERVIEW
  // ===========================================================================
  Widget _buildOverviewTab(BuildContext context, MoneyProvider money) {
    final auth = context.watch<AuthProvider>();
    final daily = money.dailyLimit;
    final pressure = money.budgetPressure;
    final summary = money.summary;
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: () => money.loadDashboardData(silent: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Guest Mode Notice Banner
            if (!auth.isAuthenticated)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.16 : 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.cloud,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guest Preview Mode',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Sign in to synchronize bank accounts, budgets, and transactions.',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        AuthGuardDialog.protect(
                          context,
                          title: 'Sign In to Money Manager',
                          message: 'Sign in to access your live bank accounts, monthly limits, and budgets.',
                          onAuthenticated: () => money.loadDashboardData(),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 1. Daily Spending Limit Card
            if (daily != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [const Color(0xFFEEF2FF), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
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
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                LucideIcons.gauge,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Intelligent Daily Limit',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        LifeUseBadge(
                          text: '${daily.remainingDaysInPeriod} DAYS LEFT',
                          variant: LifeUseBadgeVariant.active,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Big Number
                    Text(
                      _currencyFormat.format(daily.remainingTodayAllowance),
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: daily.remainingTodayAllowance >= 0
                            ? AppColors.primary
                            : AppColors.error,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Remaining daily allowance for today (Target: ${_currencyFormat.format(daily.recommendedDailyLimit)}/day)',
                      style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary),
                    ),
                    const SizedBox(height: 16),

                    // Progress Bar: Spent Today vs Recommended Daily
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: daily.recommendedDailyLimit > 0
                            ? (daily.spentToday / daily.recommendedDailyLimit).clamp(0.0, 1.0)
                            : 0.0,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.06),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          daily.spentToday > daily.recommendedDailyLimit
                              ? AppColors.error
                              : AppColors.success,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spent Today: ${_currencyFormat.format(daily.spentToday)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                        Text(
                          'Available Funds: ${_currencyFormat.format(daily.calculatedAvailableFunds)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),

                    if (daily.warnings.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.alertTriangle, size: 16, color: AppColors.warning),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                daily.warnings.first,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 2. Budget Pressure Card
            if (pressure != null) ...[
              Container(
                padding: const EdgeInsets.all(18),
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
                        Row(
                          children: [
                            Icon(
                              LucideIcons.barChart3,
                              size: 20,
                              color: _getPressureColor(pressure.pressureLevel),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Budget Health & Pressure',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        LifeUseBadge(
                          text: pressure.pressureLevel.toUpperCase(),
                          variant: pressure.isHealthy
                              ? LifeUseBadgeVariant.active
                              : (pressure.isModerate
                                  ? LifeUseBadgeVariant.pending
                                  : LifeUseBadgeVariant.terminated),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      pressure.summaryText,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        height: 1.4,
                        color: textSecondary,
                      ),
                    ),
                    if (pressure.actionableRecommendations.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: pressure.actionableRecommendations.take(2).map((rec) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '💡 $rec',
                              style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 3. Stat Cards Row (Income / Expenses / Net)
            Row(
              children: [
                Expanded(
                  child: LifeUseStatCard(
                    label: 'Income',
                    value: _currencyFormat.format(summary.totalIncome),
                    subtitle: 'This Month',
                    variant: LifeUseStatVariant.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LifeUseStatCard(
                    label: 'Expenses',
                    value: _currencyFormat.format(summary.totalExpenses),
                    subtitle: 'This Month',
                    variant: LifeUseStatVariant.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LifeUseStatCard(
              label: 'Net Cash Flow',
              value: _currencyFormat.format(summary.netCashFlow),
              subtitle: summary.netCashFlow >= 0 ? 'Positive balance growth' : 'Deficit spending',
              variant: summary.netCashFlow >= 0 ? LifeUseStatVariant.purple : LifeUseStatVariant.blue,
            ),
            const SizedBox(height: 20),

            // 4. Recent Transactions Header & List
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
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (money.transactions.isEmpty)
              _buildEmptyPlaceholder(
                icon: LucideIcons.receipt,
                title: 'No Transactions Yet',
                description: 'Tap the "+ Add" button to record your first income or expense.',
                actionLabel: 'Record Transaction',
                onAction: () => AddTransactionDialog.show(context),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: money.transactions.take(5).length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final tx = money.transactions[i];
                  return _buildTransactionCard(ctx, tx, money);
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 2: TRANSACTIONS
  // ===========================================================================
  Widget _buildTransactionsTab(BuildContext context, MoneyProvider money) {
    final textSecondary = AppColors.textSecondaryOf(context);
    final borderColor = AppColors.borderOf(context);
    final surfaceColor = AppColors.surfaceOf(context);

    final typeFilters = ['ALL', 'EXPENSE', 'INCOME', 'REFUND'];

    return Column(
      children: [
        // Filter Bar (All, Expense, Income, Refund)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: typeFilters.map((type) {
                final isSelected = money.selectedTypeFilter == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : textSecondary,
                    ),
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.transparent,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : borderColor,
                    ),
                    onSelected: (_) => money.setTypeFilter(type),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Transactions List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => money.refreshTransactions(),
            child: money.transactions.isEmpty
                ? _buildEmptyPlaceholder(
                    icon: LucideIcons.receipt,
                    title: 'No Transactions Found',
                    description: 'No transactions match your current filter settings.',
                    actionLabel: 'Record New Transaction',
                    onAction: () => AddTransactionDialog.show(context),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: money.transactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final tx = money.transactions[i];
                      return _buildTransactionCard(ctx, tx, money);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 3: BUDGETS
  // ===========================================================================
  Widget _buildBudgetsTab(BuildContext context, MoneyProvider money) {
    final activePlan = money.activeBudgetPlan;
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Active Budget Card
          if (activePlan != null) ...[
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              LucideIcons.pieChart,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${activePlan.periodType} Budget Plan',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                '${_dateFormat.format(activePlan.startDate)} - ${_dateFormat.format(activePlan.endDate)}',
                                style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const LifeUseBadge(
                        text: 'ACTIVE',
                        variant: LifeUseBadgeVariant.active,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Big Remaining Budget
                  Text(
                    _currencyFormat.format(activePlan.remainingBudget),
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: activePlan.remainingBudget >= 0 ? AppColors.primary : AppColors.error,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Remaining from total ${_currencyFormat.format(activePlan.totalBudget)} budget',
                    style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary),
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: activePlan.totalBudget > 0
                          ? (activePlan.actualExpenses / activePlan.totalBudget).clamp(0.0, 1.0)
                          : 0.0,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.06),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        activePlan.actualExpenses > activePlan.totalBudget
                            ? AppColors.error
                            : AppColors.primary,
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spent: ${_currencyFormat.format(activePlan.actualExpenses)}',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                      ),
                      Text(
                        '${activePlan.periodUtilizationPercent.toStringAsFixed(1)}% Used',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: activePlan.periodUtilizationPercent > 100
                              ? AppColors.error
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ] else ...[
            _buildEmptyPlaceholder(
              icon: LucideIcons.pieChart,
              title: 'No Active Budget Plan',
              description: 'Create a budget plan to set spending targets and monitor category limits.',
              actionLabel: 'Create Budget Plan',
              onAction: () => CreateBudgetPlanDialog.show(context),
            ),
            const SizedBox(height: 20),
          ],

          // Action Button to Create New Plan
          AppButton(
            title: 'Create New Budget Plan',
            icon: LucideIcons.plusCircle,
            isOutlined: true,
            onPressed: () => CreateBudgetPlanDialog.show(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 4: PLANNING & SCHEDULES
  // ===========================================================================
  Widget _buildPlanningTab(BuildContext context, MoneyProvider money) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    return Column(
      children: [
        // Sub-segmented toggle: Planned Expenses vs Recurring Schedules
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildSubTabButton(
                  title: 'Planned Expenses (${money.plannedExpenses.length})',
                  index: 0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSubTabButton(
                  title: 'Recurring Schedules (${money.recurringSchedules.length})',
                  index: 1,
                ),
              ),
            ],
          ),
        ),

        // Sub-view Body
        Expanded(
          child: _planningSubTabIndex == 0
              ? _buildPlannedExpensesList(context, money)
              : _buildRecurringSchedulesList(context, money),
        ),
      ],
    );
  }

  Widget _buildSubTabButton({required String title, required int index}) {
    final isSelected = _planningSubTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _planningSubTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderOf(context),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textSecondaryOf(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlannedExpensesList(BuildContext context, MoneyProvider money) {
    if (money.plannedExpenses.isEmpty) {
      return _buildEmptyPlaceholder(
        icon: LucideIcons.calendar,
        title: 'No Planned Expenses',
        description: 'Schedule future expenses or special-day spending to protect daily limits.',
        actionLabel: 'Schedule Expense',
        onAction: () => AddPlannedExpenseDialog.show(context),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: money.plannedExpenses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final pe = money.plannedExpenses[i];
        return _buildPlannedExpenseCard(ctx, pe, money);
      },
    );
  }

  Widget _buildPlannedExpenseCard(
    BuildContext context,
    PlannedExpenseModel pe,
    MoneyProvider money,
  ) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  pe.title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
              LifeUseBadge(
                text: pe.executed ? 'EXECUTED' : 'UPCOMING',
                variant: pe.executed ? LifeUseBadgeVariant.active : LifeUseBadgeVariant.pending,
              ),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '📅 ${_dateFormat.format(pe.plannedDate)}  •  ${pe.categoryName}',
                style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
              ),
              Text(
                _currencyFormat.format(pe.amount),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          if (pe.notes != null && pe.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              pe.notes!,
              style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
            ),
          ],

          if (!pe.executed) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18, color: AppColors.error),
                  tooltip: 'Delete Planned Expense',
                  onPressed: () => _confirmDeletePlannedExpense(context, pe, money),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(LucideIcons.checkCheck, size: 16, color: Colors.white),
                  label: Text(
                    'Execute Now',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(110, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _confirmExecutePlannedExpense(context, pe, money),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _confirmExecutePlannedExpense(
    BuildContext context,
    PlannedExpenseModel pe,
    MoneyProvider money,
  ) {
    SweetAlert.showConfirm(
      context,
      title: 'Execute Expense?',
      message: 'This will convert "${pe.title}" into an actual recorded transaction of ${_currencyFormat.format(pe.amount)}.',
      confirmText: 'Execute Now',
      onConfirm: () async {
        try {
          await money.executePlannedExpense(pe.id);
          if (context.mounted) {
            SweetAlert.showSuccess(
              context,
              title: 'Expense Executed',
              message: 'Recorded "${pe.title}" as an active transaction.',
            );
          }
        } catch (e) {
          if (context.mounted) {
            SweetAlert.showError(
              context,
              title: 'Execution Failed',
              message: e.toString(),
            );
          }
        }
      },
    );
  }

  void _confirmDeletePlannedExpense(
    BuildContext context,
    PlannedExpenseModel pe,
    MoneyProvider money,
  ) {
    SweetAlert.showConfirm(
      context,
      title: 'Delete Planned Expense',
      message: 'Are you sure you want to delete "${pe.title}"?',
      confirmText: 'Delete',
      isDestructive: true,
      onConfirm: () async {
        try {
          await money.removePlannedExpense(pe.id);
          if (context.mounted) {
            SweetAlert.showSuccess(
              context,
              title: 'Deleted',
              message: 'Planned expense was removed.',
            );
          }
        } catch (e) {
          if (context.mounted) {
            SweetAlert.showError(
              context,
              title: 'Delete Failed',
              message: e.toString(),
            );
          }
        }
      },
    );
  }

  Widget _buildRecurringSchedulesList(BuildContext context, MoneyProvider money) {
    if (money.recurringSchedules.isEmpty) {
      return _buildEmptyPlaceholder(
        icon: LucideIcons.repeat,
        title: 'No Recurring Schedules',
        description: 'Set up recurring bills, subscriptions, or salaries for automated tracking.',
        actionLabel: 'Add Schedule',
        onAction: () => AddRecurringScheduleDialog.show(context),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: money.recurringSchedules.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final rs = money.recurringSchedules[i];
        return _buildRecurringScheduleCard(ctx, rs, money);
      },
    );
  }

  Widget _buildRecurringScheduleCard(
    BuildContext context,
    RecurringScheduleModel rs,
    MoneyProvider money,
  ) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  rs.title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
              LifeUseBadge(
                text: rs.frequency.toUpperCase(),
                variant: LifeUseBadgeVariant.active,
              ),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next: ${rs.nextOccurrenceDate != null ? _dateFormat.format(rs.nextOccurrenceDate!) : "Pending"}  •  ${rs.categoryName}',
                style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
              ),
              Text(
                _currencyFormat.format(rs.amount),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: rs.transactionType == 'INCOME' ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment: ${rs.paymentMethod}  •  ${rs.essential ? "Essential" : "Discretionary"}',
                style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 18, color: AppColors.error),
                tooltip: 'Delete Schedule',
                onPressed: () => _confirmDeleteRecurringSchedule(context, rs, money),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteRecurringSchedule(
    BuildContext context,
    RecurringScheduleModel rs,
    MoneyProvider money,
  ) {
    SweetAlert.showConfirm(
      context,
      title: 'Delete Recurring Schedule',
      message: 'Are you sure you want to delete "${rs.title}"?',
      confirmText: 'Delete',
      isDestructive: true,
      onConfirm: () async {
        try {
          await money.removeRecurringSchedule(rs.id);
          if (context.mounted) {
            SweetAlert.showSuccess(
              context,
              title: 'Deleted',
              message: 'Recurring schedule was removed.',
            );
          }
        } catch (e) {
          if (context.mounted) {
            SweetAlert.showError(
              context,
              title: 'Delete Failed',
              message: e.toString(),
            );
          }
        }
      },
    );
  }

  // ===========================================================================
  // SHARED TRANSACTION CARD WIDGET
  // ===========================================================================
  Widget _buildTransactionCard(
    BuildContext context,
    TransactionModel tx,
    MoneyProvider money,
  ) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);

    final isIncome = tx.isIncome;
    final isRefund = tx.isRefund;
    final color = isIncome
        ? AppColors.success
        : (isRefund ? AppColors.accent : AppColors.error);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Directional Flow Category Icon Container
          LifeUseDashboardIcon(
            icon: isIncome
                ? LucideIcons.arrowDownLeft
                : (isRefund ? LucideIcons.rotateCcw : LucideIcons.arrowUpRight),
            accentColor: color,
            size: 20,
            containerSize: 42,
            radius: 12,
          ),
          const SizedBox(width: 14),

          // Title & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.categoryName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      _dateFormat.format(tx.transactionDate),
                      style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(color: textSecondary, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tx.paymentMethod,
                      style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                    ),
                  ],
                ),
                if (tx.notes != null && tx.notes!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    tx.notes!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                  ),
                ],
              ],
            ),
          ),

          // Amount & Delete action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? "+" : "-"}${_currencyFormat.format(tx.amount)}',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 16),
                color: textSecondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Delete Transaction',
                onPressed: () => _confirmDeleteTransaction(context, tx, money),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTransaction(
    BuildContext context,
    TransactionModel tx,
    MoneyProvider money,
  ) {
    SweetAlert.showConfirm(
      context,
      title: 'Delete Transaction',
      message: 'Delete ${_currencyFormat.format(tx.amount)} for ${tx.categoryName}?',
      confirmText: 'Delete',
      isDestructive: true,
      onConfirm: () async {
        try {
          await money.removeTransaction(tx.id);
          if (context.mounted) {
            SweetAlert.showSuccess(
              context,
              title: 'Deleted',
              message: 'Transaction was removed.',
            );
          }
        } catch (e) {
          if (context.mounted) {
            SweetAlert.showError(
              context,
              title: 'Delete Failed',
              message: e.toString(),
            );
          }
        }
      },
    );
  }

  Widget _buildEmptyPlaceholder({
    required IconData icon,
    required String title,
    required String description,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                actionLabel,
                style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPressureColor(String level) {
    switch (level.toUpperCase()) {
      case 'HEALTHY':
        return AppColors.success;
      case 'MODERATE':
        return AppColors.warning;
      case 'HIGH':
      case 'CRITICAL':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
