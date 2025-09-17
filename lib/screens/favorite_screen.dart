import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Makanan Favorit Anda"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Kolom input
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari makanan favorit anda",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                 //pas tombol ditekan muncul apa ??
                  },
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                  iconSize: 32,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "List makanan favorit anda",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}