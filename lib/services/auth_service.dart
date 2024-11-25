import 'package:biteflow/core/result.dart';
import 'package:biteflow/core/utils/auth_helper.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService = getIt<UserService>();
  final Logger _logger = getIt<Logger>();

  Future<Result<bool>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _logger.d('email : $email, password : $password');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return Result(data: true);
      }
      _logger.e('Unexpected behaviour: user is null');
      return Result(error: 'Unexpected behaviour: user is null');
    } catch (e) {
      _logger.e('Login failed: ${e.toString()}');
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> signUpWithEmail(
      {required Map<String, dynamic> info}) async {
    User? user;
    try {
      _logger.d(info);
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: info['email'],
        password: info['password'],
      );
      user = userCredential.user;

      if (user != null) {
        info['id'] = user.uid;
        _logger.d(info);
        if (info['role'] == AuthHelper.clientRole) {
          Client client = Client.fromData(info);
          await _userService.createUser(client);
        } else if (info['role'] == AuthHelper.managerRole) {
          Manager manager = Manager.fromData(info);
          await _userService.createUser(manager);
        }
        return Result(data: true);
      }

      _logger.e('Unexpected behaviour: user is null');
      return Result(error: 'Unexpected behaviour: user is null');
    } catch (e) {
      _logger.e('Sign up failed: ${e.toString()}');
      if (user != null) {
        try {
          await user.delete();
          _logger.d('Cleaned up: User ${user.email} deleted from Firebase.');
        } catch (deleteError) {
          _logger
              .e('Failed to clean up created user: ${deleteError.toString()}');
        }
      }
      return Result(error: e.toString());
    }
  }
}
