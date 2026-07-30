import 'package:flutter/material.dart';

import '../../../core/services/customer_service.dart';
import '../../../models/customer.dart';
import 'customer_form_screen.dart';
import '../../../core/widgets/navigation/app_drawer.dart';
import 'customer_details_screen.dart';



class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final CustomerService _service = CustomerService();
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];

  bool _loading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final customers = await _service.getCustomers();

      setState(() {
        _customers = customers;
        _filteredCustomers = customers;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void _search(String query) {
    final text = query.toLowerCase().trim();

    setState(() {
      if (text.isEmpty) {
        _filteredCustomers = _customers;
        return;
      }

      _filteredCustomers = _customers.where((customer) {
        return customer.companyName.toLowerCase().contains(text) ||
            customer.contactPerson.toLowerCase().contains(text) ||
            customer.phone.toLowerCase().contains(text) ||
            customer.email.toLowerCase().contains(text);
      }).toList();
    });
  }

  Future<void> _refresh() async {
    await _loadCustomers();
  }

  Future<void> _deleteCustomer(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Customer"),
        content: const Text(
          "Are you sure you want to delete this customer?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.deleteCustomer(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Customer deleted successfully."),
        ),
      );

      _refresh();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text("Customers"),
        centerTitle: true,
      ),



      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: "Search customers...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : _error != null
                ? Center(
              child: Text(_error!),
            )
                : _filteredCustomers.isEmpty
                ? const Center(
              child: Text("No customers found."),
            )
                : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: _filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = _filteredCustomers[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.business,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomerDetailsScreen(
                              customer: customer,
                            ),
                          ),
                        );

                        if (updated == true) {
                          _refresh();
                        }
                      },
                      title: Text(
                        customer.companyName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(customer.contactPerson),
                          Text(customer.phone),
                          Text(customer.email),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case "edit":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CustomerFormScreen(
                                        customer: customer,
                                      ),
                                ),
                              ).then((_) => _refresh());
                              break;

                            case "delete":
                              _deleteCustomer(customer.id);
                              break;
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: "edit",
                            child: Text("Edit"),
                          ),
                          PopupMenuItem(
                            value: "delete",
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CustomerFormScreen(),
            ),
          );

          _refresh();
        },
      ),
    );
  }
}