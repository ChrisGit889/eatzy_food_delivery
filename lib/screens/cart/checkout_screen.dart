import 'package:eatzy_food_delivery/services/order_service.dart';
import 'package:eatzy_food_delivery/utils/snackbar_helper.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:eatzy_food_delivery/constants.dart';
import 'change_address_view.dart';
import 'package:eatzy_food_delivery/data/dummy/dummy_data.dart';
import 'package:provider/provider.dart';
import 'package:eatzy_food_delivery/data/models/cart_model.dart';
import 'checkout_message_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eatzy_food_delivery/data/models/address_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectMethod = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  child: Consumer<AddressModel>(
                    builder: (context, addressModel, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Address',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: primaryText),
                          ),
                          const SizedBox(height: 9),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  addressModel.address,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: primaryText,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              TextButton(
                                onPressed: () async {
                                  final result = await Navigator.of(context)
                                      .push(
                                        MaterialPageRoute<
                                          Map<String, dynamic>?
                                        >(
                                          builder: (context) =>
                                              const ChangeAddressView(),
                                        ),
                                      );

                                  if (result != null && mounted) {
                                    await addressModel.updateAddress(
                                      address: result['address'] as String,
                                      latitude: result['latitude'] as double,
                                      longitude: result['longitude'] as double,
                                    );
                                  }
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
                      );
                    },
                  ),
                ),
                const Divider(),

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
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: DummyData.paymentArr.length,
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
                                  DummyData.paymentArr[index]['icon'],
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    DummyData.paymentArr[index]['name'],
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

                Consumer<CartModel>(
                  builder: (context, cart, child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              numToDollar(cart.totalPrice),
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
                        const Divider(),
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
                              numToDollar(cart.totalPrice),
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

                Consumer<CartModel>(
                  builder: (context, cart, child) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 25,
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (cart.isEmpty || selectMethod == -1) {
                          showSnackBar(
                            context: context,
                            content: const Text(
                              "Keranjang kosong atau metode pembayaran belum dipilih.",
                            ),
                            backgroundColor: Colors.red,
                          );
                          return;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          final userId =
                              FirebaseAuth.instance.currentUser?.uid ??
                              'guest_user';
                          final restaurantName =
                              cart.items.first.name.contains("Pizza")
                              ? "PIZZA HUT"
                              : "KFC";

                          // DIUBAH: Panggil fungsi melalui OrderService()
                          await OrderService().placeOrder(
                            items: cart.items,
                            totalPrice: cart.totalPrice,
                            userId: userId,
                            restaurantName: restaurantName,
                          );

                          if (mounted) Navigator.of(context).pop();

                          cart.clearCart();
                          if (mounted) {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              builder: (BuildContext context) {
                                return const CheckoutMessageScreen();
                              },
                            );
                          }
                        } catch (e) {
                          if (mounted) Navigator.of(context).pop();

                          if (mounted) {
                            showSnackBar(
                              context: context,
                              content: Text("Gagal membuat pesanan: $e"),
                              backgroundColor: Colors.red,
                            );
                          }
                        }
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
                        child: const Text(
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
      ),
    );
  }
}
