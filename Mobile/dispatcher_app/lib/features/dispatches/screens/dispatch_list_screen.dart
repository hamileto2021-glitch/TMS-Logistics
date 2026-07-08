import 'package:flutter/material.dart';

import '../../../models/dispatch.dart';
import '../services/dispatch_service.dart';

import 'dispatch_form_screen.dart';
import 'dispatch_details_screen.dart';

class DispatchListScreen extends StatefulWidget {
  const DispatchListScreen({super.key});

  @override
  State<DispatchListScreen> createState() =>
      _DispatchListScreenState();
}

class _DispatchListScreenState
    extends State<DispatchListScreen> {
  final DispatchService _service = DispatchService();

  late Future<List<Dispatch>> _future;

  final TextEditingController _searchController =
  TextEditingController();

  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _loadDispatches();
  }

  void _loadDispatches() {
    _future = _service.getDispatches();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadDispatches();
    });

    await _future;
  }

  List<Dispatch> _filter(List<Dispatch> dispatches) {
    if (_searchText.isEmpty) return dispatches;

    return dispatches.where((dispatch) {
      final q = _searchText.toLowerCase();

      return dispatch.dispatchNumber
          .toLowerCase()
          .contains(q) ||
          dispatch.shipmentNumber
              .toLowerCase()
              .contains(q) ||
          dispatch.driverName
              .toLowerCase()
              .contains(q) ||
          dispatch.vehiclePlate
              .toLowerCase()
              .contains(q) ||
          dispatch.status
              .toLowerCase()
              .contains(q);
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Colors.orange;

      case "in progress":
        return Colors.blue;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
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
        title: const Text("Dispatch Management"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),

      floatingActionButton:
      FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("New Dispatch"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const DispatchFormScreen(),
            ),
          );

          if (result == true) {
            _refresh();
          }
        },
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search Dispatch...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Dispatch>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                final dispatches =
                _filter(snapshot.data ?? []);

                if (dispatches.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Dispatches Found",
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: dispatches.length,
                    itemBuilder:
                        (context, index) {
                      final dispatch =
                      dispatches[index];

                      return Card(
                        elevation: 3,
                        margin:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                            _statusColor(
                                dispatch.status),
                            child: const Icon(
                              Icons.local_shipping,
                              color: Colors.white,
                            ),
                          ),

                          title: Text(
                            dispatch.dispatchNumber,
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              const SizedBox(
                                  height: 4),

                              Text(
                                  "Shipment : ${dispatch.shipmentNumber}"),

                              Text(
                                  "Vehicle : ${dispatch.vehiclePlate}"),

                              Text(
                                  "Driver : ${dispatch.driverName}"),

                              const SizedBox(
                                  height: 4),

                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  _statusColor(
                                      dispatch
                                          .status),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      12),
                                ),
                                child: Text(
                                  dispatch.status,
                                  style:
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          trailing: const Icon(
                            Icons
                                .arrow_forward_ios,
                          ),

                          onTap: () async {
                            final result =
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DispatchDetailsScreen(
                                      dispatch:
                                      dispatch,
                                    ),
                              ),
                            );

                            if (result == true) {
                              _refresh();
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}