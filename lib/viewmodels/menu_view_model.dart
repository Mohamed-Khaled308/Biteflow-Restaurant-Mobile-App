import 'package:biteflow/dummy_data/category_list.dart';
import 'package:biteflow/dummy_data/item_list.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/services/firestore/category_service.dart';
import 'package:biteflow/services/firestore/menu_item_service.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:logger/logger.dart';
import '../models/category.dart';
import '../models/menu_item.dart';

class MenuViewModel extends BaseModel {
  final Logger _logger = getIt<Logger>();

  // Private fields
  String? _selectedCategoryId = 'c1';
  List<MenuItem> _filteredItems = [];
  MenuItem? _selectedItem;
  String? _restaurantId;
  Restaurant? _restaurant;
  List<Category>? _categories;
  List<MenuItem>? _menuItems;

  // Public getters and setters
  String? get selectedCategoryId => _selectedCategoryId;
  set selectedCategoryId(String? value) {
    _selectedCategoryId = value;
    filterItems();
    notifyListeners();
  }

  List<MenuItem> get filteredItems => _filteredItems;

  MenuItem? get selectedItem => _selectedItem;
  set selectedItem(MenuItem? value) {
    _selectedItem = value;
    notifyListeners();
  }

  String? get restaurantId => _restaurantId;
  set restaurantId(String? value) {
    _restaurantId = value;
    notifyListeners();
  }

  Restaurant? get restaurant => _restaurant;

  List<Category>? get categories => _categories;

  List<MenuItem>? get menuItems => _menuItems;

  // Constructor
  MenuViewModel();

  // Methods
  void filterItems() {
    if (_selectedCategoryId == null) {
      _filteredItems = _menuItems ?? [];
    } else {
      _filteredItems = (_menuItems ?? [])
          .where((item) => item.categoryId == _selectedCategoryId)
          .toList();
    }
  }

  // Database-related methods
  Future<void> loadRestaurantData() async {
    setBusy(true);

    await _fetchRestaurant();
    await _fetchCategories();
    await _fetchMenuItems();

    if (_categories?.isNotEmpty ?? false) {
      selectedCategoryId =  _categories!.first.id; // This will also call filterItems
    }

    setBusy(false);
  }

  Future<void> _fetchRestaurant() async {
    final restaurantResult =
        await getIt<RestaurantService>().getRestaurantById(_restaurantId!);
    if (restaurantResult.isSuccess) {
      _restaurant = restaurantResult.data;
      notifyListeners();
    } else {
      _logger.e(restaurantResult.error);
    }
  }

  String? get restaurantImageUrl => _restaurant?.imageUrl;

  Future<void> _fetchCategories() async {
    final categoriesData =
        await getIt<CategoryService>().getCategories(_restaurantId!);
    print('Categories fetched: ${categoriesData}');
    if (categoriesData.isSuccess) {
      _categories = categoriesData.data;
      // Automatically set the selected category to the first fetched category's ID
      if (_categories != null && _categories!.isNotEmpty) {
        selectedCategoryId = _categories!.first.id; // Uses the setter
      }
      notifyListeners();
    } else {
      _logger.e(categoriesData.error);
    }
  }

  Future<void> _fetchMenuItems() async {
    final menuItemsData =
        await getIt<MenuItemService>().getMenuItems(_restaurantId!);
    if (menuItemsData.isSuccess) {
      _menuItems = menuItemsData.data;
      notifyListeners();
    } else {
      _logger.e(menuItemsData.error);
    }
  }
}
