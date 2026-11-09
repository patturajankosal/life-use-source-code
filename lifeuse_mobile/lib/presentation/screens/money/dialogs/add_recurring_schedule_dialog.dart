import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/sweet_alert.dart';
import '../../../../data/models/money/recurring_schedule_models.dart';
import '../../../state/money_provider.dart';

/// Modal bottom sheet dialog for creating a recurring transaction schedule.
class AddRecurringScheduleDialog extends StatefulWidget {
  const AddRecurringScheduleDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddRecurringScheduleDialog(),
    );
  }

  @override
  State<AddRecurringScheduleDialog> createState() => _AddRecurringScheduleDialogState();
}

class _AddRecurringScheduleDialogState extends State<AddRecurringScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String _transactionType = 'EXPENSE';
  String _selectedCategory = 'Rent & Utilities';
  String _frequency = 'MONTHLY';
  String _paymentMethod = 'UPI';
  final DateTime _startDate = DateTime.now();
  final int _dayOfMonth = DateTime.now().day;
  bool _isEssential = true;
  bool _isSubmitting = false;

  final List<String> _frequencies = ['DAILY', 'WEEKLY', 'MONTHLY', 'QUARTERLY', 'YEARLY'];
  final List<String> _paymentMethods = ['UPI', 'CASH', 'CARD', 'NET_BANKING'];
  final List<String> _defaultCategories = [
    'Rent & Utilities',
    'Subscriptions',
    'Insurance',
    'Loan / EMI',
    'Groceries',
    'Salary',
    'Investment',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      SweetAlert.showWarning(
        context,
        title: 'Invalid Amount',
        message: 'Please enter a valid amount greater than zero.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final req = RecurringScheduleRequest(
        title: _titleController.text.trim(),
        transactionType: _transactionType,
        categoryName: _selectedCategory,
        amount: amount,
        frequency: _frequency,
        startDate: _startDate,
        dayOfMonth: _frequency == 'MONTHLY' ? _dayOfMonth : null,
        essential: _isEssential,
        paymentMethod: _paymentMethod,
      );

      final moneyProvider = context.read<MoneyProvider>();
      await moneyProvider.addRecurringSchedule(req);

      if (mounted) {
        Navigator.pop(context, true);
        SweetAlert.showSuccess(
          context,
          title: 'Schedule Created',
          message: '"${_titleController.text.trim()}" ($_frequency) has been scheduled.',
        );
      }
    } catch (e) {
      if (mounted) {
        SweetAlert.showError(
          context,
          title: 'Failed to Create Schedule',
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

    final moneyProvider = context.watch<MoneyProvider>();
    final categories = moneyProvider.categories.isNotEmpty
        ? moneyProvider.categories.map((c) => c.name).toList()
        : _defaultCategories;

    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = categories.first;
    }

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

              // Title Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recurring Schedule',
                    style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Transaction Type Selector
              Row(
                children: [
                  _buildTypeChoice('EXPENSE', 'Expense Schedule', AppColors.error),
                  const SizedBox(width: 10),
                  _buildTypeChoice('INCOME', 'Income Schedule', AppColors.success),
                ],
              ),
              const SizedBox(height: 16),

              // Title Field
              AppTextField(
                label: 'Title',
                hint: 'e.g., Netflix subscription, Home rent, Gym membership',
                controller: _titleController,
                prefixIcon: LucideIcons.repeat,
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 16),

              // Amount & Frequency in a Row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppTextField(
                      label: 'Amount (₹)',
                      hint: '0.00',
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.currency_rupee_rounded,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Required';
                        if (double.tryParse(val.trim()) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: _frequency,
                      dropdownColor: surfaceColor,
                      decoration: InputDecoration(
                        labelText: 'Frequency',
                        labelStyle: GoogleFonts.inter(color: textSecondary),
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
                      style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
                      items: _frequencies.map((f) {
                        return DropdownMenuItem(value: f, child: Text(f));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _frequency = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Category & Payment Method
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      dropdownColor: surfaceColor,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: GoogleFonts.inter(color: textSecondary),
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
                      style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
                      items: categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _paymentMethod,
                      dropdownColor: surfaceColor,
                      decoration: InputDecoration(
                        labelText: 'Payment Method',
                        labelStyle: GoogleFonts.inter(color: textSecondary),
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
                      style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
                      items: _paymentMethods.map((pm) {
                        return DropdownMenuItem(value: pm, child: Text(pm));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _paymentMethod = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Essential Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Essential Schedule',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Marks commitment as non-negotiable obligation',
                  style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                ),
                value: _isEssential,
                activeThumbColor: AppColors.primary,
                onChanged: (val) => setState(() => _isEssential = val),
              ),
              const SizedBox(height: 20),

              // Submit Button
              AppButton(
                title: 'Save Schedule',
                isLoading: _isSubmitting,
                icon: LucideIcons.checkCircle2,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChoice(String value, String label, Color color) {
    final isSelected = _transactionType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _transactionType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.borderOf(context),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : AppColors.textSecondaryOf(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
