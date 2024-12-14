import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:biteflow/views/screens/order_details/client_orders_list.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  // ignore: must_call_super
  void dispose() {
    // don't call super
  }

 



  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClientOrdersViewModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: viewModel.busy
            ? const Text('Loading...')
            : Text("${viewModel.clientLogged.name} 's Orders",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: ThemeConstants.whiteColor,
                )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: viewModel.busy
          ? const Center(
              child: CircularProgressIndicator(
              backgroundColor: ThemeConstants.blackColor40,
              color: ThemeConstants.blackColor80,
            ))
          : const Column(
              children: [
                SizedBox(height: 10),
                ClientsOrdersList(),
              ],
            ),
    );
  }
}