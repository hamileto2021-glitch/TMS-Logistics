import 'package:flutter/material.dart';

import '../../../core/widgets/dashboard_stat_card.dart';
import '../../../models/shipment.dart';

class ShipmentStatistics extends StatelessWidget {
  final List<Shipment> shipments;

  const ShipmentStatistics({
    super.key,
    required this.shipments,
  });

  @override
  Widget build(BuildContext context) {
    final total = shipments.length;

    final pending = shipments
        .where((s) => s.status == "Pending")
        .length;

    final dispatched = shipments
        .where((s) => s.status == "Dispatched")
        .length;

    final delivered = shipments
        .where((s) => s.status == "Delivered")
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
            icon: Icons.inventory,
            color: Colors.blue,
          ),

          DashboardStatCard(
            title: "Pending",
            value: pending.toString(),
            icon: Icons.pending,
            color: Colors.orange,
          ),

          DashboardStatCard(
            title: "Dispatched",
            value: dispatched.toString(),
            icon: Icons.local_shipping,
            color: Colors.indigo,
          ),

          DashboardStatCard(
            title: "Delivered",
            value: delivered.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}