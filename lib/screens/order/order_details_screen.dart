import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'chat_screen.dart';
import 'call_screen.dart';

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
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 270,
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
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
                            "KFC, Jl. Raya Lenteng Agung No. 25",
                            Icons.storefront,
                          ),
                          buildLocationInfo(
                            "Delivery Point",
                            "Jl Tanjung Duren Utara No. 1 Grogol",
                            Icons.flag,
                          ),
                          const Divider(height: 30),
                          buildItemDetails(),
                          const Divider(height: 30),
                          buildPaymentSummary(),
                          const Divider(height: 30),
                          buildOrderInfo(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: buildCancelButton(),
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
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/driver.png'),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Budi is MAN",
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
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      );
                    },
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
                            "Chat with Driver",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CallScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
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
                    child: const Icon(
                      Icons.call_outlined,
                      color: Colors.black54,
                    ),
                  ),
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
            "Order #4782 • 1 kg • Delivery in 10 m",
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

  Widget _buildStep(String label, bool isCompleted) {
    final color = isCompleted ? Colors.green : Colors.grey;
    return Column(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? Colors.black87 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isCompleted) {
    return Expanded(
      child: Divider(
        color: isCompleted ? Colors.green : Colors.grey,
        thickness: 2,
      ),
    );
  }

  Widget buildTrackerTimeline() {
    int currentStep = 3;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildStep("Ordered", currentStep >= 1)),
        _buildLine(currentStep > 1),
        Expanded(child: _buildStep("Process", currentStep >= 2)),
        _buildLine(currentStep > 2),
        Expanded(child: _buildStep("Delivered", currentStep >= 3)),
        _buildLine(currentStep > 3),
        Expanded(child: _buildStep("Finished", currentStep >= 4)),
      ],
    );
  }

  Widget buildLocationInfo(String title, String address, IconData icon) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 255, 162, 0)),
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

  Widget buildItemDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Detail Item",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildItemRow("1x", "Winger Bucket", "\$6.00"),
        _buildItemRow("1x", "Super Family", "\$7.90"),
        _buildItemRow("1x", "French Fries", "\$1.30"),
      ],
    );
  }

  Widget _buildItemRow(String qty, String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(qty, style: const TextStyle(color: Colors.black54)),
          const SizedBox(width: 8),
          Expanded(child: Text(name)),
          Text(price),
        ],
      ),
    );
  }

  Widget buildPaymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildPaymentRow("Subtotal", "\$15.20"),
        _buildPaymentRow("Delivery Fee", "\$0.50"),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "\$15.70",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          Text(amount),
        ],
      ),
    );
  }

  Widget buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Order Info",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildInfoRow("Order No.", "#4782-FP78924"),
        _buildInfoRow("Payment Methods", "Eatpay"),
        _buildInfoRow("Note", "Please add more sauce, thank you."),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(width: 16),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget buildCancelButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const SuccessDialog();
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 153, 0),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: const Text(
        "FINISH ORDER",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            top: 65,
            right: 20,
            bottom: 20,
          ),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Enjoy your meal! 😋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              const Text(
                "Your order is in hand. Time to eat!",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      _navigateBack(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 153, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "Okay",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Color(0xFF46D1A7),
            radius: 45,
            child: Icon(Icons.check, color: Colors.white, size: 50),
          ),
        ),
      ],
    );
  }
}
