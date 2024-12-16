import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/viewmodels/cart_item_view_model.dart';
import 'package:biteflow/locator.dart';

class AddNotes extends StatefulWidget {
  final String initialNote;

  const AddNotes({super.key, this.initialNote = ''});

  @override
  AddNotesState createState() => AddNotesState();
}

class AddNotesState extends State<AddNotes> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openNoteBottomSheet(BuildContext context) {
    final viewModel = context.read<CartItemViewModel>();
    final isCurrentUserOwner =
        viewModel.cartItem.userId == getIt<UserProvider>().user!.id;

    if (!isCurrentUserOwner) {
      return; // Do nothing if the current user is not the owner
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          child: Builder(
            builder: (BuildContext innerContext) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FocusScope.of(innerContext).requestFocus(_focusNode);
              });

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        labelText: 'Special request',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        _addNote(innerContext);
                      },
                      maxLines: 3,
                    ),
                    verticalSpaceMassive,
                    verticalSpaceMassive,
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _addNote(BuildContext context) {
    final viewModel = context.read<CartItemViewModel>();
    final newNote = _controller.text;
    viewModel.updateNote(newNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartItemViewModel>();
    final isCurrentUserOwner =
        viewModel.cartItem.userId == getIt<UserProvider>().user!.id;

    return InkWell(
      onTap: isCurrentUserOwner ? () => _openNoteBottomSheet(context) : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.mode_comment_outlined,
              size: 28.sp,
              color: isCurrentUserOwner
                  ? Theme.of(context).secondaryHeaderColor
                  : ThemeConstants.greyColor,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Any special requests?',
                    style: TextStyle(
                      color: isCurrentUserOwner
                          ? Theme.of(context).secondaryHeaderColor
                          : ThemeConstants.greyColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (viewModel.notes.isNotEmpty)
                    Text(
                      viewModel.notes,
                      style: TextStyle(
                        color: isCurrentUserOwner
                            ? Theme.of(context).secondaryHeaderColor
                            : ThemeConstants.greyColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: isCurrentUserOwner
                  ? () => _openNoteBottomSheet(context)
                  : null,
              child: Text(
                viewModel.notes.isNotEmpty ? 'Edit' : 'Add note',
                style: TextStyle(
                  color: isCurrentUserOwner
                      ? Theme.of(context).primaryColor
                      : ThemeConstants.greyColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
