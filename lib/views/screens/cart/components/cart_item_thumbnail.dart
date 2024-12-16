import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class CartItemThumbnail extends StatelessWidget {
  const CartItemThumbnail({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();
    final userProvider = context.read<UserProvider>();
    return SizedBox(
      width: 126.w,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(ThemeConstants.defaultBorderRadious),
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(cartItem.menuItem.imageUrl),
              width: 126.w, // Image size
              height: 105.h,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80.w,
                  height: 80.h,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          Container(
            width: 126.w,
            height: 105.h,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius:
                  BorderRadius.circular(ThemeConstants.defaultBorderRadious),
            ),
          ),
          Positioned(
            bottom: 5.h,
            left: 5.w,
            right: 5.w,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(ThemeConstants.defaultBorderRadious),
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
              ),
              height: 40.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: cartItem.userId == userProvider.user!.id
                        ? () {
                            viewModel.updateItemQuantity(
                                cartItem.menuItem.id, cartItem.quantity - 1);
                          }
                        : null,
                    icon: cartItem.quantity == 1
                        ? Icon(Icons.delete,
                            color: cartItem.userId == userProvider.user!.id
                                ? ThemeConstants.errorColor
                                : ThemeConstants.greyColor)
                        : Icon(Icons.remove,
                            color: cartItem.userId == userProvider.user!.id
                                ? Theme.of(context).secondaryHeaderColor
                                : ThemeConstants.greyColor),
                  ),
                  Text(
                    '${cartItem.quantity}',
                    style: TextStyle(
                      color: cartItem.userId == userProvider.user!.id
                          ? Theme.of(context).secondaryHeaderColor
                          : ThemeConstants.greyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: cartItem.userId == userProvider.user!.id
                        ? () {
                            viewModel.updateItemQuantity(
                                cartItem.menuItem.id, cartItem.quantity + 1);
                          }
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
