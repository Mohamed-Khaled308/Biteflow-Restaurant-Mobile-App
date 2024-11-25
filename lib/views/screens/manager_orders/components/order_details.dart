import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/view-model/manager_orders_view_model.dart';
import 'package:biteflow/locator.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/models/client.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  final ManagerOrdersViewModel _viewModel = getIt<ManagerOrdersViewModel>();
  final double fontSizeLarge = 22.0;
  final fontSizeMedium = 20.0;
  final fontSizeSmall = 18.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 25, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Items:',
            style: TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
          ),
          ..._viewModel.selectedOrder!.items.map<Widget>((item) {
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
            style: TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
          ),
          ..._viewModel.selectedOrderClients!.map<Widget>((Client client) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.person,
                      size: 20, color: ThemeConstants.blackColor80),
                  const SizedBox(width: 8),
                  Text(
                    client.name,
                    style: TextStyle(fontSize: fontSizeMedium),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          Text(
            'Total:',
            style: TextStyle(fontSize: fontSizeLarge, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${_viewModel.selectedOrder!.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: fontSizeMedium),
          ),
        ],
      ),
    );
  }
}
