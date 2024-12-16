import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/models/order_full_clients_payment.dart';
// import 'package:biteflow/viewmodels/manager_orders_details_view_model.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final double fontSizeLarge = 22.0;
  final fontSizeMedium = 20.0;
  final fontSizeSmall = 18.0;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerOrdersViewModel>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 25, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Items:',
            style:
                TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
          ),
          ...viewModel.selectedOrder!.items.map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '- ${item.title} (${item.quantity}x)',
                    style: TextStyle(fontSize: fontSizeMedium),
                  ),
                  if (item.notes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Notes: ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: fontSizeSmall,
                                color: ThemeConstants.greyColor,
                              ),
                            ),
                            TextSpan(
                              text: item.notes,
                              style: TextStyle(
                                fontSize: fontSizeSmall,
                                color: ThemeConstants.greyColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          Text(
            'Clients:',
            style:
                TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
          ),
          viewModel.isLoadingClients
              ? const Text('Loading clients...')
              : Column(
                  children: [
                    ...viewModel.selectedOrderFullClientsPayment!
                        .map<Widget>((OrderFullClientsPayment orderFullClientsPayment) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                             Icon(Icons.person,
                                size: 20, color: Theme.of(context).secondaryHeaderColor),
                            const SizedBox(width: 8),
                            Text(
                              orderFullClientsPayment.client.name,
                              style: TextStyle(fontSize: fontSizeMedium),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
          const SizedBox(height: 16),
          Text(
            'Total:',
            style:
                TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${viewModel.selectedOrder!.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: fontSizeMedium),
          ),
        ],
      ),
    );
  }
}
