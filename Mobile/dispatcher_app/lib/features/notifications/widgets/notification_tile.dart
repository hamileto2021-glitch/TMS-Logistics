import 'package:flutter/material.dart';

import '../models/notification_item.dart';

class NotificationTile extends StatelessWidget {

  final NotificationItem notification;

  final VoidCallback? onDelete;
  final VoidCallback? onMarkRead;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onDelete,
    this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {

    return Dismissible(
        key: Key(notification.id.toString()),

        background: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(
            Icons.done,
            color: Colors.white,
          ),
        ),

        secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),

      confirmDismiss: (direction) async {

        if (direction == DismissDirection.startToEnd) {

          onMarkRead?.call();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Notification marked as read"),
            ),
          );

          return false;
        }

        onDelete?.call();

        return true;
      },

        child: Card(
          child: ListTile(

        leading: CircleAvatar(
          child: Icon(
            notification.isRead
                ? Icons.notifications
                : Icons.notifications_active,
          ),
        ),

        title: Text(notification.title),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(notification.message),

            const SizedBox(height: 5),

            Text(
              notification.createdAt.toString(),
              style: const TextStyle(fontSize: 11),
            ),

          ],
        ),

            trailing: notification.isRead
                ? null
                : const Icon(
              Icons.circle,
              size: 10,
              color: Colors.red,
            ),
          ),
        ),
    );
  }
}