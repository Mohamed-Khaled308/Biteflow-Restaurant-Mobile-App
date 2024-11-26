import 'package:biteflow/core/utils/result.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<Result<void>> loginWithEmail(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Result();
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code.replaceAll('-', ' ');
      return Result(error: errorMessage);
    } on FirebaseException catch (e) {
      return Result(error: 'Firebase error: ${e.message}');
    } catch (e) {
      return Result(error: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Result<void>> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return Result();
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code.replaceAll('-', ' ');
      return Result(error: errorMessage);
    } on FirebaseException catch (e) {
      return Result(error: 'Firebase error: ${e.message}');
    } catch (e) {
      return Result(error: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return Result();
    } on FirebaseAuthException catch (e) {
      return Result(error: 'Logout failed: ${e.message}');
    } on FirebaseException catch (e) {
      return Result(error: 'Firebase error: ${e.message}');
    } catch (e) {
      return Result(error: 'An unexpected error occurred: ${e.toString()}');
    }
  }
}
