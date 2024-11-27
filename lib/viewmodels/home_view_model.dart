import 'package:biteflow/locator.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart'; 
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:logger/logger.dart';

class HomeViewModel extends BaseModel {
  List<Restaurant> bestPickRestaurants = [];
  List<Restaurant> allRestaurants = [];
  final _restaurantService = getIt<RestaurantService>();
  final Logger _logger = getIt<Logger>();

  HomeViewModel() {
    loadRestaurants();
  }

  bool get isBusy => busy;


  Future<void> loadRestaurants() async {
    setBusy(true);
    var result = await _restaurantService.getAllRestaurants();
    if (result.error != null) {
      _logger.e('Error fetching restaurants: .${result.error}');


    } else {
      allRestaurants = result.data!;
      
      List<Restaurant> sortedRestaurants = List.from(allRestaurants);
      sortedRestaurants.sort((a, b) => b.rating.compareTo(a.rating));
      
      bestPickRestaurants = sortedRestaurants.take(5).toList();
    }
    
    setBusy(false);
    notifyListeners();
  }
}
