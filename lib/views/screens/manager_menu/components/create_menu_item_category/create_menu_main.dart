import 'package:biteflow/view-model/manager_create_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/locator.dart';

class CreateMenuMain extends StatefulWidget {
  const CreateMenuMain({super.key});

  @override
  State<CreateMenuMain> createState() => _CreateMenuMainState();
}

class _CreateMenuMainState extends State<CreateMenuMain> {
  final ManagerCreateItemViewModel _viewModel =
      getIt<ManagerCreateItemViewModel>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return Container(
            height: 400, // Constant height
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                Expanded(
                  child: _viewModel.isCreatingItem
                      ? _buildCreateItem()
                      : _buildCreateCategory(),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _viewModel.isCreatingItem ? 'Create New Item' : 'Create New Category',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(
            _viewModel.isCreatingItem ? Icons.category : Icons.fastfood,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            // print('ana henaaa fi icon');
            _viewModel.updateIsCreatingItem(!_viewModel.isCreatingItem);
          },
        ),
      ],
    );
  }

  Widget _buildCreateCategory() {
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _viewModel.categoryNameController,
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
                if (!_formKey.currentState!.validate()) { // to validate the form
                  return;
                }
                _viewModel.createCategory(); // still problematic
                _viewModel.clearCategoryFormFields();
                Navigator.pop(context);
                _viewModel.isCreatingItem = true;
              },
              child: const Text('Save Category'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateItem() {
    final _formKey = GlobalKey<FormState>();
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _viewModel.itemCategoryId,
                hint: const Text('Select a category'),
                items: _viewModel.categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.title),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  // The value is the id of the selected category
                  _viewModel.updateItemCategory(value);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if(value == null){
                    return 'Please select a category';
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _viewModel.itemNameController,
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
                controller: _viewModel.itemPriceController,
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
                controller: _viewModel.itemDescriptionController,
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
                  if (!_formKey.currentState!.validate()) { // to validate the form
                    return;
                  }
                  _viewModel.createItem();
                  _viewModel.clearItemFormFields();
                  _viewModel.isCreatingItem = true;
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
