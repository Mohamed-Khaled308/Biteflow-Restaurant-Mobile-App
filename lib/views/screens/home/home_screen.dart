import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/firebase_notifications.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/viewmodels/home_view_model.dart';
import 'package:biteflow/views/screens/client_offers/client_offers_view.dart';
import 'package:biteflow/views/screens/cart/cart_view.dart';
import 'package:biteflow/views/screens/menu/menu_view.dart';
import 'package:biteflow/views/widgets/cart/cart_icon.dart';
import 'package:biteflow/views/widgets/home/promotional_offer_card.dart';
import 'package:biteflow/views/widgets/home/restaurant_card.dart';
import 'package:biteflow/views/widgets/home/restaurant_list_tile.dart';
import 'package:biteflow/views/widgets/home/section_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Delay provider access after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      // print("USER: " + user.toString());
      // Initialize Firebase notifications with the user ID
      if (user != null) {
        FirebaseNotifications().initNotifications(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final cartViewModel = context.watch<CartViewModel>();
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
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ],
        ),
        iconTheme:  IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
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
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.local_offer),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(context
                          .watch<UserProvider>()
                          .user
                          ?.id) // Use the user's ID here
                      .snapshots(),
                  builder: (context, snapshot) {
                    // Handle loading state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(); // Return an empty widget while loading
                    }

                    // Handle errors or cases where the snapshot is invalid
                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        !snapshot.data!.exists) {
                      return const SizedBox(); // No badge if there's an error or no data
                    }

                    // Safely cast the snapshot data to a Map<String, dynamic>
                    final userData =
                        snapshot.data?.data() as Map<String, dynamic>?;
                    final unseenOffers = userData?['unseenOfferCount'] ?? 0;

                    if (unseenOffers > 0) {
                      return Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$unseenOffers',
                            style:  TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                      );
                    }

                    return const SizedBox(); // No badge if unseenOffers is 0
                  },
                ),
              ],
            ),
            onPressed: () {
              navigationService.navigateTo(const ClientOffersView());
            },
          ),
          Visibility(
            visible: !cartViewModel.isCartEmpty,
            child: const CartIcon(),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
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
