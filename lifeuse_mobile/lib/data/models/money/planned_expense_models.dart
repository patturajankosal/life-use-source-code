/// Planned Expense models matching PlannedExpenseResponse & PlannedExpenseRequest
class PlannedExpenseModel {
  final int id;
  final int userId;
  final String title;
  final double amount;
  final DateTime plannedDate;
  final String categoryName;
  final bool essential;
  final bool executed;
  final int? transactionId;
  final String? notes;
  final DateTime? createdAt;

  const PlannedExpenseModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.plannedDate,
    required this.categoryName,
    required this.essential,
    required this.executed,
    this.transactionId,
    this.notes,
    this.createdAt,
  });

  factory PlannedExpenseModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic date) {
      if (date == null) return DateTime.now();
      return DateTime.tryParse(date.toString()) ?? DateTime.now();
    }

    return PlannedExpenseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      plannedDate: parseDate(json['plannedDate']),
      categoryName: json['categoryName']?.toString() ?? 'General',
      essential: json['essential'] == true,
      executed: json['executed'] == true,
      transactionId: (json['transactionId'] as num?)?.toInt(),
      notes: json['notes']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())?.toLocal()
          : null,
    );
  }
}

class PlannedExpenseRequest {
  final String title;
  final double amount;
  final DateTime plannedDate;
  final String? categoryName;
  final bool essential;
  final String? notes;

  const PlannedExpenseRequest({
    required this.title,
    required this.amount,
    required this.plannedDate,
    this.categoryName,
    this.essential = false,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    String formatDateOnly(DateTime dt) {
      return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    }

    return {
      'title': title,
      'amount': amount,
      'plannedDate': formatDateOnly(plannedDate),
      'categoryName': categoryName,
      'essential': essential,
      'notes': notes,
    };
  }
}
