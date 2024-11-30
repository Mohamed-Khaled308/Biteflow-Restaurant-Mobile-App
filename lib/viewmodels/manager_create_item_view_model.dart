import 'package:biteflow/models/category.dart';
import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/services/firestore/menu_item_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/viewmodels/manager_menu_view_model.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/services/firestore/category_service.dart';


class ManagerCreateItemViewModel extends BaseModel {

  // Tracks which page (create item or create category) to show
  bool _isCreatingItem = true;

  // for create item
  String? _itemCategoryId;

  // needed services and viewmodels
  final ManagerMenuViewModel _managerMenuViewModel = getIt<ManagerMenuViewModel>();
  final CategoryService _categoryService = getIt<CategoryService>();
  final MenuItemService _menuItemService = getIt<MenuItemService>();

  // getters and setters
  String? get itemCategoryId => _itemCategoryId;
  bool get isCreatingItem => _isCreatingItem;
  set isCreatingItem(bool value) {
    _isCreatingItem = value;
    notifyListeners();
  }
  set itemCategoryId(String? value) {
    _itemCategoryId = value;
    notifyListeners();
  }

  // state management methods
  void updateIsCreatingItem(bool isCreatingItem) {
    _isCreatingItem = isCreatingItem;
    notifyListeners();
  }

  // database related methods
  Future<void> createCategory(String categoryName) async {
    setBusy(true);

    Category newCategory = Category(
      id: _categoryService.generateCategoryId(),
      title: categoryName,
      restaurantId: _managerMenuViewModel.authenticatedManagerRestaurant!.id,
    );
    await _categoryService.createCategory(newCategory);
    await _managerMenuViewModel.reloadCategoriesAndMenuItems();

    setBusy(false);
  }

  Future<void> createItem(String itemName, String itemPrice,
      String itemDescription, String itemImageUrl) async {
    
    setBusy(true);


    MenuItem newMenuItem = MenuItem(
      id: _menuItemService.generateMenuItemId(),
      title: itemName,
      price: double.parse(itemPrice),
      imageUrl: itemImageUrl,
      description: itemDescription,
      rating: 5,
      categoryId: _itemCategoryId!,
      restaurantId: _managerMenuViewModel.authenticatedManagerRestaurant!.id,
    );
    await _menuItemService.createMenuItem(newMenuItem);
    await _managerMenuViewModel.reloadCategoriesAndMenuItems();


    
    setBusy(false);
  }
}
