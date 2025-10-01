import 'package:eatzy_food_delivery/screens/category/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:eatzy_food_delivery/widgets/category_cell.dart';
import '../cart/cart_screen.dart';
import '../restaurant/restaurant_detail_view.dart';
import 'package:provider/provider.dart';
import 'package:eatzy_food_delivery/data/models/cart_model.dart';
import 'package:eatzy_food_delivery/data/dummy/dummy_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eatzy_food_delivery/screens/cart/change_address_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  List categories = DummyData().categories;
  List popularRestaurants = DummyData().popularRestaurants;
  List banner = [
    'assets/images/promo_banner_2.jpg',
    'assets/images/promo_banner_2.jpg',
    'assets/images/promo_banner_2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Screen Bar
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sort, size: 30, color: Colors.black),
              ),
              actions: [
                Consumer<CartModel>(
                  builder: (context, cart, child) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => const CartScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        if (!cart.isEmpty)
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${cart.items.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),

            // Deliver to Text
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                "Deliver to",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // Location Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.red,
                    size: 20,
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    '123 Main Street. Bekasi, Indonesia',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const ChangeAddressView(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search food",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                  prefixIcon: const Icon(Icons.search, color: Colors.red),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.red),
                    onPressed: () {},
                  ),
                ),
              ),
            ),

            // Promo Banner (Carousel)
            const SizedBox(height: 15),
            CarouselSlider(
              options: CarouselOptions(
                height: 150.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
              ),
              items: banner.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(i, fit: BoxFit.cover),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),

            // Category List
            SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCell(
                    categories: category,
                    isSelected: index == selectedCategoryIndex,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(
                            category: category,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Popular Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                "Popular Restaurants",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: popularRestaurants.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailView(
                            restaurant: popularRestaurants[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 10,
                        bottom: 10,
                      ),
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.asset(
                              popularRestaurants[index]['imagePath'],
                              height: 120,
                              width: MediaQuery.of(context).size.width / 2,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      popularRestaurants[index]['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      popularRestaurants[index]['address'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          popularRestaurants[index]['rating']
                                              .toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '(${popularRestaurants[index]['reviews']} reviews)',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
