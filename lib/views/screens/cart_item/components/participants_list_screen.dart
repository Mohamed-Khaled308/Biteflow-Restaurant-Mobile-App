import 'package:biteflow/viewmodels/cart_item_view_model.dart';
import 'package:biteflow/views/widgets/user/user_avatar.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/core/constants/theme_constants.dart';

class ParticipantsListScreen extends StatelessWidget {
  const ParticipantsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = context.read<CartViewModel>();
    final cartItemViewModel = context.watch<CartItemViewModel>();
    final cartParticipants = cartViewModel.cart!.participants;
    final itemParticipants = cartItemViewModel.cartItem.participants;
    final currentUserId = cartItemViewModel.cartItem.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invite Members',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ThemeConstants.whiteColor,
          ),
        ),
        backgroundColor: ThemeConstants.primaryColor,
        iconTheme: const IconThemeData(
          color: ThemeConstants.whiteColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ListView.builder(
          itemCount: cartParticipants.length,
          itemBuilder: (context, index) {
            final participant = cartParticipants[index];

            final isInItemParticipants =
                itemParticipants.any((item) => item.id == participant.id);
            final isPending = itemParticipants.any((item) =>
                item.id == participant.id &&
                item.status == ParticipantStatus.pending);
            final isAccepted = itemParticipants.any((item) =>
                item.id == participant.id &&
                item.status == ParticipantStatus.done);

            return ListTile(
              leading: UserAvatar(
                  userId: participant.id, userName: participant.name),
              title: Text(
                participant.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                isInItemParticipants
                    ? (isPending
                        ? 'Invited'
                        : (currentUserId == participant.id
                            ? 'Owner'
                            : 'Accepted'))
                    : 'Uninvited',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ThemeConstants.blackColor60,
                ),
              ),
              trailing: isInItemParticipants
                  ? (isPending
                      ? Text(
                          'Pending',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: ThemeConstants.primaryColor),
                        )
                      : (isAccepted && currentUserId != participant.id)
                          ? IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: ThemeConstants.errorColor,
                              ),
                              onPressed: () {
                                // Show confirmation dialog before removing
                                _showRemoveConfirmationDialog(
                                    context, cartItemViewModel, participant);
                              },
                            )
                          : null)
                  : Checkbox(
                      value: cartItemViewModel.selectedParticipants
                          .contains(participant),
                      onChanged: (bool? value) {
                        if (value != null) {
                          cartItemViewModel.toggleParticipantSelection(
                              participant, value);
                        }
                      },
                    ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cartItemViewModel.sendInvitations();
        },
        backgroundColor: ThemeConstants.primaryColor,
        child: const Icon(
          Icons.send,
          color: ThemeConstants.whiteColor,
        ),
      ),
    );
  }

  void _showRemoveConfirmationDialog(BuildContext context,
      CartItemViewModel cartItemViewModel, CartParticipant participant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove ${participant.name}'),
          content: const Text(
              'Are you sure you want to remove this user from the item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cartItemViewModel.removeParticipantFromItem(participant.id);
                Navigator.of(context).pop();
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
