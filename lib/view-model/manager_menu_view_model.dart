import 'package:biteflow/models/category.dart';
import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/view-model/base_mode.dart';
import 'package:biteflow/dummy_data/category_list.dart';
import 'package:biteflow/dummy_data/menu_item_list.dart';



class ManagerMenuViewModel extends BaseModel {
  // Add the necessary properties and methods here

  final String _restaurantName = 'Karam El Sham'; // to be fetched from db/auth
  final List<Category> _categories = categoriesList; // to be fetched from db
  final List<MenuItem> _menuItems = menuItemsList; // to be fetched from db
  String? _selectedCategoryId;
  List<MenuItem> _menuItemsOfSelectedCategory = [];

  String get restaurantName => _restaurantName;
  // add the necessary getters here
  List<Category> get categories => _categories;
  List<MenuItem> get menuItems => _menuItems;
  String? get selectedCategoryId => _selectedCategoryId;
  List<MenuItem> get menuItemsOfSelectedCategory => _menuItemsOfSelectedCategory;

  
  ManagerMenuViewModel(){
    if(_categories.isNotEmpty){
      selectCategory(_categories.first.id);
    }
  }

  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    print('ana hena $categoryId');
    // getMenuItemsOfSelectedCategory();
    notifyListeners();
  }

  void getMenuItemsOfSelectedCategory() {
    if(_selectedCategoryId == null){
      _menuItemsOfSelectedCategory = _menuItems;
    } 
    else{
      _menuItemsOfSelectedCategory = _menuItems.where(
        (item) => item.categoryId == _selectedCategoryId
      ).toList();
    }
    notifyListeners();
  }
}