import 'package:biteflow/dummy_data/orders.dart';
import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/viewmodels/base_model.dart';

class OrderViewModel extends BaseModel{
  final Order _order = tableOrder;
  Order get order => _order;
  List<OrderItem> get items => _order.items;

  double get totalAmount {
    double total = 0;
    for (final item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

}