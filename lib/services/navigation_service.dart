import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    _navigationKey.currentState!.pop();
  }

  Future<dynamic> navigateTo(Widget screen, {dynamic arguments}) {
    return _navigationKey.currentState!.push(
      MaterialPageRoute(
        builder: (_) => screen,
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }

  Future<dynamic> replaceWith(Widget screen, {dynamic arguments}) {
    return _navigationKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => screen,
        settings: RouteSettings(arguments: arguments),
      ),
      (Route<dynamic> route) => false,
    );
  }
  Future<dynamic> navigateAndReplace(Widget screen, {dynamic arguments}) {
    return _navigationKey.currentState!.pushReplacement(
      MaterialPageRoute(
        builder: (_) => screen,
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }
}
