import 'package:flutter/material.dart';

import '../models/geofence_notification.dart';

class NotificationTile extends StatelessWidget {
  final GeofenceNotification notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final entered = notification.eventType == "Entered";

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor:
          entered ? Colors.green : Colors.orange,
          child: Icon(
            entered
                ? Icons.login
                : Icons.logout,
            color: Colors.white,
          ),
        ),
        title: Text(
          notification.geofenceName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${notification.eventType}\n"
              "${notification.vehiclePlate}\n"
              "${notification.time}",
        ),
        isThreeLine: true,
      ),
    );
  }
}