import 'dart:convert';
import 'package:biteflow/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto/crypto.dart';

class CartItemParticipant extends StatelessWidget {
  const CartItemParticipant({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  Color _getAvatarColor(String userId) {
    var bytes = utf8.encode(userId);
    var digest = sha256.convert(bytes);

    String hexColor = digest.toString().substring(0, 6);

    return Color(int.parse('0xFF$hexColor'));
  }

  String _getAvatarText(String name) {
    String str = name[0].toUpperCase();
    List<String> parts = name.split(' ');
    if (parts.length > 1) {
      str += parts[1][0].toUpperCase();
    } else if (parts[0].length > 1) {
      str += parts[0][1].toUpperCase();
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _getAvatarColor(cartItem.userId);
    final avatarText = _getAvatarText(cartItem.userName);

    return SizedBox(
      height: 100.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 30.w,
            height: 30.h,
            child: CircleAvatar(
              radius: 15.w,
              backgroundColor: avatarColor,
              child: Text(
                avatarText,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
