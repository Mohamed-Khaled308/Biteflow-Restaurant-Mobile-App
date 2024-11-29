import 'package:biteflow/services/firestore/user_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/services/firestore/order_service.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';

class ManagerOrdersDetailsViewModel extends BaseModel {

  final OrderService _orderService = getIt<OrderService>();
  final UserService _userService = getIt<UserService>();
  final ManagerOrdersViewModel _managerOrdersViewModel = getIt<ManagerOrdersViewModel>();
  Order? _selectedOrder;
  List<Client>? _selectedOrderClients;
  String selectedStatus = '';
  bool _isLoadingClients = false;

  List<Client>? get selectedOrderClients => _selectedOrderClients;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoadingClients => _isLoadingClients;
  void setSelectedOrder(Order order) {
    _selectedOrder = order;
    notifyListeners();
  }
  
  Future<void> loadSelectedOrderClients() async {
    _isLoadingClients = true;
    notifyListeners();
    
    _selectedOrderClients = [];
    for(String clientId in _selectedOrder!.userIDs) {
      final userData = await _userService.getUserById(clientId);
      if(userData.isSuccess) {
        final client = userData.data as Client;
        _selectedOrderClients!.add(client);
      }
    }

    _isLoadingClients = false;
    notifyListeners();
  }

  Future<void> updateOrderStatus() async{
    setBusy(true);

    await _orderService.updateOrderStatus(_selectedOrder!.id, selectedStatus);
    await _managerOrdersViewModel.reloadOrdersData();
    
    setBusy(false);
  }
}