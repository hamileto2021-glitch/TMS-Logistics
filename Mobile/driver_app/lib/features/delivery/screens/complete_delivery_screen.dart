import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../trips/models/active_trip.dart';
import '../models/complete_delivery_request.dart';
import '../services/delivery_service.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../../trips/models/driver_trip.dart';

class CompleteDeliveryScreen extends StatefulWidget {
  final DriverTrip trip;

  const CompleteDeliveryScreen({
    super.key,
    required this.trip,
  });

  @override
  State<CompleteDeliveryScreen> createState() => _CompleteDeliveryScreenState();
}

class _CompleteDeliveryScreenState extends State<CompleteDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _receiverController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
  );

  final DeliveryService _service = DeliveryService();

  final ImagePicker _picker = ImagePicker();

  File? _photo;

  bool _saving = false;

  @override
  void dispose() {
    _receiverController.dispose();
    _phoneController.dispose();
    _notesController.dispose();

    _signatureController.dispose();

    super.dispose();
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _photo = File(image.path);
    });
  }

  Future<void> _completeDelivery() async {
    if (!_formKey.currentState!.validate()) return;

    if (_photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please take a delivery photo."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Customer signature is required."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          "Location permission permanently denied. Please enable it in Settings.",
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final Uint8List? signatureBytes =
      await _signatureController.toPngBytes();

      if (signatureBytes == null) {
        throw Exception("Unable to capture customer signature.");
      }

      final tempDir = await getTemporaryDirectory();

      final signatureFile = File(
        "${tempDir.path}/signature_${widget.trip.id}.png",
      );

      await signatureFile.writeAsBytes(signatureBytes);

      final request = CompleteDeliveryRequest(
        receiverName: _receiverController.text.trim(),
        receiverPhone: _phoneController.text.trim(),
        notes: _notesController.text.trim(),
        latitude: position.latitude,
        longitude: position.longitude,
        photoPath: "",
        signaturePath: "",
      );

      print("================================");
      print("Trip ID sent: ${widget.trip.id}");
      print("Trip Number: ${widget.trip.tripNumber}");
      print("================================");

      final message = await _service.completeDelivery(
        widget.trip.id,
        request,
        _photo,
        signatureFile,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Delivery")),
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

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text(
                    "TAKE DELIVERY PHOTO",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              if (_photo != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _photo!,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),

              if (_photo != null)
                const SizedBox(height: 20),

              const SizedBox(height: 20),

              const Text(
                "Customer Signature",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    _signatureController.clear();
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Clear Signature"),
                ),
              ),

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

              const SizedBox(height: 30),

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
                    _saving ? "Submitting..." : "COMPLETE DELIVERY",
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
}
