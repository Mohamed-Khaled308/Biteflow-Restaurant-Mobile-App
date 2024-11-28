import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/constants/firestore_collections.dart';
import 'package:biteflow/models/category.dart';
import 'package:biteflow/core/utils/result.dart';

class CategoryService {
  final CollectionReference _categories = FirebaseFirestore.instance
      .collection(FirestoreCollections.categoriesCollection);

  String generateCategoryId() {
    return _categories.doc().id;
  }

  // get categories of a specific restaurant
  Future<Result<List<Category>>> getCategories(String restaurantId) async {
    try {
      QuerySnapshot categoriesSnapshot = await _categories
          .where('restaurantId', isEqualTo: restaurantId)
          .get();
      return Result(
          data: categoriesSnapshot.docs
              .map((doc) =>
                  Category.fromData(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      return Result(error: e.toString());
    }
  }

}