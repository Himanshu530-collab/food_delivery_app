import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_provider.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final String paymentMethod;
  final double amountToPay;

  PaymentDetailsScreen({
    required this.paymentMethod,
    required this.amountToPay,
  });

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Method: ${widget.paymentMethod}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Amount to Pay: \₹${widget.amountToPay.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),

              // Input fields based on the payment method
              if (widget.paymentMethod == 'Credit Card' ||
                  widget.paymentMethod == 'Debit Card') ...[
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card number';
                    } else if (value.length < 12 || value.length > 19) {
                      return 'Card number must be between 12 to 19 digits';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expiry date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter CVV';
                    } else if (value.length != 3) {
                      return 'CVV must be 3 digits';
                    }
                    return null;
                  },
                ),
              ] else if (widget.paymentMethod == 'UPI') ...[
                TextFormField(
                  controller: _upiIdController,
                  decoration: InputDecoration(labelText: 'UPI ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter UPI ID';
                    } else if (!RegExp(r'^[\d]{10}@upi$').hasMatch(value)) {
                      return 'UPI ID must be of the format 10 digits followed by @upi';
                    }
                    return null;
                  },
                ),
              ],

              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Generate a random delivery time between 20 and 60 minutes
                    int deliveryTime = Random().nextInt(41) + 20;

                    // Create a random order ID for tracking
                    String orderId = "ORDER${Random().nextInt(10000)}";
                    // Generate a unique transaction ID
                    String transactionId = "TXN${Random().nextInt(10000)}";

                    // Handle wallet payment
                    if (widget.paymentMethod == 'Wallet') {
                      // Check if there is enough balance
                      if (cart.hasSufficientBalance(widget.amountToPay)) {
                        // Deduct from wallet
                        cart.deductFromWallet(widget.amountToPay);
                      } else {
                        // Show insufficient balance message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Insufficient wallet balance!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return; // Stop processing further if insufficient balance
                      }
                    }

                    // Update order history with the random delivery time
                    cart.addOrderToHistory(
                        orderId, widget.amountToPay, deliveryTime);

                    // Add transaction to wallet transaction history
                    cart.addWalletTransaction(
                        transactionId, orderId, widget.amountToPay);

                    // Clear the cart after placing the order
                    cart.clearCart();

                    // Show confirmation message with the random delivery time
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Order confirmed! It will reach you in $deliveryTime minutes.',
                        ),
                        duration: Duration(seconds: 4),
                      ),
                    );

                    // Navigate back to the home screen after confirmation
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }
                },
                child: Text('Confirm Payment'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cancel and go back
                },
                child: Text('Cancel Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
