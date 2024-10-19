import 'package:flutter/material.dart';
import '../widgets/menu_item_card.dart';

class RestaurantMenuScreen extends StatelessWidget {
  final String restaurantName;
  final List<Map<String, dynamic>> menuItems;

  RestaurantMenuScreen({
    required this.restaurantName,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return MenuItemCard(
            dishName: item['name'],
            price: item['price'],
            imagePath: item['image'],
          );
        },
      ),
    );
  }
}
