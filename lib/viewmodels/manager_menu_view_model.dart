import 'package:biteflow/models/category.dart';
import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/models/restaurant.dart';
import 'package:biteflow/services/firestore/category_service.dart';
import 'package:biteflow/services/firestore/menu_item_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/manager.dart';
import 'package:biteflow/services/firestore/restaurant_service.dart';


class ManagerMenuViewModel extends BaseModel {

  // variables
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

  Future<void> reloadCategoriesAndMenuItems() async{
    // setBusy(true);

    await _fetchCategories();
    await _fetchMenuItems();
    if (_categories!.isNotEmpty) {
      selectCategory(_categories!.first.id); // this also calls getMenuItemsOfSelectedCategory
    }

    // setBusy(false);
  }

  Future<void> _fetchRestaurant() async{
    final restaurantResult =  await getIt<RestaurantService>().getRestaurantById(_authenticatedManager.restaurantId);
    if(restaurantResult.isSuccess){
      _authenticatedManagerRestaurant = restaurantResult.data;
    }
    else{
    }
  }

  Future<void> _fetchCategories() async{
    final categoriesData = await getIt<CategoryService>().getCategories(_authenticatedManager.restaurantId);
    if(categoriesData.isSuccess){
      _categories = categoriesData.data;
    }
    else{
      _categories = [];
    }
  }

  Future<void> _fetchMenuItems() async{
    final menuItemsData = await getIt<MenuItemService>().getMenuItems(_authenticatedManager.restaurantId);
    if(menuItemsData.isSuccess){
      _menuItems = menuItemsData.data;
    }
    else{
    }
  }


  // Tracks which page (create item or create category) to show
  bool _isCreatingItem = true;

  // for create item
  String? _itemCategoryId;

  // needed services and viewmodels
  // final ManagerMenuViewModel _managerMenuViewModel = getIt<ManagerMenuViewModel>();
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
      restaurantId: authenticatedManagerRestaurant!.id,
    );
    await _categoryService.createCategory(newCategory);
    await reloadCategoriesAndMenuItems();

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
      restaurantId: authenticatedManagerRestaurant!.id,
    );
    await _menuItemService.createMenuItem(newMenuItem);
    await reloadCategoriesAndMenuItems();


    
    setBusy(false);
  }




}
