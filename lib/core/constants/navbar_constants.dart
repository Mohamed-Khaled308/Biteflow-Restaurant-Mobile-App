// import 'package:biteflow/views/screens/client_offers/client_offers_view.dart';
// import 'package:biteflow/views/screens/manager_offers/manage_offers_view.dart';
import 'package:biteflow/views/screens/payment/payment_test_view.dart';
import 'package:biteflow/views/screens/manager_promotional_offers/manager_promotional_offers_view.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/views/screens/home/home_view.dart';
import 'package:biteflow/views/screens/profile/profile_view.dart';
import 'package:biteflow/views/screens/manager_menu/manager_menu_view.dart';
import 'package:biteflow/views/screens/manager_orders/manager_orders_view.dart';
import 'package:biteflow/views/screens/order_details/orders_view.dart';
// import 'package:biteflow/views/screens/payment/payment_test_view.dart';

class NavbarConstants {
  static final List<Map<String, dynamic>> clientNavItems = [
    {'icon': 'assets/icons/home.svg', 'title': 'Home'},
    // {'icon': 'assets/icons/home.svg', 'title': 'Offers'},
    {'icon': 'assets/icons/order.svg', 'title': 'Orders'},
    {'icon': 'assets/icons/profile.svg', 'title': 'Profile'},
  ];

  static final List<Widget> clientScreens = [
    const HomeView(),
    // const ClientOffersView(),
    const OrdersView(),
    // const ProfileView(),
    const PaymentTestView(),
  ];

  static final List<Map<String, dynamic>> managerNavItems = [
    {'icon': 'assets/icons/home.svg', 'title': 'Menu'},
    {'icon': 'assets/icons/home.svg', 'title': 'Offers'},
    {'icon': 'assets/icons/order.svg', 'title': 'Orders'},
    {'icon': 'assets/icons/profile.svg', 'title': 'Profile'},
  ];

  static final List<Widget> managerScreens = [
    const ManagerMenuView(),
    const ManagerPromotionalOffersView(),
    // const ManagerOffersView(),
    const ManagerOrdersView(),
    const ProfileView(),
  ];
}
