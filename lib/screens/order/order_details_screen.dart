import 'package:eatzy_food_delivery/services/order_service.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'call_screen.dart';
import 'package:video_player/video_player.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/kfc.mp4');
    _initializeVideoPlayerFuture = _videoController.initialize().then((_) {
      _videoController.setLooping(true);
      _videoController.setVolume(0.0);
      _videoController.play();
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = (widget.order['items'] as List).fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );

    final deliveryFee = widget.order['deliveryFee'] ?? 0.50;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSupportCard(context),
                  const SizedBox(height: 20),
                  buildOrderStatusStepper(widget.order['status'] ?? 'Ordered'),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: _videoController.value.aspectRatio,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: VideoPlayer(_videoController),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  buildLocationInfo(
                    pickUpPoint:
                        widget.order['pickupPoint'] ??
                        'Pick-up address not available',
                    deliveryPoint:
                        widget.order['deliveryAddress'] ??
                        'Shipping Address not available',
                  ),
                  const Divider(height: 30),
                  buildItemDetails(widget.order['items'] as List),
                  const Divider(height: 30),
                  buildPaymentSummary(
                    subtotal,
                    deliveryFee,
                    widget.order['totalPrice'],
                  ),
                  const Divider(height: 30),
                  buildOrderInfo(widget.order),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: buildFinishButton(context),
          ),
        ],
      ),
    );
  }

  Widget buildFinishButton(BuildContext context) {
    final bool isCompleted = widget.order['status'] == 'Completed';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isCompleted
            ? null
            : () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  await OrderService().updateOrderStatus(
                    orderId: widget.order['orderId'],
                    newStatus: 'Completed',
                  );
                  if (mounted) Navigator.pop(context);
                  if (mounted) Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order has been completed!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (mounted) Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update status: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          disabledBackgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          isCompleted ? "ORDER COMPLETED" : "FINISH ORDER",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget buildOrderStatusStepper(String currentStatus) {
    List<String> statuses = ['Pending', 'Process', 'Delivered', 'Completed'];
    int currentStepIndex = statuses.indexWhere(
      (s) => s.toLowerCase() == currentStatus.toLowerCase(),
    );

    if (currentStepIndex == -1) {
      if (currentStatus.toLowerCase() == 'order') {
        currentStepIndex = 0;
      } else {
        currentStepIndex = 0;
      }
    }

    List<Widget> stepWidgets = [];
    for (int i = 0; i < statuses.length; i++) {
      bool isCompleted = i <= currentStepIndex;

      stepWidgets.add(_buildStep(label: statuses[i], isCompleted: isCompleted));

      if (i < statuses.length - 1) {
        stepWidgets.add(_buildConnector(isCompleted: i < currentStepIndex));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stepWidgets,
    );
  }

  Widget _buildStep({required String label, required bool isCompleted}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: isCompleted ? Colors.green : Colors.grey.shade300,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted ? Colors.black : Colors.grey,
            fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector({required bool isCompleted}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? Colors.green : Colors.grey.shade300,
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  Widget buildSupportCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/images/driver.png'),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Budi is MAN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Eatzy Driver",
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            ),
            icon: const Icon(Icons.chat_bubble_outline),
            color: Colors.orange,
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CallScreen()),
            ),
            icon: const Icon(Icons.call_outlined),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget buildLocationInfo({
    required String pickUpPoint,
    required String deliveryPoint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.storefront, color: Colors.orange, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pick-Up Point",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(pickUpPoint, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.orange, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Delivery Point",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    deliveryPoint,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildItemDetails(List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Detail Item",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...items
            .map(
              (item) => _buildItemRow(
                '${item['quantity']}x',
                item['name'],
                numToDollar(item['price']),
              ),
            )
            .toList(),
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

  Widget buildPaymentSummary(
    double subtotal,
    double deliveryFee,
    double total,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildPaymentRow("Subtotal", numToDollar(subtotal)),
        _buildPaymentRow("Delivery Fee", numToDollar(deliveryFee)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              numToDollar(total),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  Widget buildOrderInfo(Map<String, dynamic> orderData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Order Info",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildInfoRow("Order No.", orderData['orderId']),
        _buildInfoRow(
          "Payment Methods",
          orderData['paymentMethod'] ?? "Eatpay",
        ),
        _buildInfoRow(
          "Note",
          orderData['note'] ?? "Please add more sauce, thank you.",
        ),
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
}
