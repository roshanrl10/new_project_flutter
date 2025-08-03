import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationItem> _notifications = [];
  final List<Function(List<NotificationItem>)> _listeners = [];

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  void addNotification({
    required String title,
    required String message,
    required NotificationType type,
    DateTime? timestamp,
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: timestamp ?? DateTime.now(),
    );

    _notifications.insert(0, notification); // Add to top

    // Keep only last 10 notifications
    if (_notifications.length > 10) {
      _notifications.removeRange(10, _notifications.length);
    }

    _notifyListeners();
  }

  void removeNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    _notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    _notifyListeners();
  }

  void addListener(Function(List<NotificationItem>) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(List<NotificationItem>) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener(_notifications);
    }
  }

  // Predefined notification methods
  void showLoginSuccess(String userName) {
    addNotification(
      title: 'Login Successful',
      message: 'Welcome back, $userName! You are now logged in.',
      type: NotificationType.success,
    );
  }

  void showBookingSuccess(String hotelName) {
    addNotification(
      title: 'Booking Confirmed',
      message: 'Your booking for $hotelName has been confirmed successfully!',
      type: NotificationType.success,
    );
  }

  void showRentalSuccess(String equipmentName) {
    addNotification(
      title: 'Rental Confirmed',
      message:
          'Your rental for $equipmentName has been confirmed successfully!',
      type: NotificationType.success,
    );
  }

  void showBookingCancelled(String bookingName) {
    addNotification(
      title: 'Booking Cancelled',
      message: 'Your booking for $bookingName has been cancelled successfully.',
      type: NotificationType.info,
    );
  }

  void showError(String title, String message) {
    addNotification(
      title: title,
      message: message,
      type: NotificationType.error,
    );
  }

  void showInfo(String title, String message) {
    addNotification(
      title: title,
      message: message,
      type: NotificationType.info,
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
  });
}

enum NotificationType { success, error, warning, info }

extension NotificationTypeExtension on NotificationType {
  Color get color {
    switch (this) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.info:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.info:
        return Icons.info;
    }
  }
}
