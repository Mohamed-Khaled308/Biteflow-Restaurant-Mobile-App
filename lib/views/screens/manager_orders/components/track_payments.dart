import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/models/order_full_clients_payment.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class TrackPayments extends StatefulWidget {
  const TrackPayments({super.key});

  @override
  State<TrackPayments> createState() => _TrackPaymentsState();
}

class _TrackPaymentsState extends State<TrackPayments> {
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
          viewModel.isLoadingClients
              ? const Text('Loading clients...')
              : Column(
                  children: [
                    ...viewModel.selectedOrderFullClientsPayment!.map<Widget>(
                        (OrderFullClientsPayment orderFullClientsPayment) {
                      // return Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 4.0),
                      //   child: Row(
                      //     children: [
                      //       const Icon(Icons.person,
                      //           size: 20, color: ThemeConstants.blackColor80),
                      //       const SizedBox(width: 8),
                      //       Text(
                      //         orderFullClientsPayment.client.name,
                      //         style: TextStyle(fontSize: fontSizeMedium),
                      //       ),
                      //     ],
                      //   ),
                      // );
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                 Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  orderFullClientsPayment.client.name,
                                  style: TextStyle(fontSize: fontSizeMedium, fontStyle: orderFullClientsPayment.isPaid? FontStyle.normal : FontStyle.italic),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (orderFullClientsPayment.isPaid)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        size: 20,
                                        // color: ThemeConstants.successColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '\$${orderFullClientsPayment.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: fontSizeSmall,
                                          // color: ThemeConstants.successColor,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.hourglass_bottom,
                                        size: 20,
                                        // color: Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '\$${orderFullClientsPayment.amount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: fontSizeSmall,
                                          fontStyle: FontStyle.italic,
                                          // color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
          const SizedBox(height: 16),
          Text(
            'Total Paid:',
            style:
                TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${viewModel.getPaidAmount().toStringAsFixed(2)}',
            style: TextStyle(fontSize: fontSizeMedium),
          ),
          const SizedBox(height: 16),
          Text(
            'Remaining:',
            style:
                TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${viewModel.getRemainingAmount().toStringAsFixed(2)}',
            style: TextStyle(fontSize: fontSizeMedium),
          ),
        ],
      ),
    );
  }
}
