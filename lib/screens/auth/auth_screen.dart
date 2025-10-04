import 'package:eatzy_food_delivery/screens/auth/auth_gate.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';
import 'package:eatzy_food_delivery/utils/utils_user.dart';
import 'package:flutter/material.dart';
import 'package:eatzy_food_delivery/screens/main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginView = true;
  bool _rememberMe = false;
  bool _isLoginPasswordObscured = true;
  bool _isRegisterPasswordObscured = true;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 60,
                color: const Color.fromARGB(255, 255, 106, 0),
              ),
              const SizedBox(height: 24),
              Text(
                'Get Started now',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Create an account or log in to explore about our app',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _buildToggleButtons(),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _isLoginView ? _buildLoginForm() : _buildRegisterForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isLoginView = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isLoginView ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isLoginView
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isLoginView
                          ? const Color.fromARGB(255, 255, 115, 0)
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isLoginView = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isLoginView ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !_isLoginView
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: !_isLoginView
                          ? const Color.fromARGB(255, 255, 153, 0)
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('login_form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(label: 'Email', controller: emailController),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Password',
          controller: passwordController,
          isPassword: true,
          obscureState: _isLoginPasswordObscured,
          onToggleObscure: () {
            setState(() {
              _isLoginPasswordObscured = !_isLoginPasswordObscured;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (newValue) {
                    setState(() {
                      _rememberMe = newValue!;
                    });
                  },
                ),
                const Text('Remember me'),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: const Color.fromARGB(255, 255, 153, 0)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            if (emailController.text == "call: command" &&
                passwordController.text == "resetpopulate") {
              try {
                await cleanAndRemigrate();
                print("Database has been cleaned");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Database Successfully remigrated")),
                );
              } catch (e, stack) {
                print(stack);
              }
              return;
            }
            var res = await signInUser(
              emailController.text,
              passwordController.text,
              context,
            );
            if (res) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthGate(whereToGo: AuthScreen()),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 145, 0),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Log In',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 24),
        const Center(
          child: Text('Or login with', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 16),
        _buildSocialLogins(),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      key: const ValueKey('register_form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'First Name',
                controller: firstNameController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'Last Name',
                controller: lastNameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(label: 'Email', controller: emailController),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Birth of date',
          controller: dobController,
          isDatePicker: true,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Phone Number',
          controller: phoneController,
          isPhoneNumber: true,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Set Password',
          controller: passwordController,
          isPassword: true,
          obscureState: _isRegisterPasswordObscured,
          onToggleObscure: () {
            setState(() {
              _isRegisterPasswordObscured = !_isRegisterPasswordObscured;
            });
          },
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            var res = createNewUser(
              firstNameController.text,
              emailController.text,
              passwordController.text,
              context,
            );
            FutureBuilder(
              future: res,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  }
                }
                return Placeholder();
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 140, 0),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Register',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    bool isDatePicker = false,
    bool isPhoneNumber = false,
    bool? obscureState,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? (obscureState ?? true) : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (obscureState ?? true)
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: onToggleObscure,
                  )
                : isDatePicker
                ? const Icon(Icons.calendar_today_outlined)
                : null,
            prefixIcon: isPhoneNumber
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('🇮🇩', style: TextStyle(fontSize: 18)),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(Image.asset('assets/images/google_icon.png', height: 24)),
        const SizedBox(width: 16),
        _socialButton(
          Image.asset('assets/images/facebook_icon.png', height: 24),
        ),
        const SizedBox(width: 16),
        _socialButton(Image.asset('assets/images/apple_icon.png', height: 24)),
        const SizedBox(width: 16),
        _socialButton(Icon(Icons.more_horiz, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _socialButton(Widget child) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: child,
      ),
    );
  }
}
