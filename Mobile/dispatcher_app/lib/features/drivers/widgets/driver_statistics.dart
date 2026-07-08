import 'package:flutter/material.dart';

import '../../../core/widgets/dashboard_stat_card.dart';
import '../../../models/driver.dart';

class DriverStatistics extends StatelessWidget {
  final List<Driver> drivers;

  const DriverStatistics({
    super.key,
    required this.drivers,
  });

  @override
  Widget build(BuildContext context) {
    final total = drivers.length;

    final available = drivers
        .where((d) => d.status == "Available")
        .length;

    final assigned = drivers
        .where((d) => d.status == "Assigned")
        .length;

    final inactive = drivers
        .where((d) => d.status == "Inactive")
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: MediaQuery.of(context).size.width > 700
            ? 1.5
            : 1.2,
        children: [

          DashboardStatCard(
            title: "Drivers",
            value: total.toString(),
            icon: Icons.people,
            color: Colors.blue,
          ),

          DashboardStatCard(
            title: "Available",
            value: available.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),

          DashboardStatCard(
            title: "Assigned",
            value: assigned.toString(),
            icon: Icons.assignment_ind,
            color: Colors.orange,
          ),

          DashboardStatCard(
            title: "Inactive",
            value: inactive.toString(),
            icon: Icons.person_off,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}