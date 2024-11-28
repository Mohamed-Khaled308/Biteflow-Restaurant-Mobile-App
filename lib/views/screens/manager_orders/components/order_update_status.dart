import 'package:flutter/material.dart';
import 'package:biteflow/core/constants/business_constants.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/utils/status_icon_color.dart';

class OrderUpdateStatus extends StatefulWidget {
  const OrderUpdateStatus({super.key});

  @override
  State<OrderUpdateStatus> createState() => _OrderUpdateStatusState();
}

class _OrderUpdateStatusState extends State<OrderUpdateStatus> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // String _selectedStatus = '';


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerOrdersViewModel>();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top:30),
            child: Center(
              child: Text(
                'Update Order Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...BusinessConstants.statuses.map((status) {
            return RadioListTile<String>(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: ThemeConstants.blackColor60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    StatusIconColor.getStatusIcon(status),
                    color: ThemeConstants.blackColor80,
                    size: 20,
                  ),
                ],
              ),
              value: status,
              groupValue: viewModel.selectedStatus,
              onChanged: (newStatus) {
                setState(() {
                  viewModel.selectedStatus = newStatus!;
                });
              },
              activeColor: Theme.of(context).primaryColor,
            );
          }),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if(viewModel.selectedStatus != ''){
                  viewModel.updateOrderStatus();
                  viewModel.selectedStatus = '';
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}