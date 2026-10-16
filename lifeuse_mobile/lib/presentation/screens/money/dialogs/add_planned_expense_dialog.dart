import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/sweet_alert.dart';
import '../../../../data/models/money/planned_expense_models.dart';
import '../../../state/money_provider.dart';

/// Modal bottom sheet dialog for scheduling a planned upcoming expense or special-day spending.
class AddPlannedExpenseDialog extends StatefulWidget {
  const AddPlannedExpenseDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddPlannedExpenseDialog(),
    );
  }

  @override
  State<AddPlannedExpenseDialog> createState() => _AddPlannedExpenseDialogState();
}

class _AddPlannedExpenseDialogState extends State<AddPlannedExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Shopping';
  DateTime _plannedDate = DateTime.now().add(const Duration(days: 3));
  bool _isEssential = false;
  bool _isSubmitting = false;

  final List<String> _defaultCategories = [
    'Shopping',
    'Travel & Vacation',
    'Festival & Celebration',
    'Electronics & Gadgets',
    'Medical & Health',
    'Home Improvement',
    'Education & Books',
    'Gift',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
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
      final req = PlannedExpenseRequest(
        title: _titleController.text.trim(),
        amount: amount,
        plannedDate: _plannedDate,
        categoryName: _selectedCategory,
        essential: _isEssential,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      final moneyProvider = context.read<MoneyProvider>();
      await moneyProvider.addPlannedExpense(req);

      if (mounted) {
        Navigator.pop(context, true);
        SweetAlert.showSuccess(
          context,
          title: 'Planned Expense Scheduled',
          message: '"${_titleController.text.trim()}" (₹${amount.toStringAsFixed(2)}) has been scheduled.',
        );
      }
    } catch (e) {
      if (mounted) {
        SweetAlert.showError(
          context,
          title: 'Failed to Schedule',
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
                    'Schedule Planned Expense',
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

              // Title Field
              AppTextField(
                label: 'Title / Description',
                hint: 'e.g., Diwali shopping, Laptop purchase',
                controller: _titleController,
                prefixIcon: Icons.title_rounded,
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 16),

              // Amount Field
              AppTextField(
                label: 'Planned Amount (₹)',
                hint: '0.00',
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.currency_rupee_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter amount';
                  if (double.tryParse(val.trim()) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category & Date in a Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      dropdownColor: surfaceColor,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: GoogleFonts.inter(color: textSecondary),
                        prefixIcon: Icon(Icons.category_outlined, color: textSecondary, size: 20),
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
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _plannedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 730)),
                        );
                        if (picked != null) {
                          setState(() => _plannedDate = picked);
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
                            Text('Planned Date', style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
                            const SizedBox(height: 4),
                            Text(
                              '${_plannedDate.day}/${_plannedDate.month}/${_plannedDate.year}',
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Essential Toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Essential Expense',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                subtitle: Text(
                  'Guarantees daily limit protects funds for this expense',
                  style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                ),
                value: _isEssential,
                activeThumbColor: AppColors.primary,
                onChanged: (val) => setState(() => _isEssential = val),
              ),
              const SizedBox(height: 10),

              // Notes Field
              AppTextField(
                label: 'Notes (optional)',
                hint: 'e.g., Saved for online sale offer',
                controller: _notesController,
                prefixIcon: Icons.notes_rounded,
              ),
              const SizedBox(height: 24),

              // Submit Button
              AppButton(
                title: 'Schedule Expense',
                isLoading: _isSubmitting,
                icon: Icons.event_available_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
