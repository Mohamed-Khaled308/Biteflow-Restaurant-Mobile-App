import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/view-model/cart_view_model.dart';
import 'package:biteflow/view-model/manager_menu_view_model.dart';
import 'package:biteflow/view-model/manager_create_item_view_model.dart';
import 'package:biteflow/view-model/manager_orders_view_model.dart';
import 'package:logger/logger.dart';
import 'view-model/entry_point_view_model.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<UserService>(() => UserService());
  getIt.registerLazySingleton<Logger>(() => Logger());
  getIt.registerFactory<EntryPointViewModel>(() => EntryPointViewModel());
  getIt.registerLazySingleton<CartViewModel>(() => CartViewModel());
  getIt.registerLazySingleton<ManagerMenuViewModel>(() => ManagerMenuViewModel());
  getIt.registerLazySingleton<ManagerCreateItemViewModel>(() => ManagerCreateItemViewModel());
  getIt.registerLazySingleton<ManagerOrdersViewModel>(() => ManagerOrdersViewModel());
}
