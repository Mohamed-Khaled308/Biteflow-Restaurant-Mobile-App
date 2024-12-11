import 'package:biteflow/core/constants/navbar_constants.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/user.dart';



class EntryPointViewModel extends BaseModel {
  int _selectedIndex = 0;

  final User _authenticatedUser = getIt<UserProvider>().user!;
  List<Map<String, dynamic>> _navItems = [];
  List<Widget> _screens = [];

  EntryPointViewModel() {
    _navItems = _authenticatedUser.role == 'Client' ? NavbarConstants.clientNavItems : NavbarConstants.managerNavItems;
    _screens = _authenticatedUser.role == 'Client' ? NavbarConstants.clientScreens : NavbarConstants.managerScreens;
  }

  int get selectedIndex => _selectedIndex;
  List<Map<String, dynamic>> get navItems => _navItems;
  Widget get currentScreen => _screens[_selectedIndex];

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
