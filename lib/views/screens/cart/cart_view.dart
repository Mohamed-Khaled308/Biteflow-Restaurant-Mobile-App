import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/screens/cart/cart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<CartViewModel>(),
      child: const CartScreen(),
    );
  }
}
