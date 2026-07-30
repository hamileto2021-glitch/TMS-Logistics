import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/geofence_controller.dart';
import '../widgets/geofence_card.dart';
import 'geofence_form_screen.dart';

class GeofenceListScreen extends StatefulWidget {
  const GeofenceListScreen({super.key});

  @override
  State<GeofenceListScreen> createState() => _GeofenceListScreenState();
}

class _GeofenceListScreenState extends State<GeofenceListScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GeofenceController>().loadGeofences();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geofences"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GeofenceFormScreen(),
            ),
          );

          if (!mounted) return;

          context.read<GeofenceController>().refresh();
        },
        icon: const Icon(Icons.add),
        label: const Text("New"),
      ),
      body: Consumer<GeofenceController>(
        builder: (context, controller, child) {
          if (controller.isLoading &&
              controller.geofences.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  controller.error!,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final geofences =
          controller.search(_searchText);

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search geofences...",
                      prefixIcon:
                      const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: geofences.isEmpty
                      ? const Center(
                    child: Text(
                      "No geofences found.",
                    ),
                  )
                      : ListView.builder(
                    padding:
                    const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 80,
                    ),
                    itemCount: geofences.length,
                    itemBuilder:
                        (context, index) {
                      final geofence =
                      geofences[index];

                      return GeofenceCard(
                        geofence: geofence,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}