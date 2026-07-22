import 'package:flutter/material.dart';

import '../models/driver_dashboard.dart';
import '../services/driver_dashboard_service.dart';
import '../../trips/screens/active_trip_screen.dart';
import '../../trips/screens/trip_history_screen.dart';
import '../../trips/trip_list_screen.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() =>
      _DriverDashboardScreenState();
}

class _DriverDashboardScreenState
    extends State<DriverDashboardScreen> {

  final DriverDashboardService _service =
  DriverDashboardService();

  late Future<DriverDashboard> _dashboard;

  @override
  void initState() {
    super.initState();
    _dashboard = _service.loadDashboard();
  }

  Future<void> _refresh() async {
    setState(() {
      _dashboard = _service.loadDashboard();
    });

    await _dashboard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Dashboard"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<DriverDashboard>(
          future: _dashboard,
          builder: (context, snapshot) {

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }

            final dashboard = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [

                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [

                        const CircleAvatar(
                          radius: 32,
                          child: Icon(
                            Icons.person,
                            size: 32,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(
                                dashboard.driverName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              Text(
                                  "Vehicle: ${dashboard.vehicleCode}"),

                              Text(
                                  "Plate: ${dashboard.plateNumber}"),

                              const SizedBox(height: 8),

                              Chip(
                                label: Text(
                                  dashboard.driverStatus,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Current Trip",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                dashboard.activeTrip == null
                    ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: const [

                        Icon(
                          Icons.local_shipping_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 10),

                        Text(
                          "No Active Trip",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : Card(
                  elevation: 3,
                  child: Padding(
                    padding:
                    const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          dashboard.activeTrip!
                              .shipmentNumber,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                            "Origin: ${dashboard.activeTrip!.origin}"),

                        Text(
                            "Destination: ${dashboard.activeTrip!.destination}"),

                        Text(
                            "Status: ${dashboard.activeTrip!.status}"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                GridView.count(
                  physics:
                  const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [

                    _actionCard(
                      Icons.play_circle_fill,
                      "Active Trip",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ActiveTripScreen(),
                          ),
                        );
                      },
                    ),
                    _actionCard(
                      Icons.list_alt,
                      "My Trips",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TripListScreen(),
                          ),
                        );
                      },
                    ),

                    _actionCard(
                      Icons.map,
                      "Navigation",
                          () {},
                    ),

                    _actionCard(
                      Icons.camera_alt,
                      "Proof of Delivery",
                          () {},
                    ),

                    _actionCard(
                      Icons.history,
                      "Trip History",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TripHistoryScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _actionCard(
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [

              Icon(
                icon,
                size: 42,
              ),

              const SizedBox(height: 12),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}