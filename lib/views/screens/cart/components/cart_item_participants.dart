import 'dart:math';
import 'package:biteflow/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemParticipants extends StatelessWidget {
  const CartItemParticipants({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  /// Generates a random color for the avatar background
  Color _getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(100),
      random.nextInt(100),
    );
  }

  /// Generates a list of fake user initials for demonstration
  List<String> _getFakeUsers() {
    return ['AA', 'BB', 'CC']; // Replace with actual user initials in your app
  }

  @override
  Widget build(BuildContext context) {
    final clientInitials = _getFakeUsers(); // Get user initials
    final avatarColors = clientInitials
        .map((_) => _getRandomColor())
        .toList(); // Assign random colors for avatars.
    return Container(
      height: 100.h,

      // for debugging purposes
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.0),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 50.w,
            height: 30.h,
            child: Stack(
              children: List.generate(clientInitials.length, (index) {
                return Positioned(
                  left: index * 10.w,
                  child: CircleAvatar(
                    radius: 15.w,
                    backgroundColor: avatarColors[index],
                    child: Text(
                      clientInitials[index],
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
