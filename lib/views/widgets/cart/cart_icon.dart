import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/screens/cart/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();
    final itemCount = viewModel.cartItemCount;
    return SizedBox(
      width: 40.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: () {
              if (viewModel.isCartOpened) {
                getIt<NavigationService>().pop();
              } else {
                viewModel.setIsCartOpen = true;
                getIt<NavigationService>().navigateTo(const CartView());
              }
            },
            icon: const Icon(
              Icons.shopping_cart,
            ),
          ),
          if (itemCount > 0)
            Positioned(
              right: 3.w,
              top: 4.h,
              child: CircleAvatar(
                radius: 8.r,
                backgroundColor: ThemeConstants.darkGreyColor.withOpacity(0.8),
                child: Text(
                  itemCount > 9 ? '+9' : '$itemCount',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: ThemeConstants.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
