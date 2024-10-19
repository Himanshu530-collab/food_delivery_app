import 'package:flutter/material.dart';
import '../screens/restaurants.dart'; // Ensure this points to the correct file
import '../widgets/restaurant_card.dart'; // Import the RestaurantCard

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return RestaurantCard(
                  name: restaurant['name'],
                  imageUrl:
                      restaurant['image'], // Use imageUrl instead of image
                  menu: restaurant['menu'], // Pass the menu items
                  rating: restaurant['rating'], // Pass the rating
                );
              },
            ),
          ),
          // New Row for Orders and Wallet Transactions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.receipt_long),
                      onPressed: () {
                        Navigator.pushNamed(context, '/orders');
                      },
                    ),
                    Text('Orders')
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.account_balance_wallet),
                      onPressed: () {
                        Navigator.pushNamed(context, '/walletTransactions');
                      },
                    ),
                    Text('Wallet Transactions')
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
