import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/viewmodels/cart_item_view_model.dart';
import 'package:biteflow/views/screens/cart_item/components/add_participants.dart';
import 'package:biteflow/views/screens/cart_item/components/bottom_bar.dart';
import 'package:biteflow/views/screens/cart_item/components/add_notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CartItemScreen extends StatelessWidget {
  const CartItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CartItemViewModel>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                viewModel.cartItem.menuItem.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              viewModel.cartItem.menuItem.title,
                              style: TextStyle(
                                color: ThemeConstants.blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.sp,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            const Icon(Icons.star, color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(viewModel.cartItem.menuItem.rating.toString()),
                            SizedBox(
                              width: 8.w,
                            )
                          ],
                        ),
                        Text(
                          viewModel.cartItem.menuItem.description,
                          style: TextStyle(
                            color: ThemeConstants.blackColor60,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AddParticipants(),
                  AddNotes(
                    initialNote: viewModel.cartItem.notes,
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
