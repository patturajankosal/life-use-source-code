import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeuse_mobile/data/models/money/budget_plan_models.dart';
import 'package:lifeuse_mobile/data/models/money/planned_expense_models.dart';
import 'package:lifeuse_mobile/data/models/money/recurring_schedule_models.dart';
import 'package:lifeuse_mobile/data/models/money/spending_plan_models.dart';
import 'package:lifeuse_mobile/data/models/money/transaction_models.dart';
import 'package:lifeuse_mobile/presentation/screens/dashboard/models/dashboard_module_item.dart';

void main() {
  group('Money Manager Data Models Test Suite', () {
    test('TransactionModel parses backend JSON correctly', () {
      final json = {
        'id': 101,
        'userId': 42,
        'transactionType': 'EXPENSE',
        'categoryName': 'Groceries',
        'subCategory': 'Supermarket',
        'amount': 1450.75,
        'currency': 'INR',
        'paymentMethod': 'UPI',
        'transactionDate': '2026-10-16T12:00:00Z',
        'essential': true,
        'notes': 'Weekly fruits and veggies',
        'createdAt': '2026-10-16T12:05:00Z',
      };

      final tx = TransactionModel.fromJson(json);

      expect(tx.id, equals(101));
      expect(tx.userId, equals(42));
      expect(tx.transactionType, equals('EXPENSE'));
      expect(tx.isExpense, isTrue);
      expect(tx.isIncome, isFalse);
      expect(tx.categoryName, equals('Groceries'));
      expect(tx.amount, equals(1450.75));
      expect(tx.currency, equals('INR'));
      expect(tx.paymentMethod, equals('UPI'));
      expect(tx.essential, isTrue);
      expect(tx.notes, equals('Weekly fruits and veggies'));
    });

    test('TransactionSummaryModel parses backend summary and empty fallback', () {
      final empty = TransactionSummaryModel.empty();
      expect(empty.totalIncome, equals(0.0));
      expect(empty.totalExpenses, equals(0.0));
      expect(empty.netCashFlow, equals(0.0));
      expect(empty.transactionCount, equals(0));

      final json = {
        'totalIncome': 75000.0,
        'totalExpenses': 28500.50,
        'totalRefunds': 500.0,
        'netCashFlow': 46999.50,
        'essentialExpenses': 18000.0,
        'discretionaryExpenses': 10500.50,
        'transactionCount': 42,
        'expensesByCategory': {
          'Groceries': 8500.0,
          'Rent': 12000.0,
        },
      };

      final summary = TransactionSummaryModel.fromJson(json);
      expect(summary.totalIncome, equals(75000.0));
      expect(summary.totalExpenses, equals(28500.50));
      expect(summary.netCashFlow, equals(46999.50));
      expect(summary.transactionCount, equals(42));
      expect(summary.expensesByCategory['Groceries'], equals(8500.0));
    });

    test('DailySpendingLimitModel parses backend calculation correctly', () {
      final json = {
        'recommendedDailyLimit': 1250.0,
        'spentToday': 450.0,
        'remainingTodayAllowance': 800.0,
        'reportedFunds': 50000.0,
        'calculatedAvailableFunds': 38750.0,
        'reservedForCommitments': 7000.0,
        'reservedForSavings': 4250.0,
        'plannedExpensesAhead': 2000.0,
        'emergencyReserve': 5000.0,
        'remainingDiscretionaryBudget': 25000.0,
        'remainingDaysInPeriod': 20,
        'budgetUtilizationPercent': 36.0,
        'explanation': 'Paced well within daily limits.',
        'warnings': ['Approaching high dining expenditure'],
        'actionableInsights': ['Reduce non-essential dining for 2 days'],
      };

      final limit = DailySpendingLimitModel.fromJson(json);

      expect(limit.recommendedDailyLimit, equals(1250.0));
      expect(limit.spentToday, equals(450.0));
      expect(limit.remainingTodayAllowance, equals(800.0));
      expect(limit.calculatedAvailableFunds, equals(38750.0));
      expect(limit.remainingDaysInPeriod, equals(20));
      expect(limit.warnings.length, equals(1));
      expect(limit.actionableInsights.length, equals(1));
    });

    test('BudgetPressureModel computes pressure flags accurately', () {
      final healthy = BudgetPressureModel.fromJson({
        'pressureLevel': 'HEALTHY',
        'pressureScore': 22.5,
        'summaryText': 'Spending is under control.',
      });
      expect(healthy.isHealthy, isTrue);
      expect(healthy.isCritical, isFalse);

      final critical = BudgetPressureModel.fromJson({
        'pressureLevel': 'CRITICAL',
        'pressureScore': 92.0,
        'summaryText': 'Spending exceeds safe reserves.',
      });
      expect(critical.isCritical, isTrue);
      expect(critical.isHealthy, isFalse);
    });

    test('BudgetPlanModel parses multi-horizon plan and category limits', () {
      final json = {
        'id': 10,
        'userId': 1,
        'periodType': 'MONTHLY',
        'startDate': '2026-10-01',
        'endDate': '2026-10-31',
        'totalBudget': 35000.0,
        'carryForwardRule': 'RESET',
        'carriedForwardAmount': 0.0,
        'actualExpenses': 12500.0,
        'remainingBudget': 22500.0,
        'dailyRecommendedSpending': 1406.25,
        'periodUtilizationPercent': 35.71,
        'active': true,
        'notes': 'October Monthly Plan',
        'categoryLimits': [
          {
            'categoryId': 1,
            'categoryName': 'Food & Dining',
            'limitAmount': 8000.0,
            'essential': true,
          },
        ],
      };

      final plan = BudgetPlanModel.fromJson(json);
      expect(plan.id, equals(10));
      expect(plan.periodType, equals('MONTHLY'));
      expect(plan.totalBudget, equals(35000.0));
      expect(plan.remainingBudget, equals(22500.0));
      expect(plan.categoryLimits.length, equals(1));
      expect(plan.categoryLimits.first.categoryName, equals('Food & Dining'));
      expect(plan.categoryLimits.first.limitAmount, equals(8000.0));
    });

    test('PlannedExpense and RecurringSchedule parse models correctly', () {
      final pe = PlannedExpenseModel.fromJson({
        'id': 5,
        'userId': 1,
        'title': 'Car Service',
        'amount': 4500.0,
        'plannedDate': '2026-10-25',
        'categoryName': 'Transportation',
        'essential': true,
        'executed': false,
      });

      expect(pe.id, equals(5));
      expect(pe.title, equals('Car Service'));
      expect(pe.amount, equals(4500.0));
      expect(pe.executed, isFalse);

      final rs = RecurringScheduleModel.fromJson({
        'id': 8,
        'userId': 1,
        'title': 'Netflix Subscription',
        'transactionType': 'EXPENSE',
        'categoryName': 'Entertainment',
        'amount': 649.0,
        'frequency': 'MONTHLY',
        'startDate': '2026-01-01',
        'essential': false,
        'paymentMethod': 'CARD',
        'active': true,
      });

      expect(rs.id, equals(8));
      expect(rs.title, equals('Netflix Subscription'));
      expect(rs.frequency, equals('MONTHLY'));
      expect(rs.amount, equals(649.0));
    });

    test('DashboardModuleItem descriptor states and labels', () {
      const activeItem = DashboardModuleItem(
        id: 'money',
        title: 'Money Manager',
        subtitle: 'Cash Flow',
        description: 'Manage finances',
        icon: Icons.account_balance_wallet_rounded,
        accentColor: Colors.blue,
        status: ModuleStatus.active,
        highlights: ['Daily Limit'],
      );

      expect(activeItem.isActive, isTrue);
      expect(activeItem.isComingSoon, isFalse);
      expect(activeItem.statusLabel, equals('ACTIVE'));

      const comingSoonItem = DashboardModuleItem(
        id: 'tasks',
        title: 'Tasks & Habits',
        subtitle: 'Productivity',
        description: 'Track habits',
        icon: Icons.check_circle_outline_rounded,
        accentColor: Colors.green,
        status: ModuleStatus.comingSoon,
        highlights: ['Habits'],
      );

      expect(comingSoonItem.isComingSoon, isTrue);
      expect(comingSoonItem.isActive, isFalse);
      expect(comingSoonItem.statusLabel, equals('COMING SOON'));
    });
  });
}
