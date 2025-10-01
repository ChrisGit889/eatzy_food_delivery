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
              // Shopping Cart Icon
              Consumer<CartModel>(
                builder: (context, cart, child) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(),
                            ),
                          );
                        },
                      ),
                      if (!cart.isEmpty)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cart.items.length}',
                              style: TextStyle(
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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 16),
                        SizedBox(width: 4),
                        widget.restaurant['rating'] != null
                            ? Text('${widget.restaurant['rating']}')
                            : Container(),
                        SizedBox(width: 16),
                        Icon(Icons.location_on, color: Colors.grey, size: 16),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.restaurant['address'] ??
                                'Restaurant Address',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey),
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

            // Menu Items List
            SliverList.builder(
              itemCount: widget.restaurant['menus']?.length ?? 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    // Dish Image
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/pick.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Dish Name, Description, Price
                    title: Text(
                      widget.restaurant['menus']?[index]['name'] ??
                          'Dish ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(widget.restaurant['menus'][index]['description']),
                        const SizedBox(height: 8),
                        Text(
                          widget.restaurant['menus']?[index]['price'] != null
                              ? '\$${widget.restaurant['menus']?[index]['price']}'
                              : '\$12.99',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    // Add to Cart Button and favorite button 
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Consumer<FavoriteModel>(
                          builder: (context, favModel, child) {
                            final isFav = favModel.favorites.any(
                              (item) =>
                                  item['id'] ==
                                  widget.restaurant['menus'][index]['id'],
                            );

                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                favModel.toggleFav({
                                  ...Map<String, dynamic>.from(
                                    widget.restaurant['menus'][index],
                                  ),
                                  'restaurant': widget.restaurant['name'],
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFav
                                          ? '${widget.restaurant['menus'][index]['name']} removed from favorites'
                                          : '${widget.restaurant['menus'][index]['name']} added to favorites',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        // Consumer Cart
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
                                    'id':
                                        widget
                                            .restaurant['menus']?[index]['id'] ??
                                        'dish_${index + 1}',
                                    'name':
                                        widget
                                            .restaurant['menus']?[index]['name'] ??
                                        'Dish ${index + 1}',
                                    'price':
                                        widget
                                            .restaurant['menus']?[index]['price'] ??
                                        12.99,
                                    'quantity': 1,
                                  });
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
                                            '${widget.restaurant['menus'][index]['name']} added to cart',
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
                    onTap: () => _showDishDetails(context, index),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),

      // Floating Action Button to View Cart (If cart is not empty)
      floatingActionButton: Consumer<CartModel>(
        builder: (context, cart, child) {
          if (cart.isEmpty) return SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
            backgroundColor: Colors.orange,
            icon: Icon(Icons.shopping_cart),
            label: Text(
              'View Cart (${cart.items.length})',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  // Show Dish Details in a Dialog
  void _showDishDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: widget.restaurant['menus']?[index]['name'] != null
            ? Text(widget.restaurant['menus']?[index]['name'])
            : Text('Dish ${index + 1}'),
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
            SizedBox(height: 16),
            Text(
              widget.restaurant['menus']?[index]['description'] ??
                  'Delicious dish made with fresh ingredients.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    widget.restaurant['menus']?[index]['price'] != null
                        ? '\$${widget.restaurant['menus']?[index]['price']}'
                        : '\$12.99',
                    style: TextStyle(
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
            child: Text('Close'),
          ),
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return ElevatedButton(
                onPressed: () {
                  cart.addItem({
                    'id':
                        widget.restaurant['menus']?[index]['id'] ??
                        'dish_${index + 1}',
                    'name':
                        widget.restaurant['menus']?[index]['name'] ??
                        'Dish ${index + 1}',
                    'price':
                        widget.restaurant['menus']?[index]['price'] ?? 12.99,
                    'quantity': 1,
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Added to cart!')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: Text('Add to Cart'),
              );
            },
          ),
        ],
      ),
    );
  }
}
