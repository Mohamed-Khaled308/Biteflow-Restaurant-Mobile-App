import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/views/screens/menu/menu_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItems extends StatelessWidget {
  const AddItems({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CartViewModel>();
    return TextButton(
      onPressed: () {
        viewModel.setIsCartOpen = true;
        getIt<NavigationService>().navigateTo(
          MenuView(restaurantId: viewModel.cart!.restaurantId),
        );
      },
      child: const Text(
        'Add Items',
        style: TextStyle(color: ThemeConstants.whiteColor),
      ),
    );
  }
}
