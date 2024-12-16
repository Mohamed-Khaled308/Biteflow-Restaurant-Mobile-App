import 'package:biteflow/services/firestore/comment_service.dart';
import 'package:flutter/foundation.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/comment.dart';
import 'package:biteflow/models/user.dart';
import 'package:biteflow/services/firestore/user_service.dart'; 
import 'package:logger/logger.dart';

class FeedbackViewModel extends ChangeNotifier {
  final CommentService _commentService = getIt<CommentService>();
  final UserService _userService = getIt<UserService>();
  final Logger _logger = getIt<Logger>();
  
  bool _isLoading = false;
  String? _error;
  List<Comment>? _comments;
  final Map<String, User> _users = {};
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Comment>? get comments => _comments;
  Map<String, User> get users => _users;

  Future<void> loadComments(String restaurantId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _commentService.getRestaurantComments(restaurantId);
      if (result.error != null) {
        _error = result.error;
        _logger.e('Failed to load comments: ${result.error}');
        return;
      }

      _comments = result.data;
      _logger.i('Loaded ${_comments?.length} comments');
      
      // Load user data for each comment
      for (var comment in _comments!) {
        if (!_users.containsKey(comment.userId)) {
          final userResult = await _userService.getUserById(comment.userId);
          if (userResult.error != null) {
            _logger.w('Failed to load user ${comment.userId}: ${userResult.error}');
            continue;
          }
          _users[comment.userId] = userResult.data!;
        }
      }

    } catch (e) {
      _error = e.toString();
      _logger.e('Error loading comments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}