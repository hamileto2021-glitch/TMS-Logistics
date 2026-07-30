import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../tracking/screens/trip_replay_screen.dart';
import '../controllers/fleet_command_controller.dart';
import '../widgets/fleet_search_bar.dart';
import '../widgets/fleet_status_filter.dart';
import '../widgets/fleet_summary_card.dart';
import '../widgets/vehicle_info_bottom_sheet.dart';
import 'live_map_screen.dart';
import '../widgets/fleet_alert_panel.dart';
import '../widgets/fleet_analytics_panel.dart';
import 'package:provider/provider.dart';
import '../../notifications/controllers/notification_controller.dart';

class FleetCommandCenter extends StatefulWidget {
  const FleetCommandCenter({super.key});

  @override
  State<FleetCommandCenter> createState() =>
      _FleetCommandCenterState();
}

class _FleetCommandCenterState extends State<FleetCommandCenter> {
  late final FleetCommandController controller;

  GoogleMapController? _mapController;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;

    controller = FleetCommandController(
      notificationController:
      context.read<NotificationController>(),
    );

    controller.initialize();

    _initialized = true;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    controller.dispose();
    super.dispose();
  }
  Future<void> _focusOnSelectedTrip() async {
    final trip = controller.selectedTrip;

    if (trip == null || _mapController == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          trip.latitude,
          trip.longitude,
        ),
        15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(

      animation: controller,

      builder: (context, _) {

        final summary = controller.summary;
        final analytics = controller.analytics;

        return Scaffold(

          appBar: AppBar(
            title: const Text("Fleet Command Center"),
          ),

          body: Column(

            children: [

              FleetSearchBar(
                onChanged: controller.search,
              ),

              FleetStatusFilter(
                selectedStatus: controller.selectedStatus,
                onSelected: controller.filter,
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.4,
                  children: [

                    FleetSummaryCard(
                      title: "Active Trips",
                      value: (analytics?.activeTrips ?? summary.activeTrips).toString(),
                      icon: Icons.local_shipping,
                      color: Colors.green,
                    ),

                    FleetSummaryCard(
                      title: "Delayed",
                      value: summary.delayedTrips.toString(),
                      icon: Icons.warning,
                      color: Colors.red,
                    ),

                    FleetSummaryCard(
                      title: "Completed",
                      value: summary.completedTrips.toString(),
                      icon: Icons.check_circle,
                      color: Colors.blue,
                    ),

                    FleetSummaryCard(
                      title: "Drivers",
                      value: (analytics?.availableDrivers ?? summary.activeDrivers).toString(),
                      icon: Icons.person,
                      color: Colors.orange,
                    ),

                  ],
                ),
              ),
              FleetAnalyticsPanel(
                analytics: controller.analytics,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: FleetAlertPanel(
                  alerts: controller.alerts,
                  onAlertTap: (alert) async {
                    controller.selectTripById(alert.tripId);
                    await _focusOnSelectedTrip();
                  },
                ),
              ),

              Expanded(

                child: GoogleMap(

                  initialCameraPosition:
                  const CameraPosition(
                    target: LatLng(
                      8.9806,
                      38.7578,
                    ),
                    zoom: 7,
                  ),

                  onMapCreated: (map) {
                    _mapController = map;
                  },

                  markers: controller.markers,

                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,

                  compassEnabled: true,

                  zoomControlsEnabled: true,

                ),

              ),

              VehicleInfoBottomSheet(

                trip: controller.selectedTrip,

                onOpenMap: controller.selectedTrip == null
                    ? null
                    : () {
                  final selectedTrip = controller.selectedTrip!;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TripReplayScreen(
                        tripId: selectedTrip.tripId,
                        tripNumber: selectedTrip.tripNumber,
                      ),
                    ),
                  );
                },

              ),

            ],

          ),

        );

      },

    );

  }

}