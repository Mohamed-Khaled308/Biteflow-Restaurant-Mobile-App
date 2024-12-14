import 'dart:math';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_item_view_model.dart';
import 'package:biteflow/views/screens/cart_item/components/participants_list_screen.dart';
import 'package:biteflow/views/widgets/user/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddParticipants extends StatelessWidget {
  const AddParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartItemViewModel>();

    // Filter participants with "done" status
    final doneParticipants = viewModel.cartItem.participants
        .where((participant) => participant.status == ParticipantStatus.done)
        .toList();

    return InkWell(
      onTap: () {
        getIt<NavigationService>().navigateTo(
          ChangeNotifierProvider.value(
            value: viewModel,
            child: const ParticipantsListScreen(),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Text(
              'Participants',
              style: TextStyle(
                color: ThemeConstants.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            const Icon(
              Icons.person_add,
              color: ThemeConstants.primaryColor,
            ),
            Expanded(child: Container()),
            SizedBox(
              width: 15.w * min(doneParticipants.length, 5) + 30.w,
              height: 30.h,
              child: Stack(
                children: [
                  for (int i = 0; i < doneParticipants.length && i < 5; i++)
                    Positioned(
                      left: i * 15.w,
                      child: UserAvatar(
                        userId: doneParticipants[i].id,
                        userName: doneParticipants[i].name,
                      ),
                    ),
                  if (doneParticipants.length > 5)
                    Positioned(
                      left: 75.w,
                      child: SizedBox(
                        width: 30.w,
                        height: 30.h,
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: ThemeConstants.greyColor,
                          child: Text(
                            '+${doneParticipants.length - 5}',
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
      ),
    );
  }
}
