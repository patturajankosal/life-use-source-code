/// Budget Plan models matching com.lifeuse.money.models.dto
class BudgetCategoryLimitModel {
  final int categoryId;
  final String categoryName;
  final double limitAmount;
  final bool essential;

  const BudgetCategoryLimitModel({
    required this.categoryId,
    required this.categoryName,
    required this.limitAmount,
    this.essential = false,
  });

  factory BudgetCategoryLimitModel.fromJson(Map<String, dynamic> json) {
    return BudgetCategoryLimitModel(
      categoryId: (json['categoryId'] as num?)?.toInt() ?? 0,
      categoryName: json['categoryName']?.toString() ?? '',
      limitAmount: (json['limitAmount'] as num?)?.toDouble() ?? 0.0,
      essential: json['essential'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'limitAmount': limitAmount,
      'essential': essential,
    };
  }
}

class BudgetPlanModel {
  final int id;
  final int userId;
  final String periodType; // MONTHLY, WEEKLY, BI_WEEKLY, CUSTOM
  final DateTime startDate;
  final DateTime endDate;
  final double totalBudget;
  final String carryForwardRule; // RESET, CARRY_POSITIVE, CARRY_NEGATIVE, CARRY_ALL
  final double carriedForwardAmount;
  final double actualExpenses;
  final double remainingBudget;
  final double dailyRecommendedSpending;
  final double periodUtilizationPercent;
  final bool active;
  final String? notes;
  final List<BudgetCategoryLimitModel> categoryLimits;
  final DateTime? createdAt;

  const BudgetPlanModel({
    required this.id,
    required this.userId,
    required this.periodType,
    required this.startDate,
    required this.endDate,
    required this.totalBudget,
    required this.carryForwardRule,
    required this.carriedForwardAmount,
    required this.actualExpenses,
    required this.remainingBudget,
    required this.dailyRecommendedSpending,
    required this.periodUtilizationPercent,
    required this.active,
    this.notes,
    required this.categoryLimits,
    this.createdAt,
  });

  factory BudgetPlanModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic date) {
      if (date == null) return DateTime.now();
      return DateTime.tryParse(date.toString()) ?? DateTime.now();
    }

    final rawLimits = json['categoryLimits'];
    final limitsList = <BudgetCategoryLimitModel>[];
    if (rawLimits is List) {
      for (final item in rawLimits) {
        if (item is Map<String, dynamic>) {
          limitsList.add(BudgetCategoryLimitModel.fromJson(item));
        }
      }
    }

    return BudgetPlanModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      periodType: json['periodType']?.toString() ?? 'MONTHLY',
      startDate: parseDate(json['startDate']),
      endDate: parseDate(json['endDate']),
      totalBudget: (json['totalBudget'] as num?)?.toDouble() ?? 0.0,
      carryForwardRule: json['carryForwardRule']?.toString() ?? 'RESET',
      carriedForwardAmount: (json['carriedForwardAmount'] as num?)?.toDouble() ?? 0.0,
      actualExpenses: (json['actualExpenses'] as num?)?.toDouble() ?? 0.0,
      remainingBudget: (json['remainingBudget'] as num?)?.toDouble() ?? 0.0,
      dailyRecommendedSpending: (json['dailyRecommendedSpending'] as num?)?.toDouble() ?? 0.0,
      periodUtilizationPercent: (json['periodUtilizationPercent'] as num?)?.toDouble() ?? 0.0,
      active: json['active'] == true,
      notes: json['notes']?.toString(),
      categoryLimits: limitsList,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())?.toLocal()
          : null,
    );
  }
}

class BudgetPlanRequest {
  final String periodType; // MONTHLY, WEEKLY, BI_WEEKLY, CUSTOM
  final DateTime startDate;
  final DateTime endDate;
  final double totalBudget;
  final String carryForwardRule; // RESET, CARRY_POSITIVE, CARRY_NEGATIVE, CARRY_ALL
  final String? notes;
  final List<BudgetCategoryLimitModel> categoryLimits;

  const BudgetPlanRequest({
    required this.periodType,
    required this.startDate,
    required this.endDate,
    required this.totalBudget,
    this.carryForwardRule = 'RESET',
    this.notes,
    this.categoryLimits = const [],
  });

  Map<String, dynamic> toJson() {
    String formatDateOnly(DateTime dt) {
      return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    }

    return {
      'periodType': periodType,
      'startDate': formatDateOnly(startDate),
      'endDate': formatDateOnly(endDate),
      'totalBudget': totalBudget,
      'carryForwardRule': carryForwardRule,
      'notes': notes,
      'categoryLimits': categoryLimits.map((e) => e.toJson()).toList(),
    };
  }
}
