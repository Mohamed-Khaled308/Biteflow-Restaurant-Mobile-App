import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/dummy_data/manager_list_of_orders.dart';

class ManagerOrdersViewModel extends BaseModel {
  final String _restaurantName = 'Karam El Sham'; // to be fetched from db/auth
  final List<Order> _orders = managerListOfOrders; // to be fetched from db
  Order? selectedOrder;
  List<Client>?
      _selectedOrderClients; // to be fetched from db (after selecting an order)
  String selectedStatus =
      ''; // the status selected by the manager to update the order status

  String get restaurantName => _restaurantName;
  List<Order> get orders => _orders;
  List<Client>? get selectedOrderClients => _selectedOrderClients;

  void loadSelectedOrderClients() {
    _selectedOrderClients =
        orderClients; // to be fetched from db based on selected order
    // notifyListeners();
  }

  void updateOrderStatus() {
    // update the satus of _selectedOrder to _selectedStatus in the db
    // notifyListeners();
  }
  void tmp() {
    // notifyListeners();
    // selectedOrder;
    // selectedStatus;
  }
}
