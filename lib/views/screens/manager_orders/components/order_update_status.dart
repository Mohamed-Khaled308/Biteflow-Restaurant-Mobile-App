import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/core/constants/business_constants.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
// import 'package:biteflow/viewmodels/manager_orders_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/core/utils/status_icon_color.dart';
import 'package:biteflow/services/navigation_service.dart';

class OrderUpdateStatus extends StatefulWidget {
  const OrderUpdateStatus({super.key});

  @override
  State<OrderUpdateStatus> createState() => _OrderUpdateStatusState();
}

class _OrderUpdateStatusState extends State<OrderUpdateStatus> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerOrdersViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 30),
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
                    style:  TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    StatusIconColor.getStatusIcon(status),
                    color: Theme.of(context).secondaryHeaderColor,
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
              onPressed: viewModel.busy
                  ? null // Disable button when busy
                  : () async {
                      if (viewModel.selectedStatus != '') {
                        await viewModel.updateOrderStatus();
                        viewModel.selectedStatus = '';
                        getIt<NavigationService>().pop();
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
