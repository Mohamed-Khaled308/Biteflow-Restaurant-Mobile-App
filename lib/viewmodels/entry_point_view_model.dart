import 'package:biteflow/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/views/screens/home/home_view.dart';
import 'package:biteflow/views/screens/order_details/order_details_view.dart';
import 'package:biteflow/views/screens/profile/profile_view.dart';
import 'package:biteflow/views/screens/search/search_view.dart';
// import 'package:biteflow/views/screens/menu/menu_view.dart';
// import 'package:biteflow/views/screens/manager_menu/manager_menu_view.dart';
// import 'package:biteflow/views/screens/manager_orders/manager_orders_view.dart';

class EntryPointViewModel extends BaseModel {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': 'assets/icons/home.svg', 'title': 'Home'},
    {'icon': 'assets/icons/search.svg', 'title': 'Search'},
    // {'icon': 'assets/icons/order.svg', 'title': 'Menu'},
    {'icon': 'assets/icons/order.svg', 'title': 'Orders'},
    {'icon': 'assets/icons/profile.svg', 'title': 'Profile'},
  ];

  final List<Widget> _screens = [
    const HomeView(),
    const SearchView(),
    // const MenuView(),
    // const ManagerOrdersView(),
    const OrderDetailsView(),
    const ProfileView(),
    // const ManagerMenuView(),
  ];

  int get selectedIndex => _selectedIndex;
  List<Map<String, dynamic>> get navItems => _navItems;
  Widget get currentScreen => _screens[_selectedIndex];

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
