import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/trip_replay_controller.dart';

class TripReplayScreen extends StatefulWidget {
  final int tripId;
  final String tripNumber;

  const TripReplayScreen({
    super.key,
    required this.tripId,
    required this.tripNumber,
  });

  @override
  State<TripReplayScreen> createState() =>
      _TripReplayScreenState();
}

class _TripReplayScreenState
    extends State<TripReplayScreen> {
  late final TripReplayController controller;

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    controller = TripReplayController();

    controller.addListener(_onControllerChanged);

    controller.loadReplay(widget.tripId);
  }

  Future<void> _onControllerChanged() async {
    if (!mounted) return;

    final position = controller.currentLatLng;

    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 16,
            bearing: controller.animatedHeading,
            tilt: 45,
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final point = controller.currentPoint;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trip Replay - ${widget.tripNumber}",
        ),
      ),
      body: controller.isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : point == null
          ? const Center(
        child: Text("No replay data available"),
      )
          : Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition:
              CameraPosition(
                target: LatLng(
                  point.latitude,
                  point.longitude,
                ),
                zoom: 15,
              ),
              markers: controller.markers,
              polylines: controller.polylines,
              onMapCreated: (map) {
                _mapController = map;
              },
            ),
          ),
          Container(
            padding:
            const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  point.recordedAt.toString(),
                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.replay,
                      ),
                      onPressed:
                      controller.restart,
                    ),
                    IconButton(
                      icon: Icon(
                        controller.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        if (controller
                            .isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Slider(
                  min: 0,
                  max: (controller.points.length - 1).toDouble(),
                  value: controller.currentIndex.toDouble(),
                  onChanged: (value) {
                    controller.seek(value.round());
                  },
                ),
                Text(
                  "${controller.currentIndex + 1} / ${controller.points.length} GPS Points",
                ),

                const SizedBox(height: 12),

                DropdownButton<double>(
                  value: controller.speed,
                  items: const [
                    DropdownMenuItem(
                      value: 1,
                      child: Text("1×"),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text("2×"),
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: Text("4×"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.changeSpeed(
                          value);
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}