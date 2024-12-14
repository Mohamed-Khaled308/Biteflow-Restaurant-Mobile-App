import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/core/utils/result.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/models/promotional_offer.dart';
import 'package:biteflow/models/restaurant.dart';
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

        _offerService.getRestaurantOffers(manager.restaurantId).then((result) {
          if (result.error == null) {
            offers = result.data!;
            notifyListeners();
          }
        });
      }

    }
    setBusy(false);
  }

  Future<Result<bool>> createOffer({
    required String title,
    required String description,
    required String imageUrl,
    required DateTime startDate,
    required DateTime endDate,
    required double discount,
  }) async {
    if (_userProvider.currentUser?.role != 'Manager') {
      return Result(error: 'Not authorized: User is not a manager');
    }

    final manager = _userProvider.currentUser as Manager;

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
    );

    offers.add(offer);
    notifyListeners();

    return await _offerService.createOffer(offer);
  }
}
