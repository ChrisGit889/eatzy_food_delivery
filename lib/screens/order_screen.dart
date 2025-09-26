import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // 1. Controller untuk mengelola input teks pada search bar
  final TextEditingController _searchController = TextEditingController();

  // 2. Daftar untuk menyimpan semua data pesanan (data asli)
  final List<Map<String, dynamic>> _allOrders = [
    {
      "orderId": "#EAT6925",
      "date": "Sep 25, 2025",
      "service": "Special Care Wash",
      "items": "7 items • 2 loads",
      "delivery": "June 30, 2025",
      "status": "Pending",
      "steps": 3,
    },
    {
      "orderId": "#FP78923",
      "date": "Sep 24, 2025",
      "service": "Ironing Service",
      "items": "10 items • 3 loads",
      "delivery": "June 27, 2025",
      "status": "Completed",
      "steps": 4,
    },
    {
      "orderId": "#FP78922",
      "date": "Sep 23n , 2025",
      "service": "Dry Cleaning",
      "items": "3 items • 1 load",
      "delivery": "June 25, 2025",
      "status": "Cancelled",
      "steps": 1,
    },
  ];

  // 3. Daftar untuk menampilkan pesanan yang sudah difilter
  late List<Map<String, dynamic>> _filteredOrders;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Saat awal, daftar yang difilter berisi semua pesanan
    _filteredOrders = _allOrders;

    // Menambahkan listener, sehingga fungsi _filterOrders akan terpanggil setiap kali ada perubahan teks
    _searchController.addListener(_filterOrders);
  }

  @override
  void dispose() {
    // 4. Jangan lupa dispose controller untuk menghindari memory leaks
    _searchController.removeListener(_filterOrders);
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // 5. Fungsi utama untuk logika filtering
  void _filterOrders() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOrders = _allOrders.where((order) {
        final orderId = order['orderId']!.toLowerCase();
        final service = order['service']!.toLowerCase();
        return orderId.contains(query) || service.contains(query);
      }).toList();
    });
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
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Mengirim search controller ke widget _OrderSearchBar
              _OrderSearchBar(controller: _searchController),
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 86, 13),
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
      // NOTE: Logika TabBarView perlu disesuaikan agar bisa bekerja dengan filter
      // Untuk saat ini, kita tampilkan hasil filter di semua tab
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList(), // All
          buildOrderList(), // Processing (perlu logika filter tambahan berdasarkan status)
          buildOrderList(), // Completed (perlu logika filter tambahan berdasarkan status)
          buildOrderList(), // Cancelled (perlu logika filter tambahan berdasarkan status)
        ],
      ),
    );
  }

  // 6. Widget builder sekarang menggunakan _filteredOrders
  Widget buildOrderList() {
    if (_filteredOrders.isEmpty) {
      return const Center(
        child: Text(
          "Pesanan tidak ditemukan.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: buildOrderCard(
            orderId: order['orderId']!,
            date: order['date']!,
            service: order['service']!,
            items: order['items']!,
            delivery: order['delivery']!,
            status: order['status']!,
            steps: order['steps']!,
          ),
        );
      },
    );
  }

  // Widget untuk UI card (tidak ada perubahan)
  Widget buildOrderCard({
    required String orderId,
    required String date,
    required String service,
    required String items,
    required String delivery,
    required String status,
    required int steps,
  }) {
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
                "Order $orderId",
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
            "Placed on $date",
            style: const TextStyle(color: Color.fromARGB(255, 106, 106, 106)),
          ),
          const SizedBox(height: 12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStep("Ordered", true),
              buildLine(),
              buildStep("Picked Up", steps >= 2),
              buildLine(),
              buildStep("Handover", steps >= 3),
              buildLine(),
              buildStep("Finish", steps >= 4),
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

// Widget untuk Search Bar (terpisah)
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
        controller: controller, // Menggunakan controller dari state
        decoration: InputDecoration(
          hintText: "Search by ID or name",
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: const Icon(Icons.search, color: themeColor),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list, color: themeColor),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
