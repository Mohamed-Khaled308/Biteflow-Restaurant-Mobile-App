// views/widgets/home/restaurant_card.dart

import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:flutter/material.dart';
 

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({
    required this.restaurant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: ThemeConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            restaurant.imageUrl,
            width: 160,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            restaurant.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            restaurant.location,
            style: const TextStyle(color: ThemeConstants.greyColor),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ThemeConstants.primaryColor,
                  borderRadius:
                      BorderRadius.circular(ThemeConstants.defaultBorderRadious / 3),
                ),
                child: Text(
                  '${restaurant.rating}',
                  style: const TextStyle(color: ThemeConstants.whiteColor),
                ),
              ),
              const SizedBox(width: 8),
              if (restaurant.isTableAvailable)
                const Text(
                  'Table Available',
                  style: TextStyle(color: ThemeConstants.successColor),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
