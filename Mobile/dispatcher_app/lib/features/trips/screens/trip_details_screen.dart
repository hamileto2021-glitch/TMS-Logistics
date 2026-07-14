import 'package:flutter/material.dart';

import '../models/trip.dart';
import '../../../services/trip_service.dart';

import '../widgets/trip_status_chip.dart';
import '../widgets/trip_header_card.dart';
import '../widgets/trip_section_card.dart';
import '../widgets/trip_detail_row.dart';
import '../widgets/trip_metrics_card.dart';
import '../widgets/trip_timeline_card.dart';
import '../../delivery/screens/delivery_details_screen.dart';

class TripDetailsScreen extends StatefulWidget {
  final int tripId;

  const TripDetailsScreen({
    super.key,
    required this.tripId,
  });

  @override
  State<TripDetailsScreen> createState() =>
      _TripDetailsScreenState();
}

class _TripDetailsScreenState
    extends State<TripDetailsScreen> {

  final TripService _service = TripService();

  late Future<Trip> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getTrip(widget.tripId);
  }

  Future<void> _reload() async {
    setState(() {
      _future = _service.getTrip(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Trip Details"),
      ),

      body: FutureBuilder<Trip>(
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

          if (!snapshot.hasData) {
            return const Center(
              child: Text("Trip not found."),
            );
          }

          final trip = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Center(
                  child: TripStatusChip(
                    status: trip.status,
                  ),
                ),

                const SizedBox(height: 20),

                TripHeaderCard(trip: trip),

                const SizedBox(height: 16),

                TripSectionCard(
                  title: "Shipment & Dispatch",
                  icon: Icons.inventory_2,
                  child: Column(
                    children: [
                      TripDetailRow(
                        label: "Shipment",
                        value: trip.shipmentNumber,
                        icon: Icons.inventory,
                      ),
                      TripDetailRow(
                        label: "Dispatch",
                        value: trip.dispatchNumber,
                        icon: Icons.local_shipping,
                      ),
                    ],
                  ),
                ),

                TripSectionCard(
                  title: "Vehicle & Driver",
                  icon: Icons.local_shipping,
                  child: Column(
                    children: [
                      TripDetailRow(
                        label: "Vehicle",
                        value: trip.vehiclePlateNumber,
                        icon: Icons.local_shipping,
                      ),
                      TripDetailRow(
                        label: "Driver",
                        value: trip.driverName,
                        icon: Icons.person,
                      ),
                    ],
                  ),
                ),

                TripSectionCard(
                  title: "Current Location",
                  icon: Icons.location_on,
                  child: TripDetailRow(
                    label: "Location",
                    value: trip.currentLocation,
                    icon: Icons.place,
                  ),
                ),

                TripMetricsCard(trip: trip),

                TripTimelineCard(trip: trip),

                if (trip.delayReason.isNotEmpty)
                  TripSectionCard(
                    title: "Delay",
                    icon: Icons.warning,
                    child: Text(
                      trip.delayReason,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                if (trip.remarks.isNotEmpty)
                  TripSectionCard(
                    title: "Remarks",
                    icon: Icons.notes,
                    child: Text(trip.remarks),
                  ),

                const SizedBox(height: 20),

                Row(
                  children: [

                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Start"),
                        onPressed: () async {

                          await _service.startTrip(
                            trip.id,
                          );

                          await _reload();
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text("Complete"),
                        onPressed: () async {

                          await _service.completeTrip(
                            trip.id,
                          );

                          await _reload();
                        },
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),

                    icon: const Icon(Icons.delete),

                    label: const Text("Delete"),

                    onPressed: () async {

                      final confirm =
                      await showDialog<bool>(
                        context: context,
                        builder: (context) {

                          return AlertDialog(
                            title: const Text(
                                "Delete Trip"),
                            content: const Text(
                                "Delete this trip?"),
                            actions: [

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context, false);
                                },
                                child:
                                const Text("No"),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context, true);
                                },
                                child:
                                const Text("Yes"),
                              ),

                            ],
                          );
                        },
                      );

                      if (confirm == true) {

                        await _service.deleteTrip(
                          trip.id,
                        );

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.verified),
                    label: const Text(
                      "VIEW PROOF OF DELIVERY",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DeliveryDetailsScreen(
                            tripId: trip.id,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }

  Widget _item(
      String title,
      String value,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        title: Text(title),
        subtitle: Text(
          value.isEmpty ? "-" : value,
        ),
      ),
    );
  }
}