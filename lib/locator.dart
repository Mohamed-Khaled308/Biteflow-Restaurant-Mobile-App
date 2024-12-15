import 'package:biteflow/core/providers/notification_provider.dart';
import 'package:biteflow/services/auth_service.dart';
import 'package:biteflow/services/firestore/cart_service.dart';
import 'package:biteflow/services/firestore/category_service.dart';
import 'package:biteflow/services/firestore/comment_service.dart';
import 'package:biteflow/services/firestore/menu_item_service.dart';
import 'package:biteflow/services/firestore/offer_notification_service.dart';
import 'package:biteflow/services/firestore/promotional_offer_service.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:biteflow/services/firestore/order_service.dart';
import 'package:biteflow/services/image_service.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/services/payment_service.dart';
import 'package:biteflow/viewmodels/cart_item_view_model.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/viewmodels/client_orders_view_model.dart';
import 'package:biteflow/viewmodels/client_offers_view_model.dart';
import 'package:biteflow/viewmodels/entry_point_view_model.dart';
import 'package:biteflow/viewmodels/home_view_model.dart';
import 'package:biteflow/viewmodels/image_view_model.dart';
import 'package:biteflow/viewmodels/login_view_model.dart';
import 'package:biteflow/viewmodels/manager_offers_view_model.dart';
import 'package:biteflow/viewmodels/mode_view_model.dart';
import 'package:biteflow/viewmodels/manager_promotional_offers_view_model.dart';
import 'package:biteflow/viewmodels/rating_view_model.dart';
import 'package:biteflow/viewmodels/restaurant_onboarding_view_model.dart';
import 'package:biteflow/viewmodels/signup_view_model.dart';
import 'package:biteflow/viewmodels/order_view_model.dart';
import 'package:biteflow/viewmodels/manager_menu_view_model.dart';
import 'package:biteflow/viewmodels/manager_create_item_view_model.dart';
import 'package:biteflow/viewmodels/manager_orders_view_model.dart';
import 'package:biteflow/viewmodels/manager_orders_details_view_model.dart';
import 'package:biteflow/viewmodels/menu_view_model.dart';
import 'package:biteflow/viewmodels/payment_view_model.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Services
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<UserService>(() => UserService());
  getIt.registerLazySingleton<RestaurantService>(() => RestaurantService());
  getIt.registerLazySingleton<CategoryService>(() => CategoryService());
  getIt.registerLazySingleton<MenuItemService>(() => MenuItemService());
  getIt.registerLazySingleton<OfferNotificationService>(
      () => OfferNotificationService());
  getIt.registerLazySingleton<OrderService>(() => OrderService());
  getIt.registerLazySingleton<PaymentService>(() => PaymentService());
  getIt.registerLazySingleton<CartService>(() => CartService());
  getIt.registerLazySingleton<UserProvider>(() => UserProvider());
  getIt.registerLazySingleton<NotificationProvider>(
      () => NotificationProvider());
  getIt.registerLazySingleton<Logger>(() => Logger());

  // ViewModels - Use factories for scoped ViewModels
  getIt.registerFactory<EntryPointViewModel>(() => EntryPointViewModel());
  getIt.registerLazySingleton<CartViewModel>(() => CartViewModel());
  getIt.registerFactory<LoginViewModel>(() => LoginViewModel());
  getIt.registerFactory<SignupViewModel>(() => SignupViewModel());
  getIt.registerFactory<HomeViewModel>(() => HomeViewModel());
  getIt.registerFactory<RatingViewModel>(() => RatingViewModel());
  getIt.registerFactory<RestaurantOnboardingViewModel>(
      () => RestaurantOnboardingViewModel());
  getIt.registerFactory<OrderViewModel>(() => OrderViewModel());
  getIt.registerFactory<MenuViewModel>(() => MenuViewModel());
  getIt.registerFactory<PaymentViewModel>(() => PaymentViewModel());
  getIt.registerLazySingleton<ModeViewModel>(() => ModeViewModel());

  getIt.registerFactory<ManagerCreateItemViewModel>(
      () => ManagerCreateItemViewModel());
  getIt.registerFactory<ManagerOrdersDetailsViewModel>(
      () => ManagerOrdersDetailsViewModel());
  getIt.registerFactory<ManagerOffersViewModel>(() => ManagerOffersViewModel());
  getIt.registerFactory<ClientOffersViewModel>(() => ClientOffersViewModel());
  getIt.registerLazySingleton<ManagerOrdersViewModel>(
      () => ManagerOrdersViewModel());
  getIt.registerLazySingleton<ManagerMenuViewModel>(
      () => ManagerMenuViewModel());
  getIt.registerLazySingleton<ClientOrdersViewModel>(
      () => ClientOrdersViewModel());

  getIt.registerFactory<ManagerPromotionalOffersViewModel>(
      () => ManagerPromotionalOffersViewModel());

  getIt.registerLazySingleton<PromotionalOfferService>(
      () => PromotionalOfferService());

  getIt.registerLazySingleton<ImageService>(() => ImageService());

  getIt.registerFactory<ImageViewModel>(
      () => ImageViewModel(getIt<ImageService>()));
  getIt.registerFactoryParam<CartItemViewModel, String, void>(
      (itemId, _) => CartItemViewModel(itemId: itemId));

  getIt.registerLazySingleton(() => CommentService());
}
