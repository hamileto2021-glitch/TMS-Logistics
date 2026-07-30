import 'package:flutter/foundation.dart';

import '../models/geofence_notification.dart';

class NotificationController extends ChangeNotifier {
  final List<GeofenceNotification> _notifications = [];
  int _unreadCount = 0;

  List<GeofenceNotification> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _unreadCount;

  void addNotification(GeofenceNotification notification) {
    _notifications.insert(0, notification);
    _unreadCount++;
    notifyListeners();
  }

  void markAllAsRead() {
    _unreadCount = 0;
    notifyListeners();
  }

  void clear() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }
}