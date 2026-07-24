import '../models/notification_item.dart';

class NotificationService {

  Future<List<NotificationItem>> getNotifications() async {

    // Temporary demo data
    await Future.delayed(const Duration(milliseconds: 500));

    return [

      NotificationItem(
        id: 1,
        title: "Shipment Assigned",
        message: "Shipment SHP-000015 assigned to Driver Ahmed",
        type: "Shipment",
        createdAt: DateTime.now(),
        isRead: false,
      ),

      NotificationItem(
        id: 2,
        title: "Trip Completed",
        message: "Trip TRP-000007 completed successfully",
        type: "Trip",
        createdAt: DateTime.now(),
        isRead: true,
      ),
    ];
  }
}