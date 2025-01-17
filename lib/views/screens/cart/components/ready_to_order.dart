import 'package:biteflow/locator.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/screens/split_bill/split_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReadyToOrder extends StatelessWidget {
  const ReadyToOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();
    final isCreator = viewModel.isCreator;
    final allParticipantsReady = viewModel.checkAllParticipantsDone();
    final pendingParticipants = viewModel.cart!.participants
            .where(
              (participant) => participant.status == ParticipantStatus.pending,
            )
            .length -
        1;

    return GestureDetector(
      onTap: viewModel.toggleParticipantStatus,
      child: isCreator
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: allParticipantsReady
                      ? Text(
                          'Everyone\'s ready!',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Waiting for others',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              textAlign: TextAlign.center,
                              '$pendingParticipants  remaining',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: allParticipantsReady
                      ? () {
                          getIt<NavigationService>()
                              .navigateTo(const SplitScreen());
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allParticipantsReady
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 38.w, vertical: 12.h),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Ready to Order',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: viewModel.isReady
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
                Switch(
                  value: viewModel.isReady,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.withOpacity(0.3),
                  onChanged: (bool value) {
                    viewModel.toggleParticipantStatus();
                  },
                ),
              ],
            ),
    );
  }
}
