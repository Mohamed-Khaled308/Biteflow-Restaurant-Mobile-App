import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/viewmodels/menu_view_model.dart';
import 'package:biteflow/views/screens/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class MenuView extends StatelessWidget {
  final String restaurantId;

  const MenuView({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => getIt<MenuViewModel>()),
      ChangeNotifierProvider(create: (_) => getIt<CartViewModel>()),
    ], child: MenuScreen(restaurantId: restaurantId));
  }
}
