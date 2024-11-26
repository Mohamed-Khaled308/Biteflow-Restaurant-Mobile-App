import 'package:flutter/material.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
import 'package:biteflow/views/screens/manager_orders/components/orders_list.dart';
import 'package:provider/provider.dart';

class ManagerOrdersScreen extends StatefulWidget {
  const ManagerOrdersScreen({super.key});

  @override
  State<ManagerOrdersScreen> createState() => _ManagerOrdersScreenState();
}

class _ManagerOrdersScreenState extends State<ManagerOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerOrdersViewModel>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${viewModel.restaurantName} Orders',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: ThemeConstants.whiteColor,
            )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const Column(
        children: [
          SizedBox(height: 10),
          OrdersList(),
        ],
      ),
    );
  }
}
