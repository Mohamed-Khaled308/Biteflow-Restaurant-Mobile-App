import 'package:biteflow/models/order_clients_payment.dart';
import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/core/utils/status_icon_color.dart';

class ClientsOrdersList extends StatefulWidget {
  const ClientsOrdersList({super.key});

  @override
  State<ClientsOrdersList> createState() => _ClientsOrdersListState();
}

class _ClientsOrdersListState extends State<ClientsOrdersList> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClientOrdersViewModel>();
    return Expanded(
      child: viewModel.orders!.isEmpty
          ? const Center(
              child: Text(
                'No orders yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: viewModel.orders!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = viewModel.orders![index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // Tap logic to show each order details
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  StatusIconColor.getStatusIcon(order.status),
                                  color: StatusIconColor.getStatusColor(order.status),
                                  size: 36,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order #${order.orderNumber}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
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
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: StatusIconColor.getStatusColor(order.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    order.status.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: StatusIconColor.getStatusColor(order.status),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            for (final OrderClientsPayment orderClientsPayment
                                in order.orderClientsPayment)
                              if (orderClientsPayment.userId ==
                                      viewModel.clientLogged.id &&
                                  order.status == 'accepted')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orderClientsPayment.isPaid == false
                                          ? 'Payment pending'
                                          : 'Payment completed',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: orderClientsPayment.isPaid == false 
                                            ? Colors.orange 
                                            : Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (orderClientsPayment.isPaid == false)
                                      ElevatedButton(
                                        onPressed: () {
                                          // hosseiny code
                                          
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        ),
                                        child: const Text(
                                          'Pay Now',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}