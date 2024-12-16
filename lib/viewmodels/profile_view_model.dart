import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/models/user.dart';



class ProfileViewModel extends BaseModel {
  final User _authenticatedUser = getIt<UserProvider>().user!;

  User get authenticatedUser => _authenticatedUser;

  void logout() {
    getIt<UserProvider>().logout();
  }
}