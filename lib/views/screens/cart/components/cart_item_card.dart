import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/views/screens/cart/components/cart_item_description.dart';
import 'package:biteflow/views/screens/cart/components/cart_item_notes_dialog.dart';
import 'package:biteflow/views/screens/cart/components/cart_item_participant.dart';
import 'package:biteflow/views/screens/cart/components/cart_item_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard(this.cartItem, {super.key});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(ThemeConstants.defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2.r,
            blurRadius: 5.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) =>
                    CartItemNotesDialog(itemId: cartItem.menuItem.id));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CartItemThumbnail(cartItem: cartItem),
                SizedBox(width: 16.w),
                CartItemDescription(cartItem: cartItem),
                CartItemParticipant(cartItem: cartItem),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
