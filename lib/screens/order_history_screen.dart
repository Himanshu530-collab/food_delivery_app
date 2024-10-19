import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_provider.dart';
import '../widgets/home_button.dart'; // Adjust the path as necessary

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        actions: [
          HomeButton(), // Add HomeButton here
        ],
      ),
      body: ListView.builder(
        itemCount: cart.orderHistory.length,
        itemBuilder: (context, index) {
          final order = cart.orderHistory[index];
          return ListTile(
            title: Text('Order ID: ${order['orderId']}'),
            subtitle: Text(
                'Amount: \₹${order['amount'].toStringAsFixed(2)}\nDelivery in: ${order['deliveryTime']} mins'),
            onTap: () {
              // Show order details when tapping on Order ID
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Order Details'),
                  content: Text('Order ID: ${order['orderId']}\n'
                      'Amount: \₹${order['amount'].toStringAsFixed(2)}\n'
                      'Delivery Time: ${order['deliveryTime']} mins\n'
                      'Items: ${order['items'].join(', ')}'), // Display ordered items
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
