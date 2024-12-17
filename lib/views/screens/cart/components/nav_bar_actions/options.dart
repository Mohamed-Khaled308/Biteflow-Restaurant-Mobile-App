import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/widgets/dialogues/action_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CartViewModel>();
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () async {
        await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            MediaQuery.of(context).size.width - 50.w,
            kToolbarHeight,
            0.0,
            0.0,
          ),
          items: [
            PopupMenuItem(
              padding: const EdgeInsets.all(0),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                leading: const Icon(Icons.person_add),
                title: Text(
                  'Invite',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text(
                        'Scan this QR Code to be added to the order',
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        height: 200,
                        width: 200,
                        alignment: Alignment.center,
                        child: QrImageView(
                          foregroundColor: Theme.of(context).secondaryHeaderColor,
                          data: viewModel.cart!.id,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            PopupMenuItem(
              padding: const EdgeInsets.all(0),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                leading: const Icon(Icons.logout),
                title: Text(
                  'Leave Order',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ActionDialogue(
                          title: 'Leave Order',
                          body:
                              'Are you sure you want to cancel the order and leave the cart?',
                          actionLabel: 'Leave',
                          onAction: () {
                            Navigator.pop(context);
                            viewModel.leaveCart();
                          });
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
