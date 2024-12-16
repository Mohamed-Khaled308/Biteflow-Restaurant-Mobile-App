import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/widgets/user/user_avatar.dart';
import 'package:biteflow/views/widgets/user/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MembersFilter extends StatelessWidget {
  const MembersFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();
    final filteredUser =
        viewModel.filterUserId != null && viewModel.cart != null
            ? viewModel.cart!.participants.firstWhere(
                (participant) => participant.id == viewModel.filterUserId)
            : null;

    return IconButton(
      icon: SizedBox(
        width: 30.w,
        height: 30.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            filteredUser == null
                ? SizedBox(
                    width: 30.w,
                    height: 30.h,
                    child: CircleAvatar(
                      radius: 15.r,
                      child: const Icon(Icons.group),
                    ),
                  )
                : UserAvatar(
                    userId: filteredUser.id, userName: filteredUser.name),
            Positioned(
              right: -2.w,
              bottom: -2.h,
              child: CircleAvatar(
                radius: 8.r,
                backgroundColor: ThemeConstants.whiteColor,
                child: Icon(
                  Icons.filter_list,
                  size: 12.sp,
                  color: ThemeConstants.darkGreyColor,
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: () async {
        // Open the menu and await the selected filter value
        final selectedFilter = await showMenu<String>(
          menuPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 12.h),
          context: context,
          position: RelativeRect.fromLTRB(
            MediaQuery.of(context).size.width - 50.w,
            kToolbarHeight,
            0.0,
            0.0,
          ),
          items: [
            PopupMenuItem<String>(
              padding: const EdgeInsets.all(0),
              value: 'All Members', // Use "All Members" string for the option
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
                color: viewModel.filterUserId == null
                    ? ThemeConstants.greyColor.withOpacity(0.5)
                    : null,
                child: Row(
                  children: [
                    SizedBox(width: 8.w),
                    SizedBox(
                      width: 30.w,
                      height: 30.h,
                      child: CircleAvatar(
                        radius: 15.r,
                        child: const Icon(Icons.group),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'All Members',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...viewModel.cart!.participants.map((participant) {
              final isSelected = viewModel.filterUserId == participant.id;
              return PopupMenuItem<String>(
                padding: const EdgeInsets.all(0),
                value: participant.id, // Use participant's ID for other options
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  color: isSelected
                      ? ThemeConstants.greyColor.withOpacity(0.5)
                      : null,
                  child: UserCard(
                    name: participant.name,
                    id: participant.id,
                  ),
                ),
              );
            }),
          ],
        );

        // Only update the filter if a valid selection is made
        if (selectedFilter != null) {
          if (selectedFilter == 'All Members') {
            // If "All Members" is selected, reset the filter
            viewModel.setFilter(null);
          } else {
            // Otherwise, set the filter to the selected participant's ID
            viewModel.setFilter(selectedFilter);
          }
        }
      },
    );
  }
}
