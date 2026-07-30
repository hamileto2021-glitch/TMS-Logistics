import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final String status;
  final VoidCallback? onStart;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onCompleteDelivery;

  const ActionButtons({
    super.key,
    required this.status,
    this.onStart,
    this.onPause,
    this.onResume,
    this.onCompleteDelivery,
  });

  @override
  Widget build(BuildContext context) {
    switch (status.toLowerCase()) {
      case "assigned":
      case "scheduled":
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text("START TRIP"),
            onPressed: onStart,
          ),
        );

      case "started":
      case "in progress":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.pause),
                label: const Text("PAUSE TRIP"),
                onPressed: onPause,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text("COMPLETE DELIVERY"),
                onPressed: onCompleteDelivery,
              ),
            ),
          ],
        );

      case "paused":
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.play_circle_fill),
            label: const Text("RESUME TRIP"),
            onPressed: onResume,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}