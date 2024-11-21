import 'package:biteflow/dummy_data/order_list.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/view-model/base_mode.dart';

class CartViewModel extends BaseModel {
  final List<OrderItem> _cartItems = orderList;

  List<OrderItem> get cartItems => _cartItems;

  void incrementItemQuantity(String id) {
    final index = _cartItems.indexWhere((element) => element.id == id);
    final updatedItem = _cartItems[index].copyWith(updatedQuantity: _cartItems[index].quantity + 1);
    _cartItems[index] = updatedItem;
    notifyListeners();
  }

  void decrementItemQuantity(String id) {
    final index = _cartItems.indexWhere((element) => element.id == id);
    if (_cartItems[index].quantity == 1) {
      _cartItems.removeAt(index);
      notifyListeners();
      return;
    }
    final updatedItem = _cartItems[index].copyWith(updatedQuantity: _cartItems[index].quantity - 1);
    _cartItems[index] = updatedItem;
    notifyListeners();
    
  }
}
