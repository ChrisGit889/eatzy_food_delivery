import 'package:eatzy_food_delivery/data/models/cart_model.dart';
import 'package:eatzy_food_delivery/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eatzy_food_delivery/data/models/favorit_model.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';

class FavoriteSearchScreen extends StatefulWidget {
  const FavoriteSearchScreen({super.key});

  @override
  State<FavoriteSearchScreen> createState() => _FavoriteSearchScreenState();
}

class _FavoriteSearchScreenState extends State<FavoriteSearchScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Favorite")),
      body: Column(
        children: [
          // input
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search your favorite food by name",
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 212, 86, 13),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  query = value.toLowerCase();
                });
              },
            ),
          ),

          //output
          Expanded(
            child: Consumer<FavoriteModel>(
              builder: (context, favModel, child) {
                if (query.isEmpty) {
                  return const Center(
                    child: Text(
                      "Search your favorite food",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final results = favModel.favorites.where((food) {
                  final name = (food['name'] ?? '').toString().toLowerCase();
                  return name.contains(query);
                }).toList();

                if (results.isEmpty) {
                  return Center(child: Text('there is no favorite food with the keyword : $query'));
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final food = results[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          imagePathOfCategory(food["type"]),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(food['name'] ?? "Unknown"),
                        subtitle: Text("Price: ${numToDollar(food['price'])}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //remove
                            Consumer<FavoriteModel>(
                              builder: (context, favModel, child) {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    favModel.toggleFav(
                                      Map<String, dynamic>.from(food),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Removed from favorites"),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            // add to cart
                            Consumer<CartModel>(
                              builder: (context, cart, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      cart.addItem({
                                        'name': food['name'],
                                        'price': food['price'],
                                        'quantity': 1,
                                      });

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '${food['name']} added to cart',
                                                ),
                                              ),
                                            ],
                                          ),
                                          duration: const Duration(seconds: 2),
                                          action: SnackBarAction(
                                            label: 'View Cart',
                                            textColor: Colors.orange,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CartScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          _showDishDetails(context, food);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showDishDetails(BuildContext context, Map food) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(food['name'] ?? 'Unknown'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (food.containsKey('imagePath'))
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                food['imagePath'],
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            )
          else
            const Icon(Icons.fastfood, size: 100),
          const SizedBox(height: 16),
          Text("${food['description'] ?? '-'}", textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            "Price: ${numToDollar(food["price"])}",
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        Consumer<CartModel>(
          builder: (context, cart, child) {
            return ElevatedButton(
              onPressed: () {
                cart.addItem({
                  'name': food['name'],
                  'price': food['price'],
                  'quantity': 1,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('added to cart!')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add to Cart'),
            );
          },
        ),
      ],
    ),
  );
}
