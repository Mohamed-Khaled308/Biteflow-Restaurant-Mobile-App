import 'package:biteflow/core/utils/result.dart';
import 'package:biteflow/core/utils/auth_helper.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/models/user.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final UserService _userService = getIt<UserService>();

  bool _isLoggedIn = false;
  User? _user;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  set setUser(User? user) {
    _user = user;
    notifyListeners();
  }

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

  Future<Result<bool>> login(String email, String password) async {
    final result =
        await _authService.loginWithEmail(email: email, password: password);
    if (result.isSuccess) {
      return await _initializeAuthState();
    } else {
      _handleError(result);
      return Result(error: _errorMessage);
    }
  }

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

  Future<Result<bool>> loginWithGoogle() async {
    final result = await _authService.signInWithGoogle();

    if (result.isSuccess) {
      if (result.data == null) return Result(data: false);
      return await _initializeAuthState();
    } else {
      _handleError(result);
      return Result(error: _errorMessage);
    }
  }

  Future<Result<bool>> loginWithFacebook() async {
    final result = await _authService.signInWithFacebook();
    if (result.isSuccess) {
      return await _initializeAuthState();
    } else {
      _handleError(result);
      return Result(error: _errorMessage);
    }
  }

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
      _errorMessage = null;
    }
    return result;
  }

  Future<Result<bool>> _loadOrCreateUser(
      String userId, String? email, String? name) async {
    final result = await _userService.getUserById(userId);

    if (result.isSuccess) {
      _isLoggedIn = true;
      _user = result.data;
      _errorMessage = null;
      notifyListeners();
      return Result(data: true);
    } else if (email != null) {
      final user = Client(id: userId, name: name ?? 'New Client', email: email);
      final creationResult = await _userService.createUser(user);
      if (creationResult.isSuccess) {
        _isLoggedIn = true;
        _user = user;
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

  Future<Result<bool>> logout() async {
    final result = await _authService.logout();
    if (result.isSuccess) {
      _setLoggedOutState();
      return Result(data: true);
    } else {
      _handleError(result);
      return Result(error: _errorMessage);
    }
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
