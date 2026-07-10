import 'package:flutter/material.dart';

import '../../features/customers/screens/customer_list_screen.dart';
import '../../features/shipments/screens/shipment_list_screen.dart';
import '../../features/dispatches/screens/dispatch_list_screen.dart';
import '../../features/trips/screens/trip_list_screen.dart';
import '../../features/vehicles/screens/vehicle_list_screen.dart';
import '../../features/drivers/screens/driver_list_screen.dart';
import '../../features/tracking/screens/live_tracking_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _menu(
      BuildContext context,
      IconData icon,
      String title,
      Widget page,
      ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              "Mohammed",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text("Dispatcher"),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
          ),

          _menu(
            context,
            Icons.dashboard,
            "Dashboard",
            const DashboardScreen(),
          ),

          _menu(
            context,
            Icons.people,
            "Customers",
            const CustomerListScreen(),
          ),

          _menu(
            context,
            Icons.inventory,
            "Shipments",
            const ShipmentListScreen(),
          ),

          _menu(
            context,
            Icons.local_shipping,
            "Dispatches",
            const DispatchListScreen(),
          ),

          _menu(
            context,
            Icons.route,
            "Trips",
            const TripListScreen(),
          ),

          _menu(
            context,
            Icons.fire_truck,
            "Vehicles",
            const VehicleListScreen(),
          ),

          _menu(
            context,
            Icons.badge,
            "Drivers",
            const DriverListScreen(),
          ),

          _menu(
            context,
            Icons.location_on,
            "Live Tracking",
            const LiveTrackingScreen(),
          ),

          const Spacer(),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              // We'll connect logout later.
            },
          ),
        ],
      ),
    );
  }
}