import 'package:biteflow/viewmodels/image_view_model.dart';
import 'package:biteflow/viewmodels/manager_promotional_offers_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddPromotionalOfferScreen extends StatefulWidget {
  const AddPromotionalOfferScreen({super.key});

  @override
  State<AddPromotionalOfferScreen> createState() =>
      _AddPromotionalOfferScreenState();
}

class _AddPromotionalOfferScreenState extends State<AddPromotionalOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountController = TextEditingController();
  // final _imageService = getIt<ImageService>();

  late final ImageViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<ImageViewModel>();
    _viewModel.addListener(_updateUI);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    if (mounted) setState(() {});
  }

  Future<void> _pickImage() async {
    try {
      await _viewModel.pickAndUploadImage();

      if (!mounted) return;

      if (_viewModel.imageUrl != null) {
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
    }
  }

  DateTime? _startDate;
  DateTime? _endDate;
  // String? _imageUrl;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManagerPromotionalOffersViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Offer'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _viewModel.imageUrl != null
                            ? Image.network(_viewModel.imageUrl!,
                                fit: BoxFit.cover)
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate, size: 48),
                                    Text('Add Image'),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _discountController,
                      decoration: const InputDecoration(
                        labelText: 'Discount %',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        final number = double.tryParse(value!);
                        if (number == null) return 'Invalid number';
                        if (number <= 0 || number > 100) {
                          return 'Discount must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                            ),
                            controller: TextEditingController(
                              text: _startDate != null
                                  ? DateFormat('MMM dd, yyyy')
                                      .format(_startDate!)
                                  : '',
                            ),
                            onTap: () => _selectDate(true),
                            validator: (value) =>
                                _startDate == null ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(),
                            ),
                            controller: TextEditingController(
                              text: _endDate != null
                                  ? DateFormat('MMM dd, yyyy').format(_endDate!)
                                  : '',
                            ),
                            onTap: () => _selectDate(false),
                            validator: (value) =>
                                _endDate == null ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _submitForm(viewModel),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Create Offer'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submitForm(ManagerPromotionalOffersViewModel view) async {
    final viewModel = view;
    if (!_formKey.currentState!.validate()) return;
    if (_viewModel.imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await viewModel.createOffer(
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _viewModel.imageUrl!,
        startDate: _startDate!,
        endDate: _endDate!,
        discount: double.parse(_discountController.text),
      );

      // print(result.error);

      if (!mounted) return;

      if (result.error == null) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errorrr: ${result.error}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
