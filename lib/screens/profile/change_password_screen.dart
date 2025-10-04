import 'package:eatzy_food_delivery/services/user_service.dart';
import 'package:eatzy_food_delivery/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      if (newPasswordController.text == confirmPasswordController.text) {
        updatePassword(password: newPasswordController.text);
      }
      showSnackBar(
        context: context,
        content: Text("Password changed successfully!"),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback toggle,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter $label";
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: const Color(0xFFFD6C00),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField(
                "Old Password",
                oldPasswordController,
                _isObscureOld,
                () {
                  setState(() => _isObscureOld = !_isObscureOld);
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                "New Password",
                newPasswordController,
                _isObscureNew,
                () {
                  setState(() => _isObscureNew = !_isObscureNew);
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                "Confirm Password",
                confirmPasswordController,
                _isObscureConfirm,
                () {
                  setState(() => _isObscureConfirm = !_isObscureConfirm);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _savePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFD6C00),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
