import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/viewmodels/home_view_model.dart';
import 'package:biteflow/views/screens/cart/cart_view.dart';
import 'package:biteflow/views/screens/menu/menu_view.dart';
import 'package:biteflow/views/widgets/home/restaurant_card.dart';
import 'package:biteflow/views/widgets/home/restaurant_list_tile.dart';
import 'package:biteflow/views/widgets/home/section_title.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/locator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final cartViewModel = context.read<CartViewModel>();
    final NavigationService navigationService = getIt<NavigationService>();

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
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    final MobileScannerController scannerController =
                        MobileScannerController(
                      detectionSpeed: DetectionSpeed.normal,
                    );

                    return AlertDialog(
                      title: const Text(
                        'Scan QR Code to be added to cart',
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        height: 300,
                        width: 300,
                        alignment: Alignment.center,
                        child: MobileScanner(
                          controller: scannerController,
                          onDetect: (capture) {
                            final List<Barcode> barcodes = capture.barcodes;
                            for (Barcode barcode in barcodes) {
                              if (barcode.rawValue != null) {
                                cartViewModel.joinCart(barcode.rawValue!);
                                scannerController.dispose();
                                getIt<NavigationService>()
                                    .navigateAndReplace(const CartView());
                              }
                            }
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            scannerController.dispose();
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.camera_alt_rounded)),
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
                              (restaurant) => GestureDetector(
                                onTap: () {
                                  navigationService.navigateTo(
                                    MenuView(restaurantId: restaurant.id),
                                  );
                                },
                                child: Hero(
                                  tag: restaurant.id,
                                  child: RestaurantListTile(
                                    restaurant: restaurant,
                                  ),
                                ),
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
