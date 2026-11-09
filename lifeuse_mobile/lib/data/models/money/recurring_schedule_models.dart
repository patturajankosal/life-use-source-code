/// Recurring Schedule & Occurrence models matching com.lifeuse.money.models.dto
class RecurringScheduleModel {
  final int id;
  final int userId;
  final String title;
  final String transactionType; // EXPENSE, INCOME
  final String categoryName;
  final double amount;
  final String frequency; // DAILY, WEEKLY, MONTHLY, QUARTERLY, YEARLY
  final DateTime startDate;
  final DateTime? endDate;
  final int? dayOfMonth;
  final String? dayOfWeek;
  final bool essential;
  final String paymentMethod;
  final bool active;
  final DateTime? nextOccurrenceDate;
  final DateTime? createdAt;

  const RecurringScheduleModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.transactionType,
    required this.categoryName,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.dayOfMonth,
    this.dayOfWeek,
    required this.essential,
    required this.paymentMethod,
    required this.active,
    this.nextOccurrenceDate,
    this.createdAt,
  });

  factory RecurringScheduleModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseNullableDate(dynamic date) {
      if (date == null) return null;
      return DateTime.tryParse(date.toString());
    }

    return RecurringScheduleModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      transactionType: json['transactionType']?.toString() ?? 'EXPENSE',
      categoryName: json['categoryName']?.toString() ?? 'General',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      frequency: json['frequency']?.toString() ?? 'MONTHLY',
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ?? DateTime.now(),
      endDate: parseNullableDate(json['endDate']),
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      dayOfWeek: json['dayOfWeek']?.toString(),
      essential: json['essential'] == true,
      paymentMethod: json['paymentMethod']?.toString() ?? 'UPI',
      active: json['active'] == true,
      nextOccurrenceDate: parseNullableDate(json['nextOccurrenceDate']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())?.toLocal()
          : null,
    );
  }
}

class RecurringScheduleRequest {
  final String title;
  final String transactionType; // EXPENSE, INCOME
  final String categoryName;
  final double amount;
  final String frequency; // DAILY, WEEKLY, MONTHLY, QUARTERLY, YEARLY
  final DateTime startDate;
  final DateTime? endDate;
  final int? dayOfMonth;
  final String? dayOfWeek;
  final bool essential;
  final String paymentMethod;

  const RecurringScheduleRequest({
    required this.title,
    required this.transactionType,
    required this.categoryName,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.dayOfMonth,
    this.dayOfWeek,
    this.essential = false,
    this.paymentMethod = 'UPI',
  });

  Map<String, dynamic> toJson() {
    String formatDateOnly(DateTime dt) {
      return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    }

    return {
      'title': title,
      'transactionType': transactionType,
      'categoryName': categoryName,
      'amount': amount,
      'frequency': frequency,
      'startDate': formatDateOnly(startDate),
      'endDate': endDate != null ? formatDateOnly(endDate!) : null,
      'dayOfMonth': dayOfMonth,
      'dayOfWeek': dayOfWeek,
      'essential': essential,
      'paymentMethod': paymentMethod,
    };
  }
}

class RecurringOccurrenceModel {
  final int id;
  final int scheduleId;
  final String scheduleTitle;
  final int userId;
  final DateTime scheduledDate;
  final double amount;
  final String status; // PENDING, PROCESSED, SKIPPED, CANCELLED
  final int? transactionId;

  const RecurringOccurrenceModel({
    required this.id,
    required this.scheduleId,
    required this.scheduleTitle,
    required this.userId,
    required this.scheduledDate,
    required this.amount,
    required this.status,
    this.transactionId,
  });

  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isProcessed => status.toUpperCase() == 'PROCESSED';

  factory RecurringOccurrenceModel.fromJson(Map<String, dynamic> json) {
    return RecurringOccurrenceModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      scheduleId: (json['scheduleId'] as num?)?.toInt() ?? 0,
      scheduleTitle: json['scheduleTitle']?.toString() ?? '',
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      scheduledDate: DateTime.tryParse(json['scheduledDate']?.toString() ?? '') ?? DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'PENDING',
      transactionId: (json['transactionId'] as num?)?.toInt(),
    );
  }
}
