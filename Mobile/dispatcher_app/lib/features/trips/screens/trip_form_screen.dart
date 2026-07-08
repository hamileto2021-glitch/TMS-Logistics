import 'package:flutter/material.dart';

class TripFormScreen extends StatefulWidget {
  const TripFormScreen({super.key});

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController shipmentController =
  TextEditingController();

  final TextEditingController vehicleController =
  TextEditingController();

  final TextEditingController driverController =
  TextEditingController();

  final TextEditingController remarksController =
  TextEditingController();

  bool isSaving = false;

  Future<void> saveTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    // TODO:
    // Call TripService.createTrip()

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Trip created successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Trip"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            TextFormField(
              controller: shipmentController,
              decoration: const InputDecoration(
                labelText: "Shipment ID",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Shipment is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: vehicleController,
              decoration: const InputDecoration(
                labelText: "Vehicle ID",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vehicle is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: driverController,
              decoration: const InputDecoration(
                labelText: "Driver ID",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Driver is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: remarksController,
              decoration: const InputDecoration(
                labelText: "Remarks",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                icon: isSaving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.save),
                label: Text(
                  isSaving ? "Saving..." : "Create Trip",
                ),
                onPressed: isSaving ? null : saveTrip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}