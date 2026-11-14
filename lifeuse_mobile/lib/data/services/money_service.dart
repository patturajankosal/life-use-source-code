import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';
import '../models/money/budget_plan_models.dart';
import '../models/money/category_models.dart';
import '../models/money/financial_profile_models.dart';
import '../models/money/planned_expense_models.dart';
import '../models/money/recurring_schedule_models.dart';
import '../models/money/spending_plan_models.dart';
import '../models/money/transaction_models.dart';

/// Complete service for Money Manager API operations.
/// Interacts directly with Spring Boot backend endpoints defined in com.lifeuse.AppRoutes.Money.
class MoneyService {
  final ApiClient _apiClient;

  MoneyService(this._apiClient);

  // ===========================================================================
  // 1. INTELLIGENT SPENDING PLAN & BUDGET PRESSURE
  // ===========================================================================

  /// Calculate intelligent daily spending limit
  Future<DailySpendingLimitModel> getDailySpendingLimit() async {
    final response = await _apiClient.get<DailySpendingLimitModel>(
      url: ApiConfig.moneyDailyLimit,
      fromJson: (json) => DailySpendingLimitModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data ?? DailySpendingLimitModel.empty();
  }

  /// Evaluate budget pressure score and forward projection
  Future<BudgetPressureModel> getBudgetPressure() async {
    final response = await _apiClient.get<BudgetPressureModel>(
      url: ApiConfig.moneyPressure,
      fromJson: (json) => BudgetPressureModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data ?? BudgetPressureModel.empty();
  }

  /// Get current monthly spending & commitments breakdown
  Future<SpendingBreakdownModel?> getSpendingBreakdown() async {
    final response = await _apiClient.get<SpendingBreakdownModel>(
      url: ApiConfig.moneySpendingBreakdown,
      fromJson: (json) => SpendingBreakdownModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  // ===========================================================================
  // 2. TRANSACTIONS & SUMMARY
  // ===========================================================================

  /// Retrieve filtered transactions list
  Future<List<TransactionModel>> getTransactions({
    String? type,
    String? category,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 50,
    int offset = 0,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    if (type != null && type.isNotEmpty && type != 'ALL') {
      queryParams['type'] = type;
    }
    if (category != null && category.isNotEmpty && category != 'ALL') {
      queryParams['category'] = category;
    }
    if (fromDate != null) {
      queryParams['fromDate'] = fromDate.toUtc().toIso8601String();
    }
    if (toDate != null) {
      queryParams['toDate'] = toDate.toUtc().toIso8601String();
    }

    final uri = Uri.parse(ApiConfig.moneyTransactions).replace(queryParameters: queryParams);

    final response = await _apiClient.get<List<TransactionModel>>(
      url: uri.toString(),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => TransactionModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return <TransactionModel>[];
      },
    );
    return response.data ?? <TransactionModel>[];
  }

  /// Record a new financial transaction
  Future<TransactionModel> createTransaction(TransactionCreateRequest request) async {
    final response = await _apiClient.post<TransactionModel>(
      url: ApiConfig.moneyTransactions,
      body: request.toJson(),
      fromJson: (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty ? response.message : 'Failed to record transaction',
        statusCode: 500,
      );
    }
    return response.data!;
  }

  /// Delete transaction by ID
  Future<void> deleteTransaction(int id) async {
    await _apiClient.delete<void>(
      url: ApiConfig.moneyTransaction(id),
    );
  }

  /// Fetch financial summary metrics for a date range
  Future<TransactionSummaryModel> getTransactionSummary({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final queryParams = <String, String>{};
    if (fromDate != null) {
      queryParams['fromDate'] = fromDate.toUtc().toIso8601String();
    }
    if (toDate != null) {
      queryParams['toDate'] = toDate.toUtc().toIso8601String();
    }

    final uri = Uri.parse(ApiConfig.moneyTransactionSummary).replace(
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final response = await _apiClient.get<TransactionSummaryModel>(
      url: uri.toString(),
      fromJson: (json) => TransactionSummaryModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data ?? TransactionSummaryModel.empty();
  }

  // ===========================================================================
  // 3. EXPENSE CATEGORIES
  // ===========================================================================

  /// Retrieve all available categories
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get<List<CategoryModel>>(
      url: ApiConfig.moneyCategories,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => CategoryModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return <CategoryModel>[];
      },
    );
    return response.data ?? <CategoryModel>[];
  }

  /// Create custom category
  Future<CategoryModel> createCategory(CategoryRequest request) async {
    final response = await _apiClient.post<CategoryModel>(
      url: ApiConfig.moneyCategories,
      body: request.toJson(),
      fromJson: (json) => CategoryModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty ? response.message : 'Failed to create category',
        statusCode: 500,
      );
    }
    return response.data!;
  }

  // ===========================================================================
  // 4. BUDGET PLANS
  // ===========================================================================

  /// List all budget plans for user
  Future<List<BudgetPlanModel>> getBudgetPlans() async {
    final response = await _apiClient.get<List<BudgetPlanModel>>(
      url: ApiConfig.moneyBudgetPlans,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => BudgetPlanModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return <BudgetPlanModel>[];
      },
    );
    return response.data ?? <BudgetPlanModel>[];
  }

  /// Get currently active budget plan
  Future<BudgetPlanModel?> getActiveBudgetPlan() async {
    try {
      final response = await _apiClient.get<BudgetPlanModel>(
        url: ApiConfig.moneyActiveBudgetPlan,
        fromJson: (json) => BudgetPlanModel.fromJson(json as Map<String, dynamic>),
      );
      return response.data;
    } catch (_) {
      // 404 or no active plan is normal
      return null;
    }
  }

  /// Create a new budget plan
  Future<BudgetPlanModel> createBudgetPlan(BudgetPlanRequest request) async {
    final response = await _apiClient.post<BudgetPlanModel>(
      url: ApiConfig.moneyBudgetPlans,
      body: request.toJson(),
      fromJson: (json) => BudgetPlanModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty ? response.message : 'Failed to create budget plan',
        statusCode: 500,
      );
    }
    return response.data!;
  }

  /// Delete budget plan
  Future<void> deleteBudgetPlan(int id) async {
    await _apiClient.delete<void>(
      url: ApiConfig.moneyBudgetPlan(id),
    );
  }

  // ===========================================================================
  // 5. PLANNED EXPENSES
  // ===========================================================================

  /// List all planned expenses
  Future<List<PlannedExpenseModel>> getPlannedExpenses() async {
    final response = await _apiClient.get<List<PlannedExpenseModel>>(
      url: ApiConfig.moneyPlannedExpenses,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => PlannedExpenseModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return <PlannedExpenseModel>[];
      },
    );
    return response.data ?? <PlannedExpenseModel>[];
  }

  /// Create a planned expense
  Future<PlannedExpenseModel> createPlannedExpense(PlannedExpenseRequest request) async {
    final response = await _apiClient.post<PlannedExpenseModel>(
      url: ApiConfig.moneyPlannedExpenses,
      body: request.toJson(),
      fromJson: (json) => PlannedExpenseModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty ? response.message : 'Failed to schedule planned expense',
        statusCode: 500,
      );
    }
    return response.data!;
  }

  /// Delete planned expense
  Future<void> deletePlannedExpense(int id) async {
    await _apiClient.delete<void>(
      url: ApiConfig.moneyPlannedExpense(id),
    );
  }

  /// Convert planned expense directly into an actual financial transaction
  Future<TransactionModel> executePlannedExpense(int id) async {
    final response = await _apiClient.post<TransactionModel>(
      url: ApiConfig.moneyExecutePlannedExpense(id),
      body: const {},
      fromJson: (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty ? response.message : 'Failed to execute planned expense',
        statusCode: 500,
      );
    }
    return response.data!;
  }

  // ===========================================================================
  // 6. RECURRING SCHEDULES & OCCURRENCES
  // ===========================================================================

  /// List all recurring transaction schedules
  Future<List<RecurringScheduleModel>> getRecurringSchedules() async {
    final response = await _apiClient.get<List<RecurringScheduleModel>>(
      url: ApiConfig.moneyRecurringSchedules,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => RecurringScheduleModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return <RecurringScheduleModel>[];
      },
    );
    return response.data ?? <RecurringScheduleModel>[];
  }

  /// Create recurring transaction schedule
  Future<RecurringScheduleModel> createRecurringSchedule(RecurringScheduleRequest request) async {
    final response = await _apiClient.post<RecurringScheduleModel>(
      url: ApiConfig.moneyRecurringSchedules,
      body: request.toJson(),
      fromJson: (json) => RecurringScheduleModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty ? response.message : 'Failed to create recurring schedule',
        statusCode: 500,
      );
    }
    return response.data!;
  }

  /// Delete recurring schedule
  Future<void> deleteRecurringSchedule(int id) async {
    await _apiClient.delete<void>(
      url: ApiConfig.moneyRecurringSchedule(id),
    );
  }

  /// List upcoming occurrences for recurring schedules
  Future<List<RecurringOccurrenceModel>> getUpcomingOccurrences() async {
    final response = await _apiClient.get<List<RecurringOccurrenceModel>>(
      url: ApiConfig.moneyRecurringOccurrences,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => RecurringOccurrenceModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return <RecurringOccurrenceModel>[];
      },
    );
    return response.data ?? <RecurringOccurrenceModel>[];
  }

  /// Process occurrence into actual transaction
  Future<TransactionModel> processOccurrence(int id) async {
    final response = await _apiClient.post<TransactionModel>(
      url: ApiConfig.moneyProcessOccurrence(id),
      body: const {},
      fromJson: (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty ? response.message : 'Failed to process recurring occurrence',
        statusCode: 500,
      );
    }
    return response.data!;
  }

  // ===========================================================================
  // 7. FINANCIAL PROFILE & COMMITMENTS
  // ===========================================================================

  /// Get financial profile
  Future<FinancialProfileModel?> getProfile() async {
    try {
      final response = await _apiClient.get<FinancialProfileModel>(
        url: ApiConfig.moneyProfile,
        fromJson: (json) => FinancialProfileModel.fromJson(json as Map<String, dynamic>),
      );
      return response.data;
    } catch (_) {
      return null;
    }
  }

  /// Update or save financial profile
  Future<FinancialProfileModel> updateProfile(FinancialProfileRequest request) async {
    final response = await _apiClient.put<FinancialProfileModel>(
      url: ApiConfig.moneyProfile,
      body: request.toJson(),
      fromJson: (json) => FinancialProfileModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty ? response.message : 'Failed to update financial profile',
        statusCode: 500,
      );
    }
    return response.data!;
  }
}
