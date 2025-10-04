import 'package:eatzy_food_delivery/data/models/cart_model.dart';
import 'package:eatzy_food_delivery/data/models/favorit_model.dart';
import 'package:eatzy_food_delivery/screens/cart/cart_screen.dart';
import 'package:eatzy_food_delivery/screens/main_screen.dart';
import 'package:eatzy_food_delivery/utils/snackbar_helper.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';
import 'package:eatzy_food_delivery/services/seller_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool AtoZ = false;
  bool ZtoA = false;
  bool Cheapest = false;
  bool Expensive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Find your favorite food",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  color: Colors.black,
                  iconSize: 32,
                ),
              ],
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AtoZ ? Colors.orange : Colors.white,
                      foregroundColor: AtoZ ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        AtoZ = !AtoZ;
                        ZtoA = false;
                        Expensive = false;
                        Cheapest = false;
                      });
                    },
                    child: const Text("A-Z"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ZtoA ? Colors.orange : Colors.white,
                      foregroundColor: ZtoA ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        ZtoA = !ZtoA;
                        AtoZ = false;
                        Expensive = false;
                        Cheapest = false;
                      });
                    },
                    child: const Text("Z-A"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cheapest ? Colors.orange : Colors.white,
                      foregroundColor: Cheapest ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        Cheapest = !Cheapest;
                        Expensive = false;
                        AtoZ = false;
                        ZtoA = false;
                      });
                    },
                    child: const Text("Cheapest"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Expensive ? Colors.orange : Colors.white,
                      foregroundColor: Expensive ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        Expensive = !Expensive;
                        Cheapest = false;
                        AtoZ = false;
                        ZtoA = false;
                      });
                    },
                    child: const Text("Most Expensive"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<FavoriteModel>(
                builder: (context, favModel, child) {
                  List<Map> sortedFavorites = List.from(favModel.favorites);

                  if (AtoZ) {
                    sortedFavorites.sort(
                      (a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''),
                    );
                  }
                  if (ZtoA) {
                    sortedFavorites.sort(
                      (a, b) => (b['name'] ?? '').compareTo(a['name'] ?? ''),
                    );
                  }
                  if (Cheapest) {
                    sortedFavorites.sort(
                      (a, b) =>
                          (a['price'] ?? 0.0).compareTo(b['price'] ?? 0.0),
                    );
                  }
                  if (Expensive) {
                    sortedFavorites.sort(
                      (a, b) =>
                          (b['price'] ?? 0.0).compareTo(a['price'] ?? 0.0),
                    );
                  }

                  if (sortedFavorites.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "You don't have a favorite food yet",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainScreen(initialIndex: 0),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "Find Food",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: sortedFavorites.length,
                    itemBuilder: (context, index) {
                      final food = sortedFavorites[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            imagePathOfCategory(food["type"]),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(food['name'] ?? "Unknown"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<String?>(
                                future: findRestaurantFromFood(food["name"]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text("Loading...");
                                  }
                                  return Text(snapshot.data ?? '-');
                                },
                              ),
                              Text("Price: ${numToDollar(food["price"])}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  favModel.toggleFav(
                                    Map<String, dynamic>.from(food),
                                  );

                                  showSnackBar(
                                    context: context,
                                    content: Text("Removed from favorites"),
                                  );
                                },
                              ),
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
                                        final newItem = CartItem(
                                          name: food['name'],
                                          price: (food['price'] as num)
                                              .toDouble(),
                                          quantity: 1,
                                          image: imagePathOfCategory(
                                            food["type"],
                                          ),
                                        );
                                        cart.addItem(newItem);

                                        showSnackBar(
                                          context: context,
                                          content: Row(
                                            children: [
                                              const Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${food['name']} added to cart',
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
                                                      const CartScreen(),
                                                ),
                                              );
                                            },
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
          Image.asset(
            imagePathOfCategory(food["type"]),
            height: 150,
            fit: BoxFit.contain,
          ),
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
                final newItem = CartItem(
                  name: food['name'],
                  price: (food['price'] as num).toDouble(),
                  quantity: 1,
                  image: imagePathOfCategory(food["type"]),
                );
                cart.addItem(newItem);

                Navigator.pop(context);
                showSnackBar(context: context, content: Text("Added to cart!"));
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
