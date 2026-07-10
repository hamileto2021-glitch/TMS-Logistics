import 'package:flutter/material.dart';

import '../../../features/auth/login_screen.dart';
import '../../../features/customers/screens/customer_list_screen.dart';
import '../../../features/shipments/screens/shipment_list_screen.dart';
import '../../../features/dispatches/screens/dispatch_list_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            accountName: const Text(
              "Mohammed",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text("Dispatcher"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text("Dispatches"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DispatchListScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Customers"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CustomerListScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text("Shipments"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ShipmentListScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Drivers"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Driver module coming next")),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text("Dispatches"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DispatchListScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.route),
            title: const Text("Trips"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Trip module coming next")),
              );
            },
          ),

          const Spacer(),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
