import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_provider.dart'; // Adjust the path if necessary

class PaymentDetailsInputScreen extends StatefulWidget {
  final String paymentMethod;
  final double amount;

  PaymentDetailsInputScreen({
    required this.paymentMethod,
    required this.amount,
  });

  @override
  _PaymentDetailsInputScreenState createState() =>
      _PaymentDetailsInputScreenState();
}

class _PaymentDetailsInputScreenState extends State<PaymentDetailsInputScreen> {
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
    final cart = Provider.of<CartProvider>(context); // Access CartProvider

    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Payment Details'),
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

              // Add input fields based on payment method
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Assuming payment details are valid and payment is successful
                    // Deduct from wallet if wallet is the payment method
                    if (widget.paymentMethod == 'Wallet') {
                      cart.deductFromWallet(widget.amount);
                    }

                    // Generate a unique order ID and delivery time
                    final String orderId =
                        'order_${DateTime.now().millisecondsSinceEpoch}';
                    final int deliveryTime =
                        30; // Specify delivery time in minutes

                    // Add order to history with item details
                    cart.addOrderToHistory(
                        orderId, widget.amount, deliveryTime);

                    // Clear the cart after placing the order
                    cart.clearCart();

                    // Show confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Payment of \₹${widget.amount.toStringAsFixed(2)} confirmed. Your order is booked!'),
                        duration: Duration(seconds: 4),
                      ),
                    );

                    // Navigate to the Order History screen after a short delay
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.pushNamed(context,
                          '/orderHistory'); // Navigate to order history screen
                    });
                  }
                },
                child: Text('Confirm Payment Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
