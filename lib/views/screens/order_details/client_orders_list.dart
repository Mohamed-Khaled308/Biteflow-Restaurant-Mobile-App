import 'package:biteflow/locator.dart';
import 'package:biteflow/models/order_clients_payment.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:biteflow/views/screens/order_details/order_details_view.dart';
import 'package:biteflow/views/screens/rating/rating_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/core/utils/status_icon_color.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/payment_view_model.dart';

class ClientsOrdersList extends StatefulWidget {
  const ClientsOrdersList({super.key});

  @override
  State<ClientsOrdersList> createState() => _ClientsOrdersListState();
}

class _ClientsOrdersListState extends State<ClientsOrdersList> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClientOrdersViewModel>();
    final paymentViewModel = context.watch<PaymentViewModel>();
    double totalAmount = 0;

    return Expanded(
      child: viewModel.orders!.isEmpty
          ? Center(
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
                    'Your order history will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onRefresh: () async {
                await viewModel.reloadClientOrdersData();
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: viewModel.orders!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final order = viewModel.orders![index];
                  return Container(
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
                          for (final OrderClientsPayment orderClientsPayment
                              in order.orderClientsPayment) {
                            if (orderClientsPayment.userId ==
                                viewModel.clientLogged.id) {
                              totalAmount = orderClientsPayment.amount;
                            }
                          }
                          getIt<NavigationService>().navigateTo(
                            OrderDetailsView(
                              items: order.items,
                              totalAmount: totalAmount,
                              orderDiscount: order.items.first.discountPercentage,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: StatusIconColor.getStatusColor(
                                              order.status)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      StatusIconColor.getStatusIcon(order.status),
                                      color: StatusIconColor.getStatusColor(
                                          order.status),
                                      size: 32,
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
                                            fontSize: 22,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Order Total: \$${order.totalAmount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 18,
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
                              const SizedBox(height: 16),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              for (final OrderClientsPayment orderClientsPayment
                                  in order.orderClientsPayment)
                                if (orderClientsPayment.userId ==
                                        viewModel.clientLogged.id &&
                                    order.status == 'accepted')
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            orderClientsPayment.isPaid
                                                ? Icons.check_circle
                                                : Icons.pending_outlined,
                                            color: orderClientsPayment.isPaid
                                                ? Colors.green
                                                : Colors.orange,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            orderClientsPayment.isPaid
                                                ? 'Payment completed'
                                                : 'Payment pending',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: orderClientsPayment.isPaid
                                                  ? Colors.green
                                                  : Colors.orange,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (!orderClientsPayment.isPaid)
                                        ElevatedButton.icon(
                                          onPressed: paymentViewModel
                                                  .isBusy(order.id)
                                              ? null
                                              : () async {
                                                  paymentViewModel
                                                      .setBusyForOrder(
                                                          order.id, true);
                                                  for (final OrderClientsPayment
                                                      orderClientsPayment
                                                      in order
                                                          .orderClientsPayment) {
                                                    if (orderClientsPayment
                                                            .userId ==
                                                        viewModel
                                                            .clientLogged.id) {
                                                      totalAmount =
                                                          orderClientsPayment
                                                              .amount;
                                                    }
                                                  }
                                                  await paymentViewModel
                                                      .initiatePayment(
                                                          totalAmount);
                                                  Stripe.instance
                                                      .presentPaymentSheet()
                                                      .then((value) {
                                                    paymentViewModel
                                                        .setBusyForOrder(
                                                            order.id, false);
                                                    paymentViewModel
                                                        .setBusy(false);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Payment Successful'),
                                                          backgroundColor:
                                                              ThemeConstants
                                                                  .successColor,
                                                        ),
                                                      );
                                                    }
                                                    viewModel
                                                        .updateOrderClientPaymentStatus(
                                                            order.id);
                                                  }).catchError((e) {
                                                    paymentViewModel
                                                        .setBusyForOrder(
                                                            order.id, false);
                                                    paymentViewModel
                                                        .setBusy(false);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Payment process was interrupted. Please try again.'),
                                                          backgroundColor:
                                                              ThemeConstants
                                                                  .errorColor,
                                                        ),
                                                      );
                                                    }
                                                  });
                                                },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.blue,
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 12),
                                          ),
                                          icon: const Icon(Icons.payment,
                                              size: 20),
                                          label: const Text(
                                            'Pay Now',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                              if (order.status == 'served')
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blue,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                      ),
                                      icon: const Icon(Icons.rate_review,
                                          size: 20),
                                      label: const Text(
                                        'Rate Now',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        getIt<NavigationService>().navigateTo(
                                          RatingView(
                                              restaurantId: order.restaurantId),
                                        );
                                      },
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}