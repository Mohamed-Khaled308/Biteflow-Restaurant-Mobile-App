import 'package:biteflow/locator.dart';
import 'package:biteflow/view-model/order_view_model.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';
import 'package:biteflow/views/widgets/order/order_item_details.dart';
import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});


  @override
  Widget build(BuildContext context) {
    final OrderViewModel viewModel = getIt<OrderViewModel>();
    return AnimatedBuilder(
      animation: viewModel,
      builder:(context , _)  { return Scaffold(
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
    );
  }
}
