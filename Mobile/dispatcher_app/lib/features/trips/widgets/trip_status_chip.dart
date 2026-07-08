import 'package:flutter/material.dart';

class TripStatusChip extends StatelessWidget {
  final String status;

  const TripStatusChip({
    super.key,
    required this.status,
  });

  Color _backgroundColor() {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Colors.blue;

      case "in progress":
        return Colors.orange;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  IconData _icon() {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Icons.schedule;

      case "in progress":
        return Icons.local_shipping;

      case "completed":
        return Icons.check_circle;

      case "cancelled":
        return Icons.cancel;

      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        _icon(),
        color: Colors.white,
        size: 18,
      ),
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: _backgroundColor(),
    );
  }
}