import 'package:flutter/material.dart';
import '../../theme/biteflow_theme.dart';

class MenuItemGrid extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double discountPercentage;
  final VoidCallback onTap;

  const MenuItemGrid({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onTap,
    required this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = BiteflowTheme.lightTheme(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 180, // Ensuring image height for consistency
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              // Title Section
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Consistent font size for title
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8), // Space between title and price

              // Price Section
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Check if there's a discount and show old price if applicable
                  if (discountPercentage > 0)
                    Row(
                      children: [
                        Text(
                          price.toStringAsFixed(2), // Old price
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            decoration:
                                TextDecoration.lineThrough, // Dashed effect
                          ),
                        ),

                        const SizedBox(
                            width: 8), // Space between old and new prices
                      ],
                    ),

                  // New discounted price
                  Row(
                    children: [
                      Text(
                        (price * (1 - discountPercentage / 100))
                            .toStringAsFixed(2), // New price
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: discountPercentage > 0
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).secondaryHeaderColor, // Highlighted color for the new price
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('\$'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
