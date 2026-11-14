/// Models for Daily Spending Limit, Budget Pressure, and Spending Breakdown.
class DailySpendingLimitModel {
  final double recommendedDailyLimit;
  final double spentToday;
  final double remainingTodayAllowance;
  final double reportedFunds;
  final double calculatedAvailableFunds;
  final double reservedForCommitments;
  final double reservedForSavings;
  final double plannedExpensesAhead;
  final double emergencyReserve;
  final double remainingDiscretionaryBudget;
  final int remainingDaysInPeriod;
  final double budgetUtilizationPercent;
  final DateTime calculatedAt;
  final String explanation;
  final List<String> warnings;
  final List<String> actionableInsights;

  const DailySpendingLimitModel({
    required this.recommendedDailyLimit,
    required this.spentToday,
    required this.remainingTodayAllowance,
    required this.reportedFunds,
    required this.calculatedAvailableFunds,
    required this.reservedForCommitments,
    required this.reservedForSavings,
    required this.plannedExpensesAhead,
    required this.emergencyReserve,
    required this.remainingDiscretionaryBudget,
    required this.remainingDaysInPeriod,
    required this.budgetUtilizationPercent,
    required this.calculatedAt,
    required this.explanation,
    required this.warnings,
    required this.actionableInsights,
  });

  factory DailySpendingLimitModel.empty() {
    return DailySpendingLimitModel(
      recommendedDailyLimit: 0.0,
      spentToday: 0.0,
      remainingTodayAllowance: 0.0,
      reportedFunds: 0.0,
      calculatedAvailableFunds: 0.0,
      reservedForCommitments: 0.0,
      reservedForSavings: 0.0,
      plannedExpensesAhead: 0.0,
      emergencyReserve: 0.0,
      remainingDiscretionaryBudget: 0.0,
      remainingDaysInPeriod: 0,
      budgetUtilizationPercent: 0.0,
      calculatedAt: DateTime.now(),
      explanation: 'No spending limit data available',
      warnings: const [],
      actionableInsights: const [],
    );
  }

  factory DailySpendingLimitModel.fromJson(Map<String, dynamic> json) {
    return DailySpendingLimitModel(
      recommendedDailyLimit: (json['recommendedDailyLimit'] as num?)?.toDouble() ?? 0.0,
      spentToday: (json['spentToday'] as num?)?.toDouble() ?? 0.0,
      remainingTodayAllowance: (json['remainingTodayAllowance'] as num?)?.toDouble() ?? 0.0,
      reportedFunds: (json['reportedFunds'] as num?)?.toDouble() ?? 0.0,
      calculatedAvailableFunds: (json['calculatedAvailableFunds'] as num?)?.toDouble() ?? 0.0,
      reservedForCommitments: (json['reservedForCommitments'] as num?)?.toDouble() ?? 0.0,
      reservedForSavings: (json['reservedForSavings'] as num?)?.toDouble() ?? 0.0,
      plannedExpensesAhead: (json['plannedExpensesAhead'] as num?)?.toDouble() ?? 0.0,
      emergencyReserve: (json['emergencyReserve'] as num?)?.toDouble() ?? 0.0,
      remainingDiscretionaryBudget: (json['remainingDiscretionaryBudget'] as num?)?.toDouble() ?? 0.0,
      remainingDaysInPeriod: (json['remainingDaysInPeriod'] as num?)?.toInt() ?? 0,
      budgetUtilizationPercent: (json['budgetUtilizationPercent'] as num?)?.toDouble() ?? 0.0,
      calculatedAt: json['calculatedAt'] != null
          ? DateTime.tryParse(json['calculatedAt'].toString())?.toLocal() ?? DateTime.now()
          : DateTime.now(),
      explanation: json['explanation']?.toString() ?? '',
      warnings: (json['warnings'] as List?)?.map((e) => e.toString()).toList() ?? [],
      actionableInsights: (json['actionableInsights'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class BudgetPressureModel {
  final String pressureLevel; // HEALTHY, MODERATE, HIGH, CRITICAL
  final double pressureScore; // 0 - 100
  final double upcomingCommitmentsTotal;
  final double upcomingPlannedExpensesTotal;
  final double projectedBalanceAtPeriodEnd;
  final String summaryText;
  final List<String> pressureFactors;
  final List<String> actionableRecommendations;

  const BudgetPressureModel({
    required this.pressureLevel,
    required this.pressureScore,
    required this.upcomingCommitmentsTotal,
    required this.upcomingPlannedExpensesTotal,
    required this.projectedBalanceAtPeriodEnd,
    required this.summaryText,
    required this.pressureFactors,
    required this.actionableRecommendations,
  });

  bool get isHealthy => pressureLevel.toUpperCase() == 'HEALTHY';
  bool get isModerate => pressureLevel.toUpperCase() == 'MODERATE';
  bool get isHigh => pressureLevel.toUpperCase() == 'HIGH';
  bool get isCritical => pressureLevel.toUpperCase() == 'CRITICAL';

  factory BudgetPressureModel.empty() {
    return const BudgetPressureModel(
      pressureLevel: 'HEALTHY',
      pressureScore: 0.0,
      upcomingCommitmentsTotal: 0.0,
      upcomingPlannedExpensesTotal: 0.0,
      projectedBalanceAtPeriodEnd: 0.0,
      summaryText: 'Financial plan is well-balanced',
      pressureFactors: [],
      actionableRecommendations: [],
    );
  }

  factory BudgetPressureModel.fromJson(Map<String, dynamic> json) {
    return BudgetPressureModel(
      pressureLevel: json['pressureLevel']?.toString() ?? 'HEALTHY',
      pressureScore: (json['pressureScore'] as num?)?.toDouble() ?? 0.0,
      upcomingCommitmentsTotal: (json['upcomingCommitmentsTotal'] as num?)?.toDouble() ?? 0.0,
      upcomingPlannedExpensesTotal: (json['upcomingPlannedExpensesTotal'] as num?)?.toDouble() ?? 0.0,
      projectedBalanceAtPeriodEnd: (json['projectedBalanceAtPeriodEnd'] as num?)?.toDouble() ?? 0.0,
      summaryText: json['summaryText']?.toString() ?? '',
      pressureFactors: (json['pressureFactors'] as List?)?.map((e) => e.toString()).toList() ?? [],
      actionableRecommendations: (json['actionableRecommendations'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class SpendingBreakdownModel {
  final double totalIncomeMonth;
  final double totalExpensesMonth;
  final double totalCommitmentsMonth;
  final double totalSavingsMonth;
  final double plannedExpensesMonth;
  final double unallocatedDiscretionary;
  final Map<String, double> breakdownByCategory;
  final Map<String, double> commitmentsByType;

  const SpendingBreakdownModel({
    required this.totalIncomeMonth,
    required this.totalExpensesMonth,
    required this.totalCommitmentsMonth,
    required this.totalSavingsMonth,
    required this.plannedExpensesMonth,
    required this.unallocatedDiscretionary,
    required this.breakdownByCategory,
    required this.commitmentsByType,
  });

  factory SpendingBreakdownModel.fromJson(Map<String, dynamic> json) {
    Map<String, double> parseMap(dynamic map) {
      final res = <String, double>{};
      if (map is Map) {
        map.forEach((k, v) {
          if (v is num) res[k.toString()] = v.toDouble();
        });
      }
      return res;
    }

    return SpendingBreakdownModel(
      totalIncomeMonth: (json['totalIncomeMonth'] as num?)?.toDouble() ?? 0.0,
      totalExpensesMonth: (json['totalExpensesMonth'] as num?)?.toDouble() ?? 0.0,
      totalCommitmentsMonth: (json['totalCommitmentsMonth'] as num?)?.toDouble() ?? 0.0,
      totalSavingsMonth: (json['totalSavingsMonth'] as num?)?.toDouble() ?? 0.0,
      plannedExpensesMonth: (json['plannedExpensesMonth'] as num?)?.toDouble() ?? 0.0,
      unallocatedDiscretionary: (json['unallocatedDiscretionary'] as num?)?.toDouble() ?? 0.0,
      breakdownByCategory: parseMap(json['breakdownByCategory']),
      commitmentsByType: parseMap(json['commitmentsByType']),
    );
  }
}
