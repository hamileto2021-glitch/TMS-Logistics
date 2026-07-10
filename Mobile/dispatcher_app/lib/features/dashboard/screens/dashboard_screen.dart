import 'package:flutter/material.dart';

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
import '../../tracking/screens/live_tracking_screen.dart';
import '../../../core/widgets/app_drawer.dart';

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

  @override
  void initState() {
    super.initState();
    _future = _service.getDashboard();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _service.getDashboard();
    });

    await _future;
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
child: Text(snapshot.error.toString()),
);
}

final dashboard = snapshot.data!;

return ListView(
          children: [

            const DashboardHeader(
              userName: "Mohammed",
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

            DashboardQuickActions(
              onAddCustomer: () {
                // TODO:
                // Navigate to CustomerFormScreen
              },

              onAddShipment: () {
                // TODO:
                // Navigate to ShipmentFormScreen
              },

              onAddDispatch: () {
                // TODO:
                // Navigate to DispatchFormScreen
              },

              onAddTrip: () {
                // TODO:
                // Navigate to TripFormScreen
              },

              onLiveTracking: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveTrackingScreen(),
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