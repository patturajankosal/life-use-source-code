/// Transaction data models matching Spring Boot com.lifeuse.money.models.dto
class TransactionModel {
  final int id;
  final int userId;
  final String transactionType; // EXPENSE, INCOME, REFUND
  final String categoryName;
  final String? subCategory;
  final double amount;
  final String currency;
  final String paymentMethod; // UPI, CASH, CARD, NET_BANKING
  final DateTime transactionDate;
  final bool essential;
  final String? idempotencyKey;
  final String? notes;
  final int? plannedExpenseId;
  final int? recurringOccurrenceId;
  final DateTime? createdAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.transactionType,
    required this.categoryName,
    this.subCategory,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.transactionDate,
    required this.essential,
    this.idempotencyKey,
    this.notes,
    this.plannedExpenseId,
    this.recurringOccurrenceId,
    this.createdAt,
  });

  bool get isIncome => transactionType.toUpperCase() == 'INCOME';
  bool get isExpense => transactionType.toUpperCase() == 'EXPENSE';
  bool get isRefund => transactionType.toUpperCase() == 'REFUND';

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      transactionType: json['transactionType']?.toString() ?? 'EXPENSE',
      categoryName: json['categoryName']?.toString() ?? 'General',
      subCategory: json['subCategory']?.toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'INR',
      paymentMethod: json['paymentMethod']?.toString() ?? 'UPI',
      transactionDate: json['transactionDate'] != null
          ? DateTime.tryParse(json['transactionDate'].toString())?.toLocal() ?? DateTime.now()
          : DateTime.now(),
      essential: json['essential'] == true,
      idempotencyKey: json['idempotencyKey']?.toString(),
      notes: json['notes']?.toString(),
      plannedExpenseId: (json['plannedExpenseId'] as num?)?.toInt(),
      recurringOccurrenceId: (json['recurringOccurrenceId'] as num?)?.toInt(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())?.toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'transactionType': transactionType,
      'categoryName': categoryName,
      'subCategory': subCategory,
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'transactionDate': transactionDate.toUtc().toIso8601String(),
      'essential': essential,
      'idempotencyKey': idempotencyKey,
      'notes': notes,
      'plannedExpenseId': plannedExpenseId,
      'recurringOccurrenceId': recurringOccurrenceId,
      'createdAt': createdAt?.toUtc().toIso8601String(),
    };
  }
}

class TransactionCreateRequest {
  final String transactionType; // EXPENSE, INCOME, REFUND
  final String categoryName;
  final String? subCategory;
  final double amount;
  final String currency;
  final String paymentMethod;
  final DateTime transactionDate;
  final bool essential;
  final String? idempotencyKey;
  final String? notes;
  final int? plannedExpenseId;

  const TransactionCreateRequest({
    required this.transactionType,
    required this.categoryName,
    this.subCategory,
    required this.amount,
    this.currency = 'INR',
    this.paymentMethod = 'UPI',
    required this.transactionDate,
    this.essential = false,
    this.idempotencyKey,
    this.notes,
    this.plannedExpenseId,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'categoryName': categoryName,
      'subCategory': subCategory,
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'transactionDate': transactionDate.toUtc().toIso8601String(),
      'essential': essential,
      'idempotencyKey': idempotencyKey,
      'notes': notes,
      'plannedExpenseId': plannedExpenseId,
    };
  }
}

class TransactionSummaryModel {
  final double totalIncome;
  final double totalExpenses;
  final double totalRefunds;
  final double netCashFlow;
  final double essentialExpenses;
  final double discretionaryExpenses;
  final int transactionCount;
  final Map<String, double> expensesByCategory;

  const TransactionSummaryModel({
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalRefunds,
    required this.netCashFlow,
    required this.essentialExpenses,
    required this.discretionaryExpenses,
    required this.transactionCount,
    required this.expensesByCategory,
  });

  factory TransactionSummaryModel.empty() {
    return const TransactionSummaryModel(
      totalIncome: 0.0,
      totalExpenses: 0.0,
      totalRefunds: 0.0,
      netCashFlow: 0.0,
      essentialExpenses: 0.0,
      discretionaryExpenses: 0.0,
      transactionCount: 0,
      expensesByCategory: {},
    );
  }

  factory TransactionSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['expensesByCategory'];
    final categoryMap = <String, double>{};
    if (rawCategories is Map) {
      rawCategories.forEach((k, v) {
        if (v is num) {
          categoryMap[k.toString()] = v.toDouble();
        }
      });
    }

    return TransactionSummaryModel(
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      totalRefunds: (json['totalRefunds'] as num?)?.toDouble() ?? 0.0,
      netCashFlow: (json['netCashFlow'] as num?)?.toDouble() ?? 0.0,
      essentialExpenses: (json['essentialExpenses'] as num?)?.toDouble() ?? 0.0,
      discretionaryExpenses: (json['discretionaryExpenses'] as num?)?.toDouble() ?? 0.0,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
      expensesByCategory: categoryMap,
    );
  }
}
