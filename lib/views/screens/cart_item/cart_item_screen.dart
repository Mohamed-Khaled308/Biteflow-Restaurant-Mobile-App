import 'package:biteflow/viewmodels/cart_item_view_model.dart';
import 'package:biteflow/views/screens/cart_item/components/add_participants.dart';
import 'package:biteflow/views/screens/cart_item/components/bottom_bar.dart';
import 'package:biteflow/views/screens/cart_item/components/add_notes.dart';
import 'package:biteflow/views/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CartItemScreen extends StatelessWidget {
  const CartItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartItemViewModel>();
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
                        Text(
                          viewModel.cartItem.menuItem.title,
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                          ),
                        ),
                        Text(
                          viewModel.cartItem.menuItem.description,
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  const AddParticipants(),
                  AddNotes(
                    initialNote: viewModel.notes,
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
