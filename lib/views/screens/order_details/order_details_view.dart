import 'package:biteflow/viewmodels/order_view_model.dart';
import 'package:biteflow/views/screens/order_details/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<OrderViewModel>(),
      child: const OrderDetailsScreen(),
    );
  }
}
