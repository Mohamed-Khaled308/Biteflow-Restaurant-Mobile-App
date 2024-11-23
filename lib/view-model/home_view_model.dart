
import 'package:biteflow/dummy_data/dummy_restaurants.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:flutter/foundation.dart';
 
// import '../data/dummy_restaurants.dart';


class HomeViewModel extends ChangeNotifier {
  List<Restaurant> bestPickRestaurants = [];
  List<Restaurant> allRestaurants = [];

  HomeViewModel() {
    loadRestaurants();
  }

  void loadRestaurants() {
    bestPickRestaurants = bestPickRestaurantsDate;
    allRestaurants = allRestaurantsData;
    notifyListeners();
  }


  Future<void> fetchRestaurantsFromDatabase() async {
  //    // TODO: fectch the data from the database

  }
}
