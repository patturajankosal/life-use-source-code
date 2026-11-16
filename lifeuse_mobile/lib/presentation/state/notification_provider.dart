import 'package:flutter/material.dart';
import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_icons.dart';

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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawType = (json['notificationType'] ?? json['type'] ?? 'system')
        .toString()
        .toLowerCase();
    String normalizedType = 'system';
    IconData icon = AppIcons.notifications;
    if (rawType.contains('bill') || rawType.contains('reminder')) {
      normalizedType = 'reminder';
      icon = AppIcons.billsPayments;
    } else if (rawType.contains('limit') ||
        rawType.contains('budget') ||
        rawType.contains('finance') ||
        rawType.contains('money')) {
      normalizedType = 'finance';
      icon = AppIcons.moneyManager;
    }

    String timeStr = 'Just now';
    if (json['createdAt'] != null) {
      try {
        final dt = DateTime.parse(json['createdAt'].toString()).toLocal();
        final diff = DateTime.now().difference(dt);
        if (diff.inMinutes < 60) {
          timeStr = '${diff.inMinutes.clamp(1, 59)}m ago';
        } else if (diff.inHours < 24) {
          timeStr = '${diff.inHours}h ago';
        } else {
          timeStr = '${diff.inDays}d ago';
        }
      } catch (_) {
        timeStr = 'Recent';
      }
    }

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Alert',
      message: json['message']?.toString() ?? '',
      time: timeStr,
      type: normalizedType,
      icon: icon,
      color: AppColors.primary,
      isRead: json['read'] == true || json['isRead'] == true,
    );
  }
}

/// Reactive State Provider for Notifications and Alerts.
/// Powers dynamic unread indicators across the Bottom Navigation Bar,
/// Dashboard Header, and Notifications Center.
class NotificationProvider extends ChangeNotifier {
  final ApiClient? _apiClient;

  NotificationProvider([this._apiClient]);

  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'notif_1',
      title: 'Electricity Utility Due in 3 Days',
      message:
          'State Power Corp bill of ₹1,840.00 is due on Oct 19. Ensure timely payment to avoid late fees.',
      time: '15m ago',
      type: 'reminder',
      icon: AppIcons.billsPayments,
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
      icon: AppIcons.moneyManager,
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
      icon: AppIcons.healthWellness,
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
      icon: AppIcons.documentsVault,
      color: const Color(0xFF8B5CF6),
      isRead: true,
    ),
  ];
  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;

  /// Fetch user notifications dynamically from backend
  Future<void> loadNotifications() async {
    final client = _apiClient;
    if (client == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await client.get<List<dynamic>>(
        url: ApiConfig.moneyNotifications,
      );
      if (res.data != null) {
        _notifications.clear();
        for (final item in res.data!) {
          if (item is Map<String, dynamic>) {
            _notifications.add(NotificationModel.fromJson(item));
          }
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark all notifications as read both locally and in backend
  Future<void> markAllAsRead() async {
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
    final client = _apiClient;
    if (client != null) {
      for (final n in _notifications) {
        try {
          await client.put(
            url: '${ApiConfig.moneyNotifications}/${n.id}/read',
            body: {},
          );
        } catch (_) {}
      }
    }
  }

  /// Toggle read state of a notification
  Future<void> toggleRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      final newRead = !_notifications[idx].isRead;
      _notifications[idx].isRead = newRead;
      notifyListeners();

      final client = _apiClient;
      if (client != null && newRead) {
        try {
          await client.put(
            url: '${ApiConfig.moneyNotifications}/$id/read',
            body: {},
          );
        } catch (_) {}
      }
    }
  }

  void addNotification(NotificationModel item) {
    _notifications.insert(0, item);
    notifyListeners();
  }

  /// Clear in-memory notification state upon logout
  void clear() {
    _notifications.clear();
    _error = null;
    notifyListeners();
  }
}
