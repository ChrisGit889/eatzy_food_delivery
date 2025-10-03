import 'package:flutter/material.dart';
import 'order_details_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allOrders = [
    {
      "orderId": "#4782-FP78924",
      "date": "Sep 30, 2025",
      "service": "KFC",
      "items": "3 items",
      "delivery": "June 30, 2025",
      "status": "Pending",
      "steps": 3,
    },
    {
      "orderId": "#4782-FP78925",
      "date": "Sep 27, 2025",
      "service": "PIZZA HUT ",
      "items": "2 items",
      "delivery": "June 27, 2025",
      "status": "Completed",
      "steps": 4,
    },
    {
      "orderId": "#4782-FP78926",
      "date": "Sep 25, 2025",
      "service": "Starbucks",
      "items": "3 items",
      "delivery": "June 25, 2025",
      "status": "Cancelled",
      "steps": 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(() => setState(() {}));
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.removeListener(() => setState(() {}));
    _tabController.removeListener(() => setState(() {}));
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredOrders() {
    List<Map<String, dynamic>> tabFilteredList;
    switch (_tabController.index) {
      case 1:
        tabFilteredList = _allOrders
            .where((order) => order['status'] == 'Pending')
            .toList();
        break;
      case 2:
        tabFilteredList = _allOrders
            .where((order) => order['status'] == 'Completed')
            .toList();
        break;
      case 3:
        tabFilteredList = _allOrders
            .where((order) => order['status'] == 'Cancelled')
            .toList();
        break;
      case 0:
      default:
        tabFilteredList = List.from(_allOrders);
        break;
    }

    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return tabFilteredList;
    }

    return tabFilteredList.where((order) {
      final orderId = order['orderId']!.toLowerCase();
      final service = order['service']!.toLowerCase();
      return orderId.contains(query) || service.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _getFilteredOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              _OrderSearchBar(controller: _searchController),
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 115, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: false,
                tabs: const [
                  Tab(text: "All orders"),
                  Tab(text: "Process"),
                  Tab(text: "Completed"),
                  Tab(text: "Cancelled"),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList(filteredOrders),
          buildOrderList(filteredOrders),
          buildOrderList(filteredOrders),
          buildOrderList(filteredOrders),
        ],
      ),
    );
  }

  Widget buildOrderList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          "Pesanan tidak ditemukan.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: buildOrderCard(order: order),
        );
      },
    );
  }

  Widget _getServiceLogo(String serviceName) {
    String imagePath;
    String trimmedServiceName = serviceName.trim();

    if (trimmedServiceName == 'KFC') {
      imagePath = 'assets/images/Kfc.png';
    } else if (trimmedServiceName == 'PIZZA HUT') {
      imagePath = 'assets/images/Pizza-hut.png';
    } else if (trimmedServiceName == 'Starbucks') {
      imagePath = 'assets/images/Starbucks.png';
    } else {
      return const Icon(
        Icons.restaurant_menu,
        size: 40,
        color: Color.fromARGB(255, 255, 136, 0),
      );
    }

    return Image.asset(imagePath);
  }

  Widget buildOrderCard({required Map<String, dynamic> order}) {
    final String status = order['status'];
    final int steps = order['steps'];

    Color statusColor;
    if (status == "Completed") {
      statusColor = Colors.green;
    } else if (status == "Pending") {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ${order['orderId']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(50),
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
            "Placed on ${order['date']}",
            style: const TextStyle(color: Color.fromARGB(255, 106, 106, 106)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: _getServiceLogo(order['service']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['service'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order['items'],
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      "Delivery • ${order['delivery']}",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderDetailsScreen(),
                    ),
                  );
                },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStep("Ordered", true),
              buildLine(),
              buildStep("Process", steps >= 2),
              buildLine(),
              buildStep("Handover", steps >= 3),
              buildLine(),
              buildStep("Finished", steps >= 4),
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

class _OrderSearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _OrderSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color.fromARGB(255, 212, 86, 13);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search by ID or name",
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: const Icon(Icons.search, color: themeColor),
        ),
      ),
    );
  }
}
