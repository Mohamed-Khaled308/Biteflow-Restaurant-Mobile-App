import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/core/utils/result.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/models/promotional_offer.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/services/firestore/menu_item_service.dart';
import 'package:biteflow/services/firestore/promotional_offer_service.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';

class ManagerPromotionalOffersViewModel extends BaseModel {
  final _offerService = getIt<PromotionalOfferService>();
  final _restaurantService = getIt<RestaurantService>();
  final _userProvider = getIt<UserProvider>();
  List<PromotionalOffer> offers = [];
  Restaurant? restaurant;

  ManagerPromotionalOffersViewModel() {
    _initializeData();
  }

  bool get isBusy => busy;

  Future<void> _initializeData() async {
    setBusy(true);
    if (_userProvider.currentUser?.role == 'Manager') {
      final manager = _userProvider.currentUser as Manager;

      // Load restaurant data
      final restaurantResult =
          await _restaurantService.getRestaurantById(manager.restaurantId);
      if (restaurantResult.error == null) {
        restaurant = restaurantResult.data;
        await _refreshOffers(manager.restaurantId);
      }

    }
    setBusy(false);
  }

  Future<void> _refreshOffers(String restaurantId) async {
    final result = await _offerService.getRestaurantOffers(restaurantId);
    if (result.isSuccess && result.data != null) {
      offers = result.data!;
      notifyListeners();
    }
  }

  Future<Result<bool>> createOffer({
    required String title,
    required String description,
    required String imageUrl,
    required DateTime startDate,
    required DateTime endDate,
    required double discount, // e.g., 0.2 for 20% off
  }) async {
    if (_userProvider.currentUser?.role != 'Manager') {
      return Result(error: 'Not authorized: User is not a manager');
    }

    setBusy(true);
    final manager = _userProvider.currentUser as Manager;

    // 1. Disable all currently active offers
    final activeOffersResult = await _offerService.getRestaurantOffers(manager.restaurantId);
    if (activeOffersResult.isSuccess && activeOffersResult.data != null) {
      for (var activeOffer in activeOffersResult.data!) {
        if (activeOffer.isActive) {
          // Set isActive = false
          var updatedOffer = PromotionalOffer(
            id: activeOffer.id,
            restaurantId: activeOffer.restaurantId,
            restaurantName: activeOffer.restaurantName,
            title: activeOffer.title,
            description: activeOffer.description,
            imageUrl: activeOffer.imageUrl,
            startDate: activeOffer.startDate,
            endDate: activeOffer.endDate,
            discount: activeOffer.discount,
            isActive: false,
          );
          await _offerService.updateOffer(updatedOffer);
        }
      }
    }

    // 2. Create the new active offer
    final offer = PromotionalOffer(
      id: _offerService.generateId(),
      restaurantId: manager.restaurantId,
      restaurantName: restaurant?.name ?? '',
      title: title,
      description: description,
      imageUrl: imageUrl,
      startDate: startDate,
      endDate: endDate,
      discount: discount,
      isActive: true,
    );

    // 3. Update all menu items with the new discount
    final menuItemService = getIt<MenuItemService>();
    final menuItemsResult = await menuItemService.getMenuItems(manager.restaurantId);
    if (menuItemsResult.isSuccess && menuItemsResult.data != null) {
      for (var item in menuItemsResult.data!) {
        // Keep price same, just set discountPercentage
        final updatedItem = item.copyWith(discountPercentage: discount);
        await menuItemService.updateMenuItem(updatedItem);
      }
    }

    // 4. Save the new offer to the database
    final result = await _offerService.createOffer(offer);
    if (result.isSuccess) {
      // Re-fetch the offers to ensure UI is updated with the latest data
      await _refreshOffers(manager.restaurantId);
    }

    setBusy(false);
    return result;
  }
}
