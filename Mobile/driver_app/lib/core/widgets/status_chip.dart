import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {

  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  Color get color {

    switch(status){

      case "Completed":
        return Colors.green;

      case "InProgress":
        return Colors.orange;

      case "Assigned":
        return Colors.blue;

      default:
        return Colors.grey;

    }

  }

  @override
  Widget build(BuildContext context) {

    return Chip(

      backgroundColor: color,

      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}