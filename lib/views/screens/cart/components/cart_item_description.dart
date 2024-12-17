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
    final discountPercentage = cartItem.menuItem.discountPercentage;
    final price = cartItem.menuItem.price * cartItem.quantity;
    final newPrice = price * (1 - discountPercentage / 100);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cartItem.menuItem.title,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor,
                overflow: TextOverflow.ellipsis),
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
          verticalSpaceTiny,

          // Display old price if discount exists
          if (discountPercentage > 0)
            Row(
              children: [
                Text(
                  price.toStringAsFixed(2), // Old price
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    decoration:
                        TextDecoration.lineThrough, // Strikethrough effect
                  ),
                ),
                const SizedBox(width: 4), // Space between old and new prices
                Text(
                  '${newPrice.toStringAsFixed(2)} \$', // New discounted price
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                      overflow:
                          TextOverflow.clip // Highlighted color for new price
                      ),
                ),
              ],
            )
          else
            Row(
              children: [
                Text(
                  '${price.toStringAsFixed(2)} \$',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
