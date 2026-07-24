import 'package:flutter/material.dart';

import '../models/notification_item.dart';
import '../services/notification_service.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = NotificationService();

  List<NotificationItem> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final data = await _service.getNotifications();

    setState(() {
      _notifications = data;
      _loading = false;
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((n) {
        return NotificationItem(
          id: n.id,
          title: n.title,
          message: n.message,
          type: n.type,
          createdAt: n.createdAt,
          isRead: true,
        );
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("All notifications marked as read"),
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("All notifications cleared"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            tooltip: "Refresh",
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loading = true;
              });

              _loadNotifications();
            },
          ),

          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case "read":
                  _markAllAsRead();
                  break;

                case "clear":
                  _clearAll();
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "read",
                child: Text("Mark All as Read"),
              ),
              PopupMenuItem(
                value: "clear",
                child: Text("Clear All"),
              ),
            ],
          ),
        ],
      ),

      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _notifications.isEmpty
          ? const Center(
        child: Text("No notifications"),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Unread Notifications: ${_notifications.where((n) => !n.isRead).length}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return NotificationTile(
                  notification: _notifications[index],

                  onDelete: () {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                  },

                  onMarkRead: () {
                    setState(() {
                      final n = _notifications[index];

                      _notifications[index] = NotificationItem(
                        id: n.id,
                        title: n.title,
                        message: n.message,
                        type: n.type,
                        createdAt: n.createdAt,
                        isRead: true,
                      );
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}