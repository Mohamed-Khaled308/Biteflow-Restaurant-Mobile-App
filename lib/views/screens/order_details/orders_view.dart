import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:biteflow/views/screens/order_details/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/viewmodels/payment_view_model.dart';



class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    ClientOrdersViewModel clientOrdersViewModel = getIt<ClientOrdersViewModel>();
    clientOrdersViewModel.loadClientOrdersData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ClientOrdersViewModel>(
          create: (_) => clientOrdersViewModel,
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<PaymentViewModel>(),
        ),
      ],
      child: const OrdersScreen(),
    );
  }
}