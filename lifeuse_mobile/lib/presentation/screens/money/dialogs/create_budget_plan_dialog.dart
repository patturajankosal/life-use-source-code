import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/sweet_alert.dart';
import '../../../../data/models/money/budget_plan_models.dart';
import '../../../state/money_provider.dart';

/// Modal bottom sheet dialog for creating a new multi-horizon budget plan.
class CreateBudgetPlanDialog extends StatefulWidget {
  const CreateBudgetPlanDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CreateBudgetPlanDialog(),
    );
  }

  @override
  State<CreateBudgetPlanDialog> createState() => _CreateBudgetPlanDialogState();
}

class _CreateBudgetPlanDialogState extends State<CreateBudgetPlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _notesController = TextEditingController();

  String _periodType = 'MONTHLY';
  String _carryForwardRule = 'RESET';
  DateTime _startDate = DateTime.now();
  late DateTime _endDate;
  bool _isSubmitting = false;

  final List<String> _periodTypes = ['MONTHLY', 'WEEKLY', 'BI_WEEKLY', 'CUSTOM'];
  final List<String> _carryForwardRules = [
    'RESET',
    'CARRY_POSITIVE',
    'CARRY_NEGATIVE',
    'CARRY_ALL',
  ];

  @override
  void initState() {
    super.initState();
    _endDate = DateTime(_startDate.year, _startDate.month + 1, 0); // End of current month
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _periodType = period;
      if (period == 'WEEKLY') {
        _endDate = _startDate.add(const Duration(days: 6));
      } else if (period == 'BI_WEEKLY') {
        _endDate = _startDate.add(const Duration(days: 13));
      } else if (period == 'MONTHLY') {
        _endDate = DateTime(_startDate.year, _startDate.month + 1, 0);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final totalBudget = double.tryParse(_budgetController.text.trim());
    if (totalBudget == null || totalBudget <= 0) {
      SweetAlert.showWarning(
        context,
        title: 'Invalid Budget',
        message: 'Please enter a valid total budget amount greater than zero.',
      );
      return;
    }

    if (_endDate.isBefore(_startDate)) {
      SweetAlert.showWarning(
        context,
        title: 'Invalid Date Range',
        message: 'End date must be on or after start date.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final req = BudgetPlanRequest(
        periodType: _periodType,
        startDate: _startDate,
        endDate: _endDate,
        totalBudget: totalBudget,
        carryForwardRule: _carryForwardRule,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      final moneyProvider = context.read<MoneyProvider>();
      await moneyProvider.addBudgetPlan(req);

      if (mounted) {
        Navigator.pop(context, true);
        SweetAlert.showSuccess(
          context,
          title: 'Budget Plan Created',
          message: '$_periodType budget plan of ₹${totalBudget.toStringAsFixed(2)} is now active.',
        );
      }
    } catch (e) {
      if (mounted) {
        SweetAlert.showError(
          context,
          title: 'Failed to Create Plan',
          message: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: borderColor),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Budget Plan',
                    style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 1. Period Selector
              DropdownButtonFormField<String>(
                initialValue: _periodType,
                dropdownColor: surfaceColor,
                decoration: InputDecoration(
                  labelText: 'Plan Period Horizon',
                  labelStyle: GoogleFonts.inter(color: textSecondary),
                  prefixIcon: Icon(Icons.date_range_rounded, color: textSecondary, size: 20),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.02),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
                style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
                items: _periodTypes.map((p) {
                  return DropdownMenuItem(value: p, child: Text(p));
                }).toList(),
                onChanged: (val) {
                  if (val != null) _onPeriodChanged(val);
                },
              ),
              const SizedBox(height: 16),

              // 2. Budget Amount
              AppTextField(
                label: 'Total Budget Amount (₹)',
                hint: 'e.g. 25000.00',
                controller: _budgetController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.currency_rupee_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter budget amount';
                  if (double.tryParse(val.trim()) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Date Range Pickers in a Row
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setState(() {
                            _startDate = picked;
                            if (_endDate.isBefore(_startDate)) {
                              _endDate = _startDate.add(const Duration(days: 30));
                            }
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : Colors.black.withValues(alpha: 0.02),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start Date', style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
                            const SizedBox(height: 4),
                            Text(
                              '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime(2035),
                        );
                        if (picked != null) {
                          setState(() => _endDate = picked);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : Colors.black.withValues(alpha: 0.02),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('End Date', style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
                            const SizedBox(height: 4),
                            Text(
                              '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Carry-Forward Rule
              DropdownButtonFormField<String>(
                initialValue: _carryForwardRule,
                dropdownColor: surfaceColor,
                decoration: InputDecoration(
                  labelText: 'Carry Forward Rule',
                  labelStyle: GoogleFonts.inter(color: textSecondary),
                  prefixIcon: Icon(Icons.sync_alt_rounded, color: textSecondary, size: 20),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.02),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
                style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
                items: _carryForwardRules.map((r) {
                  return DropdownMenuItem(value: r, child: Text(r));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _carryForwardRule = val);
                },
              ),
              const SizedBox(height: 16),

              // 5. Notes
              AppTextField(
                label: 'Notes (optional)',
                hint: 'e.g., Monthly allowance plan',
                controller: _notesController,
                prefixIcon: Icons.notes_rounded,
              ),
              const SizedBox(height: 24),

              // Submit Button
              AppButton(
                title: 'Create Budget Plan',
                isLoading: _isSubmitting,
                icon: Icons.check_circle_outline_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
