import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/views/screens/cart/components/nav_bar_actions/add_items.dart';
import 'package:biteflow/views/screens/cart/components/nav_bar_actions/members_filter.dart';
import 'package:biteflow/views/screens/cart/components/nav_bar_actions/options.dart';
import 'package:biteflow/views/screens/home/home_screen.dart';
import 'package:biteflow/views/screens/order_details/orders_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/screens/cart/components/cart_item_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/views/screens/cart/components/ready_to_order.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _listKey = GlobalKey<AnimatedListState>();
  late CartViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = context.watch<CartViewModel>();
  }

  @override
  void dispose() {
    viewModel.setIsCartOpen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title:  Text(
          'Cart',
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme:  IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        actions: [
          const MembersFilter(),
          const Options(),
          const AddItems(),
          SizedBox(width: 8.w),
        ],
      ),
      body: StreamBuilder<Cart>(
        stream: viewModel.cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return const Center(child: Text('Cart is empty'));
          }

          final cart = snapshot.data!;

          if (cart.isDeleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.cleanUpCart();
              getIt<NavigationService>().popUntil(HomeScreen);
              getIt<NavigationService>().navigateTo(const OrdersView());
            });
            return const Center(child: CircularProgressIndicator());
          }

          final participants = snapshot.data!.participants;

          final isUserParticipant =
              participants.any((p) => p.id == getIt<UserProvider>().user?.id);

          if (!isUserParticipant && !viewModel.isCreator) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (viewModel.cart!.restaurantId == snapshot.data!.restaurantId) {
                viewModel.cleanUpCart();
                getIt<NavigationService>().popUntil(HomeScreen);
              }
            });
          }

          final newList = viewModel.applyFilter(snapshot.data!.items);
          final curList = viewModel.filteredItems;
          _updateListState(curList, newList);
          viewModel.setCart = snapshot.data!;
          final filteredItems = newList;
          viewModel.setFilteredItems = filteredItems;

          return Column(
            children: [
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(child: Text('No items for this participant'))
                    : AnimatedList(
                        key: _listKey,
                        initialItemCount: filteredItems.length,
                        itemBuilder: (ctx, index, animation) {
                          return SlideTransition(
                            position: animation.drive(
                              Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.easeInOut)),
                            ),
                            child: CartItemCard(filteredItems[index]),
                          );
                        },
                      ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Subtotal (before discount)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${(viewModel.totalAmount + viewModel.totalDiscount).toStringAsFixed(2)} \$', // Showing subtotal before discount
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    if (viewModel.totalDiscount > 0)
                      Column(
                        children: [
                          SizedBox(height: 6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                '-${viewModel.totalDiscount.toStringAsFixed(2)} \$',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    SizedBox(height: 6.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${viewModel.totalAmount.toStringAsFixed(2)} \$',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),

                    Divider(height: 32.h),
                    const ReadyToOrder(),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateListState(List<CartItem> currentItems, List<CartItem> newItems) {
    final currentIds =
        currentItems.map((e) => '${e.menuItem.id}, ${e.userId}').toList();
    final newIds =
        newItems.map((e) => '${e.menuItem.id}, ${e.userId}').toList();

    // Identify additions
    for (int i = 0; i < newIds.length; i++) {
      if (!currentIds.contains(newIds[i])) {
        _listKey.currentState
            ?.insertItem(i, duration: const Duration(milliseconds: 300));
      }
    }

    // Identify removals
    for (int i = currentIds.length - 1; i >= 0; i--) {
      if (!newIds.contains(currentIds[i])) {
        _listKey.currentState?.removeItem(i, (context, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.vertical,
              child: CartItemCard(currentItems[i]),
            ),
          );
        }, duration: const Duration(milliseconds: 300));
      }
    }
  }
}
