import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CartItemNotesDialog extends StatelessWidget {
  CartItemNotesDialog({super.key, required this.itemId});

  final NavigationService _navigationService = getIt<NavigationService>();
  final _notesController = TextEditingController();
  final String itemId;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();
    return AlertDialog(
      title: const Text('Special Note'),
      content: TextField(
        controller: _notesController,
        decoration: InputDecoration(
          labelText: 'Notes',
          labelStyle: const TextStyle(color: ThemeConstants.blueColor),
          hintText: 'Enter your notes here',
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ThemeConstants.defaultBorderRadious),
            borderSide: const BorderSide(color: ThemeConstants.blueColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ThemeConstants.defaultBorderRadious),
            borderSide: const BorderSide(color: ThemeConstants.blueColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(ThemeConstants.defaultBorderRadious),
            borderSide: BorderSide(color: ThemeConstants.blueColor, width: 2.w),
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
          style:
              TextButton.styleFrom(foregroundColor: ThemeConstants.blueColor),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _navigationService.pop();
            viewModel.updateItemNotes(itemId, _notesController.text);
            _notesController.clear();
          },
          style:
              TextButton.styleFrom(foregroundColor: ThemeConstants.blueColor),
          child: const Text('Okay'),
        ),
      ],
    );
  }
}
