import 'package:biteflow/core/constants/business_constants.dart';
import 'package:biteflow/models/order_item.dart';

class Order {
  final String id;
  final String status;
  final double totalAmount;
  final List<OrderItem> items;
  final List<String> userIDs;
  final String paymentMethod;
  final String restaurantId;
  final int orderNumber;

  Order({
    required this.id,
    required this.restaurantId,
    required this.orderNumber,
    this.status = BusinessConstants.pendingStatus,
    this.totalAmount = 0.0,
    this.items = const [],
    this.userIDs = const [],
    this.paymentMethod = '',
  });

  Order.fromData(Map<String, dynamic> data)
      : id = data['id'],
        restaurantId = data['restaurantId'],
        orderNumber = data['orderNumber'],
        status = data['status'] ?? BusinessConstants.pendingStatus,
        totalAmount = (data['totalAmount'] ?? 0).toDouble(),
        userIDs = List<String>.from(data['userIDs'] ?? []),
        paymentMethod = data['paymentMethod'] ?? '',
        items = (data['items'] as List<dynamic>? ?? [])
            .map((item) => OrderItem.fromData(item))
            .toList();
}
