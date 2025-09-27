import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/kfc.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 250, 184, 4),
                  Color.fromARGB(255, 176, 118, 0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                buildSupportCard(),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildOrderStatus(),
                          const SizedBox(height: 20),
                          buildTrackerTimeline(),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: _controller.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      child: VideoPlayer(_controller),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          buildLocationInfo(
                            "Pick-Up Point",
                            "49 Featherstone Street, EC1Y 8SY, UK.",
                            Icons.location_on,
                          ),
                          buildLocationInfo(
                            "Delivery Point",
                            "2/4-Brucfield Street, EC1Y 8, London.",
                            Icons.flag,
                          ),
                          const SizedBox(height: 30),
                          buildCancelButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSupportCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            // Bagian Atas(Ikon dan Teks)
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 237, 148, 4),
                        Color(0xFF8E2DE2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "G",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Budi MAN",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Eatzy Driver",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bagian Bawah (Tombol Chat & Telepon)
            Row(
              children: [
                // Tombol Chat
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.black54,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Chat with Support",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Tombol Telepon (Ukuran tetap)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.call_outlined, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderStatus() => const Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your order is picked.",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            "Order #4782 • 4 kg • Delivery in 2 hr",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      Chip(
        label: Text("On-Process"),
        backgroundColor: Color(0xFFE0F2F1),
        labelStyle: TextStyle(color: Colors.green),
      ),
    ],
  );

  Widget buildTrackerTimeline() => const Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Picked",
        style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
      ),
      Text("Washing", style: TextStyle(color: Colors.grey)),
      Text("Out for delivery", style: TextStyle(color: Colors.grey)),
      Text("Delivered", style: TextStyle(color: Colors.grey)),
    ],
  );

  Widget buildLocationInfo(String title, String address, IconData icon) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.purple),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(address, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      );

  Widget buildCancelButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A1B9A),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: const Text(
        "CANCEL ORDER",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}
