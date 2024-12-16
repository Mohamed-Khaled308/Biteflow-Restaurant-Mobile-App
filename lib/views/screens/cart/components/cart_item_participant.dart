import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/views/widgets/user/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemParticipant extends StatelessWidget {
  const CartItemParticipant({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    // Filter participants with 'done' status
    final doneParticipants = cartItem.participants
        .where((participant) => participant.status == ParticipantStatus.done)
        .toList();
    double leftPadding = doneParticipants.length == 1
        ? 20
        : doneParticipants.length == 2
            ? 10
            : 0;
    return SizedBox(
      height: 100.h,
      width: 50.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 50.w,
            height: 30.h,
            child: Stack(
              children: [
                // Display first participant's avatar if available
                if (doneParticipants.isNotEmpty)
                  Positioned(
                    left: leftPadding,
                    child: UserAvatar(
                        userId: doneParticipants[0].id,
                        userName: doneParticipants[0].name),
                  ),
                // Display second participant's avatar if available
                if (doneParticipants.length > 1)
                  Positioned(
                    left: 10 + leftPadding,
                    child: UserAvatar(
                        userId: doneParticipants[1].id,
                        userName: doneParticipants[1].name),
                  ),
                // If there are more than 2 participants, show the "+X" indicator
                if (doneParticipants.length > 2)
                  Positioned(
                    left: 20 + leftPadding,
                    child: SizedBox(
                      width: 30.w,
                      height: 30.h,
                      child: CircleAvatar(
                        radius: 15.r,
                        backgroundColor: ThemeConstants.greyColor,
                        child: Text(
                          '+${doneParticipants.length - 2}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
