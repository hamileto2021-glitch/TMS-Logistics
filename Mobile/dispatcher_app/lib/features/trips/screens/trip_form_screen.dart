import 'package:flutter/material.dart';

import '../../../core/services/dispatch_service.dart';
import '../../../core/services/trip_service.dart';

import '../../../models/dispatch.dart';
import '../../../models/create_trip_request.dart';

class TripFormScreen extends StatefulWidget {
  const TripFormScreen({super.key});

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final DispatchService dispatchService = DispatchService();
  final TripService tripService = TripService();

  final TextEditingController remarksController =
  TextEditingController();

  List<Dispatch> dispatches = [];

  Dispatch? selectedDispatch;

  bool loading = true;
  bool isSaving = false;

  DateTime plannedStartTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadDispatches();
  }

  Future<void> loadDispatches() async {
    try {
      dispatches = await dispatchService.getDispatches();

      dispatches = dispatches
          .where((e) => e.status == "Scheduled")
          .toList();
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: plannedStartTime,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        plannedStartTime = date;
      });
    }
  }

  Future<void> saveTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      final request = CreateTripRequest(
        dispatchId: selectedDispatch!.id,
        plannedStartTime: plannedStartTime,
        remarks: remarksController.text,
      );

      await tripService.createTrip(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Trip created successfully"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Trip"),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<Dispatch>(
              value: selectedDispatch,
              decoration: const InputDecoration(
                labelText: "Dispatch",
                border: OutlineInputBorder(),
              ),
              items: dispatches.map((dispatch) {
                return DropdownMenuItem(
                  value: dispatch,
                  child: Text(
                    "${dispatch.dispatchNumber} | "
                        "${dispatch.shipmentNumber}",
                  ),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return "Please select a dispatch";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  selectedDispatch = value;
                });
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
              leading: const Icon(Icons.calendar_today),
              title: const Text("Planned Start Date"),
              subtitle: Text(
                "${plannedStartTime.day}/${plannedStartTime.month}/${plannedStartTime.year}",
              ),
              onTap: pickDate,
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

            const SizedBox(height: 24),

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
                  isSaving
                      ? "Saving..."
                      : "Create Trip",
                ),
                onPressed:
                isSaving ? null : saveTrip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}