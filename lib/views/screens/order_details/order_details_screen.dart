import 'package:biteflow/viewmodels/order_view_model.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';
import 'package:biteflow/views/widgets/order/order_item_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) =>
                  OrderItemDetails(viewModel.items[index]),
              itemCount: viewModel.items.length,
            ),
          ),
          PaymentSummary(viewModel.totalAmount),
        ],
      ),
    );
  }
}
