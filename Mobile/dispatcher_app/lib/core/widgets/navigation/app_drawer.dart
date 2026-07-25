import 'package:flutter/material.dart';

import '../../../features/auth/login_screen.dart';
import '../../../features/dashboard/screens/dashboard_screen.dart';
import '../../../features/customers/screens/customer_list_screen.dart';
import '../../../features/shipments/screens/shipment_list_screen.dart';
import '../../../features/dispatches/screens/dispatch_list_screen.dart';
import '../../../features/trips/screens/trip_list_screen.dart';
import '../../../features/vehicles/screens/vehicle_list_screen.dart';
import '../../../features/drivers/screens/driver_list_screen.dart';
import '../../../features/fleet/screens/live_fleet_screen.dart';
import '../../../features/reports/screens/reports_screen.dart';
import '../../../features/notifications/screens/notifications_screen.dart';
import '../../../features/settings/screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              accountName: const Text(
                "Mohammed",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: const Text("Dispatcher"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 40,
                ),
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
              "Live Fleet",
              const LiveFleetScreen(),
            ),

            _menu(
              context,
              Icons.bar_chart,
              "Reports & Analytics",
              const ReportsScreen(),
            ),

            _menu(
              context,
              Icons.notifications,
              "Notifications",
              const NotificationsScreen(),
            ),

            const Divider(),

            _menu(
              context,
              Icons.settings,
              "Settings",
              const SettingsScreen(),
            ),

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menu(
      BuildContext context,
      IconData icon,
      String title,
      Widget screen,
      ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },
    );
  }
}