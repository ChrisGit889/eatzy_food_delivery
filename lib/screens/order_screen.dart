import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search orders",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // TabBar filter
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 86, 13),
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                tabs: const [
                  Tab(text: "All orders"),
                  Tab(text: "Processing"),
                  Tab(text: "Completed"),
                  Tab(text: "Cancelled"),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),

      // Tab content
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList(), // All
          buildOrderList(status: "Processing"),
          buildOrderList(status: "Completed"),
          buildOrderList(status: "Cancelled"),
        ],
      ),
    );
  }

  // Card list builder
  Widget buildOrderList({String status = "All"}) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildOrderCard(
          orderId: "#FP78924",
          date: "June 25, 2023",
          service: "Special Care Wash",
          items: "7 items • 2 loads",
          delivery: "June 30, 2025",
          status: "Pending",
          steps: 3,
        ),
        const SizedBox(height: 16),
        buildOrderCard(
          orderId: "#FP78923",
          date: "June 22, 2023",
          service: "Ironing Service",
          items: "10 items • 3 loads",
          delivery: "June 27, 2025",
          status: "Completed",
          steps: 4,
        ),
      ],
    );
  }

  // Order card UI
  Widget buildOrderCard({
    required String orderId,
    required String date,
    required String service,
    required String items,
    required String delivery,
    required String status,
    required int steps,
  }) {
    Color statusColor = status == "Completed" ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order $orderId",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Placed on $date",
            style: TextStyle(color: const Color.fromARGB(255, 106, 106, 106)),
          ),

          const SizedBox(height: 12),

          // Service
          Row(
            children: [
              const Icon(
                Icons.local_laundry_service,
                size: 40,
                color: Colors.black54,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(items, style: TextStyle(color: Colors.grey.shade600)),
                    Text(
                      "Delivery • $delivery",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 230, 144, 16),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 223, 153, 13),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Track Order"),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Step indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStep("Ordered", true),
              buildLine(),
              buildStep("Picked Up", steps >= 2),
              buildLine(),
              buildStep("Handover", steps >= 3),
              buildLine(),
              buildStep("Delivered", steps >= 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStep(String text, bool done) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: done
              ? const Color.fromARGB(255, 236, 157, 12)
              : Colors.grey.shade300,
          child: Icon(
            done ? Icons.check : Icons.hourglass_empty,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget buildLine() {
    return Expanded(child: Container(height: 2, color: Colors.grey.shade300));
  }
}
