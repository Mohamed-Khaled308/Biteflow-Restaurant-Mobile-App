import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/views/widgets/cart/card_trait.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemDescription extends StatelessWidget {
  const CartItemDescription({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cartItem.menuItem.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ThemeConstants.blackColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          const OrderItemCardTrait(
            Icons.edit_note_rounded,
            Colors.orange,
            'Edit',
            Colors.orange,
          ),
          verticalSpaceMedium,
          Text(
            '${cartItem.menuItem.price} EGP',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ThemeConstants.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
