import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lifeuse_badge.dart';

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

  final List<_BillItem> _bills = [
    _BillItem(
      id: 'bill_1',
      title: 'Electricity Utility',
      provider: 'TNEB Power Distribution',
      amount: 1840.00,
      dueDate: 'Due Oct 19 (in 3 days)',
      icon: Icons.bolt_rounded,
      isPaid: false,
      isAutoPay: false,
    ),
    _BillItem(
      id: 'bill_2',
      title: 'Fiber Internet (300 Mbps)',
      provider: 'Airtel Broadband',
      amount: 1179.00,
      dueDate: 'Due Oct 22 (in 6 days)',
      icon: Icons.wifi_rounded,
      isPaid: false,
      isAutoPay: true,
    ),
    _BillItem(
      id: 'bill_3',
      title: 'Piped Natural Gas',
      provider: 'City Gas Networks',
      amount: 480.00,
      dueDate: 'Paid Oct 12',
      icon: Icons.local_fire_department_rounded,
      isPaid: true,
      isAutoPay: false,
    ),
    _BillItem(
      id: 'bill_4',
      title: 'Mobile Postpaid Plan',
      provider: 'Jio 5G Family Plan',
      amount: 699.00,
      dueDate: 'Paid Oct 10',
      icon: Icons.phone_android_rounded,
      isPaid: true,
      isAutoPay: true,
    ),
  ];

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
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Bill Name',
                hintText: 'e.g. Water Supply Bill',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: provCtrl,
              decoration: InputDecoration(
                labelText: 'Provider',
                hintText: 'e.g. Municipal Corp',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                hintText: 'e.g. 550.00',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateCtrl,
              decoration: InputDecoration(
                labelText: 'Due Date',
                hintText: 'e.g. Due Oct 28',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                setState(() {
                  _bills.insert(
                    0,
                    _BillItem(
                      id: 'bill_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleCtrl.text.trim(),
                      provider: provCtrl.text.trim().isEmpty ? 'Direct Provider' : provCtrl.text.trim(),
                      amount: double.tryParse(amountCtrl.text) ?? 500.0,
                      dueDate: dateCtrl.text.trim().isEmpty ? 'Due this month' : dateCtrl.text.trim(),
                      icon: Icons.receipt_long_rounded,
                      isPaid: false,
                    ),
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
    const accentColor = Color(0xFFF59E0B);

    final dueBills = _bills.where((b) => !b.isPaid).toList();
    final paidBills = _bills.where((b) => b.isPaid).toList();
    final totalDue = dueBills.fold(0.0, (sum, b) => sum + b.amount);

    final filtered = _filter == 'DUE'
        ? dueBills
        : (_filter == 'PAID' ? paidBills : _bills);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Bills & Payments',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Bill',
            onPressed: _showAddBillDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                          color: accentColor.withValues(alpha: isDark ? 0.2 : 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.receipt_long_rounded, color: accentColor, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pending Outflow Due',
                                style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _currencyFormat.format(totalDue),
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: totalDue > 0 ? accentColor : AppColors.success,
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
                      _buildFilterChip('ALL', 'All (${_bills.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('DUE', 'Due (${dueBills.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('PAID', 'Paid (${paidBills.length})'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. Bills List
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
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: b.isPaid
                                    ? AppColors.success.withValues(alpha: 0.12)
                                    : accentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                b.icon,
                                color: b.isPaid ? AppColors.success : accentColor,
                                size: 22,
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
                                          style: GoogleFonts.inter(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                            color: textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (b.isAutoPay) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'AUTO-PAY',
                                            style: GoogleFonts.inter(
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
                                    style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
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
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () {
                                    setState(() => b.isPaid = !b.isPaid);
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    child: Text(
                                      b.isPaid ? 'Mark Due' : 'Mark Paid',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: b.isPaid ? textSecondary : AppColors.primary,
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
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filter == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => _filter = value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.12)
              : AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFFF59E0B) : AppColors.borderOf(context),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFFF59E0B) : AppColors.textSecondaryOf(context),
          ),
        ),
      ),
    );
  }
}
