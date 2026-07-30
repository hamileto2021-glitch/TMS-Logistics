import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/geofence_controller.dart';
import '../models/geofence.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'geofence_map_screen.dart';

class GeofenceFormScreen extends StatefulWidget {
  final Geofence? geofence;

  const GeofenceFormScreen({
    super.key,
    this.geofence,
  });

  @override
  State<GeofenceFormScreen> createState() =>
      _GeofenceFormScreenState();
}

class _GeofenceFormScreenState
    extends State<GeofenceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _radiusController;

  String _type = "Warehouse";
  bool _isActive = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final g = widget.geofence;

    _nameController =
        TextEditingController(text: g?.name ?? '');

    _latitudeController =
        TextEditingController(text: g?.latitude.toString() ?? '');

    _longitudeController =
        TextEditingController(text: g?.longitude.toString() ?? '');

    _radiusController =
        TextEditingController(text: g?.radius.toString() ?? '100');

    _type = g?.type ?? "Warehouse";
    _isActive = g?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final data = {
      "name": _nameController.text.trim(),
      "type": _type,
      "latitude": double.parse(_latitudeController.text),
      "longitude": double.parse(_longitudeController.text),
      "radius": double.parse(_radiusController.text),
      "polygonCoordinates": null,
      "customerId": null,
      "warehouseId": null,
      "isActive": _isActive,
    };

    final controller =
    context.read<GeofenceController>();

    if (widget.geofence == null) {
      await controller.create(data);
    } else {
      await controller.update(
        widget.geofence!.id,
        data,
      );
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.geofence != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? "Edit Geofence"
              : "New Geofence",
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Location",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Latitude: ${_latitudeController.text}",
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Longitude: ${_longitudeController.text}",
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Radius: ${_radiusController.text} m",
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.map),
                        label: const Text("Select on Map"),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GeofenceMapScreen(
                                initialLocation: LatLng(
                                  double.tryParse(_latitudeController.text) ?? 8.5402,
                                  double.tryParse(_longitudeController.text) ?? 39.2713,
                                ),
                                initialRadius:
                                double.tryParse(_radiusController.text) ?? 100,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _latitudeController.text =
                                  result["latitude"].toString();

                              _longitudeController.text =
                                  result["longitude"].toString();

                              _radiusController.text =
                                  result["radius"].toStringAsFixed(0);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            SwitchListTile(
              value: _isActive,
              title: const Text("Active"),
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),

            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.save),
              label: Text(
                isEdit ? "Update" : "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}