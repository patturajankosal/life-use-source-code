import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final String type; // reminder, finance, system
  final IconData icon;
  final Color color;
  bool isRead;

  NotificationModel({
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

/// Reactive State Provider for Notifications and Alerts.
/// Powers dynamic unread indicators across the Bottom Navigation Bar,
/// Dashboard Header, and Notifications Center.
class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'notif_1',
      title: 'Electricity Utility Due in 3 Days',
      message:
          'State Power Corp bill of ₹1,840.00 is due on Oct 19. Ensure timely payment to avoid late fees.',
      time: '15m ago',
      type: 'reminder',
      icon: LucideIcons.zap,
      color: const Color(0xFFF59E0B),
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_2',
      title: 'Money Manager: Spending Safe',
      message:
          'Your remaining daily allowance today is well within budget targets. Great job pacing your outflow!',
      time: '2h ago',
      type: 'finance',
      icon: LucideIcons.wallet,
      color: AppColors.primary,
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_3',
      title: 'Doctor Appointment Reminder',
      message:
          'Annual health check-up with Dr. Sharma scheduled for tomorrow at 10:30 AM at Apollo Medical Center.',
      time: '5h ago',
      type: 'reminder',
      icon: LucideIcons.heartPulse,
      color: const Color(0xFF10B981),
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_4',
      title: 'LifeUse v2.0 Dashboard Active',
      message:
          'Welcome to the upgraded modular dashboard experience with live Money Manager micro-app integration.',
      time: '1d ago',
      type: 'system',
      icon: LucideIcons.shieldCheck,
      color: const Color(0xFF8B5CF6),
      isRead: true,
    ),
  ];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get hasUnread => unreadCount > 0;

  void markAllAsRead() {
    bool changed = false;
    for (final n in _notifications) {
      if (!n.isRead) {
        n.isRead = true;
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  void toggleRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = !_notifications[idx].isRead;
      notifyListeners();
    }
  }

  void addNotification(NotificationModel item) {
    _notifications.insert(0, item);
    notifyListeners();
  }
}
