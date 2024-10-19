import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_provider.dart';
import '../widgets/home_button.dart'; // Adjust the path as necessary

class WalletTransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet Transactions'),
        actions: [
          HomeButton(), // Add HomeButton here
        ],
      ),
      body: ListView.builder(
        itemCount: cart.walletTransactions.length,
        itemBuilder: (context, index) {
          final transaction = cart.walletTransactions[index];
          return ListTile(
            title: Text('Transaction ID: ${transaction['transactionId']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: ${transaction['orderId']}'),
                Text(
                    'Amount Paid: \₹${transaction['amount'].toStringAsFixed(2)}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
