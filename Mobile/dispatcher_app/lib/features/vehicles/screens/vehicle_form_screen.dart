import 'package:flutter/material.dart';

import '../../../core/services/vehicle_service.dart';
import '../../../models/vehicle.dart';

class VehicleFormScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleFormScreen({super.key, this.vehicle});

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final VehicleService _service = VehicleService();

  final vehicleCodeController = TextEditingController();
  final plateNumberController = TextEditingController();
  final registrationController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();

  final yearController = TextEditingController();

  final vehicleTypeController = TextEditingController();

  final capacityWeightController = TextEditingController();

  final capacityVolumeController = TextEditingController();

  final fuelTypeController = TextEditingController();

  final odometerController = TextEditingController();

  final insuranceNumberController = TextEditingController();

  final roadLicenseController = TextEditingController();

  final notesController = TextEditingController();

  DateTime? insuranceExpiry;
  DateTime? roadLicenseExpiry;

  String status = "Available";

  bool saving = false;

  @override
  void initState() {
    super.initState();

    if (widget.vehicle != null) {
      final v = widget.vehicle!;

      vehicleCodeController.text = v.vehicleCode;
      plateNumberController.text = v.plateNumber;
      registrationController.text = v.registrationNumber;
      makeController.text = v.make;
      modelController.text = v.model;

      yearController.text = v.year.toString();

      vehicleTypeController.text = v.vehicleType;

      capacityWeightController.text = v.capacityWeight.toString();

      capacityVolumeController.text = v.capacityVolume.toString();

      fuelTypeController.text = v.fuelType;

      odometerController.text = v.odometer.toString();

      insuranceNumberController.text = v.insuranceNumber;

      roadLicenseController.text = v.roadLicenseNumber;

      notesController.text = v.notes;

      insuranceExpiry = v.insuranceExpiry;
      roadLicenseExpiry = v.roadLicenseExpiry;

      status = v.status;
    }
  }

  @override
  void dispose() {
    vehicleCodeController.dispose();
    plateNumberController.dispose();
    registrationController.dispose();
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    vehicleTypeController.dispose();
    capacityWeightController.dispose();
    capacityVolumeController.dispose();
    fuelTypeController.dispose();
    odometerController.dispose();
    insuranceNumberController.dispose();
    roadLicenseController.dispose();
    notesController.dispose();

    super.dispose();
  }

  Future<void> _pickInsuranceDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: insuranceExpiry ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        insuranceExpiry = picked;
      });
    }
  }

  Future<void> _pickRoadLicenseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: roadLicenseExpiry ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        roadLicenseExpiry = picked;
      });
    }
  }

  Widget textBox({
    required TextEditingController controller,
    required String label,
    TextInputType keyboard = TextInputType.text,
    bool requiredField = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator:
            validator ??
            (requiredField
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "$label is required";
                    }
                    return null;
                  }
                : null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? "Add Vehicle" : "Edit Vehicle"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              textBox(
                controller: vehicleCodeController,
                label: "Vehicle Code",
                requiredField: true,
              ),

              textBox(
                controller: plateNumberController,
                label: "Plate Number",
                requiredField: true,
              ),

              textBox(
                controller: registrationController,
                label: "Registration Number",
              ),

              textBox(controller: makeController, label: "Make"),

              textBox(controller: modelController, label: "Model"),

              textBox(
                controller: yearController,
                label: "Year",
                keyboard: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Year is required";
                  }

                  final year = int.tryParse(value);

                  if (year == null) {
                    return "Invalid year";
                  }

                  if (year < 1990 || year > DateTime.now().year + 1) {
                    return "Enter a valid year";
                  }

                  return null;
                },
              ),

              textBox(controller: vehicleTypeController, label: "Vehicle Type"),

              textBox(
                controller: capacityWeightController,
                label: "Capacity Weight (Kg)",
                keyboard: TextInputType.number,
              ),

              textBox(
                controller: capacityVolumeController,
                label: "Capacity Volume",
                keyboard: TextInputType.number,
              ),

              textBox(controller: fuelTypeController, label: "Fuel Type"),

              textBox(
                controller: odometerController,
                label: "Odometer",
                keyboard: TextInputType.number,
              ),

              textBox(
                controller: insuranceNumberController,
                label: "Insurance Number",
              ),

              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text(
                  insuranceExpiry == null
                      ? "Insurance Expiry"
                      : insuranceExpiry!.toString().substring(0, 10),
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _pickInsuranceDate,
              ),

              const Divider(),

              textBox(
                controller: roadLicenseController,
                label: "Road License Number",
              ),

              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text(
                  roadLicenseExpiry == null
                      ? "Road License Expiry"
                      : roadLicenseExpiry!.toString().substring(0, 10),
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _pickRoadLicenseDate,
              ),

              const Divider(),

              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Available",
                    child: Text("Available"),
                  ),
                  DropdownMenuItem(value: "Assigned", child: Text("Assigned")),
                  DropdownMenuItem(
                    value: "Maintenance",
                    child: Text("Maintenance"),
                  ),
                  DropdownMenuItem(value: "Inactive", child: Text("Inactive")),
                ],
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Notes",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: saving
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          setState(() {
                            saving = true;
                          });

                          try {
                            final vehicle = Vehicle(
                              id: widget.vehicle?.id ?? 0,
                              vehicleCode: vehicleCodeController.text.trim(),
                              plateNumber: plateNumberController.text.trim(),
                              registrationNumber: registrationController.text
                                  .trim(),
                              make: makeController.text.trim(),
                              model: modelController.text.trim(),
                              year:
                                  int.tryParse(yearController.text.trim()) ?? 0,
                              vehicleType: vehicleTypeController.text.trim(),
                              capacityWeight:
                                  double.tryParse(
                                    capacityWeightController.text.trim(),
                                  ) ??
                                  0,
                              capacityVolume:
                                  double.tryParse(
                                    capacityVolumeController.text.trim(),
                                  ) ??
                                  0,
                              fuelType: fuelTypeController.text.trim(),
                              odometer:
                                  int.tryParse(
                                    odometerController.text.trim(),
                                  ) ??
                                  0,
                              status: status,
                              insuranceNumber: insuranceNumberController.text
                                  .trim(),
                              insuranceExpiry: insuranceExpiry,
                              roadLicenseNumber: roadLicenseController.text
                                  .trim(),
                              roadLicenseExpiry: roadLicenseExpiry,
                              notes: notesController.text.trim(),
                            );

                            if (widget.vehicle == null) {
                              await _service.createVehicle(vehicle);
                            } else {
                              await _service.updateVehicle(vehicle);
                            }

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.vehicle == null
                                      ? "Vehicle created successfully."
                                      : "Vehicle updated successfully.",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pop(context, true);
                          } catch (e) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: $e"),
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
                    widget.vehicle == null ? "SAVE VEHICLE" : "UPDATE VEHICLE",
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
