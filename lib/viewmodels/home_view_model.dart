import 'package:biteflow/locator.dart';
import 'package:biteflow/models/promotional_offer.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/services/firestore/promotional_offer_service.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart'; 
import 'package:biteflow/viewmodels/base_model.dart';

class HomeViewModel extends BaseModel {
  List<Restaurant> bestPickRestaurants = [];
  List<Restaurant> allRestaurants = [];
  List<PromotionalOffer> promotionalOffers = [];
  
  final _restaurantService = getIt<RestaurantService>();
  final _promotionalOfferService = getIt<PromotionalOfferService>();

  HomeViewModel() {
    loadData();  // Changed from loadRestaurants() to loadData()
  }

  bool get isBusy => busy;

  Future<void> loadData() async {
    setBusy(true);
    
    // Load both restaurants and offers
    await Future.wait([
      _loadRestaurants(),
      _loadPromotionalOffers(),
    ]);
    
    setBusy(false);
    notifyListeners();
  }

  Future<void> _loadRestaurants() async {
    var result = await _restaurantService.getAllRestaurants();
    if (result.error != null) {
    } else {
      allRestaurants = result.data!;
      
      List<Restaurant> sortedRestaurants = List.from(allRestaurants);
      sortedRestaurants.sort((a, b) => b.rating.compareTo(a.rating));
      
      bestPickRestaurants = sortedRestaurants.take(5).toList();
    }
  }

  Future<void> _loadPromotionalOffers() async {
    var result = await _promotionalOfferService.getAllActiveOffers();
    if (result.error != null) {
    } else {
      promotionalOffers = result.data!;
    }
  }
}