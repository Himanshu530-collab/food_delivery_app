import 'package:flutter/material.dart'; // Necessary for ChangeNotifier
import 'package:provider/provider.dart'; // Required for provider functionality

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> items = [];
  double totalPrice = 0.0;
  double walletBalance = 100.0; // Default wallet balance

  // Order history and wallet transaction logs
  List<Map<String, dynamic>> orderHistory = [];
  List<Map<String, dynamic>> walletTransactions = [];

  // Add item to cart
  void addItem(String name, double price, String image) {
    int index = items.indexWhere((item) => item['name'] == name);
    if (index != -1) {
      items[index]['quantity'] += 1;
    } else {
      items.add({'name': name, 'price': price, 'quantity': 1, 'image': image});
    }
    totalPrice += price;
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(String name) {
    int index = items.indexWhere((item) => item['name'] == name);
    if (index != -1) {
      if (items[index]['quantity'] > 1) {
        items[index]['quantity'] -= 1; // Decrease quantity
        totalPrice -= items[index]['price']; // Adjust total price
      } else {
        totalPrice -= items[index]['price']; // Adjust total price
        items.removeAt(index); // Remove item if quantity is 0
      }
      notifyListeners();
    }
  }

  // Clear cart after order
  void clearCart() {
    items.clear();
    totalPrice = 0.0;
    notifyListeners();
  }

  // Get total number of items
  int get totalItems =>
      items.fold(0, (sum, item) => sum + (item['quantity'] as int));

  // Check if the wallet has sufficient balance
  bool hasSufficientBalance(double amount) {
    return walletBalance >= amount;
  }

  // Deduct from wallet
  void deductFromWallet(double amount) {
    if (hasSufficientBalance(amount)) {
      walletBalance -= amount;
      notifyListeners();
    }
  }

  // Add order to history
  void addOrderToHistory(String orderId, double amountPaid, int deliveryTime) {
    orderHistory.add({
      'orderId': orderId,
      'amount': amountPaid,
      'deliveryTime': deliveryTime,
      'items': List.from(items), // Save ordered items details
    });
    notifyListeners();
  }

  // Add wallet transaction
  void addWalletTransaction(
      String transactionId, String orderId, double amountPaid,
      {String paymentMethod = 'Unknown'}) {
    walletTransactions.add({
      'orderId': orderId,
      'amount': amountPaid,
      'transactionId': transactionId, // New field for transaction ID
      'paymentMethod': paymentMethod, // Include payment method
    });
    notifyListeners();
  }

  // Add balance to wallet
  void addWalletBalance(double amount) {
    walletBalance += amount;
    notifyListeners();
  }
}
