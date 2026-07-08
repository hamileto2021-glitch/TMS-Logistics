import 'package:flutter/material.dart';

class AppStatusChip extends StatelessWidget {
  final String status;

  const AppStatusChip({
    super.key,
    required this.status,
  });

  Color _backgroundColor() {
    switch (status.toLowerCase()) {
      case 'available':
      case 'active':
      case 'completed':
      case 'delivered':
        return Colors.green.shade100;

      case 'assigned':
      case 'pending':
      case 'scheduled':
        return Colors.orange.shade100;

      case 'maintenance':
      case 'cancelled':
      case 'inactive':
        return Colors.red.shade100;

      case 'in transit':
        return Colors.blue.shade100;

      default:
        return Colors.grey.shade200;
    }
  }

  Color _textColor() {
    switch (status.toLowerCase()) {
      case 'available':
      case 'active':
      case 'completed':
      case 'delivered':
        return Colors.green.shade900;

      case 'assigned':
      case 'pending':
      case 'scheduled':
        return Colors.orange.shade900;

      case 'maintenance':
      case 'cancelled':
      case 'inactive':
        return Colors.red.shade900;

      case 'in transit':
        return Colors.blue.shade900;

      default:
        return Colors.black87;
    }
  }

  IconData _icon() {
    switch (status.toLowerCase()) {
      case 'available':
      case 'active':
        return Icons.check_circle;

      case 'assigned':
        return Icons.assignment;

      case 'maintenance':
        return Icons.build;

      case 'pending':
        return Icons.schedule;

      case 'in transit':
        return Icons.local_shipping;

      case 'completed':
      case 'delivered':
        return Icons.done_all;

      case 'cancelled':
      case 'inactive':
        return Icons.cancel;

      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        _icon(),
        size: 18,
        color: _textColor(),
      ),
      label: Text(
        status,
        style: TextStyle(
          color: _textColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: _backgroundColor(),
      visualDensity: VisualDensity.compact,
    );
  }
}