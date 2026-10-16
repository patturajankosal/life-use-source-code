import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
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
  bool isPacked;

  _PackingItem({
    required this.id,
    required this.name,
    this.isPacked = false,
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
  final List<_TravelTicket> _tickets = const [
    _TravelTicket(
      id: 't_1',
      tripName: 'Bengaluru Tech Conference',
      type: 'Flight',
      from: 'MAA (Chennai)',
      to: 'BLR (Bengaluru)',
      date: 'Nov 02 • 07:15 AM',
      bookingRef: '6E-482 (PNR: XY89KC)',
      icon: Icons.flight_takeoff_rounded,
    ),
    _TravelTicket(
      id: 't_2',
      tripName: 'Bengaluru Tech Conference',
      type: 'Hotel',
      from: 'Check-in: Nov 02',
      to: 'Check-out: Nov 04',
      date: '2 Nights • Whitefield',
      bookingRef: 'Marriott Courtyard (Conf: #90812)',
      icon: Icons.hotel_rounded,
    ),
    _TravelTicket(
      id: 't_3',
      tripName: 'Diwali Home Visit',
      type: 'Train',
      from: 'Chennai Central',
      to: 'Madurai Jn',
      date: 'Nov 11 • 10:30 PM',
      bookingRef: 'Tejas Express (PNR: 42189021)',
      icon: Icons.train_rounded,
    ),
  ];

  final List<_PackingItem> _packing = [
    _PackingItem(id: 'p_1', name: 'MacBook Pro & 96W Charger', isPacked: true),
    _PackingItem(id: 'p_2', name: 'National ID & Conference Passes', isPacked: true),
    _PackingItem(id: 'p_3', name: 'Noise Cancelling Headphones', isPacked: false),
    _PackingItem(id: 'p_4', name: 'Emergency Medications & First-Aid', isPacked: false),
    _PackingItem(id: 'p_5', name: 'Universal Travel Adapter & Cables', isPacked: false),
  ];

  void _showAddPackingItemDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Add Packing Item', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'e.g. Passport or Power bank',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
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
    const accentColor = Color(0xFF06B6D4);

    final packedCount = _packing.where((p) => p.isPacked).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Tickets & Travel',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
        ),
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
                          child: const Icon(Icons.flight_takeoff_rounded, color: accentColor, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upcoming Travel Itinerary',
                                style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Bengaluru Tech Summit',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'Starts in 16 days • Nov 02, 2026',
                                style: GoogleFonts.inter(fontSize: 12, color: accentColor, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const LifeUseBadge(text: 'CONFIRMED', variant: LifeUseBadgeVariant.active),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 2. Tickets List
                  Text(
                    'Travel Bookings & Wallet',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                  const SizedBox(height: 12),

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
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(t.icon, color: accentColor, size: 22),
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
                                        style: GoogleFonts.inter(
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
                                    style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    t.bookingRef,
                                    style: GoogleFonts.inter(
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
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
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
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        tooltip: 'Add Packing Item',
                        onPressed: _showAddPackingItemDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _packing.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final p = _packing[i];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                                style: GoogleFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: p.isPacked ? textSecondary : textPrimary,
                                  decoration: p.isPacked ? TextDecoration.lineThrough : null,
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
          ),
        ),
      ),
    );
  }
}
