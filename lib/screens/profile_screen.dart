import 'package:eatzy_food_delivery/screens/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<User> getUser() async {
    return FirebaseAuth.instance.currentUser!;
  }

  Future<String> getUserName(user) async {
    return (await user).displayName;
  }

  @override
  Widget build(BuildContext context) {
    var user = getUser();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => {
                      // Firebase
                    },
                    child: const Text(
                      "< Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthGate(),
                          ),
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("assets/buatisiprofile.jpg"),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<String>(
                    future: getUserName(user),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Account Settings",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildRoundedBox("Personal Information", onTap: () {}),
                  _buildRoundedBox("Payment Methods", onTap: () {}),
                  _buildRoundedBox("About Us", onTap: () {}),
                  _buildRoundedBox("Contact Us", onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedBox(String title, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
