import 'package:biteflow/models/order_full_clients_payment.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/services/firestore/order_service.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
import 'package:biteflow/models/order_clients_payment.dart';
import 'package:biteflow/core/utils/price_calculator.dart';


class ManagerOrdersDetailsViewModel extends BaseModel {

  final OrderService _orderService = getIt<OrderService>();
  final UserService _userService = getIt<UserService>();
  final ManagerOrdersViewModel _managerOrdersViewModel = getIt<ManagerOrdersViewModel>();
  Order? _selectedOrder;
  List<OrderFullClientsPayment>? _selectedOrderFullClientsPayment;
  String selectedStatus = '';
  bool _isLoadingClients = false;

  List<OrderFullClientsPayment>? get selectedOrderFullClientsPayment => _selectedOrderFullClientsPayment;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoadingClients => _isLoadingClients;
  void setSelectedOrder(Order order) {
    _selectedOrder = order;
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
    setBusy(true);

    await _orderService.updateOrderStatus(_selectedOrder!.id, selectedStatus);
    await _managerOrdersViewModel.reloadOrdersData();
    
    setBusy(false);
  }

  double getPaidAmount(){
    return PriceCalculator.getPaidAmount(selectedOrderFullClientsPayment);
  }

  double getRemainingAmount(){
    return selectedOrder!.totalAmount - getPaidAmount();
  }

}