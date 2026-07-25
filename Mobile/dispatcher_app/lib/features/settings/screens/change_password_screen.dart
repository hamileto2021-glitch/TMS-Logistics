import 'package:flutter/material.dart';

import '../models/change_password_request.dart';
import '../services/change_password_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  final ChangePasswordService _service =
  ChangePasswordService();

  bool _loading = false;

  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final message = await _service.changePassword(
        ChangePasswordRequest(
          currentPassword: _currentController.text.trim(),
          newPassword: _newController.text.trim(),
          confirmPassword: _confirmController.text.trim(),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  InputDecoration _decoration(
      String label,
      bool obscure,
      VoidCallback toggle,
      ) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      suffixIcon: IconButton(
        icon: Icon(
          obscure
              ? Icons.visibility
              : Icons.visibility_off,
        ),
        onPressed: toggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _currentController,
                obscureText: _hideCurrent,
                decoration: _decoration(
                  "Current Password",
                  _hideCurrent,
                      () {
                    setState(() {
                      _hideCurrent = !_hideCurrent;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Current password is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _newController,
                obscureText: _hideNew,
                decoration: _decoration(
                  "New Password",
                  _hideNew,
                      () {
                    setState(() {
                      _hideNew = !_hideNew;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "New password is required";
                  }

                  if (value.length < 8) {
                    return "Minimum 8 characters";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _confirmController,
                obscureText: _hideConfirm,
                decoration: _decoration(
                  "Confirm Password",
                  _hideConfirm,
                      () {
                    setState(() {
                      _hideConfirm = !_hideConfirm;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm password";
                  }

                  if (value != _newController.text) {
                    return "Passwords do not match";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed:
                  _loading ? null : _changePassword,
                  icon: _loading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.lock_reset),
                  label: Text(
                    _loading
                        ? "Updating..."
                        : "Change Password",
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