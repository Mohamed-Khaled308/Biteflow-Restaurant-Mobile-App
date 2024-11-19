import 'package:biteflow/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future createUser(User user, String collection) async {
    await _firestore.collection(collection).doc(user.id).update(user.toJson());
  }
}
