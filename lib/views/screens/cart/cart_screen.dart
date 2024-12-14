import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/views/screens/menu/menu_view.dart';
import 'package:biteflow/views/widgets/user/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/screens/cart/components/cart_item_card.dart';
import 'package:biteflow/views/widgets/cart/payment_summary.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: ThemeConstants.whiteColor),
        ),
        backgroundColor: ThemeConstants.primaryColor,
        iconTheme: const IconThemeData(
          color: ThemeConstants.whiteColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.filter_list,
            ),
            onPressed: () async {
              final selectedFilter = await showMenu<String>(
                menuPadding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                context: context,
                position: RelativeRect.fromLTRB(
                  MediaQuery.of(context).size.width - 50.w,
                  kToolbarHeight,
                  0.0,
                  0.0,
                ),
                items: [
                  PopupMenuItem<String>(
                    padding: const EdgeInsets.all(0),
                    value: null,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                      color: viewModel.filterUserId == null
                          ? ThemeConstants.greyColor.withOpacity(
                              0.5) // Highlight if "All Participants" is selected
                          : null,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30.w,
                            height: 30.h,
                            child: CircleAvatar(
                              radius: 15.r,
                              child: const Icon(Icons.group),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'All Members',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...viewModel.cart.participants.map((participant) {
                    final isSelected = viewModel.filterUserId == participant.id;
                    return PopupMenuItem<String>(
                      padding: const EdgeInsets.all(0),
                      value: participant.id,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          color: isSelected
                              ? ThemeConstants.greyColor.withOpacity(0.5)
                              : null,
                          child: UserCard(
                              name: participant.name, id: participant.id)),
                    );
                  })
                ],
              );
              if (selectedFilter != null) {
                viewModel.setFilter(selectedFilter);
              } else {
                // If null is selected (All Participants), reset the filter
                viewModel.setFilter(null);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    'Scan this QR Code to be added to the order',
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    height: 200,
                    width: 200,
                    alignment: Alignment.center,
                    child: QrImageView(
                      data: viewModel.cart.id,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(
            width: 8.w,
          ),
          TextButton(
              onPressed: () {
                getIt<NavigationService>().navigateTo(
                  MenuView(restaurantId: viewModel.cart.restaurantId),
                );
              },
              child: const Text(
                'Add Items',
                style: TextStyle(color: ThemeConstants.whiteColor),
              ))
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
              PaymentSummary(viewModel.totalAmount),
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
