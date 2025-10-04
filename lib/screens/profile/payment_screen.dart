import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = "COD";
  double _eatzyBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMethod = prefs.getString('selected_method') ?? "COD";
      _eatzyBalance = prefs.getDouble('eatzy_balance') ?? 0.0;
    });
  }

  Future<void> _saveSelectedMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_method', method);
  }

  Future<void> _saveEatzyBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('eatzy_balance', balance);
  }

  void _selectMethod(String method) {
    setState(() {
      _selectedMethod = method;
    });
    _saveSelectedMethod(method);
  }

  void _confirmPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You selected: $_selectedMethod"),
        backgroundColor: const Color(0xFFFD6C00),
      ),
    );
  }

  void _showTopUpDialog() {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Top Up EatzyPay"),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter amount",
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFD6C00),
              ),
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  setState(() {
                    _eatzyBalance += amount;
                  });
                  _saveEatzyBalance(_eatzyBalance);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Top Up Successful! Balance: Rp${_eatzyBalance.toStringAsFixed(0)}"),
                      backgroundColor: const Color(0xFFFD6C00),
                    ),
                  );
                }
              },
              child: const Text("Top Up", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption(String title, String value) {
    bool selected = _selectedMethod == value;
    return GestureDetector(
      onTap: () => _selectMethod(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFD6C00).withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFFFD6C00) : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: selected ? const Color(0xFFFD6C00) : Colors.black87,
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? const Color(0xFFFD6C00) : Colors.grey,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEatzyPayCard() {
    bool selected = _selectedMethod == "Eatzy";

    return GestureDetector(
      onTap: () => _selectMethod("Eatzy"),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFD6C00).withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFFFD6C00) : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "EatzyPay",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: selected ? const Color(0xFFFD6C00) : Colors.black87,
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected ? const Color(0xFFFD6C00) : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Balance: Rp${_eatzyBalance.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _showTopUpDialog,
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFD6C00)),
                label: const Text(
                  "Top Up",
                  style: TextStyle(color: Color(0xFFFD6C00), fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Method"),
        backgroundColor: const Color(0xFFFD6C00),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentOption("Cash on Delivery (COD)", "COD"),
            _buildEatzyPayCard(),
            const Spacer(),
            ElevatedButton(
              onPressed: _confirmPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFD6C00),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Confirm Payment",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
