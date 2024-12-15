// Import statements
import 'package:biteflow/models/category.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/manager_create_item_view_model.dart';
import 'package:biteflow/viewmodels/image_view_model.dart'; // Import ImageViewModel
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart'; // Import GetIt
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
  
  // Remove the image URL controller as we'll use ImageViewModel
  // final TextEditingController _itemImageUrlController = TextEditingController();

  // ImageViewModel instance
  late final ImageViewModel _imageViewModel;

  // Loading state for image uploading
  bool _isImageLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize ImageViewModel using GetIt
    _imageViewModel = GetIt.I<ImageViewModel>();
    _imageViewModel.addListener(_updateUI);
  }

  @override
  void dispose() {
    _imageViewModel.removeListener(_updateUI);
    _categoryNameController.dispose();
    _itemNameController.dispose();
    _itemPriceController.dispose();
    _itemDescriptionController.dispose();
    // _itemImageUrlController.dispose(); // No longer needed
    super.dispose();
  }

  void _updateUI() {
    if (mounted) setState(() {});
  }

  // Method to handle image picking
  Future<void> _pickImage() async {
    setState(() {
      _isImageLoading = true;
    });

    try {
      await _imageViewModel.pickAndUploadImage();

      if (!mounted) return;

      if (_imageViewModel.imageUrl != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImageLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerCreateItemViewModel>();
    return Container(
      height: 600, // Adjusted height to accommodate image picker
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
                      await viewModel.createCategory(_categoryNameController.text);
                      _categoryNameController.clear();
                      getIt<NavigationService>().pop(); // Close the bottom sheet
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
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: viewModel.itemCategoryId,
                hint: categoriesAvailable
                    ? const Text('Select a category')
                    : const Text('No categories available.'),
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
              ),
              const SizedBox(height: 16),
              // Item Name
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Item Price
              TextFormField(
                controller: _itemPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
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
              // Item Description
              TextFormField(
                controller: _itemDescriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Image Picker
              Text(
                'Item Image',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      if (_imageViewModel.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _imageViewModel.imageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 48),
                              SizedBox(height: 8),
                              Text('Tap to add image'),
                            ],
                          ),
                        ),
                      if (_imageViewModel.imageUrl != null)
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Change Image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      if (_isImageLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Save Item Button
              ElevatedButton(
                onPressed: viewModel.busy
                    ? null // disable the button if the view model is busy
                    : () async {
                        if (!itemFormKey.currentState!.validate()) {
                          // to validate the form
                          return;
                        }
                        if (_imageViewModel.imageUrl == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please add an image')),
                          );
                          return;
                        }
                        // create item
                        await viewModel.createItem(
                          _itemNameController.text,
                          _itemPriceController.text,
                          _itemDescriptionController.text,
                          _imageViewModel.imageUrl!,
                        );

                        // clear form fields
                        viewModel.itemCategoryId = null;
                        _itemNameController.clear();
                        _itemPriceController.clear();
                        _itemDescriptionController.clear();
                        // _itemImageUrlController.clear(); // No longer needed
                        _imageViewModel.resetImageUrl(); // Reset image URL

                        // close bottom sheet
                        getIt<NavigationService>().pop();
                        viewModel.isCreatingItem = true;
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
