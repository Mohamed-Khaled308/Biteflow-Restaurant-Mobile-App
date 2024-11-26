import 'package:biteflow/viewmodels/menu_view_model.dart';
import 'package:biteflow/views/screens/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<MenuViewModel>(),
      child: const MenuScreen(),
    );
  }
}
