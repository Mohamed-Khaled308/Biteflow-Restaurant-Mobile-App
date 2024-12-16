import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:biteflow/views/screens/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/entry_point_view_model.dart';
import 'entry_point_screen.dart';
import 'package:biteflow/viewmodels/manager_menu_view_model.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';



class EntryPointView extends StatelessWidget {
  EntryPointView({super.key});

  final _navigationService = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    if (!userProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigationService.replaceWith(const LoginView());
      });
      return const SizedBox.shrink();
    }

    if(userProvider.user!.role == 'Manager'){
      ManagerMenuViewModel managerMenuViewModel = getIt<ManagerMenuViewModel>();
      managerMenuViewModel.loadRestaurantData(); // can be made automatic in constructor
      ManagerOrdersViewModel managerOrdersViewModel = getIt<ManagerOrdersViewModel>();
      managerOrdersViewModel.loadOrdersData();
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => getIt<EntryPointViewModel>(),
          ),
          ChangeNotifierProvider(
            create: (_) => managerMenuViewModel,
          ),
          ChangeNotifierProvider(
            create: (_) => managerOrdersViewModel,
          ),
        ],
        child: const EntryPointScreen(),
      );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => getIt<EntryPointViewModel>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<ClientOrdersViewModel>(),
          ),
        ],
        child: const EntryPointScreen(),
      );
    }

    
    // return ChangeNotifierProvider(
    //   create: (_) => getIt<EntryPointViewModel>(),
    //   child: const EntryPointScreen(),
    // );
  }
}
