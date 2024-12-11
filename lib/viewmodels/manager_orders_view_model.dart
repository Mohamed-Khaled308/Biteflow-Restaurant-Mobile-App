import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:biteflow/services/firestore/order_service.dart';
import 'package:biteflow/locator.dart';
import 'package:logger/logger.dart';

class ManagerOrdersViewModel extends BaseModel {
  final Logger _logger = getIt<Logger>();
  final Manager _authenticatedManager = getIt<UserProvider>().user as Manager;
  Restaurant? _authenticatedManagerRestaurant;
  List<Order>? _orders; // to be fetched from db

  Restaurant? get authenticatedManagerRestaurant =>
      _authenticatedManagerRestaurant;
  List<Order>? get orders => _orders;

  Future<void> loadOrdersData() async {
    setBusy(true);

    await _fetchRestaurant();
    await _fetchOrders();

    setBusy(false);
  }

  Future<void> reloadOrdersData() async {
    await _fetchOrders();
    notifyListeners();
  }

  // database related methods
  Future<void> _fetchRestaurant() async {
    final restaurantResult = await getIt<RestaurantService>()
        .getRestaurantById(_authenticatedManager.restaurantId);
    if (restaurantResult.isSuccess) {
      _authenticatedManagerRestaurant = restaurantResult.data;
    } else {
      _logger.e(restaurantResult.error);
    }
  }

  Future<void> _fetchOrders() async {
    final ordersData = await getIt<OrderService>()
        .getOrders(_authenticatedManager.restaurantId);
    if(ordersData.isSuccess){
      _orders = ordersData.data;
    } else {
      _logger.e(ordersData.error);
    }
  }
}
