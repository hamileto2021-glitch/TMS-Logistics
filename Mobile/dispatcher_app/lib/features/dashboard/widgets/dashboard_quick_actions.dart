import 'package:flutter/material.dart';

class DashboardQuickActions extends StatelessWidget {
  final VoidCallback? onAddCustomer;
  final VoidCallback? onAddShipment;
  final VoidCallback? onAddDispatch;
  final VoidCallback? onAddTrip;
  final VoidCallback? onLiveTracking;

  const DashboardQuickActions({
    super.key,
    this.onAddCustomer,
    this.onAddShipment,
    this.onAddDispatch,
    this.onAddTrip,
    this.onLiveTracking,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _actionButton(
                "Customer",
                Icons.person_add,
                Colors.blue,
                onAddCustomer,
              ),

              _actionButton(
                "Shipment",
                Icons.inventory,
                Colors.orange,
                onAddShipment,
              ),

              _actionButton(
                "Dispatch",
                Icons.local_shipping,
                Colors.green,
                onAddDispatch,
              ),

              _actionButton(
                "Trip",
                Icons.route,
                Colors.purple,
                onAddTrip,
              ),

              _actionButton(
                "Live Tracking",
                Icons.location_on,
                Colors.red,
                onLiveTracking,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      String title,
      IconData icon,
      Color color,
      VoidCallback? onTap,
      ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}