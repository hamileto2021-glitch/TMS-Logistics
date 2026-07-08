import 'package:flutter/material.dart';

import '../../../core/services/customer_service.dart';
import '../../../models/customer.dart';

class CustomerFormScreen extends StatefulWidget {
  final Customer? customer;

  const CustomerFormScreen({
    super.key,
    this.customer,
  });

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final CustomerService _service = CustomerService();

  final companyController = TextEditingController();
  final contactController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    if (widget.customer != null) {
      companyController.text = widget.customer!.companyName;
      contactController.text = widget.customer!.contactPerson;
      phoneController.text = widget.customer!.phone;
      emailController.text = widget.customer!.email;
      addressController.text = widget.customer!.address;
      cityController.text = widget.customer!.city;
      stateController.text = widget.customer!.state;
      countryController.text = widget.customer!.country;
    }
  }

  @override
  void dispose() {
    companyController.dispose();
    contactController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
    });

    final customer = Customer(
      id: widget.customer?.id ?? 0,
      customerCode: widget.customer?.customerCode ?? "",
      companyName: companyController.text.trim(),
      contactPerson: contactController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      country: countryController.text.trim(),
    );

    try {
      if (widget.customer == null) {
        await _service.createCustomer(customer);
      } else {
        await _service.updateCustomer(customer);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.customer == null
                ? "Customer added successfully."
                : "Customer updated successfully.",
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool requiredField = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
          widget.customer == null
              ? "Add Customer"
              : "Edit Customer",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildTextField(
                controller: companyController,
                label: "Company Name",
                requiredField: true,
              ),

              _buildTextField(
                controller: contactController,
                label: "Contact Person",
              ),

              _buildTextField(
                controller: phoneController,
                label: "Phone",
                keyboardType: TextInputType.phone,
              ),

              _buildTextField(
                controller: emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
              ),

              _buildTextField(
                controller: addressController,
                label: "Address",
              ),

              _buildTextField(
                controller: cityController,
                label: "City",
              ),

              _buildTextField(
                controller: stateController,
                label: "State",
              ),

              _buildTextField(
                controller: countryController,
                label: "Country",
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _saveCustomer,
                  icon: _saving
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
                    widget.customer == null
                        ? "SAVE CUSTOMER"
                        : "UPDATE CUSTOMER",
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