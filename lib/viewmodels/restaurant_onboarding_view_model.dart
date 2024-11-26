import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:biteflow/services/firestore/user_service.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/views/screens/entry_point/entry_point_view.dart';

class RestaurantOnboardingViewModel extends BaseModel {
  final _userProvider = getIt<UserProvider>();
  final _restaurantService = getIt<RestaurantService>();
  final _userService = getIt<UserService>();
  final _navigationService = getIt<NavigationService>();

  String _nameError = '';
  String _locationError = '';
  String _descriptionError = '';
  String _imageUrlError = '';
  String get nameError => _nameError;
  String get locationError => _locationError;
  String get descriptionError => _descriptionError;
  String get imageUrlError => _imageUrlError;

  String? validateName(String name) {
    if (name.isEmpty) {
      return 'Restaurant name is required';
    }
    return null;
  }

  String? validateLocation(String location) {
    if (location.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  String? validateDescription(String description) {
    if (description.isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  String? validateImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) {
      return 'Image URL is required';
    }
    return null;
  }

  Future<void> saveRestaurantData({
    required String name,
    required String location,
    required String imageUrl,
    required String description,
  }) async {
    final manager = _userProvider.user;

    _nameError = '';
    _locationError = '';
    _descriptionError = '';
    _imageUrlError = '';

    final nameValidation = validateName(name);
    final locationValidation = validateLocation(location);
    final descriptionValidation = validateDescription(description);
    final imageUrlValidation = validateImageUrl(imageUrl);

    if (nameValidation != null) {
      _nameError = nameValidation;
    }
    if (locationValidation != null) {
      _locationError = locationValidation;
    }
    if (descriptionValidation != null) {
      _descriptionError = descriptionValidation;
    }
    if (imageUrlValidation != null) {
      _imageUrlError = imageUrlValidation;
    }

    if (_nameError.isNotEmpty ||
        _locationError.isNotEmpty ||
        _descriptionError.isNotEmpty ||
        _imageUrlError.isNotEmpty) {
      notifyListeners();
      return;
    }

    setBusy(true);

    final String id = _restaurantService.generateId();
    Restaurant restaurant = Restaurant(
      id: id,
      name: name,
      managerId: manager!.id,
      location: location,
      imageUrl: imageUrl,
      description: description,
    );
    final result = await _restaurantService.createRestaurant(restaurant);
    if (result.isSuccess) {
      Map<String, dynamic> data = manager.toJson();
      data['restaurantId'] = id;
      Manager newManager = Manager.fromData(data);
      await _userService.updateUser(newManager);
      _userProvider.setUser = newManager;
      _navigationService.replaceWith(EntryPointView());
    } else {
      // Error!
    }

    setBusy(false);
  }
}
