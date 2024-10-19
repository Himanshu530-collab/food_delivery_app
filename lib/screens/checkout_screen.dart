import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_provider.dart'; // Ensure this import is correct.
import '../widgets/home_button.dart'; // Adjust the path as necessary.
import 'payment_details_screen.dart'; // Ensure this import is correct.

class CheckoutScreen extends StatefulWidget {
  final double totalAmount; // Accept total amount

  CheckoutScreen({required this.totalAmount}); // Constructor

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Define the payment method options
  String _selectedPaymentMethod = 'Wallet';

  // List of payment methods
  final List<String> _paymentMethods = [
    'Wallet',
    'UPI',
    'Credit Card',
    'Debit Card',
    'PayPal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        actions: [
          HomeButton(), // Add HomeButton here
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display total amount
            Text(
              'Total Amount: \₹${widget.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),

            // Loop through the payment methods and display them as radio buttons
            Column(
              children: _paymentMethods.map((method) {
                return RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 30.0),

            // Confirm Payment button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment confirmation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentDetailsScreen(
                        paymentMethod: _selectedPaymentMethod,
                        amountToPay:
                            widget.totalAmount, // Pass the total amount
                      ),
                    ),
                  );
                },
                child: Text('Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
