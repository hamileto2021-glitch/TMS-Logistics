import 'package:flutter/material.dart';

import '../../../models/dispatch.dart';
import '../../../core/widgets/app_status_chip.dart';

import '../services/dispatch_service.dart';
import 'dispatch_form_screen.dart';

class DispatchDetailsScreen extends StatefulWidget {
  final Dispatch dispatch;

  const DispatchDetailsScreen({
    super.key,
    required this.dispatch,
  });

  @override
  State<DispatchDetailsScreen> createState() =>
      _DispatchDetailsScreenState();
}

class _DispatchDetailsScreenState
    extends State<DispatchDetailsScreen> {
  final DispatchService _service = DispatchService();

  bool loading = false;

  Widget buildTile(
      String title,
      String value,
      IconData icon,
      ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Future<void> _startDispatch() async {
    setState(() => loading = true);

    try {
      await _service.startDispatch(widget.dispatch.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dispatch started successfully."),
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
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> _completeDispatch() async {
    setState(() => loading = true);

    try {
      await _service.completeDispatch(widget.dispatch.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dispatch completed successfully."),
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
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> _cancelDispatch() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Dispatch"),
        content: const Text(
          "Are you sure you want to cancel this dispatch?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("NO"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("YES"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => loading = true);

    try {
      await _service.cancelDispatch(widget.dispatch.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dispatch cancelled successfully."),
          backgroundColor: Colors.orange,
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
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  Future<void> _editDispatch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DispatchFormScreen(
          dispatch: widget.dispatch,
        ),
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dispatch = widget.dispatch;

    return Scaffold(
      appBar: AppBar(
        title: Text(dispatch.dispatchNumber),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: AppStatusChip(
              status: dispatch.status,
            ),
          ),

          const SizedBox(height: 20),

          buildTile(
            "Dispatch Number",
            dispatch.dispatchNumber,
            Icons.confirmation_number,
          ),

          buildTile(
            "Shipment",
            dispatch.shipmentNumber,
            Icons.inventory,
          ),

          buildTile(
            "Vehicle",
            dispatch.vehiclePlate,
            Icons.local_shipping,
          ),

          buildTile(
            "Driver",
            dispatch.driverName,
            Icons.person,
          ),

          buildTile(
            "Dispatch Date",
            dispatch.dispatchDate
                .toString()
                .substring(0, 10),
            Icons.calendar_today,
          ),

          buildTile(
            "Notes",
            dispatch.notes.isEmpty
                ? "-"
                : dispatch.notes,
            Icons.note,
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text("START DISPATCH"),
              onPressed: loading ? null : _startDispatch,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("EDIT DISPATCH"),
              onPressed: loading ? null : _editDispatch,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text("COMPLETE DISPATCH"),
              onPressed: loading ? null : _completeDispatch,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              icon: const Icon(Icons.cancel),
              label: const Text("CANCEL DISPATCH"),
              onPressed: loading ? null : _cancelDispatch,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}