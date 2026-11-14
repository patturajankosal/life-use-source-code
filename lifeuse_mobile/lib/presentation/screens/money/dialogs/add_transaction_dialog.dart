import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/sweet_alert.dart';
import '../../../../data/models/money/transaction_models.dart';
import '../../../state/money_provider.dart';

/// Modal bottom sheet dialog for recording a new financial transaction.
class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddTransactionDialog(),
    );
  }

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedType = 'EXPENSE';
  String _selectedCategory = 'Food & Dining';
  String _selectedPaymentMethod = 'UPI';
  bool _isEssential = true;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  final List<String> _defaultCategories = [
    'Food & Dining',
    'Groceries',
    'Rent & Utilities',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Healthcare',
    'Education',
    'Investment',
    'Salary',
    'Other',
  ];

  final List<String> _paymentMethods = ['UPI', 'CASH', 'CARD', 'NET_BANKING'];

  @override
  void dispose() {
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
      final req = TransactionCreateRequest(
        transactionType: _selectedType,
        categoryName: _selectedCategory,
        amount: amount,
        currency: 'INR',
        paymentMethod: _selectedPaymentMethod,
        transactionDate: _selectedDate,
        essential: _isEssential,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      );

      final moneyProvider = context.read<MoneyProvider>();
      await moneyProvider.addTransaction(req);

      if (mounted) {
        Navigator.pop(context, true);
        SweetAlert.showSuccess(
          context,
          title: 'Transaction Saved',
          message: 'Recorded ₹${amount.toStringAsFixed(2)} for $_selectedCategory.',
        );
      }
    } catch (e) {
      if (mounted) {
        SweetAlert.showError(
          context,
          title: 'Failed to Save',
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

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Record Transaction',
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

              // 1. Transaction Type Toggle (EXPENSE / INCOME / REFUND)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTypeOption('EXPENSE', 'Expense', AppColors.error),
                    _buildTypeOption('INCOME', 'Income', AppColors.success),
                    _buildTypeOption('REFUND', 'Refund', AppColors.accent),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Amount Input
              AppTextField(
                label: 'Amount (₹)',
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

              // 3. Category Selector
              DropdownButtonFormField<String>(
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
              const SizedBox(height: 16),

              // 4. Payment Method & Date in a Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedPaymentMethod,
                      dropdownColor: surfaceColor,
                      decoration: InputDecoration(
                        labelText: 'Payment Method',
                        labelStyle: GoogleFonts.inter(color: textSecondary),
                        prefixIcon: Icon(Icons.payment_rounded, color: textSecondary, size: 20),
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
                      items: _paymentMethods.map((pm) {
                        return DropdownMenuItem(value: pm, child: Text(pm));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedPaymentMethod = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
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
                        child: Row(
                          children: [
                            Icon(LucideIcons.calendar, size: 18, color: textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 5. Essential Toggle (for expenses)
              if (_selectedType == 'EXPENSE')
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
                    'Categorize as necessity (food, rent, medicine) vs discretionary',
                    style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                  ),
                  value: _isEssential,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) => setState(() => _isEssential = val),
                ),
              const SizedBox(height: 10),

              // 6. Notes Input
              AppTextField(
                label: 'Notes (optional)',
                hint: 'e.g., Grocery shopping at Supermart',
                controller: _notesController,
                prefixIcon: LucideIcons.fileText,
              ),
              const SizedBox(height: 24),

              // Submit Button
              AppButton(
                title: 'Save Transaction',
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

  Widget _buildTypeOption(String value, String label, Color activeColor) {
    final isSelected = _selectedType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? activeColor : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : AppColors.textSecondaryOf(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
