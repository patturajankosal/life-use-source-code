import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../data/models/money/budget_plan_models.dart';
import '../../data/models/money/category_models.dart';
import '../../data/models/money/financial_profile_models.dart';
import '../../data/models/money/planned_expense_models.dart';
import '../../data/models/money/recurring_schedule_models.dart';
import '../../data/models/money/spending_plan_models.dart';
import '../../data/models/money/transaction_models.dart';
import '../../data/services/money_service.dart';

/// Central state provider for the Money Manager module.
/// Manages live data, filter states, and handles asynchronous operations with feedback.
class MoneyProvider extends ChangeNotifier {
  final MoneyService _service;

  MoneyProvider(this._service);

  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _errorMessage;

  DailySpendingLimitModel? _dailyLimit;
  BudgetPressureModel? _budgetPressure;
  SpendingBreakdownModel? _spendingBreakdown;
  TransactionSummaryModel _summary = TransactionSummaryModel.empty();
  List<TransactionModel> _transactions = [];
  List<CategoryModel> _categories = [];
  List<BudgetPlanModel> _budgetPlans = [];
  BudgetPlanModel? _activeBudgetPlan;
  List<PlannedExpenseModel> _plannedExpenses = [];
  List<RecurringScheduleModel> _recurringSchedules = [];
  List<RecurringOccurrenceModel> _upcomingOccurrences = [];
  FinancialProfileModel? _financialProfile;

  String _selectedTypeFilter = 'ALL';
  String _selectedCategoryFilter = 'ALL';

  // Getters
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get errorMessage => _errorMessage;

  DailySpendingLimitModel? get dailyLimit => _dailyLimit;
  BudgetPressureModel? get budgetPressure => _budgetPressure;
  SpendingBreakdownModel? get spendingBreakdown => _spendingBreakdown;
  TransactionSummaryModel get summary => _summary;
  List<TransactionModel> get transactions => _transactions;
  List<CategoryModel> get categories => _categories;
  List<BudgetPlanModel> get budgetPlans => _budgetPlans;
  BudgetPlanModel? get activeBudgetPlan => _activeBudgetPlan;
  List<PlannedExpenseModel> get plannedExpenses => _plannedExpenses;
  List<RecurringScheduleModel> get recurringSchedules => _recurringSchedules;
  List<RecurringOccurrenceModel> get upcomingOccurrences => _upcomingOccurrences;
  FinancialProfileModel? get financialProfile => _financialProfile;

  String get selectedTypeFilter => _selectedTypeFilter;
  String get selectedCategoryFilter => _selectedCategoryFilter;

  /// Load core data across the entire module
  Future<void> loadDashboardData({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      _isRefreshing = true;
      notifyListeners();
    }

    try {
      final results = await Future.wait([
        _service.getDailySpendingLimit().catchError((_) => DailySpendingLimitModel.empty()),
        _service.getBudgetPressure().catchError((_) => BudgetPressureModel.empty()),
        _service.getTransactionSummary().catchError((_) => TransactionSummaryModel.empty()),
        _service.getTransactions(
          type: _selectedTypeFilter == 'ALL' ? null : _selectedTypeFilter,
          category: _selectedCategoryFilter == 'ALL' ? null : _selectedCategoryFilter,
          limit: 30,
        ).catchError((_) => <TransactionModel>[]),
        _service.getCategories().catchError((_) => <CategoryModel>[]),
        _service.getActiveBudgetPlan().catchError((_) => null),
        _service.getPlannedExpenses().catchError((_) => <PlannedExpenseModel>[]),
        _service.getUpcomingOccurrences().catchError((_) => <RecurringOccurrenceModel>[]),
      ]);

      _dailyLimit = results[0] as DailySpendingLimitModel;
      _budgetPressure = results[1] as BudgetPressureModel;
      _summary = results[2] as TransactionSummaryModel;
      _transactions = results[3] as List<TransactionModel>;
      _categories = results[4] as List<CategoryModel>;
      _activeBudgetPlan = results[5] as BudgetPlanModel?;
      _plannedExpenses = results[6] as List<PlannedExpenseModel>;
      _upcomingOccurrences = results[7] as List<RecurringOccurrenceModel>;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e is ApiException ? e.message : e.toString();
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Change transaction type filter (ALL, EXPENSE, INCOME, REFUND)
  void setTypeFilter(String type) {
    if (_selectedTypeFilter == type) return;
    _selectedTypeFilter = type;
    notifyListeners();
    refreshTransactions();
  }

  /// Change transaction category filter
  void setCategoryFilter(String category) {
    if (_selectedCategoryFilter == category) return;
    _selectedCategoryFilter = category;
    notifyListeners();
    refreshTransactions();
  }

  /// Refresh only transactions based on current filters
  Future<void> refreshTransactions() async {
    try {
      final list = await _service.getTransactions(
        type: _selectedTypeFilter == 'ALL' ? null : _selectedTypeFilter,
        category: _selectedCategoryFilter == 'ALL' ? null : _selectedCategoryFilter,
        limit: 50,
      );
      _transactions = list;
      notifyListeners();
    } catch (e) {
      // Keep previous list on failure
    }
  }

  /// Record a transaction
  Future<TransactionModel> addTransaction(TransactionCreateRequest req) async {
    final created = await _service.createTransaction(req);
    _transactions.insert(0, created);
    // Refresh calculations in background
    _service.getTransactionSummary().then((s) {
      _summary = s;
      notifyListeners();
    });
    _service.getDailySpendingLimit().then((dl) {
      _dailyLimit = dl;
      notifyListeners();
    });
    _service.getBudgetPressure().then((bp) {
      _budgetPressure = bp;
      notifyListeners();
    });
    notifyListeners();
    return created;
  }

  /// Delete transaction
  Future<void> removeTransaction(int id) async {
    await _service.deleteTransaction(id);
    _transactions.removeWhere((tx) => tx.id == id);
    _service.getTransactionSummary().then((s) {
      _summary = s;
      notifyListeners();
    });
    _service.getDailySpendingLimit().then((dl) {
      _dailyLimit = dl;
      notifyListeners();
    });
    notifyListeners();
  }

  /// Load budget plans tab data
  Future<void> loadBudgetPlans() async {
    try {
      final list = await _service.getBudgetPlans();
      _budgetPlans = list;
      _activeBudgetPlan = await _service.getActiveBudgetPlan();
      notifyListeners();
    } catch (e) {
      // Log or handle
    }
  }

  /// Create budget plan
  Future<BudgetPlanModel> addBudgetPlan(BudgetPlanRequest req) async {
    final created = await _service.createBudgetPlan(req);
    await loadBudgetPlans();
    return created;
  }

  /// Delete budget plan
  Future<void> removeBudgetPlan(int id) async {
    await _service.deleteBudgetPlan(id);
    _budgetPlans.removeWhere((p) => p.id == id);
    if (_activeBudgetPlan?.id == id) {
      _activeBudgetPlan = null;
    }
    notifyListeners();
  }

  /// Load planned expenses
  Future<void> loadPlannedExpenses() async {
    try {
      final list = await _service.getPlannedExpenses();
      _plannedExpenses = list;
      notifyListeners();
    } catch (_) {}
  }

  /// Add planned expense
  Future<PlannedExpenseModel> addPlannedExpense(PlannedExpenseRequest req) async {
    final created = await _service.createPlannedExpense(req);
    _plannedExpenses.insert(0, created);
    _service.getBudgetPressure().then((bp) {
      _budgetPressure = bp;
      notifyListeners();
    });
    notifyListeners();
    return created;
  }

  /// Delete planned expense
  Future<void> removePlannedExpense(int id) async {
    await _service.deletePlannedExpense(id);
    _plannedExpenses.removeWhere((pe) => pe.id == id);
    _service.getBudgetPressure().then((bp) {
      _budgetPressure = bp;
      notifyListeners();
    });
    notifyListeners();
  }

  /// Execute planned expense into transaction
  Future<TransactionModel> executePlannedExpense(int id) async {
    final tx = await _service.executePlannedExpense(id);
    await loadDashboardData(silent: true);
    return tx;
  }

  /// Load recurring schedules & occurrences
  Future<void> loadRecurringData() async {
    try {
      final schedules = await _service.getRecurringSchedules();
      final occurrences = await _service.getUpcomingOccurrences();
      _recurringSchedules = schedules;
      _upcomingOccurrences = occurrences;
      notifyListeners();
    } catch (_) {}
  }

  /// Add recurring schedule
  Future<RecurringScheduleModel> addRecurringSchedule(RecurringScheduleRequest req) async {
    final created = await _service.createRecurringSchedule(req);
    await loadRecurringData();
    return created;
  }

  /// Delete recurring schedule
  Future<void> removeRecurringSchedule(int id) async {
    await _service.deleteRecurringSchedule(id);
    _recurringSchedules.removeWhere((rs) => rs.id == id);
    _upcomingOccurrences.removeWhere((oc) => oc.scheduleId == id);
    notifyListeners();
  }

  /// Process occurrence
  Future<TransactionModel> processOccurrence(int occurrenceId) async {
    final tx = await _service.processOccurrence(occurrenceId);
    await loadDashboardData(silent: true);
    return tx;
  }
}
