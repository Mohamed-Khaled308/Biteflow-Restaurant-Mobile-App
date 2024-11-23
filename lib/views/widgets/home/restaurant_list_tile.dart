// views/widgets/home/restaurant_list_tile.dart

import 'package:flutter/material.dart';
import '../../../models/restaurant.dart';

class RestaurantListTile extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantListTile({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          restaurant.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(restaurant.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(restaurant.description),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: const Color.fromARGB(255, 86, 84, 65), size: 16),
                SizedBox(width: 4),
                Text('${restaurant.rating}'),
                SizedBox(width: 8),
                Text('${restaurant.reviewCount}+ Ratings'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
