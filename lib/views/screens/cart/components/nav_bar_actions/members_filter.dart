import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/widgets/user/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MembersFilter extends StatelessWidget {
  const MembersFilter({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CartViewModel>();
    return IconButton(
      icon: const Icon(
        Icons.filter_list,
      ),
      onPressed: () async {
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
              value: null,
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
                value: participant.id,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    color: isSelected
                        ? ThemeConstants.greyColor.withOpacity(0.5)
                        : null,
                    child:
                        UserCard(name: participant.name, id: participant.id)),
              );
            })
          ],
        );
        if (selectedFilter != null) {
          viewModel.setFilter(selectedFilter);
        } else {
          viewModel.setFilter(null);
        }
      },
    );
  }
}
