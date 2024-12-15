import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartItemViewModel>();
    final isCurrentUserOwner =
        viewModel.cartItem.userId == getIt<UserProvider>().user!.id;

    return BottomAppBar(
      height: 90.h,
      elevation: 10,
      color: ThemeConstants.whiteColor,
      child: Container(
        decoration: BoxDecoration(
          color: ThemeConstants.whiteColor,
          boxShadow: [
            BoxShadow(
              color: ThemeConstants.blackColor.withOpacity(0.1),
              blurRadius: 10.r,
              offset: Offset(0, -2.h),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: isCurrentUserOwner && viewModel.itemQuantity > 1
                      ? () => viewModel.updateItemQuantity(-1)
                      : null,
                  icon: Icon(
                    Icons.remove,
                    color: isCurrentUserOwner && viewModel.itemQuantity > 1
                        ? ThemeConstants.blackColor
                        : ThemeConstants.greyColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    viewModel.itemQuantity.toString(),
                    style: TextStyle(
                      color: ThemeConstants.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: isCurrentUserOwner && viewModel.itemQuantity < 99
                      ? () => viewModel.updateItemQuantity(1)
                      : null,
                  icon: Icon(
                    Icons.add,
                    color: isCurrentUserOwner && viewModel.itemQuantity < 99
                        ? ThemeConstants.blackColor
                        : ThemeConstants.greyColor,
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: isCurrentUserOwner && !viewModel.busy
                      ? () {
                          viewModel.updateItem();
                          getIt<NavigationService>().pop();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrentUserOwner
                        ? ThemeConstants.primaryColor
                        : ThemeConstants.greyColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
                  ),
                  child: Text(
                    'Update item',
                    style: TextStyle(
                      color: viewModel.busy
                          ? ThemeConstants.blackColor
                          : ThemeConstants.whiteColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                if (viewModel.busy)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: ThemeConstants.primaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
