import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatzy_food_delivery/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(() => setState(() {}));
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredOrders(
    List<Map<String, dynamic>> allOrders,
  ) {
    List<Map<String, dynamic>> filteredList = List.from(allOrders);

    if (_selectedDateRange != null) {
      filteredList = filteredList.where((order) {
        final orderDate = DateFormat("MMM dd, yyyy").parse(order['date']);
        final startDate = _selectedDateRange!.start;
        final endDate = _selectedDateRange!.end.add(const Duration(days: 1));
        return orderDate.isAfter(startDate) && orderDate.isBefore(endDate);
      }).toList();
    }

    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return filteredList;
    }

    return filteredList.where((order) {
      final orderId = order['orderId']!.toLowerCase();
      final restaurantName = (order['restaurantName'] as String).toLowerCase();
      return orderId.contains(query) || restaurantName.contains(query);
    }).toList();
  }

  int _getStatusSteps(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 2;
      case 'completed':
        return 4;
      case 'cancelled':
        return 1;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(160),
          child: Column(
            children: [
              _OrderSearchBar(
                controller: _searchController,
                onFilterPressed: _selectDateRange,
              ),
              _buildActiveFilterInfo(),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: OrderService().getOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada pesanan.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final allOrdersFromDb = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['orderId'] = doc.id;
            data['date'] = DateFormat(
              "MMM dd, yyyy",
            ).format((data['createdAt'] as Timestamp).toDate());
            data['steps'] = _getStatusSteps(data['status'] ?? 'Unknown');
            return data;
          }).toList();

          final filteredOrders = _getFilteredOrders(allOrdersFromDb);

          return TabBarView(
            controller: _tabController,
            children: [
              buildOrderList(filteredOrders),
              buildOrderList(
                filteredOrders.where((o) => o['status'] == 'Pending').toList(),
              ),
              buildOrderList(
                filteredOrders
                    .where((o) => o['status'] == 'Completed')
                    .toList(),
              ),
              buildOrderList(
                filteredOrders
                    .where((o) => o['status'] == 'Cancelled')
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActiveFilterInfo() {
    if (_selectedDateRange == null) return const SizedBox(height: 30);
    final dateFormat = DateFormat('dd MMM yyyy');
    final startDate = dateFormat.format(_selectedDateRange!.start);
    final endDate = dateFormat.format(_selectedDateRange!.end);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Chip(
            label: Text('$startDate - $endDate'),
            backgroundColor: Colors.orange.shade100,
            onDeleted: () => setState(() => _selectedDateRange = null),
            deleteIcon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    );
  }

  Widget buildOrderList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          "Order not found",
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
    String trimmedServiceName = serviceName.trim().toUpperCase();
    if (trimmedServiceName == 'KFC')
      imagePath = 'assets/images/Kfc.png';
    else if (trimmedServiceName == 'PIZZA HUT')
      imagePath = 'assets/images/Pizza-hut.png';
    else if (trimmedServiceName == 'STARBUCKS')
      imagePath = 'assets/images/Starbucks.png';
    else
      return const Icon(
        Icons.restaurant_menu,
        size: 40,
        color: Color.fromARGB(255, 255, 136, 0),
      );
    return Image.asset(imagePath);
  }

  Widget buildOrderCard({required Map<String, dynamic> order}) {
    final String status = order['status'];
    final int steps = order['steps'];
    final restaurantName = order['restaurantName'] ?? 'Restaurant';
    final items = order['items'] as List;

    Color statusColor = switch (status) {
      "Completed" => Colors.green,
      "Pending" => Colors.orange,
      _ => Colors.red,
    };

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
                "Order #${order['orderId'].substring(0, 8)}...",
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
                child: _getServiceLogo(restaurantName),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${items.length} items",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      "Delivery • ${order['date']}",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              if (status == 'Completed')
                ElevatedButton(
                  onPressed: () {
                    final snackBar = SnackBar(
                      content: Text('Enjoy your ${restaurantName.trim()} 😊'),
                      backgroundColor: Colors.green,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 230, 144, 16),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Enjoy your meal"),
                )
              else if (status == 'Cancelled')
                OutlinedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    disabledForegroundColor: Colors.grey.withOpacity(0.38),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("View Details"),
                )
              else
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(order: order),
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

  Widget buildLine() =>
      Expanded(child: Container(height: 2, color: Colors.grey.shade300));
}

class _OrderSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterPressed;

  const _OrderSearchBar({
    required this.controller,
    required this.onFilterPressed,
  });

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
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list, color: themeColor),
            onPressed: onFilterPressed,
          ),
        ),
      ),
    );
  }
}
