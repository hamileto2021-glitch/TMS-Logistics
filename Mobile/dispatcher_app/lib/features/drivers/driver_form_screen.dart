import 'package:flutter/material.dart';

import '../../core/services/driver_service.dart';
import '../../core/services/vehicle_service.dart';

import '../../models/driver.dart';
import '../../models/vehicle.dart';

class DriverFormScreen extends StatefulWidget {
  final Driver? driver;

  const DriverFormScreen({
    super.key,
    this.driver,
  });

  @override
  State<DriverFormScreen> createState() =>
      _DriverFormScreenState();
}

class _DriverFormScreenState
    extends State<DriverFormScreen> {
final _formKey = GlobalKey<FormState>();

final DriverService _driverService =
DriverService();

final VehicleService _vehicleService =
VehicleService();

final fullNameController =
TextEditingController();

final phoneController =
TextEditingController();

final emailController =
TextEditingController();

final addressController =
TextEditingController();

final licenseController =
TextEditingController();

List<Vehicle> vehicles = [];

Vehicle? selectedVehicle;

DateTime? licenseExpiry;

String status = "Available";

bool loadingVehicles = true;

bool saving = false;

@override
void initState() {
super.initState();

_loadVehicles();

if (widget.driver != null) {
final driver = widget.driver!;

fullNameController.text =
driver.fullName;

phoneController.text =
driver.phoneNumber;

emailController.text =
driver.email;

addressController.text =
driver.address;

licenseController.text =
driver.licenseNumber;

licenseExpiry =
driver.licenseExpiry;

status = driver.status;
}
}

Future<void> _loadVehicles() async {
try {
vehicles =
await _vehicleService.getVehicles();

if (widget.driver != null &&
widget.driver!.vehicleId != null) {
try {
selectedVehicle = vehicles.firstWhere(
(v) =>
v.id ==
widget.driver!.vehicleId,
);
} catch (_) {}
}
} finally {
if (mounted) {
setState(() {
loadingVehicles = false;
});
}
}
}

Future<void> _pickLicenseDate() async {
final picked =
await showDatePicker(
context: context,
initialDate:
licenseExpiry ??
DateTime.now(),
firstDate: DateTime(2020),
lastDate: DateTime(2100),
);

if (picked != null) {
setState(() {
licenseExpiry = picked;
});
}
}

@override
void dispose() {
  fullNameController.dispose();
  phoneController.dispose();
  emailController.dispose();
  addressController.dispose();
  licenseController.dispose();

  super.dispose();
}
Widget _textField({
required TextEditingController controller,
required String label,
TextInputType keyboardType = TextInputType.text,
bool requiredField = false,
}) {
return Padding(
padding: const EdgeInsets.only(bottom: 16),
child: TextFormField(
controller: controller,
keyboardType: keyboardType,
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
return Scaffold(
appBar: AppBar(
title: Text(
widget.driver == null
? "Add Driver"
: "Edit Driver",
),
),

body: loadingVehicles
? const Center(
child: CircularProgressIndicator(),
)
: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Form(
key: _formKey,
child: Column(
children: <Widget>[

_textField(
controller: fullNameController,
label: "Full Name",
requiredField: true,
),

_textField(
controller: phoneController,
label: "Phone Number",
keyboardType: TextInputType.phone,
requiredField: true,
),

_textField(
controller: emailController,
label: "Email",
keyboardType:
TextInputType.emailAddress,
),

_textField(
controller: addressController,
label: "Address",
),

_textField(
controller: licenseController,
label: "License Number",
requiredField: true,
),

const SizedBox(height: 10),

ListTile(
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(8),
side: const BorderSide(
color: Colors.grey,
),
),
leading:
const Icon(Icons.badge),
title: Text(
licenseExpiry == null
? "License Expiry"
: licenseExpiry!
.toString()
.substring(0, 10),
),
trailing:
const Icon(Icons.calendar_month),
onTap: _pickLicenseDate,
),

const SizedBox(height: 20),

DropdownButtonFormField<Vehicle>(
value: selectedVehicle,
decoration: const InputDecoration(
labelText:
"Assigned Vehicle",
border:
OutlineInputBorder(),
),
items: [
const DropdownMenuItem<Vehicle>(
value: null,
child: Text("No Vehicle"),
),

...vehicles.map(
(vehicle) =>
DropdownMenuItem(
value: vehicle,
child: Text(
"${vehicle.plateNumber} - ${vehicle.make}",
),
),
),
],
onChanged: (value) {
setState(() {
selectedVehicle = value;
});
},
),

const SizedBox(height: 16),

DropdownButtonFormField<String>(
value: status,
decoration: const InputDecoration(
labelText: "Status",
border:
OutlineInputBorder(),
),
items: const [

DropdownMenuItem(
value: "Available",
child: Text("Available"),
),

DropdownMenuItem(
value: "Assigned",
child: Text("Assigned"),
),

DropdownMenuItem(
value: "Inactive",
child: Text("Inactive"),
),
],
onChanged: (value) {
setState(() {
status = value!;
});
},
),

const SizedBox(height: 30),
  SizedBox(
  width: double.infinity,
  height: 50,
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
      widget.driver == null
          ? "SAVE DRIVER"
          : "UPDATE DRIVER",
    ),
    onPressed: saving
        ? null
        : () async {
      if (!_formKey.currentState!
          .validate()) {
        return;
      }

      if (licenseExpiry == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Please select License Expiry",
            ),
          ),
        );
        return;
      }

      setState(() {
        saving = true;
      });

      try {
        final driver = Driver(
          id: widget.driver?.id ?? 0,
          driverNumber:
          widget.driver?.driverNumber ??
              "",
          fullName:
          fullNameController.text.trim(),
          phoneNumber:
          phoneController.text.trim(),
          email:
          emailController.text.trim(),
          address:
          addressController.text.trim(),
          licenseNumber:
          licenseController.text.trim(),
          licenseExpiry:
          licenseExpiry,
          vehicleId:
          selectedVehicle?.id,
          status: status,
        );

        if (widget.driver == null) {
          await _driverService
              .createDriver(driver);
        } else {
          await _driverService
              .updateDriver(driver);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            backgroundColor:
            Colors.green,
            content: Text(
              widget.driver == null
                  ? "Driver created successfully."
                  : "Driver updated successfully.",
            ),
          ),
        );

        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            backgroundColor:
            Colors.red,
            content:
            Text(e.toString()),
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
