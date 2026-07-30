import 'package:flutter/material.dart';
import 'dart:async';

import '../../../core/services/session_manager.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_statistics.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_fleet_status.dart';
import '../widgets/dashboard_recent_activity.dart';

// Import your screens
import '../../customers/screens/customer_list_screen.dart';
import '../../shipments/screens/shipment_list_screen.dart';
import '../../dispatches/screens/dispatch_list_screen.dart';
import '../../trips/screens/trip_list_screen.dart';
import '../../vehicles/screens/vehicle_list_screen.dart';
import '../../drivers/screens/driver_list_screen.dart';
import '../models/dashboard.dart';
import '../services/dashboard_service.dart';
import '../../fleet/screens/live_fleet_screen.dart';

import '../../../core/widgets/navigation/app_drawer.dart';
import '../widgets/dashboard_live_map.dart';
import '../../customers/screens/customer_form_screen.dart';
import '../../shipments/screens/shipment_form_screen.dart';
import '../../dispatches/screens/dispatch_form_screen.dart';
import '../../trips/screens/trip_form_screen.dart';
import '../../../models/current_user.dart';
import '../../../core/storage/user_storage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  final DashboardService _service =
  DashboardService();

  late Future<Dashboard> _future;

  Timer? _refreshTimer;

  CurrentUser? currentUser;

  @override
  void initState() {
    super.initState();

    _future = _service.getDashboard();

    _loadCurrentUser();

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 1),
          (_) {
        if (mounted) {
          _refresh();
        }
      },
    );
  }
  Future<void> _loadCurrentUser() async {
    final user = await UserStorage().get();

    if (!mounted) return;

    setState(() {
      currentUser = user;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.getDashboard();
    });

    await _future;
  }
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _refresh,

child: FutureBuilder<Dashboard>(
future: _future,
builder: (context, snapshot) {

if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.cloud_off,
          size: 70,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        const Text(
          "Unable to load dashboard",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          snapshot.error.toString(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _refresh,
          child: const Text("Retry"),
        ),
      ],
    ),
  );
}


final dashboard = snapshot.data!;

return ListView(
          children: [

            Builder(
              builder: (context) => DashboardHeader(
                userName: SessionManager.instance.currentUser?.fullName ?? "Dispatcher",
                onMenuPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),

            DashboardStatistics(

customers: dashboard.customers,
shipments: dashboard.shipments,
dispatches: dashboard.dispatches,
trips: dashboard.trips,
vehicles: dashboard.vehicles,
drivers: dashboard.drivers,


              onCustomersTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomerListScreen(),
                  ),
                );
              },

              onShipmentsTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ShipmentListScreen(),
                  ),
                );
              },

              onDispatchesTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DispatchListScreen(),
                  ),
                );
              },

              onTripsTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TripListScreen(),
                  ),
                );
              },

              onVehiclesTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VehicleListScreen(),
                  ),
                );
              },

              onDriversTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DriverListScreen(),
                  ),
                );
              },
            ),
            const DashboardLiveMap(),

            DashboardQuickActions(
              onAddCustomer: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomerFormScreen(),
                  ),
                );
              },

              onAddShipment: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ShipmentFormScreen(),
                  ),
                );
              },

              onAddDispatch: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DispatchFormScreen(),
                  ),
                );
              },

              onAddTrip: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TripFormScreen(),
                  ),
                );
              },

              onLiveTracking: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveFleetScreen(),
                  ),
                );
              },
            ),

DashboardFleetStatus(
availableVehicles: dashboard.availableVehicles,
busyVehicles: dashboard.busyVehicles,
availableDrivers: dashboard.availableDrivers,
activeTrips: dashboard.activeTrips,
),

            DashboardRecentActivity(
              activities: const [

                ActivityItem(
                  icon: Icons.local_shipping,
                  title: "TRP-00021 Started",
                  subtitle: "2 minutes ago",
                  color: Colors.green,
                ),

                ActivityItem(
                  icon: Icons.inventory,
                  title: "Shipment Delivered",
                  subtitle: "15 minutes ago",
                  color: Colors.blue,
                ),

                ActivityItem(
                  icon: Icons.person,
                  title: "Driver Assigned",
                  subtitle: "35 minutes ago",
                  color: Colors.orange,
                ),

              ],
            ),

            const SizedBox(height: 30),
          ],
);
},
),
      ),
    );
  }
}