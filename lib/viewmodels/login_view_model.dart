import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/core/utils/result.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/views/screens/signup/signup_view.dart';
import 'package:biteflow/views/screens/entry_point/entry_point_view.dart';
import 'package:biteflow/core/utils/auth_helper.dart';

class LoginViewModel extends BaseModel {
  final UserProvider _authProvider = getIt<UserProvider>();
  final NavigationService _navigationService = getIt<NavigationService>();

  bool _isInputActive = false;
  bool get isInputActive => _isInputActive;

  String _emailError = '';
  String _passwordError = '';
  String _generalError = '';
  String get emailError => _emailError;
  String get passwordError => _passwordError;
  String get errorMessage => _generalError;

  String? validateEmail(String email) {
    return AuthHelper.validateEmail(email);
  }

  String? validatePassword(String password) {
    return AuthHelper.validatePassword(password);
  }

  void updateFocusState(bool isFocused) {
    _isInputActive = isFocused;
    notifyListeners();
  }

  void clearError() {
    _generalError = '';
    notifyListeners();
  }

  void login({required String email, required String password}) async {
    _emailError = '';
    _passwordError = '';
    _generalError = '';
    notifyListeners();

    bool hasError = false;
    final emailValidation = validateEmail(email);
    final passwordValidation = validatePassword(password);

    if (emailValidation != null) {
      _emailError = emailValidation;
      hasError = true;
    }
    if (passwordValidation != null) {
      _passwordError = passwordValidation;
      hasError = true;
    }
    if (hasError) {
      notifyListeners();
      return;
    }

    setBusy(true);
    Result result = await _authProvider.login(email, password);

    if (result.isSuccess) {
      _navigateToEntryPoint();
    } else {
      _generalError = result.error ?? 'Login failed. Please try again.';
      notifyListeners();
    }

    setBusy(false);
  }

  void signInWithGoogle() async {
    setBusy(true);
    final result = await _authProvider.loginWithGoogle();

    if (result.isSuccess && result.data!) {
      _navigateToEntryPoint();
    } else {
      _generalError = result.error ?? 'Google sign-in failed. try again!';
      notifyListeners();
    }
    setBusy(false);
  }

  void signInWithFacebook() async {
    setBusy(true);
    final result = await _authProvider.loginWithFacebook();

    if (result.isSuccess) {
      _navigateToEntryPoint();
    } else {
      _generalError =
          result.error ?? 'Facebook sign-in failed. Please try again.';
      notifyListeners();
    }
    setBusy(false);
  }

  void navigateToSignup() => _navigationService.navigateTo(const SignupView());
  void navigateToEntryPoint() =>
      _navigationService.replaceWith(EntryPointView());

  void _navigateToEntryPoint() {
    navigateToEntryPoint();
  }
}
