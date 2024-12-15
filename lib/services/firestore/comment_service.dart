import 'package:biteflow/core/utils/result.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
 
class CommentService {
  final CollectionReference _comments =
      FirebaseFirestore.instance.collection('comments');
  final Logger _logger = getIt<Logger>();

  String generateId() {
    return _comments.doc().id;
  }

  Future<Result<bool>> createComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toJson());
      return Result(data: true);
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }

  Future<Result<List<Comment>>> getRestaurantComments(String restaurantId) async {
    try {
      QuerySnapshot querySnapshot = await _comments
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();
      
      List<Comment> comments = querySnapshot.docs
          .map((doc) => Comment.fromData(doc.data() as Map<String, dynamic>))
          .toList();
          
      return Result(data: comments);
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }
}