import 'package:biteflow/core/result.dart';
import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/views/screens/auth/login/login_view.dart';
import 'package:biteflow/views/screens/entry_point/entry_point_view.dart';

class SignupViewModel extends BaseModel {
  String _selectedRole = 'Client';
  final AuthService _authService = getIt<AuthService>();
  final NavigationService _navigationService = getIt<NavigationService>();

  Map<String, dynamic> _getInfo(String email, String password, String name) {
    Map<String, dynamic> info = {};
    info['email'] = email;
    info['password'] = password;
    info['name'] = name;
    info['role'] = _selectedRole;
    return info;
  }

  void signUp(
      {required String email,
      required String password,
      required String name}) async {
    Map<String, dynamic> info = _getInfo(email, password, name);
    Result result = await _authService.signUpWithEmail(info: info);
    if (result.isSuccess) {
      _navigationService.replaceWith(const EntryPointView());
    } else {
      // TODO display error message.
    }
  }

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  String get selectedRole => _selectedRole;
  void navigateToLogin() => _navigationService.navigateTo(const LoginView());
}
