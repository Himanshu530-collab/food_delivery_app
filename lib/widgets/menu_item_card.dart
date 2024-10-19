import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_provider.dart';

class MenuItemCard extends StatelessWidget {
  final String dishName;
  final double price;
  final String imagePath;

  MenuItemCard({
    required this.dishName,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(dishName),
        subtitle: Text("\₹$price"),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () {
            // Pass the image path along with the name and price
            Provider.of<CartProvider>(context, listen: false)
                .addItem(dishName, price, imagePath);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$dishName added to cart'),
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        ),
      ),
    );
  }
}
