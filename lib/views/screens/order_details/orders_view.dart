import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:biteflow/views/screens/order_details/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    ClientOrdersViewModel clientOrdersViewModel = getIt<ClientOrdersViewModel>();
    clientOrdersViewModel.loadClientOrdersData();
    return ChangeNotifierProvider(
      create: (_) => clientOrdersViewModel,
      child: const OrdersScreen(),
    );
  }
}