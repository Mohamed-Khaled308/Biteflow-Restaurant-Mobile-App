import 'package:biteflow/core/constants/business_constants.dart';
import 'package:biteflow/models/order_clients_payment.dart';
import 'package:biteflow/models/order_item.dart';

class Order {
  final String id;
  final String status;
  final double totalAmount;
  final List<OrderItem> items;
  final List<OrderClientsPayment> orderClientsPayment;
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
    this.orderClientsPayment = const [],
    this.paymentMethod = '',
  });

  // Convert Firestore data into an Order object
  Order.fromData(Map<String, dynamic> data)
      : id = data['id'],
        restaurantId = data['restaurantId'],
        orderNumber = data['orderNumber'],
        status = data['status'] ?? BusinessConstants.pendingStatus,
        totalAmount = (data['totalAmount'] ?? 0).toDouble(),
        orderClientsPayment =
            (data['orderClientsPayment'] as List<dynamic>? ?? [])
                .map((orderClientPayment) =>
                    OrderClientsPayment.fromData(orderClientPayment))
                .toList(),
        paymentMethod = data['paymentMethod'] ?? '',
        items = (data['items'] as List<dynamic>? ?? [])
            .map((item) => OrderItem.fromData(item))
            .toList();

 
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'orderNumber': orderNumber,
      'status': status,
      'totalAmount': totalAmount,
      'items': items.map((item) => item.toJson()).toList(),
      'orderClientsPayment':
          orderClientsPayment.map((payment) => payment.toJson()).toList(),
      'paymentMethod': paymentMethod,
    };
  }
}
