import 'package:flutter/material.dart';

import '../../core/services/driver_service.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_loading.dart';
import '../../core/widgets/app_search_bar.dart';
import '../../core/widgets/confirm_delete_dialog.dart';

import '../../models/driver.dart';

import 'driver_form_screen.dart';
import 'widgets/driver_card.dart';
import 'widgets/driver_statistics.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  final DriverService _service = DriverService();

  late Future<List<Driver>> _drivers;

  final TextEditingController _searchController =
  TextEditingController();

  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDrivers() {
    _drivers = _service.getDrivers();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadDrivers();
    });
  }

  Future<void> _deleteDriver(Driver driver) async {
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: "Delete Driver",
      message:
      "Are you sure you want to delete\n\n${driver.fullName}?",
    );

    if (!confirmed) return;

    try {
      await _service.deleteDriver(driver.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "${driver.fullName} deleted successfully.",
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

  List<Driver> _filterDrivers(List<Driver> drivers) {
    if (_searchText.isEmpty) return drivers;

    final query = _searchText.toLowerCase();

    return drivers.where((driver) {
      return driver.driverNumber
          .toLowerCase()
          .contains(query) ||
          driver.fullName
              .toLowerCase()
              .contains(query) ||
          driver.phoneNumber
              .toLowerCase()
              .contains(query) ||
          driver.licenseNumber
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Drivers"),
        centerTitle: true,
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Driver"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const DriverFormScreen(),
            ),
          );

          _refresh();
        },
      ),

      body: FutureBuilder<List<Driver>>(
        future: _drivers,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const AppLoading(
              message: "Loading drivers...",
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Text(
                  snapshot.error.toString(),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const AppEmptyState(
              icon: Icons.people,
              title: "No Drivers",
              subtitle:
              "Driver list is empty.",
            );
          }

          final drivers =
          _filterDrivers(snapshot.data!);

          return Column(
            children: [

              DriverStatistics(
                drivers: drivers,
              ),

              AppSearchBar(
                controller: _searchController,
                hintText:
                "Search driver...",
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),

              if (drivers.isEmpty)
                const Expanded(
                  child: AppEmptyState(
                    icon: Icons.search_off,
                    title: "No Results",
                    subtitle:
                    "No drivers found.",
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      padding:
                      const EdgeInsets.only(
                        bottom: 80,
                      ),
                      itemCount:
                      drivers.length,
                      itemBuilder:
                          (context, index) {
                        final driver =
                        drivers[index];

                        return DriverCard(
                          driver: driver,
                          onRefresh:
                          _refresh,
                          onDelete: () =>
                              _deleteDriver(
                                  driver),
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