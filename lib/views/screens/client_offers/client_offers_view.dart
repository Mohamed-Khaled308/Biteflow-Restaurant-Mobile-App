import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/viewmodels/client_offers_view_model.dart';
import 'package:biteflow/views/screens/client_offers/client_offers_screen.dart';
import 'package:biteflow/views/screens/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class ClientOffersView extends StatelessWidget {
  const ClientOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => getIt<ClientOffersViewModel>()),
      ],
      child: const ClientOffersScreen(),
    );
  }
}
