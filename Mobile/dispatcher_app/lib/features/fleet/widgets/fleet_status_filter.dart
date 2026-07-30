import 'package:flutter/material.dart';

class FleetStatusFilter extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onSelected;

  const FleetStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  static const List<String> statuses = [
    'All',
    'In Progress',
    'Scheduled',
    'Completed',
    'Delayed',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = statuses[index];

          return ChoiceChip(
            label: Text(status),
            selected: selectedStatus == status,
            onSelected: (_) => onSelected(status),
          );
        },
      ),
    );
  }
}