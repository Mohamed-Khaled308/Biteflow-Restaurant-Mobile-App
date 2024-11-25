import 'package:biteflow/models/order_item.dart';
import 'package:flutter/material.dart';

class OrderItemDetails extends StatelessWidget {
  const OrderItemDetails(this.orderItem,{super.key});

  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    return Text(orderItem.title);
  }
}