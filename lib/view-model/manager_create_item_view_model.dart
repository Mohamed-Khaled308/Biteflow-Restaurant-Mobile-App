import 'package:biteflow/models/category.dart';
import 'package:biteflow/dummy_data/category_list.dart';
import 'package:biteflow/view-model/base_mode.dart';
import 'package:flutter/material.dart';



class ManagerCreateItemViewModel extends BaseModel {

  // to select between create item and create category
  bool _isCreatingItem = true; // Tracks which page to show

  // for create item
  List<Category> _categories = categoriesList; // should be fetched from db
  String? _itemCategoryId;
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemDescriptionController = TextEditingController();

  // for create category
  final TextEditingController _categoryNameController = TextEditingController();
  
  List<Category> get categories => _categories;
  String? get itemCategoryId => _itemCategoryId;
  TextEditingController get itemNameController => _itemNameController;
  TextEditingController get itemPriceController => _itemPriceController;
  TextEditingController get itemDescriptionController => _itemDescriptionController;
  TextEditingController get categoryNameController => _categoryNameController;
  bool get isCreatingItem => _isCreatingItem;
  set isCreatingItem(bool value) {
    _isCreatingItem = value;
    notifyListeners();
  }

  void updateItemCategory(String? categoryId) {
    _itemCategoryId = categoryId;
    notifyListeners();
  }

  void updateIsCreatingItem(bool isCreatingItem) {
    _isCreatingItem = isCreatingItem;
    notifyListeners();
  }

  void createCategory() { // should post to db using some service
    // Add the logic to create a new category here
    print('Creating category...');
    print('Category Name: ${_categoryNameController.text}');

    // after saving in db
    // reload categories list both here and in manager_menu_view_model
  }

  void createItem() { // should post to db using some service
    // Add the logic to create a new item here
    print('Creating item...');
    print('Item Name: ${_itemNameController.text}');
    print('Item Price: ${_itemPriceController.text}');
    print('Item Description: ${_itemDescriptionController.text}');
    print('Item Category: $_itemCategoryId');

    // after saving in db
    // reload items list in manager_menu_view_model
  }

  

}