import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/firebase_notifications.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/viewmodels/home_view_model.dart';
import 'package:biteflow/views/screens/client_offers/client_offers_view.dart';
import 'package:biteflow/viewmodels/mode_view_model.dart';
import 'package:biteflow/views/screens/cart/cart_view.dart';
import 'package:biteflow/views/screens/menu/menu_view.dart';
import 'package:biteflow/views/widgets/home/restaurant_card.dart';
import 'package:biteflow/views/widgets/home/restaurant_list_tile.dart';
import 'package:biteflow/views/widgets/home/section_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/locator.dart';
import 'package:cloud_functions/cloud_functions.dart'; // Import Cloud Functions

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

  // Function to trigger the callable function for split request notifications
  Future<void> sendSplitRequestNotification(
      List<String> userIds, String title, String message) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('sendSplitRequestNotification');
      await callable.call({
        'userIds': userIds, // List of user IDs to send notification to
        'title': title, // Title of the notification
        'message': message, // Message of the notification
      });

      // Handle the result
      // if (result.data['success']) {
      //   print('Split request notification sent successfully');
      // } else {
      //   print(
      //       'Failed to send split request notification: ${result.data['message']}');
      // }
    } catch (e) {
      // print('Error calling the Firebase function: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final cartViewModel = context.read<CartViewModel>();
    final NavigationService navigationService = getIt<NavigationService>();
    final modeViewModel = getIt<ModeViewModel>();

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
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_sharp
                  : Icons.dark_mode_sharp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: () {
              modeViewModel.toggleThemeMode();
              
            },
          ),
          
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Scan QR Code to be added to cart',
                      textAlign: TextAlign.center,
                    ),
                    content: Container(
                      height: 300,
                      width: 300,
                      alignment: Alignment.center,
                      child: MobileScanner(
                        controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.normal,
                        ),
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          for (Barcode barcode in barcodes) {
                            if (barcode.rawValue != null) {
                              cartViewModel
                                  .startListeningToCart(barcode.rawValue!);
                              getIt<NavigationService>()
                                  .navigateAndReplace(const CartView());
                            }
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.camera_alt_rounded)),
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
                return const CircularProgressIndicator();
              }

              // Handle errors
              if (snapshot.hasError) {
                return const Icon(Icons.local_offer);
              }

              // Handle case where the snapshot doesn't contain any data
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Icon(Icons.local_offer);
              }

              // Safely cast the snapshot data to a Map<String, dynamic>
              final userData = snapshot.data?.data() as Map<String, dynamic>?;
              if (userData == null) {
                return const Icon(
                    Icons.local_offer); // In case the data is null
              }

              final unseenOffers = userData['unseenOfferCount'] ?? 0;

              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.local_offer),
                    if (unseenOffers > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$unseenOffers',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  navigationService.navigateTo(const ClientOffersView());
                },
              );
            },
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
