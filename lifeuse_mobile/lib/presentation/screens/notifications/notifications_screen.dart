import 'package:flutter/material.dart';
import 'package:lifeuse_mobile/core/theme/app_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/icons/lifeuse_icons.dart';
import '../../../core/widgets/lifeuse_badge.dart';
import '../../state/notification_provider.dart';

typedef NotificationItem = NotificationModel;

/// Responsive Notifications & Reminders Center for LifeUse.
/// Displays actionable reminders, financial milestones, and system updates.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'ALL'; // ALL, REMINDERS, FINANCE, SYSTEM

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  void _markAllAsRead() {
    context.read<NotificationProvider>().markAllAsRead();
  }

  void _toggleNotificationRead(NotificationModel item) {
    context.read<NotificationProvider>().toggleRead(item.id);
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final notifProvider = context.watch<NotificationProvider>();
    final notifications = notifProvider.notifications;
    final unreadCount = notifProvider.unreadCount;

    final filteredList = notifications.where((n) {
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
          style: AppFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark All Read',
                style: AppFonts.inter(
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
        child: RefreshIndicator(
          onRefresh: () =>
              context.read<NotificationProvider>().loadNotifications(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Filter Chips
                  Row(
                    children: [
                      _buildFilterChip('ALL', 'All (${notifications.length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('REMINDERS',
                          'Reminders (${notifications.where((n) => n.type == 'reminder').length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('FINANCE',
                          'Finance (${notifications.where((n) => n.type == 'finance').length})'),
                      const SizedBox(width: 8),
                      _buildFilterChip('SYSTEM',
                          'System (${notifications.where((n) => n.type == 'system').length})'),
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
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.25),
                                width: 1.2,
                              ),
                            ),
                            child: const Center(
                              child: AppIcon(
                                AppIcons.alertsOutline,
                                size: 28,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Notifications',
                            style: AppFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You\'re all caught up! Important reminders and financial alerts will show up here.',
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
                      itemCount: filteredList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final item = filteredList[i];

                        return Container(
                          decoration: BoxDecoration(
                            color: item.isRead
                                ? surfaceColor
                                : (isDark
                                    ? const Color(0xFF262626)
                                    : const Color(0xFFF7F7F8)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: item.isRead
                                  ? borderColor
                                  : (isDark
                                      ? const Color(0xFF383838)
                                      : const Color(0xFFD4D4D8)),
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
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.iconBackgroundOf(context),
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                        color: AppColors.iconBorderOf(context),
                                      ),
                                    ),
                                    child: Center(
                                      child: AppIcon(
                                        item.icon,
                                        size: 24,
                                        color: AppColors.brandIconOf(context),
                                      ),
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
                                                style: AppFonts.inter(
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
                                              style: AppFonts.inter(
                                                fontSize: 11,
                                                color: textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.message,
                                          style: AppFonts.inter(
                                            fontSize: 12.5,
                                            height: 1.4,
                                            color: textSecondary,
                                          ),
                                        ),
                                        if (!item.isRead) ...[
                                          const SizedBox(height: 8),
                                          const LifeUseBadge(
                                            text: 'NEW ALERT',
                                            variant: LifeUseBadgeVariant.active,
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
                  // Clearance for floating bottom navigation bar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 250.ms),
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
