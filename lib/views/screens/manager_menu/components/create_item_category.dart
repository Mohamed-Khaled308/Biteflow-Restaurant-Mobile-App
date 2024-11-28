import 'package:biteflow/viewmodels/manager_create_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateItemCategory extends StatefulWidget {
  const CreateItemCategory({super.key});

  @override
  State<CreateItemCategory> createState() => _CreateItemCategoryState();
}

class _CreateItemCategoryState extends State<CreateItemCategory> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerCreateItemViewModel>();
    return Container(
      height: 400, // Constant height
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
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: viewModel.categoryNameController,
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
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  // to validate the form
                  return;
                }
                viewModel.createCategory(); // still problematic
                viewModel.clearCategoryFormFields();
                Navigator.pop(context);
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
    final formKey = GlobalKey<FormState>();
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: viewModel.itemCategoryId,
                hint: const Text('Select a category'),
                items: viewModel.categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.title),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  // The value is the id of the selected category
                  viewModel.updateItemCategory(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: viewModel.itemNameController,
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
                controller: viewModel.itemPriceController,
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
                controller: viewModel.itemDescriptionController,
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
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    // to validate the form
                    return;
                  }
                  viewModel.createItem();
                  viewModel.clearItemFormFields();
                  viewModel.isCreatingItem = true;
                  Navigator.pop(context); // Close the bottom sheet
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
