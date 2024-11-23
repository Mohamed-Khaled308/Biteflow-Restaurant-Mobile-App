// views/screens/home/home_view.dart

import 'package:biteflow/view-model/home_view_model.dart';
import 'package:biteflow/views/widgets/home/restaurant_card.dart';
import 'package:biteflow/views/widgets/home/restaurant_list_tile.dart';
import 'package:biteflow/views/widgets/home/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../../../viewmodels/home_view_model.dart';


class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RESTAURANTS AT',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                'Helwan',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Filter',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          backgroundColor: Color(0xFFC62828), // Ruby Red
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // Best Pick Section
                SectionTitle(title: 'Best Pick', onSeeAll: () {}),
                SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.bestPickRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = viewModel.bestPickRestaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                // All Restaurants Section
                SectionTitle(title: 'All Restaurants', onSeeAll: () {}),
                SizedBox(height: 10),
                ...viewModel.allRestaurants
                    .map((restaurant) => RestaurantListTile(
                          restaurant: restaurant,
                        ))
                    .toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
