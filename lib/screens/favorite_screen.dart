import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isFilterActive = false;
  bool AtoZ = false;
  bool ZtoA = false;
  bool Cheapest = false;
  bool Expensive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Makanan Favorit Anda")),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFilterActive
                          ? Colors.orange
                          : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isFilterActive = !isFilterActive;
                      });
                    },
                    child: const Text("Filter"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AtoZ
                          ? Colors.orange
                          : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        AtoZ = !AtoZ;
                        ZtoA = false;
                      });
                    },
                    child: const Text("A-Z"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ZtoA
                          ? Colors.orange
                          : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        ZtoA = !ZtoA;
                        AtoZ = false;
                      });
                    },
                    child: const Text("Z-A"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cheapest
                          ? Colors.orange
                          : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        Cheapest = !Cheapest;
                        Expensive = false;
                      });
                    },
                    child: const Text("Termurah"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Expensive
                          ? Colors.orange
                          : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        Expensive = !Expensive;
                        Cheapest = false;
                      });
                    },
                    child: const Text("Termahal"),
                  ),
                ],
              ),
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
