import 'package:eatzy_food_delivery/screens/auth_gate.dart';
import 'package:eatzy_food_delivery/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool isError = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dobNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Latar Belakang Gradien
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0F7FA), Color(0xFFE1BEE7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [SizedBox(width: 8)],
                  ),
                  const SizedBox(height: 30),
                  _buildRegisterCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color.fromARGB(255, 228, 113, 5),
                Color.fromARGB(255, 243, 129, 7),
              ],
            ).createShader(bounds),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: Colors.grey),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Color.fromARGB(255, 244, 117, 6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildFormFields(),

          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 238, 114, 4),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Register",
              style: TextStyle(color: Color(isError ? 0xFF000000 : 0xFFFFFFFF)),
            ),
            onPressed: () async {
              //Register function
              if (firstNameController.text == '' ||
                  emailController.text == '' ||
                  passwordController.text == '') {
                setState(() {
                  isError = true;
                });
              }

              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                );
                await FirebaseAuth.instance.currentUser!.updateDisplayName(
                  firstNameController.text,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AuthGate(whereToGo: LoginScreen()),
                  ),
                );
              } on FirebaseException catch (e) {
                if (e.code == 'weak-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('The password provided is too weak.'),
                    ),
                    snackBarAnimationStyle: AnimationStyle(
                      curve: ElasticInCurve(),
                    ),
                  );
                } else if (e.code == 'email-already-in-use') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'The account already exists for that email.',
                      ),
                    ),
                    snackBarAnimationStyle: AnimationStyle(
                      curve: ElasticInCurve(),
                    ),
                  );
                }
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: "First Name",
                controller: firstNameController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: "Last Name",
                controller: lastNameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(label: "Email", controller: emailController),
        const SizedBox(height: 16),
        _buildTextField(
          label: "Birth of date",
          suffixIcon: Icons.calendar_today_outlined,
          controller: dobNumberController,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: "Phone Number",
          controller: phoneNumberController,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("🇮🇩", style: TextStyle(fontSize: 20)),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          obscureText: !_isPasswordVisible,
          controller: passwordController,
          decoration: InputDecoration(
            labelText: "Set Password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? suffixIcon,
    Widget? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
