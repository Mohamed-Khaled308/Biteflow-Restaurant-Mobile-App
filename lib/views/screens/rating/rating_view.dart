import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/view-model/rating_view_model.dart';
import 'package:biteflow/views/screens/home/home_view.dart';
import 'package:biteflow/views/widgets/rating/rating_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 

class RatingView extends StatelessWidget {
  const RatingView({super.key});

  void _showRatingBottomSheet(
      BuildContext context, OrderItem item, RatingViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // To make the bottom sheet full height
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: RatingBottomSheet(
            item: item,
            onRatingSubmitted: (rating) {
              viewModel.updateRating(item, rating);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RatingViewModel>(
      create: (_) => RatingViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rate Your Dishes'),
          backgroundColor: ThemeConstants.primaryColor,
        ),
        body: Consumer<RatingViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.all(ThemeConstants.defaultPadding),
                    itemCount: viewModel.orderedItems.length,
                    itemBuilder: (context, index) {
                      final item = viewModel.orderedItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item.title),
                          subtitle: Text(
                            'Quantity: ${item.quantity}\n${item.description}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Icon(
                            Icons.star,
                            color: item.rating > 0
                                ? ThemeConstants.warningColor
                                : ThemeConstants.greyColor,
                          ),
                          onTap: () {
                            _showRatingBottomSheet(context, item, viewModel);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
                  child: ElevatedButton(
                    onPressed: () => _navigateToHome(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeConstants.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            ThemeConstants.defaultBorderRadious),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                    ),
                    child: const Text(
                      'Return to Home',
                      style: TextStyle(
                        color: ThemeConstants.whiteColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
