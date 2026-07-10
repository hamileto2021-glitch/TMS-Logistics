import 'package:flutter/material.dart';

import 'dashboard_grid_card.dart';

class DashboardStatistics extends StatelessWidget {
  final int customers;
  final int shipments;
  final int dispatches;
  final int trips;
  final int vehicles;
  final int drivers;

  final VoidCallback? onCustomersTap;
  final VoidCallback? onShipmentsTap;
  final VoidCallback? onDispatchesTap;
  final VoidCallback? onTripsTap;
  final VoidCallback? onVehiclesTap;
  final VoidCallback? onDriversTap;

  const DashboardStatistics({
    super.key,
    required this.customers,
    required this.shipments,
    required this.dispatches,
    required this.trips,
    required this.vehicles,
    required this.drivers,
    this.onCustomersTap,
    this.onShipmentsTap,
    this.onDispatchesTap,
    this.onTripsTap,
    this.onVehiclesTap,
    this.onDriversTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.90,
        children: [

          DashboardGridCard(
            title: "Customers",
            value: customers.toString(),
            icon: Icons.people,
            color: Colors.blue,
            onTap: onCustomersTap,
          ),

          DashboardGridCard(
            title: "Shipments",
            value: shipments.toString(),
            icon: Icons.inventory,
            color: Colors.orange,
            onTap: onShipmentsTap,
          ),

          DashboardGridCard(
            title: "Dispatches",
            value: dispatches.toString(),
            icon: Icons.local_shipping,
            color: Colors.green,
            onTap: onDispatchesTap,
          ),

          DashboardGridCard(
            title: "Trips",
            value: trips.toString(),
            icon: Icons.route,
            color: Colors.purple,
            onTap: onTripsTap,
          ),

          DashboardGridCard(
            title: "Vehicles",
            value: vehicles.toString(),
            icon: Icons.directions_bus,
            color: Colors.red,
            onTap: onVehiclesTap,
          ),

          DashboardGridCard(
            title: "Drivers",
            value: drivers.toString(),
            icon: Icons.person,
            color: Colors.teal,
            onTap: onDriversTap,
          ),

        ],
      ),
    );
  }
}