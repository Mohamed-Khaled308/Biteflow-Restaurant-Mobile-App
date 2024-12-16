import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
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
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () async {
          await viewModel.reloadOrdersData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: viewModel.orders!.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders yet',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'New orders will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: viewModel.orders!.map((order) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) {
                                viewModel.setSelectedOrder(order);
                                viewModel.loadSelectedOrderClients();
                                return ChangeNotifierProvider.value(
                                  value: viewModel,
                                  child: const OrderBottomSheet(),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) {
                                      viewModel.setSelectedOrder(order);
                                      viewModel.loadSelectedOrderClients();
                                      return ChangeNotifierProvider.value(
                                        value: viewModel,
                                        child: const OrderBottomSheet(),
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: StatusIconColor.getStatusColor(
                                                  order.status)
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          StatusIconColor.getStatusIcon(
                                              order.status),
                                          color: StatusIconColor.getStatusColor(
                                              order.status),
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
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
                                            const SizedBox(height: 6),
                                            Text(
                                              'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: StatusIconColor.getStatusColor(
                                                  order.status)
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          order.status.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: StatusIconColor.getStatusColor(
                                                order.status),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ),
    );
  }
}