import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';

class TripTimelineCard extends StatelessWidget {

  final Trip trip;

  const TripTimelineCard({
    super.key,
    required this.trip,
  });

  String format(DateTime? date){

    if(date==null) return "-";

    return DateFormat("dd MMM yyyy  HH:mm")
        .format(date);

  }

  @override
  Widget build(BuildContext context){

    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              "Timeline",
              style: TextStyle(
                fontSize:18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text("Created"),
              subtitle: Text(
                format(trip.createdAt),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text("Started"),
              subtitle: Text(
                format(trip.startTime),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Completed"),
              subtitle: Text(
                format(trip.endTime),
              ),
            ),

          ],
        ),
      ),
    );
  }
}