import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';
import '../models/money/budget_plan_models.dart';
import '../models/money/category_models.dart';
import '../models/money/family_finance_models.dart';
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
      fromJson: (json) =>
          DailySpendingLimitModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data ?? DailySpendingLimitModel.empty();
  }

  /// Evaluate budget pressure score and forward projection
  Future<BudgetPressureModel> getBudgetPressure() async {
    final response = await _apiClient.get<BudgetPressureModel>(
      url: ApiConfig.moneyPressure,
      fromJson: (json) =>
          BudgetPressureModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data ?? BudgetPressureModel.empty();
  }

  /// Get current monthly spending & commitments breakdown
  Future<SpendingBreakdownModel?> getSpendingBreakdown() async {
    final response = await _apiClient.get<SpendingBreakdownModel>(
      url: ApiConfig.moneySpendingBreakdown,
      fromJson: (json) =>
          SpendingBreakdownModel.fromJson(json as Map<String, dynamic>),
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

    final uri = Uri.parse(ApiConfig.moneyTransactions)
        .replace(queryParameters: queryParams);

    final response = await _apiClient.get<List<TransactionModel>>(
      url: uri.toString(),
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) =>
                  TransactionModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <TransactionModel>[];
      },
    );
    return response.data ?? <TransactionModel>[];
  }

  /// Record a new financial transaction
  Future<TransactionModel> createTransaction(
      TransactionCreateRequest request) async {
    final response = await _apiClient.post<TransactionModel>(
      url: ApiConfig.moneyTransactions,
      body: request.toJson(),
      fromJson: (json) =>
          TransactionModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to record transaction',
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
      fromJson: (json) =>
          TransactionSummaryModel.fromJson(json as Map<String, dynamic>),
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
          return json
              .map((item) =>
                  CategoryModel.fromJson(item as Map<String, dynamic>))
              .toList();
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
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to create category',
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
          return json
              .map((item) =>
                  BudgetPlanModel.fromJson(item as Map<String, dynamic>))
              .toList();
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
        fromJson: (json) =>
            BudgetPlanModel.fromJson(json as Map<String, dynamic>),
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
      fromJson: (json) =>
          BudgetPlanModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to create budget plan',
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
          return json
              .map((item) =>
                  PlannedExpenseModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <PlannedExpenseModel>[];
      },
    );
    return response.data ?? <PlannedExpenseModel>[];
  }

  /// Create a planned expense
  Future<PlannedExpenseModel> createPlannedExpense(
      PlannedExpenseRequest request) async {
    final response = await _apiClient.post<PlannedExpenseModel>(
      url: ApiConfig.moneyPlannedExpenses,
      body: request.toJson(),
      fromJson: (json) =>
          PlannedExpenseModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to schedule planned expense',
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
      fromJson: (json) =>
          TransactionModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to execute planned expense',
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
          return json
              .map((item) =>
                  RecurringScheduleModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <RecurringScheduleModel>[];
      },
    );
    return response.data ?? <RecurringScheduleModel>[];
  }

  /// Create recurring transaction schedule
  Future<RecurringScheduleModel> createRecurringSchedule(
      RecurringScheduleRequest request) async {
    final response = await _apiClient.post<RecurringScheduleModel>(
      url: ApiConfig.moneyRecurringSchedules,
      body: request.toJson(),
      fromJson: (json) =>
          RecurringScheduleModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to create recurring schedule',
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
          return json
              .map((item) => RecurringOccurrenceModel.fromJson(
                  item as Map<String, dynamic>))
              .toList();
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
      fromJson: (json) =>
          TransactionModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to process recurring occurrence',
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
        fromJson: (json) =>
            FinancialProfileModel.fromJson(json as Map<String, dynamic>),
      );
      return response.data;
    } catch (_) {
      return null;
    }
  }

  /// Update or save financial profile
  Future<FinancialProfileModel> updateProfile(
      FinancialProfileRequest request) async {
    final response = await _apiClient.put<FinancialProfileModel>(
      url: ApiConfig.moneyProfile,
      body: request.toJson(),
      fromJson: (json) =>
          FinancialProfileModel.fromJson(json as Map<String, dynamic>),
    );
    if (response.data == null) {
      throw ApiException(
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to update financial profile',
        statusCode: 500,
      );
    }
    return response.data!;
  }

  // ===========================================================================
  // 6. FAMILY & SHARED FINANCE MANAGEMENT
  // ===========================================================================

  /// List all finance groups the authenticated user belongs to
  Future<List<FinanceGroupModel>> getGroups() async {
    final response = await _apiClient.get<List<FinanceGroupModel>>(
      url: ApiConfig.moneyGroups,
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) =>
                  FinanceGroupModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <FinanceGroupModel>[];
      },
    );
    return response.data ?? <FinanceGroupModel>[];
  }

  /// Get details of a single finance group
  Future<FinanceGroupModel?> getGroupById(int groupId) async {
    final response = await _apiClient.get<FinanceGroupModel>(
      url: ApiConfig.moneyGroup(groupId),
      fromJson: (json) =>
          FinanceGroupModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Create a new finance group
  Future<FinanceGroupModel?> createGroup(
    String name, {
    String? description,
    String? currency,
    String? defaultPrivacyMode,
  }) async {
    final response = await _apiClient.post<FinanceGroupModel>(
      url: ApiConfig.moneyGroups,
      body: {
        'name': name,
        'description': description,
        'currency': currency ?? 'INR',
        'defaultPrivacyMode': defaultPrivacyMode ?? 'SHARED_ONLY',
      },
      fromJson: (json) =>
          FinanceGroupModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Update group details
  Future<FinanceGroupModel?> updateGroup(
    int groupId,
    String name, {
    String? description,
    String? currency,
    String? defaultPrivacyMode,
  }) async {
    final response = await _apiClient.put<FinanceGroupModel>(
      url: ApiConfig.moneyGroup(groupId),
      body: {
        'name': name,
        'description': description,
        'currency': currency,
        'defaultPrivacyMode': defaultPrivacyMode,
      },
      fromJson: (json) =>
          FinanceGroupModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Archive / delete a finance group (OWNER only)
  Future<bool> deleteGroup(int groupId) async {
    final response = await _apiClient.delete<void>(
      url: ApiConfig.moneyGroup(groupId),
    );
    return response.success;
  }

  /// Leave a finance group
  Future<bool> leaveGroup(int groupId) async {
    final response = await _apiClient.post<void>(
      url: ApiConfig.moneyLeaveGroup(groupId),
      body: const {},
    );
    return response.success;
  }

  /// Transfer group ownership
  Future<bool> transferGroupOwnership(int groupId, int newOwnerId) async {
    final response = await _apiClient.post<void>(
      url: ApiConfig.moneyTransferGroupOwner(groupId),
      body: {'newOwnerUserId': newOwnerId},
    );
    return response.success;
  }

  /// Invite a user to a finance group
  Future<GroupInvitationModel?> inviteMember(
    int groupId,
    String identifier, {
    String proposedRole = 'MEMBER',
  }) async {
    final response = await _apiClient.post<GroupInvitationModel>(
      url: ApiConfig.moneyGroupInvitations(groupId),
      body: {
        'inviteeIdentifier': identifier,
        'proposedRole': proposedRole,
      },
      fromJson: (json) =>
          GroupInvitationModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// List pending invitations for a group
  Future<List<GroupInvitationModel>> getGroupInvitations(int groupId) async {
    final response = await _apiClient.get<List<GroupInvitationModel>>(
      url: ApiConfig.moneyGroupInvitations(groupId),
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) =>
                  GroupInvitationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <GroupInvitationModel>[];
      },
    );
    return response.data ?? <GroupInvitationModel>[];
  }

  /// List invitations received by current user
  Future<List<GroupInvitationModel>> getMyInvitations() async {
    final response = await _apiClient.get<List<GroupInvitationModel>>(
      url: ApiConfig.moneyMyInvitations,
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) =>
                  GroupInvitationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <GroupInvitationModel>[];
      },
    );
    return response.data ?? <GroupInvitationModel>[];
  }

  /// Accept an invitation
  Future<GroupInvitationModel?> acceptInvitation(int invitationId) async {
    final response = await _apiClient.post<GroupInvitationModel>(
      url: ApiConfig.moneyAcceptInvitation(invitationId),
      body: const {},
      fromJson: (json) =>
          GroupInvitationModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Reject an invitation
  Future<GroupInvitationModel?> rejectInvitation(int invitationId) async {
    final response = await _apiClient.post<GroupInvitationModel>(
      url: ApiConfig.moneyRejectInvitation(invitationId),
      body: const {},
      fromJson: (json) =>
          GroupInvitationModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Cancel an invitation
  Future<bool> cancelInvitation(int groupId, int invitationId) async {
    final response = await _apiClient.delete<void>(
      url: ApiConfig.moneyCancelInvitation(groupId, invitationId),
    );
    return response.success;
  }

  /// List active group members
  Future<List<GroupMemberModel>> getGroupMembers(int groupId) async {
    final response = await _apiClient.get<List<GroupMemberModel>>(
      url: ApiConfig.moneyGroupMembers(groupId),
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) =>
                  GroupMemberModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <GroupMemberModel>[];
      },
    );
    return response.data ?? <GroupMemberModel>[];
  }

  /// Update a member's role
  Future<bool> updateMemberRole(int groupId, int memberId, String role) async {
    final response = await _apiClient.put<void>(
      url: ApiConfig.moneyGroupMemberRole(groupId, memberId),
      body: {'role': role},
    );
    return response.success;
  }

  /// Remove a member from group
  Future<bool> removeMember(int groupId, int memberId) async {
    final response = await _apiClient.delete<void>(
      url: ApiConfig.moneyGroupMember(groupId, memberId),
    );
    return response.success;
  }

  /// Get user's privacy configuration for a group
  Future<GroupPrivacySettingModel?> getGroupPrivacy(int groupId) async {
    final response = await _apiClient.get<GroupPrivacySettingModel>(
      url: ApiConfig.moneyGroupPrivacy(groupId),
      fromJson: (json) =>
          GroupPrivacySettingModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Update privacy configuration and explicit sharing consent
  Future<GroupPrivacySettingModel?> updateGroupPrivacy(
    int groupId, {
    required String privacyMode,
    bool allowAdminViewPersonalAnalytics = false,
    bool explicitConsentGranted = false,
  }) async {
    final response = await _apiClient.put<GroupPrivacySettingModel>(
      url: ApiConfig.moneyGroupPrivacy(groupId),
      body: {
        'privacyMode': privacyMode,
        'allowAdminViewPersonalAnalytics': allowAdminViewPersonalAnalytics,
        'explicitConsentGranted': explicitConsentGranted,
      },
      fromJson: (json) =>
          GroupPrivacySettingModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Get privacy audit logs
  Future<List<GroupAuditLogModel>> getGroupPrivacyAudit(int groupId) async {
    final response = await _apiClient.get<List<GroupAuditLogModel>>(
      url: ApiConfig.moneyGroupPrivacyAudit(groupId),
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) =>
                  GroupAuditLogModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <GroupAuditLogModel>[];
      },
    );
    return response.data ?? <GroupAuditLogModel>[];
  }

  /// Create shared group budget
  Future<GroupBudgetModel?> createGroupBudget(
    int groupId,
    Map<String, dynamic> body,
  ) async {
    final response = await _apiClient.post<GroupBudgetModel>(
      url: ApiConfig.moneyGroupBudgets(groupId),
      body: body,
      fromJson: (json) =>
          GroupBudgetModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Get active group budget
  Future<GroupBudgetModel?> getActiveGroupBudget(int groupId) async {
    final response = await _apiClient.get<GroupBudgetModel>(
      url: ApiConfig.moneyActiveGroupBudget(groupId),
      fromJson: (json) =>
          GroupBudgetModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// List group budgets
  Future<List<GroupBudgetModel>> getGroupBudgets(int groupId) async {
    final response = await _apiClient.get<List<GroupBudgetModel>>(
      url: ApiConfig.moneyGroupBudgets(groupId),
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) =>
                  GroupBudgetModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <GroupBudgetModel>[];
      },
    );
    return response.data ?? <GroupBudgetModel>[];
  }

  /// Deactivate group budget
  Future<bool> deleteGroupBudget(int groupId, int budgetId) async {
    final response = await _apiClient.delete<void>(
      url: ApiConfig.moneyGroupBudget(groupId, budgetId),
    );
    return response.success;
  }

  /// Record shared group transaction
  Future<TransactionModel?> createGroupTransaction(
    int groupId,
    TransactionCreateRequest request,
  ) async {
    final response = await _apiClient.post<TransactionModel>(
      url: ApiConfig.moneyGroupTransactions(groupId),
      body: request.toJson(),
      fromJson: (json) =>
          TransactionModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// List shared group transactions
  Future<List<TransactionModel>> getGroupTransactions(
    int groupId, {
    String? type,
    String? category,
    int? memberId,
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
    if (memberId != null) {
      queryParams['memberId'] = memberId.toString();
    }
    if (fromDate != null) {
      queryParams['fromDate'] = fromDate.toUtc().toIso8601String();
    }
    if (toDate != null) {
      queryParams['toDate'] = toDate.toUtc().toIso8601String();
    }

    final uri = Uri.parse(ApiConfig.moneyGroupTransactions(groupId))
        .replace(queryParameters: queryParams);

    final response = await _apiClient.get<List<TransactionModel>>(
      url: uri.toString(),
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) =>
                  TransactionModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <TransactionModel>[];
      },
    );
    return response.data ?? <TransactionModel>[];
  }

  /// Get group transaction summary
  Future<TransactionSummaryModel?> getGroupTransactionSummary(
    int groupId, {
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
    final uri = Uri.parse(ApiConfig.moneyGroupTxSummary(groupId))
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await _apiClient.get<TransactionSummaryModel>(
      url: uri.toString(),
      fromJson: (json) =>
          TransactionSummaryModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Get Group Financial Dashboard
  Future<GroupDashboardModel?> getGroupDashboard(int groupId) async {
    final response = await _apiClient.get<GroupDashboardModel>(
      url: ApiConfig.moneyGroupDashboard(groupId),
      fromJson: (json) =>
          GroupDashboardModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data;
  }

  /// Get member-wise spending report
  Future<List<MemberSpendingSummaryModel>> getGroupMemberReport(
    int groupId, {
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
    final uri = Uri.parse(ApiConfig.moneyGroupMemberReport(groupId))
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await _apiClient.get<List<MemberSpendingSummaryModel>>(
      url: uri.toString(),
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) => MemberSpendingSummaryModel.fromJson(
                  item as Map<String, dynamic>))
              .toList();
        }
        return <MemberSpendingSummaryModel>[];
      },
    );
    return response.data ?? <MemberSpendingSummaryModel>[];
  }

  /// Get category-wise spending report
  Future<List<GroupCategorySpendingModel>> getGroupCategoryReport(
    int groupId, {
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
    final uri = Uri.parse(ApiConfig.moneyGroupCategoryReport(groupId))
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await _apiClient.get<List<GroupCategorySpendingModel>>(
      url: uri.toString(),
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) => GroupCategorySpendingModel.fromJson(
                  item as Map<String, dynamic>))
              .toList();
        }
        return <GroupCategorySpendingModel>[];
      },
    );
    return response.data ?? <GroupCategorySpendingModel>[];
  }
}
