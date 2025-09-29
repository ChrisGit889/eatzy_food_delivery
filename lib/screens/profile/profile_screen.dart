import 'package:eatzy_food_delivery/screens/auth/auth_gate.dart';
import 'package:eatzy_food_delivery/screens/auth/login_screen.dart';
import 'package:eatzy_food_delivery/screens/seller/seller_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<bool> isSeller = FirebaseFirestore.instance
      .collection('sellers')
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .get()
      .then((value) => value.exists);

  @override
  Widget build(BuildContext context) {
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
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AuthGate(whereToGo: LoginScreen()),
                          ),
                        );
                      } catch (e) {
                        // ignore: avoid_print
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
                  Text(
                    FirebaseAuth.instance.currentUser!.displayName!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  _paymentMethods(),
                  _personalInfo(),
                  FutureBuilder<bool>(
                    future: isSeller,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!) {
                          return _isASeller();
                        } else {
                          return _notASeller();
                        }
                      } else {
                        return _notASeller();
                      }
                    },
                  ),
                  _contactUs(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: slash_for_doc_comments
  /*********************
  Helper Functions
 *********************/
  //Function to build rounded boxes
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

  //Function to build "Personal Information"
  Widget _personalInfo() {
    return _buildRoundedBox("Personal Information", onTap: () {});
  }

  //Function to build "Payment Methods"
  Widget _paymentMethods() {
    return _buildRoundedBox("Payment Methods", onTap: () {});
  }

  //Function to build "Become A Seller" if user isnt a seller
  Widget _notASeller() {
    return _buildRoundedBox(
      "Become A Seller",
      onTap: () {
        var db = FirebaseFirestore.instance;
        var data = <String, dynamic>{
          "email": FirebaseAuth.instance.currentUser!.email,
          "store": null,
        };
        db
            .collection('sellers')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .set(data)
            // ignore: avoid_print
            .onError((e, _) => print("Error writing document to seller"));
        setState(() {
          isSeller = db
              .collection('sellers')
              .doc(FirebaseAuth.instance.currentUser!.email!)
              .get()
              .then((value) => value.exists);
        });
      },
    );
  }

  //Function to build "You Are a Seller" if user is a seller
  Widget _isASeller() {
    return _buildRoundedBox(
      "Manage Seller",
      onTap: () {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const SellerScreen()),
        );
      },
    );
  }

  //Function to build "Contact Us"
  Widget _contactUs() {
    return _buildRoundedBox("Contact Us", onTap: () {});
  }
}
