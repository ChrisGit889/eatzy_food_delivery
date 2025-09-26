import 'package:flutter/material.dart';
import 'package:eatzy_food_delivery/widgets/category_cell.dart';
import 'package:eatzy_food_delivery/widgets/restaurant_rows.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;

  List categories = [
    {"name": "Pizza", "iconPath": "assets/images/pick.png"},
    {"name": "Burger", "iconPath": "assets/images/pick.png"},
    {"name": "Hotdog", "iconPath": "assets/images/pick.png"},
    {"name": "Drink", "iconPath": "assets/images/pick.png"},
    {"name": "Donut", "iconPath": "assets/images/pick.png"},
  ];

  List popularRestaurants = [
    {
      "name": "Pizza Hut",
      "imagePath": "assets/images/pick.png",
      "rating": 4.5,
      "address": "123 Main St",
    },
    {
      "name": "Burger King",
      "imagePath": "assets/images/pick.png",
      "rating": 4.0,
      "address": "456 Elm St",
    },
    {
      "name": "Subway",
      "imagePath": "assets/images/pick.png",
      "rating": 4.2,
      "address": "789 Oak St",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.sort,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
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
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Deliver to Text
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Deliver to",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
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
                          "Deliver to",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Category List
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: categories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryCell(
                          categories: category,
                          isSelected: index == selectedCategoryIndex,
                          onPressed: () {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: popularRestaurants.map((restaurant) {
                        return RestaurantRows(
                          restaurant: restaurant,
                          onPressed: () {},
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
