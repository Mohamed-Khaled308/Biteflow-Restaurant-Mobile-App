import 'package:biteflow/viewmodels/manager_offers_view_model.dart';
import 'package:biteflow/views/screens/manager_offers/manage_offers_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class ManagerOffersView extends StatelessWidget {
  const ManagerOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    ManagerOffersViewModel managerOffersViewModel =
        getIt<ManagerOffersViewModel>();
    managerOffersViewModel.loadOrdersData();
    return ChangeNotifierProvider(
      create: (_) => managerOffersViewModel,
      child: const ManagerOffersScreen(),
    );
  }
}
