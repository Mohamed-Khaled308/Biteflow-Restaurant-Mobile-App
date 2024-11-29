import 'package:biteflow/locator.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/constants/firestore_collections.dart';
import 'package:biteflow/core/utils/result.dart';
import 'package:logger/logger.dart';

class RestaurantService {
  final CollectionReference _restaurants = FirebaseFirestore.instance
      .collection(FirestoreCollections.restaurantsCollection);
  final Logger _logger = getIt<Logger>();

  String generateId() {
    return _restaurants.doc().id;
  }

  Future<Result<bool>> createRestaurant(Restaurant restaurant) async {
    try {
      await _restaurants.doc(restaurant.id).set(restaurant.toJson());
      return Result(data: true);
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }

  Future<Result<Restaurant>> getRestaurantById(String restaurantId) async {
    try {
      DocumentSnapshot restaurantDoc =
          await _restaurants.doc(restaurantId).get();
      if (restaurantDoc.exists) {
        Map<String, dynamic> restaurantData =
            restaurantDoc.data() as Map<String, dynamic>;
        return Result(data: Restaurant.fromData(restaurantData));
      }
      _logger.e('Restaurant not found');
      return Result(error: 'Restaurant not found');
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> updateRestaurant(Restaurant restaurant) async {
    try {
      await _restaurants.doc(restaurant.id).update(restaurant.toJson());
      return Result(data: true);
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> deleteRestaurant(String restaurantId) async {
    try {
      await _restaurants.doc(restaurantId).delete();
      return Result(data: true);
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }



    // fetch all restaurants
  Future<Result<List<Restaurant>>> getAllRestaurants() async {
    try {
      QuerySnapshot querySnapshot = await _restaurants.get();
      List<Restaurant> restaurants = querySnapshot.docs.map((doc) {
        return Restaurant.fromData(doc.data() as Map<String, dynamic>);
      }).toList();
      return Result(data: restaurants);
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }
}
