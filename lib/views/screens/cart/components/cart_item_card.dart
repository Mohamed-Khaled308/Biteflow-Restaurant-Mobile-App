import 'dart:math';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/widgets/cart/card_trait.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard(this.cartItem, {super.key});

  final CartItem cartItem;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  final _notesController = TextEditingController();
  final NavigationService _navigationService = getIt<NavigationService>();

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
    final viewModel = context.watch<CartViewModel>();
    final clientInitials = _getFakeUsers(); // Get user initials
    final avatarColors = clientInitials
        .map((_) => _getRandomColor())
        .toList(); // Assign random colors for avatars.

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
              builder: (ctx) => AlertDialog(
                title: const Text('Special Note'),
                content: TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    labelStyle:
                        const TextStyle(color: ThemeConstants.blueColor),
                    hintText: 'Enter your notes here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          ThemeConstants.defaultBorderRadious),
                      borderSide:
                          const BorderSide(color: ThemeConstants.blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          ThemeConstants.defaultBorderRadious),
                      borderSide:
                          const BorderSide(color: ThemeConstants.blueColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          ThemeConstants.defaultBorderRadious),
                      borderSide: BorderSide(
                          color: ThemeConstants.blueColor, width: 2.w),
                    ),
                    filled: true,
                    fillColor: ThemeConstants.lightGreyColor,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                  maxLength: 100,
                  style: TextStyle(fontSize: 16.sp),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _navigationService.pop();
                      _notesController.clear();
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: ThemeConstants.blueColor),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _navigationService.pop();
                      viewModel.updateItemNotes(
                          widget.cartItem.menuItem.id, _notesController.text);
                      _notesController.clear();
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: ThemeConstants.blueColor),
                    child: const Text('Okay'),
                  ),
                ],
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110.w,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image:
                              NetworkImage(widget.cartItem.menuItem.imageUrl),
                          width: 110.w, // Image size
                          height: 100.h,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80.w,
                              height: 80.h,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white.withOpacity(0.8),
                          ),
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  viewModel.updateItemQuantity(
                                      widget.cartItem.menuItem.id,
                                      widget.cartItem.quantity - 1);
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text('${widget.cartItem.quantity}'),
                              IconButton(
                                onPressed: () {
                                  viewModel.updateItemQuantity(
                                      widget.cartItem.menuItem.id,
                                      widget.cartItem.quantity + 1);
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cartItem.menuItem.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeConstants.blackColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      const OrderItemCardTrait(
                        Icons.edit_note_rounded,
                        Colors.orange,
                        'Edit',
                        Colors.orange,
                      ),
                      verticalSpaceMedium,
                      Text(
                        '${widget.cartItem.menuItem.price} EGP',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: ThemeConstants.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50.w,
                  height: 50.h,
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
          ),
        ),
      ),
    );
  }
}
