import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_provider.dart';
import '../screens/checkout_screen.dart'; // Import the CheckoutScreen

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Dismissible(
                  key: Key(item['name']),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    cart.removeItem(item['name']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item['name']} removed from cart'),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.asset(
                      item['image'], // Display the product image
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text('${item['name']} x ${item['quantity']}'),
                    trailing: Text(
                        "\₹${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            cart.removeItem(item['name']);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            cart.addItem(item['name'], item['price'],
                                item['image']); // Add image here
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total Items: ${cart.totalItems}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Total Value: \₹${cart.totalPrice.toStringAsFixed(2)}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Available Wallet Balance: \₹${cart.walletBalance.toStringAsFixed(2)}'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to Checkout screen and pass the total price
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(
                    totalAmount: cart.totalPrice,
                  ),
                ),
              );
            },
            child: Text("Proceed to Checkout"),
          ),
        ],
      ),
    );
  }
}
