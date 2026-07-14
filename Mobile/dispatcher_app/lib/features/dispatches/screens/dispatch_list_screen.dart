import 'package:flutter/material.dart';

import '../../../core/services/dispatch_service.dart';
import '../../../models/dispatch.dart';
import 'dispatch_form_screen.dart';
import 'dispatch_details_screen.dart';

class DispatchListScreen extends StatefulWidget {
  const DispatchListScreen({super.key});

  @override
  State<DispatchListScreen> createState() => _DispatchListScreenState();
}

class _DispatchListScreenState extends State<DispatchListScreen> {
  final DispatchService _service = DispatchService();

  late Future<List<Dispatch>> _dispatches;

  @override
  void initState() {
    super.initState();
    _dispatches = _service.getDispatches();
  }

  Future<void> _refresh() async {
    setState(() {
      _dispatches = _service.getDispatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dispatches"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DispatchFormScreen(),
            ),
          );

          if (result == true) {
            _refresh();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<Dispatch>>(
        future: _dispatches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final dispatches = snapshot.data ?? [];

          if (dispatches.isEmpty) {
            return const Center(
              child: Text("No Dispatches Found"),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: dispatches.length,
              itemBuilder: (context, index) {
                final dispatch = dispatches[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(

                    onTap: () async {

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DispatchDetailsScreen(
                            dispatch: dispatch,
                          ),
                        ),
                      );

                      if (result == true) {
                        _refresh();
                      }

                    },

                    leading: CircleAvatar(
                      child: Text(dispatch.id.toString()),
                    ),

                    title: Text(dispatch.dispatchNumber),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shipment : ${dispatch.shipmentNumber}"),
                        Text("Driver : ${dispatch.driverName}"),
                        Text("Vehicle : ${dispatch.plateNumber}"),
                        Text("Status : ${dispatch.status}"),
                      ],
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}