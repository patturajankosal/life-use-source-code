import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../core/widgets/lifeuse_badge.dart';

class _TravelTicket {
  final String id;
  final String tripName;
  final String type; // Flight, Train, Hotel
  final String from;
  final String to;
  final String date;
  final String bookingRef;
  final IconData icon;

  const _TravelTicket({
    required this.id,
    required this.tripName,
    required this.type,
    required this.from,
    required this.to,
    required this.date,
    required this.bookingRef,
    required this.icon,
  });
}

class _PackingItem {
  final String id;
  final String name;
  bool isPacked = false;

  _PackingItem({
    required this.id,
    required this.name,
  });
}

/// Interactive Tickets & Travel micro-app screen.
/// Manages itineraries, travel passes, PNRs, and packing checklists.
class TicketsTravelScreen extends StatefulWidget {
  const TicketsTravelScreen({super.key});

  @override
  State<TicketsTravelScreen> createState() => _TicketsTravelScreenState();
}

class _TicketsTravelScreenState extends State<TicketsTravelScreen> {
  final List<_TravelTicket> _tickets = [];
  final List<_PackingItem> _packing = [];

  void _showAddPackingItemDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Add Packing Item',
            style: AppFonts.inter(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'e.g. Passport or Power bank',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() {
                  _packing.add(_PackingItem(
                    id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                    name: ctrl.text.trim(),
                  ));
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
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
    const accentColor = AppColors.primary;

    final packedCount = _packing.where((p) => p.isPacked).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Tickets & Travel',
          style: AppFonts.plusJakartaSans(
              fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const AppIcon(AppIcons.plus, size: 20),
            tooltip: 'Add Packing Item',
            onPressed: _showAddPackingItemDialog,
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
                  // 1. Travel Hero Summary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(
                              alpha: isDark ? 0.2 : 0.05),
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
                              AppIcons.ticketsTravel,
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
                                'Upcoming Travel Itinerary',
                                style: AppFonts.inter(
                                    fontSize: 12.5, color: textSecondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Bengaluru Tech Summit',
                                style: AppFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'Starts in 16 days • Nov 02, 2026',
                                style: AppFonts.inter(
                                    fontSize: 12,
                                    color: accentColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const LifeUseBadge(
                            text: 'CONFIRMED',
                            variant: LifeUseBadgeVariant.active),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 2. Tickets List
                  Text(
                    'Travel Bookings & Wallet',
                    style: AppFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary),
                  ),
                  const SizedBox(height: 12),

                  if (_tickets.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 36),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.iconBackgroundOf(context),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.iconBorderOf(context),
                                width: 1.2,
                              ),
                            ),
                            child: Center(
                              child: AppIcon(
                                AppIcons.ticketsTravel,
                                size: 26,
                                color: AppColors.brandIconOf(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Travel Itineraries',
                            style: AppFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'No upcoming flights, trains, or hotels planned.\nAdd booking confirmations to keep your trips organized.',
                            textAlign: TextAlign.center,
                            style: AppFonts.inter(
                              fontSize: 12,
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
                    itemCount: _tickets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final t = _tickets[i];
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
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.iconBackgroundOf(context),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: AppColors.iconBorderOf(context),
                                ),
                              ),
                              child: Center(
                                child: AppIcon(t.icon,
                                    color: AppColors.brandIconOf(context),
                                    size: 21),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${t.from} → ${t.to}',
                                        style: AppFonts.inter(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    t.date,
                                    style: AppFonts.inter(
                                        fontSize: 12, color: textSecondary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    t.bookingRef,
                                    style: AppFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // 3. Packing Checklist
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Packing Checklist',
                            style: AppFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textPrimary),
                          ),
                          const SizedBox(width: 8),
                          LifeUseBadge(
                            text: '$packedCount/${_packing.length} PACKED',
                            variant: packedCount == _packing.length
                                ? LifeUseBadgeVariant.active
                                : LifeUseBadgeVariant.pending,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.plusCircle, size: 20),
                        tooltip: 'Add Packing Item',
                        onPressed: _showAddPackingItemDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (_packing.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 36),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.iconBackgroundOf(context),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.iconBorderOf(context),
                                width: 1.2,
                              ),
                            ),
                            child: Center(
                              child: AppIcon(
                                AppIcons.ticketsTravel,
                                size: 26,
                                color: AppColors.brandIconOf(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Packing List Empty',
                            style: AppFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Add luggage essentials, devices, and passes before heading out.',
                            textAlign: TextAlign.center,
                            style: AppFonts.inter(
                              fontSize: 12,
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
                    itemCount: _packing.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final p = _packing[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: p.isPacked,
                              activeColor: accentColor,
                              onChanged: (val) {
                                setState(() => p.isPacked = val ?? false);
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                p.name,
                                style: AppFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      p.isPacked ? textSecondary : textPrimary,
                                  decoration: p.isPacked
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
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
}
