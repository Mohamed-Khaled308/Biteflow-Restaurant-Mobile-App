import 'package:biteflow/viewmodels/manager_menu_view_model.dart';
import 'package:biteflow/viewmodels/manager_create_item_view_model.dart';
import 'package:biteflow/views/screens/manager_menu/manager_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class ManagerMenuView extends StatelessWidget {
  const ManagerMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<ManagerMenuViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<ManagerCreateItemViewModel>(),
        ),
      ],
      child: const ManagerMenuScreen(),
    );
  }
}
