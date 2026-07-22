import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trip_provider.dart';
import '../widgets/action_buttons.dart';
import '../widgets/route_card.dart';
import '../widgets/trip_header.dart';
import '../widgets/trip_info_card.dart';
import '../widgets/vehicle_card.dart';
import '../../tracking/widgets/live_map.dart';
import '../../tracking/providers/tracking_provider.dart';
import '../../delivery/screens/complete_delivery_screen.dart';
import '../models/driver_trip.dart';

class ActiveTripScreen extends StatefulWidget {
  const ActiveTripScreen({super.key});

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<TripProvider>().loadActiveTrip();

      await context.read<TrackingProvider>().initializeSignalR();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Trip"),
      ),

      body: Consumer<TripProvider>(
        builder: (context, provider, child) {

          if (provider.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final trip = provider.activeTrip;

          if (trip == null) {
            return const Center(
              child: Text(
                "No Active Trip Assigned",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              TripHeader(
                trip: trip,
              ),
              if (trip.latitude != null && trip.longitude != null) ...[
                LiveMap(
                  latitude: trip.latitude!,
                  longitude: trip.longitude!,
                ),

                const SizedBox(height: 16),
              ],

              const SizedBox(height: 16),

              TripInfoCard(
                icon: Icons.business,
                title: "Customer",
                value: trip.customerName,
              ),

              TripInfoCard(
                icon: Icons.inventory_2,
                title: "Shipment",
                value: trip.shipmentNumber,
              ),

              const SizedBox(height: 10),

              RouteCard(
                origin: trip.origin,
                destination: trip.destination,
              ),

              const SizedBox(height: 10),

              VehicleCard(
                vehicle: trip.vehicleCode,
                plate: trip.plateNumber,
                driver: trip.driverName,
              ),

              const SizedBox(height: 24),

              ActionButtons(
                status: trip.status,

                onStart: () async {
                  await provider.startTrip();
                },

                onPause: () async {
                  await provider.pauseTrip(
                    "Paused by Driver",
                  );
                },

                onResume: () async {
                  await provider.resumeTrip();
                },

                onCompleteDelivery: () async {

                  final driverTrip = DriverTrip(
                    id: trip.tripId,
                    tripNumber: trip.tripNumber,
                    shipmentNumber: trip.shipmentNumber,
                    origin: trip.origin,
                    destination: trip.destination,
                    status: trip.status,
                    vehicle: trip.plateNumber,
                    driver: trip.driverName,
                    startTime: trip.startTime,
                    endTime: null,
                  );

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompleteDeliveryScreen(
                        trip: driverTrip,
                      ),
                    ),
                  );

                  if (result == true) {
                    await provider.loadActiveTrip();
                  }
                },
              ),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}