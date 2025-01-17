import 'package:flutter/material.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
import 'package:biteflow/views/screens/manager_orders/components/orders_list.dart';
import 'package:provider/provider.dart';

class ManagerOrdersScreen extends StatefulWidget {
  const ManagerOrdersScreen({super.key});

  @override
  State<ManagerOrdersScreen> createState() => _ManagerOrdersScreenState();
}

class _ManagerOrdersScreenState extends State<ManagerOrdersScreen> {

  // @override
  // // ignore: must_call_super
  // void dispose() {
  //   // don't call super
  // }



  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerOrdersViewModel>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: viewModel.busy
            ? const Text('Loading...')
            : Text('${viewModel.authenticatedManagerRestaurant!.name} Orders',
                style:  TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).secondaryHeaderColor,
                )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: viewModel.busy
          ?  Center(
              child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              color: Theme.of(context).secondaryHeaderColor,
            ))
          : const Column(
              children: [
                SizedBox(height: 10),
                OrdersList(),
              ],
            ),
    );
  }
}
