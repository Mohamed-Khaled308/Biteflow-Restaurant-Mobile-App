import 'package:biteflow/view-model/base_mode.dart';
import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/dummy_data/manager_list_of_orders.dart';

class ManagerOrdersViewModel extends BaseModel{
  
  final String _restaurantName = 'Karam El Sham'; // to be fetched from db/auth
  final List<Order> _orders = manager_list_of_orders; // to be fetched from db
  Order? _selectedOrder;
  List<Client>? _selectedOrderClients; // to be fetched from db (after selecting an order)
  String _selectedStatus = ''; // the status selected by the manager to update the order status
                                      
  
  String get restaurantName => _restaurantName;
  List<Order> get orders => _orders;
  Order? get selectedOrder => _selectedOrder;
  List<Client>? get selectedOrderClients => _selectedOrderClients;
  String get selectedStatus => _selectedStatus;
  set selectedOrder(Order? order){
    _selectedOrder = order;
    // notifyListeners();
  }
  set selectedStatus(String status){
    _selectedStatus = status;
    // notifyListeners();
  }

  void loadSelectedOrderClients(){
    _selectedOrderClients = order_clients; // to be fetched from db based on selected order
    // notifyListeners();
  }

  void updateOrderStatus(){
    // update the satus of _selectedOrder to _selectedStatus in the db
    // notifyListeners();
  }
}