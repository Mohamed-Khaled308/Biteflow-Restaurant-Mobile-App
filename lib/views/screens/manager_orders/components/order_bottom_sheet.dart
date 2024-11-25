import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/views/screens/manager_orders/components/order_details.dart';
import 'package:biteflow/views/screens/manager_orders/components/order_update_status.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/view-model/manager_orders_view_model.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/utils/status_icon_color.dart';


class OrderBottomSheet extends StatefulWidget {
  const OrderBottomSheet({super.key});

  @override
  State<OrderBottomSheet> createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends State<OrderBottomSheet> {
  final ManagerOrdersViewModel _viewModel = getIt<ManagerOrdersViewModel>();
  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      expand: false,
      builder: (_, scrollController) => DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // The drag indicator
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            
            // Order Number and Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        StatusIconColor.getStatusIcon(
                            _viewModel.selectedOrder!.status),
                        color: StatusIconColor.getStatusColor(
                            _viewModel.selectedOrder!.status),
                        size: 30,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Order #${_viewModel.selectedOrder!.orderNumber}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      _viewModel.selectedOrder!.status.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: StatusIconColor.getStatusColor(
                            _viewModel.selectedOrder!.status),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // TabBar
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: ThemeConstants.greyColor,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(
                  text: 'Order Details',
                  icon: Icon(Icons.info_outline),
                ),
                Tab(
                  text: 'Update Status',
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
            
            // TabBarViews
            Expanded(
              child: TabBarView(
                children: [

                  // Order Details Tab
                  SingleChildScrollView(
                    controller: scrollController,
                    child: const OrderDetails()
                  ),

                  // Update Status Tab
                  SingleChildScrollView(
                    controller: scrollController,
                    child: const OrderUpdateStatus()
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
