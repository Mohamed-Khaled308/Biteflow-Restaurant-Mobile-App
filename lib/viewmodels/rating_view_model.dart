import 'package:biteflow/dummy_data/dummy_items.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import '../models/order_item.dart';

class RatingViewModel extends BaseModel {
  List<OrderItem> orderedItems = [];

  RatingViewModel() {
    loadOrderedItems();
  }

  void loadOrderedItems() {
    orderedItems = orderedItemsData;
    notifyListeners();
  }

  void updateRating(OrderItem item, double newRating) {
    int index = orderedItems.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      orderedItems[index] =
          orderedItems[index].copyWith(updatedRating: newRating);
      notifyListeners();
      // TODO - Update the rating in the database
    }
  }
}
