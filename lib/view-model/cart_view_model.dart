import 'package:biteflow/dummy_data/order_list.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/view-model/base_mode.dart';
import 'package:flutter/material.dart';

class CartViewModel extends BaseModel {
  final List<OrderItem> _cartItems = orderList;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _notesController = TextEditingController();

  List<OrderItem> get cartItems => _cartItems;
  GlobalKey<AnimatedListState> get listKey => _listKey;
  TextEditingController get notesController => _notesController;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get totalAmount {
    double total = 0;
    for (final item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void updateNotes(String id, String notes) {
    final index = _cartItems.indexWhere((element) => element.id == id);
    final updatedItem = _cartItems[index].copyWith(updatedNotes: notes);
    _cartItems[index] = updatedItem;
    notifyListeners();
  }

  void incrementItemQuantity(String id) {
    final index = _cartItems.indexWhere((element) => element.id == id);
    final updatedItem = _cartItems[index]
        .copyWith(updatedQuantity: _cartItems[index].quantity + 1);
    _cartItems[index] = updatedItem;
    notifyListeners();
  }

  void decrementItemQuantity(String id) {
    final index = _cartItems.indexWhere((element) => element.id == id);
    if (_cartItems[index].quantity == 1) {
      _listKey.currentState!.removeItem(index, (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: const Card(
            margin: EdgeInsets.all(16),
            color: Colors.red,
            child: ListTile(
              title: Text(
                'Item removed from cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      }, duration: const Duration(milliseconds: 500));
      _cartItems.removeAt(index);
      notifyListeners();
      return;
    }
    final updatedItem = _cartItems[index]
        .copyWith(updatedQuantity: _cartItems[index].quantity - 1);
    _cartItems[index] = updatedItem;
    notifyListeners();
  }
}
