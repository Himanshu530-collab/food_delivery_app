import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String imageUrl; // Changed from image to imageUrl for clarity
  final double rating;
  final List<Map<String, dynamic>> menu; // Accept the menu

  RestaurantCard({
    required this.name,
    required this.imageUrl,
    required this.menu,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl), // Use Image.asset for local images
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Rating: $rating'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the restaurant menu screen
                Navigator.pushNamed(
                  context,
                  '/restaurant',
                  arguments: {
                    'name': name,
                    'menu': menu,
                  },
                );
              },
              child: Text('View Menu'),
            ),
          ),
        ],
      ),
    );
  }
}
