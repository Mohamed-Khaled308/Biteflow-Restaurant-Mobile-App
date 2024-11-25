import 'package:biteflow/dummy_data/category_list.dart';
import 'package:biteflow/dummy_data/item_list.dart';
import 'package:biteflow/view-model/base_mode.dart';
import '../models/category.dart';
import '../models/menu_item.dart';

class MenuViewModel extends BaseModel {
  List<Category> categories = categoriesList;
  List<MenuItem> allItems = menuItemsList;
  String? selectedCategoryId;
  List<MenuItem> filteredItems = [];
  MenuItem? selectedItem;

  MenuViewModel() {
    // Set default category to 'Offers' (id: 'c1')
    selectedCategoryId = 'c1';
    filterItems();
  }

  void selectCategory(String categoryId) {
    selectedCategoryId = categoryId;
    filterItems();
    notifyListeners();
  }

  void selectMenuItem(MenuItem item) {
    selectedItem = item;
    notifyListeners();
  }

  void filterItems() {
    if (selectedCategoryId == null) {
      filteredItems = allItems;
    } else {
      filteredItems = allItems
          .where((item) => item.categoryId == selectedCategoryId)
          .toList();
    }
  }
}
