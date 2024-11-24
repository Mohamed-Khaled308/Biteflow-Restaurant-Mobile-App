import 'package:biteflow/core/result.dart';
import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/views/screens/auth/signup/client_signup_screen.dart';
import 'package:biteflow/views/screens/auth/login/login_view.dart';
import 'package:biteflow/views/screens/auth/signup/manager_signup_screen.dart';
import 'package:biteflow/views/screens/entry_point/entry_point_view.dart';
import 'package:flutter/material.dart';

class SignupViewModel extends BaseModel {
  String _selectedRole = 'Client';
  dynamic _selectedRoleWidget = ClientSignupView();
  final AuthService _authService = getIt<AuthService>();
  final NavigationService _navigationService = getIt<NavigationService>();

  Future<Result<bool>> _signUpUser() async {
    if (_selectedRole == 'Client') {
      Map<String, dynamic> info =
          (_selectedRoleWidget as ClientSignupView).getInfo();
      return await _authService.signUpClientWithEmail(clientInfo: info);
    } else {
      Map<String, dynamic> info =
          (_selectedRoleWidget as ManagerSignupView).getInfo();
      return await _authService.signUpManagerWithEmail(managerInfo: info);
    }
  }

  void signUp() async {
    Result result = await _signUpUser();
    if (result.isSuccess) {
      _navigationService.replaceWith(const EntryPointView());
    } else {
      // TODO display error message.
    }
  }

  void setRole(String role) {
    _selectedRole = role;
    if (role == 'Client') {
      _selectedRoleWidget = ClientSignupView();
    } else {
      _selectedRoleWidget = ManagerSignupView();
    }
    notifyListeners();
  }

  String get selectedRole => _selectedRole;
  Widget get selectedRoleWidget => _selectedRoleWidget;
  void navigateToLogin() => _navigationService.navigateTo(LoginView());
}
