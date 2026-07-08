import 'package:flutter/material.dart';

import '../../core/services/vehicle_service.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_loading.dart';
import '../../core/widgets/app_search_bar.dart';
import '../../core/widgets/confirm_delete_dialog.dart';
import '../../models/vehicle.dart';
import 'vehicle_form_screen.dart';
import 'widgets/vehicle_card.dart';
import 'widgets/vehicle_statistics.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final VehicleService _service = VehicleService();

  late Future<List<Vehicle>> _vehicles;

  final TextEditingController _searchController =
  TextEditingController();

  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadVehicles() {
    _vehicles = _service.getVehicles();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadVehicles();
    });
  }

  Future<void> _deleteVehicle(Vehicle vehicle) async {
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: "Delete Vehicle",
      message:
      "Are you sure you want to delete\n\n${vehicle.plateNumber}?",
    );

    if (!confirmed) return;

    try {
      await _service.deleteVehicle(vehicle.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "${vehicle.plateNumber} deleted successfully.",
          ),
        ),
      );

      _refresh();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }
  }

  List<Vehicle> _filterVehicles(List<Vehicle> vehicles) {
    if (_searchText.isEmpty) return vehicles;

    final query = _searchText.toLowerCase();

    return vehicles.where((vehicle) {
      return vehicle.vehicleCode.toLowerCase().contains(query) ||
          vehicle.plateNumber.toLowerCase().contains(query) ||
          vehicle.make.toLowerCase().contains(query) ||
          vehicle.model.toLowerCase().contains(query) ||
          vehicle.vehicleType.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Fleet Vehicles"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Vehicle"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const VehicleFormScreen(),
            ),
          );

          _refresh();
        },
      ),

      body: FutureBuilder<List<Vehicle>>(
        future: _vehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const AppLoading(
              message: "Loading vehicles...",
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(snapshot.error.toString()),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const AppEmptyState(
              icon: Icons.fire_truck,
              title: "No Vehicles",
              subtitle: "Vehicle list is empty.",
            );
          }

          final vehicles =
          _filterVehicles(snapshot.data!);

          return Column(
            children: [

              VehicleStatistics(
                vehicles: vehicles,
              ),

              AppSearchBar(
                controller: _searchController,
                hintText:
                "Search plate, make, model...",
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),

              if (vehicles.isEmpty)
                const Expanded(
                  child: AppEmptyState(
                    icon: Icons.search_off,
                    title: "No Results",
                    subtitle:
                    "No vehicles match your search.",
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 80,
                      ),
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];

                        return VehicleCard(
                          vehicle: vehicle,
                          onRefresh: _refresh,
                          onDelete: () =>
                              _deleteVehicle(vehicle),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}