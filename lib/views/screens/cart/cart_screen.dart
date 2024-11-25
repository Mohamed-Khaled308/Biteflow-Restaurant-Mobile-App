import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/widgets/cart/card.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: viewModel.listKey,
              itemBuilder: (ctx, index, animation) =>
                  OrderItemCard(viewModel.cartItems[index]),
              // not using animation as an animation is done in the view model
              initialItemCount: viewModel.cartItems.length,
            ),
          ),
          PaymentSummary(viewModel.totalAmount),
        ],
      ),
    );
  }
}
