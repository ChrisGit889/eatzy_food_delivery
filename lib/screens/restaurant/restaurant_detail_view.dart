import 'package:eatzy_food_delivery/data/models/favorit_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eatzy_food_delivery/data/models/cart_model.dart';
import '../cart/cart_screen.dart';

class RestaurantDetailView extends StatefulWidget {
  final Map restaurant;
  const RestaurantDetailView({super.key, required this.restaurant});

  @override
  State<RestaurantDetailView> createState() => _RestaurantDetailViewState();
}

class _RestaurantDetailViewState extends State<RestaurantDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.restaurant['imagePath'],
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              Consumer<CartModel>(
                builder: (context, cart, child) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ),
                          );
                        },
                      ),
                      if (!cart.isEmpty)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cart.items.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
        ],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.restaurant['name'] ?? 'Restaurant Name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        widget.restaurant['rating'] != null
                            ? Text('${widget.restaurant['rating']}')
                            : Container(),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.restaurant['address'] ??
                                'Restaurant Address',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This is a detailed description of the restaurant. It offers various cuisines and has a great ambiance.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            SliverList.builder(
              itemCount: widget.restaurant['menus']?.length ?? 5,
              itemBuilder: (context, index) {
                final menuItem = widget.restaurant['menus'][index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/pick.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),

                    title: Text(
                      menuItem['name'] ?? 'Dish ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(menuItem['description']),
                        const SizedBox(height: 8),
                        Text(
                          menuItem['price'] != null
                              ? '\$${menuItem['price']}'
                              : '\$12.99',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Consumer<FavoriteModel>(
                          builder: (context, favModel, child) {
                            final isFav = favModel.favorites.any(
                              (item) => item['id'] == menuItem['id'],
                            );

                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                favModel.toggleFav({
                                  ...Map<String, dynamic>.from(menuItem),
                                  'restaurant': widget.restaurant['name'],
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFav
                                          ? '${menuItem['name']} removed from favorites'
                                          : '${menuItem['name']} added to favorites',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
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
                                    name:
                                        menuItem['name'] ?? 'Dish ${index + 1}',
                                    image: 'assets/images/pick.png',
                                    price: (menuItem['price'] as num? ?? 12.99)
                                        .toDouble(),
                                    quantity: 1,
                                  );
                                  cart.addItem(newItem);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${menuItem['name']} added to cart',
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
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () => _showDishDetails(context, index),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),

      floatingActionButton: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            backgroundColor: Colors.orange,
            icon: const Icon(Icons.shopping_cart),
            label: Text(
              'View Cart (${cart.items.length})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  void _showDishDetails(BuildContext context, int index) {
    final menuItem = widget.restaurant['menus'][index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(menuItem['name'] ?? 'Dish ${index + 1}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/pick.png',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              menuItem['description'] ??
                  'Delicious dish made with fresh ingredients.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    menuItem['price'] != null
                        ? '\$${menuItem['price']}'
                        : '\$12.99',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
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
                    name: menuItem['name'] ?? 'Dish ${index + 1}',
                    image: 'assets/images/pick.png',
                    price: (menuItem['price'] as num? ?? 12.99).toDouble(),
                    quantity: 1,
                  );
                  cart.addItem(newItem);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart!')),
                  );
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
}
