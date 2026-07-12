import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../trips/models/driver_trip.dart';
import '../models/complete_delivery_request.dart';
import '../services/delivery_service.dart';

class CompleteDeliveryScreen extends StatefulWidget {
  final DriverTrip trip;

  const CompleteDeliveryScreen({
    super.key,
    required this.trip,
  });

  @override
  State<CompleteDeliveryScreen> createState() =>
      _CompleteDeliveryScreenState();
}

class _CompleteDeliveryScreenState extends State<CompleteDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _receiverController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  final DeliveryService _service = DeliveryService();

  bool _saving = false;

  @override
  void dispose() {
    _receiverController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _completeDelivery() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
    });

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final request = CompleteDeliveryRequest(
        receiverName: _receiverController.text.trim(),
        receiverPhone: _phoneController.text.trim(),
        notes: _notesController.text.trim(),
        latitude: position.latitude,
        longitude: position.longitude,
        photoPath: "",
        signaturePath: "",
      );

      final message = await _service.completeDelivery(
        widget.trip.id,
        request,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Delivery"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _infoRow("Trip", widget.trip.tripNumber),
                      _infoRow("Shipment", widget.trip.shipmentNumber),
                      _infoRow("Origin", widget.trip.origin),
                      _infoRow("Destination", widget.trip.destination),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _receiverController,
                decoration: const InputDecoration(
                  labelText: "Receiver Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Receiver name is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Receiver Phone",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Delivery Notes",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _completeDelivery,
                  icon: _saving
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.check_circle),
                  label: Text(
                    _saving
                        ? "Submitting..."
                        : "COMPLETE DELIVERY",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}