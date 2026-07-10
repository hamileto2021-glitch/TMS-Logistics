import 'package:flutter/material.dart';

import '../../../core/services/customer_service.dart';
import '../../../core/services/driver_service.dart';
import '../../../core/services/shipment_service.dart';
import '../../../core/services/vehicle_service.dart';

import '../../../models/customer.dart';
import '../../../models/driver.dart';
import '../../../models/shipment.dart';
import '../../../models/vehicle.dart';

class ShipmentFormScreen extends StatefulWidget {
  final Shipment? shipment;

  const ShipmentFormScreen({super.key, this.shipment});

  @override
  State<ShipmentFormScreen> createState() => _ShipmentFormScreenState();
}

class _ShipmentFormScreenState extends State<ShipmentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final ShipmentService _shipmentService = ShipmentService();

  final CustomerService _customerService = CustomerService();

  final VehicleService _vehicleService = VehicleService();

  final DriverService _driverService = DriverService();

  List<Customer> customers = [];
  List<Vehicle> vehicles = [];
  List<Driver> drivers = [];

  Customer? selectedCustomer;
  Vehicle? selectedVehicle;
  Driver? selectedDriver;

  final originController = TextEditingController();

  final destinationController = TextEditingController();

  final cargoController = TextEditingController();

  final weightController = TextEditingController();

  final volumeController = TextEditingController();

  final packagesController = TextEditingController();

  final notesController = TextEditingController();

  DateTime bookingDate = DateTime.now();

  DateTime? expectedDeliveryDate;

  String status = "Pending";

  bool loading = true;

  bool saving = false;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    customers = await _customerService.getCustomers();

    vehicles = await _vehicleService.getVehicles();

    drivers = await _driverService.getDrivers();

    if (widget.shipment != null) {
      final s = widget.shipment!;

      originController.text = s.origin;

      destinationController.text = s.destination;

      cargoController.text = s.cargoType;

      weightController.text = s.weight.toString();

      volumeController.text = s.volume.toString();

      packagesController.text = s.numberOfPackages.toString();

      notesController.text = s.notes;

      bookingDate = s.bookingDate;

      expectedDeliveryDate = s.expectedDeliveryDate;

      status = s.status;

      selectedCustomer = customers.cast<Customer?>().firstWhere(
        (c) => c?.id == s.customerId,
        orElse: () => null,
      );

      selectedVehicle = vehicles.cast<Vehicle?>().firstWhere(
        (v) => v?.id == s.vehicleId,
        orElse: () => null,
      );

      selectedDriver = drivers.cast<Driver?>().firstWhere(
        (d) => d?.id == s.driverId,
        orElse: () => null,
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    cargoController.dispose();
    weightController.dispose();
    volumeController.dispose();
    packagesController.dispose();
    notesController.dispose();

    super.dispose();
  }

  Widget textBox({
    required TextEditingController controller,
    required String label,
    TextInputType keyboard = TextInputType.text,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: requiredField
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return "$label is required";
                }
                return null;
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shipment == null ? "New Shipment" : "Edit Shipment"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              DropdownButtonFormField<Customer>(
                initialValue: selectedCustomer,
                decoration: const InputDecoration(
                  labelText: "Customer",
                  border: OutlineInputBorder(),
                ),
                items: customers.map((customer) {
                  return DropdownMenuItem(
                    value: customer,
                    child: Text(customer.companyName),
                  );
                }).toList(),
                validator: (value) => value == null ? "Select customer" : null,
                onChanged: (value) {
                  setState(() {
                    selectedCustomer = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<Vehicle>(
                initialValue: selectedVehicle,
                decoration: const InputDecoration(
                  labelText: "Vehicle",
                  border: OutlineInputBorder(),
                ),
                items: vehicles.map((vehicle) {
                  return DropdownMenuItem(
                    value: vehicle,
                    child: Text("${vehicle.plateNumber} - ${vehicle.make}"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<Driver>(
                initialValue: selectedDriver,
                decoration: const InputDecoration(
                  labelText: "Driver",
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

              textBox(
                controller: originController,
                label: "Origin",
                requiredField: true,
              ),

              textBox(
                controller: destinationController,
                label: "Destination",
                requiredField: true,
              ),

              textBox(
                controller: cargoController,
                label: "Cargo Type",
                requiredField: true,
              ),

              textBox(
                controller: weightController,
                label: "Weight (Kg)",
                keyboard: TextInputType.number,
                requiredField: true,
              ),

              textBox(
                controller: volumeController,
                label: "Volume (m³)",
                keyboard: TextInputType.number,
              ),

              textBox(
                controller: packagesController,
                label: "Packages",
                keyboard: TextInputType.number,
              ),
              textBox(
                controller: packagesController,
                label: "Packages",
                keyboard: TextInputType.number,
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  "Booking Date: "
                  "${bookingDate.toString().substring(0, 10)}",
                ),
              ),

              const SizedBox(height: 10),

              ListTile(
                leading: const Icon(Icons.event),
                title: Text(
                  expectedDeliveryDate == null
                      ? "Expected Delivery"
                      : expectedDeliveryDate!.toString().substring(0, 10),
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: expectedDeliveryDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (picked != null) {
                    setState(() {
                      expectedDeliveryDate = picked;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Pending", child: Text("Pending")),

                  DropdownMenuItem(
                    value: "Dispatched",
                    child: Text("Dispatched"),
                  ),

                  DropdownMenuItem(
                    value: "In Transit",
                    child: Text("In Transit"),
                  ),

                  DropdownMenuItem(
                    value: "Delivered",
                    child: Text("Delivered"),
                  ),

                  DropdownMenuItem(
                    value: "Cancelled",
                    child: Text("Cancelled"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
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
                height: 55,
                child: ElevatedButton.icon(
                  icon: saving
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
                    widget.shipment == null
                        ? "SAVE SHIPMENT"
                        : "UPDATE SHIPMENT",
                  ),
                  onPressed: saving
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          if (selectedCustomer == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a customer."),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            saving = true;
                          });

                          try {
                            final shipment = Shipment(
                              id: widget.shipment?.id ?? 0,
                              shipmentNumber:
                                  widget.shipment?.shipmentNumber ?? "",
                              customerId: selectedCustomer!.id,
                              vehicleId: selectedVehicle?.id,
                              driverId: selectedDriver?.id,
                              origin: originController.text.trim(),
                              destination: destinationController.text.trim(),
                              cargoType: cargoController.text.trim(),
                              weight:
                                  double.tryParse(
                                    weightController.text.trim(),
                                  ) ??
                                  0,
                              volume:
                                  double.tryParse(
                                    volumeController.text.trim(),
                                  ) ??
                                  0,
                              numberOfPackages:
                                  int.tryParse(
                                    packagesController.text.trim(),
                                  ) ??
                                  0,
                              bookingDate: bookingDate,
                              dispatchDate: widget.shipment?.dispatchDate,
                              expectedDeliveryDate: expectedDeliveryDate,
                              status: status,
                              notes: notesController.text.trim(),
                            );

                            if (widget.shipment == null) {
                              await _shipmentService.createShipment(shipment);
                            } else {
                              await _shipmentService.updateShipment(shipment);
                            }

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  widget.shipment == null
                                      ? "Shipment created successfully."
                                      : "Shipment updated successfully.",
                                ),
                              ),
                            );

                            Navigator.pop(context, true);
                          } catch (e) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
