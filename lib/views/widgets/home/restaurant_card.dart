// views/widgets/home/restaurant_card.dart

import 'package:flutter/material.dart';
import '../../../models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            restaurant.imageUrl,
            width: 160,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          Text(
            restaurant.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            restaurant.location,
            style: TextStyle(color: Colors.grey),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${restaurant.rating}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8),
              if (restaurant.isTableAvailable)
                Text(
                  'Table Available',
                  style: TextStyle(color: Colors.green),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
