import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  Color get color {
    switch (status.toLowerCase()) {
      case "assigned":
        return Colors.orange;

      case "scheduled":
        return Colors.blue;

      case "started":
      case "in progress":
        return Colors.green;

      case "paused":
        return Colors.deepOrange;

      case "completed":
        return Colors.grey;

      default:
        return Colors.black54;
    }
  }

  IconData get icon {
    switch (status.toLowerCase()) {
      case "assigned":
        return Icons.assignment;

      case "scheduled":
        return Icons.schedule;

      case "started":
      case "in progress":
        return Icons.local_shipping;

      case "paused":
        return Icons.pause_circle;

      case "completed":
        return Icons.check_circle;

      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        size: 18,
        color: Colors.white,
      ),
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
    );
  }
}