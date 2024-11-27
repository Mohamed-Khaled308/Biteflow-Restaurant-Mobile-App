import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/home_view_model.dart';
import 'package:biteflow/views/widgets/home/restaurant_card.dart';
import 'package:biteflow/views/widgets/home/restaurant_list_tile.dart';
import 'package:biteflow/views/widgets/home/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RESTAURANTS AT',
              style: TextStyle(
                fontSize: 14,
                color: ThemeConstants.greyColor,
              ),
            ),
            Text(
              'Helwan',
              style: TextStyle(
                fontSize: 20,
                color: ThemeConstants.whiteColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Filter',
              style: TextStyle(color: ThemeConstants.whiteColor),
            ),
          ),
        ],
        backgroundColor: ThemeConstants.primaryColor,
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
              children: [
                // Best Pick Section
                const SectionTitle(title: 'Best Pick'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: viewModel.bestPickRestaurants.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.bestPickRestaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant =
                                viewModel.bestPickRestaurants[index];
                            return RestaurantCard(
                              restaurant: restaurant,
                            );
                          },
                        )
                      : const Center(
                          child: Text('No restaurants available'),
                        ),
                ),
                const SizedBox(height: 20),
                // All Restaurants Section
                const SectionTitle(title: 'All Restaurants'),
                const SizedBox(height: 10),
                viewModel.allRestaurants.isNotEmpty
                    ? Column(
                        children: viewModel.allRestaurants
                            .map(
                              (restaurant) => RestaurantListTile(
                                restaurant: restaurant,
                              ),
                            )
                            .toList(),
                      )
                    : const Center(
                        child: Text('No restaurants available'),
                      ),
              ],
            ),
    );
  }
}
