import 'package:flutter/material.dart';

import '../../../models/dashboard_summary.dart';
import '../../../core/widgets/dashboard_card.dart';

class OverviewCards extends StatelessWidget {
  final DashboardSummary summary;

  const OverviewCards({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [

        DashboardCard(
          icon: Icons.people,
          title: "Customers",
          value: summary.totalCustomers,
          color: Colors.blue,
        ),

        DashboardCard(
          icon: Icons.inventory,
          title: "Shipments",
          value: summary.totalShipments,
          color: Colors.orange,
        ),

        DashboardCard(
          icon: Icons.fire_truck,
          title: "Vehicles",
          value: summary.availableVehicles,
          color: Colors.indigo,
        ),

        DashboardCard(
          icon: Icons.person,
          title: "Drivers",
          value: summary.availableDrivers,
          color: Colors.teal,
        ),

        DashboardCard(
          icon: Icons.local_shipping,
          title: "Dispatches",
          value: summary.activeDispatches,
          color: Colors.red,
        ),

        DashboardCard(
          icon: Icons.route,
          title: "Trips",
          value: summary.activeTrips,
          color: Colors.green,
        ),
      ],
    );
  }
}