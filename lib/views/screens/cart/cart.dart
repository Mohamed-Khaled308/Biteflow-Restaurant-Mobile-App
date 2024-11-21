import 'package:biteflow/locator.dart';
import 'package:biteflow/view-model/cart_view_model.dart';
import 'package:biteflow/views/widgets/cart/card.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';
import 'package:flutter/material.dart';



class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartViewModel _viewModel =  getIt<CartViewModel>();
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
builder: (context, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) => OrderItemCard(_viewModel.cartItems[index]),
                itemCount: _viewModel.cartItems.length,
              ),
            ),
             const PaymentSummary(),
          ],
        ),
      );
  }
    );
  }
}