import 'package:biteflow/core/result.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _firestoreService = getIt<UserService>();
  final Logger _logger = getIt<Logger>();

  Future<Result<T>> _handleAuthOperation<T>(
    Future<T> Function() operation,
    String errorMessage,
  ) async {
    try {
      final result = await operation();
      return Result(data: result);
    } on FirebaseAuthException catch (e) {
      _logger.e('$errorMessage: ${e.message}');
      return Result(error: e.message);
    } catch (e) {
      _logger.e('$errorMessage: ${e.toString()}');
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _handleAuthOperation(() async {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    }, 'Login Failed');
  }

  Future<Result<bool>> signUpClientWithEmail({
    required String email,
    required String password,
    required Map<String, dynamic> info,
  }) async {
    return await _handleAuthOperation(() async {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        info['id'] = userCredential.user!.uid;
        info['email'] = email;

        if (info['role'] == 'client') {
          Client client = Client.fromData(info);
          await _firestoreService.createUser(client);
        } else if (info['role'] == 'manager') {
          Manager manager = Manager.fromData(info);
          await _firestoreService.createUser(manager);
        } else {
          _logger.e('Unknown user role: ${info['role']}');
          return false;
        }
        return true;
      }
      return false;
    }, 'Sign Up Failed');
  }
}
