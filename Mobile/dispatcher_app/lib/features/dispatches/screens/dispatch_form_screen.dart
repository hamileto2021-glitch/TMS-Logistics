import 'package:flutter/material.dart';

import '../../../core/services/dispatch_service.dart';
import '../../../core/services/shipment_service.dart';
import '../../../core/services/vehicle_service.dart';
import '../../../core/services/driver_service.dart';

import '../../../models/shipment.dart';
import '../../../models/vehicle.dart';
import '../../../models/driver.dart';
import '../../../models/create_dispatch_request.dart';
import '../../../models/dispatch.dart';

class DispatchFormScreen extends StatefulWidget {
  final Dispatch? dispatch;

  const DispatchFormScreen({
    super.key,
    this.dispatch,
  });

  @override
  State<DispatchFormScreen> createState() =>
      _DispatchFormScreenState();
}

class _DispatchFormScreenState extends State<DispatchFormScreen> {

  final ShipmentService shipmentService = ShipmentService();
  final VehicleService vehicleService = VehicleService();
  final DriverService driverService = DriverService();
  final DispatchService dispatchService = DispatchService();

  final TextEditingController notesController =
  TextEditingController();

  List<Shipment> shipments = [];
  List<Vehicle> vehicles = [];
  List<Driver> drivers = [];

  Shipment? selectedShipment;
  Vehicle? selectedVehicle;
  Driver? selectedDriver;

  DateTime selectedDate = DateTime.now();

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {

      shipments = await shipmentService.getShipments();

      print("========== SHIPMENTS ==========");
      for (var s in shipments) {
        print("${s.shipmentNumber} -> ${s.status}");
      }
      print("===============================");

      vehicles = await vehicleService.getVehicles();

      drivers = await driverService.getDrivers();

      final availableShipments = shipments
          .where((e) => e.status.trim().toLowerCase() == "pending")
          .toList();

      print("Available shipments: ${availableShipments.length}");

      shipments = availableShipments;

      vehicles = vehicles
          .where((e) => e.status == "Available")
          .toList();

      drivers = drivers
          .where((e) => e.status == "Available")
          .toList();

    } finally {

      if (mounted) {
        setState(() {
          loading = false;
        });
      }

    }
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
        title: const Text("Create Dispatch"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Shipment",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<Shipment>(
              value: selectedShipment,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: shipments.map((shipment) {
                return DropdownMenuItem(
                  value: shipment,
                  child: Text(
                    "${shipment.shipmentNumber} | ${shipment.origin} → ${shipment.destination}",
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedShipment = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Vehicle",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<Vehicle>(
              value: selectedVehicle,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: vehicles.map((vehicle) {
                return DropdownMenuItem(
                  value: vehicle,
                  child: Text(vehicle.plateNumber),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVehicle = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Driver",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<Driver>(
              value: selectedDriver,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: drivers.map((driver) {
                return DropdownMenuItem(
                  value: driver,
                  child: Text(driver.fullName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDriver = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Dispatch Date",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            ListTile(
              tileColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2035),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saving
                    ? null
                    : () async {

                  if (selectedShipment == null ||
                      selectedVehicle == null ||
                      selectedDriver == null) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please select Shipment, Vehicle and Driver.",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );

                    return;
                  }

                  setState(() {
                    saving = true;
                  });

                  try {

                    final request = CreateDispatchRequest(
                      shipmentId: selectedShipment!.id,
                      vehicleId: selectedVehicle!.id,
                      driverId: selectedDriver!.id,
                      dispatchDate: selectedDate,
                      notes: notesController.text,
                    );

                    await dispatchService.createDispatch(request);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Dispatch created successfully.",
                        ),
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
                        saving = false;
                      });
                    }

                  }
                },
                child: const Text(
                  "CREATE DISPATCH",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}