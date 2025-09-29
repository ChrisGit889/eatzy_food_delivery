import 'package:flutter/material.dart';
import 'package:eatzy_food_delivery/constants.dart';
import 'change_address_view.dart';
import 'package:eatzy_food_delivery/data/dummy/dummy_data.dart';
import 'package:provider/provider.dart';
import 'package:eatzy_food_delivery/data/models/cart_model.dart';
import 'checkout_message_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectMethod = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              // Delivery Address Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: primaryText),
                    ),
                    SizedBox(height: 9),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '123 Main Street.\nBekasi, Indonesia',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: primaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChangeAddressView(),
                              ),
                            );
                          },
                          child: Text(
                            'Change',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: EATZY_ORANGE,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Payment Method Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment Method",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          label: Text(
                            "Add Card",
                            style: TextStyle(
                              fontSize: 13,
                              color: EATZY_ORANGE,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: DummyData().paymentArr.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                DummyData().paymentArr[index]['icon'],
                                width: 30,
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  DummyData().paymentArr[index]['name'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: primaryText,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectMethod = index;
                                  });
                                },
                                child: Icon(
                                  selectMethod == index
                                      ? Icons.check_circle
                                      : Icons.radio_button_off,
                                  color: EATZY_ORANGE,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Order Summary Section
              Consumer<CartModel>(
                builder: (context, cart, child) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sub Total",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Cost",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$0',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discount",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$0',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Send Order Button
              Consumer<CartModel>(
                builder: (context, cart, child) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25,
                  ),
                  child: InkWell(
                    onTap: () {
                      cart.clearCart();
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        isDismissible: false,
                        enableDrag: false,
                        builder: (BuildContext context) {
                          return CheckoutMessageScreen();
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: EATZY_ORANGE, width: 1),
                        color: EATZY_ORANGE,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Text(
                        'Send Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
