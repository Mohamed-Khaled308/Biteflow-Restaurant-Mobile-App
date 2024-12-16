import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/cart_item_view_model.dart';
import 'package:biteflow/views/widgets/dialogues/action_dialogue.dart';
import 'package:biteflow/views/widgets/user/user_avatar.dart';
import 'package:logger/logger.dart';
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
    getIt<Logger>().d('rebuild');
    final cartViewModel = context.watch<CartViewModel>();
    final cartItemViewModel = context.watch<CartItemViewModel>();
    final cartParticipants = cartViewModel.cart!.participants;

    // Sort the participants so the one matching the cartItem.userId appears first
    final cartItemUserId = cartItemViewModel.cartItem.userId;
    cartParticipants.sort((a, b) {
      if (a.id == cartItemUserId) return -1; // Move the user to the top
      if (b.id == cartItemUserId) return 1; // Keep the other user at the bottom
      return 0; // Keep the rest in the same order
    });

    final itemParticipants = cartItemViewModel.cartItem.participants;

    // Check if the current user is the owner
    final isCurrentUserOwner =
        cartItemViewModel.cartItem.userId == getIt<UserProvider>().user!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invite Members',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme:  IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
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
              onTap: isCurrentUserOwner
                  ? () {
                      final isSelected = cartItemViewModel.selectedParticipants
                          .contains(participant);
                      cartItemViewModel.toggleParticipantSelection(
                          participant, !isSelected);
                    }
                  : null,
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
                        ? 'Pending' // Invitation sent but not accepted yet
                        : (cartItemUserId == participant.id
                            ? 'Owner' // For the owner of the cart item
                            : 'Joined')) // Invitation accepted
                    : 'Not Invited', // Not invited yet
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              trailing: isCurrentUserOwner
                  ? (isInItemParticipants
                      ? (isPending
                          ? Text(
                              'Pending',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : (isAccepted && cartItemUserId != participant.id)
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: ThemeConstants.errorColor,
                                  ),
                                  onPressed: () {
                                    // Show confirmation dialog before removing
                                    _showRemoveConfirmationDialog(context,
                                        cartItemViewModel, participant);
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
                        ))
                  : null,
            );
          },
        ),
      ),
      floatingActionButton: isCurrentUserOwner
          ? FloatingActionButton(
              onPressed: cartItemViewModel.selectedParticipants.isEmpty
                  ? null
                  : cartItemViewModel.sendInvitations,
              backgroundColor: cartItemViewModel.selectedParticipants.isEmpty
                  ? ThemeConstants.greyColor
                  : Theme.of(context).primaryColor,
              child:  Icon(
                Icons.send,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            )
          : null,
    );
  }

  void _showRemoveConfirmationDialog(BuildContext context,
      CartItemViewModel cartItemViewModel, CartParticipant participant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ActionDialogue(
            title: 'Remove ${participant.name}',
            body: 'Are you sure you want to remove this user from the item?',
            actionLabel: 'Remove',
            onAction: () {
              cartItemViewModel.removeParticipantFromItem(participant.id);
              Navigator.of(context).pop();
            });
      },
    );
  }
}
