import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../core/widgets/lifeuse_badge.dart';
import '../../../data/models/money/recurring_schedule_models.dart';
import '../../state/money_provider.dart';

class _BillItem {
  final String id;
  final String title;
  final String provider;
  final double amount;
  final String dueDate;
  final IconData icon;
  bool isPaid;
  final bool isAutoPay;

  _BillItem({
    required this.id,
    required this.title,
    required this.provider,
    required this.amount,
    required this.dueDate,
    required this.icon,
    this.isPaid = false,
    this.isAutoPay = false,
  });
}

/// Interactive Bills & Subscriptions micro-app screen.
/// Tracks due dates, utility invoices, subscription services, and payment status.
class BillsPaymentsScreen extends StatefulWidget {
  const BillsPaymentsScreen({super.key});

  @override
  State<BillsPaymentsScreen> createState() => _BillsPaymentsScreenState();
}

class _BillsPaymentsScreenState extends State<BillsPaymentsScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  String _filter = 'ALL'; // ALL, DUE, PAID
  final List<_BillItem> _localBills = [];

  void _showAddBillDialog() {
    final titleCtrl = TextEditingController();
    final provCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final dateCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Add Upcoming Bill',
          style: AppFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Bill Name',
                hintText: 'e.g. Water Supply Bill',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: provCtrl,
              decoration: InputDecoration(
                labelText: 'Provider',
                hintText: 'e.g. Municipal Corp',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                hintText: 'e.g. 550.00',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateCtrl,
              decoration: InputDecoration(
                labelText: 'Due Date',
                hintText: 'e.g. Due Oct 28',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                final amount = double.tryParse(amountCtrl.text) ?? 500.0;
                final providerName = provCtrl.text.trim().isEmpty
                    ? 'Direct Provider'
                    : provCtrl.text.trim();
                final dueStr = dateCtrl.text.trim().isEmpty
                    ? 'Due this month'
                    : dateCtrl.text.trim();

                final money = context.read<MoneyProvider>();
                money.addRecurringSchedule(RecurringScheduleRequest(
                  title: title,
                  transactionType: 'EXPENSE',
                  categoryName: 'Bills & Utilities',
                  amount: amount,
                  frequency: 'MONTHLY',
                  startDate: DateTime.now(),
                )).catchError((_) {
                  setState(() {
                    _localBills.insert(
                      0,
                      _BillItem(
                        id: 'bill_${DateTime.now().millisecondsSinceEpoch}',
                        title: title,
                        provider: providerName,
                        amount: amount,
                        dueDate: dueStr,
                        icon: AppIcons.billsPayments,
                        isPaid: false,
                      ),
                    );
                  });
                  return RecurringScheduleModel(
                    id: 0,
                    userId: 0,
                    title: title,
                    transactionType: 'EXPENSE',
                    categoryName: 'Bills & Utilities',
                    amount: amount,
                    frequency: 'MONTHLY',
                    startDate: DateTime.now(),
                    essential: true,
                    paymentMethod: 'UPI',
                    active: true,
                  );
                });

                Navigator.pop(ctx);
              }
            },
            child: const Text('Save Bill'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    final money = context.watch<MoneyProvider>();

    // Build unified list from real backend occurrences + recurring schedules + user added bills
    final List<_BillItem> allBills = [..._localBills];

    for (final oc in money.upcomingOccurrences) {
      allBills.add(_BillItem(
        id: 'oc_${oc.id}',
        title: oc.scheduleTitle,
        provider: 'Scheduled Occurrence',
        amount: oc.amount,
        dueDate: 'Due ${DateFormat('MMM d').format(oc.scheduledDate)}',
        icon: AppIcons.billsPayments,
        isPaid: oc.isProcessed,
        isAutoPay: true,
      ));
    }

    for (final rs in money.recurringSchedules) {
      if (!allBills.any((b) => b.title.toLowerCase() == rs.title.toLowerCase())) {
        allBills.add(_BillItem(
          id: 'rs_${rs.id}',
          title: rs.title,
          provider: rs.categoryName,
          amount: rs.amount,
          dueDate: rs.nextOccurrenceDate != null
              ? 'Due ${DateFormat('MMM d').format(rs.nextOccurrenceDate!)}'
              : rs.frequency,
          icon: AppIcons.billsPayments,
          isPaid: false,
          isAutoPay: true,
        ));
      }
    }

    final dueBills = allBills.where((b) => !b.isPaid).toList();
    final paidBills = allBills.where((b) => b.isPaid).toList();
    final totalDue = dueBills.fold(0.0, (sum, b) => sum + b.amount);

    final filtered =
        _filter == 'DUE' ? dueBills : (_filter == 'PAID' ? paidBills : allBills);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Bills & Payments',
          style: AppFonts.plusJakartaSans(
              fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const AppIcon(AppIcons.plus, size: 22),
            tooltip: 'Add Bill',
            onPressed: _showAddBillDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Total Due Summary Hero Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.20 : 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.iconBackgroundOf(context),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.iconBorderOf(context),
                            ),
                          ),
                          child: Center(
                            child: AppIcon(
                              AppIcons.billsPayments,
                              color: AppColors.brandIconOf(context),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pending Outflow Due',
                                style: AppFonts.inter(
                                    fontSize: 12.5, color: textSecondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _currencyFormat.format(totalDue),
                                style: AppFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        LifeUseBadge(
                          text: '${dueBills.length} PENDING',
                          variant: dueBills.isNotEmpty
                              ? LifeUseBadgeVariant.pending
                              : LifeUseBadgeVariant.active,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 2. Filter Pills
                  Row(
                    children: [
                      _buildFilterChip('ALL', 'All (${allBills.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('DUE', 'Due (${dueBills.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('PAID', 'Paid (${paidBills.length})'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. Bills List or Empty State
                  if (filtered.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.iconBackgroundOf(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.iconBorderOf(context),
                                width: 1.2,
                              ),
                            ),
                            child: Center(
                              child: AppIcon(
                                AppIcons.billsPayments,
                                size: 28,
                                color: AppColors.brandIconOf(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Upcoming Bills',
                            style: AppFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You have no pending bills or active recurring subscriptions.\nTap \'+\' in the header to add your utility bills or recharge reminders.',
                            textAlign: TextAlign.center,
                            style: AppFonts.inter(
                              fontSize: 12.5,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final b = filtered[i];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.iconBackgroundOf(context),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.iconBorderOf(context),
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                  child: AppIcon(
                                    b.icon,
                                    color: AppColors.brandIconOf(context),
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            b.title,
                                            style: AppFonts.inter(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w700,
                                              color: textPrimary,
                                            ),
                                          ),
                                        ),
                                        if (b.isAutoPay) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'AUTO-PAY',
                                              style: AppFonts.inter(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${b.provider} • ${b.dueDate}',
                                      style: AppFonts.inter(
                                          fontSize: 12, color: textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _currencyFormat.format(b.amount),
                                    style: AppFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () {
                                      if (b.id.startsWith('oc_')) {
                                        final ocId = int.tryParse(b.id.substring(3));
                                        if (ocId != null) {
                                          context.read<MoneyProvider>().processOccurrence(ocId);
                                        }
                                      }
                                      setState(() => b.isPaid = !b.isPaid);
                                    },
                                    borderRadius: BorderRadius.circular(6),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      child: Text(
                                        b.isPaid ? 'Mark Due' : 'Mark Paid',
                                        style: AppFonts.inter(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: b.isPaid
                                              ? textSecondary
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 250.ms),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = _filter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _filter = filterKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderOf(context),
          ),
        ),
        child: Text(
          label,
          style: AppFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color:
                isSelected ? Colors.white : AppColors.textSecondaryOf(context),
          ),
        ),
      ),
    );
  }
}
