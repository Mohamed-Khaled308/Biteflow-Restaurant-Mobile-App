import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/manager_promotional_offers_view_model.dart';
import 'package:biteflow/views/screens/manager_promotional_offers/manager_promotional_offers_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ManagerPromotionalOffersView extends StatelessWidget {
  const ManagerPromotionalOffersView({super.key});

  // final ManagerPromotionalOffersViewModel managerPromotionalOffersViewModel =
  //     getIt<ManagerPromotionalOffersViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ManagerPromotionalOffersViewModel>(),
      child:  ManagerPromotionalOffersScreen(),
    );
  }
}
