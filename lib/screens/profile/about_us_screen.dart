import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: const Color(0xFFFD6C00),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            "Eatzy has been present in Indonesia for more than 10 years, serving and delivering top-quality food for Indonesian families. "
            "Since 2015, Eatzy in Indonesia has been owned by PT Mobile Programming and operated independently by PT Mobile Programming — "
            "one of the subsidiaries of an Information Technology company that is a 100% privately owned national enterprise run entirely by Indonesian entrepreneurs.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}