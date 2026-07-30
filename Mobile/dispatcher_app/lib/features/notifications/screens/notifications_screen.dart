import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/notification_controller.dart';
import '../widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
    context.watch<NotificationController>();
    controller.markAllAsRead();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: controller.clear,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: controller.notifications.length,
        itemBuilder: (_, index) {
          return NotificationTile(
            notification:
            controller.notifications[index],
          );
        },
      ),
    );
  }
}