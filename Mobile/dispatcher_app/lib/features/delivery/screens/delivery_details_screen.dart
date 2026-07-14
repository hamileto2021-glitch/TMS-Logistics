import 'package:flutter/material.dart';

import '../models/delivery_details.dart';
import '../services/delivery_service.dart';
import '../../../core/constants/api_constants.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final int tripId;

  const DeliveryDetailsScreen({
    super.key,
    required this.tripId,
  });

  @override
  State<DeliveryDetailsScreen> createState() =>
      _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState
    extends State<DeliveryDetailsScreen> {
  final DeliveryService _service = DeliveryService();

  DeliveryDetails? delivery;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    delivery = await _service.getDelivery(widget.tripId);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Proof of Delivery"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Text(
            delivery!.shipmentNumber,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text("Trip : ${delivery!.tripNumber}"),

          Text("Driver : ${delivery!.driverName}"),

          Text("Vehicle : ${delivery!.vehiclePlate}"),

          const SizedBox(height: 20),

          Text(
            "Receiver",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(delivery!.receiverName),

          Text(delivery!.receiverPhone),

          const SizedBox(height: 20),

          const SizedBox(height: 20),

          const Text(
            "Delivery Photo",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          if (delivery!.photoPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "${ApiConstants.baseUrl.replaceFirst('/api', '')}/${delivery!.photoPath!}",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Text("Unable to load photo.");
                },
              ),
            ),

          const SizedBox(height: 20),

          Text(delivery!.notes),

        ],
      ),
    );
  }
}