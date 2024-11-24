import 'package:flutter/material.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/view-model/manager_orders_view_model.dart';
import 'package:biteflow/views/screens/manager_orders/components/orders_list.dart';


class ManagerOrdersView extends StatefulWidget {
  const ManagerOrdersView({super.key});

  @override
  State<ManagerOrdersView> createState() => _ManagerOrdersViewState();
}

class _ManagerOrdersViewState extends State<ManagerOrdersView> {

  final ManagerOrdersViewModel _viewModel =  getIt<ManagerOrdersViewModel>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context,_){
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              '${_viewModel.restaurantName} Orders',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: ThemeConstants.whiteColor,
              )
            ),
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
    );
  }
}