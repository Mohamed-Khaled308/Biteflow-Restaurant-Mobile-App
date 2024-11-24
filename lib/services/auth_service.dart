import 'package:biteflow/core/result.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService = getIt<UserService>();
  final RestaurantService _restaurantService = getIt<RestaurantService>();
  final Logger _logger = getIt<Logger>();

  Future<Result<bool>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _logger.d('email : $email, password : $password');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return Result(data: true);
      }
      _logger.e('Unexpected behaviour: user is null');
      return Result(error: 'Unexpected behaviour: user is null');
    } catch (e) {
      _logger.e('Login failed: ${e.toString()}');
      return Result(error: e.toString());
    }
  }

  Future<User?> _signUpWithEmail(
      {required String email, required String password}) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<Result<bool>> signUpClientWithEmail({
    required Map<String, dynamic> clientInfo,
  }) async {
    User? user;
    try {
      user = await _signUpWithEmail(
          email: clientInfo['email'], password: clientInfo['password']);

      if (user != null) {
        clientInfo['id'] = user.uid;
        Client client = Client.fromData(clientInfo);
        await _userService.createUser(client);
        return Result(data: true);
      }

      _logger.e('Unexpected behaviour: user is null');
      return Result(error: 'Unexpected behaviour: user is null');
    } catch (e) {
      _logger.e('Sign up failed: ${e.toString()}');
      if (user != null) {
        try {
          await user.delete();
          _logger.d('Cleaned up: User ${user.email} deleted from Firebase.');
        } catch (deleteError) {
          _logger
              .e('Failed to clean up created user: ${deleteError.toString()}');
        }
      }
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> signUpManagerWithEmail({
    required Map<String, dynamic> managerInfo,
  }) async {
    User? user;
    try {
      user = await _signUpWithEmail(
          email: managerInfo['email'], password: managerInfo['password']);

      if (user != null) {
        Map<String, dynamic> restaurantInfo = {};
        restaurantInfo['id'] = _restaurantService.generateId();
        restaurantInfo['name'] = managerInfo['restaurantName'];
        restaurantInfo['managerId'] = user.uid;

        Restaurant restaurant = Restaurant.fromData(restaurantInfo);
        await _restaurantService.createRestaurant(restaurant);

        managerInfo['id'] = user.uid;
        managerInfo['restaurantId'] = restaurantInfo['id'];
        Manager manager = Manager.fromData(managerInfo);
        await _userService.createUser(manager);
        return Result(data: true);
      }

      _logger.e('Unexpected behaviour: user is null');
      return Result(error: 'Unexpected behaviour: user is null');
    } catch (e) {
      _logger.e('Sign up failed: ${e.toString()}');
      if (user != null) {
        try {
          await user.delete();
          _logger.d('Cleaned up: User ${user.email} deleted from Firebase.');
        } catch (deleteError) {
          _logger
              .e('Failed to clean up created user: ${deleteError.toString()}');
        }
      }
      return Result(error: e.toString());
    }
  }
}
