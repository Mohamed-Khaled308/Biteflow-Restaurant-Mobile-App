import 'package:biteflow/viewmodels/base_model.dart';
// import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
// import 'package:biteflow/services/firestore/order_service.dart';
import 'package:biteflow/locator.dart';

class ManagerOffersViewModel extends BaseModel {
  final Manager _authenticatedManager = getIt<UserProvider>().user as Manager;
  Restaurant? _authenticatedManagerRestaurant;

  Restaurant? get authenticatedManagerRestaurant =>
      _authenticatedManagerRestaurant;

  Future<void> loadOrdersData() async {
    setBusy(true);

    await _fetchRestaurant();
    // await _fetchOrders();

    setBusy(false);
  }

  // Future<void> reloadOrdersData() async {
  //   await _fetchOrders();
  //   notifyListeners();
  // }

  // database related methods
  Future<void> _fetchRestaurant() async {
    final restaurantResult = await getIt<RestaurantService>()
        .getRestaurantById(_authenticatedManager.restaurantId);
    if (restaurantResult.isSuccess) {
      _authenticatedManagerRestaurant = restaurantResult.data;
    } else {
    }
  }

  // Future<void> _fetchOrders() async {
  //   final ordersData = await getIt<OrderService>()
  //       .getOrders(_authenticatedManager.restaurantId);
  //   if (ordersData.isSuccess) {
  //     _orders = ordersData.data;
  //   } else {
  //     _logger.e(ordersData.error);
  //   }
  // }
}
