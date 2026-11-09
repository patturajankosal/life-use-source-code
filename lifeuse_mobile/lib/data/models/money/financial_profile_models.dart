/// Financial Profile, Income Sources, Commitments, and Savings Goals models
class FinancialProfileModel {
  final int id;
  final int userId;
  final String currency;
  final double reportedBalance;
  final double emergencyReserve;
  final double minimumCashReserve;
  final String weekStartDay;
  final String timezone;
  final String defaultCarryForward;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FinancialProfileModel({
    required this.id,
    required this.userId,
    required this.currency,
    required this.reportedBalance,
    required this.emergencyReserve,
    required this.minimumCashReserve,
    required this.weekStartDay,
    required this.timezone,
    required this.defaultCarryForward,
    this.createdAt,
    this.updatedAt,
  });

  factory FinancialProfileModel.fromJson(Map<String, dynamic> json) {
    return FinancialProfileModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
      reportedBalance: (json['reportedBalance'] as num?)?.toDouble() ?? 0.0,
      emergencyReserve: (json['emergencyReserve'] as num?)?.toDouble() ?? 0.0,
      minimumCashReserve: (json['minimumCashReserve'] as num?)?.toDouble() ?? 0.0,
      weekStartDay: json['weekStartDay']?.toString() ?? 'MONDAY',
      timezone: json['timezone']?.toString() ?? 'Asia/Kolkata',
      defaultCarryForward: json['defaultCarryForward']?.toString() ?? 'RESET',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())?.toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())?.toLocal()
          : null,
    );
  }
}

class FinancialProfileRequest {
  final String currency;
  final double reportedBalance;
  final double emergencyReserve;
  final double minimumCashReserve;
  final String weekStartDay;
  final String timezone;
  final String defaultCarryForward;

  const FinancialProfileRequest({
    this.currency = 'INR',
    required this.reportedBalance,
    this.emergencyReserve = 0.0,
    this.minimumCashReserve = 0.0,
    this.weekStartDay = 'MONDAY',
    this.timezone = 'Asia/Kolkata',
    this.defaultCarryForward = 'RESET',
  });

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'reportedBalance': reportedBalance,
      'emergencyReserve': emergencyReserve,
      'minimumCashReserve': minimumCashReserve,
      'weekStartDay': weekStartDay,
      'timezone': timezone,
      'defaultCarryForward': defaultCarryForward,
    };
  }
}

class IncomeSourceModel {
  final int id;
  final int userId;
  final String sourceName;
  final double amount;
  final String frequency; // MONTHLY, BI_WEEKLY, WEEKLY, ONE_TIME
  final int? expectedDayOfMonth;
  final bool active;
  final String? notes;

  const IncomeSourceModel({
    required this.id,
    required this.userId,
    required this.sourceName,
    required this.amount,
    required this.frequency,
    this.expectedDayOfMonth,
    required this.active,
    this.notes,
  });

  factory IncomeSourceModel.fromJson(Map<String, dynamic> json) {
    return IncomeSourceModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      sourceName: json['sourceName']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      frequency: json['frequency']?.toString() ?? 'MONTHLY',
      expectedDayOfMonth: (json['expectedDayOfMonth'] as num?)?.toInt(),
      active: json['active'] == true,
      notes: json['notes']?.toString(),
    );
  }
}

class FinancialCommitmentModel {
  final int id;
  final int userId;
  final String title;
  final String commitmentType; // RENT, EMI, BILL, SUBSCRIPTION, INSURANCE, LOAN
  final double amount;
  final int? dueDayOfMonth;
  final String frequency;
  final bool essential;
  final bool active;
  final String? notes;

  const FinancialCommitmentModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.commitmentType,
    required this.amount,
    this.dueDayOfMonth,
    required this.frequency,
    required this.essential,
    required this.active,
    this.notes,
  });

  factory FinancialCommitmentModel.fromJson(Map<String, dynamic> json) {
    return FinancialCommitmentModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      commitmentType: json['commitmentType']?.toString() ?? 'BILL',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      dueDayOfMonth: (json['dueDayOfMonth'] as num?)?.toInt(),
      frequency: json['frequency']?.toString() ?? 'MONTHLY',
      essential: json['essential'] == true,
      active: json['active'] == true,
      notes: json['notes']?.toString(),
    );
  }
}

class SavingsGoalModel {
  final int id;
  final int userId;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final double monthlyContribution;
  final DateTime? targetDate;
  final bool active;
  final double progressPercent;

  const SavingsGoalModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.monthlyContribution,
    this.targetDate,
    required this.active,
    required this.progressPercent,
  });

  factory SavingsGoalModel.fromJson(Map<String, dynamic> json) {
    return SavingsGoalModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      monthlyContribution: (json['monthlyContribution'] as num?)?.toDouble() ?? 0.0,
      targetDate: json['targetDate'] != null
          ? DateTime.tryParse(json['targetDate'].toString())
          : null,
      active: json['active'] == true,
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
