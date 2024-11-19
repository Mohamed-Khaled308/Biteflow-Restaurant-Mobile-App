import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/services/firestore_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton(AuthService());
  getIt.registerSingleton(FirestoreService());
}
