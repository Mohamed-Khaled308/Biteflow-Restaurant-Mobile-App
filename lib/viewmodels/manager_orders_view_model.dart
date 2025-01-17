import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:biteflow/services/firestore/order_service.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/core/utils/price_calculator.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:biteflow/models/order_full_clients_payment.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/order_clients_payment.dart';






class ManagerOrdersViewModel extends BaseModel {
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
    }
  }

  Future<void> _fetchOrders() async {
    final ordersData = await getIt<OrderService>()
        .getOrders(_authenticatedManager.restaurantId);
    if(ordersData.isSuccess){
      _orders = ordersData.data;
    } else {
    }
  }

  final OrderService _orderService = getIt<OrderService>();
  final UserService _userService = getIt<UserService>();
  // final ManagerOrdersViewModel _managerOrdersViewModel = getIt<ManagerOrdersViewModel>();
  Order? _selectedOrder;
  List<OrderFullClientsPayment>? _selectedOrderFullClientsPayment;
  String selectedStatus = '';
  bool _isLoadingClients = false;
  bool _clickedUpdateStatus = false;

  List<OrderFullClientsPayment>? get selectedOrderFullClientsPayment => _selectedOrderFullClientsPayment;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoadingClients => _isLoadingClients;
  bool get clickedUpdateStatus => _clickedUpdateStatus;
  void setSelectedOrder(Order order) {
    _selectedOrder = order;
    notifyListeners();
  }
  void setClickedUpdateStatus(bool value) {
    _clickedUpdateStatus = value;
    notifyListeners();
  }
  
  Future<void> loadSelectedOrderClients() async {
    _isLoadingClients = true;
    notifyListeners();

    _selectedOrderFullClientsPayment = [];
    for(OrderClientsPayment orderClientPayment in _selectedOrder!.orderClientsPayment) {
      final userData = await _userService.getUserById(orderClientPayment.userId);
      if(userData.isSuccess) {
        final client = userData.data as Client;
        _selectedOrderFullClientsPayment!.add(OrderFullClientsPayment(client: client, isPaid: orderClientPayment.isPaid, amount: orderClientPayment.amount));
      }
    }

    _isLoadingClients = false;
    notifyListeners();
  }

  Future<void> updateOrderStatus() async{
    // setBusy(true);
    setClickedUpdateStatus(true);

    /*Result<bool> res = */await _orderService.updateOrderStatus(_selectedOrder!.id, selectedStatus);
    // print(res.data);
    // print(res.error);

    await reloadOrdersData();
    
    setClickedUpdateStatus(false);
    // setBusy(false);
  }

  double getPaidAmount(){
    return PriceCalculator.getPaidAmount(selectedOrderFullClientsPayment);
  }

  double getRemainingAmount(){
    return selectedOrder!.totalAmount - getPaidAmount();
  }

}
