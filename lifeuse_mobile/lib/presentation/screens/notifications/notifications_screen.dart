import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/lifeuse_badge.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final String type; // reminder, finance, system
  final IconData icon;
  final Color color;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

/// Responsive Notifications & Reminders Center for LifeUse.
/// Displays actionable reminders, financial milestones, and system updates.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'ALL'; // ALL, REMINDERS, FINANCE, SYSTEM

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'notif_1',
      title: 'Electricity Utility Due in 3 Days',
      message:
          'State Power Corp bill of ₹1,840.00 is due on Oct 19. Ensure timely payment to avoid late fees.',
      time: '15m ago',
      type: 'reminder',
      icon: Icons.bolt_rounded,
      color: const Color(0xFFF59E0B),
      isRead: false,
    ),
    NotificationItem(
      id: 'notif_2',
      title: 'Money Manager: Spending Safe',
      message:
          'Your remaining daily allowance today is well within budget targets. Great job pacing your outflow!',
      time: '2h ago',
      type: 'finance',
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.primary,
      isRead: false,
    ),
    NotificationItem(
      id: 'notif_3',
      title: 'Doctor Appointment Reminder',
      message:
          'Annual health check-up with Dr. Sharma scheduled for tomorrow at 10:30 AM at Apollo Medical Center.',
      time: '5h ago',
      type: 'reminder',
      icon: Icons.medical_services_rounded,
      color: const Color(0xFF10B981),
      isRead: true,
    ),
    NotificationItem(
      id: 'notif_4',
      title: 'LifeUse v2.0 Dashboard Active',
      message:
          'Welcome to the upgraded modular dashboard experience with live Money Manager micro-app integration.',
      time: '1d ago',
      type: 'system',
      icon: Icons.verified_rounded,
      color: const Color(0xFF8B5CF6),
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _toggleNotificationRead(NotificationItem item) {
    setState(() {
      item.isRead = !item.isRead;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredList = _notifications.where((n) {
      if (_selectedFilter == 'REMINDERS') return n.type == 'reminder';
      if (_selectedFilter == 'FINANCE') return n.type == 'finance';
      if (_selectedFilter == 'SYSTEM') return n.type == 'system';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        title: Text(
          'Notifications & Alerts',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark All Read',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Filter Chips
                  Row(
                    children: [
                      _buildFilterChip('ALL', 'All (${_notifications.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('REMINDERS', 'Reminders (2)'),
                      const SizedBox(width: 8),
                      _buildFilterChip('FINANCE', 'Finance (1)'),
                      const SizedBox(width: 8),
                      _buildFilterChip('SYSTEM', 'System (1)'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. Notifications List or Empty State
                  if (filteredList.isEmpty)
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
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 48,
                            color: textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Notifications',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You\'re all caught up! Important reminders and financial alerts will show up here.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
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
                      itemCount: filteredList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final item = filteredList[i];

                        return Container(
                          decoration: BoxDecoration(
                            color: item.isRead
                                ? surfaceColor
                                : AppColors.primary
                                    .withValues(alpha: isDark ? 0.08 : 0.04),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: item.isRead
                                  ? borderColor
                                  : AppColors.primary.withValues(alpha: 0.3),
                              width: item.isRead ? 1 : 1.2,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _toggleNotificationRead(item),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon Badge
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color:
                                          item.color.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            item.color.withValues(alpha: 0.25),
                                      ),
                                    ),
                                    child: Icon(
                                      item.icon,
                                      size: 20,
                                      color: item.color,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.title,
                                                style: GoogleFonts.inter(
                                                  fontSize: 14.5,
                                                  fontWeight: item.isRead
                                                      ? FontWeight.w600
                                                      : FontWeight.w700,
                                                  color: textPrimary,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              item.time,
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.message,
                                          style: GoogleFonts.inter(
                                            fontSize: 12.5,
                                            height: 1.4,
                                            color: textSecondary,
                                          ),
                                        ),
                                        if (!item.isRead) ...[
                                          const SizedBox(height: 8),
                                          const LifeUseBadge(
                                            text: 'NEW ALERT',
                                            variant:
                                                LifeUseBadgeVariant.active,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterKey),
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
          style: GoogleFonts.inter(
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
