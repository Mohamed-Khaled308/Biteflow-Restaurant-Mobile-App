import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/core/utils/auth_helper.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/views/screens/entry_point/entry_point_view.dart';
import 'package:biteflow/views/screens/login/login_view.dart';
import 'package:biteflow/views/screens/restaurant_onboarding/restaurant_onboarding_view.dart';
import 'package:logger/logger.dart';

class SignupViewModel extends BaseModel {
  final UserProvider _userProvider = getIt<UserProvider>();
  final NavigationService _navigationService = getIt<NavigationService>();
  final _logger = getIt<Logger>();

  String _selectedRole = 'Client';
  String get selectedRole => _selectedRole;
  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  String _nameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _generalError = '';
  String get nameError => _nameError;
  String get emailError => _emailError;
  String get passwordError => _passwordError;
  String get errorMessage => _generalError;

  String? validateName(String name) {
    return AuthHelper.validateName(name);
  }

  String? validateEmail(String email) {
    return AuthHelper.validateEmail(email);
  }

  String? validatePassword(String password) {
    return AuthHelper.validatePassword(password);
  }

  void clearError() {
    _generalError = '';
    notifyListeners();
  }

  bool _isInputActive = false;
  bool get isInputActive => _isInputActive;

  void updateFocusState(bool isFocused) {
    _isInputActive = isFocused;
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _nameError = '';
    _emailError = '';
    _passwordError = '';
    _generalError = '';
    notifyListeners();

    bool hasError = false;
    final nameValidation = validateName(name);
    final emailValidation = validateEmail(email);
    final passwordValidation = validatePassword(password);

    if (nameValidation != null) {
      _nameError = nameValidation;
      hasError = true;
    }
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
    final result = await _userProvider.signup(
      name: name,
      email: email,
      password: password,
      role: _selectedRole,
    );

    if (result.isSuccess) {
      if (_userProvider.user!.role == AuthHelper.clientRole) {
        _navigationService.replaceWith(EntryPointView());
      } else {
        _navigationService.replaceWith(const RestaurantOnboardingView());
      }
    } else {
      _generalError = result.error ?? 'Signup failed. Please try again.';
      notifyListeners();
    }

    setBusy(false);
  }

  void signInWithGoogle() async {
    setBusy(true);
    final result = await _userProvider.loginWithGoogle();

    if (result.isSuccess && result.data!) {
      _navigateToEntryPoint();
    } else {
      _generalError =
          result.error ?? 'Google sign-in failed. Please try again.';
      _logger.e(_generalError);
      notifyListeners();
    }
    setBusy(false);
  }

  void signInWithFacebook() async {
    setBusy(true);
    final result = await _userProvider.loginWithFacebook();

    if (result.isSuccess) {
      _navigateToEntryPoint();
    } else {
      _generalError =
          result.error ?? 'Facebook sign-in failed. Please try again.';
      _logger.e(_generalError);
      notifyListeners();
    }
    setBusy(false);
  }

  void navigateToLogin() => _navigationService.navigateTo(const LoginView());
  void navigateToEntryPoint() =>
      _navigationService.replaceWith(EntryPointView());

  void _navigateToEntryPoint() {
    navigateToEntryPoint();
  }
}
