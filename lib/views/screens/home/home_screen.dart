import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/home_view_model.dart';
import 'package:biteflow/views/screens/menu/menu_view.dart';
import 'package:biteflow/views/widgets/home/promotional_offer_card.dart';
import 'package:biteflow/views/widgets/home/restaurant_card.dart';
import 'package:biteflow/views/widgets/home/restaurant_list_tile.dart';
import 'package:biteflow/views/widgets/home/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/locator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final NavigationService navigationService = getIt<NavigationService>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RESTAURANTS AT',
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeConstants.greyColor,
              ),
            ),
            Text(
              'Helwan',
              style: TextStyle(
                fontSize: 20.sp,
                color: ThemeConstants.whiteColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Filter',
              style: TextStyle(
                color: ThemeConstants.whiteColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
        backgroundColor: ThemeConstants.primaryColor,
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(ThemeConstants.defaultPadding.w),
              children: [
                if (viewModel.promotionalOffers.isNotEmpty) ...[
                  const SectionTitle(title: 'Special Offers'),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 170.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: viewModel.promotionalOffers.length,
                      itemBuilder: (context, index) {
                        final offer = viewModel.promotionalOffers[index];
                        return PromotionalOfferCard(
                          offer: offer,
                          onTap: () {
                            navigationService.navigateTo(
                              MenuView(restaurantId: offer.restaurantId),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
                const SectionTitle(title: 'Best Pick'),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 180.h,
                  child: viewModel.bestPickRestaurants.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.bestPickRestaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant =
                                viewModel.bestPickRestaurants[index];
                            return GestureDetector(
                              onTap: () {
                                navigationService.navigateTo(
                                  MenuView(restaurantId: restaurant.id),
                                );
                              },
                              child: RestaurantCard(
                                restaurant: restaurant,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            'No restaurants available',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                ),
                // SizedBox(height: 20.h),
                const SectionTitle(title: 'All Restaurants'),
                SizedBox(height: 10.h),
                viewModel.allRestaurants.isNotEmpty
                    ? Column(
                        children: viewModel.allRestaurants
                            .map(
                              (restaurant) => Hero(
                                tag: restaurant.id,
                                child: RestaurantListTile(
                                  restaurant: restaurant,
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : Center(
                        child: Text(
                          'No restaurants available',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
              ],
            ),
    );
  }
}
