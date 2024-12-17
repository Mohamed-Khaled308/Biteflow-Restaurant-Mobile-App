import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/viewmodels/order_view_model.dart';
import 'package:biteflow/views/screens/order_details/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key , required this.items , required this.totalAmount, required this.orderDiscount});
  final List<OrderItem> items ;
  final double totalAmount;
  final double orderDiscount;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<OrderViewModel>(),
      child: OrderDetailsScreen(items: items, totalAmount: totalAmount, orderDiscount: orderDiscount),
    );
  }
}
