import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';
import 'package:biteflow/views/widgets/order/order_item_details.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key , required this.items ,required this.totalAmount, required this.orderDiscount});
  final List<OrderItem> items ;
  final double totalAmount;
  final double orderDiscount;
  

  @override
  Widget build(BuildContext context) {
    // final viewModel = context.watch<OrderViewModel>();
    // double total = 0;
    // double discount = 0;
    // double discountTotal = 0;
    // for (final item in items) {
    //   total += item.price * item.quantity;
    // }
    // for (final item in items) {
    //   discountTotal += item.price * item.quantity * item.discountPercentage / 100;
    // }
    // discount = total - discountTotal;
    double personalizedDiscountedTotal = totalAmount;
    double personalizedOriginalTotal = personalizedDiscountedTotal/(1- (orderDiscount/100));
    double discount = personalizedOriginalTotal - personalizedDiscountedTotal;

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
          PaymentSummary(personalizedDiscountedTotal , personalizedOriginalTotal , discount),
        ],
      ),
    );
  }
}
