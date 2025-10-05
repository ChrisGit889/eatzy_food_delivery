import 'package:eatzy_food_delivery/utils/snackbar_helper.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eatzy_food_delivery/data/models/payment_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  void _confirmPayment(PaymentModel paymentModel) {
    showSnackBar(
      context: context,
      content: Text("You selected: ${paymentModel.selectedMethod}"),
      backgroundColor: const Color(0xFFFD6C00),
    );
  }

  void _showTopUpDialog(PaymentModel paymentModel) {
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
              prefixText: "\$ ",
              prefixStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFD6C00),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFD6C00),
              ),
              onPressed: () async {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  await paymentModel.topUpBalance(amount);
                  if (mounted) {
                    Navigator.pop(context);
                    showSnackBar(
                      context: context,
                      content: Text(
                        "Top Up successful! Balance: ${numToDollar(paymentModel.eatzyBalance)}",
                      ),
                      backgroundColor: const Color(0xFFFD6C00),
                    );
                  }
                }
              },
              child: const Text(
                "Top Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption(
    String title,
    String value,
    PaymentModel paymentModel,
  ) {
    bool selected = paymentModel.selectedMethod == value;
    return GestureDetector(
      onTap: () => paymentModel.setSelectedMethod(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFD6C00).withAlpha(25)
              : Colors.white,
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

  Widget _buildEatzyPayCard(PaymentModel paymentModel) {
    bool selected = paymentModel.selectedMethod == "Eatzy";

    return GestureDetector(
      onTap: () => paymentModel.setSelectedMethod("Eatzy"),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFD6C00).withAlpha(25)
              : Colors.white,
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
              "Balance: ${numToDollar(paymentModel.eatzyBalance)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showTopUpDialog(paymentModel),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFFFD6C00),
                ),
                label: const Text(
                  "Top Up",
                  style: TextStyle(
                    color: Color(0xFFFD6C00),
                    fontWeight: FontWeight.w600,
                  ),
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
    return Consumer<PaymentModel>(
      builder: (context, paymentModel, child) {
        if (paymentModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFD6C00)),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Payment Method"),
            backgroundColor: const Color(0xFFFD6C00),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentOption(
                    "Cash on Delivery (COD)",
                    "COD",
                    paymentModel,
                  ),
                  _buildEatzyPayCard(paymentModel),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => _confirmPayment(paymentModel),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
