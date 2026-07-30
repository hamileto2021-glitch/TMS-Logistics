import 'package:flutter/material.dart';

import '../../../core/services/dispatch_service.dart';
import '../../../core/services/trip_service.dart';

import '../../../models/dispatch.dart';
import '../../../models/create_trip_request.dart';
import '../../../models/trip.dart';
import '../../../models/update_trip_request.dart';


class TripFormScreen extends StatefulWidget {
  final Trip? trip;

  const TripFormScreen({
    super.key,
    this.trip,
  });

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
  bool get isEdit => widget.trip != null;

  DateTime plannedStartTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      plannedStartTime = widget.trip!.startTime ?? DateTime.now();
      remarksController.text = widget.trip!.remarks;
    }

    loadDispatches();
  }

  Future<void> loadDispatches() async {
    try {
      dispatches = await dispatchService.getDispatches();

      dispatches = dispatches
          .where((e) => e.status == "Scheduled")
          .toList();
      if (isEdit) {
        selectedDispatch = dispatches.firstWhere(
              (d) => d.id == widget.trip!.dispatchId,
        );
      }

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

      if (isEdit) {
        await tripService.updateTrip(
          widget.trip!.id,
          UpdateTripRequest(
            startTime: plannedStartTime,
            endTime: widget.trip!.endTime,
            distance: widget.trip!.distanceKm,
            fuel: widget.trip!.fuelUsed,
            odometer: widget.trip!.odometer,
            currentLocation: widget.trip!.currentLocation,
            delayReason: widget.trip!.delayReason,
            status: widget.trip!.status,
            remarks: remarksController.text,
          ),

        );
      } else {
        await tripService.createTrip(request);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? "Trip updated successfully"
                  : "Trip created successfully",
            ),
          )
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Trip" : "Create Trip",
        ),
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
              initialValue: selectedDispatch,
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
                      : (isEdit ? "Update Trip" : "Create Trip"),
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