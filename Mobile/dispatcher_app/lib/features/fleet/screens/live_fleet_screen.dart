import 'dart:async';

import 'package:flutter/material.dart';

import '../models/live_trip.dart';
import '../services/fleet_service.dart';

class LiveFleetScreen extends StatefulWidget {
  const LiveFleetScreen({super.key});

  @override
  State<LiveFleetScreen> createState() => _LiveFleetScreenState();
}

class _LiveFleetScreenState extends State<LiveFleetScreen> {

  final FleetService _service = FleetService();

  List<LiveTrip> trips = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _loadFleet();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
          (_) => _loadFleet(),
    );
  }

  Future<void> _loadFleet() async {

    try{

      final data = await _service.getLiveTrips();

      if(mounted){
        setState(() {
          trips = data;
        });
      }

    }catch(e){

      debugPrint(e.toString());

    }

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color statusColor(String status){

    switch(status){

      case "Started":
        return Colors.green;

      case "Scheduled":
        return Colors.orange;

      case "Completed":
        return Colors.blue;

      default:
        return Colors.grey;

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Live Fleet"),
      ),

      body: trips.isEmpty
          ? const Center(
        child: Text("No active trips."),
      )
          : ListView.builder(

        itemCount: trips.length,

        itemBuilder: (context,index){

          final trip = trips[index];

          return Card(

            margin: const EdgeInsets.all(10),

            elevation: 5,

            child: Padding(

              padding: const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    trip.tripNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height:10),

                  Text("👤 Driver : ${trip.driverName}"),

                  Text("🚚 Vehicle : ${trip.vehiclePlate}"),

                  Text("📍 Origin : ${trip.origin}"),

                  Text("🏁 Destination : ${trip.destination}"),

                  Text("⚡ Speed : ${trip.speed.toStringAsFixed(0)} km/h"),

                  const SizedBox(height:10),

                  Chip(
                    label: Text(trip.status),
                    backgroundColor: statusColor(trip.status),
                  ),

                  const SizedBox(height:15),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton.icon(

                      onPressed: (){

                        // Next Sprint
                        // Open Google Map

                      },

                      icon: const Icon(Icons.map),

                      label: const Text("VIEW LIVE MAP"),

                    ),

                  )

                ],

              ),

            ),

          );

        },

      ),

    );

  }

}