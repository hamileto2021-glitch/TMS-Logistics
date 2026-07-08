import 'package:flutter/material.dart';

import '../../../core/widgets/dashboard_stat_card.dart';
import '../../../models/vehicle.dart';

class VehicleStatistics extends StatelessWidget {
  final List<Vehicle> vehicles;

  const VehicleStatistics({
    super.key,
    required this.vehicles,
  });

  @override
  Widget build(BuildContext context) {
    final total = vehicles.length;

    final available = vehicles
        .where((e) => e.status == "Available")
        .length;

    final assigned = vehicles
        .where((e) => e.status == "Assigned")
        .length;

    final maintenance = vehicles
        .where((e) => e.status == "Maintenance")
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
            title: "Total",
            value: total.toString(),
            icon: Icons.fire_truck,
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
            icon: Icons.assignment,
            color: Colors.orange,
          ),
          DashboardStatCard(
            title: "Maintenance",
            value: maintenance.toString(),
            icon: Icons.build,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}