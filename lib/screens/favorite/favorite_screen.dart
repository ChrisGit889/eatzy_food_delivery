import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool AtoZ = false;
  bool ZtoA = false;
  bool Cheapest = false;
  bool Expensive = false;

  List<Map<String, dynamic>> foods = [
    {"name": "Nasi Goreng", "price": 15000},
    {"name": "Sate Ayam", "price": 20000},
    {"name": "Bakso", "price": 12000},
    {"name": "Mie Ayam", "price": 10000},
    {"name": "Ayam Geprek", "price": 18000},
  ];

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
                      backgroundColor: AtoZ ? Colors.orange : Colors.white,
                      foregroundColor: AtoZ ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        AtoZ = !AtoZ;
                        ZtoA = false;
                        Expensive = false;
                        Cheapest = false;
                        foods.sort((a, b) => a["name"].compareTo(b["name"]));
                      });
                    },
                    child: const Text("A-Z"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ZtoA ? Colors.orange : Colors.white,
                      foregroundColor: ZtoA ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        ZtoA = !ZtoA;
                        AtoZ = false;
                        Expensive = false;
                        Cheapest = false;
                        foods.sort((a, b) => b["name"].compareTo(a["name"]));
                      });
                    },
                    child: const Text("Z-A"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cheapest ? Colors.orange : Colors.white,
                      foregroundColor: Cheapest ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        Cheapest = !Cheapest;
                        Expensive = false;
                        AtoZ = false;
                        ZtoA = false;
                        foods.sort((a, b) => a["price"].compareTo(b["price"]));
                      });
                    },
                    child: const Text("Termurah"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Expensive ? Colors.orange : Colors.white,
                      foregroundColor: Expensive ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        Expensive = !Expensive;
                        Cheapest = false;
                        AtoZ = false;
                        ZtoA = false;
                        foods.sort((a, b) => b["price"].compareTo(a["price"]));
                      });
                    },
                    child: const Text("Termahal"),
                  ),
                ],
              ),
            ),
           

            Expanded(
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            food["name"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Rp ${food["price"]}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                             
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
