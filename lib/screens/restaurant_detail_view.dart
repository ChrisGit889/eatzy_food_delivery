import 'package:flutter/material.dart';

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
                'assets/images/pick.png',
                fit: BoxFit.cover,
              ),
            ),
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
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    'assets/images/pick.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text('Dish ${index + 1}'),
                  subtitle: const Text('Delicious dish description'),
                  trailing: const Text('\$10.00'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
