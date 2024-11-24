import 'package:biteflow/core/result.dart';
import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/views/screens/auth/signup/signup_view.dart';
import 'package:biteflow/views/screens/entry_point/entry_point_view.dart';

class LoginViewModel extends BaseModel {
  final AuthService _authService = getIt<AuthService>();
  final NavigationService _navigationService = getIt<NavigationService>();

  void login({required String email, required String password}) async {
    Result result = await _authService.loginWithEmail(
      email: email,
      password: password,
    );
    if (result.isSuccess) {
      _navigationService.replaceWith(const EntryPointView());
    } else {
      // TODO display error message.
    }
  }

  void navigateToSignup() => _navigationService.navigateTo(SignupView());
}
