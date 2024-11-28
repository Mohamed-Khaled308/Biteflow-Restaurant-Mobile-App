import 'package:biteflow/models/category.dart';
import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/services/firestore/manager_menu_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';
import 'package:logger/logger.dart';


class ManagerMenuViewModel extends BaseModel {

  // variables
  final Logger _logger = getIt<Logger>();
  final Manager _authenticatedManager = getIt<UserProvider>().user as Manager;
  Restaurant? _authenticatedManagerRestaurant;
  List<Category>? _categories;
  List<MenuItem>? _menuItems;
  String? _selectedCategoryId;
  List<MenuItem>? _menuItemsOfSelectedCategory;


  // getters and setters
  Restaurant? get authenticatedManagerRestaurant => _authenticatedManagerRestaurant;
  List<Category>? get categories => _categories;
  List<MenuItem>? get menuItems => _menuItems;
  String? get selectedCategoryId => _selectedCategoryId;
  List<MenuItem>? get menuItemsOfSelectedCategory =>
      _menuItemsOfSelectedCategory;



  // state management methods
  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    getMenuItemsOfSelectedCategory();
    notifyListeners();
  }
  void getMenuItemsOfSelectedCategory() {
    if (_selectedCategoryId == null) {
      _menuItemsOfSelectedCategory = _menuItems;
    } else {
      _menuItemsOfSelectedCategory = _menuItems
          !.where((item) => item.categoryId == _selectedCategoryId)
          .toList();
    }
    notifyListeners();
  }

  // database related methods
  Future<void> loadRestaurantData() async{
    setBusy(true);

    await _fetchRestaurant();
    await _fetchCategories();
    await _fetchMenuItems();
    if (_categories!.isNotEmpty) {
      selectCategory(_categories!.first.id); // this also calls getMenuItemsOfSelectedCategory
    }

    setBusy(false);
  }

  Future<void> _fetchRestaurant() async{
    final restaurantResult =  await getIt<RestaurantService>().getRestaurantById(_authenticatedManager.restaurantId);
    if(restaurantResult.isSuccess){
      _authenticatedManagerRestaurant = restaurantResult.data;
    }
    else{
      _logger.e(restaurantResult.error);
    }
  }

  Future<void> _fetchCategories() async{
    final categoriesData = await getIt<ManagerMenuService>().getCategories(_authenticatedManager.restaurantId);
    if(categoriesData.isSuccess){
      _categories = categoriesData.data;
    }
    else{
      _logger.e(categoriesData.error);
    }
  }

  Future<void> _fetchMenuItems() async{
    final menuItemsData = await getIt<ManagerMenuService>().getMenuItems(_authenticatedManager.restaurantId);
    if(menuItemsData.isSuccess){
      _menuItems = menuItemsData.data;
    }
    else{
      _logger.e(menuItemsData.error);
    }
  }

}
