import 'package:biteflow/models/category.dart';
import 'package:biteflow/dummy_data/category_list.dart';
import 'package:biteflow/view-model/base_mode.dart';
import 'package:flutter/material.dart';





class ManagerCreateItemViewModel extends BaseModel {
  List<Category> _categories = categoriesList; // should be fetched from db
  String? _itemCategoryId;
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemDescriptionController = TextEditingController();
  
  List<Category> get categories => _categories;
  String? get itemCategoryId => _itemCategoryId;
  TextEditingController get itemNameController => _itemNameController;
  TextEditingController get itemPriceController => _itemPriceController;
  TextEditingController get itemDescriptionController => _itemDescriptionController;

  void updateItemCategory(String? categoryId) {
    _itemCategoryId = categoryId;
  }

  void createItem() {
    // Add the logic to create a new item here
    print('Creating item...');
    print('Item Name: ${_itemNameController.text}');
    print('Item Price: ${_itemPriceController.text}');
    print('Item Description: ${_itemDescriptionController.text}');
    print('Item Category: $_itemCategoryId');
  }
  

}