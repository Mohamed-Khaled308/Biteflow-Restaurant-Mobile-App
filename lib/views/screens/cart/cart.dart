import 'package:biteflow/views/widgets/cart/card.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/dummy_data/order_list.dart';



class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => OrderItemCard(orderList[index]),
              itemCount: orderList.length,
            ),
          ),
           const PaymentSummary(),
        ],
      ),
    );
  }
}