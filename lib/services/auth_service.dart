import 'package:biteflow/locator.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:biteflow/constants/firestore_collections.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = getIt<FirestoreService>();

  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user != null;
    } on FirebaseAuthException catch (_) {
      // print('FirebaseAuthException: ${e.message}');
      return false;
    } catch (e) {
      // print('Error: ${e.toString()}');
      return false;
    }
  }

  Future<bool> signUpClientWithEmail(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        Client client =
            Client(id: userCredential.user!.uid, name: name, email: email);
        await _firestoreService.createUser(
            client, FirestoreCollections.clientsCollection);
      }

      return userCredential.user != null;
    } on FirebaseAuthException catch (_) {
      // print('FirebaseAuthException: ${e.message}');
      return false;
    } catch (e) {
      // print('Error: ${e.toString()}');
      return false;
    }
  }
}
