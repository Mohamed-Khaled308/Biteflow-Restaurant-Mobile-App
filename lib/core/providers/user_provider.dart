import 'package:biteflow/core/utils/result.dart';
import 'package:biteflow/core/utils/auth_helper.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final UserService _userService = getIt<UserService>();

  bool _isLoggedIn = false;
  User? _user;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  set setLoggedIn(loggedIn) {
    _isLoggedIn = loggedIn;
  }

  User? get user => _user;
  String? get errorMessage => _errorMessage;

  User? get currentUser => _user;

  set setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  /// Initialize user authentication state.
  Future<Result<bool>> _initializeAuthState() async {
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      return _loadOrCreateUser(
          currentUser.uid, currentUser.email, currentUser.displayName);
    } else {
      _setLoggedOutState('No user is currently logged in.');
      return Result(error: _errorMessage);
    }
  }

  /// Login using email and password.
  Future<Result<bool>> login(String email, String password) async {
    final result =
        await _authService.loginWithEmail(email: email, password: password);
    if (result.isSuccess) {
      return await _handleLoginSuccess();
    } else {
      _handleError(result);
      return Result(error: _errorMessage);
    }
  }

  /// Handle post-login state setup and SharedPreferences.
  Future<Result<bool>> _handleLoginSuccess() async {
    final initResult = await _initializeAuthState();
    if (initResult.isSuccess) {
      final prefs = await SharedPreferences.getInstance();
      final savedCartId =
          prefs.getString('cart_${_authService.currentUser!.uid}');
      if (savedCartId != null) {
        getIt<CartViewModel>().joinCart(savedCartId);
      }
    }
    return initResult;
  }

  /// Sign up with user details and save to database.
  Future<Result<bool>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final result =
        await _authService.signUpWithEmail(email: email, password: password);

    if (result.isSuccess) {
      final firebaseUser = _authService.currentUser;

      if (firebaseUser == null) {
        return Result(error: 'Failed to retrieve authenticated user.');
      }

      final userResult = await _createUserByRole(
        id: firebaseUser.uid,
        name: name,
        email: email,
        role: role,
      );

      return userResult;
    } else {
      _handleError(result);
      return Result(error: _errorMessage);
    }
  }

  /// Google login and SharedPreferences handling.
  Future<Result<bool>> loginWithGoogle() async {
    final result = await _authService.signInWithGoogle();

    if (result.isSuccess) {
      return await _handleLoginSuccess();
    } else {
      _handleError(result);
      return Result(error: _errorMessage);
    }
  }

  /// Facebook login.
  Future<Result<bool>> loginWithFacebook() async {
    final result = await _authService.signInWithFacebook();
    if (result.isSuccess) {
      return await _handleLoginSuccess();
    } else {
      _handleError(result);
      return Result(error: _errorMessage);
    }
  }

  /// Create a user by role and save to database.
  Future<Result<bool>> _createUserByRole({
    required String id,
    required String name,
    required String email,
    required String role,
  }) async {
    User newUser;

    switch (role) {
      case AuthHelper.clientRole:
        newUser = Client(id: id, name: name, email: email);
        break;
      case AuthHelper.managerRole:
        newUser = Manager(id: id, name: name, email: email);
        break;
      default:
        return Result(error: 'Invalid user role specified.');
    }

    final result = await _userService.createUser(newUser);

    if (result.isSuccess) {
      _isLoggedIn = true;
      _user = newUser;
      _saveUserToPreferences(newUser);
      _errorMessage = null;
    }
    return result;
  }

  /// Load or create a new user.
  Future<Result<bool>> _loadOrCreateUser(
      String userId, String? email, String? name) async {
    final result = await _userService.getUserById(userId);

    if (result.isSuccess) {
      _isLoggedIn = true;
      _user = result.data;
      _saveUserToPreferences(_user!);
      _errorMessage = null;
      notifyListeners();
      return Result(data: true);
    } else if (email != null) {
      final user = Client(id: userId, name: name ?? 'New Client', email: email);
      final creationResult = await _userService.createUser(user);
      if (creationResult.isSuccess) {
        _isLoggedIn = true;
        _user = user;
        _saveUserToPreferences(user);
        _errorMessage = null;
        notifyListeners();
        return Result(data: true);
      } else {
        _setLoggedOutState(creationResult.error);
        return Result(error: creationResult.error);
      }
    } else {
      _setLoggedOutState(result.error);
      return Result(error: result.error);
    }
  }

  /// Logout and clear SharedPreferences.
  Future<Result<bool>> logout() async {
    final currentUser = _user;
    if (currentUser != null) {
      Cart? cart = getIt<CartViewModel>().cart;
      final cartId = cart?.id;
      if (cartId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cart_${currentUser.id}', cartId);
      }
    }

    final result = await _authService.logout();
    if (result.isSuccess) {
      _clearPreferences();
      _setLoggedOutState();
      getIt<CartViewModel>().cleanUpCart();
      return Result(data: true);
    } else {
      _handleError(result);
      return Result(error: _errorMessage);
    }
  }

  /// Save user and cart details to SharedPreferences.
  Future<void> _saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id);
    await prefs.setString('userEmail', user.email);
    await prefs.setString('userName', user.name);
    await prefs.setString('userRole', user.role);
  }

  /// Clear user and cart details from SharedPreferences.
  Future<void> _clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userRole');
  }

  void _setLoggedOutState([String? error]) {
    _isLoggedIn = false;
    _user = null;
    _errorMessage = error;
    notifyListeners();
  }

  void _handleError(Result result) {
    _errorMessage = result.error;
    notifyListeners();
  }
}
