import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/models/user.dart';
import 'package:biteflow/constants/firestore_collections.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/core/result.dart';

class UserService {
  final CollectionReference _users = FirebaseFirestore.instance
      .collection(FirestoreCollections.usersCollection);

  Future<Result<bool>> createUser(User user) async {
    try {
      await _users.doc(user.id).set(user.toJson());
      return Result(data: true);
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<User>> getUserById(String userId) async {
    try {
      DocumentSnapshot userDoc = await _users.doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData['role'] == 'client') {
          return Result(data: Client.fromData(userData));
        } else if (userData['role'] == 'manager') {
          return Result(data: Manager.fromData(userData));
        }
        return Result(error: 'Unknown user role: ${userData['role']}');
      }
      return Result(error: 'User not found');
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> updateUser(User user) async {
    try {
      await _users.doc(user.id).update(user.toJson());
      return Result(data: true);
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> deleteUser(String userId) async {
    try {
      await _users.doc(userId).delete();
      return Result(data: true);
    } catch (e) {
      return Result(error: e.toString());
    }
  }
}
