// import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/models/category.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/manager_create_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteflow/locator.dart';

class CreateItemCategory extends StatefulWidget {
  final List<Category>? categories;
  const CreateItemCategory({super.key, required this.categories});

  @override
  State<CreateItemCategory> createState() => _CreateItemCategoryState();
}

class _CreateItemCategoryState extends State<CreateItemCategory> {
  // category form
  final categoryFormKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();

  // item form
  final itemFormKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  final TextEditingController _itemImageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerCreateItemViewModel>();
    return Container(
      height: 500, // Constant height
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(viewModel),
          const SizedBox(height: 16),
          Expanded(
            child: viewModel.isCreatingItem
                ? _buildCreateItem(viewModel)
                : _buildCreateCategory(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ManagerCreateItemViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          viewModel.isCreatingItem ? 'Create New Item' : 'Create New Category',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(
            viewModel.isCreatingItem ? Icons.category : Icons.fastfood,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            // print('ana henaaa fi icon');
            viewModel.updateIsCreatingItem(!viewModel.isCreatingItem);
          },
        ),
      ],
    );
  }

  Widget _buildCreateCategory(ManagerCreateItemViewModel viewModel) {
    return Form(
      key: categoryFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _categoryNameController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a category name';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: viewModel.busy
                  ? null // disable the button if the view model is busy
                  : () async {
                      if (!categoryFormKey.currentState!.validate()) {
                        // to validate the form
                        return;
                      }
                      await viewModel
                          .createCategory(_categoryNameController.text);
                      _categoryNameController.clear();
                      getIt<NavigationService>()
                          .pop(); // Close the bottom sheet
                      viewModel.isCreatingItem = true;
                    },
              child: const Text('Save Category'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateItem(ManagerCreateItemViewModel viewModel) {
    bool categoriesAvailable =
        widget.categories != null && widget.categories!.isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: itemFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16), DropdownButtonFormField<String>(
                      value: viewModel.itemCategoryId,
                      hint: categoriesAvailable? const Text('Select a category') : const Text('No categories available.'),
                      items: widget.categories == null
                          ? []
                          : widget.categories!
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.title),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        // The value is the id of the selected category
                        viewModel.itemCategoryId = value;
                      },
                      decoration: const InputDecoration(
                        isDense: false,
                        
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (categoriesAvailable && value == null) {
                          return 'Please select a category';
                        }

                        if (!categoriesAvailable) {
                          return 'No categories available. Create one first.';
                        }
                        return null;
                      },
                    )
                  ,
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  // border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  // border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  // check if the value is a number
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemDescriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  // border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _itemImageUrlController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Image Url',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Url';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: viewModel.busy
                    ? null // disable the button if the view model is busy
                    : () async {
                        if (!itemFormKey.currentState!.validate()) {
                          // to validate the form
                          return;
                        }
                        // create item
                        await viewModel.createItem(
                            _itemNameController.text,
                            _itemPriceController.text,
                            _itemDescriptionController.text,
                            _itemImageUrlController.text);

                        // clear form fields
                        viewModel.itemCategoryId = null;
                        _itemNameController.clear();
                        _itemPriceController.clear();
                        _itemDescriptionController.clear();
                        _itemImageUrlController.clear();

                        // close bottome sheet
                        getIt<NavigationService>().pop();
                        viewModel.isCreatingItem = true;
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text('Save Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
