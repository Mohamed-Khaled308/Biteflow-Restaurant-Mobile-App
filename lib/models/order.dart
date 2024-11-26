import 'package:biteflow/core/constants/order_status.dart';
import 'package:biteflow/models/order_item.dart';

class Order {
  final String id;
  final String status;
  final double totalAmount;
  final List<OrderItem> items;
  final List<String> userIDs;
  final String paymentMethod;
  final String restaurantID;

  Order({
    required this.id,
    required this.restaurantID,
    this.status = OrderStatus.pending,
    this.totalAmount = 0.0,
    this.items = const [],
    this.userIDs = const [],
    this.paymentMethod = '',
  });

  Order.fromData(Map<String, dynamic> data)
      : id = data['id'] ?? '',
        restaurantID = data['restaurantID'] ?? '',
        status = data['status'] ?? OrderStatus.pending,
        totalAmount = (data['totalAmount'] ?? 0).toDouble(),
        userIDs = List<String>.from(data['userIDs'] ?? []),
        paymentMethod = data['paymentMethod'] ?? '',
        items = (data['items'] as List<dynamic>? ?? [])
            .map((item) => OrderItem.fromData(item))
            .toList();
}
