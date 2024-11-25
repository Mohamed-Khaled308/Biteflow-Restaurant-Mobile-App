import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:flutter/material.dart';
 

class RestaurantListTile extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantListTile({
    required this.restaurant,
    super.key,
  });

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
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: ThemeConstants.warningColor, size: 16),
                const SizedBox(width: 4),
                Text('${restaurant.rating}'),
                const SizedBox(width: 8),
                Text('${restaurant.reviewCount}+ Ratings'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
