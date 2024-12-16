import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/models/comment.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/services/firestore/comment_service.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:flutter/foundation.dart';
import 'package:biteflow/locator.dart'; 

class RatingViewModel extends ChangeNotifier {
  final CommentService _commentService = getIt<CommentService>();
  final RestaurantService _restaurantService = getIt<RestaurantService>();
  final UserProvider _userProvider = getIt<UserProvider>();
  
  bool _isLoading = false;
  String? _error;
  Restaurant? _restaurant;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  Restaurant? get restaurant => _restaurant;

  Future<void> loadRestaurant(String restaurantId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _restaurantService.getRestaurantById(restaurantId);
      if (result.error != null) {
        _error = result.error;
      } else {
        _restaurant = result.data;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitRating(String restaurantId, double rating, String comment) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final currentUser = _userProvider.currentUser;
      if (currentUser == null) {
        _error = 'Please login to rate restaurants';
        return false;
      }

      // Only create a comment if there's text
      if (comment.trim().isNotEmpty) {
        final newComment = Comment(
          id: _commentService.generateId(),
          userId: currentUser.id,
          restaurantId: restaurantId,
          text: comment,
          rating: rating,
        );

        final commentResult = await _commentService.createComment(newComment);
        if (commentResult.error != null) {
          _error = commentResult.error;
          return false;
        }
      }

      // Update restaurant rating regardless of comment
      final restaurantResult = await _restaurantService.getRestaurantById(restaurantId);
      if (restaurantResult.error != null) {
        _error = restaurantResult.error;
        return false;
      }

      final restaurant = restaurantResult.data!;
      final newReviewCount = restaurant.reviewCount + 1;
      final newRating = ((restaurant.rating * restaurant.reviewCount) + rating) / newReviewCount;

      final updatedRestaurant = Restaurant(
        id: restaurant.id,
        name: restaurant.name,
        managerId: restaurant.managerId,
        location: restaurant.location,
        imageUrl: restaurant.imageUrl,
        description: restaurant.description,
        rating: newRating,
        reviewCount: newReviewCount,
        isTableAvailable: restaurant.isTableAvailable,
      );

      final updateResult = await _restaurantService.updateRestaurant(updatedRestaurant);
      if (updateResult.error != null) {
        _error = updateResult.error;
        return false;
      }

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
