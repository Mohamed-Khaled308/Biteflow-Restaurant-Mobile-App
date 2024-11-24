import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/view-model/cart_view_model.dart';
import 'package:biteflow/view-model/entry_point_view_model.dart';
import 'package:biteflow/view-model/login_view_model.dart';
import 'package:biteflow/view-model/signup_view_model.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Services
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<UserService>(() => UserService());
  getIt.registerLazySingleton<RestaurantService>(() => RestaurantService());
  getIt.registerLazySingleton<Logger>(() => Logger());

  // ViewModels - Use factories for scoped ViewModels
  getIt.registerFactory<EntryPointViewModel>(() => EntryPointViewModel());
  getIt.registerFactory<CartViewModel>(() => CartViewModel());
  getIt.registerFactory<LoginViewModel>(() => LoginViewModel());
  getIt.registerFactory<SignupViewModel>(() => SignupViewModel());
}
