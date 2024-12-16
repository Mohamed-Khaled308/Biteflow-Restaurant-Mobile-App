import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/widgets/dialogues/action_dialogue.dart';
import 'package:flutter/material.dart';
import '../../theme/biteflow_theme.dart';
import 'package:provider/provider.dart';

class MenuCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String categoryId;
  final String restaurantId;
  final double discountPercentage;

  const MenuCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.categoryId,
    required this.restaurantId,
    required this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();

    // Accessing the current theme for colors and text styles
    final theme =
        BiteflowTheme.lightTheme(context); // Get light theme from AppTheme

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
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).secondaryHeaderColor,
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
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [

                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style:  TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
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

            const SizedBox(height: 10),
            // Add to Cart Button
            GestureDetector(
              onTap: () {
                if (viewModel.isCartEmpty ||
                    viewModel.cart!.restaurantId == restaurantId) {
                  viewModel.addItem(
                      menuItem: MenuItem(
                          id: DateTime.now().toString(),
                          title: title,
                          price: price,
                          imageUrl: imageUrl,
                          description: description,
                          rating: rating,
                          categoryId: categoryId,
                          restaurantId: restaurantId,
                          discountPercentage: discountPercentage));
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ActionDialogue(
                        title: 'Switch Restaurant?',
                        body:
                            'Adding this item will clear your current cart. Do you want to continue?',
                        actionLabel: 'Yes, Proceed',
                        onAction: () {
                          viewModel.addItem(
                            menuItem: MenuItem(
                              id: DateTime.now().toString(),
                              title: title,
                              price: price,
                              imageUrl: imageUrl,
                              description: description,
                              rating: rating,
                              categoryId: categoryId,
                              restaurantId: restaurantId,
                              discountPercentage: discountPercentage,
                            ),
                          );
                          // viewModel.leaveCart();
                        },
                      );
                    },
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Add to Cart',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).secondaryHeaderColor,
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
