import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';
import 'package:biteflow/views/widgets/order/order_item_details.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key , required this.items ,required this.totalAmount});
  final List<OrderItem> items ;
  final double totalAmount;
  

  @override
  Widget build(BuildContext context) {
    // final viewModel = context.watch<OrderViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) =>
                  OrderItemDetails(items[index]),
              itemCount: items.length,
            ),
          ),
          PaymentSummary(totalAmount),
        ],
      ),
    );
  }
}
