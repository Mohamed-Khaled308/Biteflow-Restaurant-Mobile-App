import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/cart_item_view_model.dart';
import 'package:biteflow/views/screens/cart_item/cart_item_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CartItemView extends StatelessWidget {
  final String itemId;
  const CartItemView({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => getIt<CartItemViewModel>(param1: itemId),
      child: const CartItemScreen(),
    );
  }
}
