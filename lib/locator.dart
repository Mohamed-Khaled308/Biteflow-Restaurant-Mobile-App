import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/services/firestore_service.dart';
import 'view-model/entry_point_view_model.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  getIt.registerFactory<EntryPointViewModel>(() => EntryPointViewModel());
}
