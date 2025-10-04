import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: const Color(0xFFFD6C00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Need help? We're here for you!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "If you have questions, feedback, or need assistance, "
              "please reach out to us via one of the following platforms:",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 25),

            const ListTile(
              leading: Icon(Icons.email, color: Colors.orange),
              title: Text("Email"),
              subtitle: Text("eatzy@gmail.com"),
            ),

            const ListTile(
              leading: Icon(FontAwesomeIcons.facebook, color: Colors.blue),
              title: Text("Facebook"),
              subtitle: Text("Eatzy Official"),
            ),

            const ListTile(
              leading: Icon(FontAwesomeIcons.instagram, color: Colors.purple),
              title: Text("Instagram"),
              subtitle: Text("@eatzy"),
            ),

            const ListTile(
              leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
              title: Text("WhatsApp"),
              subtitle: Text("+62 812-3456-7890"),
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                "Thank you for supporting Eatzy!\nWe're always ready to make your experience better 🍽️",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}