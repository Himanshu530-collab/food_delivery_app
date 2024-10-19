import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/cart_provider.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/payment_details_screen.dart';
import 'screens/restaurant_menu_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/wallet_transaction_history_screen.dart';
import 'screens/restaurants.dart'; // Ensure this path is correct

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Food Delivery App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/home': (context) => HomeScreen(),
          '/cart': (context) => CartScreen(),
          '/checkout': (context) {
            final cart = Provider.of<CartProvider>(context);
            return CheckoutScreen(totalAmount: cart.totalPrice);
          },
          '/restaurant': (context) {
            // Make sure we get arguments properly
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            final restaurantName = args['name'];
            final restaurant = restaurants
                .firstWhere((rest) => rest['name'] == restaurantName);

            return RestaurantMenuScreen(
              restaurantName: restaurant['name'],
              menuItems: restaurant['menu'], // Pass the menu
            );
          },
          '/payment': (context) => PaymentDetailsScreen(
                paymentMethod: 'Wallet',
                amountToPay: Provider.of<CartProvider>(context).totalPrice,
              ),
          '/orderHistory': (context) => OrderHistoryScreen(),
          '/walletTransactions': (context) => WalletTransactionHistoryScreen(),
          '/orders': (context) => OrderHistoryScreen(),
        },
      ),
    );
  }
}
