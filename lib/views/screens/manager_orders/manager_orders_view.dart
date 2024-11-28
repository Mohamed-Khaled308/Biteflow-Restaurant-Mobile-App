import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
import 'package:biteflow/views/screens/manager_orders/manager_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class ManagerOrdersView extends StatelessWidget {
  const ManagerOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ManagerOrdersViewModel>(),
      child: const ManagerOrdersScreen(),
    );
  }
}