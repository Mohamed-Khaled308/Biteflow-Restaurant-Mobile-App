import 'package:biteflow/models/order_item.dart';

class Order{
  final String id;
  final String status;
  final double totalAmount;
  final List<OrderItem> items;
  final List<String> userIDs;
  final String paymentMethod;
  final String restaurantID;
  final int orderNumber;

  Order({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.items,
    required this.userIDs,
    required this.paymentMethod,
    required this.restaurantID,
    required this.orderNumber,
  });


  Order.fromData(Map<String, dynamic> data)
    : id = data['id'],
      status = data['status'],
      totalAmount = data['totalAmount'],
      userIDs = data['userIDs'],
      paymentMethod = data['paymentMethod'],
      restaurantID = data['restaurantID'],
      items = data['items'],
      orderNumber = data['orderNumber'];

}