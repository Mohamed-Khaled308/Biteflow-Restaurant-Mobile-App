// import 'package:biteflow/constants/theme_constants.dart';
import 'package:biteflow/view-model/manager_create_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:biteflow/locator.dart';

class CreateMenuItem extends StatefulWidget {
  const CreateMenuItem({super.key});

  @override
  State<CreateMenuItem> createState() => _CreateMenuItemState();
}

class _CreateMenuItemState extends State<CreateMenuItem> {

  final ManagerCreateItemViewModel _viewModel = getIt<ManagerCreateItemViewModel>();


  bool _isCreatingItem = true; // Tracks which page to show

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Constant height
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: _isCreatingItem ? _buildCreateItemPage() : _buildCreateCategoryPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _isCreatingItem ? 'Create New Item' : 'Create New Category',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(
            _isCreatingItem ? Icons.category : Icons.fastfood,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            setState(() {
              _isCreatingItem = !_isCreatingItem;
            });
          },
        ),
      ],
    );
  }
  
  Widget _buildCreateCategoryPage() {
    final TextEditingController _categoryNameController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _categoryNameController,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Implement your logic to add the category
            print('Category Name: ${_categoryNameController.text}');
            Navigator.pop(context); // Close the bottom sheet
          },
          child: const Text('Save Category'),
        ),
      ],
    );
  }

  Widget _buildCreateItemPage() {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context,_){
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: SingleChildScrollView(
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
                  onChanged: (value) { // The value is the id of the selected category
                    _viewModel.updateItemCategory(value);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _viewModel.itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    // border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _viewModel.itemPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    // border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _viewModel.itemDescriptionController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    // border: OutlineInputBorder(),
                  ),
                ),
                

                
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    
                    
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
        );
      }
    );
  }

}