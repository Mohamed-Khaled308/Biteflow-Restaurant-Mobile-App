import 'package:biteflow/locator.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/screens/cart/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../theme/app_theme.dart';
import 'package:provider/provider.dart';

class MenuCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String categoryId;
  final String restaurantId;

  const MenuCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.categoryId,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();

    // Accessing the current theme for colors and text styles
    final theme = AppTheme.lightTheme(context); // Get light theme from AppTheme

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with title and rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Rating
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      RatingBarIndicator(
                        rating: rating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 16,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Center Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            // Description
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 18,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            // Price Section
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  price.toStringAsFixed(2),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 4),
                Image.asset(
                  'assets/images/EGP.png',
                  width: 22,
                  height: 22,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Add to Cart Button
            GestureDetector(
              onTap: () {
                viewModel.addItemToCart(
                  OrderItem(
                      id: DateTime.now().toString(),
                      title: title,
                      imageUrl: imageUrl,
                      price: price,
                      rating: rating,
                      quantity: 1,
                      notes: '',
                      description: description,
                      categoryId: categoryId,
                      restaurantId: restaurantId),
                );
                getIt<NavigationService>().navigateAndReplace(const CartView());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Add to Cart',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
