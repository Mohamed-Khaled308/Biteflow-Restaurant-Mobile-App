import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/manager_promotional_offers_view_model.dart';
import 'package:biteflow/views/screens/manager_promotional_offers/manager_promotional_offers_view.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/views/screens/home/home_view.dart';
import 'package:biteflow/views/screens/order_details/order_details_view.dart';
import 'package:biteflow/views/screens/profile/profile_view.dart';
import 'package:biteflow/views/screens/manager_menu/manager_menu_view.dart';
import 'package:biteflow/views/screens/manager_orders/manager_orders_view.dart';
import 'package:provider/provider.dart';

class NavbarConstants {

  static final List<Map<String, dynamic>> clientNavItems = [
    {'icon': 'assets/icons/home.svg', 'title': 'Home'},
    {'icon': 'assets/icons/order.svg', 'title': 'Orders'},
    {'icon': 'assets/icons/profile.svg', 'title': 'Profile'},
  ];


  static final List<Widget> clientScreens = [
    const HomeView(),
    const OrderDetailsView(),
    const ProfileView(),
  ];

  static final List<Map<String, dynamic>> managerNavItems = [
    {'icon': 'assets/icons/menu.svg', 'title': 'Menu'},
    {'icon': 'assets/icons/order.svg', 'title': 'Orders'},
    {'icon': 'assets/icons/offer.svg', 'title': 'Offers'},
    {'icon': 'assets/icons/profile.svg', 'title': 'Profile'},
  ];

static final List<Widget> managerScreens = [
  const ManagerMenuView(),
  const ManagerOrdersView(),
  ChangeNotifierProvider(
    create: (_) => getIt<ManagerPromotionalOffersViewModel>(),
    child: const ManagerPromotionalOffersView(),
  ),
  const ProfileView(),
];
}
