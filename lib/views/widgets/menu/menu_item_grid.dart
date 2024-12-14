import 'package:flutter/material.dart';
import '../../theme/biteflow_theme.dart';

class MenuItemGrid extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final VoidCallback onTap;

  const MenuItemGrid({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.onTap,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price.toStringAsFixed(2),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Image.asset(
                    'assets/images/EGP.png',
                    width: 22,
                    height: 22,
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
