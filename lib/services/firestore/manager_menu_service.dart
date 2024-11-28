import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/constants/firestore_collections.dart';
import 'package:biteflow/models/category.dart';
import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/core/utils/result.dart';
// import 'package:logger/logger.dart';
// import 'package:biteflow/locator.dart';

class ManagerMenuService {
  // final Logger _logger = getIt<Logger>();
  final CollectionReference _categories = FirebaseFirestore.instance
      .collection(FirestoreCollections.categoriesCollection);
  final CollectionReference _menuItems = FirebaseFirestore.instance
      .collection(FirestoreCollections.menuItemsCollection);

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

  // get menuItems of a specific restaurant
  Future<Result<List<MenuItem>>> getMenuItems(String restaurantId) async {
    try {
      QuerySnapshot menuItemsSnapshot =
          await _menuItems.where('restaurantId', isEqualTo: restaurantId).get();
      return Result(
          data: menuItemsSnapshot.docs
              .map((doc) =>
                  MenuItem.fromData(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      return Result(error: e.toString());
    }
  }
}
