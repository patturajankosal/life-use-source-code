import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../data/models/money/budget_plan_models.dart';
import '../../data/models/money/category_models.dart';
import '../../data/models/money/family_finance_models.dart';
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

  // Family & Shared Finance state
  List<FinanceGroupModel> _groups = [];
  FinanceGroupModel? _selectedGroup;
  GroupDashboardModel? _groupDashboard;
  List<GroupMemberModel> _groupMembers = [];
  List<GroupInvitationModel> _myInvitations = [];
  List<GroupInvitationModel> _groupPendingInvitations = [];
  GroupBudgetModel? _activeGroupBudget;
  List<TransactionModel> _groupTransactions = [];
  GroupPrivacySettingModel? _groupPrivacy;
  List<GroupAuditLogModel> _privacyAuditLogs = [];
  bool _isLoadingGroup = false;

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
  List<RecurringOccurrenceModel> get upcomingOccurrences =>
      _upcomingOccurrences;
  FinancialProfileModel? get financialProfile => _financialProfile;

  // Family Finance Getters
  List<FinanceGroupModel> get groups => _groups;
  List<FinanceGroupModel> get userGroups => _groups;
  FinanceGroupModel? get selectedGroup => _selectedGroup;
  GroupDashboardModel? get groupDashboard => _groupDashboard;
  List<GroupMemberModel> get groupMembers => _groupMembers;
  List<GroupInvitationModel> get myInvitations => _myInvitations;
  List<GroupInvitationModel> get groupPendingInvitations =>
      _groupPendingInvitations;
  GroupBudgetModel? get activeGroupBudget => _activeGroupBudget;
  List<TransactionModel> get groupTransactions => _groupTransactions;
  GroupPrivacySettingModel? get groupPrivacy => _groupPrivacy;
  List<GroupAuditLogModel> get privacyAuditLogs => _privacyAuditLogs;
  bool get isLoadingGroup => _isLoadingGroup;

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
        _service
            .getDailySpendingLimit()
            .catchError((_) => DailySpendingLimitModel.empty()),
        _service
            .getBudgetPressure()
            .catchError((_) => BudgetPressureModel.empty()),
        _service
            .getTransactionSummary()
            .catchError((_) => TransactionSummaryModel.empty()),
        _service
            .getTransactions(
              type: _selectedTypeFilter == 'ALL' ? null : _selectedTypeFilter,
              category: _selectedCategoryFilter == 'ALL'
                  ? null
                  : _selectedCategoryFilter,
              limit: 30,
            )
            .catchError((_) => <TransactionModel>[]),
        _service.getCategories().catchError((_) => <CategoryModel>[]),
        _service.getActiveBudgetPlan().catchError((_) => null),
        _service
            .getPlannedExpenses()
            .catchError((_) => <PlannedExpenseModel>[]),
        _service
            .getUpcomingOccurrences()
            .catchError((_) => <RecurringOccurrenceModel>[]),
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
        category:
            _selectedCategoryFilter == 'ALL' ? null : _selectedCategoryFilter,
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
  Future<PlannedExpenseModel> addPlannedExpense(
      PlannedExpenseRequest req) async {
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
  Future<RecurringScheduleModel> addRecurringSchedule(
      RecurringScheduleRequest req) async {
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

  // ===========================================================================
  // FAMILY & SHARED FINANCE ACTIONS
  // ===========================================================================

  /// Load user groups and received invitations
  Future<void> loadUserGroups() async {
    try {
      final grps = await _service.getGroups();
      _groups = grps;
      if (_groups.isNotEmpty) {
        if (_selectedGroup == null ||
            !_groups.any((g) => g.id == _selectedGroup!.id)) {
          _selectedGroup = _groups.first;
        }
        await loadGroupDashboard(_selectedGroup!.id, silent: true);
      } else {
        _selectedGroup = null;
        _groupDashboard = null;
      }
      _myInvitations = await _service.getMyInvitations();
      notifyListeners();
    } catch (_) {}
  }

  /// Reload invitations received by user
  Future<void> loadPendingInvitations() async {
    try {
      _myInvitations = await _service.getMyInvitations();
      notifyListeners();
    } catch (_) {}
  }

  /// Switch currently viewed finance group
  Future<void> selectGroup(int groupId) async {
    final found = _groups.firstWhere(
      (g) => g.id == groupId,
      orElse: () => _selectedGroup ?? _groups.first,
    );
    _selectedGroup = found;
    notifyListeners();
    await loadGroupDashboard(groupId);
  }

  /// Load complete group dashboard and sub-resources
  Future<void> loadGroupDashboard(int groupId, {bool silent = false}) async {
    if (!silent) {
      _isLoadingGroup = true;
      notifyListeners();
    }

    try {
      final dashboard = await _service.getGroupDashboard(groupId);
      final members = await _service.getGroupMembers(groupId);
      final privacy = await _service.getGroupPrivacy(groupId);
      final activeBudget = await _service.getActiveGroupBudget(groupId);
      final groupTxs = await _service.getGroupTransactions(groupId, limit: 30);

      _groupDashboard = dashboard;
      _groupMembers = members;
      _groupPrivacy = privacy;
      _activeGroupBudget = activeBudget;
      _groupTransactions = groupTxs;

      if (_selectedGroup?.isAdmin == true) {
        _groupPendingInvitations = await _service
            .getGroupInvitations(groupId)
            .catchError((_) => <GroupInvitationModel>[]);
      }
    } catch (e) {
      // Keep previous data
    } finally {
      _isLoadingGroup = false;
      notifyListeners();
    }
  }

  /// Create a new finance group
  Future<FinanceGroupModel> createGroup(
    String name, {
    String? description,
    String? currency,
    String? defaultPrivacyMode,
  }) async {
    final created = await _service.createGroup(
      name,
      description: description,
      currency: currency,
      defaultPrivacyMode: defaultPrivacyMode,
    );
    if (created != null) {
      _groups.insert(0, created);
      _selectedGroup = created;
      await loadGroupDashboard(created.id);
      return created;
    }
    throw Exception('Failed to create finance group');
  }

  /// Update group details
  Future<void> updateGroup(
    int groupId,
    String name, {
    String? description,
    String? currency,
    String? defaultPrivacyMode,
  }) async {
    final updated = await _service.updateGroup(
      groupId,
      name,
      description: description,
      currency: currency,
      defaultPrivacyMode: defaultPrivacyMode,
    );
    if (updated != null) {
      final idx = _groups.indexWhere((g) => g.id == groupId);
      if (idx != -1) {
        _groups[idx] = updated;
      }
      if (_selectedGroup?.id == groupId) {
        _selectedGroup = updated;
      }
      notifyListeners();
    }
  }

  /// Archive group
  Future<void> deleteGroup(int groupId) async {
    await _service.deleteGroup(groupId);
    _groups.removeWhere((g) => g.id == groupId);
    if (_selectedGroup?.id == groupId) {
      _selectedGroup = _groups.isNotEmpty ? _groups.first : null;
      if (_selectedGroup != null) {
        await loadGroupDashboard(_selectedGroup!.id);
      }
    }
    notifyListeners();
  }

  /// Leave group
  Future<void> leaveGroup(int groupId) async {
    await _service.leaveGroup(groupId);
    _groups.removeWhere((g) => g.id == groupId);
    if (_selectedGroup?.id == groupId) {
      _selectedGroup = _groups.isNotEmpty ? _groups.first : null;
      if (_selectedGroup != null) {
        await loadGroupDashboard(_selectedGroup!.id);
      }
    }
    notifyListeners();
  }

  /// Transfer ownership
  Future<void> transferOwnership(int groupId, int newOwnerId) async {
    await _service.transferGroupOwnership(groupId, newOwnerId);
    await loadUserGroups();
  }

  /// Invite member
  Future<void> inviteMember(
    int groupId,
    String identifier, {
    String proposedRole = 'MEMBER',
  }) async {
    await _service.inviteMember(
      groupId,
      identifier,
      proposedRole: proposedRole,
    );
    _groupPendingInvitations = await _service.getGroupInvitations(groupId);
    notifyListeners();
  }

  /// Accept an invitation
  Future<void> acceptInvitation(int invitationId) async {
    await _service.acceptInvitation(invitationId);
    await loadUserGroups();
  }

  /// Reject an invitation
  Future<void> rejectInvitation(int invitationId) async {
    await _service.rejectInvitation(invitationId);
    _myInvitations.removeWhere((i) => i.id == invitationId);
    notifyListeners();
  }

  /// Cancel an invitation
  Future<void> cancelInvitation(int groupId, int invitationId) async {
    await _service.cancelInvitation(groupId, invitationId);
    _groupPendingInvitations.removeWhere((i) => i.id == invitationId);
    notifyListeners();
  }

  /// Update member role
  Future<void> updateMemberRole(int groupId, int memberId, String role) async {
    await _service.updateMemberRole(groupId, memberId, role);
    _groupMembers = await _service.getGroupMembers(groupId);
    notifyListeners();
  }

  /// Remove member
  Future<void> removeMember(int groupId, int memberId) async {
    await _service.removeMember(groupId, memberId);
    _groupMembers.removeWhere((m) => m.userId == memberId);
    notifyListeners();
  }

  /// Update user privacy mode & explicit consent
  Future<void> updateGroupPrivacy(
    int groupId, {
    required String privacyMode,
    bool allowAdminViewPersonalAnalytics = false,
    bool explicitConsentGranted = false,
  }) async {
    final updated = await _service.updateGroupPrivacy(
      groupId,
      privacyMode: privacyMode,
      allowAdminViewPersonalAnalytics: allowAdminViewPersonalAnalytics,
      explicitConsentGranted: explicitConsentGranted,
    );
    _groupPrivacy = updated;
    notifyListeners();
  }

  /// Load privacy audit logs
  Future<void> loadPrivacyAuditLogs(int groupId) async {
    _privacyAuditLogs = await _service.getGroupPrivacyAudit(groupId);
    notifyListeners();
  }

  /// Create group budget
  Future<GroupBudgetModel> createGroupBudget(
    int groupId,
    Map<String, dynamic> body,
  ) async {
    final created = await _service.createGroupBudget(groupId, body);
    if (created != null) {
      _activeGroupBudget = created;
      await loadGroupDashboard(groupId, silent: true);
      return created;
    }
    throw Exception('Failed to create group budget');
  }

  /// Deactivate group budget
  Future<void> deleteGroupBudget(int groupId, int budgetId) async {
    await _service.deleteGroupBudget(groupId, budgetId);
    _activeGroupBudget = null;
    await loadGroupDashboard(groupId, silent: true);
    notifyListeners();
  }

  /// Record shared group transaction
  Future<TransactionModel> addGroupTransaction(
    int groupId,
    TransactionCreateRequest req,
  ) async {
    final created = await _service.createGroupTransaction(groupId, req);
    if (created != null) {
      _groupTransactions.insert(0, created);
      await loadGroupDashboard(groupId, silent: true);
      return created;
    }
    throw Exception('Failed to record shared transaction');
  }

  /// Clear in-memory caches on user logout or session switch
  void clear() {
    _dailyLimit = null;
    _budgetPressure = null;
    _spendingBreakdown = null;
    _summary = TransactionSummaryModel.empty();
    _transactions = [];
    _categories = [];
    _budgetPlans = [];
    _activeBudgetPlan = null;
    _plannedExpenses = [];
    _recurringSchedules = [];
    _upcomingOccurrences = [];
    _financialProfile = null;
    _groups = [];
    _selectedGroup = null;
    _groupDashboard = null;
    _groupMembers = [];
    _myInvitations = [];
    _groupPendingInvitations = [];
    _activeGroupBudget = null;
    _groupTransactions = [];
    _groupPrivacy = null;
    _privacyAuditLogs = [];
    _errorMessage = null;
    notifyListeners();
  }
}
