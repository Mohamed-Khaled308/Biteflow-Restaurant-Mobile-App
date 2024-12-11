import 'package:biteflow/core/utils/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
      errorMessage[0].toUpperCase();
      return Result(error: errorMessage);
    } on FirebaseException catch (_) {
      return Result(error: 'Server is down. Try again later!');
    } catch (_) {
      return Result(error: 'Login failed. Please try again!');
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
    } on FirebaseException catch (_) {
      return Result(error: 'Server is down. Try again later!');
    } catch (e) {
      return Result(error: 'Sign up failed. Please try again!');
    }
  }

  Future<Result<User?>> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return Result(data: userCredential.user);
    }
    return Result(data: null);
  }

  Future<Result<User?>> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if (loginResult.status == LoginStatus.success) {
      final OAuthCredential credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return Result(data: userCredential.user);
    }
    return Result(error: 'User Not Found!');
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
