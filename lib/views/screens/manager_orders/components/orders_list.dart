import 'package:biteflow/core/constants/theme_constants.dart';
// import 'package:biteflow/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
// import 'package:biteflow/viewmodels/manager_orders_details_view_model.dart';
import 'package:biteflow/views/screens/manager_orders/components/order_bottom_sheet.dart';
import 'package:biteflow/core/utils/status_icon_color.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerOrdersViewModel>();
    return Expanded(
      child: SingleChildScrollView(
          child: viewModel.orders!.isEmpty
              ? const Center(child: Text('No orders yet'))
              : Column(
                  children: viewModel.orders!.map((order) {
                    return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow:  [
                                BoxShadow(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Icon(
                                    StatusIconColor.getStatusIcon(order.status),
                                    color: StatusIconColor.getStatusColor(
                                        order.status),
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order #${order.orderNumber}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    order.status.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: StatusIconColor.getStatusColor(
                                          order.status),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              // ManagerOrdersDetailsViewModel
                              //     managerOrdersDetailsViewModel =
                              //     getIt<ManagerOrdersDetailsViewModel>();
                              // managerOrdersDetailsViewModel
                              //     .setSelectedOrder(order);
                              // managerOrdersDetailsViewModel
                              //     .loadSelectedOrderClients(); // to load clients based on selected order
                              
                              viewModel.setSelectedOrder(order);
                              viewModel.loadSelectedOrderClients();
                              return ChangeNotifierProvider.value(
                                value: viewModel,
                                child: const OrderBottomSheet(),
                              );
                              // return ChangeNotifierProvider(
                              //   create: (_) => managerOrdersDetailsViewModel,
                              //   child: const OrderBottomSheet(),
                              // );
                            },
                          );
                        });
                  }).toList(),
                )),
    );
  }
}
