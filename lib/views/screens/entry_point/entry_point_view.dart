import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/core/utils/auth_helper.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/models/user.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:biteflow/views/screens/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/entry_point_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'entry_point_screen.dart';
import 'package:biteflow/viewmodels/manager_menu_view_model.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';

class EntryPointView extends StatelessWidget {
  EntryPointView({super.key});

  final _navigationService = getIt<NavigationService>();

  Future<User?> _initializeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userEmail = prefs.getString('userEmail');
    final userName = prefs.getString('userName');
    final userRole = prefs.getString('userRole');

    if (userId != null &&
        userEmail != null &&
        userName != null &&
        userRole != null) {
      final userProvider = getIt<UserProvider>();

      userProvider.setUser = userRole == AuthHelper.clientRole
          ? Client(id: userId, name: userName, email: userEmail)
          : Manager(id: userId, name: userName, email: userEmail);

      userProvider.setLoggedIn = true;

      final savedCartId = prefs.getString('cart_$userId');
      if (savedCartId != null) {
        getIt<CartViewModel>().joinCart(savedCartId);
      }
      return UserProvider().currentUser;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    if (!userProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final user = await _initializeUser();
        // print(user);
        if (user == null) {
          _navigationService.replaceWith(const LoginView());
        }
      });
      return const SizedBox.shrink();
    }

    if (userProvider.user!.role == 'Manager') {
      ManagerMenuViewModel managerMenuViewModel = getIt<ManagerMenuViewModel>();
      managerMenuViewModel
          .loadRestaurantData(); // can be made automatic in constructor
      ManagerOrdersViewModel managerOrdersViewModel =
          getIt<ManagerOrdersViewModel>();
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
