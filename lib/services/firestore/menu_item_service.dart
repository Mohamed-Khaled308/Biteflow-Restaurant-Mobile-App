import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/constants/firestore_collections.dart';
import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/core/utils/result.dart';

class MenuItemService {
  final CollectionReference _menuItems = FirebaseFirestore.instance
      .collection(FirestoreCollections.menuItemsCollection);

  String generateMenuItemId() {
    return _menuItems.doc().id;
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
