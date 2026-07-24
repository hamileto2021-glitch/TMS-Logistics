import 'package:flutter/material.dart';

class ReportFilterBar extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onChanged;

  const ReportFilterBar({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DropdownButtonFormField<String>(
          value: selectedPeriod,
          decoration: const InputDecoration(
            labelText: "Report Period",
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: "Today",
              child: Text("Today"),
            ),
            DropdownMenuItem(
              value: "This Week",
              child: Text("This Week"),
            ),
            DropdownMenuItem(
              value: "This Month",
              child: Text("This Month"),
            ),
            DropdownMenuItem(
              value: "This Year",
              child: Text("This Year"),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}